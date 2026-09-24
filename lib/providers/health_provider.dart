
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fitnflaifrontendv2/services/health/health_repository.dart';

class HealthProvider extends ChangeNotifier {
  final HealthRepository _healthRepository;
  HealthProviderType _connectedProvider = HealthProviderType.none;
  bool _isLoading = false;

  HealthProvider(this._healthRepository) {
    _loadConnectedProvider();
  }

  HealthProviderType get connectedProvider => _connectedProvider;
  bool get isLoading => _isLoading;

  Future<void> _loadConnectedProvider() async {
    final prefs = await SharedPreferences.getInstance();
    final savedProviderId = prefs.getString('health_connected_provider') ?? 'none';
    _connectedProvider = HealthProviderType.values.firstWhere(
      (e) => e.id == savedProviderId,
      orElse: () => HealthProviderType.none,
    );
    notifyListeners();
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
        await _healthRepository.fetchAndDeduplicateData(DateTime.now()); // Initial sync
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
      await _healthRepository.fetchAndDeduplicateData(DateTime.now());
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
      await _healthRepository.fetchAndDeduplicateData(DateTime.now());
      debugPrint('Silent sync for today completed.');
    } catch (e) {
      debugPrint('Error during silent sync: $e');
    }
  }
}
