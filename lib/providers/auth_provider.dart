import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../data/repositories/auth_repository.dart';
import '../services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/cached_http.dart';

enum AuthStatus { uninitialized, authenticated, unauthenticated }

class AuthProvider with ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository(authService: AuthService());
  final AuthService _authService = AuthService();

  AuthStatus _status       = AuthStatus.uninitialized;
  Usuario?   _user;
  String?    _token;
  bool       _isLoading    = false;
  String?    _errorMessage;

  AuthStatus get status       => _status;
  Usuario?   get user         => _user;
  String?    get token        => _token;
  bool       get isLoading    => _isLoading;
  String?    get errorMessage => _errorMessage;
  String?    get nivelActividad => _user?.nivelActividad;

  String? onboardingFechaInicio;
  int?    onboardingSemanas;

  AuthProvider() {
    Future.delayed(Duration.zero, () => tryAutoLogin());
  }

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  void _updateFromResponse(Map<String, dynamic> data) {
    _token = data['access_token'] as String? ??
             data['token']?['access_token'] as String? ??
             data['token'] as String?;

    // Asegurarse de que pasamos el objeto correcto a fromJson
    // El backend suele enviar { "user": {...} } o el objeto usuario directamente
    final userJson = data['user'] is Map<String, dynamic> ? data['user'] : data;
    
    _user         = Usuario.fromJson(userJson);
    _status       = AuthStatus.authenticated;
    _errorMessage = null;

    debugPrint('TOKEN OK: $_token');
    debugPrint('USER: ${_user?.email}');
    
    // Guardar token siempre para sobreescribir tokens viejos o inválidos
    if (_token != null) {
      _authService.saveToken(_token!);
    }

    // Guardar el perfil de usuario localmente para soporte offline
    if (_user != null) {
      SharedPreferences.getInstance().then((prefs) {
        prefs.setString('cached_user_profile', jsonEncode(_user!.toJson()));
      });
    }
  }

  Future<void> _refreshUser() async {
    try {
      CachedHttp.clearCache(); // Invalidate HTTP cache to fetch freshest profile data
      _authRepository.clearCache();
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        _user = user;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('cached_user_profile', jsonEncode(user.toJson()));
        notifyListeners();
        debugPrint('USER REFRESHED: disciplina=${_user?.nombreDisciplina}');
      }
    } catch (e) {
      debugPrint('REFRESH USER ERROR: $e');
    }
  }

  Future<void> refreshUser() => _refreshUser();

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // ── Login ─────────────────────────────────────────────────────
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    try {
      final data = await _authService.login(email, password);
      _updateFromResponse(data);
      await _refreshUser(); // Refresh profile post-login to synchronize subscription state
      notifyListeners();
      return true;
    } catch (e) {
      _status       = AuthStatus.unauthenticated;
      _errorMessage = _friendlyError(e.toString());
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ── Register ──────────────────────────────────────────────────
  Future<bool> register(
    String email,
    String password,
    String nombre, {
    String? username,
  }) async {
    _setLoading(true);
    try {
      final data = await _authService.register(
          email, password, nombre, username: username);
      _updateFromResponse(data);
      await _refreshUser(); // Refresh profile post-register to synchronize subscription state
      notifyListeners();
      return true;
    } catch (e) {
      _status       = AuthStatus.unauthenticated;
      _errorMessage = _friendlyError(e.toString());
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ── Apple Login ───────────────────────────────────────────────
  Future<bool> loginWithApple() async {
    _setLoading(true);
    try {
      final data    = await _authService.loginWithApple();
      _token        = data['access_token'] as String?;
      _status       = AuthStatus.authenticated;
      _errorMessage = null;
      notifyListeners();
      await _refreshUser();
      return true;
    } catch (e) {
      _status       = AuthStatus.unauthenticated;
      _errorMessage = _friendlyError(e.toString());
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ── Google Login ──────────────────────────────────────────────
  Future<bool> loginWithGoogle() async {
    _setLoading(true);
    try {
      final data    = await _authService.loginWithGoogle();
      _token        = data['access_token'] as String?;
      debugPrint('GOOGLE TOKEN OK: $_token');
      _status       = AuthStatus.authenticated;
      _errorMessage = null;

      final isNewUser = data['is_new_user'] as bool? ?? false;
      debugPrint('GOOGLE isNewUser: $isNewUser');

      notifyListeners();
      await _refreshUser();
      return true;
    } catch (e) {
      _status       = AuthStatus.unauthenticated;
      _errorMessage = _friendlyError(e.toString());
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ── Auto Login ────────────────────────────────────────────────
  // Solo lee el token guardado — sin HTTP en startup para no bloquear
  Future<void> tryAutoLogin() async {
    try {
      _token = await _authService.getToken();
      if (_token == null) {
        _status = AuthStatus.unauthenticated;
        notifyListeners();
        return;
      }
      
      // Intentar cargar el perfil de usuario guardado localmente (para soporte offline inmediato)
      final prefs = await SharedPreferences.getInstance();
      final savedUserJson = prefs.getString('cached_user_profile');
      if (savedUserJson != null) {
        try {
          _user = Usuario.fromJson(jsonDecode(savedUserJson) as Map<String, dynamic>);
          _status = AuthStatus.authenticated;
          notifyListeners();
        } catch (e) {
          debugPrint('Error parsing cached user: $e');
        }
      }
      
      // Intentar sincronizar/actualizar los datos con el servidor en segundo plano
      try {
        final user = await _authRepository.getCurrentUser();
        if (user != null) {
          _user = user;
          await prefs.setString('cached_user_profile', jsonEncode(user.toJson()));
          _status = AuthStatus.authenticated;
          notifyListeners();
        }
      } catch (e) {
        debugPrint('Auto-login background fetch failed (offline or expired): $e');
        // Si no pudimos cargar el perfil localmente, o si es un error de token expirado (ej: 401), desautenticamos.
        // Si estamos simplemente offline pero tenemos perfil cargado localmente, lo mantenemos (permanece logueado).
        if (_user == null || e.toString().contains('401') || e.toString().contains('expirada')) {
          _status = AuthStatus.unauthenticated;
          _user = null;
          _token = null;
          await _authService.logout();
          notifyListeners();
        }
      }
    } catch (_) {
      _status = AuthStatus.unauthenticated;
      notifyListeners();
    }
  }

  // ── Logout ────────────────────────────────────────────────────
  Future<void> logout() async {
    try {
      final userId = _user?.id;
      if (userId != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('onboarding_completed_step_$userId');
      }
    } catch (e) {
      debugPrint('Error clearing onboarding cache: $e');
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('cached_user_profile');
    } catch (_) {}
    await _authService.logout();
    _status = AuthStatus.unauthenticated;
    _user   = null;
    _token  = null;
    notifyListeners();
  }

  // ── Error formatting ─────────────────────────────────────────
  String _friendlyError(String raw) {
    final msg = raw.replaceAll('Exception: ', '');
    if (msg.contains('credenciales') || msg.contains('password') ||
        msg.contains('Incorrect'))
      return 'Correo o contraseña incorrectos.';
    if (msg.contains('connection') || msg.contains('SocketException'))
      return 'Sin conexión a internet. Verifica tu red.';
    if (msg.contains('timeout'))
      return 'La conexión tardó demasiado. Intenta de nuevo.';
    return msg.isNotEmpty ? msg : 'Error inesperado. Intenta de nuevo.';
  }
}