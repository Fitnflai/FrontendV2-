import 'package:flutter_test/flutter_test.dart';
import 'package:fitnflaifrontendv2/models/glossary_term.dart';
import 'package:fitnflaifrontendv2/providers/glossary_provider.dart';
import 'package:fitnflaifrontendv2/services/glossary_service.dart';

class FakeGlossaryService extends GlossaryService {
  final List<GlossaryTerm> mockTerms;
  final bool shouldFail;

  FakeGlossaryService({this.mockTerms = const [], this.shouldFail = false});

  @override
  Future<List<GlossaryTerm>> fetchGlossaryTerms() async {
    if (shouldFail) {
      throw Exception('Mock network error');
    }
    return mockTerms;
  }
}

void main() {
  group('GlossaryProvider', () {
    test('initial load success', () async {
      final mockTerms = [
        const GlossaryTerm(
          id: '1',
          termino: 'REP',
          descripcionEs: 'Repetición',
          descripcionEn: 'Repetition',
        ),
      ];
      final fakeService = FakeGlossaryService(mockTerms: mockTerms);
      final provider = GlossaryProvider(glossaryService: fakeService);

      expect(provider.isLoading, true);

      // Wait for async constructor initialization to complete
      await Future.delayed(Duration.zero);

      expect(provider.isLoading, false);
      expect(provider.error, isNull);
      expect(provider.terms, hasLength(1));
      expect(provider.terms[0].termino, 'REP');
    });

    test('initial load failure', () async {
      final fakeService = FakeGlossaryService(shouldFail: true);
      final provider = GlossaryProvider(glossaryService: fakeService);

      expect(provider.isLoading, true);

      // Wait for async constructor initialization to complete
      await Future.delayed(Duration.zero);

      expect(provider.isLoading, false);
      expect(provider.error, isNotNull);
      expect(provider.terms, isEmpty);
    });
  });
}
