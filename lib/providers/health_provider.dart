
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fitnflaifrontendv2/services/health/health_repository.dart';

class HealthProvider extends ChangeNotifier {
  final HealthRepository _healthRepository;
  HealthProviderType _connectedProvider = HealthProviderType.none;
  bool _isLoading = false;

  int _steps = 0;
  double _calories = 0.0;
  double _distance = 0.0;

  HealthProvider(this._healthRepository) {
    _loadConnectedProvider();
  }

  HealthProviderType get connectedProvider => _connectedProvider;
  bool get isLoading => _isLoading;

  int get steps => _steps;
  double get calories => _calories;
  double get distance => _distance;

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
    
    notifyListeners();
  }

  void _updateTodayData(Map<String, dynamic>? data) async {
    if (data == null) return;
    _steps = data['pasos'] as int? ?? 0;
    _calories = (data['calorias_quemadas'] as num?)?.toDouble() ?? 0.0;
    _distance = (data['distancia_km'] as num?)?.toDouble() ?? 0.0;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('health_today_steps', _steps);
    await prefs.setDouble('health_today_calories', _calories);
    await prefs.setDouble('health_today_distance', _distance);
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
        final data = await _healthRepository.fetchAndDeduplicateData(DateTime.now()); // Initial sync
        _updateTodayData(data);
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
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('health_today_steps');
      await prefs.remove('health_today_calories');
      await prefs.remove('health_today_distance');
    } catch (e) {
      debugPrint('Error disconnecting provider: $e');
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> manualSync() async {
    if (_connectedProvider == HealthProviderType.none) {
      debugPrint('No provider connected for manual sync.');
      return;
    }
    _setLoading(true);
    try {
      final data = await _healthRepository.fetchAndDeduplicateData(DateTime.now());
      _updateTodayData(data);
      debugPrint('Manual sync completed.');
    } catch (e) {
      debugPrint('Error during manual sync: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> silentSyncToday() async {
    if (_connectedProvider == HealthProviderType.none) {
      debugPrint('No provider connected for silent sync.');
      return;
    }
    debugPrint('Initiating silent sync for today.');
    try {
      // This sync should be non-blocking and not update loading state for UI
      final data = await _healthRepository.fetchAndDeduplicateData(DateTime.now());
      _updateTodayData(data);
      debugPrint('Silent sync for today completed.');
    } catch (e) {
      debugPrint('Error during silent sync: $e');
    }
  }
}
