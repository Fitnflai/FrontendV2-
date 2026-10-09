import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../config/app_theme_extension.dart';
import '../../providers/auth_provider.dart';
import '../onboarding/step5_test_timer_screen.dart'  show getTimerConfigs, TimerConfig, TimerMode;
import 'profile_test_feedback_screen.dart';
import '../../services/cached_http.dart';

class ProfileTestTimerScreen extends StatefulWidget {
  final int testIndex;
  final String? idResultadoExistente;
  const ProfileTestTimerScreen({
    super.key,
    required this.testIndex,
    this.idResultadoExistente,
  });

  @override
  State<ProfileTestTimerScreen> createState() => _ProfileTestTimerScreenState();
}

class _ProfileTestTimerScreenState extends State<ProfileTestTimerScreen>
    with SingleTickerProviderStateMixin {
  late TimerConfig _cfg;
  late AnimationController _pulseCtrl;

  Timer? _timer;
  int  _elapsed   = 0;
  int  _remaining = 0;
  bool _running   = false;
  bool _finished  = false;
  bool _started   = false;

  final _resultCtrl = TextEditingController();
  // ignore: prefer_final_fields
  int     _borgValue      = 13;
  String? _selectedOption;
  bool    _submitting     = false;

  static const _testNames = [
    'sentadillas', 'cooper', 'flexiones', 'plancha', 'inclinacion',
  ];

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 800),
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

  void _pause()  { _timer?.cancel(); setState(() => _running = false); }
  void _resume() { _start(); }
  void _finish() { _timer?.cancel(); setState(() { _running = false; _finished = true; }); }
  void _reset()  {
    _timer?.cancel();
    setState(() {
      _running = false; _started = false; _finished = false;
      _elapsed = 0; _remaining = _cfg.durationSeconds;
    });
  }

  String _fmt(int s) {
    final m = s ~/ 60; final sec = s % 60;
    return '${m.toString().padLeft(2,'0')}:${sec.toString().padLeft(2,'0')}';
  }

  double get _progress {
    if (_cfg.mode == TimerMode.stopwatch) return _elapsed / 300.0;
    if (_cfg.durationSeconds == 0) return 0;
    return _elapsed / _cfg.durationSeconds;
  }

  String get _displayTime =>
      _cfg.mode == TimerMode.countdown ? _fmt(_remaining) : _fmt(_elapsed);

  Future<void> _submitResult() async {
    final theme = context.themeColors;
    final rawValue = _cfg.unit == 'puntos'
        ? _borgValue.toString()
        : _cfg.unit == 'opciones'
            ? (_selectedOption ?? '')
            : _resultCtrl.text.trim();

    if (rawValue.isEmpty || rawValue == '0') {
      final theme = context.themeColors;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Ingresa tu resultado antes de continuar'),
        backgroundColor: theme.redMid,
      ));
      return;
    }


    setState(() => _submitting = true);
    try {
      const opcionesMap = {
        'No llega a rodillas': 0, 'Llega a pies': 1,
        'Supera los pies': 2,     'Palmas al suelo': 3,
      };
      final valorEnviar = _cfg.unit == 'opciones'
          ? opcionesMap[rawValue] ?? 0
          : num.tryParse(rawValue) ?? 0;

      final token = context.read<AuthProvider>().token ?? '';
      final http.Response res;
      final idExistente = widget.idResultadoExistente;

      if (idExistente != null) {
        res = await CachedHttp.patch(
          Uri.parse('https://apifitnflai.com/evaluacion/actualizar-resultado-test/$idExistente'),
          headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
          body: jsonEncode({
            'nombre_test':     _testNames[widget.testIndex],
            'resultado_valor': valorEnviar,
            'unidad':          _cfg.unit == 'opciones' ? 'nivel' : _cfg.unit,
          }),
        );
      } else {
        res = await CachedHttp.post(
          Uri.parse('https://apifitnflai.com/onboarding/test/resultado'),
          headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
          body: jsonEncode({
            'nombre_test': _testNames[widget.testIndex],
            'valor':       valorEnviar,
            'unidad':      _cfg.unit == 'opciones' ? 'nivel' : _cfg.unit,
          }),
        );
      }

      debugPrint('PROFILE TEST RESULT: ${res.statusCode} ${res.body}');
      if (!mounted) return;

      if (res.statusCode == 200 || res.statusCode == 201) {
        final body      = jsonDecode(res.body);
        final idResultado = body['id_resultado']?.toString() ?? body['id']?.toString();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ProfileTestFeedbackScreen(
            testIndex:   widget.testIndex,
            testTitle:   _cfg.testTitle,
            testIcon:    _cfg.icon,
            idResultado: idResultado,
          )),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Error al guardar. Intenta de nuevo.'),
          backgroundColor: theme.redMid,
        ));
      }
    } catch (e) {
      debugPrint('PROFILE TEST ERROR: $e');
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Error de conexión. Intenta de nuevo.'),
        backgroundColor: theme.redMid,
      ));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;
    return Scaffold(
      backgroundColor: theme.bg,
      body: SafeArea(
        child: Column(children: [
          // AppBar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
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
                      color: theme.text, size: 16),
                ),
              ),
              const Spacer(),
              Text(_cfg.testTitle,
                  style: TextStyle(color: theme.text,
                      fontSize: 15, fontWeight: FontWeight.w600)),
              const Spacer(),
              GestureDetector(
                onTap: _reset,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.card,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: theme.border),
                  ),
                  child: Icon(Icons.refresh, color: theme.primary, size: 18),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 8),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(children: [
                const SizedBox(height: 16),

                // Test info
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.card,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(children: [
                    Text(_cfg.icon, style: const TextStyle(fontSize: 28)),
                    const SizedBox(width: 12),
                    Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(_cfg.testTitle,
                          style: TextStyle(color: theme.text,
                              fontSize: 15, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text(_cfg.resultHint,
                          style: TextStyle(
                              color: theme.textMuted, fontSize: 12, height: 1.4)),
                    ])),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: _cfg.accentColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _cfg.accentColor.withValues(alpha: 0.4)),
                      ),
                      child: Text(
                        _cfg.mode == TimerMode.countdown
                            ? _fmt(_cfg.durationSeconds) : 'Libre',
                        style: TextStyle(color: _cfg.accentColor,
                            fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ]),
                ),
                const SizedBox(height: 32),

                // Prep hint
                if (!_started) Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: theme.successBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.successBorder),
                  ),
                  child: Row(children: [
                    const Text('🎯', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 10),
                    Expanded(child: Text(_cfg.prepHint,
                        style: TextStyle(
                            color: theme.successText, fontSize: 13, height: 1.4))),
                  ]),
                ),
                if (!_started) const SizedBox(height: 24),

                // Timer ring
                SizedBox(
                  width: 240, height: 240,
                  child: Stack(alignment: Alignment.center, children: [
                    CustomPaint(
                      size: const Size(240, 240),
                      painter: _RingPainter(
                        progress: _progress.clamp(0.0, 1.0),
                        color: _finished ? theme.successText
                            : _running ? _cfg.accentColor : theme.textMuted,
                        finished: _finished,
                        borderColor: theme.border,
                      ),
                    ),
                    Column(mainAxisSize: MainAxisSize.min, children: [
                      AnimatedBuilder(
                        animation: _pulseCtrl,
                        builder: (_, __) => Transform.scale(
                          scale: _running ? (1.0 + _pulseCtrl.value * 0.02) : 1.0,
                          child: Text(
                            _finished ? '✓' : _displayTime,
                            style: TextStyle(
                              color: _finished ? theme.successText : theme.text,
                              fontSize: _finished ? 64 : 52,
                              fontWeight: FontWeight.w800,
                              fontFeatures: const [FontFeature.tabularFigures()],
                            ),
                          ),
                        ),
                      ),
                      Text(
                        _finished ? 'Completado'
                            : _running
                                ? (_cfg.mode == TimerMode.countdown
                                    ? 'Tiempo restante' : 'Tiempo transcurrido')
                                : _started ? 'Pausado' : 'Listo',
                        style: TextStyle(
                          color: _finished ? theme.successText : theme.textMuted,
                          fontSize: 13,
                        ),
                      ),
                    ]),
                  ]),
                ),
                const SizedBox(height: 32),

                // Controls
                if (!_finished) Column(children: [
                  SizedBox(
                    width: 180, height: 60,
                    child: ElevatedButton(
                      onPressed: !_started ? _start : _running ? _pause : _resume,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _cfg.accentColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        elevation: 0,
                      ),
                      child: Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                        Icon(!_started ? Icons.play_arrow_rounded
                            : _running ? Icons.pause_rounded
                            : Icons.play_arrow_rounded, size: 28),
                        const SizedBox(width: 8),
                        Text(!_started ? 'Iniciar'
                            : _running ? 'Pausar' : 'Continuar',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700)),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_cfg.mode == TimerMode.stopwatch && _started && _running)
                    TextButton(
                      onPressed: _finish,
                      child: Text('Terminar ahora',
                          style: TextStyle(color: theme.primary,
                              fontSize: 14, fontWeight: FontWeight.w600)),
                    ),
                  if (_started)
                    TextButton(
                      onPressed: _reset,
                      child: Text('Reiniciar desde cero',
                          style: TextStyle(color: theme.textMuted, fontSize: 13)),
                    ),
                ]),

                // Result input
                if (_finished) _buildResultInput(theme),

                const SizedBox(height: 24),
              ]),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildResultInput(AppThemeExtensionWrapper theme) => Column(children: [
    Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.successBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.successBorder),
      ),
      child: Column(children: [
        Row(children: [
          const Text('🎉', style: TextStyle(fontSize: 22)),
          const SizedBox(width: 10),
          Expanded(child: Text('¡Test completado!',
              style: TextStyle(color: theme.successText,
                  fontSize: 16, fontWeight: FontWeight.w700))),
        ]),
        const SizedBox(height: 8),
        Text('Tiempo: ${_fmt(_elapsed)}',
            style: TextStyle(color: theme.textSecondary, fontSize: 13)),
      ]),
    ),
    const SizedBox(height: 16),

    if (_cfg.unit == 'opciones') ...[
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.card, borderRadius: BorderRadius.circular(14)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('¿Hasta dónde llegaron tus manos?',
              style: TextStyle(color: theme.textSecondary, fontSize: 13,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          ...['No llega a rodillas', 'Llega a pies', 'Supera los pies', 'Palmas al suelo']
              .map((opt) => GestureDetector(
                onTap: () => setState(() => _selectedOption = opt),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: _selectedOption == opt
                        ? theme.successText.withValues(alpha: 0.12)
                        : theme.cardDark,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _selectedOption == opt ? theme.successBorder : theme.border,
                      width: _selectedOption == opt ? 1.5 : 1,
                    ),
                  ),
                  child: Row(children: [
                    Expanded(child: Text(opt,
                        style: TextStyle(
                            color: _selectedOption == opt
                                ? theme.successText : theme.text,
                            fontSize: 14,
                            fontWeight: _selectedOption == opt
                                ? FontWeight.w600 : FontWeight.w400))),
                    if (_selectedOption == opt)
                      Icon(Icons.check_circle,
                          color: theme.successText, size: 18),
                  ]),
                ),
              )),
        ]),
      ),
    ] else ...[
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.card, borderRadius: BorderRadius.circular(14)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Ingresa tu resultado en ${_cfg.unit}',
              style: TextStyle(color: theme.textSecondary,
                  fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          TextField(
            controller: _resultCtrl,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(_cfg.unit == 'metros' ? 5 : (_cfg.unit == 'segundos' ? 4 : 3)),
            ],
            style: TextStyle(color: theme.text,
                fontSize: 22, fontWeight: FontWeight.w700),
            decoration: InputDecoration(
              hintText: '0',
              hintStyle: TextStyle(color: theme.textMuted),
              suffixText: _cfg.unit,
              suffixStyle: TextStyle(color: theme.primary, fontSize: 14),
              filled: true, fillColor: theme.cardDark,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: theme.border)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: theme.border)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: theme.primary, width: 1.5)),
            ),
          ),
        ]),
      ),
    ],
    const SizedBox(height: 16),

    SizedBox(
      width: double.infinity, height: 54,
      child: ElevatedButton(
        onPressed: _submitting ? null : _submitResult,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: theme.border,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
        child: _submitting
            ? const SizedBox(width: 22, height: 22,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : const Text('Guardar y continuar',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
      ),
    ),
  ]);


}

// ── Ring Painter ──────────────────────────────────────────────
class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color borderColor;
  final bool finished;
  const _RingPainter({required this.progress, required this.color, required this.borderColor, required this.finished});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 12;
    canvas.drawCircle(center, radius, Paint()
        ..color = borderColor ..style = PaintingStyle.stroke ..strokeWidth = 12);
    if (progress > 0 || finished) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2, (finished ? 1.0 : progress) * 2 * pi, false,
        Paint()
          ..color = color ..style = PaintingStyle.stroke
          ..strokeWidth = 12 ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress || old.color != color || old.borderColor != borderColor;
}
