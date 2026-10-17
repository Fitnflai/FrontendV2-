import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/glossary_term.dart';

class GlossaryService {
  final http.Client httpClient;

  GlossaryService({http.Client? httpClient})
      : httpClient = httpClient ?? http.Client();

  Future<List<GlossaryTerm>> fetchGlossaryTerms() async {
    final url = Uri.parse('https://apifitnflai.com/admin/obtener-terminos-glosario');
    final response = await httpClient.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final String decodedBody = utf8.decode(response.bodyBytes);
      final List<dynamic> body = json.decode(decodedBody);
      return body.map((dynamic item) => GlossaryTerm.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load glossary terms: ${response.statusCode} ${response.body}');
    }
  }
}
