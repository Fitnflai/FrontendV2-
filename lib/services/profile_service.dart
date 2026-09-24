import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'cached_http.dart';

class ProfileService {
  static const _base = 'https://apifitnflai.com';

  // ── GET /users/me ─────────────────────────────────────────────
  Future<Map<String, dynamic>> getMe(String token) async {
    final res = await CachedHttp.get(
      Uri.parse('$_base/users/me'),
      headers: _headers(token),
    );
    _check(res);
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  // ── PATCH /users/me ───────────────────────────────────────────
  Future<Map<String, dynamic>> updateProfile(
    String token, {
    String? nombre,
    String? fechaNacimiento,
    String? genero,
    String? intensidadNotificaciones,
    String? fcmToken,
  }) async {
    final body = <String, dynamic>{};
    if (nombre != null) body['nombre'] = nombre;
    if (fechaNacimiento != null) body['fecha_nacimiento'] = fechaNacimiento;
    if (genero != null) body['genero'] = genero;
    if (intensidadNotificaciones != null)
      body['intensidad_notificaciones'] = intensidadNotificaciones;
    if (fcmToken != null) body['fcm_token'] = fcmToken;

    final res = await CachedHttp.patch(
      Uri.parse('$_base/users/me'),
      headers: _headers(token),
      body: jsonEncode(body),
    );
    _check(res);
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  // ── PATCH /users/configurar-reporte ──────────────────────────
  Future<void> updateReporte(
    String token, {
    required String diaReporte,
    required String horaReporte,
  }) async {
    final res = await CachedHttp.patch(
      Uri.parse('$_base/users/configurar-reporte'),
      headers: _headers(token),
      body: jsonEncode({'dia_reporte': diaReporte, 'hora_reporte': horaReporte}),
    );
    _check(res);
  }







  // ── GET /users/usuarios/mi-plan-activo ────────────────────────
  Future<Map<String, dynamic>?> getPlanActivo(String token) async {
    final res = await CachedHttp.get(
      Uri.parse('$_base/users/usuarios/mi-plan-activo'),
      headers: _headers(token),
    );
    if (res.statusCode == 404) return null;
    _check(res);
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  // ── GET /users/estado-seguridad-parq ─────────────────────────
  Future<String> getParqStatus(String token) async {
    final res = await CachedHttp.get(
      Uri.parse('$_base/users/estado-seguridad-parq'),
      headers: _headers(token),
    );
    _check(res);
    final decoded = jsonDecode(res.body);
    if (decoded is Map<String, dynamic>) {
      return (decoded['estado'] ?? decoded['status'] ?? decoded['state'] ?? decoded.toString()).toString();
    }
    return decoded.toString();
  }

  // ── GET /users/mis-citas ──────────────────────────────────────────
  Future<List<dynamic>> getMisCitas(String token) async {
    final res = await CachedHttp.get(
      Uri.parse('$_base/users/mis-citas'),
      headers: _headers(token),
    );
    _check(res);
    return jsonDecode(res.body) as List<dynamic>;
  }

  // ── Helpers ───────────────────────────────────────────────────
  Map<String, String> _headers(String token) => {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };

  void _check(http.Response res) {
    if (res.statusCode < 200 || res.statusCode >= 300) {
      debugPrint('ProfileService error ${res.statusCode}: ${res.body}');
      throw Exception('Error ${res.statusCode}');
    }
  }
}
