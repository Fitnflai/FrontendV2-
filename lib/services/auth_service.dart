import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'cached_http.dart';

class AuthService {
  static const _baseUrl  = 'https://apifitnflai.com';
  static const _tokenKey = 'auth_token';

  // ── Login ────────────────────────────────────────────────────
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
        },
      body: {
        'username': email,
        'password': password,
        'grant_type': 'password',
      },
    );

    debugPrint('LOGIN STATUS: ${response.statusCode}');
    debugPrint('LOGIN BODY: ${response.body}');

    Map<String, dynamic> data;
    try {
      final dynamic rawBody = jsonDecode(response.body);
      if (rawBody is Map<String, dynamic>) {
        data = rawBody;
      } else if (rawBody is List && rawBody.isNotEmpty) {
        data = rawBody.first as Map<String, dynamic>;
      } else {
        data = {};
      }
    } catch (_) {
      throw Exception('Error del servidor. Intenta de nuevo.');
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Token viene como access_token directo según el swagger
      final token = data['access_token'] as String? ??
                    data['token']?['access_token'] as String? ??
                    data['token'] as String?;
      if (token != null) await _saveToken(token);
      return data;
    }

    final msg = data['detail']  is String
        ? data['detail'] as String
        : data['message'] as String? ?? 'Correo o contraseña incorrectos';
    throw Exception(msg);
  }

  // ── Register ─────────────────────────────────────────────────
  Future<Map<String, dynamic>> register(
    String email,
    String password,
    String nombre, {
    String? username,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email':    email,
        'password': password,
        'nombre':   nombre,
        if (username != null && username.isNotEmpty) 'apodo': username,
      }),
    );

    debugPrint('REGISTER STATUS: ${response.statusCode}');
    debugPrint('REGISTER BODY: ${response.body}');

    // Proteger contra respuestas no-JSON (HTML de error 500, etc.)
    Map<String, dynamic> data;
    try {
      final dynamic rawBody = jsonDecode(response.body);
      if (rawBody is Map<String, dynamic>) {
        data = rawBody;
      } else if (rawBody is List && rawBody.isNotEmpty) {
        data = rawBody.first as Map<String, dynamic>;
      } else {
        data = {};
      }
    } catch (_) {
      throw Exception('Error del servidor. Intenta de nuevo.');
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      final token = data['access_token']            as String? ??
                    data['token']?['access_token']  as String? ??
                    data['token']                   as String?;
      if (token != null) await _saveToken(token);
      return data;
    }

    // Error 422 — detalle de validación
    if (data['detail'] is List) {
      final detail = data['detail'] as List;
      final msg = detail.isNotEmpty
          ? detail.first['msg'] as String? ?? 'Error de validación'
          : 'Error de validación';
      throw Exception(msg);
    }

    final msg = data['message'] as String? ??
                data['detail']  as String? ??
                'Error al registrar';
    throw Exception(msg);
  }

  // ── Get current user ─────────────────────────────────────────
  Future<Map<String, dynamic>> getCurrentUser() async {
    final token = await getToken();
    if (token == null) throw Exception('No hay sesión activa');

    final response = await CachedHttp.get(
      Uri.parse('$_baseUrl/users/me'),
      headers: {
        'Content-Type':  'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(const Duration(seconds: 8));

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    throw Exception('Sesión expirada');
  }

  // ── Google Sign In ───────────────────────────────────────────
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId: '534984050804-nfbgd9vhfjh240gpdivvbm9pptres87m.apps.googleusercontent.com',
    scopes: ['email', 'profile'],
  );

  Future<Map<String, dynamic>> loginWithGoogle() async {
    await _googleSignIn.signOut();
    final GoogleSignInAccount? account = await _googleSignIn.signIn();
    if (account == null) throw Exception('Inicio de sesión cancelado');

    final GoogleSignInAuthentication googleAuth =
        await account.authentication;
    final String? idToken = googleAuth.idToken;
    if (idToken == null) throw Exception('No se pudo obtener el token de Google');

    debugPrint('GOOGLE ID TOKEN: $idToken');

    // 3. Envía el id_token al backend
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/google'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id_token': idToken}),
    );

    debugPrint('GOOGLE LOGIN STATUS: ${response.statusCode}');
    debugPrint('GOOGLE LOGIN BODY: ${response.body}');

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200 || response.statusCode == 201) {
      final token = data['access_token'] as String?;
      if (token != null) await _saveToken(token);
      return data;
    }

    final msg = data['detail'] is String
        ? data['detail'] as String
        : data['message'] as String? ?? 'Error con Google';
    throw Exception(msg);
  }

  // ── Apple Sign In ────────────────────────────────────────────
  Future<Map<String, dynamic>> loginWithApple() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    final identityToken = credential.identityToken;
    if (identityToken == null) throw Exception('No se pudo obtener el token de Apple');

    final fullName = [
      credential.givenName,
      credential.familyName,
    ].where((e) => e != null).join(' ');

    debugPrint('APPLE IDENTITY TOKEN: $identityToken');

    final response = await http.post(
      Uri.parse('$_baseUrl/auth/apple'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'identity_token': identityToken,
        if (fullName.isNotEmpty) 'full_name': fullName,
      }),
    );

    debugPrint('APPLE LOGIN STATUS: ${response.statusCode}');
    debugPrint('APPLE LOGIN BODY: ${response.body}');

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200 || response.statusCode == 201) {
      final token = data['access_token'] as String?;
      if (token != null) await _saveToken(token);
      return data;
    }

    final msg = data['detail'] is String
        ? data['detail'] as String
        : data['message'] as String? ?? 'Error con Apple';
    throw Exception(msg);
  }

  Future<void> signOutGoogle() async {
    await _googleSignIn.signOut();
  }
  Future<void> saveToken(String token) async {
    await _saveToken(token);
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    CachedHttp.clearCache();
  }

  Future<void> deleteAccount(String token) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/users/delete-me'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    debugPrint('DELETE ACCOUNT STATUS: ${response.statusCode}');
    debugPrint('DELETE ACCOUNT BODY: ${response.body}');

    if (response.statusCode != 200 && response.statusCode != 201) {
      try {
        final data = jsonDecode(response.body);
        final msg = data['detail'] is String
            ? data['detail'] as String
            : data['message'] as String? ?? 'Error al eliminar cuenta';
        throw Exception(msg);
      } catch (e) {
        if (e is Exception) rethrow;
        throw Exception('Error al eliminar cuenta (${response.statusCode})');
      }
    }
  }
}