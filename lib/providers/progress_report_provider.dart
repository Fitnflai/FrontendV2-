import 'package:flutter/material.dart';
import '../models/progress_report.dart';
import '../services/progress_service.dart';

enum ProgressReportStatus { initial, loading, loaded, error }

class ProgressReportProvider with ChangeNotifier {
  final ProgressService _service;
  ProgressReport? _report;
  ProgressReportStatus _status = ProgressReportStatus.initial;
  String? _errorMessage;
  int _weekOffset = 0;
  bool _hasNoData = false;

  ProgressReport? get report => _report;
  ProgressReportStatus get status => _status;
  String? get errorMessage => _errorMessage;
  int get weekOffset => _weekOffset;
  bool get hasNoData => _hasNoData;
  String? get recentReportId => _report?.idReporteSemanal;

  ProgressReportProvider(this._service);

  Future<void> fetchProgressReport({required String token, int weekOffset = 0}) async {
    _status = ProgressReportStatus.loading;
    _errorMessage = null;
    _weekOffset = weekOffset;
    _hasNoData = false;
    notifyListeners();
    try {
      _report = await _service.fetchProgressReport(token: token, weekOffset: weekOffset);
      _status = ProgressReportStatus.loaded;
      
      // Si la API responde con éxito pero no hay ningún dato histórico cargado, activamos la alerta de falta de datos
      if (_report != null && 
          _report!.evolucionIndiceBienestar.isEmpty && 
          _report!.historialPeso.isEmpty) {
        _hasNoData = true;
      }
    } catch (e) {
      debugPrint('🚨 ProgressReportProvider Exception: $e');
      _errorMessage = e.toString();
      
      // Fallback a Reporte de datos vacíos de forma amigable para no romper la UI
      _report = emptyMockReport;
      _status = ProgressReportStatus.loaded;
      _hasNoData = true;
    } finally {
      notifyListeners();
    }
  }

  static final ProgressReport emptyMockReport = ProgressReport(
    semanaInfo: "Semana --",
    fechaInicio: "-",
    fechaFin: "-",
    actualizado: "-",
    alertas: const Alert(
      activa: false,
      detalle: "",
    ),
    mensajeIa: "Aún no tenemos datos suficientes para medir tu progreso. Regresa cuando pase una semana y verás tu progreso registrado.",
    indiceBienestar: 0,
    variacionIndiceBienestar: 0,
    detalleFactorMovement: const GeneralFactorDetail(puntaje: 0, variacion: 0),
    detalleFactorHidratacion: const FactorHydrationDetail(
      puntaje: HydrationPuntaje(
        consumoTotalMl: 0,
        scoreHidratacion: 0,
        requerimientoTotalMl: 0,
      ),
      variacion: 0,
    ),
    detalleFactorEdadCorporal: const GeneralFactorDetail(puntaje: 0, variacion: 0),
    detalleFactorCargaMuscular: const GeneralFactorDetail(puntaje: 0, variacion: 0),
    detalleFactorPesoComposicion: const FactorWeightDetail(
      puntaje: WeightPuntaje(
        tag: "",
        puntaje: 0,
      ),
      variacion: 0,
    ),
    evolucionIndiceBienestar: [],
    historialPeso: [],
    metricasSecundarias: const SecondaryMetrics(
      actual: SecondaryMetricValues(deficitHidrico: 0, vo2Max: 0),
      anterior: null,
    ),
    grasa: const CurrentPreviousValue(actual: 0, anterior: null),
    musculos: const CurrentPreviousValue(actual: 0, anterior: null),
    calorias: const CaloriasDetail(caloriasAct: 0, caloriasAnt: 0, diferencia: 0),
    tiempoActivo: const ActiveTimeDetail(
      totalMinutos: 0,
      sesionesCompletadas: 0,
      sesionesTotales: 0,
      diferenciaSesiones: 0,
    ),
  );
}
