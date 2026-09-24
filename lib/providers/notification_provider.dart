import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../models/notification.dart';
import '../services/notification_service.dart';
import '../services/profile_service.dart';

class NotificationProvider with ChangeNotifier {
  final NotificationService? _notificationService;

  List<Notification> _notifications = [];
  bool _isLoading = false;
  String? _error;
  String? _token;
  String? _notificationTime;
  String? get notificationTime => _notificationTime;

  NotificationProvider([this._notificationService]);

  List<Notification> get all => _notifications;
  List<Notification> get noLeidas =>
      _notifications.where((n) => !n.read).toList();
  int get unreadCount => noLeidas.length;
  bool get hasUnread => unreadCount > 0;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadNotifications(String token) async {
    _token = token;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _notifications = await _notificationService!.fetchNotifications(token);
      _notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt)); // Sort by newest first
    } catch (e) {
      _error = e.toString();
      debugPrint('Error loading notifications: $_error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> markAsRead(String id, {String? token}) async {
    final int index = _notifications.indexWhere((n) => n.id == id);
    if (index == -1) return;

    final Notification originalNotification = _notifications[index];
    if (originalNotification.read) return; // Already read

    // Optimistic update
    _notifications[index] = originalNotification.copyWith(read: true);
    notifyListeners();

    final activeToken = token ?? _token;
    if (activeToken == null) {
      debugPrint('Error: Token not available to mark notification as read.');
      // Optionally throw an error or handle this case as appropriate
      return;
    }

    try {
      await _notificationService!.markNotificationAsRead(activeToken, id);
    } catch (e) {
      // Rollback on error
      _notifications[index] = originalNotification.copyWith(read: false);
      _error = e.toString();
      debugPrint('Error marking notification as read: $_error');
    } finally {
      notifyListeners();
    }
  }

  // Backward compatibility with existing UI
  Future<void> marcarLeida(String id) => markAsRead(id);

  Future<void> marcarTodasLeidas(String token) async {
    if (_notificationService == null) return;
    _isLoading = true;
    _error = null;
    notifyListeners();

    // Find all currently unread notifications
    final unreadList = _notifications.where((n) => !n.read).toList();

    try {
      // Mark all locally first for optimistic UI
      _notifications = _notifications.map((n) => n.copyWith(read: true)).toList();
      notifyListeners();

      // Call service for each previously unread notification
      await Future.wait(unreadList.map((n) => _notificationService.markNotificationAsRead(token, n.id)));
    } catch (e) {
      final errorMsg = e.toString();
      debugPrint('Error marking all notifications as read: $errorMsg');
      // On error, reload notifications to get correct state from server
      await loadNotifications(token);
      _error = errorMsg;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void eliminar(String id) {
    _notifications.removeWhere((n) => n.id == id);
    notifyListeners();
}

  Future<void> setSchedule(String token, String notificationTime) async {
    final originalTime = _notificationTime;
    _notificationTime = notificationTime;
    _isLoading = true;
    notifyListeners();
    try {
      await _notificationService!.setSchedule(token, notificationTime);
    } catch (e) {
      _notificationTime = originalTime; // Rollback
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> initPushNotifications(String token) async {
    final fcmToken = await _notificationService?.fetchFcmToken();
    if (fcmToken != null) {
      await _sendFcmTokenWithFallback(token, fcmToken);
    }
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      await _sendFcmTokenWithFallback(token, newToken);
    });
    
    // 4. Set up foreground message listener to automatically reload notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Foreground message received: ${message.messageId}');
      loadNotifications(token);
    });
  }

  Future<void> _sendFcmTokenWithFallback(String token, String fcmToken) async {
    try {
      await _notificationService!.updateFcmToken(token, fcmToken);
      debugPrint('FCM Token registered on dedicated endpoint.');
    } catch (e) {
      debugPrint('Dedicated FCM registration failed ($e). Falling back to profile updates...');
      try {
        await ProfileService().updateProfile(token, fcmToken: fcmToken);
        debugPrint('FCM token sent successfully via fallback profile endpoint.');
      } catch (err) {
        debugPrint('FCM fallback profile registration also failed: $err');
      }
    }
  }
}
