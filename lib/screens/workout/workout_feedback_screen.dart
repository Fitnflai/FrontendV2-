import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme_extension.dart';
import '../../providers/auth_provider.dart';
import '../../services/cached_http.dart';
import '../../l10n/app_localizations.dart';

// ═══════════════════════════════════════════════════════════════
// WORKOUT FEEDBACK SCREEN
// ═══════════════════════════════════════════════════════════════
class WorkoutFeedbackScreen extends StatefulWidget {
  final Map<String, dynamic>? entrenamiento;
  final int    tiempoSecs;
  final double distanciaKm;
  final bool   isExterior;

  const WorkoutFeedbackScreen({
    super.key,
    this.entrenamiento,
    required this.tiempoSecs,
    required this.distanciaKm,
    required this.isExterior,
  });

  @override
  State<WorkoutFeedbackScreen> createState() => _WorkoutFeedbackScreenState();
}

class _WorkoutFeedbackScreenState extends State<WorkoutFeedbackScreen> {
  // RPE 1–10
  int _rpe = 5;

  // ¿Completaste la rutina?
  bool? _completed;

  // Sensación
  int _feelingIdx = 2;
  static const _feelings = [
    ('😰', 'Muy cansado'),
    ('😓', 'Cansado'),
    ('😮', 'Bien'),
    ('😄', 'Sobrado'),
  ];

  // Dolor
  bool? _hadPain;
  final _painCtrl = TextEditingController();

  // Notas
  final _notesCtrl = TextEditingController();

  bool _submitting = false;

  @override
  void dispose() {
    _painCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  bool get _canSave => _completed != null && _hadPain != null;

  String _formatTime(int s) {
    final h = s ~/ 3600;
    final m = (s % 3600) ~/ 60;
    final sec = s % 60;
    if (h > 0) return '${h}h ${m}m ${sec}s';
    return '${m}m ${sec}s';
  }

  Future<void> _submit() async {
    setState(() => _submitting = true);
    try {
      final token = context.read<AuthProvider>().token ?? '';
      final id = widget.entrenamiento?['id_entrenamiento']
               ?? widget.entrenamiento?['id'];

      if (id != null) {
        // Petición original de feedback
        await CachedHttp.post(
          Uri.parse('https://apifitnflai.com/entrenamientos/$id/feedback'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'completado':     _completed,
            'esfuerzo_rpe':   _rpe,
            'sensacion':      '${_feelings[_feelingIdx].$1} ${_feelings[_feelingIdx].$2}',
            'dolor_molestia': _hadPain,
            'descripcion_dolor': _hadPain == true
                ? _painCtrl.text.trim()
                : null,
            'comentarios':    _notesCtrl.text.trim().isEmpty
                ? null
                : _notesCtrl.text.trim(),
            'tiempo_segundos':  widget.tiempoSecs,
            'distancia_km':     widget.isExterior ? widget.distanciaKm : null,
          }),
        );

        // Nueva petición para completar el entrenamiento
        await CachedHttp.post(
          Uri.parse('https://apifitnflai.com/entrenamientos/completar/$id'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'ejecucion_routine_completa': _completed ?? false,
            'esfuerzo_percibido':        _rpe,
            'como_te_sentiste':          _feelings[_feelingIdx].$2,
            'dolor_o_molestia':          _hadPain ?? false,
            'texto_dolor_o_molestia':    (_hadPain == true) ? _painCtrl.text.trim() : "",
            'notas_adicionales':         _notesCtrl.text.trim(),
          }),
        );
      }
    } catch (e) {
      debugPrint('WORKOUT FEEDBACK ERROR: $e');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }

    if (!mounted) return;
    // Volver al home (pop hasta la raíz de este flujo)
    Navigator.of(context).popUntil((r) => r.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;
    return Scaffold(
      backgroundColor: theme.bg,
      body: SafeArea(
        child: Column(children: [
          // Top bar
          _buildTopBar(theme),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(children: [
                const SizedBox(height: 8),
                _buildSummaryCard(theme),
                const SizedBox(height: 16),
                _buildCompletionCard(theme),
                const SizedBox(height: 14),
                _buildRPECard(theme),
                const SizedBox(height: 14),
                _buildFeelingCard(theme),
                const SizedBox(height: 14),
                _buildPainCard(theme),
                const SizedBox(height: 14),
                _buildNotesCard(theme),
                const SizedBox(height: 24),
              ]),
            ),
          ),

          // Save button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: Column(children: [
              SizedBox(
                width: double.infinity, height: 54,
                child: ElevatedButton(
                  onPressed: (_canSave && !_submitting) ? _submit : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _canSave
                        ? theme.orange : theme.disabledBg,
                    disabledBackgroundColor: theme.disabledBg,
                    foregroundColor: Colors.white,
                    disabledForegroundColor: theme.grey,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: _submitting
                      ? const SizedBox(width: 22, height: 22,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : Text(AppLocalizations.of(context).workoutFeedbackSaveFinish,
                          style: const TextStyle(fontSize: 16,
                              fontWeight: FontWeight.w700)),
                ),
              ),
              if (!_canSave) ...[
                const SizedBox(height: 8),
                Text(AppLocalizations.of(context).workoutFeedbackAnswerAll,
                    style: TextStyle(color: theme.grey, fontSize: 12)),
              ],
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _buildTopBar(AppThemeExtensionWrapper theme) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
    child: Row(children: [
      GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.card,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: theme.border),
          ),
          child: Icon(Icons.arrow_back_ios_new,
              color: theme.white, size: 16),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Text(AppLocalizations.of(context).workoutFeedbackQuestion,
            style: TextStyle(
                color: theme.white, fontSize: 16,
                fontWeight: FontWeight.w700)),
      ),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: theme.orange.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.orange),
        ),
        child: Text('FEEDBACK',
            style: TextStyle(
                color: theme.orange, fontSize: 10,
                fontWeight: FontWeight.w700, letterSpacing: 0.5)),
      ),
    ]),
  );

  Widget _buildSummaryCard(AppThemeExtensionWrapper theme) {
    final titulo = widget.entrenamiento?['titulo_entrenamiento']
                ?? widget.entrenamiento?['titulo'] ?? AppLocalizations.of(context).workoutDetailTitle;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.border),
      ),
      child: Column(children: [
        const Text('🏁', style: TextStyle(fontSize: 36)),
        const SizedBox(height: 8),
        Text(AppLocalizations.of(context).workoutFeedbackFinished,
            style: TextStyle(
                color: theme.greenText, fontSize: 18,
                fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        Text(titulo,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: theme.greyLight, fontSize: 14)),
        const SizedBox(height: 16),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          _StatChip(label: AppLocalizations.of(context).workoutFeedbackTime, value: _formatTime(widget.tiempoSecs)),
          if (widget.isExterior)
            _StatChip(
              label: AppLocalizations.of(context).workoutFeedbackDistance,
              value: '${widget.distanciaKm.toStringAsFixed(2)} km',
            ),
          _StatChip(
            label: AppLocalizations.of(context).workoutFeedbackMode,
            value: widget.isExterior ? AppLocalizations.of(context).workoutFeedbackOutdoor : AppLocalizations.of(context).workoutFeedbackIndoor,
          ),
        ]),
      ]),
    );
  }

  Widget _buildCompletionCard(AppThemeExtensionWrapper theme) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
        color: theme.card, borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.border)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(AppLocalizations.of(context).workoutFeedbackDidComplete,
          style: TextStyle(
              color: theme.orange, fontSize: 14,
              fontWeight: FontWeight.w700)),
      const SizedBox(height: 12),
      Row(children: [
        Expanded(child: _ChoiceBtn(
          label: AppLocalizations.of(context).workoutFeedbackYesComplete,
          selected: _completed == true,
          activeColor: theme.greenText,
          activeBg: theme.greenBg,
          activeBorder: theme.successBorder,
          onTap: () => setState(() => _completed = true),
        )),
        const SizedBox(width: 10),
        Expanded(child: _ChoiceBtn(
          label: AppLocalizations.of(context).workoutFeedbackPartially,
          selected: _completed == false,
          activeColor: theme.orange,
          activeBg: theme.orange.withValues(alpha: 0.15),
          activeBorder: theme.orange,
          onTap: () => setState(() => _completed = false),
        )),
      ]),
    ]),
  );

  Widget _buildRPECard(AppThemeExtensionWrapper theme) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
        color: theme.card, borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.border)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Text(AppLocalizations.of(context).workoutFeedbackRpeQuestion,
            style: TextStyle(
                color: theme.orange, fontSize: 14,
                fontWeight: FontWeight.w700)),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: _rpeColor(_rpe, theme).withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text('$_rpe / 10',
              style: TextStyle(
                  color: _rpeColor(_rpe, theme), fontSize: 14,
                  fontWeight: FontWeight.w800)),
        ),
      ]),
      Text(_rpeLabel(context, _rpe),
          style: TextStyle(color: _rpeColor(_rpe, theme), fontSize: 12)),
      const SizedBox(height: 12),
      SliderTheme(
        data: SliderTheme.of(context).copyWith(
          activeTrackColor: _rpeColor(_rpe, theme),
          inactiveTrackColor: theme.cardDark,
          thumbColor: _rpeColor(_rpe, theme),
          overlayColor: _rpeColor(_rpe, theme).withValues(alpha: 0.15),
          trackHeight: 6,
        ),
        child: Slider(
          value: _rpe.toDouble(),
          min: 1, max: 10,
          divisions: 9,
          onChanged: (v) => setState(() => _rpe = v.round()),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(AppLocalizations.of(context).workoutFeedbackEasy, style: TextStyle(color: theme.grey, fontSize: 10)),
          Text(AppLocalizations.of(context).workoutFeedbackMax, style: TextStyle(color: theme.grey, fontSize: 10)),
        ],
      ),
    ]),
  );

  Widget _buildFeelingCard(AppThemeExtensionWrapper theme) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
        color: theme.card, borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.border)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(AppLocalizations.of(context).workoutFeedbackFeelingQuestion,
          style: TextStyle(
              color: theme.orange, fontSize: 14,
              fontWeight: FontWeight.w700)),
      const SizedBox(height: 12),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(_feelings.length, (i) {
          final selected = i == _feelingIdx;
          return GestureDetector(
            onTap: () => setState(() => _feelingIdx = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 56,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: selected
                    ? theme.orange.withValues(alpha: 0.15)
                    : theme.cardDark,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selected ? theme.orange : theme.border,
                  width: selected ? 1.5 : 1,
                ),
              ),
              child: Column(children: [
                Text(_feelings[i].$1,
                    style: const TextStyle(fontSize: 22)),
                const SizedBox(height: 4),
                Text(_getFeelingText(context, i),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: selected
                            ? theme.orange : theme.grey,
                        fontSize: 9,
                        fontWeight: FontWeight.w600)),
              ]),
            ),
          );
        }),
      ),
    ]),
  );

  Widget _buildPainCard(AppThemeExtensionWrapper theme) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
        color: theme.card, borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.border)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(AppLocalizations.of(context).workoutFeedbackPainQuestion,
          style: TextStyle(
              color: theme.orange, fontSize: 14,
              fontWeight: FontWeight.w700)),
      const SizedBox(height: 12),
      Row(children: [
        Expanded(child: _ChoiceBtn(
          label: AppLocalizations.of(context).workoutFeedbackYesPain,
          selected: _hadPain == true,
          activeColor: theme.redText,
          activeBg: theme.redText.withValues(alpha: 0.12),
          activeBorder: theme.redMid,
          onTap: () => setState(() => _hadPain = true),
        )),
        const SizedBox(width: 10),
        Expanded(child: _ChoiceBtn(
          label: AppLocalizations.of(context).workoutFeedbackNoPain,
          selected: _hadPain == false,
          activeColor: theme.greenText,
          activeBg: theme.greenBg,
          activeBorder: theme.successBorder,
          onTap: () => setState(() => _hadPain = false),
        )),
      ]),
      if (_hadPain == true) ...[
        const SizedBox(height: 12),
        TextFormField(
          controller: _painCtrl,
          maxLines: 2,
          style: TextStyle(color: theme.white, fontSize: 13),
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context).workoutFeedbackPainHint,
            hintStyle: TextStyle(color: theme.grey, fontSize: 12),
            filled: true, fillColor: theme.cardDark,
            contentPadding: const EdgeInsets.all(12),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: theme.border)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: theme.border)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                    color: theme.orange, width: 1.5)),
          ),
        ),
      ],
    ]),
  );

  Widget _buildNotesCard(AppThemeExtensionWrapper theme) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
        color: theme.card, borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.border)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(AppLocalizations.of(context).workoutFeedbackAdditionalNotes,
          style: TextStyle(
              color: theme.orange, fontSize: 14,
              fontWeight: FontWeight.w700)),
      Text(AppLocalizations.of(context).workoutFeedbackOptional,
          style: TextStyle(color: theme.grey, fontSize: 12)),
      const SizedBox(height: 12),
      TextFormField(
        controller: _notesCtrl,
        maxLines: 3,
        style: TextStyle(color: theme.white, fontSize: 13),
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context).workoutFeedbackNotesHint,
          hintStyle: TextStyle(color: theme.grey, fontSize: 12),
          filled: true, fillColor: theme.cardDark,
          contentPadding: const EdgeInsets.all(12),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: theme.border)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: theme.border)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                  color: theme.orange, width: 1.5)),
        ),
      ),
    ]),
  );

  Color _rpeColor(int v, AppThemeExtensionWrapper theme) {
    if (v <= 3) return theme.greenText;
    if (v <= 6) return theme.orange;
    return theme.redText;
  }

  String _rpeLabel(BuildContext context, int v) {
    final l10n = AppLocalizations.of(context);
    if (v <= 2) return l10n.workoutFeedbackRpeEasy;
    if (v <= 4) return l10n.workoutFeedbackRpeModerate;
    if (v <= 6) return l10n.workoutFeedbackRpeSomewhatHard;
    if (v <= 8) return l10n.workoutFeedbackRpeHard;
    return l10n.workoutFeedbackRpeMax;
  }

  String _getFeelingText(BuildContext context, int index) {
    final l10n = AppLocalizations.of(context);
    switch (index) {
      case 0: return l10n.workoutFeedbackFeelingVeryTired;
      case 1: return l10n.workoutFeedbackFeelingTired;
      case 2: return l10n.workoutFeedbackFeelingGood;
      case 3: return l10n.workoutFeedbackFeelingGreat;
      default: return '';
    }
  }
}

// ═══════════════════════════════════════════════════════════════
// STAT CHIP
// ═══════════════════════════════════════════════════════════════
class _StatChip extends StatelessWidget {
  final String label, value;
  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;
    return Column(children: [
      Text(label,
          style: TextStyle(
              color: theme.grey, fontSize: 10,
              fontWeight: FontWeight.w600, letterSpacing: 0.5)),
      const SizedBox(height: 4),
      Text(value,
          style: TextStyle(
              color: theme.white, fontSize: 15,
              fontWeight: FontWeight.w800)),
    ]);
  }
}

// ═══════════════════════════════════════════════════════════════
// CHOICE BUTTON
// ═══════════════════════════════════════════════════════════════
class _ChoiceBtn extends StatelessWidget {
  final String label;
  final bool selected;
  final Color activeColor, activeBg, activeBorder;
  final VoidCallback onTap;
  const _ChoiceBtn({
    required this.label,
    required this.selected,
    required this.activeColor,
    required this.activeBg,
    required this.activeBorder,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 46,
        decoration: BoxDecoration(
          color: selected ? activeBg : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? activeBorder : theme.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Center(child: Text(label,
            style: TextStyle(
                color: selected ? activeColor : theme.greyLight,
                fontSize: 14,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400))),
      ),
    );
  }
}