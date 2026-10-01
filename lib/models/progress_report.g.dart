// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProgressReportImpl _$$ProgressReportImplFromJson(
  Map<String, dynamic> json,
) => _$ProgressReportImpl(
  idReporteSemanal: json['id_reporte_semanal'] as String?,
  semanaInfo: json['semana_info'] as String?,
  fechaInicio: json['fecha_inicio'] as String?,
  fechaFin: json['fecha_fin'] as String?,
  actualizado: json['actualizado'] as String?,
  alertas: json['alertas'] == null
      ? null
      : Alert.fromJson(json['alertas'] as Map<String, dynamic>),
  mensajeIa: json['mensaje_ia'] as String?,
  indiceBienestar: json['indice_bienestar'] as num?,
  variacionIndiceBienestar: json['variacion_indice_bienestar'] as num?,
  detalleFactorMovement: json['detalle_factor_movimiento'] == null
      ? null
      : GeneralFactorDetail.fromJson(
          json['detalle_factor_movimiento'] as Map<String, dynamic>,
        ),
  detalleFactorHidratacion: json['detalle_factor_hidratacion'] == null
      ? null
      : GeneralFactorDetail.fromJson(
          json['detalle_factor_hidratacion'] as Map<String, dynamic>,
        ),
  detalleFactorEdadCorporal: json['detalle_factor_edad_corporal'] == null
      ? null
      : GeneralFactorDetail.fromJson(
          json['detalle_factor_edad_corporal'] as Map<String, dynamic>,
        ),
  detalleFactorCargaMuscular: json['detalle_factor_carga_muscular'] == null
      ? null
      : GeneralFactorDetail.fromJson(
          json['detalle_factor_carga_muscular'] as Map<String, dynamic>,
        ),
  detalleFactorPesoComposicion: json['detalle_factor_peso_composicion'] == null
      ? null
      : FactorWeightDetail.fromJson(
          json['detalle_factor_peso_composicion'] as Map<String, dynamic>,
        ),
  evolucionIndiceBienestar:
      (json['evolucion_indice_bienestar'] as List<dynamic>?)
          ?.map(
            (e) => WellnessIndexEvolution.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  historialPeso:
      (json['historial_peso'] as List<dynamic>?)
          ?.map((e) => WeightHistory.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  metricasSecundarias: json['metricas_secundarias'] == null
      ? null
      : SecondaryMetrics.fromJson(
          json['metricas_secundarias'] as Map<String, dynamic>,
        ),
  grasa: json['grasa'] == null
      ? null
      : CurrentPreviousValue.fromJson(json['grasa'] as Map<String, dynamic>),
  musculos: json['musculos'] == null
      ? null
      : CurrentPreviousValue.fromJson(json['musculos'] as Map<String, dynamic>),
  calorias: json['calorias'] == null
      ? null
      : CaloriasDetail.fromJson(json['calorias'] as Map<String, dynamic>),
  tiempoActivo: json['tiempo_activo'] == null
      ? null
      : ActiveTimeDetail.fromJson(
          json['tiempo_activo'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$$ProgressReportImplToJson(
  _$ProgressReportImpl instance,
) => <String, dynamic>{
  'id_reporte_semanal': instance.idReporteSemanal,
  'semana_info': instance.semanaInfo,
  'fecha_inicio': instance.fechaInicio,
  'fecha_fin': instance.fechaFin,
  'actualizado': instance.actualizado,
  'alertas': instance.alertas,
  'mensaje_ia': instance.mensajeIa,
  'indice_bienestar': instance.indiceBienestar,
  'variacion_indice_bienestar': instance.variacionIndiceBienestar,
  'detalle_factor_movimiento': instance.detalleFactorMovement,
  'detalle_factor_hidratacion': instance.detalleFactorHidratacion,
  'detalle_factor_edad_corporal': instance.detalleFactorEdadCorporal,
  'detalle_factor_carga_muscular': instance.detalleFactorCargaMuscular,
  'detalle_factor_peso_composicion': instance.detalleFactorPesoComposicion,
  'evolucion_indice_bienestar': instance.evolucionIndiceBienestar,
  'historial_peso': instance.historialPeso,
  'metricas_secundarias': instance.metricasSecundarias,
  'grasa': instance.grasa,
  'musculos': instance.musculos,
  'calorias': instance.calorias,
  'tiempo_activo': instance.tiempoActivo,
};

_$AlertImpl _$$AlertImplFromJson(Map<String, dynamic> json) => _$AlertImpl(
  activa: json['activa'] as bool? ?? false,
  detalle: json['detalle'] as String?,
);

Map<String, dynamic> _$$AlertImplToJson(_$AlertImpl instance) =>
    <String, dynamic>{'activa': instance.activa, 'detalle': instance.detalle};

_$GeneralFactorDetailImpl _$$GeneralFactorDetailImplFromJson(
  Map<String, dynamic> json,
) => _$GeneralFactorDetailImpl(
  puntaje: json['puntaje'] as num?,
  variacion: json['variacion'] as num?,
);

Map<String, dynamic> _$$GeneralFactorDetailImplToJson(
  _$GeneralFactorDetailImpl instance,
) => <String, dynamic>{
  'puntaje': instance.puntaje,
  'variacion': instance.variacion,
};

_$FactorWeightDetailImpl _$$FactorWeightDetailImplFromJson(
  Map<String, dynamic> json,
) => _$FactorWeightDetailImpl(
  puntaje: json['puntaje'] as num?,
  variacion: json['variacion'] as num?,
  imc: json['imc'] as num?,
  pesoRegistrado: json['peso_registrado'] as num?,
);

Map<String, dynamic> _$$FactorWeightDetailImplToJson(
  _$FactorWeightDetailImpl instance,
) => <String, dynamic>{
  'puntaje': instance.puntaje,
  'variacion': instance.variacion,
  'imc': instance.imc,
  'peso_registrado': instance.pesoRegistrado,
};

_$CurrentPreviousValueImpl _$$CurrentPreviousValueImplFromJson(
  Map<String, dynamic> json,
) => _$CurrentPreviousValueImpl(
  actual: _parseNumericOrString(json['actual']),
  anterior: _parseNumericOrString(json['anterior']),
);

Map<String, dynamic> _$$CurrentPreviousValueImplToJson(
  _$CurrentPreviousValueImpl instance,
) => <String, dynamic>{
  'actual': instance.actual,
  'anterior': instance.anterior,
};

_$ActiveTimeDetailImpl _$$ActiveTimeDetailImplFromJson(
  Map<String, dynamic> json,
) => _$ActiveTimeDetailImpl(
  totalMinutos: json['total_minutos'] as num?,
  sesionesCompletadas: json['sesiones_completadas'] as num?,
  sesionesTotales: json['sesiones_totales'] as num?,
  diferenciaSesiones: json['diferencia_sesiones'] as num?,
);

Map<String, dynamic> _$$ActiveTimeDetailImplToJson(
  _$ActiveTimeDetailImpl instance,
) => <String, dynamic>{
  'total_minutos': instance.totalMinutos,
  'sesiones_completadas': instance.sesionesCompletadas,
  'sesiones_totales': instance.sesionesTotales,
  'diferencia_sesiones': instance.diferenciaSesiones,
};

_$SecondaryMetricsImpl _$$SecondaryMetricsImplFromJson(
  Map<String, dynamic> json,
) => _$SecondaryMetricsImpl(
  actual: json['actual'] == null
      ? null
      : SecondaryMetricValues.fromJson(json['actual'] as Map<String, dynamic>),
  anterior: json['anterior'] == null
      ? null
      : SecondaryMetricValues.fromJson(
          json['anterior'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$$SecondaryMetricsImplToJson(
  _$SecondaryMetricsImpl instance,
) => <String, dynamic>{
  'actual': instance.actual,
  'anterior': instance.anterior,
};

_$SecondaryMetricValuesImpl _$$SecondaryMetricValuesImplFromJson(
  Map<String, dynamic> json,
) => _$SecondaryMetricValuesImpl(
  deficitHidrico: json['deficit_hidrico'] as num?,
  vo2Max: json['vo2_max'] as num?,
);

Map<String, dynamic> _$$SecondaryMetricValuesImplToJson(
  _$SecondaryMetricValuesImpl instance,
) => <String, dynamic>{
  'deficit_hidrico': instance.deficitHidrico,
  'vo2_max': instance.vo2Max,
};

_$WellnessIndexEvolutionImpl _$$WellnessIndexEvolutionImplFromJson(
  Map<String, dynamic> json,
) => _$WellnessIndexEvolutionImpl(
  fecha: json['fecha'] as String?,
  semanaActual: json['semana_actual'] as num?,
  puntaje: json['puntaje'] as num?,
);

Map<String, dynamic> _$$WellnessIndexEvolutionImplToJson(
  _$WellnessIndexEvolutionImpl instance,
) => <String, dynamic>{
  'fecha': instance.fecha,
  'semana_actual': instance.semanaActual,
  'puntaje': instance.puntaje,
};

_$WeightHistoryImpl _$$WeightHistoryImplFromJson(Map<String, dynamic> json) =>
    _$WeightHistoryImpl(
      semana: json['semana'] as num?,
      fecha: json['fecha'] as String?,
      peso: _parseNumericOrString(json['peso']),
      musculo: _parseNumericOrString(json['musculo']),
      grasa: _parseNumericOrString(json['grasa']),
    );

Map<String, dynamic> _$$WeightHistoryImplToJson(_$WeightHistoryImpl instance) =>
    <String, dynamic>{
      'semana': instance.semana,
      'fecha': instance.fecha,
      'peso': instance.peso,
      'musculo': instance.musculo,
      'grasa': instance.grasa,
    };

_$CaloriasDetailImpl _$$CaloriasDetailImplFromJson(Map<String, dynamic> json) =>
    _$CaloriasDetailImpl(
      caloriasAct: json['calorias_act'] as num?,
      caloriasAnt: json['calorias_ant'] as num?,
      diferencia: json['diferencia'] as num?,
    );

Map<String, dynamic> _$$CaloriasDetailImplToJson(
  _$CaloriasDetailImpl instance,
) => <String, dynamic>{
  'calorias_act': instance.caloriasAct,
  'calorias_ant': instance.caloriasAnt,
  'diferencia': instance.diferencia,
};
