import 'package:freezed_annotation/freezed_annotation.dart';

part 'progress_report.freezed.dart';
part 'progress_report.g.dart';

num? _parseNumericOrString(dynamic value) {
  if (value == null) return null;
  if (value is num) return value;
  if (value is String) {
    final cleanStr = value.replaceAll(RegExp(r'[^0-9.]'), '');
    return num.tryParse(cleanStr);
  }
  return null;
}

@freezed
abstract class ProgressReport with _$ProgressReport {
  const factory ProgressReport({
    @JsonKey(name: 'id_reporte_semanal') String? idReporteSemanal,
    @JsonKey(name: 'semana_info') String? semanaInfo,
    @JsonKey(name: 'fecha_inicio') String? fechaInicio,
    @JsonKey(name: 'fecha_fin') String? fechaFin,
    String? actualizado,
    Alert? alertas,
    @JsonKey(name: 'mensaje_ia') String? mensajeIa,
    @JsonKey(name: 'indice_bienestar') num? indiceBienestar,
    @JsonKey(name: 'variacion_indice_bienestar') num? variacionIndiceBienestar,
    @JsonKey(name: 'detalle_factor_movimiento') GeneralFactorDetail? detalleFactorMovement,
    @JsonKey(name: 'detalle_factor_hidratacion') FactorHydrationDetail? detalleFactorHidratacion,
    @JsonKey(name: 'detalle_factor_edad_corporal') GeneralFactorDetail? detalleFactorEdadCorporal,
    @JsonKey(name: 'detalle_factor_carga_muscular') GeneralFactorDetail? detalleFactorCargaMuscular,
    @JsonKey(name: 'detalle_factor_peso_composicion') FactorWeightDetail? detalleFactorPesoComposicion,
    @JsonKey(name: 'evolucion_indice_bienestar') @Default([]) List<WellnessIndexEvolution> evolucionIndiceBienestar,
    @JsonKey(name: 'historial_peso') @Default([]) List<WeightHistory> historialPeso,
    @JsonKey(name: 'metricas_secundarias') SecondaryMetrics? metricasSecundarias,
    CurrentPreviousValue? grasa,
    CurrentPreviousValue? musculos,
    CaloriasDetail? calorias,
    @JsonKey(name: 'tiempo_activo') ActiveTimeDetail? tiempoActivo,
  }) = _ProgressReport;

  factory ProgressReport.fromJson(Map<String, dynamic> json) => _$ProgressReportFromJson(json);
}

@freezed
abstract class Alert with _$Alert {
  const factory Alert({
    @Default(false) bool activa,
    String? detalle,
  }) = _Alert;
  factory Alert.fromJson(Map<String, dynamic> json) => _$AlertFromJson(json);
}

@freezed
abstract class GeneralFactorDetail with _$GeneralFactorDetail {
  const factory GeneralFactorDetail({
    num? puntaje,
    num? variacion,
  }) = _GeneralFactorDetail;
  factory GeneralFactorDetail.fromJson(Map<String, dynamic> json) => _$GeneralFactorDetailFromJson(json);
}

@freezed
abstract class FactorHydrationDetail with _$FactorHydrationDetail {
  const factory FactorHydrationDetail({
    HydrationPuntaje? puntaje,
    num? variacion,
  }) = _FactorHydrationDetail;
  factory FactorHydrationDetail.fromJson(Map<String, dynamic> json) => _$FactorHydrationDetailFromJson(json);
}

@freezed
abstract class HydrationPuntaje with _$HydrationPuntaje {
  const factory HydrationPuntaje({
    @JsonKey(name: 'consumo_total_ml') num? consumoTotalMl,
    @JsonKey(name: 'score_hidratacion') num? scoreHidratacion,
    @JsonKey(name: 'requerimiento_total_ml') num? requerimientoTotalMl,
  }) = _HydrationPuntaje;
  factory HydrationPuntaje.fromJson(Map<String, dynamic> json) => _$HydrationPuntajeFromJson(json);
}

@freezed
abstract class FactorWeightDetail with _$FactorWeightDetail {
  const factory FactorWeightDetail({
    WeightPuntaje? puntaje,
    num? variacion,
  }) = _FactorWeightDetail;
  factory FactorWeightDetail.fromJson(Map<String, dynamic> json) => _$FactorWeightDetailFromJson(json);
}

@freezed
abstract class WeightPuntaje with _$WeightPuntaje {
  const factory WeightPuntaje({
    String? tag,
    num? puntaje,
  }) = _WeightPuntaje;
  factory WeightPuntaje.fromJson(Map<String, dynamic> json) => _$WeightPuntajeFromJson(json);
}

@freezed
abstract class CurrentPreviousValue with _$CurrentPreviousValue {
  const factory CurrentPreviousValue({
    @JsonKey(fromJson: _parseNumericOrString) num? actual,
    @JsonKey(fromJson: _parseNumericOrString) num? anterior,
  }) = _CurrentPreviousValue;
  factory CurrentPreviousValue.fromJson(Map<String, dynamic> json) => _$CurrentPreviousValueFromJson(json);
}

@freezed
abstract class ActiveTimeDetail with _$ActiveTimeDetail {
  const factory ActiveTimeDetail({
    @JsonKey(name: 'total_minutos') num? totalMinutos,
    @JsonKey(name: 'sesiones_completadas') num? sesionesCompletadas,
    @JsonKey(name: 'sesiones_totales') num? sesionesTotales,
    @JsonKey(name: 'diferencia_sesiones') num? diferenciaSesiones,
  }) = _ActiveTimeDetail;
  factory ActiveTimeDetail.fromJson(Map<String, dynamic> json) => _$ActiveTimeDetailFromJson(json);
}

@freezed
abstract class SecondaryMetrics with _$SecondaryMetrics {
  const factory SecondaryMetrics({
    SecondaryMetricValues? actual,
    SecondaryMetricValues? anterior,
  }) = _SecondaryMetrics;
  factory SecondaryMetrics.fromJson(Map<String, dynamic> json) => _$SecondaryMetricsFromJson(json);
}

@freezed
abstract class SecondaryMetricValues with _$SecondaryMetricValues {
  const factory SecondaryMetricValues({
    @JsonKey(name: 'deficit_hidrico') num? deficitHidrico,
    @JsonKey(name: 'vo2_max') num? vo2Max,
  }) = _SecondaryMetricValues;
  factory SecondaryMetricValues.fromJson(Map<String, dynamic> json) => _$SecondaryMetricValuesFromJson(json);
}

@freezed
abstract class WellnessIndexEvolution with _$WellnessIndexEvolution {
  const factory WellnessIndexEvolution({
    String? fecha,
    @JsonKey(name: 'semana_actual') num? semanaActual,
    num? puntaje,
  }) = _WellnessIndexEvolution;
  factory WellnessIndexEvolution.fromJson(Map<String, dynamic> json) => _$WellnessIndexEvolutionFromJson(json);
}

@freezed
abstract class WeightHistory with _$WeightHistory {
  const factory WeightHistory({
    num? semana,
    String? fecha,
    @JsonKey(fromJson: _parseNumericOrString) num? peso,
    @JsonKey(fromJson: _parseNumericOrString) num? musculo,
    @JsonKey(fromJson: _parseNumericOrString) num? grasa,
  }) = _WeightHistory;
  factory WeightHistory.fromJson(Map<String, dynamic> json) => _$WeightHistoryFromJson(json);
}

@freezed
abstract class CaloriasDetail with _$CaloriasDetail {
  const factory CaloriasDetail({
    @JsonKey(name: 'calorias_act') num? caloriasAct,
    @JsonKey(name: 'calorias_ant') num? caloriasAnt,
    num? diferencia,
  }) = _CaloriasDetail;
  factory CaloriasDetail.fromJson(Map<String, dynamic> json) => _$CaloriasDetailFromJson(json);
}
