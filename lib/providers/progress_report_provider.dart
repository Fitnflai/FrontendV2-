import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/progress_report.dart';
import '../services/progress_service.dart';
import '../services/specialist_service.dart';

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
  bool get isGeneratingReport => _isGeneratingReport;

  bool _isGeneratingReport = false;

  ProgressReportProvider(this._service);

  Future<void> fetchProgressReport({required String token, int weekOffset = 0}) async {
    _status = ProgressReportStatus.loading;
    _errorMessage = null;
    _weekOffset = weekOffset;
    _hasNoData = false;
    notifyListeners();
    try {
      // Calcular fecha_inicio y fecha_fin locales basados en el weekOffset para cubrir la semana completa (Domingo a Lunes siguiente)
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final currentMonday = today.subtract(Duration(days: today.weekday - 1));
      final targetMonday = currentMonday.add(Duration(days: weekOffset * 7));
      
      // Expandimos el rango (desde el domingo anterior al lunes siguiente) para asegurar capturar el reporte semanal,
      // el cual se registra habitualmente los lunes al concluir o iniciar el ciclo.
      final targetSundayPrev = targetMonday.subtract(const Duration(days: 1));
      final targetMondayNext = targetMonday.add(const Duration(days: 7));

      String format(DateTime d) {
        final day = d.day.toString().padLeft(2, '0');
        final month = d.month.toString().padLeft(2, '0');
        final year = d.year;
        return '$year-$month-$day'; // YYYY-MM-DD
      }

      final fechaInicioStr = format(targetSundayPrev);
      final fechaFinStr = format(targetMondayNext);

      _report = await _service.fetchProgressReport(
        token: token,
        fechaInicio: fechaInicioStr,
        fechaFin: fechaFinStr,
      );
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

  Future<String?> generarReportePDF({required String token}) async {
    if (recentReportId == null || recentReportId!.trim().isEmpty) {
      _errorMessage = 'No hay un ID de reporte disponible.';
      notifyListeners();
      return null;
    }

    _isGeneratingReport = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final service = SpecialistService(); 
      final reportUrl = await service.generarReportePDF(token, recentReportId!);
      final uri = Uri.parse(reportUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return reportUrl;
      } else {
        throw Exception('No se pudo abrir la URL del reporte.');
      }
    } catch (e) {
      debugPrint('🚨 Error generando el reporte PDF: $e');
      _errorMessage = e.toString();
      return null;
    } finally {
      _isGeneratingReport = false;
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
    detalleFactorHidratacion: const GeneralFactorDetail(puntaje: 0, variacion: 0),
    detalleFactorEdadCorporal: const GeneralFactorDetail(puntaje: 0, variacion: 0),
    detalleFactorCargaMuscular: const GeneralFactorDetail(puntaje: 0, variacion: 0),
    detalleFactorPesoComposicion: const FactorWeightDetail(
      puntaje: 0,
      variacion: 0,
      imc: 0,
      pesoRegistrado: 0,
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
