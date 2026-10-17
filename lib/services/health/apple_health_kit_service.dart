import 'package:flutter/foundation.dart';
import 'package:health/health.dart';
import 'package:fitnflaifrontendv2/services/health/base_health_service.dart';
import 'package:fitnflaifrontendv2/services/health/health_data_model.dart';
import 'package:intl/intl.dart'; // For date formatting

class AppleHealthKitService implements BaseHealthService {
  final Health _health = Health();
  bool _isConfigured = false;

  Future<void> _ensureConfigured() async {
    if (!_isConfigured) {
      try {
        await _health.configure();
        _isConfigured = true;
      } catch (e) {
        debugPrint('Error configuring HealthKit: $e');
      }
    }
  }
  
  final List<HealthDataType> _types = [
    HealthDataType.STEPS,
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.DISTANCE_DELTA,
    HealthDataType.HEART_RATE,
    HealthDataType.SLEEP_SESSION,
    HealthDataType.WEIGHT,
  ];

  @override
  String get providerId => 'health_kit';

  @override
  Future<bool> checkAvailability() async {
    if (defaultTargetPlatform != TargetPlatform.iOS) {
      return false;
    }
    await _ensureConfigured();
    return true;
  }

  @override
  Future<bool> requestPermissions() async {
    await _ensureConfigured();
    final permissions = List.filled(_types.length, HealthDataAccess.READ);
    try {
      final hasPerm = await _health.hasPermissions(_types, permissions: permissions) ?? false;
      if (hasPerm) {
        debugPrint('HealthKit permissions already granted.');
        return true;
      }
    } catch (e) {
      debugPrint('Error checking HealthKit permissions: $e');
    }
    return _health.requestAuthorization(_types, permissions: permissions);
  }

  double _getNumericValue(HealthValue value) {
    if (value is NumericHealthValue) {
      return value.numericValue.toDouble();
    }
    try {
      return (value as dynamic).numericValue.toDouble();
    } catch (_) {
      try {
        return double.parse(value.toString());
      } catch (_) {
        return 0.0;
      }
    }
  }

  @override
  Future<Map<String, dynamic>?> fetchSyncData(DateTime date) async {
    await _ensureConfigured();
    final startOfDay = DateTime(date.year, date.month, date.day, 0, 0, 0);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    List<HealthDataPoint> healthData = [];
    for (var type in _types) {
      try {
        final data = await _health.getHealthDataFromTypes(
          startTime: startOfDay,
          endTime: endOfDay,
          types: [type],
        );
        healthData.addAll(data);
      } catch (e) {
        debugPrint("Error fetching HealthKit data for type $type: $e");
      }
    }

    // Accumulate data for normalization
    int pasos = 0;
    double caloriasQuemadas = 0.0;
    double distanciaKm = 0.0;
    List<double> heartRates = [];
    double pesoKg = 0.0;
    double horasSueno = 0.0;

    for (HealthDataPoint dataPoint in healthData) {
      switch (dataPoint.type) {
        case HealthDataType.STEPS:
          pasos += _getNumericValue(dataPoint.value).toInt();
          break;
        case HealthDataType.ACTIVE_ENERGY_BURNED:
          caloriasQuemadas += _getNumericValue(dataPoint.value);
          break;
        case HealthDataType.DISTANCE_DELTA:
          distanciaKm += _getNumericValue(dataPoint.value) / 1000; // meters to km
          break;
        case HealthDataType.HEART_RATE:
          heartRates.add(_getNumericValue(dataPoint.value));
          break;
        case HealthDataType.WEIGHT:
          pesoKg = _getNumericValue(dataPoint.value);
          break;
        case HealthDataType.SLEEP_SESSION:
          final diff = dataPoint.dateTo.difference(dataPoint.dateFrom).inMinutes;
          horasSueno += diff / 60.0;
          break;
        default:
          break;
      }
    }

    double ritmoCardiacoPromedio = 0.0;
    double ritmoCardiacoReposo = 0.0;
    if (heartRates.isNotEmpty) {
      ritmoCardiacoPromedio = heartRates.reduce((a, b) => a + b) / heartRates.length;
      ritmoCardiacoReposo = heartRates.reduce((a, b) => a < b ? a : b);
    }

    // Create HealthDataModel instance
    final healthDataModel = HealthDataModel(
      fecha: DateFormat('yyyy-MM-dd').format(date),
      pasos: pasos,
      caloriasQuemadas: caloriasQuemadas,
      distanciaKm: distanciaKm,
      ritmoCardiacoPromedio: ritmoCardiacoPromedio,
      ritmoCardiacoReposo: ritmoCardiacoReposo,
      pesoKg: pesoKg,
      horasSueno: horasSueno,
      fuente: providerId,
      fcReposo: ritmoCardiacoReposo,
    );

        return healthDataModel.toMap();
  }

  @override
  Future<void> disconnect() async {
    // HealthKit does not have a direct "disconnect" API like Health Connect.
    // Revoking permissions is the closest equivalent.
    // However, revokePermissions is for specific types. A full disconnect
    // would imply revoking all previously granted permissions.
    // For simplicity, we'll revoke all registered types.
    await _health.revokePermissions();
  }
}
