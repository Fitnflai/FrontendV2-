import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/cached_http.dart'; // Our custom CachedHttp client
import '../../config/app_theme_extension.dart'; // Import for AppThemeExtension
import '../../widgets/bottom_nav.dart';
import '../../providers/auth_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/l10n_helpers.dart';

// ═══════════════════════════════════════════════════════════════
// DAILY CHECK-IN SCREEN
// ═══════════════════════════════════════════════════════════════
class DailyCheckinScreen extends StatefulWidget {
  const DailyCheckinScreen({super.key});
  @override
  State<DailyCheckinScreen> createState() => _DailyCheckinScreenState();
}

class _DailyCheckinScreenState extends State<DailyCheckinScreen> {
  // Respuestas
  int? _sleep;        // 0-4
  int? _energy;       // 0-4
  bool? _hasPain;
  String? _painZone;
  int? _timeIdx;      // 0-4
  int? _fcReposo;

  // Estado semáforo (null = en progreso)
  _Semaforo? _result;
  final TextEditingController _detallesDolorController = TextEditingController();
  bool _submitting = false; // New state variable
  Map<String, dynamic>? _apiResponse; // Store API response

  bool get _allAnswered =>
      _sleep != null && _energy != null &&
      _hasPain != null && _timeIdx != null &&
      _fcReposo != null;

  static const _bodyZones  = ['Cuello','Hombro','Espalda alta','Lumbar','Cadera','Rodilla','Tobillo','Otro'];


  Future<bool> _registerDailyState() async {
    if (_submitting) return false;
    setState(() => _submitting = true);
    final token = context.read<AuthProvider>().token ?? '';
    const base = 'https://apifitnflai.com';
    final themeColors = context.themeColors; 

    final List<int> timeInMinutesMap = [30, 45, 60, 90, 120];

    try {
      final res = await CachedHttp.post(
        Uri.parse('$base/users/registrar-estado'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "calidad_sueno":            _sleep! + 1, // Map 0-4 to 1-5
          "nivel_energia":            _energy! + 1, // Map 0-4 to 1-5
          "tiempo_disponible_minutos":  timeInMinutesMap[_timeIdx!],
          "dolor_o_molestia":         _hasPain!,
          "texto_dolor_o_molestia":   _hasPain! && _detallesDolorController.text.isNotEmpty
                                      ? _detallesDolorController.text : "",
          "zona_lesion":              _hasPain! && _painZone != null ? _painZone : "",
          "fc_reposo":                (_fcReposo ?? 0) * 4,
        }),
      );
      debugPrint('DAILY CHECKIN STATUS: ${res.statusCode}');
      debugPrint('DAILY CHECKIN BODY: ${res.body}');

      if (res.statusCode == 200 || res.statusCode == 201) {
        if (res.body.isNotEmpty) {
          try {
            final decoded = jsonDecode(res.body);
            if (decoded is Map<String, dynamic>) {
              _apiResponse = decoded;
            } else if (decoded is String) {
              final doubleDecoded = jsonDecode(decoded);
              if (doubleDecoded is Map<String, dynamic>) {
                _apiResponse = doubleDecoded;
              }
            }
          } catch (e) {
            debugPrint('DAILY CHECKIN PARSE ERROR: $e');
          }
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar( // No const here
            content: Text(AppLocalizations.of(context).dailyCheckinSaveSuccess),
            backgroundColor: themeColors.successBorder,
          ));
        }
        return true;
      } else {
        throw Exception('Error al registrar estado: ${res.statusCode}');
      }
    } catch (e) {
      debugPrint('DAILY CHECKIN ERROR: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar( // No const here
          content: Text(AppLocalizations.of(context).dailyCheckinSaveError(e.toString())),
          backgroundColor: themeColors.redMid,
        ));
      }
      return false;
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _compute() {
    final s = _sleep!;
    final e = _energy!;
    final p = _hasPain!;
    if (s <= 1 || e <= 1 || (p && _painZone != null)) {
      setState(() => _result = _Semaforo.red);
    } else if (s <= 2 || e <= 2 || p) {
      setState(() => _result = _Semaforo.yellow);
    } else {
      setState(() => _result = _Semaforo.green);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;
    return Scaffold(
      backgroundColor: theme.bg,
      body: SafeArea(
        child: Column(children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.arrow_back, color: theme.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Consumer<AuthProvider>(
                  builder: (context, auth, _) {
                    final user = auth.user;
                    final nombreUsuario = user?.apodo 
                        ?? (user?.nombre != null ? user!.nombre.split(' ').first : 'Campeón');
                    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(AppLocalizations.of(context).dailyCheckinGreeting(nombreUsuario),
                          style: TextStyle(color: theme.white,
                              fontSize: 16, fontWeight: FontWeight.w600)),
                      Text(AppLocalizations.of(context).dailyCheckinSubtitle,
                          style: TextStyle(color: theme.grey, fontSize: 11)),
                    ]);
                  }
                ),
              ),
            ]),
          ),
          Divider(color: theme.border, height: 20),

          Expanded(
            child: _result == null
                ? _buildQuestions(theme)
                : _buildResult(theme),
          ),
          const AppBottomNav(selectedIndex: 0),
        ]),
      ),
    );
  }

  // ── CUESTIONARIO ─────────────────────────────────────────────
  Widget _buildQuestions(AppThemeExtensionWrapper theme) {
    final answered = [_sleep, _energy, _hasPain, _timeIdx, _fcReposo]
        .where((v) => v != null).length;
    final sleepOpts = L10nHelpers.getSleepOptions(context);
    final energyOpts = L10nHelpers.getEnergyOptions(context);
    final timeOpts = L10nHelpers.getTimeOptions(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        // Subtítulo
        Text(
          AppLocalizations.of(context).dailyCheckinHeaderDesc,
          style: TextStyle(color: theme.grey, fontSize: 12, height: 1.5),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),

        // Progress dots
        Row(children: List.generate(5, (i) => Expanded(
          child: Container(
            margin: EdgeInsets.only(right: i < 4 ? 6 : 0),
            height: 4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(99),
              color: i < answered
                  ? theme.greenText
                  : i == answered
                      ? theme.orange
                      : theme.cardDark,
            ),
          ),
        ))),
        const SizedBox(height: 16),

        // P1 Sueño
        _QuestionCard(
          number: '1', label: AppLocalizations.of(context).dailyCheckinLabelSleep,
          question: AppLocalizations.of(context).dailyCheckinQuestionSleep,
          done: _sleep != null,
          child: Row(children: List.generate(5, (i) {
            final sel = _sleep == i;
            return Expanded(child: GestureDetector(
              onTap: () => setState(() => _sleep = i),
              child: _ScaleBtn(
                emoji: sleepOpts[i].$1,
                label: sel ? '${sleepOpts[i].$2} ✓' : sleepOpts[i].$2,
                selected: sel,
                activeColor: theme.greenText,
              ),
            ));
          })),
        ),
        const SizedBox(height: 10),

        // P2 Energía
        _QuestionCard(
          number: '2', label: AppLocalizations.of(context).dailyCheckinLabelEnergy,
          question: AppLocalizations.of(context).dailyCheckinQuestionEnergy,
          done: _energy != null,
          child: Row(children: List.generate(5, (i) {
            final sel = _energy == i;
            return Expanded(child: GestureDetector(
              onTap: () => setState(() => _energy = i),
              child: _ScaleBtn(
                emoji: energyOpts[i].$1,
                label: sel ? '${energyOpts[i].$2} ✓' : energyOpts[i].$2,
                selected: sel,
                activeColor: theme.orange,
              ),
            ));
          })),
        ),
        const SizedBox(height: 10),

        // P3 Dolor
        _QuestionCard(
          number: '3', label: AppLocalizations.of(context).dailyCheckinLabelPain,
          question: AppLocalizations.of(context).dailyCheckinQuestionPain,
          done: _hasPain != null,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: GestureDetector(
                onTap: () => setState(() { _hasPain = false; _painZone = null; }),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: _hasPain == false ? theme.greenBg : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _hasPain == false ? theme.greenText : theme.border),
                  ),
                  child: Center(child: Text(AppLocalizations.of(context).dailyCheckinPainNo,
                      style: TextStyle(
                          color: _hasPain == false ? theme.greenText : theme.grey,
                          fontSize: 13, fontWeight: FontWeight.w600))),
                ),
              )),
              const SizedBox(width: 8),
              Expanded(child: GestureDetector(
                onTap: () => setState(() => _hasPain = true),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: _hasPain == true
                        ? theme.redText.withValues(alpha: 0.12) : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _hasPain == true ? theme.redText : theme.border),
                  ),
                  child: Center(child: Text(AppLocalizations.of(context).dailyCheckinPainYes,
                      style: TextStyle(
                          color: _hasPain == true ? theme.redText : theme.grey,
                          fontSize: 13, fontWeight: FontWeight.w600))),
                ),
              )),
            ]),
            if (_hasPain == true) ...[
              const SizedBox(height: 10),
              Text(AppLocalizations.of(context).dailyCheckinPainWhere,
                  style: TextStyle(color: theme.grey, fontSize: 11)),
              const SizedBox(height: 6),
              Wrap(spacing: 6, runSpacing: 6,
                children: _bodyZones.map((z) {
                  final sel = _painZone == z;
                  return GestureDetector(
                    onTap: () => setState(() => _painZone = z),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: sel ? theme.redText.withValues(alpha: 0.12) : theme.cardDark,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: sel ? theme.redText : theme.border),
                      ),
                      child: Text(L10nHelpers.getPainZoneLabel(context, z),
                          style: TextStyle(
                              color: sel ? theme.redText : theme.grey,
                              fontSize: 11)),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _detallesDolorController,
                style: TextStyle(color: theme.white, fontSize: 13),
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context).dailyCheckinPainDetailsHint,
                  hintStyle: TextStyle(color: theme.grey),
                  filled: true,
                  fillColor: theme.cardDark,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
              ),
            ],
          ]),
        ),
        const SizedBox(height: 10),

        // P4 Tiempo
        _QuestionCard(
          number: '4', label: AppLocalizations.of(context).dailyCheckinLabelTime,
          question: AppLocalizations.of(context).dailyCheckinQuestionTime,
          done: _timeIdx != null,
          child: Row(children: List.generate(5, (i) {
            final sel = _timeIdx == i;
            return Expanded(child: GestureDetector(
              onTap: () => setState(() => _timeIdx = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                margin: EdgeInsets.only(right: i < 4 ? 5 : 0),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: sel ? theme.orange : theme.cardDark,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: sel ? theme.orange : theme.border),
                ),
                child: Column(children: [
                  Text(timeOpts[i].$1,
                      style: TextStyle(
                          color: sel ? Colors.white : theme.greyLight,
                          fontSize: 12, fontWeight: FontWeight.w600)),
                  Text(timeOpts[i].$2,
                      style: TextStyle(
                          color: sel ? Colors.white70 : theme.grey,
                          fontSize: 9)),
                ]),
              ),
            ));
          })),
        ),
        const SizedBox(height: 10),

        // P5 Pulsaciones
        _QuestionCard(
          number: '5',
          label: AppLocalizations.of(context).dailyCheckinLabelPulse,
          question: AppLocalizations.of(context).dailyCheckinQuestionPulse,
          done: _fcReposo != null,
          child: _PulseTimerCard(
            initialValue: _fcReposo,
            onPulseChanged: (v) => setState(() => _fcReposo = v),
          ),
        ),
        const SizedBox(height: 20),

        // CTA
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: (_allAnswered && !_submitting)
                ? () async {
                    final success = await _registerDailyState();
                    if (success) {
                      _compute();
                    }
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: _allAnswered ? theme.orange : theme.disabledBg,
              disabledBackgroundColor: theme.disabledBg,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: _submitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    _allAnswered
                        ? AppLocalizations.of(context).dailyCheckinBtnResult
                        : AppLocalizations.of(context).dailyCheckinBtnAnswerAll,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
          ),
        ),
        if (!_allAnswered) ...[
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context).dailyCheckinProgressStatus(
              [_sleep, _energy, _hasPain, _timeIdx, _fcReposo].where((v) => v != null).length,
              5,
            ),
            style: TextStyle(color: theme.grey, fontSize: 12),
          ),
        ],
        const SizedBox(height: 24),
      ]),
    );
  }

  // ── RESULTADO ────────────────────────────────────────────────
  Widget _buildResult(AppThemeExtensionWrapper theme) {
    final sleepOpts = L10nHelpers.getSleepOptions(context);
    final energyOpts = L10nHelpers.getEnergyOptions(context);
    final timeOpts = L10nHelpers.getTimeOptions(context);

    final bool debeAjustar = _apiResponse?['debe_ajustar'] ?? false;
    final String? razon = _apiResponse?['razon'] as String?;
    final String? tipoAjuste = _apiResponse?['tipo_ajuste'] as String?;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        // Score row
        Row(children: [
          _ScoreItem(emoji: sleepOpts[_sleep!].$1,
              value: '${_sleep!+1}/5',
              label: AppLocalizations.of(context).dailyCheckinScoreSleep,
              color: _scoreColor(_sleep!, theme)),
          const SizedBox(width: 8),
          _ScoreItem(emoji: energyOpts[_energy!].$1,
              value: '${_energy!+1}/5',
              label: AppLocalizations.of(context).dailyCheckinScoreEnergy,
              color: _scoreColor(_energy!, theme)),
          const SizedBox(width: 8),
          _ScoreItem(
              emoji: _hasPain! ? '⚠️' : '✅',
              value: _hasPain!
                  ? L10nHelpers.getPainZoneLabel(context, _painZone ?? 'Leve')
                  : AppLocalizations.of(context).dailyCheckinPainValueNo,
              label: AppLocalizations.of(context).dailyCheckinScorePain,
              color: _hasPain! ? const Color(0xFFEF9F27) : theme.greenText),
          const SizedBox(width: 8),
          _ScoreItem(emoji: '⏱️',
              value: timeOpts[_timeIdx!].$1,
              label: AppLocalizations.of(context).dailyCheckinScoreTime,
              color: theme.orange),
          const SizedBox(width: 8),
          _ScoreItem(emoji: '❤️',
              value: '${_fcReposo != null ? _fcReposo! * 4 : 0}',
              label: AppLocalizations.of(context).dailyCheckinScorePulse,
              color: theme.orange),
        ]),
        const SizedBox(height: 16),

        // Semáforo card
        _SemaforoCard(
          semaforo: _result!,
          debeAjustar: debeAjustar,
          tipoAjuste: tipoAjuste,
          razonAjuste: razon,
        ),
        const SizedBox(height: 12),

        // Sesión card
        _SessionCard(
          semaforo: _result!,
          debeAjustar: debeAjustar,
          tipoAjuste: tipoAjuste,
          razonAjuste: razon,
        ),
        const SizedBox(height: 12),

        // Pain alert if needed
        if (_hasPain == true)
          _PainAlert(
              zone: _painZone ?? 'zona no especificada',
              isUrgent: _result == _Semaforo.red),
        const SizedBox(height: 12),

        // IA insight
        _AIInsight(
          semaforo: _result!,
          apiReason: razon,
        ),
        const SizedBox(height: 20),

        // CTA buttons
        SizedBox(
          width: double.infinity, height: 50,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _result == _Semaforo.green
                  ? theme.orange
                  : _result == _Semaforo.yellow
                      ? const Color(0xFFEF9F27)
                      : const Color(0xFF378ADD),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: Text(
              _result == _Semaforo.green
                  ? AppLocalizations.of(context).dailyCheckinCtaGreen
                  : _result == _Semaforo.yellow
                      ? AppLocalizations.of(context).dailyCheckinCtaYellow
                      : AppLocalizations.of(context).dailyCheckinCtaRed,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity, height: 44,
          child: OutlinedButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.grey,
              side: BorderSide(color: theme.border),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              _result == _Semaforo.red
                  ? AppLocalizations.of(context).dailyCheckinCtaRestRed
                  : AppLocalizations.of(context).dailyCheckinCtaRestNormal,
              style: const TextStyle(fontSize: 13)),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          AppLocalizations.of(context).dailyCheckinCtaBottomNote,
          style: TextStyle(color: theme.grey, fontSize: 11),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
      ]),
    );
  }

  Color _scoreColor(int v, AppThemeExtensionWrapper theme) {
    if (v >= 3) return theme.greenText;
    if (v == 2) return const Color(0xFFEF9F27);
    return theme.redText;
  }
}

// ═══════════════════════════════════════════════════════════════
// SEMAFORO ENUM
// ═══════════════════════════════════════════════════════════════
enum _Semaforo { green, yellow, red }

// ═══════════════════════════════════════════════════════════════
// QUESTION CARD
// ═══════════════════════════════════════════════════════════════
class _QuestionCard extends StatelessWidget {
  final String number, label, question;
  final bool done;
  final Widget child;
  const _QuestionCard({
    required this.number, required this.label,
    required this.question, required this.done, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;
    return Opacity(
      opacity: 1.0,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: theme.card,
          borderRadius: BorderRadius.circular(14),
          border: done ? Border.all(color: theme.successBorder) : null,
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            if (done)
              Text('✓ ', style: TextStyle(color: theme.greenText, fontSize: 11)),
            Text(AppLocalizations.of(context).dailyCheckinQuestionLabel(int.tryParse(number) ?? 0, label),
                style: TextStyle(
                    color: done ? theme.greenText : theme.orange,
                    fontSize: 11, fontWeight: FontWeight.w600,
                    letterSpacing: 0.5)),
          ]),
          const SizedBox(height: 6),
          Text(question,
              style: TextStyle(color: theme.white,
                  fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          child,
        ]),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// SCALE BUTTON
// ═══════════════════════════════════════════════════════════════
class _ScaleBtn extends StatelessWidget {
  final String emoji, label;
  final bool selected;
  final Color activeColor;
  const _ScaleBtn({required this.emoji, required this.label,
      required this.selected, required this.activeColor});

  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
      decoration: BoxDecoration(
        color: selected ? activeColor.withValues(alpha: 0.15) : theme.cardDark,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: selected ? activeColor : theme.border,
          width: selected ? 1.5 : 1,
        ),
      ),
      child: Column(children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 3),
        Text(label, textAlign: TextAlign.center,
            style: TextStyle(
                color: selected ? activeColor : theme.grey,
                fontSize: 8,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                height: 1.2)),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// SCORE ITEM
// ═══════════════════════════════════════════════════════════════
class _ScoreItem extends StatelessWidget {
  final String emoji, value, label;
  final Color color;
  const _ScoreItem({required this.emoji, required this.value,
      required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          color: theme.card,
          borderRadius: BorderRadius.circular(10),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(children: [
            Text(emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(color: color,
                fontSize: 14, fontWeight: FontWeight.w700)),
            Text(label, style: TextStyle(color: theme.grey, fontSize: 9)),
          ]),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// SEMÁFORO CARD
// ═══════════════════════════════════════════════════════════════
class _SemaforoCard extends StatelessWidget {
  final _Semaforo semaforo;
  final bool? debeAjustar;
  final String? tipoAjuste;
  final String? razonAjuste;

  const _SemaforoCard({
    required this.semaforo,
    this.debeAjustar,
    this.tipoAjuste,
    this.razonAjuste,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;
    final l10n = AppLocalizations.of(context);

    var currentSemaforo = semaforo;
    if (debeAjustar == true && currentSemaforo == _Semaforo.green) {
      currentSemaforo = _Semaforo.yellow;
    }

    final isGreen  = currentSemaforo == _Semaforo.green;
    final isYellow = currentSemaforo == _Semaforo.yellow;
    final color = isGreen
        ? theme.greenText
        : isYellow ? const Color(0xFFEF9F27) : theme.redText;
    final bg = isGreen
        ? theme.greenBg
        : isYellow
            ? theme.orange.withValues(alpha: 0.12)
            : theme.redText.withValues(alpha: 0.10);
    final emoji = isGreen ? '🟢' : isYellow ? '🟡' : '🔴';
    
    final title = (debeAjustar == true && tipoAjuste != null)
        ? "${l10n.dailyCheckinSemaforoYellowTitle} · $tipoAjuste"
        : (isGreen
            ? l10n.dailyCheckinSemaforoGreenTitle
            : isYellow
                ? l10n.dailyCheckinSemaforoYellowTitle
                : l10n.dailyCheckinSemaforoRedTitle);
                
    final sub = (debeAjustar == true && razonAjuste != null)
        ? razonAjuste!
        : (isGreen
            ? l10n.dailyCheckinSemaforoGreenDesc
            : isYellow
                ? l10n.dailyCheckinSemaforoYellowDesc
                : l10n.dailyCheckinSemaforoRedDesc);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 2),
      ),
      child: Column(children: [
        Text(emoji, style: const TextStyle(fontSize: 40)),
        const SizedBox(height: 8),
        Text(title, textAlign: TextAlign.center,
            style: TextStyle(color: color,
                fontSize: 15, fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Text(sub, textAlign: TextAlign.center,
            style: TextStyle(color: theme.grey, fontSize: 12, height: 1.5)),
        if (isGreen) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: theme.greenText.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(l10n.dailyCheckinSemaforoGreenBadge,
                style: TextStyle(color: theme.greenText,
                    fontSize: 11, fontWeight: FontWeight.w600)),
          ),
        ],
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// SESSION CARD
// ═══════════════════════════════════════════════════════════════
// ═══════════════════════════════════════════════════════════════
// SESSION CARD
// ═══════════════════════════════════════════════════════════════
class _SessionCard extends StatelessWidget {
  final _Semaforo semaforo;
  final bool? debeAjustar;
  final String? tipoAjuste;
  final String? razonAjuste;

  const _SessionCard({
    required this.semaforo,
    this.debeAjustar,
    this.tipoAjuste,
    this.razonAjuste,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;
    final l10n = AppLocalizations.of(context);

    var currentSemaforo = semaforo;
    if (debeAjustar == true && currentSemaforo == _Semaforo.green) {
      currentSemaforo = _Semaforo.yellow;
    }

    final isGreen  = currentSemaforo == _Semaforo.green;
    final isYellow = currentSemaforo == _Semaforo.yellow;
    final borderColor = isGreen
        ? theme.greenText
        : isYellow ? const Color(0xFFEF9F27) : const Color(0xFF378ADD);
    final badgeColor = isGreen
        ? theme.greenText
        : isYellow ? const Color(0xFFEF9F27) : const Color(0xFF378ADD);
    final badgeBg = isGreen
        ? theme.greenBg
        : isYellow
            ? theme.orange.withValues(alpha: 0.12)
            : const Color(0xFF378ADD).withValues(alpha: 0.12);
    final badgeLabel = (debeAjustar == true)
        ? (currentSemaforo == _Semaforo.red ? l10n.dailyCheckinSemaforoRedBadge : l10n.dailyCheckinSemaforoYellowBadge)
        : (isGreen
            ? l10n.dailyCheckinSemaforoGreenBadge
            : isYellow
                ? l10n.dailyCheckinSemaforoYellowBadge
                : l10n.dailyCheckinSemaforoRedBadge);

    final title = (debeAjustar == true && tipoAjuste != null)
        ? tipoAjuste!
        : (isGreen
            ? l10n.dailyCheckinSessionTitleGreen
            : isYellow
                ? l10n.dailyCheckinSessionTitleYellow
                : l10n.dailyCheckinSessionTitleRed);

    final subtitle = (debeAjustar == true && razonAjuste != null)
        ? razonAjuste!
        : (isGreen
            ? l10n.dailyCheckinSessionSubGreen
            : isYellow
                ? l10n.dailyCheckinSessionSubYellow
                : l10n.dailyCheckinSessionSubRed);
    final duracion = isGreen ? '50 min'
        : isYellow ? '35 min' : '20 min';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(14),
        border: Border(left: BorderSide(color: borderColor, width: 3)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(
                  color: theme.white, fontSize: 14,
                  fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(subtitle, style: TextStyle(
                  color: theme.grey, fontSize: 11)),
            ],
          )),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: badgeBg, borderRadius: BorderRadius.circular(20)),
            child: Text(badgeLabel, style: TextStyle(
                color: badgeColor, fontSize: 10, fontWeight: FontWeight.w600)),
          ),
        ]),
        const SizedBox(height: 10),
        Row(children: [
          _SessionDetail('⏱', duracion),
          const SizedBox(width: 12),
          if (!isGreen)
            _SessionDetail(
              '📉',
              isYellow ? l10n.dailyCheckinSessionReducePct : l10n.dailyCheckinSessionNoFc,
            ),
        ]),
        if (debeAjustar == true && tipoAjuste != null) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.cardDark,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(l10n.dailyCheckinSessionChangeTitle,
                  style: const TextStyle(color: Color(0xFFEF9F27),
                      fontSize: 10, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(
                tipoAjuste!,
                style: TextStyle(color: theme.grey, fontSize: 11, height: 1.4)),
            ]),
          ),
        ] else if (isYellow) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.cardDark,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(l10n.dailyCheckinSessionChangeTitle,
                  style: const TextStyle(color: Color(0xFFEF9F27),
                      fontSize: 10, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(
                l10n.dailyCheckinSessionChangeDesc,
                style: TextStyle(color: theme.grey, fontSize: 11, height: 1.4)),
            ]),
          ),
        ],
      ]),
    );
  }
}

class _SessionDetail extends StatelessWidget {
  final String icon, text;
  const _SessionDetail(this.icon, this.text);
  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;
    return Row(children: [
      Text(icon, style: const TextStyle(fontSize: 12)),
      const SizedBox(width: 4),
      Text(text, style: TextStyle(color: theme.grey, fontSize: 11)),
    ]);
  }
}

// ═══════════════════════════════════════════════════════════════
// PAIN ALERT
// ═══════════════════════════════════════════════════════════════
class _PainAlert extends StatelessWidget {
  final String zone;
  final bool isUrgent;
  const _PainAlert({required this.zone, required this.isUrgent});

  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;
    final l10n = AppLocalizations.of(context);
    final localizedZone = L10nHelpers.getPainZoneLabel(context, zone);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.redText.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.redText.withValues(alpha: 0.3),
          width: isUrgent ? 2 : 1,
        ),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(isUrgent ? Icons.warning_amber : Icons.info_outline,
              color: theme.redText, size: 14),
          const SizedBox(width: 6),
          Text(
            isUrgent
                ? l10n.dailyCheckinPainAlertUrgent
                : l10n.dailyCheckinPainAlertNormal(localizedZone),
            style: TextStyle(color: theme.redText,
                fontSize: 12, fontWeight: FontWeight.w600)),
        ]),
        const SizedBox(height: 6),
        Text(
          isUrgent
              ? l10n.dailyCheckinPainAlertUrgentDesc
              : l10n.dailyCheckinPainAlertNormalDesc,
          style: TextStyle(color: theme.grey, fontSize: 11, height: 1.4)),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// AI INSIGHT
// ═══════════════════════════════════════════════════════════════
class _AIInsight extends StatelessWidget {
  final _Semaforo semaforo;
  final String? apiReason;
  const _AIInsight({required this.semaforo, this.apiReason});

  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;
    final l10n = AppLocalizations.of(context);
    final text = apiReason ?? (semaforo == _Semaforo.green
        ? l10n.dailyCheckinInsightGreen
        : semaforo == _Semaforo.yellow
            ? l10n.dailyCheckinInsightYellow
            : l10n.dailyCheckinInsightRed);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.orange.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.orange.withValues(alpha: 0.25)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Text('✨', style: TextStyle(fontSize: 14)),
          const SizedBox(width: 6),
          Text(l10n.dailyCheckinInsightTitle,
              style: TextStyle(color: theme.orange,
                  fontSize: 12, fontWeight: FontWeight.w600)),
        ]),
        const SizedBox(height: 8),
        Text(text, style: TextStyle(color: theme.grey, fontSize: 12, height: 1.5)),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// PULSE TIMER CARD (Question 5 child)
// ═══════════════════════════════════════════════════════════════
class _PulseTimerCard extends StatefulWidget {
  final int? initialValue;
  final ValueChanged<int?> onPulseChanged;

  const _PulseTimerCard({
    required this.initialValue,
    required this.onPulseChanged,
  });

  @override
  State<_PulseTimerCard> createState() => _PulseTimerCardState();
}

class _PulseTimerCardState extends State<_PulseTimerCard>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  int _secondsRemaining = 15;
  bool _isRunning = false;
  late AnimationController _heartController;
  final TextEditingController _pulseController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    if (widget.initialValue != null) {
      _pulseController.text = widget.initialValue.toString();
    }
    _pulseController.addListener(_onInputChanged);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _heartController.dispose();
    _pulseController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onInputChanged() {
    final text = _pulseController.text.trim();
    if (text.isEmpty) {
      widget.onPulseChanged(null);
    } else {
      final val = int.tryParse(text);
      widget.onPulseChanged(val);
    }
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
    });
    _heartController.repeat(reverse: true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 1) {
          _secondsRemaining--;
        } else {
          _secondsRemaining = 0;
          _isRunning = false;
          _timer?.cancel();
          _heartController.stop();
          _focusNode.requestFocus(); // Auto focus input once countdown finishes!
        }
      });
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    _heartController.stop();
    setState(() {
      _isRunning = false;
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    _heartController.stop();
    setState(() {
      _isRunning = false;
      _secondsRemaining = 15;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;
    final l10n = AppLocalizations.of(context);

    // Calc BPM
    final pulseText = _pulseController.text.trim();
    final pulseVal = int.tryParse(pulseText);
    final calculatedBpm = pulseVal != null ? pulseVal * 4 : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Countdown section
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.cardDark,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: theme.border),
          ),
          child: Row(
            children: [
              // Heart icon + Timer
              ScaleTransition(
                scale: Tween<double>(begin: 1.0, end: 1.15).animate(
                  CurvedAnimation(parent: _heartController, curve: Curves.easeInOut),
                ),
                child: Icon(
                  Icons.favorite,
                  color: _isRunning ? theme.redText : theme.grey,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '00:${_secondsRemaining.toString().padLeft(2, '0')}',
                style: TextStyle(
                  color: theme.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              const Spacer(),
              // Control buttons
              if (!_isRunning && _secondsRemaining == 15)
                ElevatedButton.icon(
                  onPressed: _startTimer,
                  icon: const Icon(Icons.play_arrow, size: 16),
                  label: const Text('Empezar', style: TextStyle(fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                )
              else if (_isRunning)
                ElevatedButton.icon(
                  onPressed: _pauseTimer,
                  icon: const Icon(Icons.pause, size: 16),
                  label: const Text('Pausar', style: TextStyle(fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.orange.withValues(alpha: 0.2),
                    foregroundColor: theme.orange,
                    side: BorderSide(color: theme.orange),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                )
              else ...[
                OutlinedButton(
                  onPressed: _resetTimer,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.grey,
                    side: BorderSide(color: theme.border),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Reiniciar', style: TextStyle(fontSize: 11)),
                ),
                if (_secondsRemaining > 0) ...[
                  const SizedBox(width: 6),
                  ElevatedButton(
                    onPressed: _startTimer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Reanudar', style: TextStyle(fontSize: 11)),
                  ),
                ],
              ],
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Input Field
        TextField(
          controller: _pulseController,
          focusNode: _focusNode,
          keyboardType: TextInputType.number,
          style: TextStyle(color: theme.white, fontSize: 14, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            hintText: l10n.dailyCheckinPulseHint,
            hintStyle: TextStyle(color: theme.grey),
            suffixText: 'pulsaciones en 15s',
            suffixStyle: TextStyle(color: theme.orange, fontSize: 11, fontWeight: FontWeight.w500),
            filled: true,
            fillColor: theme.cardDark,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),

        // Real-time calculation feedback
        if (calculatedBpm != null) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.check_circle_outline, color: theme.greenText, size: 14),
              const SizedBox(width: 6),
              Text(
                l10n.dailyCheckinPulseCalculated(calculatedBpm.toString()),
                style: TextStyle(color: theme.greenText, fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ],
    );
  }
}