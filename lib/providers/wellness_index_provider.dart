import 'package:flutter/material.dart';
import '../models/wellness_factor.dart';
import '../models/progress_report.dart';

class WellnessIndexProvider with ChangeNotifier {
  List<WellnessFactor> _factors = [];
  String? _selectedFactorId;

  WellnessIndexProvider();

  List<WellnessFactor> get factors => _factors;

  WellnessFactor get selectedFactor =>
      _factors.firstWhere((factor) => factor.id == _selectedFactorId, orElse: () => _factors.first);

  void selectFactor(String factorId) {
    if (_selectedFactorId != factorId) {
      _selectedFactorId = factorId;
      notifyListeners();
    }
  }

  void updateFromProgressReport(ProgressReport report) {
    final List<String> commonLabels = report.evolucionIndiceBienestar.isNotEmpty
        ? report.evolucionIndiceBienestar.map((e) => e.semanaActual != null ? "Sem. ${e.semanaActual}" : 'Current').toList()
        : ['Current'];

    final String? previousSelectedFactorId = _selectedFactorId;

    _factors = [
      WellnessFactor(
        id: 'movement',
        nameEs: 'Movimiento',
        nameEn: 'Movement',
        weight: 0.30,
        scores: report.evolucionIndiceBienestar.isNotEmpty
            ? report.evolucionIndiceBienestar.map((e) => (e.puntaje ?? 0.0).toDouble()).toList()
            : [(report.detalleFactorMovement?.puntaje ?? 0.0).toDouble()],
        labels: commonLabels,
        colorResolver: (theme) => theme.primary,
      ),
      WellnessFactor(
        id: 'muscle_load',
        nameEs: 'Carga muscular',
        nameEn: 'Muscle Load',
        weight: 0.25,
        scores: report.evolucionIndiceBienestar.isNotEmpty
            ? report.evolucionIndiceBienestar.map((e) => (report.detalleFactorCargaMuscular?.puntaje ?? 0.0).toDouble()).toList()
            : [(report.detalleFactorCargaMuscular?.puntaje ?? 0.0).toDouble()],
        labels: commonLabels,
        colorResolver: (theme) => theme.redMid,
      ),
      WellnessFactor(
        id: 'weight_composition',
        nameEs: 'Peso y composición',
        nameEn: 'Weight & Composition',
        weight: 0.20,
        scores: report.historialPeso.isNotEmpty
            ? report.historialPeso.map((e) => (e.peso ?? 0.0).toDouble()).toList()
            : [(report.detalleFactorPesoComposicion?.puntaje ?? 0.0).toDouble()],
        labels: report.historialPeso.isNotEmpty
            ? report.historialPeso.map((e) => e.fecha != null && e.fecha!.length >= 10 ? e.fecha!.substring(5, 10) : 'Current').toList()
            : ['Current'],
        colorResolver: (theme) => theme.greenMid,
      ),
      WellnessFactor(
        id: 'hydration',
        nameEs: 'Hidratación',
        nameEn: 'Hydration',
        weight: 0.15,
        scores: report.evolucionIndiceBienestar.isNotEmpty
            ? report.evolucionIndiceBienestar.map((e) => (report.detalleFactorHidratacion?.puntaje ?? 0.0).toDouble()).toList()
            : [(report.detalleFactorHidratacion?.puntaje ?? 0.0).toDouble()],
        labels: commonLabels,
        colorResolver: (theme) => theme.principal.primary,
      ),
      WellnessFactor(
        id: 'body_age',
        nameEs: 'Edad corporal',
        nameEn: 'Body Age',
        weight: 0.10,
        scores: report.evolucionIndiceBienestar.isNotEmpty
            ? report.evolucionIndiceBienestar.map((e) => (report.detalleFactorEdadCorporal?.puntaje ?? 0.0).toDouble()).toList()
            : [(report.detalleFactorEdadCorporal?.puntaje ?? 0.0).toDouble()],
        labels: commonLabels,
        colorResolver: (theme) => theme.nutricion.primary,
      ),
    ];

    if (previousSelectedFactorId != null && _factors.any((f) => f.id == previousSelectedFactorId)) {
      _selectedFactorId = previousSelectedFactorId;
    } else if (_factors.isNotEmpty) {
      _selectedFactorId = _factors.first.id;
    } else {
      _selectedFactorId = null;
    }
    notifyListeners();
  }
}
