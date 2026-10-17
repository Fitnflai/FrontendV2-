import 'package:flutter/material.dart';
import '../models/glossary_term.dart';
import '../services/glossary_service.dart';

class GlossaryProvider extends ChangeNotifier {
  final GlossaryService _glossaryService;

  List<GlossaryTerm> _terms = [];
  bool _isLoading = false;
  String? _error;

  GlossaryProvider({GlossaryService? glossaryService})
      : _glossaryService = glossaryService ?? GlossaryService() {
    fetchTerms();
  }

  List<GlossaryTerm> get terms => _terms;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchTerms() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _terms = await _glossaryService.fetchGlossaryTerms();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
