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
import 'widgets/analytics/activity_exercise_inspector_card.dart';
import 'widgets/analytics/activity_hr_zones_card.dart';
import 'widgets/analytics/activity_kpi_grid.dart';
import 'widgets/analytics/activity_laps_chart.dart';
import 'widgets/analytics/activity_map_header.dart';
import 'widgets/analytics/activity_splits_list.dart';
import 'widgets/analytics/activity_strength_exercises_card.dart';
import 'widgets/analytics/activity_telemetry_chart.dart';

class ActivityAnalyticsScreen extends StatefulWidget {
  final String activityId;
  final ActivityDetail? initialActivity;
  final Map<String, dynamic>? workoutData;

  const ActivityAnalyticsScreen({
    super.key,
    required this.activityId,
    this.initialActivity,
    this.workoutData,
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
  int? _selectedExerciseIndex;

  @override
  void initState() {
    super.initState();
    _activity = widget.initialActivity ??
        ActivityDetail.empty(title: 'Resumen de actividad');

    _initExercises();

    if (widget.initialActivity == null) {
      _loadActivity();
    } else {
      _checkBanner();
    }
  }

  void _checkBanner() {
    final hasGps = _activity.summary.distanceMeters > 0 ||
        _activity.routePoints.isNotEmpty ||
        _activity.telemetry.isNotEmpty;

    if (!hasGps) {
      if (_exercises.isNotEmpty) {
        _noticeBanner =
            'Esta sesión incluye ejercicios de fuerza y cardio interior. Podés tocar cualquier ejercicio de la lista para ver su rendimiento específico.';
      } else {
        _noticeBanner =
            'Aún no hay datos de telemetría o GPS registrados para esta sesión.\nCompletala usando el tracking en vivo del móvil o sincronizá tu reloj Garmin para ver los gráficos.';
      }
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
      _cacheExercises(parsed);
      _checkBanner();
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
          _checkBanner();
        }
      }
    } catch (e) {
      debugPrint('🚨 Error loading cached exercises: $e');
    }
  }

  Future<void> _cacheExercises(List<Map<String, dynamic>> list) async {
    if (widget.activityId.isEmpty) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'workout_exercises_${widget.activityId}';
      await prefs.setString(key, json.encode(list));
    } catch (_) {}
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

      list.add({
        'nombre': nombre,
        'tipo': tipo,
        'series': series,
        'reps': reps,
        'dur': durMin,
        'dur_seg': durSeg,
        'descanso_seg': descansoSeg,
        'peso': peso,
      });
    }

    return list;
  }

  Future<void> _loadActivity() async {
    if (widget.activityId.trim().isEmpty) {
      setState(() {
        _activity = ActivityDetail.empty(
          title: widget.initialActivity?.title ?? 'Resumen de actividad',
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
            title: widget.initialActivity?.title ?? 'Resumen de actividad',
          );
          _isLoading = false;
          _checkBanner();
        });
      }
    }
  }

  List<RoutePoint>? _getHighlightedRoutePoints() {
    if (_selectedExerciseIndex == null) return null;
    if (_activity.routePoints.isEmpty) return null;
    if (_selectedExerciseIndex! >= _exercises.length) return null;

    final selectedEj = _exercises[_selectedExerciseIndex!];
    final tipo = (selectedEj['tipo'] ?? selectedEj['bloque'] ?? '').toString().toUpperCase();
    final isCardio = tipo.contains('CARDIO') || tipo.contains('CARRERA') || tipo.contains('VELOCIDAD');
    if (!isCardio) return null;

    final cardioExercises = _exercises.where((e) {
      final t = (e['tipo'] ?? e['bloque'] ?? '').toString().toUpperCase();
      return t.contains('CARDIO') || t.contains('CARRERA') || t.contains('VELOCIDAD');
    }).toList();

    final cardioIdx = cardioExercises.indexOf(selectedEj);
    if (cardioIdx == -1) return null;

    final totalPoints = _activity.routePoints.length;
    final segmentLen = (totalPoints / cardioExercises.length).ceil();
    final startIdx = (cardioIdx * segmentLen).clamp(0, totalPoints - 1);
    final endIdx = ((cardioIdx + 1) * segmentLen).clamp(0, totalPoints);

    if (endIdx > startIdx) {
      return _activity.routePoints.sublist(startIdx, endIdx);
    }
    return null;
  }

  ActivityLap? _getCorrespondingLap(int exerciseIndex) {
    if (_activity.laps.isEmpty) return null;
    if (exerciseIndex < _activity.laps.length) {
      return _activity.laps[exerciseIndex];
    }
    return _activity.laps.first;
  }

  String _formatPace(double paceSec) {
    if (paceSec <= 0) return '--:--';
    final mins = (paceSec / 60).floor();
    final secs = (paceSec % 60).round();
    return '$mins:${secs.toString().padLeft(2, '0')}/km';
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;

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
          _activity.title,
          style: TextStyle(
            color: theme.text,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
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

    final highlightedPoints = _getHighlightedRoutePoints();
    final selectedLapTitle = _selectedExerciseIndex != null &&
            _selectedExerciseIndex! < _exercises.length
        ? _exercises[_selectedExerciseIndex!]['nombre'] as String?
        : null;

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
              highlightedPoints: highlightedPoints,
              highlightedLapTitle: selectedLapTitle,
              onShare: () {},
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // Active Exercise Inspector Card (Garmin-Style Drilldown)
                  if (_selectedExerciseIndex != null &&
                      _selectedExerciseIndex! < _exercises.length) ...[
                    ActivityExerciseInspectorCard(
                      exercise: _exercises[_selectedExerciseIndex!],
                      index: _selectedExerciseIndex!,
                      lap: _getCorrespondingLap(_selectedExerciseIndex!),
                      sessionSummary: act.summary,
                      onClose: () => setState(() => _selectedExerciseIndex = null),
                    ),
                    const SizedBox(height: 16),
                  ],

                  if (_noticeBanner != null && _selectedExerciseIndex == null) ...[
                    _buildNoticeBanner(theme, _noticeBanner!),
                    const SizedBox(height: 16),
                  ],

                  ActivityKpiGrid(summary: act.summary),

                  if (_exercises.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    ActivityStrengthExercisesCard(
                      exercises: _exercises,
                      selectedIndex: _selectedExerciseIndex,
                      onSelectExercise: (index) {
                        setState(() {
                          _selectedExerciseIndex =
                              (_selectedExerciseIndex == index) ? null : index;
                        });
                      },
                    ),
                  ],

                  if (act.bestEfforts.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    ActivityBestEffortsCard(bestEfforts: act.bestEfforts),
                  ],

                  if (act.laps.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    ActivityLapsChart(
                      laps: act.laps,
                      selectedLapOrder: _selectedExerciseIndex != null
                          ? _selectedExerciseIndex! + 1
                          : null,
                      onSelectLap: (order) {
                        setState(() {
                          final targetIdx = order - 1;
                          _selectedExerciseIndex =
                              (_selectedExerciseIndex == targetIdx) ? null : targetIdx;
                        });
                      },
                    ),
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
              Icons.touch_app_outlined,
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
                  'Sesión interactiva por bloques',
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
