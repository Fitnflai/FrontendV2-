import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fitnflaifrontendv2/services/health/health_repository.dart';

class HealthProvider extends ChangeNotifier {
  final HealthRepository _healthRepository;
  HealthProviderType _connectedProvider = HealthProviderType.none;
  bool _isLoading = false;
  bool _hasExternalActivities = false;
  bool _isGarminConnected = false;
  bool _isStravaConnected = false;
  List<String> _externalSources = [];
  DateTime? _lastSyncTime;

  int _steps = 0;
  double _calories = 0.0;
  double _distance = 0.0;
  double _heartRate = 0.0;

  HealthProvider(this._healthRepository) {
    _loadConnectedProvider();
  }

  HealthProviderType get connectedProvider => _connectedProvider;
  bool get isLoading => _isLoading;
  bool get hasExternalActivities => _hasExternalActivities;
  bool get isGarminConnected => _isGarminConnected;
  bool get isStravaConnected => _isStravaConnected;
  List<String> get externalSources => _externalSources;
  DateTime? get lastSyncTime => _lastSyncTime;

  bool get isDeviceConnected =>
      _connectedProvider != HealthProviderType.none ||
      _isGarminConnected ||
      _isStravaConnected ||
      _hasExternalActivities;

  int get steps => _steps;
  double get calories => _calories;
  double get distance => _distance;
  double get heartRate => _heartRate;

  Future<void> _loadConnectedProvider() async {
    final prefs = await SharedPreferences.getInstance();
    final savedProviderId = prefs.getString('health_connected_provider') ?? 'none';
    _connectedProvider = HealthProviderType.values.firstWhere(
      (e) => e.id == savedProviderId,
      orElse: () => HealthProviderType.none,
    );
    
    // Load cached health data
    _steps = prefs.getInt('health_today_steps') ?? 0;
    _calories = prefs.getDouble('health_today_calories') ?? 0.0;
    _distance = prefs.getDouble('health_today_distance') ?? 0.0;
    _heartRate = prefs.getDouble('health_today_heart_rate') ?? 0.0;
    _hasExternalActivities = prefs.getBool('health_has_external_activities') ?? false;
    _isGarminConnected = prefs.getBool('health_garmin_connected') ?? false;
    _isStravaConnected = prefs.getBool('health_strava_connected') ?? false;
    _externalSources = prefs.getStringList('health_external_sources') ?? [];
    final lastSyncMillis = prefs.getInt('health_last_sync_time');
    if (lastSyncMillis != null) {
      _lastSyncTime = DateTime.fromMillisecondsSinceEpoch(lastSyncMillis);
    }
    
    notifyListeners();
  }

  void setExternalConnectedStatus({required bool garmin, required bool strava}) async {
    _isGarminConnected = garmin;
    _isStravaConnected = strava;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('health_garmin_connected', garmin);
    await prefs.setBool('health_strava_connected', strava);
  }

  @visibleForTesting
  void updateConsolidatedData({
    Map<String, dynamic>? localData,
    Map<String, dynamic>? backendSummary,
  }) => _updateConsolidatedData(localData: localData, backendSummary: backendSummary);

  double? _extractHeartRate(Map<String, dynamic>? map) {
    if (map == null) return null;
    const candidateKeys = [
      'frecuencia_cardiaca_actual',
      'ritmo_cardiaco_actual',
      'frecuencia_cardiaca_mas_reciente',
      'ritmo_cardiaco_reciente',
      'frecuencia_cardiaca',
      'ritmo_cardiaco',
      'heart_rate',
      'frecuencia_cardiaca_promedio',
      'ritmo_cardiaco_promedio',
      'bpm',
      'frecuencia_cardiaca_reposo',
      'ritmo_cardiaco_reposo',
      'fc_reposo',
      'resting_heart_rate',
    ];
    for (final k in candidateKeys) {
      final val = map[k];
      if (val is num && val > 0) return val.toDouble();
    }
    return null;
  }

  void _updateConsolidatedData({
    Map<String, dynamic>? localData,
    Map<String, dynamic>? backendSummary,
  }) async {
    // 1. Datos locales del sensor del dispositivo (Tier 3: Apple Health, Health Connect, Huawei)
    final localSteps = (localData?['pasos'] as int?) ?? 0;
    final localCalories = (localData?['calorias_quemadas'] as num?)?.toDouble() ?? 0.0;
    final localDistance = (localData?['distancia_km'] as num?)?.toDouble() ?? 0.0;
    final localHeartRate = _extractHeartRate(localData) ?? 0.0;

    // 2. Extracción de datos del backend (Garmin / Strava)
    final totalActividades = (backendSummary?['total_actividades'] as int?) ?? 0;
    final fuentesRaw = backendSummary?['fuentes'] as List<dynamic>?;
    _externalSources = fuentesRaw?.map((e) => e.toString().toLowerCase()).toList() ?? [];
    _hasExternalActivities = totalActividades > 0 || _externalSources.isNotEmpty;

    final tienePasosBackend = backendSummary?['tiene_pasos'] == true;
    final rawBackendSteps = tienePasosBackend ? ((backendSummary?['pasos_dia'] as int?) ?? 0) : 0;
    final rawBackendDistance = (backendSummary?['distancia_total_km'] as num?)?.toDouble() ?? 0.0;
    final rawBackendHeartRate = _extractHeartRate(backendSummary) ?? 0.0;
    final rawBackendCalories = (backendSummary?['calorias_actividad'] as num?)?.toDouble() ?? 0.0;

    // Desglose por fuente si el backend lo provee de forma estructurada
    final Map<String, dynamic>? garminMap = backendSummary?['garmin'] as Map<String, dynamic>?;
    final Map<String, dynamic>? stravaMap = backendSummary?['strava'] as Map<String, dynamic>?;
    final List<dynamic>? actividades = backendSummary?['actividades'] as List<dynamic>?;

    // --- TIER 1: GARMIN ---
    int? garminSteps;
    double? garminDistance;
    double? garminHeartRate;
    double? garminCalories;

    if (garminMap != null) {
      garminSteps = (garminMap['pasos'] as int?) ?? (garminMap['pasos_dia'] as int?);
      garminDistance = (garminMap['distancia_km'] as num?)?.toDouble() ?? (garminMap['distancia_total_km'] as num?)?.toDouble();
      garminHeartRate = _extractHeartRate(garminMap) ?? (rawBackendHeartRate > 0 ? rawBackendHeartRate : null);
      garminCalories = (garminMap['calorias'] as num?)?.toDouble() ?? (garminMap['calorias_actividad'] as num?)?.toDouble();
    } else {
      final bool isGarminInSources = _externalSources.contains('garmin');
      // En Fitnflai backend, los pasos diarios provienen exclusivamente de Garmin
      if ((isGarminInSources || _isGarminConnected) && rawBackendSteps > 0) {
        garminSteps = rawBackendSteps;
      }
      // Métricas de actividad Garmin si Garmin está en las fuentes o si Garmin está conectado y no hay Strava en fuentes
      if (isGarminInSources || (_isGarminConnected && !_externalSources.contains('strava'))) {
        if (rawBackendDistance > 0) garminDistance = rawBackendDistance;
        if (rawBackendHeartRate > 0) garminHeartRate = rawBackendHeartRate;
        if (rawBackendCalories > 0) garminCalories = rawBackendCalories;
      }
    }

    // --- TIER 2: STRAVA ---
    int? stravaSteps;
    double? stravaDistance;
    double? stravaHeartRate;
    double? stravaCalories;

    if (stravaMap != null) {
      stravaSteps = (stravaMap['pasos'] as int?);
      stravaDistance = (stravaMap['distancia_km'] as num?)?.toDouble() ?? (stravaMap['distancia_total_km'] as num?)?.toDouble();
      stravaHeartRate = _extractHeartRate(stravaMap) ?? (rawBackendHeartRate > 0 ? rawBackendHeartRate : null);
      stravaCalories = (stravaMap['calorias'] as num?)?.toDouble() ?? (stravaMap['calorias_actividad'] as num?)?.toDouble();
    } else {
      final bool isStravaInSources = _externalSources.contains('strava');
      if (isStravaInSources || (_isStravaConnected && !_externalSources.contains('garmin'))) {
        if (rawBackendDistance > 0 && (garminDistance == null || garminDistance == 0)) {
          stravaDistance = rawBackendDistance;
        }
        if (rawBackendHeartRate > 0 && (garminHeartRate == null || garminHeartRate == 0)) {
          stravaHeartRate = rawBackendHeartRate;
        }
        if (rawBackendCalories > 0 && (garminCalories == null || garminCalories == 0)) {
          stravaCalories = rawBackendCalories;
        }
      }
    }

    // Extracción adicional si vienen actividades individuales desglosadas
    if (actividades != null && actividades.isNotEmpty) {
      for (final act in actividades) {
        if (act is Map<String, dynamic>) {
          final src = (act['fuente'] ?? act['source'] ?? '').toString().toLowerCase();
          final d = (act['distancia_km'] as num?)?.toDouble() ?? 0.0;
          final hr = _extractHeartRate(act) ?? 0.0;
          final cal = (act['calorias'] as num?)?.toDouble() ?? (act['calorias_actividad'] as num?)?.toDouble() ?? 0.0;

          if (src.contains('garmin')) {
            if (d > 0 && (garminDistance == null || d > garminDistance)) garminDistance = d;
            if (hr > 0 && (garminHeartRate == null || hr > garminHeartRate)) garminHeartRate = hr;
            if (cal > 0 && (garminCalories == null || cal > garminCalories)) garminCalories = cal;
          } else if (src.contains('strava')) {
            if (d > 0 && (stravaDistance == null || d > stravaDistance)) stravaDistance = d;
            if (hr > 0 && (stravaHeartRate == null || hr > stravaHeartRate)) stravaHeartRate = hr;
            if (cal > 0 && (stravaCalories == null || cal > stravaCalories)) stravaCalories = cal;
          }
        }
      }
    }

    // --- TIER 3: APP LOCAL (Health Connect, HealthKit, Huawei Health) ---
    final bool hasLocalProvider = _connectedProvider != HealthProviderType.none;
    final int? localStepsVal = (hasLocalProvider && localSteps > 0) ? localSteps : null;
    final double? localDistanceVal = (hasLocalProvider && localDistance > 0) ? localDistance : null;
    final double? localHeartRateVal = (hasLocalProvider && localHeartRate > 0) ? localHeartRate : null;
    final double? localCaloriesVal = (hasLocalProvider && localCalories > 0) ? localCalories : null;

    // --- RESOLUCIÓN JERÁRQUICA MÉTRICA POR MÉTRICA (SIN SUMAR) ---
    // 1° Garmin -> 2° Strava -> 3° App de Salud local

    // 1. Pasos:
    if (garminSteps != null && garminSteps > 0) {
      _steps = garminSteps;
    } else if (stravaSteps != null && stravaSteps > 0) {
      _steps = stravaSteps;
    } else if (localStepsVal != null && localStepsVal > 0) {
      _steps = localStepsVal;
    } else {
      _steps = 0;
    }

    // 2. Ritmo cardíaco:
    if (garminHeartRate != null && garminHeartRate > 0) {
      _heartRate = garminHeartRate;
    } else if (stravaHeartRate != null && stravaHeartRate > 0) {
      _heartRate = stravaHeartRate;
    } else if (localHeartRateVal != null && localHeartRateVal > 0) {
      _heartRate = localHeartRateVal;
    } else {
      _heartRate = 0.0;
    }

    // 3. Distancia:
    if (garminDistance != null && garminDistance > 0) {
      _distance = garminDistance;
    } else if (stravaDistance != null && stravaDistance > 0) {
      _distance = stravaDistance;
    } else if (localDistanceVal != null && localDistanceVal > 0) {
      _distance = localDistanceVal;
    } else {
      _distance = 0.0;
    }

    // 4. Calorías:
    if (garminCalories != null && garminCalories > 0) {
      _calories = garminCalories;
    } else if (stravaCalories != null && stravaCalories > 0) {
      _calories = stravaCalories;
    } else if (localCaloriesVal != null && localCaloriesVal > 0) {
      _calories = localCaloriesVal;
    } else {
      _calories = 0.0;
    }

    debugPrint(
      '📊 [Health Hierarchy Resolved] '
      'Steps: $_steps (Garmin: $garminSteps, Strava: $stravaSteps, Local: $localStepsVal) | '
      'HR: $_heartRate (Garmin: $garminHeartRate, Strava: $stravaHeartRate, Local: $localHeartRateVal) | '
      'Distance: $_distance | Calories: $_calories',
    );

    _lastSyncTime = DateTime.now();
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('health_today_steps', _steps);
    await prefs.setDouble('health_today_calories', _calories);
    await prefs.setDouble('health_today_distance', _distance);
    await prefs.setDouble('health_today_heart_rate', _heartRate);
    await prefs.setBool('health_has_external_activities', _hasExternalActivities);
    await prefs.setStringList('health_external_sources', _externalSources);
    await prefs.setInt('health_last_sync_time', _lastSyncTime!.millisecondsSinceEpoch);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> checkAvailability(HealthProviderType providerType) async {
    return _healthRepository.checkAvailability(providerType);
  }

  Future<void> connectProvider(HealthProviderType providerType) async {
    if (providerType == HealthProviderType.none) return;

    _setLoading(true);
    try {
      final connected = await _healthRepository.connect(providerType);
      if (connected) {
        _connectedProvider = providerType;
        await silentSyncToday();
      }
    } catch (e) {
      debugPrint('Error connecting provider: $e');
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> disconnectProvider() async {
    _setLoading(true);
    try {
      await _healthRepository.disconnect();
      _connectedProvider = HealthProviderType.none;
      _steps = 0;
      _calories = 0.0;
      _distance = 0.0;
      _heartRate = 0.0;
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('health_today_steps');
      await prefs.remove('health_today_calories');
      await prefs.remove('health_today_distance');
      await prefs.remove('health_today_heart_rate');
      
      // Refresh with backend to see if external activities remain
      await silentSyncToday();
    } catch (e) {
      debugPrint('Error disconnecting provider: $e');
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> manualSync() async {
    _setLoading(true);
    try {
      await silentSyncToday();
      debugPrint('Manual sync completed.');
    } catch (e) {
      debugPrint('Error during manual sync: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> silentSyncToday() async {
    debugPrint('Initiating consolidated silent sync for today.');
    try {
      Map<String, dynamic>? localData;
      if (_connectedProvider != HealthProviderType.none) {
        localData = await _healthRepository.fetchAndDeduplicateData(DateTime.now());
      }
      
      // Check Garmin/Strava account-level integration status in background
      final integrations = await _healthRepository.checkAccountIntegrations();
      _isGarminConnected = integrations['garmin'] ?? _isGarminConnected;
      _isStravaConnected = integrations['strava'] ?? _isStravaConnected;
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('health_garmin_connected', _isGarminConnected);
      await prefs.setBool('health_strava_connected', _isStravaConnected);

      final backendSummary = await _healthRepository.fetchDailyActivitySummary(DateTime.now());
      _updateConsolidatedData(localData: localData, backendSummary: backendSummary);
      debugPrint('Consolidated silent sync for today completed.');
    } catch (e) {
      debugPrint('Error during silent sync: $e');
    }
  }
}
