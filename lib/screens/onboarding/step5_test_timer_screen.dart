import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../l10n/app_localizations.dart';
import 'step5_test_feedback_screen.dart';

// ═══════════════════════════════════════════════════════════════
// TIMER CONFIG POR TEST
// ═══════════════════════════════════════════════════════════════
class TimerConfig {
  final String testTitle;
  final String icon;
  final TimerMode mode;
  final int durationSeconds; // 0 = cronómetro ascendente (plancha, cooper)
  final String unit;         // 'reps', 'metros', 'segundos', 'cm'
  final String resultHint;
  final String prepHint;
  final Color accentColor;

  const TimerConfig({
    required this.testTitle,
    required this.icon,
    required this.mode,
    required this.durationSeconds,
    required this.unit,
    required this.resultHint,
    required this.prepHint,
    required this.accentColor,
  });
}

enum TimerMode { countdown, stopwatch }

// ─── Config para cada test (mismo orden que allTests) ──────────
List<TimerConfig> getTimerConfigs(BuildContext context) {
  final l10n = AppLocalizations.of(context);
  return [
    // 0 - Sentadillas (1 min cuenta regresiva)
    TimerConfig(
      testTitle: l10n.testSquatsTitle,
      icon: '🦵',
      mode: TimerMode.countdown,
      durationSeconds: 60,
      unit: 'reps',
      resultHint: l10n.testSquatsResultHint,
      prepHint: l10n.testSquatsPrepHint,
      accentColor: AppColors.orange,
    ),
    // 1 - Test de Cooper (12 min cronómetro ascendente)
    TimerConfig(
      testTitle: l10n.testCooperTitle,
      icon: '🏃‍♂️',
      mode: TimerMode.countdown,
      durationSeconds: 720, // 12 min
      unit: 'metros',
      resultHint: l10n.testCooperResultHint,
      prepHint: l10n.testCooperPrepHint,
      accentColor: const Color(0xFF4A90D9),
    ),
    // 2 - Flexiones (1 min cuenta regresiva)
    TimerConfig(
      testTitle: l10n.testPushupsTitle,
      icon: '💪',
      mode: TimerMode.countdown,
      durationSeconds: 60,
      unit: 'reps',
      resultHint: l10n.testPushupsResultHint,
      prepHint: l10n.testPushupsPrepHint,
      accentColor: const Color(0xFFB05A30),
    ),
    // 3 - Plancha (cronómetro ascendente, para cuando aguanten)
    TimerConfig(
      testTitle: l10n.testPlankTitle,
      icon: '🧘',
      mode: TimerMode.stopwatch,
      durationSeconds: 0,
      unit: 'segundos',
      resultHint: l10n.testPlankResultHint,
      prepHint: l10n.testPlankPrepHint,
      accentColor: const Color(0xFF9B7FE8),
    ),
    // 4 - Flexibilidad (sin cronómetro, resultado directo)
    TimerConfig(
      testTitle: l10n.testFlexibilityTitle,
      icon: '🤸‍♀️',
      mode: TimerMode.stopwatch,
      durationSeconds: 0,
      unit: 'opciones',
      resultHint: l10n.testFlexibilityResultHint,
      prepHint: l10n.testFlexibilityPrepHint,
      accentColor: AppColors.greenText,
    ),
  ];
}

// ═══════════════════════════════════════════════════════════════
// SCREEN
// ═══════════════════════════════════════════════════════════════
class TestTimerScreen extends StatefulWidget {
  final int testIndex;
  final bool fromOnboarding;
  final List<int> completedTests;
  const TestTimerScreen({
    super.key,
    required this.testIndex,
    this.fromOnboarding = false,
    this.completedTests = const [],
  });

  @override
  State<TestTimerScreen> createState() => _TestTimerScreenState();
}

class _TestTimerScreenState extends State<TestTimerScreen>
    with SingleTickerProviderStateMixin {
  late TimerConfig _cfg;
  late AnimationController _pulseCtrl;

  Timer? _timer;
  int _elapsed   = 0;   // segundos transcurridos
  int _remaining = 0;   // segundos restantes (countdown)
  bool _running  = false;
  bool _finished = false;
  bool _started  = false;

  final _resultCtrl = TextEditingController();
  int _borgValue = 13;
  String? _selectedOption;
  bool _submitting = false;

  // Mapeo nombre_test por índice
  static const _testNames = [
    'sentadillas',
    'cooper',
    'flexiones',
    'plancha',
    'inclinacion',
  ];

  Future<void> _submitResult() async {
    final l10n = AppLocalizations.of(context);
    final rawValue = _cfg.unit == 'puntos'
        ? _borgValue.toString()
        : _cfg.unit == 'opciones'
            ? (_selectedOption ?? '')
            : _resultCtrl.text.trim();

    if (rawValue.isEmpty || rawValue == '0') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(l10n.onboardingTestTimerErrorResultEmpty),
        backgroundColor: AppColors.redMid,
      ));
      return;
    }

    setState(() => _submitting = true);
    try {
      final opcionesMap = {
        'No llega a rodillas': 0,
        'Llega a pies':        1,
        'Supera los pies':     2,
        'Palmas al suelo':     3,
        "Doesn't reach knees": 0,
        "Reaches feet":        1,
        "Past feet":           2,
        "Palms to the floor":  3,
      };
      final valorEnviar = _cfg.unit == 'opciones'
          ? opcionesMap[rawValue] ?? 0
          : num.tryParse(rawValue) ?? 0;
      final token = context.read<AuthProvider>().token ?? '';
      debugPrint('VALOR ENVIAR: $valorEnviar | RAW: $rawValue');
      final res = await http.post(
        Uri.parse('https://apifitnflai.com/onboarding/test/resultado'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'nombre_test': _testNames[widget.testIndex],
          'valor':       valorEnviar,
          'unidad':      _cfg.unit == 'opciones' ? 'nivel' : _cfg.unit,
        }),
      );
      debugPrint('TEST RESULT: ${res.statusCode} ${res.body}');
      if (!mounted) return;
      if (res.statusCode == 200 || res.statusCode == 201) {
        final body = jsonDecode(res.body);
        final idResultado = body['id_resultado']?.toString()
                         ?? body['id']?.toString();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => TestFeedbackScreen(
              testIndex:      widget.testIndex,
              testTitle:      _cfg.testTitle,
              testIcon:       _cfg.icon,
              fromOnboarding: widget.fromOnboarding,
              idResultado:    idResultado,
              completedTests: widget.completedTests,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(l10n.onboardingTestTimerErrorSave),
          backgroundColor: AppColors.redMid,
        ));
      }
    } catch (e) {
      debugPrint('TEST RESULT ERROR: $e');
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(l10n.onboardingTestTimerErrorConnection),
        backgroundColor: AppColors.redMid,
      ));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cfg = getTimerConfigs(context)[widget.testIndex];
    if (!_started) {
      _remaining = _cfg.durationSeconds;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseCtrl.dispose();
    _resultCtrl.dispose();
    super.dispose();
  }

  // ── Timer control ───────────────────────────────────────────
  void _start() {
    setState(() { _running = true; _started = true; });
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _elapsed++;
        if (_cfg.mode == TimerMode.countdown) {
          _remaining = (_cfg.durationSeconds - _elapsed).clamp(0, 9999);
          if (_remaining == 0) _finish();
        }
      });
    });
  }

  void _pause() {
    _timer?.cancel();
    setState(() => _running = false);
  }

  void _resume() {
    _start();
  }

  void _reset() {
    _timer?.cancel();
    setState(() {
      _running   = false;
      _started   = false;
      _finished  = false;
      _elapsed   = 0;
      _remaining = _cfg.durationSeconds;
    });
  }

  void _finish() {
    _timer?.cancel();
    setState(() { _running = false; _finished = true; });
  }

  // ── Format time ─────────────────────────────────────────────
  String _fmt(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  // ── Progress for ring (countdown only) ──────────────────────
  double get _progress {
    if (_cfg.mode == TimerMode.stopwatch) return _elapsed / 300.0;
    if (_cfg.durationSeconds == 0) return 0;
    return _elapsed / _cfg.durationSeconds;
  }

  // ── Display time ─────────────────────────────────────────────
  String get _displayTime {
    if (_cfg.mode == TimerMode.countdown) return _fmt(_remaining);
    return _fmt(_elapsed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(children: [
          // ── App bar ────────────────────────────
          _buildAppBar(context),
          const SizedBox(height: 8),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(children: [
                const SizedBox(height: 16),

                // ── Test info ─────────────────────
                _buildTestInfo(),
                const SizedBox(height: 32),

                // ── Prep hint (antes de iniciar) ──
                if (!_started) _buildPrepHint(),
                if (!_started) const SizedBox(height: 24),

                // ── Timer ring ────────────────────
                _buildTimerRing(),
                const SizedBox(height: 32),

                // ── Controls ──────────────────────
                if (!_finished) _buildControls(),

                // ── Result input (al terminar) ────
                if (_finished) _buildResultInput(),

                const SizedBox(height: 24),
              ]),
            ),
          ),
        ]),
      ),
    );
  }

  // ── App bar ──────────────────────────────────────────────────
  Widget _buildAppBar(BuildContext context) => Padding(
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
      Text(_cfg.testTitle,
          style: const TextStyle(
              color: AppColors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600)),
      const Spacer(),
      // Reset
      GestureDetector(
        onTap: _reset,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
          child: const Icon(Icons.refresh,
              color: AppColors.orange, size: 18),
        ),
      ),
    ]),
  );

  // ── Test info header ─────────────────────────────────────────
  Widget _buildTestInfo() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Row(children: [
      Text(_cfg.icon, style: const TextStyle(fontSize: 28)),
      const SizedBox(width: 12),
      Expanded(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_cfg.testTitle,
              style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(_cfg.resultHint,
              style: const TextStyle(
                  color: AppColors.grey, fontSize: 12, height: 1.4)),
        ],
      )),
      // Mode badge
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: _cfg.accentColor.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _cfg.accentColor.withValues(alpha: 0.4)),
        ),
        child: Text(
          _cfg.mode == TimerMode.countdown
              ? _fmt(_cfg.durationSeconds)
              : 'Libre',
          style: TextStyle(
              color: _cfg.accentColor,
              fontSize: 12,
              fontWeight: FontWeight.w600),
        ),
      ),
    ]),
  );

  // ── Prep hint ────────────────────────────────────────────────
  Widget _buildPrepHint() => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: const Color(0xFF1A2A1A),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.greenMid),
    ),
    child: Row(children: [
      const Text('🎯', style: TextStyle(fontSize: 20)),
      const SizedBox(width: 10),
      Expanded(
        child: Text(_cfg.prepHint,
            style: const TextStyle(
                color: AppColors.greenText, fontSize: 13, height: 1.4)),
      ),
    ]),
  );

  // ── Timer ring ───────────────────────────────────────────────
  Widget _buildTimerRing() => SizedBox(
    width: 240, height: 240,
    child: Stack(alignment: Alignment.center, children: [
      // Ring
      CustomPaint(
        size: const Size(240, 240),
        painter: _RingPainter(
          progress: _progress.clamp(0.0, 1.0),
          color: _finished
              ? AppColors.greenText
              : _running
                  ? _cfg.accentColor
                  : AppColors.grey,
          finished: _finished,
        ),
      ),

      // Center content
      Column(mainAxisSize: MainAxisSize.min, children: [
        // Time
        AnimatedBuilder(
          animation: _pulseCtrl,
          builder: (context, child) => Transform.scale(
            scale: _running ? (1.0 + _pulseCtrl.value * 0.02) : 1.0,
            child: Text(
              _finished ? '✓' : _displayTime,
              style: TextStyle(
                color: _finished ? AppColors.greenText : AppColors.white,
                fontSize: _finished ? 64 : 52,
                fontWeight: FontWeight.w800,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ),

        // Label
        Text(
          _finished
              ? AppLocalizations.of(context).onboardingTestTimerStatusCompleted
              : _running
                  ? (_cfg.mode == TimerMode.countdown
                      ? AppLocalizations.of(context).onboardingTestTimerLabelRemaining
                      : AppLocalizations.of(context).onboardingTestTimerLabelElapsed)
                  : _started
                      ? AppLocalizations.of(context).onboardingTestTimerStatusPaused
                      : AppLocalizations.of(context).onboardingTestTimerStatusReady,
          style: TextStyle(
            color: _finished ? AppColors.greenText : AppColors.grey,
            fontSize: 13,
          ),
        ),

        // Reps counter (if countdown and reps)
        if (_cfg.unit == 'reps' && _started && !_finished) ...[
          const SizedBox(height: 12),
          Text(AppLocalizations.of(context).onboardingTestTimerRepsHint,
              style: const TextStyle(color: AppColors.orange,
                  fontSize: 11, fontWeight: FontWeight.w500)),
        ],
      ]),
    ]),
  );

  // ── Controls ─────────────────────────────────────────────────
  Widget _buildControls() {
    final l10n = AppLocalizations.of(context);
    return Column(children: [
      // Main button
      SizedBox(
        width: 180, height: 60,
        child: ElevatedButton(
          onPressed: !_started
              ? _start
              : _running ? _pause : _resume,
          style: ElevatedButton.styleFrom(
            backgroundColor: _cfg.accentColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
            elevation: 0,
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(
              !_started
                  ? Icons.play_arrow_rounded
                  : _running
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
              size: 28,
            ),
            const SizedBox(width: 8),
            Text(
              !_started
                  ? l10n.onboardingTestTimerBtnStart
                  : _running ? l10n.onboardingTestTimerBtnPause : l10n.onboardingTestTimerBtnResume,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ]),
        ),
      ),
      const SizedBox(height: 16),

      // Secondary: finish manually (for stopwatch mode)
      if (_cfg.mode == TimerMode.stopwatch && _started && _running)
        TextButton(
          onPressed: _finish,
          child: Text(l10n.onboardingTestTimerBtnFinish,
              style: const TextStyle(
                  color: AppColors.orange,
                  fontSize: 14,
                  fontWeight: FontWeight.w600)),
        ),

      // Reset link
      if (_started)
        TextButton(
          onPressed: _reset,
          child: Text(l10n.onboardingTestTimerBtnReset,
              style: const TextStyle(color: AppColors.grey, fontSize: 13)),
        ),
    ]);
  }

  // ── Result input ─────────────────────────────────────────────
  Widget _buildResultInput() {
    final l10n = AppLocalizations.of(context);
    return Column(children: [
      // Success message
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A3A2A),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.greenMid),
        ),
        child: Column(children: [
          Row(children: [
            const Text('🎉', style: TextStyle(fontSize: 22)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(l10n.onboardingTestTimerSuccessTitle,
                  style: const TextStyle(
                      color: AppColors.greenText,
                      fontSize: 16,
                      fontWeight: FontWeight.w700)),
            ),
          ]),
          const SizedBox(height: 8),
          Text(l10n.onboardingTestTimerSuccessTime(_fmt(_elapsed)),
              style: const TextStyle(
                  color: AppColors.greyLight, fontSize: 13)),
        ]),
      ),
      const SizedBox(height: 16),

      // Result field
      if (_cfg.unit == 'puntos') ...[
        // Borg scale selector
        _BorgSelector(
          value: _borgValue,
          onChanged: (v) => setState(() => _borgValue = v),
        ),
      ] else if (_cfg.unit == 'opciones') ...[
        // Option selector for inclinación
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(l10n.onboardingTestTimerFlexibilityQuestion,
                style: const TextStyle(
                    color: AppColors.greyLight,
                    fontSize: 13,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            ...[
              l10n.onboardingTestTimerFlexibilityOpt1,
              l10n.onboardingTestTimerFlexibilityOpt2,
              l10n.onboardingTestTimerFlexibilityOpt3,
              l10n.onboardingTestTimerFlexibilityOpt4
            ].map((opt) => GestureDetector(
                  onTap: () => setState(() => _selectedOption = opt),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: _selectedOption == opt
                          ? AppColors.greenText.withValues(alpha: 0.12)
                          : AppColors.cardDark,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: _selectedOption == opt
                            ? AppColors.greenMid : AppColors.border,
                        width: _selectedOption == opt ? 1.5 : 1,
                      ),
                    ),
                    child: Row(children: [
                      Expanded(child: Text(opt,
                          style: TextStyle(
                              color: _selectedOption == opt
                                  ? AppColors.greenText : AppColors.white,
                              fontSize: 14,
                              fontWeight: _selectedOption == opt
                                  ? FontWeight.w600 : FontWeight.w400))),
                      if (_selectedOption == opt)
                        const Icon(Icons.check_circle,
                            color: AppColors.greenText, size: 18),
                    ]),
                  ),
                )),
          ]),
        ),
      ] else ...[
        // Number input
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Text(l10n.onboardingTestTimerInputLabel(_cfg.unit),
                style: const TextStyle(
                    color: AppColors.greyLight,
                    fontSize: 13,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            TextField(
              controller: _resultCtrl,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                  color: AppColors.white, fontSize: 22, fontWeight: FontWeight.w700),
              decoration: InputDecoration(
                hintText: '0',
                hintStyle: const TextStyle(color: AppColors.grey),
                suffixText: _cfg.unit,
                suffixStyle: const TextStyle(
                    color: AppColors.orange, fontSize: 14),
                filled: true,
                fillColor: AppColors.cardDark,
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
        ),
      ],
      const SizedBox(height: 16),

      // Save button
      SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: _submitting ? null : _submitResult,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.orange,
            foregroundColor: Colors.white,
            disabledBackgroundColor: AppColors.border,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
            elevation: 0,
          ),
          child: _submitting
              ? const SizedBox(width: 22, height: 22,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2))
              : Text(l10n.onboardingTestTimerBtnSave,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        ),
      ),
    ]);
  }
}

// ═══════════════════════════════════════════════════════════════
// RING PAINTER
// ═══════════════════════════════════════════════════════════════
class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final bool finished;
  const _RingPainter({
    required this.progress,
    required this.color,
    required this.finished,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 12;

    // Background ring
    canvas.drawCircle(center, radius,
      Paint()
        ..color = AppColors.border
        ..style = PaintingStyle.stroke
        ..strokeWidth = 12);

    // Progress arc
    if (progress > 0 || finished) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2,
        (finished ? 1.0 : progress) * 2 * pi,
        false,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 12
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress || old.color != color;
}

// ═══════════════════════════════════════════════════════════════
// BORG SCALE SELECTOR
// ═══════════════════════════════════════════════════════════════
class _BorgSelector extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  const _BorgSelector({required this.value, required this.onChanged});

  String _getLevelLabel(BuildContext context, int v) {
    final l10n = AppLocalizations.of(context);
    switch (v) {
      case 6: return l10n.onboardingTestTimerBorgLevel6;
      case 7: return l10n.onboardingTestTimerBorgLevel7;
      case 8: return l10n.onboardingTestTimerBorgLevel8;
      case 9: return l10n.onboardingTestTimerBorgLevel9;
      case 10: return l10n.onboardingTestTimerBorgLevel10;
      case 11: return l10n.onboardingTestTimerBorgLevel11;
      case 12: return l10n.onboardingTestTimerBorgLevel12;
      case 13: return l10n.onboardingTestTimerBorgLevel13;
      case 14: return l10n.onboardingTestTimerBorgLevel14;
      case 15: return l10n.onboardingTestTimerBorgLevel15;
      case 16: return l10n.onboardingTestTimerBorgLevel16;
      case 17: return l10n.onboardingTestTimerBorgLevel17;
      case 18: return l10n.onboardingTestTimerBorgLevel18;
      case 19: return l10n.onboardingTestTimerBorgLevel19;
      case 20: return l10n.onboardingTestTimerBorgLevel20;
      default: return '';
    }
  }

  Color _levelColor(int v) {
    if (v <= 10) return AppColors.greenText;
    if (v <= 13) return const Color(0xFFE8C42A);
    if (v <= 16) return AppColors.orange;
    return AppColors.redText;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(l10n.onboardingTestTimerBorgQuestion,
            style: const TextStyle(
                color: AppColors.greyLight,
                fontSize: 13,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 16),

        // Current value display
        Center(child: Column(children: [
          Text('$value',
              style: TextStyle(
                  color: _levelColor(value),
                  fontSize: 56,
                  fontWeight: FontWeight.w800)),
          Text(_getLevelLabel(context, value),
              style: TextStyle(
                  color: _levelColor(value), fontSize: 14)),
        ])),
        const SizedBox(height: 16),

        // Slider
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: _levelColor(value),
            inactiveTrackColor: AppColors.border,
            thumbColor: _levelColor(value),
            overlayColor: _levelColor(value).withValues(alpha: 0.2),
            trackHeight: 6,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
          ),
          child: Slider(
            value: value.toDouble(),
            min: 6, max: 20, divisions: 14,
            onChanged: (v) => onChanged(v.round()),
          ),
        ),

        // Scale labels
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('6\n${l10n.onboardingTestTimerBorgLabelNone}', textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.grey, fontSize: 10)),
          Text('13\n${l10n.onboardingTestTimerBorgLabelHard}', textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.grey, fontSize: 10)),
          Text('20\n${l10n.onboardingTestTimerBorgLabelMax}', textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.grey, fontSize: 10)),
        ]),
      ]),
    );
  }
}