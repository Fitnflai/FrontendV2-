
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/specialist.dart';
import '../models/turno.dart'; // Import the new Turno model

class SpecialistService {
  final http.Client httpClient;

  SpecialistService({http.Client? httpClient})
      : httpClient = httpClient ?? http.Client();
  final String _baseUrl = 'https://apifitnflai.com';

  Future<List<Specialist>> getSpecialists(String token) async {
    final url = Uri.parse('$_baseUrl/specialist/especialistas');
    final response = await httpClient.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => Specialist.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load specialists: ${response.statusCode} ${response.body}');
    }
  }

  Future<Map<String, dynamic>> solicitarCita(
    String token, {
    required int idEspecialista,
    int? idSeguimiento,
    required String fechaHora,
    required bool esExpress,
    required String descripcionCita,
    required String tipoCita,
  }) async {
    final url = Uri.parse('$_baseUrl/specialist/solicitar-cita');
    final Map<String, dynamic> body = {
      'id_especialista': idEspecialista,
      'fecha_hora': fechaHora,
      'es_express': esExpress,
      'descripcion_cita': descripcionCita,
      'tipo_cita': tipoCita,
    };
    if (idSeguimiento != null) {
      body['id_seguimiento'] = idSeguimiento;
    }

    final response = await httpClient.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to book appointment: ${response.statusCode} ${response.body}');
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<void> requestSpecialistTracking(String token, int specialistId) async {
    final url = Uri.parse('$_baseUrl/specialist/solicitar-seguimiento/$specialistId');
    final response = await httpClient.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({}), // Empty JSON object body
    );

    if (response.statusCode == 200) {
      // Successfully requested tracking
      return;
    } else {
      throw Exception('Failed to request specialist tracking: ${response.statusCode} ${response.body}');
    }
  }

  Future<List<Turno>> getSpecialistAvailability(
    String token,
    String fechaInicio,
    String fechaFin,
  ) async {
    final url = Uri.parse(
        '$_baseUrl/users/disponibilidad-especialista-vinculado?fecha_inicio=$fechaInicio&fecha_fin=$fechaFin');
    final response = await httpClient.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => Turno.fromJson(item)).toList();
    } else {
      throw Exception(
          'Failed to load specialist availability: ${response.statusCode} ${response.body}');
    }
  }
}
