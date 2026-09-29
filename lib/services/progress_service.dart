
// lib/services/progress_service.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';

import '../models/progress_report.dart';
import 'cached_http.dart';

class ProgressService {
  static const _baseUrl = 'https://apifitnflai.com';

  Future<ProgressReport> fetchProgressReport({
    required String token,
    required String fechaInicio,
    required String fechaFin,
  }) async {
    final uri = Uri.parse('$_baseUrl/reportes/resumen-progreso?fecha_inicio=$fechaInicio&fecha_fin=$fechaFin');
    
    debugPrint('🌐 Fetching progress report from: $uri');
    final response = await CachedHttp.get(uri, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });
    
    debugPrint('🌐 Progress API Response Code: ${response.statusCode}');
    
    if (response.statusCode == 200) {
      try {
        final decoded = json.decode(response.body);
        return ProgressReport.fromJson(decoded);
      } catch (e, stack) {
        debugPrint('🚨 ERROR PARSING PROGRESS REPORT JSON: $e');
        debugPrint('🚨 Stacktrace: $stack');
        rethrow;
      }
    } else {
      debugPrint('🚨 Progress API Server Error Body: ${response.body}');
      throw Exception('Failed to load progress report: ${response.statusCode}');
    }
  }
}
