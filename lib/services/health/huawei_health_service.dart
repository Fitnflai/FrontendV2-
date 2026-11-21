import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:huawei_health/huawei_health.dart';
import 'package:fitnflaifrontendv2/services/health/base_health_service.dart';
import 'package:fitnflaifrontendv2/services/health/health_data_model.dart';
import 'package:fitnflaifrontendv2/models/activity_detail.dart';
import 'package:intl/intl.dart';

class HuaweiHealthService implements BaseHealthService {
  @override
  String get providerId => 'huawei_health';

  static const List<Scope> _healthScopes = [
    Scope.HEALTHKIT_STEP_READ,
    Scope.HEALTHKIT_CALORIES_READ,
    Scope.HEALTHKIT_DISTANCE_READ,
    Scope.HEALTHKIT_HEARTRATE_READ,
    Scope.HEALTHKIT_ACTIVITY_RECORD_READ,
    Scope.HEALTHKIT_SLEEP_READ,
  ];

  @override
  Future<bool> checkAvailability() async {
    return Platform.isAndroid;
  }

  @override
  Future<bool> requestPermissions() async {
    try {
      if (!Platform.isAndroid) return false;

      // 1. Verificar autorización de datos en la app Salud de Huawei
      try {
        final authorized = await SettingController.getHealthAppAuthorization();
        if (!authorized) {
          await SettingController.checkHealthAppAuthorization();
        }
      } catch (e) {
        debugPrint('⚠️ [HuaweiHealth] Error checking health app authorization: $e');
      }

      // 2. Solicitar inicio de sesión y permisos mediante HealthAuth.signIn
      final authResult = await HealthAuth.signIn(_healthScopes);
      debugPrint('Huawei Health authResult: $authResult');
      return authResult != null;
    } on PlatformException catch (e) {
      debugPrint('PlatformException requesting Huawei Health permissions: ${e.message} (code: ${e.code})');
      return false;
    } catch (e) {
      debugPrint('Error requesting Huawei Health permissions: $e');
      return false;
    }
  }

  @override
  Future<Map<String, dynamic>?> fetchSyncData(DateTime date) async {
    if (!Platform.isAndroid) {
      return null;
    }

    try {
      final dataController = await DataController.init();

      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final String formattedDate = formatter.format(date);

      int totalSteps = 0;
      double totalCaloriesBurned = 0.0;
      double totalDistanceKm = 0.0;
      double avgHeartRate = 0.0;
      double restingHeartRate = 0.0;
      double weightKg = 0.0;
      double totalSleepHours = 0.0;
      double fcReposo = 0.0;
      List<Map<String, dynamic>> workouts = [];

      final now = DateTime.now();
      final isToday = date.year == now.year && date.month == now.month && date.day == now.day;
      final int yyyymmdd = date.year * 10000 + date.month * 100 + date.day;

      // 1. Fetch Steps
      if (isToday) {
        try {
          final SampleSet? stepsSum = await dataController.readTodaySummation(
            DataType.DT_CONTINUOUS_STEPS_DELTA,
          );
          if (stepsSum != null) {
            for (var point in stepsSum.samplePoints) {
              final values = point.fieldValues;
              if (values != null) {
                final val = values['steps_delta'] ?? values['steps'];
                if (val is num) totalSteps += val.toInt();
              }
            }
          }
        } catch (e) {
          debugPrint('⚠️ [HuaweiHealth] Error in readTodaySummation steps: $e');
        }
      }

      if (totalSteps == 0) {
        try {
          final SampleSet? stepsSum = await dataController.readDailySummation(
            DataType.DT_CONTINUOUS_STEPS_DELTA,
            yyyymmdd,
            yyyymmdd,
          );
          if (stepsSum != null) {
            for (var point in stepsSum.samplePoints) {
              final values = point.fieldValues;
              if (values != null) {
                final val = values['steps_delta'] ?? values['steps'];
                if (val is num) totalSteps += val.toInt();
              }
            }
          }
        } catch (e) {
          debugPrint('⚠️ [HuaweiHealth] Error in readDailySummation steps: $e');
        }
      }

      // 2. Fetch Calories
      if (isToday) {
        try {
          final SampleSet? caloriesSum = await dataController.readTodaySummation(
            DataType.DT_CONTINUOUS_CALORIES_BURNT,
          );
          if (caloriesSum != null) {
            for (var point in caloriesSum.samplePoints) {
              final values = point.fieldValues;
              if (values != null) {
                final val = values['calories'] ?? values['calories_total'];
                if (val is num) totalCaloriesBurned += val.toDouble();
              }
            }
          }
        } catch (e) {
          debugPrint('⚠️ [HuaweiHealth] Error in readTodaySummation calories: $e');
        }
      }

      if (totalCaloriesBurned == 0.0) {
        try {
          final SampleSet? caloriesSum = await dataController.readDailySummation(
            DataType.DT_CONTINUOUS_CALORIES_BURNT,
            yyyymmdd,
            yyyymmdd,
          );
          if (caloriesSum != null) {
            for (var point in caloriesSum.samplePoints) {
              final values = point.fieldValues;
              if (values != null) {
                final val = values['calories'] ?? values['calories_total'];
                if (val is num) totalCaloriesBurned += val.toDouble();
              }
            }
          }
        } catch (e) {
          debugPrint('⚠️ [HuaweiHealth] Error in readDailySummation calories: $e');
        }
      }

      // 3. Fetch Distance
      if (isToday) {
        try {
          final SampleSet? distanceSum = await dataController.readTodaySummation(
            DataType.DT_CONTINUOUS_DISTANCE_DELTA,
          );
          if (distanceSum != null) {
            for (var point in distanceSum.samplePoints) {
              final values = point.fieldValues;
              if (values != null) {
                final val = values['distance'] ?? values['distance_delta'];
                if (val is num) totalDistanceKm += val.toDouble() / 1000.0;
              }
            }
          }
        } catch (e) {
          debugPrint('⚠️ [HuaweiHealth] Error in readTodaySummation distance: $e');
        }
      }

      if (totalDistanceKm == 0.0) {
        try {
          final SampleSet? distanceSum = await dataController.readDailySummation(
            DataType.DT_CONTINUOUS_DISTANCE_DELTA,
            yyyymmdd,
            yyyymmdd,
          );
          if (distanceSum != null) {
            for (var point in distanceSum.samplePoints) {
              final values = point.fieldValues;
              if (values != null) {
                final val = values['distance'] ?? values['distance_delta'];
                if (val is num) totalDistanceKm += val.toDouble() / 1000.0;
              }
            }
          }
        } catch (e) {
          debugPrint('⚠️ [HuaweiHealth] Error in readDailySummation distance: $e');
        }
      }

      // 4. Fetch Heart Rate
      try {
        final startOfDay = DateTime(date.year, date.month, date.day);
        final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

        final ReadOptions hrReadOptions = ReadOptions(
          dataCollectors: [
            DataCollector(
              dataType: DataType.DT_INSTANTANEOUS_HEART_RATE,
              dataGenerateType: DataGenerateType.DATA_TYPE_RAW,
            ),
          ],
          startTime: startOfDay,
          endTime: endOfDay,
        );

        final ReadReply? hrReply = await dataController.read(hrReadOptions);
        if (hrReply != null && hrReply.sampleSets.isNotEmpty) {
          final hrValues = <double>[];
          for (final set in hrReply.sampleSets) {
            for (final point in set.samplePoints) {
              final val = point.fieldValues?['bpm'] ?? point.fieldValues?['heart_rate'];
              if (val is num && val > 30 && val < 240) {
                hrValues.add(val.toDouble());
              }
            }
          }
          if (hrValues.isNotEmpty) {
            avgHeartRate = double.parse((hrValues.reduce((a, b) => a + b) / hrValues.length).toStringAsFixed(1));
            restingHeartRate = hrValues.reduce((a, b) => a < b ? a : b);
            fcReposo = restingHeartRate;
          }
        }
      } catch (e) {
        debugPrint('⚠️ [HuaweiHealth] Error reading heart rate: $e');
      }

      final healthData = HealthDataModel(
        fecha: formattedDate,
        pasos: totalSteps,
        caloriasQuemadas: totalCaloriesBurned,
        distanciaKm: totalDistanceKm,
        ritmoCardiacoPromedio: avgHeartRate,
        ritmoCardiacoReposo: restingHeartRate,
        pesoKg: weightKg,
        horasSueno: totalSleepHours,
        fuente: providerId,
        fcReposo: fcReposo,
        workouts: workouts,
      );

      return healthData.toMap();
    } catch (e) {
      debugPrint('🚨 [HuaweiHealth] Exception in fetchSyncData: $e');
      return null;
    }
  }

  /// Consulta la frecuencia cardíaca y zonas durante un entrenamiento con Huawei Health
  Future<Map<String, dynamic>?> fetchWorkoutHeartRate({
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    if (!Platform.isAndroid) return null;
    try {
      final dataController = await DataController.init();
      final ReadOptions hrReadOptions = ReadOptions(
        dataCollectors: [
          DataCollector(
            dataType: DataType.DT_INSTANTANEOUS_HEART_RATE,
            dataGenerateType: DataGenerateType.DATA_TYPE_RAW,
          ),
        ],
        startTime: startTime,
        endTime: endTime,
      );

      final ReadReply? hrReply = await dataController.read(hrReadOptions);
      if (hrReply == null || hrReply.sampleSets.isEmpty) return null;

      final values = <double>[];
      final timestampValues = <Map<String, dynamic>>[];

      for (final set in hrReply.sampleSets) {
        for (final point in set.samplePoints) {
          final val = point.fieldValues?['bpm'] ?? point.fieldValues?['heart_rate'];
          if (val is num && val > 30 && val < 240) {
            final double bpm = val.toDouble();
            values.add(bpm);
            final timeMs = point.startTime?.millisecondsSinceEpoch ??
                point.samplingTime?.millisecondsSinceEpoch ??
                0;
            timestampValues.add({
              'time': timeMs,
              'bpm': bpm.round(),
            });
          }
        }
      }

      if (values.isEmpty) return null;

      values.sort();
      final avgHr = (values.reduce((a, b) => a + b) / values.length).round();
      final maxHr = values.last.round();

      final z1Max = (maxHr * 0.60).round();
      final z2Max = (maxHr * 0.70).round();
      final z3Max = (maxHr * 0.80).round();
      final z4Max = (maxHr * 0.90).round();

      int z1Count = 0;
      int z2Count = 0;
      int z3Count = 0;
      int z4Count = 0;
      int z5Count = 0;

      for (final v in values) {
        if (v < z1Max) {
          z1Count++;
        } else if (v < z2Max) {
          z2Count++;
        } else if (v < z3Max) {
          z3Count++;
        } else if (v < z4Max) {
          z4Count++;
        } else {
          z5Count++;
        }
      }

      final totalDurationSec = endTime.difference(startTime).inSeconds;
      final total = values.length;

      final zones = [
        HrZoneDetail(
          zoneNumber: 1,
          minBpm: (maxHr * 0.50).round(),
          maxBpm: z1Max,
          percentage: double.parse((z1Count / total).toStringAsFixed(2)),
          timeInSeconds: ((z1Count / total) * totalDurationSec).round(),
        ),
        HrZoneDetail(
          zoneNumber: 2,
          minBpm: z1Max,
          maxBpm: z2Max,
          percentage: double.parse((z2Count / total).toStringAsFixed(2)),
          timeInSeconds: ((z2Count / total) * totalDurationSec).round(),
        ),
        HrZoneDetail(
          zoneNumber: 3,
          minBpm: z2Max,
          maxBpm: z3Max,
          percentage: double.parse((z3Count / total).toStringAsFixed(2)),
          timeInSeconds: ((z3Count / total) * totalDurationSec).round(),
        ),
        HrZoneDetail(
          zoneNumber: 4,
          minBpm: z3Max,
          maxBpm: z4Max,
          percentage: double.parse((z4Count / total).toStringAsFixed(2)),
          timeInSeconds: ((z4Count / total) * totalDurationSec).round(),
        ),
        HrZoneDetail(
          zoneNumber: 5,
          minBpm: z4Max,
          maxBpm: maxHr,
          percentage: double.parse((z5Count / total).toStringAsFixed(2)),
          timeInSeconds: ((z5Count / total) * totalDurationSec).round(),
        ),
      ];

      return {
        'avgHeartRate': avgHr,
        'maxHeartRate': maxHr,
        'samples': timestampValues,
        'hrZones': zones,
        'provider': providerId,
      };
    } catch (e) {
      debugPrint('🚨 [HuaweiHealth] Error fetching workout heart rate: $e');
      return null;
    }
  }

  @override
  Future<void> disconnect() async {
    try {
      if (!Platform.isAndroid) return;
      await ConsentsController.cancelAuthorization(true);
      debugPrint('Huawei Health disconnected successfully.');
    } on PlatformException catch (e) {
      debugPrint('PlatformException disconnecting Huawei Health: ${e.message}');
    } catch (e) {
      debugPrint('Error disconnecting Huawei Health: $e');
    }
  }
}
