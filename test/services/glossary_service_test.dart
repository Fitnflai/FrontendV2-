import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:fitnflaifrontendv2/services/glossary_service.dart';

import 'payments_service_test.mocks.dart'; // Reuses MockClient

void main() {
  group('GlossaryService', () {
    late GlossaryService glossaryService;
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
      glossaryService = GlossaryService(httpClient: mockClient);
    });

    test('fetchGlossaryTerms success', () async {
      final mockResponseList = [
        {
          'id': '49d6c42f-a6f7-4573-bf76-c332c34ce057',
          'termino': 'REP',
          'descripcion_es': 'Una repetición',
          'descripcion_en': 'One repetition',
        }
      ];

      when(mockClient.get(
        Uri.parse('https://apifitnflai.com/admin/obtener-terminos-glosario'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response.bytes(
            utf8.encode(json.encode(mockResponseList)),
            200,
            headers: {'content-type': 'application/json; charset=utf-8'},
          ));

      final terms = await glossaryService.fetchGlossaryTerms();
      expect(terms, hasLength(1));
      expect(terms[0].id, '49d6c42f-a6f7-4573-bf76-c332c34ce057');
      expect(terms[0].termino, 'REP');
      expect(terms[0].descripcionEs, 'Una repetición');
      expect(terms[0].descripcionEn, 'One repetition');
    });

    test('fetchGlossaryTerms failure status code', () async {
      when(mockClient.get(
        Uri.parse('https://apifitnflai.com/admin/obtener-terminos-glosario'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response('Not Found', 404));

      expect(() => glossaryService.fetchGlossaryTerms(), throwsException);
    });
  });
}
