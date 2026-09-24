abstract class BaseHealthService {
  String get providerId;
  Future<bool> checkAvailability();
  Future<bool> requestPermissions();
  Future<Map<String, dynamic>?> fetchSyncData(DateTime date);
  Future<void> disconnect();
}
