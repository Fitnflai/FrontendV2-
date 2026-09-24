import '../../services/auth_service.dart';
import '../../models/usuario.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthRepository {
  AuthRepository({required AuthService authService}) : _authService = authService;

  final AuthService _authService;
  Usuario? _cachedUser;

  Future<String?> getToken() async {
    return await _authService.getToken();
  }

  Future<Usuario?> getCurrentUser() async {
    if (_cachedUser != null) return _cachedUser;

    final token = await _authService.getToken();
    if (token == null) return null;

    final userData = await _authService.getCurrentUser();
    _cachedUser = Usuario.fromJson(userData);
    
    // Opcional: Persistir en local storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cached_user', jsonEncode(userData));
    
    return _cachedUser;
  }

  void clearCache() {
    _cachedUser = null;
  }
}
