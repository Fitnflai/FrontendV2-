import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/app_theme_extension.dart';
import '../../models/activity_detail.dart';
import '../../providers/auth_provider.dart';
import '../../services/activity_analytics_service.dart';
import 'widgets/analytics/activity_best_efforts_card.dart';
import 'widgets/analytics/activity_hr_zones_card.dart';
import 'widgets/analytics/activity_kpi_grid.dart';
import 'widgets/analytics/activity_laps_chart.dart';
import 'widgets/analytics/activity_map_header.dart';
import 'widgets/analytics/activity_splits_list.dart';
import 'widgets/analytics/activity_telemetry_chart.dart';

class ActivityAnalyticsScreen extends StatefulWidget {
  final String activityId;
  final ActivityDetail? initialActivity;
  final Map<String, dynamic>? workoutData;
  final Map<String, dynamic>? selectedExercise;
  final int? exerciseIndex;
  final bool isSingleExerciseMode;
  final String? badgeText;

  const ActivityAnalyticsScreen({
    super.key,
    required this.activityId,
    this.initialActivity,
    this.workoutData,
    this.selectedExercise,
    this.exerciseIndex,
    this.isSingleExerciseMode = false,
    this.badgeText,
  });

  @override
  State<ActivityAnalyticsScreen> createState() => _ActivityAnalyticsScreenState();
}

class _ActivityAnalyticsScreenState extends State<ActivityAnalyticsScreen> {
  final ActivityAnalyticsService _service = ActivityAnalyticsService();
  late ActivityDetail _activity;
  bool _isLoading = false;
  String? _noticeBanner;
  List<Map<String, dynamic>> _exercises = [];

  bool get _isExerciseMode => widget.isSingleExerciseMode && widget.selectedExercise != null;

  @override
  void initState() {
    super.initState();
    _activity = widget.initialActivity ??
        ActivityDetail.empty(
          title: widget.workoutData?['nombre'] as String? ??
              widget.workoutData?['titulo'] as String? ??
              'Resumen de actividad',
        );

    _initExercises();

    if (widget.initialActivity == null) {
      _loadActivity();
    } else {
      _checkBanner();
    }
  }

  void _checkBanner() {
    if (_isExerciseMode) {
      _noticeBanner = null;
      return;
    }

    final hasGps = _activity.summary.distanceMeters > 0 ||
        _activity.routePoints.isNotEmpty ||
        _activity.telemetry.isNotEmpty;

    if (!hasGps) {
      _noticeBanner =
          'Aún no hay datos de telemetría o GPS grabados para esta sesión.\nCompletala usando el tracking en vivo del móvil o sincronizá tu reloj Garmin para ver las curvas y mapas reales.';
    } else {
      _noticeBanner = null;
    }
  }

  Future<void> _initExercises() async {
    final parsed = _extractExercisesFromMap(widget.workoutData);
    if (parsed.isNotEmpty) {
      setState(() {
        _exercises = parsed;
      });
      return;
    }

    // Try loading from local storage cache
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'workout_exercises_${widget.activityId}';
      final cachedJson = prefs.getString(key);
      if (cachedJson != null) {
        final decoded = (json.decode(cachedJson) as List<dynamic>?)
            ?.map((e) => Map<String, dynamic>.from(e as Map))
            .toList();
        if (decoded != null && decoded.isNotEmpty && mounted) {
          setState(() {
            _exercises = decoded;
          });
        }
      }
    } catch (e) {
      debugPrint('🚨 Error loading cached exercises: $e');
    }
  }

  List<Map<String, dynamic>> _extractExercisesFromMap(Map<String, dynamic>? data) {
    if (data == null) return const [];
    final raw = data['ejercicios_asociados'] as List<dynamic>? ??
        data['ejercicios'] as List<dynamic>? ??
        const [];
    final list = <Map<String, dynamic>>[];

    for (final e in raw) {
      if (e is! Map) continue;
      final mapE = Map<String, dynamic>.from(e);
      final ej = mapE['ejercicio'] is Map
          ? Map<String, dynamic>.from(mapE['ejercicio'] as Map)
          : mapE;

      final nombre = ej['nombre'] ?? ej['descripcion'] ?? 'Ejercicio';
      final tipo = ej['tipo'] ?? ej['tipo_movimiento'] ?? mapE['bloque'] ?? '';
      final series = (mapE['series'] ?? ej['series'])?.toString() ?? '';
      final reps = (mapE['repeticiones'] ?? mapE['reps'] ?? ej['repeticiones'] ?? ej['reps'])?.toString() ?? '';
      final durSeg = int.tryParse((mapE['duracion_segundos'] ?? ej['duracion_segundos'] ?? '').toString()) ?? 0;
      final durMin = (mapE['duracion_minutos'] ?? ej['duracion_minutos'])?.toString() ??
          (durSeg > 0 ? '${(durSeg / 60).round()} min' : '');
      final descansoSeg = int.tryParse((mapE['descanso_segundos'] ?? ej['descanso_segundos'] ?? '').toString()) ?? 0;
      final peso = (mapE['peso_objetivo'] ?? ej['peso_objetivo'] ?? mapE['peso'])?.toString() ?? '';
      final descripcion = (ej['descripcion'] ?? mapE['descripcion']) as String? ?? '';

      list.add({
        'nombre': nombre,
        'tipo': tipo,
        'series': series,
        'reps': reps,
        'dur': durMin,
        'dur_seg': durSeg,
        'descanso_seg': descansoSeg,
        'peso': peso,
        'descripcion': descripcion,
      });
    }

    return list;
  }

  Future<void> _loadActivity() async {
    if (widget.activityId.trim().isEmpty) {
      setState(() {
        _activity = ActivityDetail.empty(
          title: widget.workoutData?['nombre'] as String? ??
              widget.workoutData?['titulo'] as String? ??
              'Resumen de actividad',
        );
        _isLoading = false;
        _checkBanner();
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final auth = context.read<AuthProvider>();
      final userId = auth.user?.id.toString() ?? '';
      final token = auth.token ?? '';

      debugPrint('🔍 [ActivityAnalyticsScreen] Fetching activityId: "${widget.activityId}", userId: "$userId"');

      final data = await _service.getActivityAnalytics(
        activityId: widget.activityId,
        userId: userId,
        token: token,
      );

      if (mounted) {
        setState(() {
          _activity = data;
          _isLoading = false;
          _checkBanner();
        });
      }
    } catch (e) {
      debugPrint('🚨 [ActivityAnalyticsScreen] Error loading activity: $e');
      if (mounted) {
        setState(() {
          _activity = ActivityDetail.empty(
            title: widget.workoutData?['nombre'] as String? ??
                widget.workoutData?['titulo'] as String? ??
                'Resumen de actividad',
          );
          _isLoading = false;
          _checkBanner();
        });
      }
    }
  }

  String _formatPace(double paceSec) {
    if (paceSec <= 0) return '--:--';
    final mins = (paceSec / 60).floor();
    final secs = (paceSec % 60).round();
    return '$mins:${secs.toString().padLeft(2, '0')}/km';
  }

  ActivityLap? _getExerciseLap() {
    if (_activity.laps.isEmpty || widget.exerciseIndex == null) return null;
    if (widget.exerciseIndex! < _activity.laps.length) {
      return _activity.laps[widget.exerciseIndex!];
    }
    return _activity.laps.first;
  }

  List<RoutePoint> _getExerciseRoutePoints(bool isCardio) {
    if (_activity.routePoints.isEmpty || !isCardio) return const [];
    if (_exercises.isEmpty || widget.exerciseIndex == null) return _activity.routePoints;

    final cardioExercises = _exercises.where((e) {
      final t = (e['tipo'] ?? e['bloque'] ?? '').toString().toUpperCase();
      return t.contains('CARDIO') || t.contains('CARRERA') || t.contains('CICLISMO') || t.contains('VELOCIDAD');
    }).toList();

    if (cardioExercises.isEmpty) return _activity.routePoints;

    final targetName = widget.selectedExercise?['nombre'];
    final cardioIdx = cardioExercises.indexWhere((e) => e['nombre'] == targetName);
    if (cardioIdx == -1) return _activity.routePoints;

    final total = _activity.routePoints.length;
    final chunk = (total / cardioExercises.length).ceil();
    final start = (cardioIdx * chunk).clamp(0, total - 1);
    final end = ((cardioIdx + 1) * chunk).clamp(0, total);

    if (end > start) {
      return _activity.routePoints.sublist(start, end);
    }
    return _activity.routePoints;
  }

  Color _badgeColor(String tipo) {
    final t = tipo.toUpperCase();
    if (t.contains('FUERZA')) return const Color(0xFFB05A30);
    if (t.contains('CARDIO') || t.contains('CARRERA')) return const Color(0xFFD97B4A);
    if (t.contains('MOVILIDAD')) return const Color(0xFF2E9E6B);
    if (t.contains('CICLISMO') || t.contains('BIKE')) return const Color(0xFF007DC3);
    return const Color(0xFFFF6B35);
  }

  IconData _disciplineIcon(String tipo) {
    final t = tipo.toUpperCase();
    if (t.contains('FUERZA')) return Icons.fitness_center_rounded;
    if (t.contains('CARDIO') || t.contains('CARRERA')) return Icons.directions_run_outlined;
    if (t.contains('MOVILIDAD')) return Icons.self_improvement_rounded;
    if (t.contains('CICLISMO')) return Icons.directions_bike_outlined;
    return Icons.sports_gymnastics_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;

    final String appBarTitle = _isExerciseMode
        ? (widget.selectedExercise?['nombre'] as String? ?? 'Detalle del ejercicio')
        : _activity.title;

    return Scaffold(
      backgroundColor: theme.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: theme.text, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          appBarTitle,
          style: TextStyle(
            color: theme.text,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: theme.text),
            tooltip: 'Actualizar métricas',
            onPressed: _isLoading ? null : _loadActivity,
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: theme.text),
            onPressed: () {},
          ),
        ],
      ),
      body: _buildBody(theme),
    );
  }

  Widget _buildBody(AppThemeExtensionWrapper theme) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(color: theme.primary),
      );
    }

    if (_isExerciseMode) {
      return _buildExerciseAnalytics(theme);
    }

    return _buildGeneralSessionAnalytics(theme);
  }

  // ═══════════════════════════════════════════════════════════════
  // 1. MODO: ANALÍTICA ESPECÍFICA DEL EJERCICIO
  // ═══════════════════════════════════════════════════════════════
  Widget _buildExerciseAnalytics(AppThemeExtensionWrapper theme) {
    final ej = widget.selectedExercise!;
    final nombre = ej['nombre'] as String? ?? 'Ejercicio';
    final rawTipo = (widget.badgeText ?? ej['tipo'] ?? ej['bloque'] ?? '').toString().toUpperCase();

    final isFuerza = rawTipo.contains('FUERZA');
    final isCardio = rawTipo.contains('CARDIO') ||
        rawTipo.contains('CARRERA') ||
        rawTipo.contains('CICLISMO') ||
        rawTipo.contains('VELOCIDAD');
    final isMovilidad = rawTipo.contains('MOVILIDAD');

    final color = _badgeColor(rawTipo);
    final icon = _disciplineIcon(rawTipo);
    final lap = _getExerciseLap();
    final routePoints = _getExerciseRoutePoints(isCardio);

    return RefreshIndicator(
      color: theme.primary,
      backgroundColor: theme.cardDark,
      onRefresh: _loadActivity,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        child: Column(
          children: [
            // Header: Mapa si es Cardio con ruta, o Hero Card elegante si es Fuerza/Movilidad
            if (isCardio && routePoints.isNotEmpty)
              ActivityMapHeader(
                activity: ActivityDetail(
                  id: _activity.id,
                  title: nombre,
                  workoutType: rawTipo,
                  date: _activity.date,
                  summary: _activity.summary,
                  routePoints: routePoints,
                ),
                onShare: () {},
              )
            else
              _buildExerciseHeroHeader(theme, color, icon, nombre, rawTipo),

            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // Disciplina específica KPIs
                  if (isFuerza)
                    _buildStrengthKpiCard(theme, ej, color)
                  else if (isCardio)
                    _buildCardioKpiCard(theme, ej, lap, color)
                  else
                    _buildMobilityKpiCard(theme, ej, color),

                  // Tarjeta de descripción técnica / notas si existe
                  if ((ej['descripcion'] as String? ?? '').trim().isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _buildInstructionCard(theme, ej['descripcion'] as String),
                  ],

                  // Telemetría si es Cardio y hay ritmo objetivo vs real
                  if (isCardio && lap != null && lap.actualPaceSecPerKm > 0) ...[
                    const SizedBox(height: 16),
                    ActivityLapsChart(
                      laps: [lap],
                      selectedLapOrder: lap.lapOrder,
                    ),
                  ],

                  // Zonas cardíacas si hubo telemetría de FC en la sesión
                  if (_activity.hrZones.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    ActivityHrZonesCard(zones: _activity.hrZones),
                  ],

                  const SizedBox(height: 24),

                  // Botón al pie para saltar a la sesión general si se desea
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ActivityAnalyticsScreen(
                              activityId: widget.activityId,
                              workoutData: widget.workoutData,
                              isSingleExerciseMode: false,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.analytics_outlined, size: 18),
                      label: const Text(
                        'Ver analítica general de toda la sesión',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: theme.text,
                        side: BorderSide(color: theme.border.withValues(alpha: 0.6)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseHeroHeader(
    AppThemeExtensionWrapper theme,
    Color color,
    IconData icon,
    String nombre,
    String rawTipo,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      decoration: BoxDecoration(
        color: theme.cardDark,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
        border: Border(bottom: BorderSide(color: theme.border.withValues(alpha: 0.4))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 28, color: color),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        rawTipo.isNotEmpty ? rawTipo : 'EJERCICIO',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.6,
                          color: color,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      nombre,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: theme.text,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.calendar_today_outlined, size: 14, color: theme.textMuted),
              const SizedBox(width: 6),
              Text(
                'Sesión del día',
                style: TextStyle(fontSize: 12, color: theme.textMuted),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check, size: 12, color: Color(0xFF4CAF50)),
                    SizedBox(width: 4),
                    Text(
                      'COMPLETADO',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStrengthKpiCard(
    AppThemeExtensionWrapper theme,
    Map<String, dynamic> ej,
    Color color,
  ) {
    final series = ej['series']?.toString() ?? '1';
    final reps = ej['reps']?.toString() ?? ej['repeticiones']?.toString() ?? '1';
    final descanso = ej['descanso_seg'] ?? ej['descanso_segundos'] ?? 60;
    final pesoStr = ej['peso']?.toString() ?? '';

    final numSeries = int.tryParse(series) ?? 1;
    final numReps = int.tryParse(reps) ?? 1;
    final numPeso = double.tryParse(pesoStr) ?? 0.0;
    final totalVolumen = numSeries * numReps * (numPeso > 0 ? numPeso : 0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.border.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'RENDIMIENTO DE FUERZA',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  color: theme.textMuted,
                ),
              ),
              const Spacer(),
              Icon(Icons.fitness_center, size: 16, color: color),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _KpiBox(
                  label: 'SERIES × REPS',
                  value: '$series × $reps',
                  theme: theme,
                ),
              ),
              Expanded(
                child: _KpiBox(
                  label: 'PESO / CARGA',
                  value: numPeso > 0 ? '${numPeso.toStringAsFixed(0)} kg' : 'Corporal',
                  theme: theme,
                ),
              ),
              Expanded(
                child: _KpiBox(
                  label: 'VOLUMEN CARGA',
                  value: totalVolumen > 0
                      ? '${totalVolumen.toStringAsFixed(0)} kg'
                      : '${numSeries * numReps} reps',
                  theme: theme,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Divider(color: theme.border.withValues(alpha: 0.3), height: 1),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _KpiBox(
                  label: 'DESCANSO PLANIFICADO',
                  value: '${descanso}s',
                  prefixIcon: Icons.timer_outlined,
                  theme: theme,
                ),
              ),
              Expanded(
                child: _KpiBox(
                  label: 'TUT ESTIMADO',
                  value: '${numReps * 3}s / serie',
                  theme: theme,
                ),
              ),
              Expanded(
                child: _KpiBox(
                  label: 'PULSO DE ESFUERZO',
                  value: _activity.summary.avgHeartRate > 0
                      ? '${_activity.summary.avgHeartRate} bpm'
                      : '-- bpm',
                  prefixIcon: Icons.favorite_border,
                  theme: theme,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardioKpiCard(
    AppThemeExtensionWrapper theme,
    Map<String, dynamic> ej,
    ActivityLap? lap,
    Color color,
  ) {
    final distanceM = (lap != null && lap.distanceMeters > 0)
        ? lap.distanceMeters
        : (int.tryParse(ej['distancia_m']?.toString() ?? '')?.toDouble() ?? 0.0);

    final paceSec = lap?.actualPaceSecPerKm ?? 0.0;
    final durSeg = int.tryParse(ej['dur_seg']?.toString() ?? '') ?? 0;
    final durMinStr = ej['dur']?.toString() ?? '';
    final descanso = ej['descanso_seg'] ?? ej['descanso_segundos'] ?? 60;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.border.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'MÉTRICAS DE CARDIO Y VELOCIDAD',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  color: theme.textMuted,
                ),
              ),
              const Spacer(),
              Icon(Icons.speed, size: 16, color: color),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _KpiBox(
                  label: 'DISTANCIA TRAMO',
                  value: distanceM >= 1000
                      ? '${(distanceM / 1000).toStringAsFixed(2)} km'
                      : (distanceM > 0 ? '${distanceM.toStringAsFixed(0)} m' : '--'),
                  theme: theme,
                ),
              ),
              Expanded(
                child: _KpiBox(
                  label: 'DURACIÓN TRAMO',
                  value: durSeg > 0
                      ? (durSeg >= 60 ? '${(durSeg / 60).round()} min' : '$durSeg s')
                      : (durMinStr.isNotEmpty ? durMinStr : '--'),
                  theme: theme,
                ),
              ),
              Expanded(
                child: _KpiBox(
                  label: 'RITMO MEDIO',
                  value: _formatPace(paceSec),
                  theme: theme,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Divider(color: theme.border.withValues(alpha: 0.3), height: 1),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _KpiBox(
                  label: 'DESCANSO ENTRE SERIES',
                  value: '${descanso}s',
                  prefixIcon: Icons.timer_outlined,
                  theme: theme,
                ),
              ),
              Expanded(
                child: _KpiBox(
                  label: 'PULSO MEDIO',
                  value: _activity.summary.avgHeartRate > 0
                      ? '${_activity.summary.avgHeartRate} bpm'
                      : '-- bpm',
                  prefixIcon: Icons.favorite_border,
                  theme: theme,
                ),
              ),
              Expanded(
                child: _KpiBox(
                  label: 'CADENCIA',
                  value: _activity.summary.avgCadence > 0
                      ? '${_activity.summary.avgCadence} spm'
                      : '--',
                  theme: theme,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMobilityKpiCard(
    AppThemeExtensionWrapper theme,
    Map<String, dynamic> ej,
    Color color,
  ) {
    final dur = ej['dur']?.toString() ?? '5 min';
    final durSeg = int.tryParse(ej['dur_seg']?.toString() ?? '') ?? 300;
    final descanso = ej['descanso_seg'] ?? ej['descanso_segundos'] ?? 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.border.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'MÉTRICAS DE MOVILIDAD',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  color: theme.textMuted,
                ),
              ),
              const Spacer(),
              Icon(Icons.self_improvement, size: 16, color: color),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _KpiBox(
                  label: 'DURACIÓN SOSTENIDA',
                  value: dur.isNotEmpty ? dur : '${durSeg ~/ 60} min',
                  theme: theme,
                ),
              ),
              Expanded(
                child: _KpiBox(
                  label: 'TIPO DE SESIÓN',
                  value: 'Vuelta a la calma',
                  theme: theme,
                ),
              ),
              Expanded(
                child: _KpiBox(
                  label: 'DESCANSO',
                  value: descanso > 0 ? '${descanso}s' : '0s',
                  theme: theme,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionCard(AppThemeExtensionWrapper theme, String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.border.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, size: 16, color: theme.primary),
              const SizedBox(width: 8),
              Text(
                'GUÍA DE EJECUCIÓN',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  color: theme.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: theme.text,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // 2. MODO: ANALÍTICA GENERAL DE TODA LA SESIÓN
  // ═══════════════════════════════════════════════════════════════
  Widget _buildGeneralSessionAnalytics(AppThemeExtensionWrapper theme) {
    final act = _activity;
    final paceSpots = act.telemetry
        .map((t) => FlSpot(t.distanceKm, t.paceSecPerKm))
        .toList();
    final elevationSpots = act.telemetry
        .map((t) => FlSpot(t.distanceKm, t.elevationMeters))
        .toList();
    final hrSpots = act.telemetry
        .map((t) => FlSpot(t.distanceKm, t.heartRateBpm.toDouble()))
        .toList();

    return RefreshIndicator(
      color: theme.primary,
      backgroundColor: theme.cardDark,
      onRefresh: _loadActivity,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        child: Column(
          children: [
            ActivityMapHeader(
              activity: act,
              onShare: () {},
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  if (_noticeBanner != null) ...[
                    _buildNoticeBanner(theme, _noticeBanner!),
                    const SizedBox(height: 16),
                  ],

                  ActivityKpiGrid(summary: act.summary),

                  if (act.bestEfforts.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    ActivityBestEffortsCard(bestEfforts: act.bestEfforts),
                  ],

                  if (act.laps.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    ActivityLapsChart(laps: act.laps),
                  ],

                  if (act.splits.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    ActivitySplitsList(splits: act.splits),
                  ],

                  if (paceSpots.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    ActivityTelemetryChart(
                      title: 'Ritmo',
                      yAxisLabel: '/km',
                      spots: paceSpots,
                      type: TelemetryType.pace,
                      primaryColor: const Color(0xFF26A69A), // Cyan / Teal
                      footerStat1Label: 'Ritmo prom.',
                      footerStat1Value: _formatPace(act.summary.avgPaceSecPerKm),
                      footerStat2Label: 'Ritmo máx.',
                      footerStat2Value: act.summary.maxPaceSecPerKm != null
                          ? _formatPace(act.summary.maxPaceSecPerKm!)
                          : null,
                    ),
                  ],

                  if (elevationSpots.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    ActivityTelemetryChart(
                      title: 'Desnivel',
                      yAxisLabel: 'm',
                      spots: elevationSpots,
                      type: TelemetryType.elevation,
                      primaryColor: const Color(0xFF42A5F5), // Blue
                      footerStat1Label: 'Desnivel positivo',
                      footerStat1Value: '${act.summary.elevationGainMeters.toStringAsFixed(0)} m',
                      footerStat2Label: 'Desnivel máx.',
                      footerStat2Value: act.summary.maxElevationMeters != null
                          ? '${act.summary.maxElevationMeters!.toStringAsFixed(0)} m'
                          : null,
                    ),
                  ],

                  if (hrSpots.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    ActivityTelemetryChart(
                      title: 'Ritmo cardíaco',
                      yAxisLabel: 'bpm',
                      spots: hrSpots,
                      type: TelemetryType.heartRate,
                      primaryColor: const Color(0xFFEF5350), // Red / Coral
                      footerStat1Label: 'Ritmo cardiaco med.',
                      footerStat1Value: '${act.summary.avgHeartRate} bpm',
                      footerStat2Label: 'Ritmo cardiaco máx.',
                      footerStat2Value: act.summary.maxHeartRate != null
                          ? '${act.summary.maxHeartRate} bpm'
                          : null,
                    ),
                  ],

                  if (act.hrZones.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    ActivityHrZonesCard(zones: act.hrZones),
                  ],

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoticeBanner(AppThemeExtensionWrapper theme, String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE65100).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFF9800).withValues(alpha: 0.35),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFF9800).withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.info_outline_rounded,
              color: Color(0xFFFF9800),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Resumen general de la sesión',
                  style: TextStyle(
                    color: theme.text,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(
                    color: theme.textMuted,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _KpiBox extends StatelessWidget {
  final String label;
  final String value;
  final IconData? prefixIcon;
  final AppThemeExtensionWrapper theme;

  const _KpiBox({
    required this.label,
    required this.value,
    this.prefixIcon,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.6,
            color: theme.textMuted,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (prefixIcon != null) ...[
              Icon(prefixIcon, size: 13, color: theme.textMuted),
              const SizedBox(width: 3),
            ],
            Flexible(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: theme.text,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
