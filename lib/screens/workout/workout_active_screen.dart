import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../services/cached_http.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import '../../config/app_theme_extension.dart';
import '../../providers/auth_provider.dart';
import 'workout_feedback_screen.dart';
import '../../l10n/app_localizations.dart';


// AppLayout placeholder
class AppLayout {
  static double hPadding(BuildContext context) => 16.0;
}

// Extension for colors — delega en el tema global (claro/oscuro)
extension ContextExt on BuildContext {
  AppColorsHelper get colors => AppColorsHelper(themeColors);
}

class AppColorsHelper {
  final AppThemeExtensionWrapper _t;
  AppColorsHelper(this._t);

  Color get bg => _t.bg;
  Color get card => _t.card;
  Color get cardDarker => _t.cardDark;
  Color get cardDark => _t.cardDark;
  Color get primary => _t.primary;
  Color get successBg => _t.successBg;
  Color get successBorder => _t.successBorder;
  Color get successText => _t.successText;
  Color get errorText => _t.errorText;
  Color get text => _t.text;
  Color get textMuted => _t.textMuted;
  Color get textSecondary => _t.textSecondary;
  Color get disabledBg => _t.disabledBg;
  Color get border => _t.border;
}



// ═══════════════════════════════════════════════════════════════
// WORKOUT ACTIVE SCREEN
// ═══════════════════════════════════════════════════════════════
class WorkoutActiveScreen extends StatefulWidget {
  final Map<String, dynamic>? entrenamiento;
  const WorkoutActiveScreen({super.key, this.entrenamiento});

  @override
  State<WorkoutActiveScreen> createState() => _WorkoutActiveScreenState();
}

class _WorkoutActiveScreenState extends State<WorkoutActiveScreen>
    with TickerProviderStateMixin {

  // ── Modo: null = aún no elegido ─────────────────────────────
  bool? _isExterior = false; // interior por defecto
  bool _modeAsked = false;  // si ya se preguntó el modo para el ejercicio actual

  // ── Estado del workout ──────────────────────────────────────
  _WState _state = _WState.ready;
  Timer? _timer;
  int   _elapsedSecs  = 0;
  double _distanceKm  = 0.0;
  double _speedKmh    = 0.0;

  // ── Ejercicios / pasos ──────────────────────────────────────
  List<Map<String, dynamic>> _pasos = [];
  int _pasoIdx = 0;
  final Set<int> _completedSteps = {};

  // ── Mapa (exterior) ─────────────────────────────────────────
  GoogleMapController? _mapCtrl;
  final List<LatLng> _route = [];
  StreamSubscription<Position>? _posSub;
  LatLng _currentPos = const LatLng(11.0041, -74.8070); // Barranquilla default

  // ── Animación scroll título ──────────────────────────────────
  late AnimationController _scrollAnim;



  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _buildPasos();
    _scrollAnim = AnimationController(
        vsync: this, duration: const Duration(seconds: 6))
      ..repeat();
  }

  void _buildPasos() {
    final rawEjercicios =
        widget.entrenamiento?['ejercicios_asociados'] as List<dynamic>? ?? [];
    if (rawEjercicios.isEmpty) {
      _pasos = [{'nombre': 'Entrenamiento libre', 'tipo': 'LIBRE', 'duracion': 0, 'bloque': ''}];
      return;
    }

    // Ordenar de forma robusta por 'orden' o 'order'
    final ejercicios = List<dynamic>.from(rawEjercicios);
    ejercicios.sort((a, b) {
      final mapA = a is Map ? Map<String, dynamic>.from(a) : <String, dynamic>{};
      final mapB = b is Map ? Map<String, dynamic>.from(b) : <String, dynamic>{};

      final ordA = mapA['orden'] ?? mapA['order'] ?? mapA['ejercicio']?['orden'] ?? mapA['ejercicio']?['order'] ?? 0;
      final ordB = mapB['orden'] ?? mapB['order'] ?? mapB['ejercicio']?['orden'] ?? mapB['ejercicio']?['order'] ?? 0;

      return (int.tryParse(ordA.toString()) ?? 0).compareTo(int.tryParse(ordB.toString()) ?? 0);
    });

    int firstPendingIdx = -1;

    for (int i = 0; i < ejercicios.length; i++) {
      final e = ejercicios[i];
      final asoc = e is Map ? Map<String, dynamic>.from(e) : <String, dynamic>{};
      final ej   = asoc['ejercicio'] as Map<String, dynamic>? ?? <String, dynamic>{};

      final estado = asoc['estado'] as String? ?? '';
      final isHecho = estado == 'completado' || estado == 'completo' || estado == 'done';

      if (isHecho) {
        _completedSteps.add(i);
      } else if (firstPendingIdx == -1) {
        firstPendingIdx = i;
      }

      _pasos.add({
        'id_entrenamiento_ejercicio': asoc['id_entrenamiento_ejercicio']
            ?? asoc['id']
            ?? ej['id_entrenamiento_ejercicio']
            ?? ej['id']
            ?? '',
        'nombre':       ej['nombre']        ?? ej['descripcion'] ?? 'Ejercicio',
        'tipo':         ej['tipo']          ?? '',
        'duracion':     (asoc['duracion_segundos'] as num?)?.toInt() ?? 0,
        'bloque':       asoc['bloque']      ?? ej['tipo']        ?? '',
        'series':       (asoc['series']     as num?)?.toString() ?? '',
        'reps':         asoc['repeticiones']?.toString() ?? '',
        'descripcion':  ej['descripcion']   as String? ?? '',
        'multimedia':   ej['multimedia_url'] as String? ?? '',
        'descanso':     (asoc['descanso_segundos'] as num?)?.toInt() ?? 0,
        'necesita_mapa': ej['necesita_mapa'] as bool? ?? false,
        'instrucciones': ej['instrucciones'] as Map<String, dynamic>?,
        'estado':       estado,
      });
    }

    if (firstPendingIdx != -1) {
      _pasoIdx = firstPendingIdx;
    } else {
      _pasoIdx = 0;
    }
  }

  Map<String, dynamic> get _current =>
      _pasos.isNotEmpty ? _pasos[_pasoIdx] : {};
  Map<String, dynamic>? get _next =>
      _pasoIdx + 1 < _pasos.length ? _pasos[_pasoIdx + 1] : null;

  // ── Timer ───────────────────────────────────────────────────
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        _elapsedSecs++;
        if (_isExterior != true) {
          // Interior: simular velocidad suave
          _speedKmh   = 0;
          _distanceKm = 0;
        }
      });
    });
  }

  void _start() {
    setState(() => _state = _WState.running);
    _startTimer();
  }

  void _pause() {
    _timer?.cancel();
    _posSub?.pause();
    setState(() => _state = _WState.paused);
  }

  void _resume() {
    setState(() => _state = _WState.running);
    _startTimer();
    _posSub?.resume();
  }

  void _markCurrentComplete(int seriesCompletadas) {
    setState(() => _completedSteps.add(_pasoIdx));
    _saveCompletedExercise(_pasoIdx, seriesCompletadas);
  }

  Future<void> _saveCompletedExercise(int index, int seriesCompletadas) async {
    final paso = _pasos[index];
    final idAsoc = paso['id_entrenamiento_ejercicio'] as String? ?? '';
    if (idAsoc.isEmpty) {
      debugPrint('WARNING: No id_entrenamiento_ejercicio found for this step');
      return;
    }
    try {
      final token = context.read<AuthProvider>().token ?? '';
      final body = {
        'ejercicios_completados': [
          {
            'id_entrenamiento_ejercicio': idAsoc,
            'series_completadas': seriesCompletadas,
          },
        ]
      };

      final res = await CachedHttp.post(
        Uri.parse('https://apifitnflai.com/entrenamientos/completar-ejercicio-entrenamiento'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        debugPrint('EXERCISE SAVED SUCCESSFULLY: $idAsoc');
      } else {
        debugPrint('EXERCISE SAVE FAILED: ${res.statusCode} - ${res.body}');
      }
    } catch (e) {
      debugPrint('EXERCISE SAVE ERROR: $e');
    }
  }

  void _nextStep() {
    if (_pasoIdx < _pasos.length - 1) {
      _timer?.cancel();
      if (!_completedSteps.contains(_pasoIdx)) {
        _saveCompletedExercise(_pasoIdx, 0);
      }
      setState(() {
        _completedSteps.add(_pasoIdx);
        _pasoIdx++;
        _elapsedSecs  = 0;
        _modeAsked    = false; // reset para el siguiente ejercicio
        // volver a interior por defecto hasta que se pregunte
        final necesita = _pasos[_pasoIdx]['necesita_mapa'] as bool? ?? false;
        if (!necesita) _isExterior = false;
        if (_state == _WState.running) _startTimer();
      });
    }
  }

  void _finish() {
    _timer?.cancel();
    _posSub?.cancel();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => WorkoutFeedbackScreen(
          entrenamiento: widget.entrenamiento,
          tiempoSecs:    _elapsedSecs,
          distanciaKm:   _distanceKm,
          isExterior:    _isExterior ?? false,
        ),
      ),
    );
  }

  // ── GPS (exterior) ──────────────────────────────────────────
  Future<void> _initGps() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;
    LocationPermission perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
      if (perm == LocationPermission.denied) return;
    }
    if (perm == LocationPermission.deniedForever) return;

    final pos = await Geolocator.getCurrentPosition();
    if (!mounted) return;
    setState(() => _currentPos = LatLng(pos.latitude, pos.longitude));

    _posSub = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 15,
      ),
    ).listen((p) {
      if (!mounted) return;
      final newPos = LatLng(p.latitude, p.longitude);
      setState(() {
        _currentPos = newPos;
        _route.add(newPos);
        _speedKmh   = p.speed * 3.6;
        if (_route.length > 1) {
          _distanceKm += Geolocator.distanceBetween(
            _route[_route.length - 2].latitude,
            _route[_route.length - 2].longitude,
            newPos.latitude,
            newPos.longitude,
          ) / 1000;
        }
      });
      _mapCtrl?.animateCamera(CameraUpdate.newLatLng(newPos));
    });
  }

  // ── Mode selector ────────────────────────────────────────────
  void _selectMode(bool exterior) async {
    final l10n = AppLocalizations.of(context);
    if (exterior) {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!mounted) return;
      if (!serviceEnabled) {
        // GPS is disabled
        setState(() { _isExterior = false; _modeAsked = true; });
        _showGpsMandatoryDialog(l10n.workoutActiveGpsDisabled);
        return;
      }
      LocationPermission perm = await Geolocator.checkPermission();
      if (!mounted) return;
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
        if (!mounted) return;
        if (perm == LocationPermission.denied || perm == LocationPermission.deniedForever) {
          // Permissions denied
          setState(() { _isExterior = false; _modeAsked = true; });
          _showGpsMandatoryDialog(l10n.workoutActiveGpsDenied);
          return;
        }
      } else if (perm == LocationPermission.deniedForever) {
        // Permissions permanently denied
        setState(() { _isExterior = false; _modeAsked = true; });
        _showGpsMandatoryDialog(l10n.workoutActiveGpsDeniedForever);
        return;
      }
    }
    setState(() { _isExterior = exterior; _modeAsked = true; });
    if (exterior) await _initGps();
  }

  void _checkAndAskMode() {
    final necesitaMapa = _current['necesita_mapa'] as bool? ?? false;
    if (necesitaMapa && !_modeAsked) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showModeDialog());
    }
  }

  Future<void> _showModeDialog() async {
    setState(() => _modeAsked = true);
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _ModeSelectorDialog(
        titulo: _current['nombre'] as String? ?? 'Ejercicio',
        onSelect: _selectMode,
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _posSub?.cancel();
    _scrollAnim.dispose();
    _mapCtrl?.dispose();
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Verificar si el ejercicio actual necesita mapa y preguntar modo
    _checkAndAskMode();

    return Scaffold(
      backgroundColor: context.colors.bg,
      body: SafeArea(
        child: Column(children: [
          _buildTopBar(),
          Expanded(
            child: (_isExterior! || (_current['necesita_mapa'] as bool? ?? false))
                ? _ExteriorLayout(
                    state:       _state,
                    current:     _current,
                    next:        _next,
                    elapsed:     _elapsedSecs,
                    distancia:   _distanceKm,
                    velocidad:   _speedKmh,
                    pasoIdx:     _pasoIdx,
                    totalPasos:  _pasos.length,
                    completedSteps: _completedSteps,
                    scrollAnim:  _scrollAnim,
                    route:       _route,
                    currentPos:  _currentPos,
                    showMap:     _isExterior!,
                    onMapCreated: (c) => _mapCtrl = c,
                    onStart:     _start,
                    onPause:     _pause,
                    onResume:    _resume,
                    onComplete:  _markCurrentComplete,
                    onNextStep:  _next != null ? _nextStep : null,
                    onFinish:    _finish,
                    onMyLocationTap: () {
                      _mapCtrl?.animateCamera(CameraUpdate.newLatLng(_currentPos));
                    },
                  )
                : _InteriorLayout(
                    state:       _state,
                    current:     _current,
                    next:        _next,
                    elapsed:     _elapsedSecs,
                    pasoIdx:     _pasoIdx,
                    totalPasos:  _pasos.length,
                    completedSteps: _completedSteps,
                    scrollAnim:  _scrollAnim,
                    onStart:     _start,
                    onPause:     _pause,
                    onResume:    _resume,
                    onComplete:  _markCurrentComplete,
                    onNextStep:  _next != null ? _nextStep : null,
                    onFinish:    _finish,
                  ),
          ),
        ]),
      ),
    );
  }

  Widget _buildTopBar() => Padding(
    padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
    child: Row(children: [
      _IconBtn(
        icon: Icons.arrow_back_ios_new,
        onTap: () {
          if (_state == _WState.running) _pause();
          _showExitDialog();
        },
      ),
      const Spacer(),
      // Badge de modo
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: _isExterior!
              ? context.colors.primary.withValues(alpha: 0.15)
              : context.colors.successBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _isExterior! ? context.colors.primary : context.colors.successBorder,
          ),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(_isExterior! ? Icons.location_on : Icons.fitness_center,
              size: 12,
              color: _isExterior! ? context.colors.primary : context.colors.successText),
          const SizedBox(width: 4),
          Text(_isExterior! ? AppLocalizations.of(context).workoutActiveExterior.toUpperCase() : AppLocalizations.of(context).workoutActiveInterior.toUpperCase(),
              style: TextStyle(
                  color: _isExterior! ? context.colors.primary : context.colors.successText,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5)),
        ]),
      ),
      if (_state != _WState.ready) ...[
        const SizedBox(width: 8),
        _IconBtn(icon: Icons.list_outlined, onTap: _showPasosList),
      ],
    ]),
  );

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: context.colors.cardDarker,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(AppLocalizations.of(context).workoutActiveExitTitle,
            style: TextStyle(color: context.colors.text, fontSize: 16,
                fontWeight: FontWeight.w700)),
        content: Text(AppLocalizations.of(context).workoutActiveExitDesc,
            style: TextStyle(color: context.colors.textMuted, fontSize: 13)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context).workoutActiveExitContinue,
                style: TextStyle(color: context.colors.primary))),
          TextButton(
            onPressed: () {
              _timer?.cancel();
              _posSub?.cancel();
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context).workoutActiveExitBtn,
                style: TextStyle(color: context.colors.errorText))),
          ],
      ),
    );
  }

  void _showPasosList() {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.colors.cardDarker,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(AppLocalizations.of(context).workoutActiveExercises,
                  style: TextStyle(color: context.colors.text, fontSize: 16,
                      fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          ..._pasos.asMap().entries.map((e) {
            final done   = _completedSteps.contains(e.key);
            final active = e.key == _pasoIdx;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(children: [
                Container(
                  width: 28, height: 28,
                  decoration: BoxDecoration(
                    color: done
                        ? context.colors.successBorder.withValues(alpha: 0.2)
                        : active
                            ? context.colors.primary.withValues(alpha: 0.2)
                            : context.colors.disabledBg,
                    shape: BoxShape.circle,
                  ),
                  child: Center(child: done
                      ? Icon(Icons.check, color: context.colors.successText, size: 14)
                      : Text('${e.key + 1}',
                          style: TextStyle(
                              color: active ? context.colors.primary : context.colors.textMuted,
                              fontSize: 12, fontWeight: FontWeight.w700))),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(
                  e.value['nombre'] as String? ?? '',
                  style: TextStyle(
                      color: active ? context.colors.text : context.colors.textMuted,
                      fontSize: 14),
                )),
                if (active)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: context.colors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(AppLocalizations.of(context).workoutActiveNow,
                        style: TextStyle(
                            color: context.colors.primary,
                            fontSize: 10,
                            fontWeight: FontWeight.w700)),
                  ),
              ]),
            );
          }),
        ]),
      ),
    );
  }

  void _showGpsMandatoryDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: context.colors.cardDarker,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(AppLocalizations.of(context).workoutActiveGpsRequired,
            style: TextStyle(color: context.colors.text, fontSize: 16,
                fontWeight: FontWeight.w700)),
        content: Text(message,
            style: TextStyle(color: context.colors.textMuted, fontSize: 13)),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _selectMode(false);
            },
            child: Text(AppLocalizations.of(context).workoutActiveSwitchToIndoor,
                style: TextStyle(color: context.colors.primary))),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Geolocator.openLocationSettings();
            },
            child: Text(AppLocalizations.of(context).workoutActiveGoToSettings,
                style: TextStyle(color: context.colors.errorText))),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// MODE SELECTOR
// ═══════════════════════════════════════════════════════════════
// ═══════════════════════════════════════════════════════════════
// MODE SELECTOR DIALOG — popup cuando necesita_mapa = true
// ═══════════════════════════════════════════════════════════════
class _ModeSelectorDialog extends StatelessWidget {
  final String titulo;
  final void Function(bool exterior) onSelect;
  const _ModeSelectorDialog({required this.titulo, required this.onSelect});

  @override
  Widget build(BuildContext context) => Dialog(
    backgroundColor: context.colors.card,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text('🗺️', style: TextStyle(fontSize: 36)),
        const SizedBox(height: 12),
        Text(titulo,
            textAlign: TextAlign.center,
            style: TextStyle(color: context.colors.text, fontSize: 16,
                fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Text(AppLocalizations.of(context).workoutActiveModeQuestion,
            textAlign: TextAlign.center,
            style: TextStyle(color: context.colors.textMuted, fontSize: 13, height: 1.5)),
        const SizedBox(height: 24),
        Row(children: [
          Expanded(child: OutlinedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              onSelect(false);
            },
            icon: const Icon(Icons.fitness_center, size: 18),
            label: Text(AppLocalizations.of(context).workoutActiveInterior),
            style: OutlinedButton.styleFrom(
              foregroundColor: context.colors.successText,
              side: BorderSide(color: context.colors.successBorder),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          )),
          const SizedBox(width: 12),
          Expanded(child: ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              onSelect(true);
            },
            icon: const Icon(Icons.location_on, size: 18),
            label: Text(AppLocalizations.of(context).workoutActiveExterior),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
          )),
        ]),
      ]),
    ),
  );
}

// ═══════════════════════════════════════════════════════════════
// INTERIOR LAYOUT
// ═══════════════════════════════════════════════════════════════
class _InteriorLayout extends StatefulWidget {
  final _WState state;
  final Map<String, dynamic> current;
  final Map<String, dynamic>? next;
  final int elapsed, pasoIdx, totalPasos;
  final Set<int> completedSteps;
  final AnimationController scrollAnim;
  final VoidCallback onStart, onPause, onResume, onFinish;
  final void Function(int seriesCompletadas) onComplete;
  final VoidCallback? onNextStep;

  const _InteriorLayout({
    required this.state,
    required this.current,
    required this.next,
    required this.elapsed,
    required this.pasoIdx,
    required this.totalPasos,
    required this.completedSteps,
    required this.scrollAnim,
    required this.onStart,
    required this.onPause,
    required this.onResume,
    required this.onComplete,
    required this.onFinish,
    this.onNextStep,
  });

  @override
  State<_InteriorLayout> createState() => _InteriorLayoutState();
}

class _InteriorLayoutState extends State<_InteriorLayout> {
  Set<int> _seriesCompletadas = {};
  int _pasoIdxAnterior = -1;

  int get _totalSeries {
    final s = int.tryParse(widget.current['series']?.toString() ?? '') ?? 0;
    return s > 0 ? s : 3;
  }

  String get _reps => widget.current['reps']?.toString() ?? '';

  String _formatTime(int s) {
    final m = (s ~/ 60).toString().padLeft(2, '0');
    final sec = (s % 60).toString().padLeft(2, '0');
    return '$m:$sec';
  }

  @override
  void didUpdateWidget(_InteriorLayout old) {
    super.didUpdateWidget(old);
    if (widget.pasoIdx != _pasoIdxAnterior) {
      setState(() { _seriesCompletadas = {}; _pasoIdxAnterior = widget.pasoIdx; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final inst = widget.current['instrucciones'] as Map<String, dynamic>?;
    final posInicial = inst?['posicion_inicial'] as String? ?? '';
    final ejecucion = inst?['ejecucion'] as String? ?? '';
    final consejos = inst?['consejos_tecnicos'] as List<dynamic>? ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      const SizedBox(height: 12),
    _StepHeader(current: widget.current, next: widget.next, scrollAnim: widget.scrollAnim),
    const SizedBox(height: 8),
    _ProgressBar(current: widget.pasoIdx, total: widget.totalPasos,
        completedSteps: widget.completedSteps),
    const SizedBox(height: 8),

    // Métricas igual que exterior
    Padding(
      padding: EdgeInsets.symmetric(horizontal: AppLayout.hPadding(context)),
      child: Row(children: [
        _Metric(label: AppLocalizations.of(context).workoutActiveSets,
            value: '${_seriesCompletadas.length} / $_totalSeries'),
        _Metric(label: AppLocalizations.of(context).workoutActiveTimer.toUpperCase(), value: _formatTime(widget.elapsed)),
        _Metric(label: AppLocalizations.of(context).workoutActiveReps, value: _reps.isNotEmpty ? _reps : '—'),
      ]),
    ),
    const SizedBox(height: 8),

    Expanded(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: AppLayout.hPadding(context)),
        child: Column(children: [
          // Card multimedia + descripción
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: context.colors.cardDarker,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: context.colors.disabledBg),
              ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(17)),
                child: (widget.current['multimedia'] as String? ?? '').isNotEmpty
                    ? Image.network(
                        widget.current['multimedia'] as String,
                        width: double.infinity, fit: BoxFit.fitWidth,
                        errorBuilder: (_, __, ___) => _MultimediaPlaceholder(
                            nombre: widget.current['nombre'] as String? ?? '', height: 200),
                      )
                    : _MultimediaPlaceholder(
                        nombre: widget.current['nombre'] as String? ?? '', height: 200),
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  if ((widget.current['descripcion'] as String? ?? '').isNotEmpty) ...[
                    Text(widget.current['descripcion'] as String,
                        style: TextStyle(
                            color: context.colors.textSecondary, fontSize: 13, height: 1.5)),
                  ],
                  if (widget.current['instrucciones'] != null) ...[
                    const SizedBox(height: 10),
                    Divider(color: context.colors.disabledBg, height: 1),
                    const SizedBox(height: 10),

                    if (posInicial.isNotEmpty) ...[
                      Text(AppLocalizations.of(context).workoutActivePosInicial,
                          style: TextStyle(
                              color: context.colors.text,
                              fontSize: 12,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text(posInicial,
                          style: TextStyle(
                              color: context.colors.textSecondary,
                              fontSize: 12,
                              height: 1.45)),
                      const SizedBox(height: 10),
                    ],
                    if (ejecucion.isNotEmpty) ...[
                      Text(AppLocalizations.of(context).workoutActiveEjecucion,
                          style: TextStyle(
                              color: context.colors.text,
                              fontSize: 12,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text(ejecucion,
                          style: TextStyle(
                              color: context.colors.textSecondary,
                              fontSize: 12,
                              height: 1.45)),
                      const SizedBox(height: 10),
                    ],
                    if (consejos.isNotEmpty) ...[
                      Text(AppLocalizations.of(context).workoutActiveConsejos,
                          style: TextStyle(
                              color: context.colors.text,
                              fontSize: 12,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      ...consejos.map((consejo) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('• ',
                                style: TextStyle(
                                    color: context.colors.primary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold)),
                            Expanded(
                              child: Text(consejo.toString(),
                                  style: TextStyle(
                                      color: context.colors.textSecondary,
                                      fontSize: 12,
                                      height: 1.45)),
                            ),
                          ],
                        ),
                      )),
                    ],
                  ],
                ]),
              ),
            ]),
          ),

          const SizedBox(height: 12),

          // Card de series
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: context.colors.card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: context.colors.disabledBg),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(AppLocalizations.of(context).workoutActiveSets, style: TextStyle(
                  color: context.colors.primary, fontSize: 11,
                  fontWeight: FontWeight.w700, letterSpacing: 0.8)),
              const SizedBox(height: 10),
              ...List.generate(_totalSeries, (i) {
                final done = _seriesCompletadas.contains(i);
                return GestureDetector(
                  onTap: () => setState(() {
                    done ? _seriesCompletadas.remove(i)
                         : _seriesCompletadas.add(i);
                  }),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: done
                          ? context.colors.successBorder.withValues(alpha: 0.12)
                          : context.colors.cardDarker,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: done ? context.colors.successBorder : context.colors.border,
                        width: done ? 1.5 : 1,
                      ),
                    ),
                    child: Row(children: [
                      Container(
                        width: 24, height: 24,
                        decoration: BoxDecoration(
                          color: done
                              ? context.colors.successBorder.withValues(alpha: 0.2)
                              : context.colors.disabledBg,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: done ? context.colors.successText : context.colors.textMuted,
                          ),
                        ),
                      child: done
                          ? Icon(Icons.check,
                              color: context.colors.successText, size: 14)
                          : Center(child: Text('${i + 1}',
                              style: TextStyle(
                                  color: context.colors.textMuted,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600))),
                      ),
                      const SizedBox(width: 12),
                    Text(AppLocalizations.of(context).workoutActiveSetLabel(i + 1),
                        style: TextStyle(
                            color: done ? context.colors.successText : context.colors.text,
                            fontSize: 14,
                            fontWeight: done ? FontWeight.w600 : FontWeight.w400)),
                    const Spacer(),
                    if (_reps.isNotEmpty)
                      Text(_reps.contains('rep') ? _reps : AppLocalizations.of(context).statsRepsCount(int.tryParse(_reps) ?? 0),
                          style: TextStyle(
                              color: done ? context.colors.successText : context.colors.textMuted,
                              fontSize: 13)),
                    ]),
                  ),
                );
              }),
            ]),
          ),

          const SizedBox(height: 12),
        ]),
      ),
    ),

    _WorkoutControls(
      state:                   widget.state,
      onStart:                 widget.onStart,
      onPause:                 widget.onPause,
      onResume:                widget.onResume,
      onComplete:              () => widget.onComplete(_seriesCompletadas.length),
      onNextStep:              widget.onNextStep,
      onFinish:                widget.onFinish,
      isCurrent:               widget.completedSteps.contains(widget.pasoIdx),
      isLastStep:              widget.onNextStep == null,
      todasSeriesCompletadas:  _seriesCompletadas.length >= _totalSeries,
    ),
  ]);
  }
}

// ═══════════════════════════════════════════════════════════════
// EXTERIOR LAYOUT
// ═══════════════════════════════════════════════════════════════
class _ExteriorLayout extends StatelessWidget {
  final _WState state;
  final Map<String, dynamic> current;
  final Map<String, dynamic>? next;
  final int elapsed, pasoIdx, totalPasos;
  final Set<int> completedSteps;
  final AnimationController scrollAnim;
  final List<LatLng> route;
  final LatLng currentPos;
  final void Function(GoogleMapController) onMapCreated;
  final VoidCallback onStart, onPause, onResume, onFinish;
  final void Function(int seriesCompletadas) onComplete;
  final VoidCallback? onNextStep;
  final double distancia, velocidad;
  final bool showMap;
  final VoidCallback onMyLocationTap;

  const _ExteriorLayout({
    required this.state,
    required this.current,
    required this.next,
    required this.elapsed,
    required this.pasoIdx,
    required this.totalPasos,
    required this.completedSteps,
    required this.scrollAnim,
    required this.route,
    required this.currentPos,
    required this.onMapCreated,
    required this.onStart,
    required this.onPause,
    required this.onResume,
    required this.onComplete,
    required this.onFinish,
    this.onNextStep,
    required this.distancia,
    required this.velocidad,
    this.showMap = true,
    required this.onMyLocationTap,
  });

  @override
  Widget build(BuildContext context) {
    final inst = current['instrucciones'] as Map<String, dynamic>?;
    final posInicial = inst?['posicion_inicial'] as String? ?? '';
    final ejecucion = inst?['ejecucion'] as String? ?? '';
    final consejos = inst?['consejos_tecnicos'] as List<dynamic>? ?? [];

    return Column(children: [
      const SizedBox(height: 8),
    _StepHeader(current: current, next: next, scrollAnim: scrollAnim),
    const SizedBox(height: 8),
    _ProgressBar(current: pasoIdx, total: totalPasos,
        completedSteps: completedSteps),
    const SizedBox(height: 10),

    // Métricas
    _MetricsRow(distancia: distancia, velocidad: velocidad, elapsed: elapsed),
    const SizedBox(height: 10),

    // Card ejercicio + mapa scrollable
    Expanded(
      child: SingleChildScrollView(
        child: Column(children: [
          // Mapa primero (solo si showMap)
          if (showMap) ...[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppLayout.hPadding(context)),
            child: SizedBox(
              height: 240,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Stack(children: [
                    GoogleMap(
                      onMapCreated: onMapCreated,
                      initialCameraPosition: CameraPosition(
                          target: currentPos, zoom: 16),
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      mapType: MapType.normal,
                      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                        Factory<OneSequenceGestureRecognizer>(
                              () => EagerGestureRecognizer(),
                        ),
                      },
                    polylines: route.length > 1
                        ? {Polyline(
                            polylineId: const PolylineId('route'),
                            points: route,
                            color: context.colors.primary,
                            width: 4,
                          )}
                        : {},
                    zoomControlsEnabled: false,
                  ),
                  Positioned(
                    right: 12, bottom: 12,
                    child: GestureDetector(
                      onTap: onMyLocationTap,
                      child: Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.8),
                          shape: BoxShape.circle,
                          border: Border.all(color: context.colors.border),
                        ),
                        child: const Icon(Icons.my_location,
                            color: Colors.white, size: 18),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ),
          const SizedBox(height: 10),
          ],

          // Card ejercicio debajo
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppLayout.hPadding(context)),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: context.colors.card,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: context.colors.disabledBg),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                if (!showMap)
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
                    child: (current['multimedia'] as String? ?? '').isNotEmpty
                        ? Image.network(
                            current['multimedia'] as String,
                            width: double.infinity, fit: BoxFit.fitWidth,
                            errorBuilder: (_, __, ___) => _MultimediaPlaceholder(
                                nombre: current['nombre'] as String? ?? '', height: 160),
                          )
                        : _MultimediaPlaceholder(
                            nombre: current['nombre'] as String? ?? '', height: 160),
                  ),
                if ((current['descripcion'] as String? ?? '').isNotEmpty || current['instrucciones'] != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if ((current['descripcion'] as String? ?? '').isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(current['descripcion'] as String,
                                style: TextStyle(
                                    color: context.colors.textSecondary, fontSize: 12, height: 1.4)),
                          ),
                          if (current['instrucciones'] != null) ...[
                            if (posInicial.isNotEmpty) ...[
                            Text(AppLocalizations.of(context).workoutActivePosInicial,
                                style: TextStyle(
                                    color: context.colors.text,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700)),
                            const SizedBox(height: 2),
                            Text(posInicial,
                                style: TextStyle(
                                    color: context.colors.textSecondary,
                                    fontSize: 11,
                                    height: 1.35)),
                            const SizedBox(height: 8),
                          ],
                          if (ejecucion.isNotEmpty) ...[
                            Text(AppLocalizations.of(context).workoutActiveEjecucion,
                                style: TextStyle(
                                    color: context.colors.text,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700)),
                            const SizedBox(height: 2),
                            Text(ejecucion,
                                style: TextStyle(
                                    color: context.colors.textSecondary,
                                    fontSize: 11,
                                    height: 1.35)),
                            const SizedBox(height: 8),
                          ],
                          if (consejos.isNotEmpty) ...[
                            Text(AppLocalizations.of(context).workoutActiveConsejos,
                                style: TextStyle(
                                    color: context.colors.text,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700)),
                            const SizedBox(height: 4),
                            ...consejos.map((consejo) => Padding(
                              padding: const EdgeInsets.only(bottom: 3),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('• ',
                                      style: TextStyle(
                                          color: context.colors.primary,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold)),
                                  Expanded(
                                    child: Text(consejo.toString(),
                                        style: TextStyle(
                                            color: context.colors.textSecondary,
                                            fontSize: 11,
                                            height: 1.35)),
                                  ),
                                ],
                              ),
                            )),
                          ],
                        ],
                      ],
                    ),
                  ),
              ]),
            ),
          ),
          const SizedBox(height: 10),
        ]),
      ),
    ),

    // Controles fijos abajo
    _WorkoutControls(
      state:       state,
      onStart:     onStart,
      onPause:     onPause,
      onResume:    onResume,
      onComplete:  () => onComplete(0),
      onNextStep:  onNextStep,
      onFinish:    onFinish,
      isCurrent:   completedSteps.contains(pasoIdx),
      isLastStep:  onNextStep == null,
    ),
  ]);
}
}

// ═══════════════════════════════════════════════════════════════
// WORKOUT CONTROLS
// ═══════════════════════════════════════════════════════════════
class _WorkoutControls extends StatelessWidget {
  final _WState state;
  final VoidCallback onStart, onPause, onResume, onComplete, onFinish;
  final VoidCallback? onNextStep;
  final bool isCurrent, isLastStep;
  final bool todasSeriesCompletadas;

  const _WorkoutControls({
    required this.state,
    required this.onStart,
    required this.onPause,
    required this.onResume,
    required this.onComplete,
    required this.onFinish,
    this.onNextStep,
    required this.isCurrent,
    required this.isLastStep,
    this.todasSeriesCompletadas = true,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(AppLayout.hPadding(context), 16, 16, 16),
    child: Column(mainAxisSize: MainAxisSize.min, children: [

      if (state == _WState.ready) ...[
        SizedBox(
          width: double.infinity, height: 56,
          child: ElevatedButton.icon(
            onPressed: onStart,
            icon: const Icon(Icons.play_arrow, size: 22),
            label: Text(AppLocalizations.of(context).workoutActiveStartBtn,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28)),
                    elevation: 0,
                  ),
          ),
        ),
      ],

      if (state == _WState.running || state == _WState.paused) ...[
        // Marcar completado + Siguiente
        Row(children: [
          // Marcar completado
          Expanded(
            child: SizedBox(
              height: 46,
              child: OutlinedButton.icon(
                onPressed: isCurrent ? null : (!todasSeriesCompletadas ? null : onComplete),
                icon: Icon(
                  isCurrent ? Icons.check_circle : Icons.check_circle_outline,
                  size: 16,
                ),
                label: Text(
                  isCurrent ? AppLocalizations.of(context).workoutActiveCompleted
                      : !todasSeriesCompletadas ? AppLocalizations.of(context).workoutActiveCompleteSets
                      : AppLocalizations.of(context).workoutActiveMarkDone,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: isCurrent
                      ? context.colors.successText : context.colors.text,
                  side: BorderSide(
                    color: isCurrent
                        ? context.colors.successBorder : context.colors.border,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(23)),
                ),
              ),
            ),
          ),
          if (onNextStep != null) ...[
            const SizedBox(width: 8),
            Expanded(
              child: SizedBox(
                height: 46,
                child: OutlinedButton.icon(
                  onPressed: isCurrent ? onNextStep : null,
                  icon: const Icon(Icons.skip_next_outlined, size: 16),
                  label: Text(AppLocalizations.of(context).workoutActiveNext,
                      style: const TextStyle(fontSize: 13,
                          fontWeight: FontWeight.w600)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: context.colors.text,
                    side: BorderSide(color: context.colors.border),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(23)),
                  ),
                ),
              ),
            ),
          ],
        ]),
        const SizedBox(height: 10),

        // Pausar / Reanudar  +  Terminar
        Row(children: [
          if (state == _WState.running)
            Expanded(
              child: SizedBox(
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: onPause,
                  icon: const Icon(Icons.pause, size: 20),
                  label: Text(AppLocalizations.of(context).workoutActivePause,
                      style: const TextStyle(fontSize: 15,
                          fontWeight: FontWeight.w700)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.cardDark,
                    foregroundColor: context.colors.text,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28)),
                    elevation: 0,
                  ),
                ),
              ),
            ),
          if (state == _WState.paused) ...[
            Expanded(
              child: SizedBox(
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: onResume,
                  icon: const Icon(Icons.play_arrow, size: 20),
                  label: Text(AppLocalizations.of(context).workoutActiveResume,
                      style: const TextStyle(fontSize: 15,
                          fontWeight: FontWeight.w700)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.cardDark,
                    foregroundColor: context.colors.text,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28)),
                    elevation: 0,
                  ),
                ),
              ),
            ),
          ],

          const SizedBox(width: 10),

          // Terminar (long press en pausa; tap si es último paso y completado)
          GestureDetector(
            onLongPress: state == _WState.paused ? onFinish : null,
            onTap: (isLastStep && isCurrent) ? onFinish : null,
              child: Container(
                width: 56, height: 56,
                decoration: BoxDecoration(
                  color: context.colors.successBg,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: context.colors.successBorder),
                ),
                child: Icon(Icons.flag_outlined,
                    color: context.colors.successText, size: 22),
              ),
          ),
        ]),

        if (state == _WState.paused)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              isLastStep && isCurrent
                  ? AppLocalizations.of(context).workoutActiveTapFinish
                  : AppLocalizations.of(context).workoutActiveHoldFinish,
              style: TextStyle(
                  color: context.colors.textSecondary, fontSize: 11),
            ),
          ),
      ],
    ]),
  );
}

// ═══════════════════════════════════════════════════════════════
// STEP HEADER
// ═══════════════════════════════════════════════════════════════
class _StepHeader extends StatelessWidget {
  final Map<String, dynamic> current;
  final Map<String, dynamic>? next;
  final AnimationController scrollAnim;
  const _StepHeader({required this.current, required this.next,
      required this.scrollAnim});

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(horizontal: AppLayout.hPadding(context)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('ACTUAL',
          style: TextStyle(color: context.colors.textMuted, fontSize: 11,
              fontWeight: FontWeight.w600, letterSpacing: 1)),
      const SizedBox(height: 2),
      AnimatedBuilder(
        animation: scrollAnim,
        builder: (_, __) => Text(
          (current['nombre'] as String? ?? '').toUpperCase(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              color: context.colors.primary, fontSize: 20,
              fontWeight: FontWeight.w900, letterSpacing: -0.5),
        ),
      ),
      if (next != null) ...[
        const SizedBox(height: 2),
        Text('SIGUIENTE',
            style: TextStyle(color: context.colors.textMuted, fontSize: 9,
                fontWeight: FontWeight.w600, letterSpacing: 1)),
        Text(
          (next!['nombre'] as String? ?? '').toUpperCase(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              color: context.colors.textSecondary, fontSize: 11,
              fontWeight: FontWeight.w600),
        ),
      ],
    ]),
  );
}

// ═══════════════════════════════════════════════════════════════
// METRICS ROW
// ═══════════════════════════════════════════════════════════════
class _MetricsRow extends StatelessWidget {
  final double distancia, velocidad;
  final int elapsed;
  const _MetricsRow({required this.distancia, required this.velocidad,
      required this.elapsed});

  String get _time {
    final m = (elapsed ~/ 60).toString().padLeft(2, '0');
    final s = (elapsed % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(horizontal: AppLayout.hPadding(context)),
    child: Row(children: [
      _Metric(label: AppLocalizations.of(context).workoutActiveDist.toUpperCase(), value: '${distancia.toStringAsFixed(2)} KM'),
      _Metric(label: AppLocalizations.of(context).workoutActiveTimer.toUpperCase(),    value: _time),
      _Metric(label: AppLocalizations.of(context).workoutActiveSpeed, value: '${velocidad.toStringAsFixed(1)} KM/H'),
    ]),
  );
}

class _Metric extends StatelessWidget {
  final String label, value;
  const _Metric({required this.label, required this.value});
  @override
  Widget build(BuildContext context) => Expanded(
    child: Column(children: [
      Text(label, style: TextStyle(
          color: context.colors.textSecondary, fontSize: 9,
          fontWeight: FontWeight.w600, letterSpacing: 0.5)),
      const SizedBox(height: 2),
      Text(value, style: TextStyle(
          color: context.colors.text, fontSize: 16, fontWeight: FontWeight.w800)),
    ]),
  );
}

// ═══════════════════════════════════════════════════════════════
// PROGRESS BAR
// ═══════════════════════════════════════════════════════════════
class _ProgressBar extends StatelessWidget {
  final int current, total;
  final Set<int> completedSteps;
  const _ProgressBar({required this.current, required this.total,
      required this.completedSteps});

  @override
  Widget build(BuildContext context) {
    final count = total.clamp(1, 20);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppLayout.hPadding(context)),
      child: Row(
        children: List.generate(count, (i) => Expanded(
          child: Container(
            height: 3,
            margin: const EdgeInsets.symmetric(horizontal: 1.5),
            decoration: BoxDecoration(
              color: completedSteps.contains(i)
                  ? context.colors.successBorder
                  : i == current
                      ? context.colors.primary
                      : context.colors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        )),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// ICON BUTTON
// ═══════════════════════════════════════════════════════════════
class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconBtn({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: context.colors.cardDarker,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colors.border),
      ),
      child: Icon(icon, color: context.colors.text, size: 18),
    ),
  );
}

enum _WState { ready, running, paused }

class _MultimediaPlaceholder extends StatelessWidget {
  final String nombre;
  final double height;
  const _MultimediaPlaceholder({required this.nombre, this.height = 160});
  @override
  Widget build(BuildContext context) => Container(
    height: height, width: double.infinity,
    color: context.colors.cardDarker,
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(Icons.play_circle_outline, color: context.colors.border, size: 48),
      const SizedBox(height: 8),
      Text('Vista previa no disponible',
          style: TextStyle(color: context.colors.textMuted, fontSize: 12)),
    ]),
  );
}