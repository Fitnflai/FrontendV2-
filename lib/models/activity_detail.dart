class ActivityDetail {
  final String id;
  final String title;
  final String workoutType;
  final DateTime date;
  final String? locationName;
  final String? description;
  final List<String> sources;
  final ActivitySummary summary;
  final List<RoutePoint> routePoints;
  final List<BestEffort> bestEfforts;
  final List<ActivityLap> laps;
  final List<ActivitySplit> splits;
  final List<TelemetrySample> telemetry;
  final List<HrZoneDetail> hrZones;

  const ActivityDetail({
    required this.id,
    required this.title,
    required this.workoutType,
    required this.date,
    this.locationName,
    this.description,
    this.sources = const [],
    required this.summary,
    this.routePoints = const [],
    this.bestEfforts = const [],
    this.laps = const [],
    this.splits = const [],
    this.telemetry = const [],
    this.hrZones = const [],
  });

  factory ActivityDetail.fromJson(Map<String, dynamic> json) {
    return ActivityDetail(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? 'Actividad',
      workoutType: json['workout_type'] as String? ?? 'RUNNING',
      date: json['date'] != null
          ? DateTime.tryParse(json['date'] as String) ?? DateTime.now()
          : DateTime.now(),
      locationName: json['location_name'] as String?,
      description: json['description'] as String?,
      sources: (json['sources'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      summary: json['summary'] != null
          ? ActivitySummary.fromJson(json['summary'] as Map<String, dynamic>)
          : const ActivitySummary.empty(),
      routePoints: (json['route_points'] as List<dynamic>?)
              ?.map((e) => RoutePoint.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      bestEfforts: (json['best_efforts'] as List<dynamic>?)
              ?.map((e) => BestEffort.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      laps: (json['laps'] as List<dynamic>?)
              ?.map((e) => ActivityLap.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      splits: (json['splits'] as List<dynamic>?)
              ?.map((e) => ActivitySplit.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      telemetry: (json['telemetry'] as List<dynamic>?)
              ?.map((e) => TelemetrySample.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      hrZones: (json['hr_zones'] as List<dynamic>?)
              ?.map((e) => HrZoneDetail.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  factory ActivityDetail.empty({
    String id = '',
    String title = 'Resumen de actividad',
    String workoutType = 'RUNNING',
    DateTime? date,
  }) {
    return ActivityDetail(
      id: id,
      title: title,
      workoutType: workoutType,
      date: date ?? DateTime.now(),
      summary: const ActivitySummary.empty(),
      routePoints: const [],
      bestEfforts: const [],
      laps: const [],
      splits: const [],
      telemetry: const [],
      hrZones: const [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'workout_type': workoutType,
        'date': date.toIso8601String(),
        'location_name': locationName,
        'description': description,
        'sources': sources,
        'summary': summary.toJson(),
        'route_points': routePoints.map((e) => e.toJson()).toList(),
        'best_efforts': bestEfforts.map((e) => e.toJson()).toList(),
        'laps': laps.map((e) => e.toJson()).toList(),
        'splits': splits.map((e) => e.toJson()).toList(),
        'telemetry': telemetry.map((e) => e.toJson()).toList(),
        'hr_zones': hrZones.map((e) => e.toJson()).toList(),
      };
}

class ActivitySummary {
  final double distanceMeters;
  final int movingTimeSeconds;
  final double avgPaceSecPerKm;
  final double elevationGainMeters;
  final int avgHeartRate;
  final int avgCadence;
  final int calories;
  final double? maxElevationMeters;
  final int? maxHeartRate;
  final double? maxPaceSecPerKm;

  const ActivitySummary({
    required this.distanceMeters,
    required this.movingTimeSeconds,
    required this.avgPaceSecPerKm,
    required this.elevationGainMeters,
    required this.avgHeartRate,
    required this.avgCadence,
    required this.calories,
    this.maxElevationMeters,
    this.maxHeartRate,
    this.maxPaceSecPerKm,
  });

  const ActivitySummary.empty()
      : distanceMeters = 0,
        movingTimeSeconds = 0,
        avgPaceSecPerKm = 0,
        elevationGainMeters = 0,
        avgHeartRate = 0,
        avgCadence = 0,
        calories = 0,
        maxElevationMeters = null,
        maxHeartRate = null,
        maxPaceSecPerKm = null;

  factory ActivitySummary.fromJson(Map<String, dynamic> json) {
    return ActivitySummary(
      distanceMeters: (json['distance_meters'] as num?)?.toDouble() ?? 0.0,
      movingTimeSeconds: (json['moving_time_seconds'] as num?)?.toInt() ?? 0,
      avgPaceSecPerKm: (json['avg_pace_sec_per_km'] as num?)?.toDouble() ?? 0.0,
      elevationGainMeters:
          (json['elevation_gain_meters'] as num?)?.toDouble() ?? 0.0,
      avgHeartRate: (json['avg_heart_rate'] as num?)?.toInt() ?? 0,
      avgCadence: (json['avg_cadence'] as num?)?.toInt() ?? 0,
      calories: (json['calories'] as num?)?.toInt() ?? 0,
      maxElevationMeters: (json['max_elevation_meters'] as num?)?.toDouble(),
      maxHeartRate: (json['max_heart_rate'] as num?)?.toInt(),
      maxPaceSecPerKm: (json['max_pace_sec_per_km'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'distance_meters': distanceMeters,
        'moving_time_seconds': movingTimeSeconds,
        'avg_pace_sec_per_km': avgPaceSecPerKm,
        'elevation_gain_meters': elevationGainMeters,
        'avg_heart_rate': avgHeartRate,
        'avg_cadence': avgCadence,
        'calories': calories,
        'max_elevation_meters': maxElevationMeters,
        'max_heart_rate': maxHeartRate,
        'max_pace_sec_per_km': maxPaceSecPerKm,
      };
}

class RoutePoint {
  final double lat;
  final double lng;

  const RoutePoint({required this.lat, required this.lng});

  factory RoutePoint.fromJson(Map<String, dynamic> json) {
    return RoutePoint(
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (json['lng'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {'lat': lat, 'lng': lng};
}

class BestEffort {
  final double distanceMeters;
  final int timeSeconds;
  final String label;

  const BestEffort({
    required this.distanceMeters,
    required this.timeSeconds,
    required this.label,
  });

  factory BestEffort.fromJson(Map<String, dynamic> json) {
    return BestEffort(
      distanceMeters: (json['distance_meters'] as num?)?.toDouble() ?? 0.0,
      timeSeconds: (json['time_seconds'] as num?)?.toInt() ?? 0,
      label: json['label'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'distance_meters': distanceMeters,
        'time_seconds': timeSeconds,
        'label': label,
      };
}

class ActivityLap {
  final int lapOrder;
  final double distanceMeters;
  final double actualPaceSecPerKm;
  final double? targetPaceSecPerKm;

  const ActivityLap({
    required this.lapOrder,
    required this.distanceMeters,
    required this.actualPaceSecPerKm,
    this.targetPaceSecPerKm,
  });

  factory ActivityLap.fromJson(Map<String, dynamic> json) {
    return ActivityLap(
      lapOrder: (json['lap_order'] as num?)?.toInt() ?? 1,
      distanceMeters: (json['distance_meters'] as num?)?.toDouble() ?? 0.0,
      actualPaceSecPerKm:
          (json['actual_pace_sec_per_km'] as num?)?.toDouble() ?? 0.0,
      targetPaceSecPerKm: (json['target_pace_sec_per_km'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'lap_order': lapOrder,
        'distance_meters': distanceMeters,
        'actual_pace_sec_per_km': actualPaceSecPerKm,
        'target_pace_sec_per_km': targetPaceSecPerKm,
      };
}

class ActivitySplit {
  final int kilometer;
  final double paceSecPerKm;
  final int diffPreviousSplitSec;

  const ActivitySplit({
    required this.kilometer,
    required this.paceSecPerKm,
    required this.diffPreviousSplitSec,
  });

  factory ActivitySplit.fromJson(Map<String, dynamic> json) {
    return ActivitySplit(
      kilometer: (json['kilometer'] as num?)?.toInt() ?? 1,
      paceSecPerKm: (json['pace_sec_per_km'] as num?)?.toDouble() ?? 0.0,
      diffPreviousSplitSec:
          (json['diff_previous_split_sec'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'kilometer': kilometer,
        'pace_sec_per_km': paceSecPerKm,
        'diff_previous_split_sec': diffPreviousSplitSec,
      };
}

class TelemetrySample {
  final double distanceKm;
  final double paceSecPerKm;
  final double elevationMeters;
  final int heartRateBpm;

  const TelemetrySample({
    required this.distanceKm,
    required this.paceSecPerKm,
    required this.elevationMeters,
    required this.heartRateBpm,
  });

  factory TelemetrySample.fromJson(Map<String, dynamic> json) {
    return TelemetrySample(
      distanceKm: (json['distance_km'] as num?)?.toDouble() ?? 0.0,
      paceSecPerKm: (json['pace_sec_per_km'] as num?)?.toDouble() ?? 0.0,
      elevationMeters: (json['elevation_meters'] as num?)?.toDouble() ?? 0.0,
      heartRateBpm: (json['heart_rate_bpm'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'distance_km': distanceKm,
        'pace_sec_per_km': paceSecPerKm,
        'elevation_meters': elevationMeters,
        'heart_rate_bpm': heartRateBpm,
      };
}

class HrZoneDetail {
  final int zoneNumber;
  final int minBpm;
  final int maxBpm;
  final int timeInSeconds;
  final double percentage;

  const HrZoneDetail({
    required this.zoneNumber,
    required this.minBpm,
    required this.maxBpm,
    required this.timeInSeconds,
    required this.percentage,
  });

  factory HrZoneDetail.fromJson(Map<String, dynamic> json) {
    return HrZoneDetail(
      zoneNumber: (json['zone_number'] as num?)?.toInt() ?? 1,
      minBpm: (json['min_bpm'] as num?)?.toInt() ?? 0,
      maxBpm: (json['max_bpm'] as num?)?.toInt() ?? 0,
      timeInSeconds: (json['time_in_seconds'] as num?)?.toInt() ?? 0,
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'zone_number': zoneNumber,
        'min_bpm': minBpm,
        'max_bpm': maxBpm,
        'time_in_seconds': timeInSeconds,
        'percentage': percentage,
      };
}
