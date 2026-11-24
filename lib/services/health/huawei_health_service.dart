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
    // --- LECTURA (READ) ---
    Scope.HEALTHKIT_STEP_READ,
    Scope.HEALTHKIT_CALORIES_READ,
    Scope.HEALTHKIT_DISTANCE_READ,
    Scope.HEALTHKIT_HEARTRATE_READ,
    Scope.HEALTHKIT_ACTIVITY_RECORD_READ,
    Scope.HEALTHKIT_ACTIVITY_READ,
    Scope.HEALTHKIT_SLEEP_READ,
    Scope.HEALTHKIT_SPEED_READ,
    Scope.HEALTHKIT_HEIGHTWEIGHT_READ,
    Scope.HEALTHKIT_BODYFAT_READ,
    Scope.HEALTHKIT_LOCATION_READ,

    // --- ESCRITURA (WRITE) ---
    Scope.HEALTHKIT_STEP_WRITE,
    Scope.HEALTHKIT_CALORIES_WRITE,
    Scope.HEALTHKIT_DISTANCE_WRITE,
    Scope.HEALTHKIT_HEARTRATE_WRITE,
    Scope.HEALTHKIT_ACTIVITY_RECORD_WRITE,
    Scope.HEALTHKIT_ACTIVITY_WRITE,
    Scope.HEALTHKIT_SLEEP_WRITE,
    Scope.HEALTHKIT_SPEED_WRITE,
    Scope.HEALTHKIT_HEIGHTWEIGHT_WRITE,
    Scope.HEALTHKIT_BODYFAT_WRITE,
    Scope.HEALTHKIT_LOCATION_WRITE,
  ];

  @override
  Future<bool> checkAvailability() async {
    return Platform.isAndroid;
  }

  num? _extractNumeric(SamplePoint point, List<String> candidateKeys) {
    final values = point.fieldValues;
    if (values != null) {
      for (final k in candidateKeys) {
        if (values.containsKey(k) && values[k] is num) {
          return values[k] as num;
        }
      }
      for (final entry in values.entries) {
        if (entry.value is num) return entry.value as num;
      }
    }
    if (point.fieldValueOptions != null && point.fieldValueOptions!.value is num) {
      return point.fieldValueOptions!.value as num;
    }
    for (final k in candidateKeys) {
      if (point.pairs.containsKey(k) && point.pairs[k] is num) {
        return point.pairs[k] as num;
      }
    }
    return null;
  }

  @override
  Future<bool> requestPermissions() async {
    try {
      if (!Platform.isAndroid) return false;

      // 1. Redirigir a la app Salud de Huawei para autorizar el uso compartido a Health Kit
      try {
        final authorized = await SettingController.getHealthAppAuthorization();
        if (!authorized) {
          await SettingController.checkHealthAppAuthorization();
        }
      } catch (e) {
        debugPrint('⚠️ [HuaweiHealth] Error checking health app authorization: $e');
      }

      // 2. Intent con Health Auth unificado
      try {
        final res = await SettingController.requestAuthorizationIntent(_healthScopes, true);
        debugPrint('Huawei Health requestAuthorizationIntent status: ${res.status?.statusCode}, auth: ${res.authAccount}');
        if (res.authAccount != null || res.status?.statusCode == 0) {
          return true;
        }
      } catch (e) {
        debugPrint('⚠️ [HuaweiHealth] requestAuthorizationIntent failed: $e, falling back to HealthAuth.signIn');
      }

      // 3. Fallback a HealthAuth.signIn
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

      // 1. Fetch Steps (Probar TOTAL primero, luego DELTA)
      if (isToday) {
        for (final dt in [
          DataType.DT_CONTINUOUS_STEPS_TOTAL,
          DataType.DT_CONTINUOUS_STEPS_DELTA,
        ]) {
          try {
            final SampleSet? stepsSum = await dataController.readTodaySummation(dt);
            if (stepsSum != null) {
              for (var point in stepsSum.samplePoints) {
                final val = _extractNumeric(point, ['steps_total', 'steps_delta', 'steps', 'step']);
                if (val != null && val > 0) {
                  totalSteps = val.toInt();
                  break;
                }
              }
            }
          } catch (e) {
            debugPrint('⚠️ [HuaweiHealth] Error reading today steps ($dt): $e');
          }
          if (totalSteps > 0) break;
        }
      }

      if (totalSteps == 0) {
        for (final dt in [
          DataType.DT_CONTINUOUS_STEPS_TOTAL,
          DataType.DT_CONTINUOUS_STEPS_DELTA,
        ]) {
          try {
            final SampleSet? stepsSum = await dataController.readDailySummation(
              dt,
              yyyymmdd,
              yyyymmdd,
            );
            if (stepsSum != null) {
              for (var point in stepsSum.samplePoints) {
                final val = _extractNumeric(point, ['steps_total', 'steps_delta', 'steps', 'step']);
                if (val != null && val > 0) {
                  totalSteps = val.toInt();
                  break;
                }
              }
            }
          } catch (e) {
            debugPrint('⚠️ [HuaweiHealth] Error reading daily steps ($dt): $e');
          }
          if (totalSteps > 0) break;
        }
      }

      // 2. Fetch Calories (Probar TOTAL primero, luego BURNT)
      if (isToday) {
        for (final dt in [
          DataType.DT_CONTINUOUS_CALORIES_BURNT_TOTAL,
          DataType.DT_CONTINUOUS_CALORIES_BURNT,
        ]) {
          try {
            final SampleSet? caloriesSum = await dataController.readTodaySummation(dt);
            if (caloriesSum != null) {
              for (var point in caloriesSum.samplePoints) {
                final val = _extractNumeric(point, ['calories_total', 'calories', 'calorie']);
                if (val != null && val > 0) {
                  totalCaloriesBurned = val.toDouble();
                  break;
                }
              }
            }
          } catch (e) {
            debugPrint('⚠️ [HuaweiHealth] Error reading today calories ($dt): $e');
          }
          if (totalCaloriesBurned > 0) break;
        }
      }

      if (totalCaloriesBurned == 0.0) {
        for (final dt in [
          DataType.DT_CONTINUOUS_CALORIES_BURNT_TOTAL,
          DataType.DT_CONTINUOUS_CALORIES_BURNT,
        ]) {
          try {
            final SampleSet? caloriesSum = await dataController.readDailySummation(
              dt,
              yyyymmdd,
              yyyymmdd,
            );
            if (caloriesSum != null) {
              for (var point in caloriesSum.samplePoints) {
                final val = _extractNumeric(point, ['calories_total', 'calories', 'calorie']);
                if (val != null && val > 0) {
                  totalCaloriesBurned = val.toDouble();
                  break;
                }
              }
            }
          } catch (e) {
            debugPrint('⚠️ [HuaweiHealth] Error reading daily calories ($dt): $e');
          }
          if (totalCaloriesBurned > 0) break;
        }
      }

      // 3. Fetch Distance (Probar TOTAL primero, luego DELTA)
      if (isToday) {
        for (final dt in [
          DataType.DT_CONTINUOUS_DISTANCE_TOTAL,
          DataType.DT_CONTINUOUS_DISTANCE_DELTA,
        ]) {
          try {
            final SampleSet? distanceSum = await dataController.readTodaySummation(dt);
            if (distanceSum != null) {
              for (var point in distanceSum.samplePoints) {
                final val = _extractNumeric(point, ['distance_total', 'distance', 'distance_delta']);
                if (val != null && val > 0) {
                  final d = val.toDouble();
                  totalDistanceKm = d > 100 ? (d / 1000.0) : d;
                  break;
                }
              }
            }
          } catch (e) {
            debugPrint('⚠️ [HuaweiHealth] Error reading today distance ($dt): $e');
          }
          if (totalDistanceKm > 0) break;
        }
      }

      if (totalDistanceKm == 0.0) {
        for (final dt in [
          DataType.DT_CONTINUOUS_DISTANCE_TOTAL,
          DataType.DT_CONTINUOUS_DISTANCE_DELTA,
        ]) {
          try {
            final SampleSet? distanceSum = await dataController.readDailySummation(
              dt,
              yyyymmdd,
              yyyymmdd,
            );
            if (distanceSum != null) {
              for (var point in distanceSum.samplePoints) {
                final val = _extractNumeric(point, ['distance_total', 'distance', 'distance_delta']);
                if (val != null && val > 0) {
                  final d = val.toDouble();
                  totalDistanceKm = d > 100 ? (d / 1000.0) : d;
                  break;
                }
              }
            }
          } catch (e) {
            debugPrint('⚠️ [HuaweiHealth] Error reading daily distance ($dt): $e');
          }
          if (totalDistanceKm > 0) break;
        }
      }

      // Fallback: Si la sumatoria directa da 0, intentar leer muestras detalladas del día
      if (totalDistanceKm == 0.0 || totalCaloriesBurned == 0.0) {
        try {
          final startOfDay = DateTime(date.year, date.month, date.day);
          final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

          final ReadOptions sampleReadOptions = ReadOptions(
            dataCollectors: [
              DataCollector(
                dataType: DataType.DT_CONTINUOUS_DISTANCE_TOTAL,
                dataGenerateType: DataGenerateType.DATA_TYPE_RAW,
              ),
              DataCollector(
                dataType: DataType.DT_CONTINUOUS_CALORIES_BURNT_TOTAL,
                dataGenerateType: DataGenerateType.DATA_TYPE_RAW,
              ),
            ],
            startTime: startOfDay,
            endTime: endOfDay,
          );

          final ReadReply? reply = await dataController.read(sampleReadOptions);
          if (reply != null && reply.sampleSets.isNotEmpty) {
            for (final set in reply.sampleSets) {
              for (final point in set.samplePoints) {
                if (totalDistanceKm == 0.0) {
                  final d = _extractNumeric(point, ['distance_total', 'distance', 'distance_delta']);
                  if (d != null && d > 0) {
                    final dv = d.toDouble();
                    totalDistanceKm = dv > 100 ? (dv / 1000.0) : dv;
                  }
                }
                if (totalCaloriesBurned == 0.0) {
                  final c = _extractNumeric(point, ['calories_total', 'calories', 'calorie']);
                  if (c != null && c > 0) {
                    totalCaloriesBurned = c.toDouble();
                  }
                }
              }
            }
          }
        } catch (e) {
          debugPrint('⚠️ [HuaweiHealth] Error reading samples via ReadOptions: $e');
        }
      }

      // Si los pasos no vienen autorizados directamente en la consola de Huawei pero sí la distancia,
      // estimar los pasos por la cadencia/zancada media del usuario (~0.742m por paso)
      if (totalSteps == 0 && totalDistanceKm > 0) {
        totalSteps = (totalDistanceKm * 1000.0 / 0.742).round();
        debugPrint('ℹ️ [HuaweiHealth] Pasos estimados a partir de la distancia ($totalDistanceKm km): $totalSteps pasos');
      }

      // 4. Fetch Heart Rate
      try {
        final startOfDay = DateTime(date.year, date.month, date.day);
        final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

        for (final dt in [
          DataType.DT_INSTANTANEOUS_HEART_RATE,
          DataType.DT_INSTANTANEOUS_RESTING_HEART_RATE,
        ]) {
          try {
            final ReadOptions hrReadOptions = ReadOptions(
              dataCollectors: [
                DataCollector(
                  dataType: dt,
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
                  final val = _extractNumeric(point, ['bpm', 'heart_rate', 'resting_heart_rate']);
                  if (val != null && val > 30 && val < 240) {
                    hrValues.add(val.toDouble());
                  }
                }
              }
              if (hrValues.isNotEmpty) {
                avgHeartRate = double.parse((hrValues.reduce((a, b) => a + b) / hrValues.length).toStringAsFixed(1));
                restingHeartRate = hrValues.last;
                fcReposo = restingHeartRate;
                break;
              }
            }
          } catch (e) {
            debugPrint('⚠️ [HuaweiHealth] Error reading heart rate ($dt): $e');
          }
          if (avgHeartRate > 0) break;
        }
      } catch (e) {
        debugPrint('⚠️ [HuaweiHealth] Error reading heart rate: $e');
      }

      debugPrint('📊 [HuaweiHealth] Sincronización completada -> Pasos: $totalSteps, Kcal: $totalCaloriesBurned, Dist: $totalDistanceKm km, FC: $avgHeartRate');

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
          final val = _extractNumeric(point, ['bpm', 'heart_rate']);
          if (val != null && val > 30 && val < 240) {
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
