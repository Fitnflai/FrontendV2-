import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fitnflaifrontendv2/services/health/health_repository.dart';

class HealthProvider extends ChangeNotifier {
  final HealthRepository _healthRepository;
  HealthProviderType _connectedProvider = HealthProviderType.none;
  bool _isLoading = false;
  bool _hasExternalActivities = false;
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
  List<String> get externalSources => _externalSources;
  DateTime? get lastSyncTime => _lastSyncTime;

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
    _externalSources = prefs.getStringList('health_external_sources') ?? [];
    final lastSyncMillis = prefs.getInt('health_last_sync_time');
    if (lastSyncMillis != null) {
      _lastSyncTime = DateTime.fromMillisecondsSinceEpoch(lastSyncMillis);
    }
    
    notifyListeners();
  }

  void _updateConsolidatedData({
    Map<String, dynamic>? localData,
    Map<String, dynamic>? backendSummary,
  }) async {
    // 1. Datos locales del sensor
    final localSteps = (localData?['pasos'] as int?) ?? 0;
    final localCalories = (localData?['calorias_quemadas'] as num?)?.toDouble() ?? 0.0;
    final localDistance = (localData?['distancia_km'] as num?)?.toDouble() ?? 0.0;
    final localHeartRate = (localData?['ritmo_cardiaco_promedio'] as num?)?.toDouble() ?? 0.0;

    // 2. Datos del backend (Garmin / Strava)
    final backendDistance = (backendSummary?['distancia_total_km'] as num?)?.toDouble() ?? 0.0;
    final backendHeartRate = (backendSummary?['frecuencia_cardiaca_promedio'] as num?)?.toDouble() ?? 0.0;
    final backendCalories = (backendSummary?['calorias_actividad'] as num?)?.toDouble() ?? 0.0;
    final tienePasosBackend = backendSummary?['tiene_pasos'] == true;
    final backendSteps = tienePasosBackend ? ((backendSummary?['pasos_dia'] as int?) ?? 0) : 0;
    
    final totalActividades = (backendSummary?['total_actividades'] as int?) ?? 0;
    final fuentesRaw = backendSummary?['fuentes'] as List<dynamic>?;
    _hasExternalActivities = totalActividades > 0 || (fuentesRaw != null && fuentesRaw.isNotEmpty);
    _externalSources = fuentesRaw?.map((e) => e.toString()).toList() ?? [];

    // 3. Regla de negocio: Priorizar sensor de Health Connect / HealthKit
    // Pasos:
    if (localSteps > 0) {
      _steps = localSteps;
    } else if (tienePasosBackend && backendSteps > 0) {
      _steps = backendSteps;
    } else {
      _steps = localSteps;
    }

    // Distancia:
    if (localDistance > 0) {
      _distance = localDistance;
    } else if (backendDistance > 0) {
      _distance = backendDistance;
    } else {
      _distance = localDistance;
    }

    // Ritmo cardíaco:
    if (localHeartRate > 0) {
      _heartRate = localHeartRate;
    } else if (backendHeartRate > 0) {
      _heartRate = backendHeartRate;
    } else {
      _heartRate = localHeartRate;
    }

    // Calorías:
    if (localCalories > 0) {
      _calories = localCalories;
    } else if (backendCalories > 0) {
      _calories = backendCalories;
    } else {
      _calories = localCalories;
    }

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
      final backendSummary = await _healthRepository.fetchDailyActivitySummary(DateTime.now());
      _updateConsolidatedData(localData: localData, backendSummary: backendSummary);
      debugPrint('Consolidated silent sync for today completed.');
    } catch (e) {
      debugPrint('Error during silent sync: $e');
    }
  }
}
