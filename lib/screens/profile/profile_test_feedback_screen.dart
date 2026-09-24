import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../services/cached_http.dart';


// ═══════════════════════════════════════════════════════════════
// FEEDBACK SCREEN — Paso 3 del test funcional
// ═══════════════════════════════════════════════════════════════
class ProfileTestFeedbackScreen extends StatefulWidget {
  final int testIndex;
  final String testTitle;
  final String testIcon;
  final String? idResultado;

  const ProfileTestFeedbackScreen({
    super.key,
    required this.testIndex,
    required this.testTitle,
    required this.testIcon,
    this.idResultado,
  });

  @override
  State<ProfileTestFeedbackScreen> createState() => _ProfileTestFeedbackScreenState();
}

class _ProfileTestFeedbackScreenState extends State<ProfileTestFeedbackScreen> {
  // RPE 1–10
  int _rpeValue = 5;

  // Sentimiento — texto libre
  final _sentimientoCtrl = TextEditingController();

  // Dolor o molestia
  bool? _hadPain;
  final _painCtrl = TextEditingController();

  // Notas libres
  final _notesCtrl = TextEditingController();

  // Completitud del test
  bool? _completed;

  bool _submitting = false;

  @override
  void dispose() {
    _sentimientoCtrl.dispose();
    _painCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  bool get _canSave => _hadPain != null && _completed != null;

  Future<void> _submitFeedback() async {
    setState(() => _submitting = true);
    try {
      final token = context.read<AuthProvider>().token ?? '';
      final res = await CachedHttp.post(
        Uri.parse('https://apifitnflai.com/onboarding/test/feedback'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'id_resultado':   widget.idResultado,
          'completo_test':  _completed,
          'esfuerzo_rpe':   _rpeValue,
          'sentimiento':    [
                              _feelings[_feelingIdx].$1,
                              _feelings[_feelingIdx].$2,
                              if (_sentimientoCtrl.text.trim().isNotEmpty)
                                _sentimientoCtrl.text.trim(),
                            ].join(' — '),
          'dolor_molestia': _hadPain,
          'comentarios':    _notesCtrl.text.trim().isEmpty
                                ? null
                                : _notesCtrl.text.trim(),
        }),
      );
      debugPrint('FEEDBACK: ${res.statusCode} ${res.body}');
      if (!mounted) return;
      if (res.statusCode == 200 || res.statusCode == 201) {
        if (!mounted) return;
        // Volver a MyTestsScreen (instruction + timer + feedback = 3 niveles)
        int count = 0;
        Navigator.of(context).popUntil((_) => count++ >= 3);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Error al guardar el feedback. Intenta de nuevo.'),
          backgroundColor: AppColors.redMid,
        ));
      }
    } catch (e) {
      debugPrint('FEEDBACK ERROR: $e');
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Error de conexión. Intenta de nuevo.'),
        backgroundColor: AppColors.redMid,
      ));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(children: [

          // ── Top bar ──────────────────────────────
          _buildTopBar(context),

          // ── Step tabs ────────────────────────────
          _StepTabs(currentStep: 2),
          const SizedBox(height: 16),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(children: [

                // ── Header ────────────────────────
                _buildHeader(),
                const SizedBox(height: 16),

                // ── ¿Completaste el test? ─────────
                _buildCompletionCard(),
                const SizedBox(height: 14),

                // ── RPE ───────────────────────────
                _buildRPECard(),
                const SizedBox(height: 14),

                // ── Sensación ─────────────────────
                _buildFeelingCard(),
                const SizedBox(height: 14),

                // ── Dolor ─────────────────────────
                _buildPainCard(),
                const SizedBox(height: 14),

                // ── Notas ─────────────────────────
                _buildNotesCard(),
                const SizedBox(height: 24),
              ]),
            ),
          ),

          // ── Save button ──────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: Column(children: [
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: (_canSave && !_submitting) ? _submitFeedback : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _canSave
                        ? AppColors.orange
                        : const Color(0xFF2A2A2A),
                    disabledBackgroundColor: const Color(0xFF2A2A2A),
                    foregroundColor: Colors.white,
                    disabledForegroundColor: AppColors.grey,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: _submitting
                      ? const SizedBox(width: 22, height: 22,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : const Text('Guardar feedback',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700)),
                ),
              ),
              if (!_canSave) ...[
                const SizedBox(height: 8),
                const Text('Responde todas las preguntas para continuar',
                    style: TextStyle(color: AppColors.grey, fontSize: 12)),
              ],
            ]),
          ),

          // ── Bottom nav ────────────────────────────
          _BottomNav(),
        ]),
      ),
    );
  }

  // ── Top bar ──────────────────────────────────────────────────
  Widget _buildTopBar(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
    child: Row(children: [
      GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
          child: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.white, size: 16),
        ),
      ),
      const Spacer(),
      const Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Text('Hola, Nico',
            style: TextStyle(color: AppColors.white,
                fontSize: 20, fontWeight: FontWeight.w800)),
        Text('Martes · Semana 2',
            style: TextStyle(color: AppColors.grey, fontSize: 12)),
      ]),
      const SizedBox(width: 12),
      Container(
        width: 38, height: 38,
        decoration: const BoxDecoration(
            color: AppColors.orange, shape: BoxShape.circle),
        child: const Center(child: Text('N',
            style: TextStyle(color: Colors.white,
                fontSize: 17, fontWeight: FontWeight.w700))),
      ),
    ]),
  );

  // ── Header ───────────────────────────────────────────────────
  Widget _buildHeader() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
        color: AppColors.card, borderRadius: BorderRadius.circular(14)),
    child: Row(children: [
      Text(widget.testIcon, style: const TextStyle(fontSize: 28)),
      const SizedBox(width: 12),
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(widget.testTitle,
              style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          const Text(
            'Cuentanos como te fue — esto personaliza tu plan.',
            style: TextStyle(
                color: AppColors.grey, fontSize: 12, height: 1.4),
          ),
        ]),
      ),
    ]),
  );

  // ── Completion card ──────────────────────────────────────────
  Widget _buildCompletionCard() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
        color: AppColors.card, borderRadius: BorderRadius.circular(14)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('¿Completaste el test al 100%?',
          style: TextStyle(
              color: AppColors.orange,
              fontSize: 14,
              fontWeight: FontWeight.w700)),
      const SizedBox(height: 12),
      Row(children: [
        Expanded(child: _YesNoBtn(
          label: '✓  Sí, completo',
          selected: _completed == true,
          activeColor: AppColors.greenText,
          activeBg: const Color(0xFF1A3A2A),
          activeBorder: AppColors.greenMid,
          onTap: () => setState(() => _completed = true),
        )),
        const SizedBox(width: 10),
        Expanded(child: _YesNoBtn(
          label: '✗  No del todo',
          selected: _completed == false,
          activeColor: AppColors.orange,
          activeBg: const Color(0xFF2E1A0A),
          activeBorder: AppColors.orange,
          onTap: () => setState(() => _completed = false),
        )),
      ]),
    ]),
  );

  // ── RPE card ─────────────────────────────────────────────────
  Widget _buildRPECard() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
        color: AppColors.card, borderRadius: BorderRadius.circular(14)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('¿Cuánto esfuerzo percibiste?',
          style: TextStyle(
              color: AppColors.orange,
              fontSize: 14,
              fontWeight: FontWeight.w700)),
      const Text('Escala RPE 1–10',
          style: TextStyle(color: AppColors.grey, fontSize: 12)),
      const SizedBox(height: 16),

      // Current value
      Center(child: RichText(
        text: TextSpan(children: [
          TextSpan(
            text: '$_rpeValue',
            style: TextStyle(
                color: _rpeColor(_rpeValue),
                fontSize: 48,
                fontWeight: FontWeight.w800),
          ),
          TextSpan(
            text: ' / 10',
            style: const TextStyle(
                color: AppColors.grey, fontSize: 20),
          ),
        ]),
      )),
      Center(child: Text(_rpeLabel(_rpeValue),
          style: TextStyle(
              color: _rpeColor(_rpeValue),
              fontSize: 13,
              fontWeight: FontWeight.w600))),
      const SizedBox(height: 16),

      // Buttons 1–10
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(10, (i) {
          final val = i + 1;
          final sel = val == _rpeValue;
          return GestureDetector(
            onTap: () => setState(() => _rpeValue = val),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 28, height: 32,
              decoration: BoxDecoration(
                color: sel ? _rpeColor(val) : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: sel ? _rpeColor(val) : AppColors.border,
                  width: 1.5,
                ),
              ),
              child: Center(child: Text('$val',
                  style: TextStyle(
                      color: sel ? Colors.white : AppColors.greyLight,
                      fontSize: 12,
                      fontWeight: sel ? FontWeight.w700 : FontWeight.w400))),
            ),
          );
        }),
      ),
      const SizedBox(height: 8),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [
        Text('Muy\nfácil', textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.grey, fontSize: 10)),
        Text('Algo difícil', style: TextStyle(color: AppColors.grey, fontSize: 10)),
        Text('Máximo\nesfuerzo', textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.grey, fontSize: 10)),
      ]),
    ]),
  );

  Color _rpeColor(int v) {
    if (v <= 3) return AppColors.greenText;
    if (v <= 5) return const Color(0xFFE8C42A);
    if (v <= 7) return AppColors.orange;
    return AppColors.redText;
  }

  String _rpeLabel(int v) {
    if (v <= 2) return 'Muy fácil';
    if (v <= 4) return 'Moderado';
    if (v <= 6) return 'Algo difícil';
    if (v <= 8) return 'Difícil';
    if (v == 9) return 'Muy difícil';
    return 'Esfuerzo máximo';
  }

  // ── Feeling card ─────────────────────────────────────────────
  static const _feelings = [
    ('😰', 'Muy cansado'),
    ('😓', 'Cansado'),
    ('😮', 'Bien'),
    ('😄', 'Sobrado'),
  ];
  int _feelingIdx = 2;

  Widget _buildFeelingCard() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
        color: AppColors.card, borderRadius: BorderRadius.circular(14)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('¿Cómo te sentiste durante el test?',
          style: TextStyle(
              color: AppColors.orange,
              fontSize: 14,
              fontWeight: FontWeight.w700)),
      const SizedBox(height: 14),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(_feelings.length, (i) {
          final sel = i == _feelingIdx;
          return GestureDetector(
            onTap: () => setState(() => _feelingIdx = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 74, height: 84,
              decoration: BoxDecoration(
                color: sel ? const Color(0xFF1A3A2A) : AppColors.cardDark,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: sel ? AppColors.greenText : AppColors.border,
                  width: sel ? 1.5 : 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_feelings[i].$1, style: const TextStyle(fontSize: 30)),
                  const SizedBox(height: 4),
                  Text(_feelings[i].$2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: sel ? AppColors.greenText : AppColors.grey,
                          fontSize: 10,
                          fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                          height: 1.2)),
                ],
              ),
            ),
          );
        }),
      ),
      const SizedBox(height: 14),
      const Text('Cuéntanos con tus palabras (opcional)',
          style: TextStyle(color: AppColors.grey, fontSize: 12)),
      const SizedBox(height: 8),
      TextFormField(
        controller: _sentimientoCtrl,
        maxLines: 2,
        style: const TextStyle(color: AppColors.white, fontSize: 13),
        decoration: InputDecoration(
          hintText: 'Ej: Me sentí con energía aunque me costó al final...',
          hintStyle: const TextStyle(color: AppColors.grey, fontSize: 12),
          filled: true, fillColor: AppColors.cardDark,
          contentPadding: const EdgeInsets.all(12),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.orange, width: 1.5)),
        ),
      ),
    ]),
  );

  // ── Pain card ────────────────────────────────────────────────
  Widget _buildPainCard() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
        color: AppColors.card, borderRadius: BorderRadius.circular(14)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('¿Sentiste algún dolor o molestia?',
          style: TextStyle(
              color: AppColors.orange,
              fontSize: 14,
              fontWeight: FontWeight.w700)),
      const SizedBox(height: 12),
      Row(children: [
        Expanded(child: _YesNoBtn(
          label: 'Sí, algo',
          selected: _hadPain == true,
          activeColor: AppColors.redText,
          activeBg: const Color(0xFF2E1515),
          activeBorder: AppColors.redMid,
          onTap: () => setState(() => _hadPain = true),
        )),
        const SizedBox(width: 10),
        Expanded(child: _YesNoBtn(
          label: 'No, ninguno',
          selected: _hadPain == false,
          activeColor: AppColors.greenText,
          activeBg: const Color(0xFF1A3A2A),
          activeBorder: AppColors.greenMid,
          onTap: () => setState(() => _hadPain = false),
        )),
      ]),
      if (_hadPain == true) ...[
        const SizedBox(height: 12),
        TextFormField(
          controller: _painCtrl,
          maxLines: 2,
          style: const TextStyle(color: AppColors.white, fontSize: 13),
          decoration: InputDecoration(
            hintText: 'Descríbela: zona del cuerpo, tipo de dolor...',
            hintStyle: const TextStyle(color: AppColors.grey, fontSize: 12),
            filled: true, fillColor: AppColors.cardDark,
            contentPadding: const EdgeInsets.all(12),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.border)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.border)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                    color: AppColors.orange, width: 1.5)),
          ),
        ),
      ],
    ]),
  );

  // ── Notes card ───────────────────────────────────────────────
  Widget _buildNotesCard() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
        color: AppColors.card, borderRadius: BorderRadius.circular(14)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('¿Algo más que quieras contarnos?',
          style: TextStyle(
              color: AppColors.orange,
              fontSize: 14,
              fontWeight: FontWeight.w700)),
      const Text('Opcional',
          style: TextStyle(color: AppColors.grey, fontSize: 12)),
      const SizedBox(height: 12),
      TextFormField(
        controller: _notesCtrl,
        maxLines: 3,
        style: const TextStyle(color: AppColors.white, fontSize: 13),
        decoration: InputDecoration(
          hintText:
              'Ej: las últimas reps me costaron más, sentí las piernas pesadas...',
          hintStyle: const TextStyle(color: AppColors.grey, fontSize: 12),
          filled: true, fillColor: AppColors.cardDark,
          contentPadding: const EdgeInsets.all(12),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                  color: AppColors.orange, width: 1.5)),
        ),
      ),
    ]),
  );
}

// ═══════════════════════════════════════════════════════════════
// YES / NO BUTTON
// ═══════════════════════════════════════════════════════════════
class _YesNoBtn extends StatelessWidget {
  final String label;
  final bool selected;
  final Color activeColor, activeBg, activeBorder;
  final VoidCallback onTap;
  const _YesNoBtn({
    required this.label,
    required this.selected,
    required this.activeColor,
    required this.activeBg,
    required this.activeBorder,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      height: 46,
      decoration: BoxDecoration(
        color: selected ? activeBg : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: selected ? activeBorder : AppColors.border,
          width: selected ? 1.5 : 1,
        ),
      ),
      child: Center(child: Text(label,
          style: TextStyle(
              color: selected ? activeColor : AppColors.greyLight,
              fontSize: 14,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400))),
    ),
  );
}

// ═══════════════════════════════════════════════════════════════
// STEP TABS
// ═══════════════════════════════════════════════════════════════
class _StepTabs extends StatelessWidget {
  final int currentStep;
  const _StepTabs({required this.currentStep});
  static const _labels = ['Instrucción', 'Registro', 'Feedback'];

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
    child: Row(children: List.generate(3, (i) {
      final done   = i < currentStep;
      final active = i == currentStep;
      return Expanded(
        child: Container(
          margin: EdgeInsets.only(right: i < 2 ? 8 : 0),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active
                ? AppColors.orange
                : done ? const Color(0xFF1A3A2A) : AppColors.card,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(children: [
            done
                ? const Icon(Icons.check,
                    color: AppColors.greenText, size: 18)
                : Text('${i + 1}',
                    style: TextStyle(
                        color: active ? Colors.white : AppColors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w800)),
            Text(_labels[i],
                style: TextStyle(
                    color: active
                        ? Colors.white
                        : done ? AppColors.greenText : AppColors.grey,
                    fontSize: 11,
                    fontWeight: active || done
                        ? FontWeight.w600 : FontWeight.w400)),
          ]),
        ),
      );
    })),
  );
}

// ═══════════════════════════════════════════════════════════════
// BOTTOM NAV
// ═══════════════════════════════════════════════════════════════
class _BottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    height: 64,
    decoration: const BoxDecoration(
      color: AppColors.card,
      border: Border(top: BorderSide(color: AppColors.border)),
    ),
    child: Row(children: const [
      _NavItem(icon: Icons.home_outlined,       label: 'Home'),
      _NavItem(icon: Icons.bar_chart_outlined,  label: 'Plan'),
      _NavItem(icon: Icons.show_chart_outlined, label: 'Progreso'),
      _NavItem(icon: Icons.person_outline,      label: 'Perfil'),
    ]),
  );
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) => Expanded(
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(icon, color: AppColors.grey, size: 24),
      Text(label,
          style: const TextStyle(color: AppColors.grey, fontSize: 10)),
    ]),
  );
}