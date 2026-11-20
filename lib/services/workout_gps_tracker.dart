import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import '../models/activity_detail.dart';

class WorkoutGpsTracker {
  static final WorkoutGpsTracker _instance = WorkoutGpsTracker._internal();
  factory WorkoutGpsTracker() => _instance;
  WorkoutGpsTracker._internal();

  StreamSubscription<Position>? _positionSub;
  final List<RoutePoint> _rawRoute = [];
  final List<TelemetrySample> _telemetrySamples = [];
  final List<ActivitySplit> _splits = [];
  final List<ActivityLap> _laps = [];

  DateTime? _startTime;
  double _totalDistanceMeters = 0.0;
  double _elevationGainMeters = 0.0;
  double? _lastAltitude;
  double _maxAltitude = 0.0;
  double _maxPaceSecPerKm = 0.0;

  // Split tracking (every 1000m)
  int _currentSplitKm = 1;
  int _lastSplitElapsedSeconds = 0;
  double _previousSplitPace = 0.0;

  // Lap tracking
  int _lapIndex = 1;
  int _lapStartSeconds = 0;
  double _lapStartDistanceMeters = 0.0;

  bool get isTracking => _positionSub != null;
  double get totalDistanceKm => _totalDistanceMeters / 1000.0;
  double get totalDistanceMeters => _totalDistanceMeters;
  List<RoutePoint> get currentRoute => List.unmodifiable(_rawRoute);

  void startTracking() {
    reset();
    _startTime = DateTime.now();

    _positionSub = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      ),
    ).listen(_onPositionUpdate, onError: (e) {
      debugPrint('🚨 WorkoutGpsTracker error: $e');
    });
  }

  void _onPositionUpdate(Position p) {
    if (p.accuracy > 25.0) return; // filter noisy GPS

    final lat = p.latitude;
    final lng = p.longitude;
    final alt = p.altitude;
    final speed = p.speed; // m/s

    if (_rawRoute.isNotEmpty) {
      final prev = _rawRoute.last;
      final dist = Geolocator.distanceBetween(prev.lat, prev.lng, lat, lng);

      // Sanity check: ignore teleports / unreasonable jumps (> 150 km/h)
      if (dist > 0.5 && dist < 200) {
        _totalDistanceMeters += dist;

        if (_lastAltitude != null && alt > _lastAltitude!) {
          _elevationGainMeters += (alt - _lastAltitude!);
        }
      }
    }

    _lastAltitude = alt;
    if (alt > _maxAltitude) _maxAltitude = alt;

    _rawRoute.add(RoutePoint(lat: lat, lng: lng));

    final elapsedSeconds = _startTime != null
        ? DateTime.now().difference(_startTime!).inSeconds
        : 0;

    // Current pace in sec/km
    final currentPaceSecPerKm = speed > 0.5 ? (1000.0 / speed) : 0.0;
    if (currentPaceSecPerKm > 0 && currentPaceSecPerKm < 1800) {
      if (_maxPaceSecPerKm == 0 || currentPaceSecPerKm < _maxPaceSecPerKm) {
        _maxPaceSecPerKm = currentPaceSecPerKm;
      }
    }

    // Telemetry sampling (every ~100m)
    final lastTelemetryDist = _telemetrySamples.isNotEmpty
        ? _telemetrySamples.last.distanceKm * 1000
        : -100.0;
    if ((_totalDistanceMeters - lastTelemetryDist) >= 100.0) {
      _telemetrySamples.add(
        TelemetrySample(
          distanceKm: double.parse((_totalDistanceMeters / 1000.0).toStringAsFixed(2)),
          paceSecPerKm: currentPaceSecPerKm > 0
              ? currentPaceSecPerKm
              : (_splits.isNotEmpty ? _splits.last.paceSecPerKm : 360.0),
          elevationMeters: double.parse(alt.toStringAsFixed(1)),
          heartRateBpm: 0,
        ),
      );
    }

    // Check for km split completion (1000m, 2000m, etc.)
    final kmThreshold = _currentSplitKm * 1000.0;
    if (_totalDistanceMeters >= kmThreshold) {
      final splitTimeSec = elapsedSeconds - _lastSplitElapsedSeconds;
      final splitPace = splitTimeSec.toDouble();
      final diff = _previousSplitPace > 0
          ? (splitPace - _previousSplitPace).round()
          : 0;

      _splits.add(
        ActivitySplit(
          kilometer: _currentSplitKm,
          paceSecPerKm: splitPace,
          diffPreviousSplitSec: diff,
        ),
      );

      _previousSplitPace = splitPace;
      _lastSplitElapsedSeconds = elapsedSeconds;
      _currentSplitKm++;
    }
  }

  /// Called when an exercise/step changes in WorkoutActiveScreen
  void markLap({double? targetPaceSecPerKm}) {
    final elapsedSeconds = _startTime != null
        ? DateTime.now().difference(_startTime!).inSeconds
        : 0;
    final lapDuration = elapsedSeconds - _lapStartSeconds;
    final lapDistance = _totalDistanceMeters - _lapStartDistanceMeters;

    double actualPace = 0.0;
    if (lapDistance > 50 && lapDuration > 5) {
      actualPace = (lapDuration / (lapDistance / 1000.0));
    }

    _laps.add(
      ActivityLap(
        lapOrder: _lapIndex,
        distanceMeters: double.parse(lapDistance.toStringAsFixed(1)),
        actualPaceSecPerKm: actualPace > 0 ? actualPace : 360.0,
        targetPaceSecPerKm: targetPaceSecPerKm,
      ),
    );

    _lapIndex++;
    _lapStartSeconds = elapsedSeconds;
    _lapStartDistanceMeters = _totalDistanceMeters;
  }

  /// Stops tracking, compiles and returns the complete ActivityDetail model
  ActivityDetail stopAndBuildActivity({
    required String title,
    String workoutType = 'RUNNING',
    String? locationName,
    String? description,
    int? customCalories,
    int fallbackElapsedSeconds = 0,
    double fallbackDistanceMeters = 0.0,
    dynamic currentPos,
  }) {
    _positionSub?.cancel();
    _positionSub = null;

    final now = DateTime.now();
    final effectiveDistanceMeters = _totalDistanceMeters > 0
        ? _totalDistanceMeters
        : fallbackDistanceMeters;

    final gpsElapsed = _startTime != null
        ? now.difference(_startTime!).inSeconds
        : 0;
    final elapsedSeconds = gpsElapsed > 0 ? gpsElapsed : fallbackElapsedSeconds;

    // Close final lap if not closed
    if (_totalDistanceMeters > _lapStartDistanceMeters) {
      markLap();
    }

    // Close final partial split if exists
    final remainingMeters = effectiveDistanceMeters - ((_currentSplitKm - 1) * 1000.0);
    if (remainingMeters > 200 && elapsedSeconds > 0) {
      final partialTime = elapsedSeconds - _lastSplitElapsedSeconds;
      final projectedPace = (partialTime / (remainingMeters / 1000.0));
      final diff = _previousSplitPace > 0
          ? (projectedPace - _previousSplitPace).round()
          : 0;
      _splits.add(
        ActivitySplit(
          kilometer: _currentSplitKm,
          paceSecPerKm: projectedPace,
          diffPreviousSplitSec: diff,
        ),
      );
    }

    final avgPace = (effectiveDistanceMeters > 50 && elapsedSeconds > 5)
        ? (elapsedSeconds / (effectiveDistanceMeters / 1000.0))
        : 0.0;

    // Approximate calories: ~62 kcal per km running or ~4 kcal per minute resting/exercising
    final calories = customCalories ??
        (effectiveDistanceMeters > 0
            ? ((effectiveDistanceMeters / 1000.0) * 62).round()
            : ((elapsedSeconds / 60) * 4).round());

    // Best efforts (fastest 1km)
    final bestEfforts = <BestEffort>[];
    if (_splits.isNotEmpty) {
      final fastestSplit = _splits.reduce((a, b) => a.paceSecPerKm < b.paceSecPerKm ? a : b);
      bestEfforts.add(
        BestEffort(
          distanceMeters: 1000,
          timeSeconds: fastestSplit.paceSecPerKm.round(),
          label: 'Mejor 1 km',
        ),
      );
    }

    // Downsample route or use current position if stationary
    List<RoutePoint> downsampledRoute;
    if (_rawRoute.isNotEmpty) {
      downsampledRoute = _downsampleRoute(_rawRoute, 400);
    } else if (currentPos != null) {
      try {
        downsampledRoute = [
          RoutePoint(
            lat: (currentPos.latitude as num).toDouble(),
            lng: (currentPos.longitude as num).toDouble(),
          ),
        ];
      } catch (_) {
        downsampledRoute = [];
      }
    } else {
      downsampledRoute = [];
    }

    // Laps: if empty, generate at least 1 lap representing the session
    final lapsList = _laps.isNotEmpty
        ? List<ActivityLap>.unmodifiable(_laps)
        : [
            ActivityLap(
              lapOrder: 1,
              distanceMeters: effectiveDistanceMeters,
              actualPaceSecPerKm: avgPace,
              targetPaceSecPerKm: null,
            ),
          ];

    // Telemetry: if empty, add starting point so charts don't crash
    final telemetryList = _telemetrySamples.isNotEmpty
        ? List<TelemetrySample>.unmodifiable(_telemetrySamples)
        : [
            TelemetrySample(
              distanceKm: effectiveDistanceMeters / 1000.0,
              paceSecPerKm: avgPace,
              elevationMeters: _maxAltitude,
              heartRateBpm: 0,
            ),
          ];

    final summary = ActivitySummary(
      distanceMeters: double.parse(effectiveDistanceMeters.toStringAsFixed(1)),
      movingTimeSeconds: elapsedSeconds,
      avgPaceSecPerKm: avgPace,
      elevationGainMeters: double.parse(_elevationGainMeters.toStringAsFixed(1)),
      avgHeartRate: 0,
      avgCadence: 0,
      calories: calories,
      maxElevationMeters: _maxAltitude > 0 ? _maxAltitude : null,
      maxHeartRate: null,
      maxPaceSecPerKm: _maxPaceSecPerKm > 0 ? _maxPaceSecPerKm : null,
    );

    return ActivityDetail(
      id: 'phone_${now.millisecondsSinceEpoch}',
      title: title,
      workoutType: workoutType,
      date: _startTime ?? now,
      locationName: locationName ?? 'Entrenamiento con móvil',
      description: description,
      sources: const ['phone', 'fitnflai'],
      summary: summary,
      routePoints: downsampledRoute,
      bestEfforts: bestEfforts,
      laps: lapsList,
      splits: List.unmodifiable(_splits),
      telemetry: telemetryList,
      hrZones: const [],
    );
  }

  void reset() {
    _positionSub?.cancel();
    _positionSub = null;
    _rawRoute.clear();
    _telemetrySamples.clear();
    _splits.clear();
    _laps.clear();
    _startTime = null;
    _totalDistanceMeters = 0.0;
    _elevationGainMeters = 0.0;
    _lastAltitude = null;
    _maxAltitude = 0.0;
    _maxPaceSecPerKm = 0.0;
    _currentSplitKm = 1;
    _lastSplitElapsedSeconds = 0;
    _previousSplitPace = 0.0;
    _lapIndex = 1;
    _lapStartSeconds = 0;
    _lapStartDistanceMeters = 0.0;
  }

  List<RoutePoint> _downsampleRoute(List<RoutePoint> points, int maxPoints) {
    if (points.length <= maxPoints) return List.from(points);
    final step = points.length / maxPoints;
    final result = <RoutePoint>[];
    for (double i = 0; i < points.length; i += step) {
      result.add(points[i.toInt()]);
    }
    if (result.last != points.last) {
      result.add(points.last);
    }
    return result;
  }
}
