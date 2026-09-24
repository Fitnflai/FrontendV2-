import 'dart:convert';
import '../../services/cached_http.dart';

class WorkoutRepository {
  final String _baseUrl = 'https://apifitnflai.com';

  Future<List<dynamic>> fetchWeeklyWorkouts(String token, String? userId, String startDate) async {
    if (userId != null && userId.isNotEmpty) {

    }

    final response = await CachedHttp.get(
      Uri.parse('$_baseUrl/entrenamientos/semana?start_date=$startDate'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      return decoded['plan'] as List<dynamic>? ?? [];
    }
    throw Exception('Error al cargar entrenamientos');
  }
}
