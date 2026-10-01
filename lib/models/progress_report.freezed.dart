// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'progress_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProgressReport {

@JsonKey(name: 'id_reporte_semanal') String? get idReporteSemanal;@JsonKey(name: 'semana_info') String? get semanaInfo;@JsonKey(name: 'fecha_inicio') String? get fechaInicio;@JsonKey(name: 'fecha_fin') String? get fechaFin; String? get actualizado; Alert? get alertas;@JsonKey(name: 'mensaje_ia') String? get mensajeIa;@JsonKey(name: 'indice_bienestar') num? get indiceBienestar;@JsonKey(name: 'variacion_indice_bienestar') num? get variacionIndiceBienestar;@JsonKey(name: 'detalle_factor_movimiento') GeneralFactorDetail? get detalleFactorMovement;@JsonKey(name: 'detalle_factor_hidratacion') FactorHidratacionDetail? get detalleFactorHidratacion;@JsonKey(name: 'detalle_factor_edad_corporal') GeneralFactorDetail? get detalleFactorEdadCorporal;@JsonKey(name: 'detalle_factor_carga_muscular') GeneralFactorDetail? get detalleFactorCargaMuscular;@JsonKey(name: 'detalle_factor_peso_composicion') FactorWeightDetail? get detalleFactorPesoComposicion;@JsonKey(name: 'evolucion_indice_bienestar') List<WellnessIndexEvolution> get evolucionIndiceBienestar;@JsonKey(name: 'historial_peso') List<WeightHistory> get historialPeso;@JsonKey(name: 'metricas_secundarias') SecondaryMetrics? get metricasSecundarias; CurrentPreviousValue? get grasa; CurrentPreviousValue? get musculos; CaloriasDetail? get calorias;@JsonKey(name: 'tiempo_activo') ActiveTimeDetail? get tiempoActivo;
/// Create a copy of ProgressReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProgressReportCopyWith<ProgressReport> get copyWith => _$ProgressReportCopyWithImpl<ProgressReport>(this as ProgressReport, _$identity);

  /// Serializes this ProgressReport to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProgressReport&&(identical(other.idReporteSemanal, idReporteSemanal) || other.idReporteSemanal == idReporteSemanal)&&(identical(other.semanaInfo, semanaInfo) || other.semanaInfo == semanaInfo)&&(identical(other.fechaInicio, fechaInicio) || other.fechaInicio == fechaInicio)&&(identical(other.fechaFin, fechaFin) || other.fechaFin == fechaFin)&&(identical(other.actualizado, actualizado) || other.actualizado == actualizado)&&(identical(other.alertas, alertas) || other.alertas == alertas)&&(identical(other.mensajeIa, mensajeIa) || other.mensajeIa == mensajeIa)&&(identical(other.indiceBienestar, indiceBienestar) || other.indiceBienestar == indiceBienestar)&&(identical(other.variacionIndiceBienestar, variacionIndiceBienestar) || other.variacionIndiceBienestar == variacionIndiceBienestar)&&(identical(other.detalleFactorMovement, detalleFactorMovement) || other.detalleFactorMovement == detalleFactorMovement)&&(identical(other.detalleFactorHidratacion, detalleFactorHidratacion) || other.detalleFactorHidratacion == detalleFactorHidratacion)&&(identical(other.detalleFactorEdadCorporal, detalleFactorEdadCorporal) || other.detalleFactorEdadCorporal == detalleFactorEdadCorporal)&&(identical(other.detalleFactorCargaMuscular, detalleFactorCargaMuscular) || other.detalleFactorCargaMuscular == detalleFactorCargaMuscular)&&(identical(other.detalleFactorPesoComposicion, detalleFactorPesoComposicion) || other.detalleFactorPesoComposicion == detalleFactorPesoComposicion)&&const DeepCollectionEquality().equals(other.evolucionIndiceBienestar, evolucionIndiceBienestar)&&const DeepCollectionEquality().equals(other.historialPeso, historialPeso)&&(identical(other.metricasSecundarias, metricasSecundarias) || other.metricasSecundarias == metricasSecundarias)&&(identical(other.grasa, grasa) || other.grasa == grasa)&&(identical(other.musculos, musculos) || other.musculos == musculos)&&(identical(other.calorias, calorias) || other.calorias == calorias)&&(identical(other.tiempoActivo, tiempoActivo) || other.tiempoActivo == tiempoActivo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,idReporteSemanal,semanaInfo,fechaInicio,fechaFin,actualizado,alertas,mensajeIa,indiceBienestar,variacionIndiceBienestar,detalleFactorMovement,detalleFactorHidratacion,detalleFactorEdadCorporal,detalleFactorCargaMuscular,detalleFactorPesoComposicion,const DeepCollectionEquality().hash(evolucionIndiceBienestar),const DeepCollectionEquality().hash(historialPeso),metricasSecundarias,grasa,musculos,calorias,tiempoActivo]);

@override
String toString() {
  return 'ProgressReport(idReporteSemanal: $idReporteSemanal, semanaInfo: $semanaInfo, fechaInicio: $fechaInicio, fechaFin: $fechaFin, actualizado: $actualizado, alertas: $alertas, mensajeIa: $mensajeIa, indiceBienestar: $indiceBienestar, variacionIndiceBienestar: $variacionIndiceBienestar, detalleFactorMovement: $detalleFactorMovement, detalleFactorHidratacion: $detalleFactorHidratacion, detalleFactorEdadCorporal: $detalleFactorEdadCorporal, detalleFactorCargaMuscular: $detalleFactorCargaMuscular, detalleFactorPesoComposicion: $detalleFactorPesoComposicion, evolucionIndiceBienestar: $evolucionIndiceBienestar, historialPeso: $historialPeso, metricasSecundarias: $metricasSecundarias, grasa: $grasa, musculos: $musculos, calorias: $calorias, tiempoActivo: $tiempoActivo)';
}


}

/// @nodoc
abstract mixin class $ProgressReportCopyWith<$Res>  {
  factory $ProgressReportCopyWith(ProgressReport value, $Res Function(ProgressReport) _then) = _$ProgressReportCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id_reporte_semanal') String? idReporteSemanal,@JsonKey(name: 'semana_info') String? semanaInfo,@JsonKey(name: 'fecha_inicio') String? fechaInicio,@JsonKey(name: 'fecha_fin') String? fechaFin, String? actualizado, Alert? alertas,@JsonKey(name: 'mensaje_ia') String? mensajeIa,@JsonKey(name: 'indice_bienestar') num? indiceBienestar,@JsonKey(name: 'variacion_indice_bienestar') num? variacionIndiceBienestar,@JsonKey(name: 'detalle_factor_movimiento') GeneralFactorDetail? detalleFactorMovement,@JsonKey(name: 'detalle_factor_hidratacion') FactorHidratacionDetail? detalleFactorHidratacion,@JsonKey(name: 'detalle_factor_edad_corporal') GeneralFactorDetail? detalleFactorEdadCorporal,@JsonKey(name: 'detalle_factor_carga_muscular') GeneralFactorDetail? detalleFactorCargaMuscular,@JsonKey(name: 'detalle_factor_peso_composicion') FactorWeightDetail? detalleFactorPesoComposicion,@JsonKey(name: 'evolucion_indice_bienestar') List<WellnessIndexEvolution> evolucionIndiceBienestar,@JsonKey(name: 'historial_peso') List<WeightHistory> historialPeso,@JsonKey(name: 'metricas_secundarias') SecondaryMetrics? metricasSecundarias, CurrentPreviousValue? grasa, CurrentPreviousValue? musculos, CaloriasDetail? calorias,@JsonKey(name: 'tiempo_activo') ActiveTimeDetail? tiempoActivo
});


$AlertCopyWith<$Res>? get alertas;$GeneralFactorDetailCopyWith<$Res>? get detalleFactorMovement;$FactorHidratacionDetailCopyWith<$Res>? get detalleFactorHidratacion;$GeneralFactorDetailCopyWith<$Res>? get detalleFactorEdadCorporal;$GeneralFactorDetailCopyWith<$Res>? get detalleFactorCargaMuscular;$FactorWeightDetailCopyWith<$Res>? get detalleFactorPesoComposicion;$SecondaryMetricsCopyWith<$Res>? get metricasSecundarias;$CurrentPreviousValueCopyWith<$Res>? get grasa;$CurrentPreviousValueCopyWith<$Res>? get musculos;$CaloriasDetailCopyWith<$Res>? get calorias;$ActiveTimeDetailCopyWith<$Res>? get tiempoActivo;

}
/// @nodoc
class _$ProgressReportCopyWithImpl<$Res>
    implements $ProgressReportCopyWith<$Res> {
  _$ProgressReportCopyWithImpl(this._self, this._then);

  final ProgressReport _self;
  final $Res Function(ProgressReport) _then;

/// Create a copy of ProgressReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? idReporteSemanal = freezed,Object? semanaInfo = freezed,Object? fechaInicio = freezed,Object? fechaFin = freezed,Object? actualizado = freezed,Object? alertas = freezed,Object? mensajeIa = freezed,Object? indiceBienestar = freezed,Object? variacionIndiceBienestar = freezed,Object? detalleFactorMovement = freezed,Object? detalleFactorHidratacion = freezed,Object? detalleFactorEdadCorporal = freezed,Object? detalleFactorCargaMuscular = freezed,Object? detalleFactorPesoComposicion = freezed,Object? evolucionIndiceBienestar = null,Object? historialPeso = null,Object? metricasSecundarias = freezed,Object? grasa = freezed,Object? musculos = freezed,Object? calorias = freezed,Object? tiempoActivo = freezed,}) {
  return _then(ProgressReport(
idReporteSemanal: freezed == idReporteSemanal ? _self.idReporteSemanal : idReporteSemanal // ignore: cast_nullable_to_non_nullable
as String?,semanaInfo: freezed == semanaInfo ? _self.semanaInfo : semanaInfo // ignore: cast_nullable_to_non_nullable
as String?,fechaInicio: freezed == fechaInicio ? _self.fechaInicio : fechaInicio // ignore: cast_nullable_to_non_nullable
as String?,fechaFin: freezed == fechaFin ? _self.fechaFin : fechaFin // ignore: cast_nullable_to_non_nullable
as String?,actualizado: freezed == actualizado ? _self.actualizado : actualizado // ignore: cast_nullable_to_non_nullable
as String?,alertas: freezed == alertas ? _self.alertas : alertas // ignore: cast_nullable_to_non_nullable
as Alert?,mensajeIa: freezed == mensajeIa ? _self.mensajeIa : mensajeIa // ignore: cast_nullable_to_non_nullable
as String?,indiceBienestar: freezed == indiceBienestar ? _self.indiceBienestar : indiceBienestar // ignore: cast_nullable_to_non_nullable
as num?,variacionIndiceBienestar: freezed == variacionIndiceBienestar ? _self.variacionIndiceBienestar : variacionIndiceBienestar // ignore: cast_nullable_to_non_nullable
as num?,detalleFactorMovement: freezed == detalleFactorMovement ? _self.detalleFactorMovement : detalleFactorMovement // ignore: cast_nullable_to_non_nullable
as GeneralFactorDetail?,detalleFactorHidratacion: freezed == detalleFactorHidratacion ? _self.detalleFactorHidratacion : detalleFactorHidratacion // ignore: cast_nullable_to_non_nullable
as FactorHidratacionDetail?,detalleFactorEdadCorporal: freezed == detalleFactorEdadCorporal ? _self.detalleFactorEdadCorporal : detalleFactorEdadCorporal // ignore: cast_nullable_to_non_nullable
as GeneralFactorDetail?,detalleFactorCargaMuscular: freezed == detalleFactorCargaMuscular ? _self.detalleFactorCargaMuscular : detalleFactorCargaMuscular // ignore: cast_nullable_to_non_nullable
as GeneralFactorDetail?,detalleFactorPesoComposicion: freezed == detalleFactorPesoComposicion ? _self.detalleFactorPesoComposicion : detalleFactorPesoComposicion // ignore: cast_nullable_to_non_nullable
as FactorWeightDetail?,evolucionIndiceBienestar: null == evolucionIndiceBienestar ? _self.evolucionIndiceBienestar : evolucionIndiceBienestar // ignore: cast_nullable_to_non_nullable
as List<WellnessIndexEvolution>,historialPeso: null == historialPeso ? _self.historialPeso : historialPeso // ignore: cast_nullable_to_non_nullable
as List<WeightHistory>,metricasSecundarias: freezed == metricasSecundarias ? _self.metricasSecundarias : metricasSecundarias // ignore: cast_nullable_to_non_nullable
as SecondaryMetrics?,grasa: freezed == grasa ? _self.grasa : grasa // ignore: cast_nullable_to_non_nullable
as CurrentPreviousValue?,musculos: freezed == musculos ? _self.musculos : musculos // ignore: cast_nullable_to_non_nullable
as CurrentPreviousValue?,calorias: freezed == calorias ? _self.calorias : calorias // ignore: cast_nullable_to_non_nullable
as CaloriasDetail?,tiempoActivo: freezed == tiempoActivo ? _self.tiempoActivo : tiempoActivo // ignore: cast_nullable_to_non_nullable
as ActiveTimeDetail?,
  ));
}
/// Create a copy of ProgressReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AlertCopyWith<$Res>? get alertas {
    if (_self.alertas == null) {
    return null;
  }

  return $AlertCopyWith<$Res>(_self.alertas!, (value) {
    return _then(_self.copyWith(alertas: value));
  });
}/// Create a copy of ProgressReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeneralFactorDetailCopyWith<$Res>? get detalleFactorMovement {
    if (_self.detalleFactorMovement == null) {
    return null;
  }

  return $GeneralFactorDetailCopyWith<$Res>(_self.detalleFactorMovement!, (value) {
    return _then(_self.copyWith(detalleFactorMovement: value));
  });
}/// Create a copy of ProgressReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FactorHidratacionDetailCopyWith<$Res>? get detalleFactorHidratacion {
    if (_self.detalleFactorHidratacion == null) {
    return null;
  }

  return $FactorHidratacionDetailCopyWith<$Res>(_self.detalleFactorHidratacion!, (value) {
    return _then(_self.copyWith(detalleFactorHidratacion: value));
  });
}/// Create a copy of ProgressReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeneralFactorDetailCopyWith<$Res>? get detalleFactorEdadCorporal {
    if (_self.detalleFactorEdadCorporal == null) {
    return null;
  }

  return $GeneralFactorDetailCopyWith<$Res>(_self.detalleFactorEdadCorporal!, (value) {
    return _then(_self.copyWith(detalleFactorEdadCorporal: value));
  });
}/// Create a copy of ProgressReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeneralFactorDetailCopyWith<$Res>? get detalleFactorCargaMuscular {
    if (_self.detalleFactorCargaMuscular == null) {
    return null;
  }

  return $GeneralFactorDetailCopyWith<$Res>(_self.detalleFactorCargaMuscular!, (value) {
    return _then(_self.copyWith(detalleFactorCargaMuscular: value));
  });
}/// Create a copy of ProgressReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FactorWeightDetailCopyWith<$Res>? get detalleFactorPesoComposicion {
    if (_self.detalleFactorPesoComposicion == null) {
    return null;
  }

  return $FactorWeightDetailCopyWith<$Res>(_self.detalleFactorPesoComposicion!, (value) {
    return _then(_self.copyWith(detalleFactorPesoComposicion: value));
  });
}/// Create a copy of ProgressReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SecondaryMetricsCopyWith<$Res>? get metricasSecundarias {
    if (_self.metricasSecundarias == null) {
    return null;
  }

  return $SecondaryMetricsCopyWith<$Res>(_self.metricasSecundarias!, (value) {
    return _then(_self.copyWith(metricasSecundarias: value));
  });
}/// Create a copy of ProgressReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CurrentPreviousValueCopyWith<$Res>? get grasa {
    if (_self.grasa == null) {
    return null;
  }

  return $CurrentPreviousValueCopyWith<$Res>(_self.grasa!, (value) {
    return _then(_self.copyWith(grasa: value));
  });
}/// Create a copy of ProgressReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CurrentPreviousValueCopyWith<$Res>? get musculos {
    if (_self.musculos == null) {
    return null;
  }

  return $CurrentPreviousValueCopyWith<$Res>(_self.musculos!, (value) {
    return _then(_self.copyWith(musculos: value));
  });
}/// Create a copy of ProgressReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CaloriasDetailCopyWith<$Res>? get calorias {
    if (_self.calorias == null) {
    return null;
  }

  return $CaloriasDetailCopyWith<$Res>(_self.calorias!, (value) {
    return _then(_self.copyWith(calorias: value));
  });
}/// Create a copy of ProgressReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActiveTimeDetailCopyWith<$Res>? get tiempoActivo {
    if (_self.tiempoActivo == null) {
    return null;
  }

  return $ActiveTimeDetailCopyWith<$Res>(_self.tiempoActivo!, (value) {
    return _then(_self.copyWith(tiempoActivo: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProgressReport].
extension ProgressReportPatterns on ProgressReport {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProgressReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProgressReport() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProgressReport value)  $default,){
final _that = this;
switch (_that) {
case _ProgressReport():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProgressReport value)?  $default,){
final _that = this;
switch (_that) {
case _ProgressReport() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id_reporte_semanal')  String? idReporteSemanal, @JsonKey(name: 'semana_info')  String? semanaInfo, @JsonKey(name: 'fecha_inicio')  String? fechaInicio, @JsonKey(name: 'fecha_fin')  String? fechaFin,  String? actualizado,  Alert? alertas, @JsonKey(name: 'mensaje_ia')  String? mensajeIa, @JsonKey(name: 'indice_bienestar')  num? indiceBienestar, @JsonKey(name: 'variacion_indice_bienestar')  num? variacionIndiceBienestar, @JsonKey(name: 'detalle_factor_movimiento')  GeneralFactorDetail? detalleFactorMovement, @JsonKey(name: 'detalle_factor_hidratacion')  FactorHidratacionDetail? detalleFactorHidratacion, @JsonKey(name: 'detalle_factor_edad_corporal')  GeneralFactorDetail? detalleFactorEdadCorporal, @JsonKey(name: 'detalle_factor_carga_muscular')  GeneralFactorDetail? detalleFactorCargaMuscular, @JsonKey(name: 'detalle_factor_peso_composicion')  FactorWeightDetail? detalleFactorPesoComposicion, @JsonKey(name: 'evolucion_indice_bienestar')  List<WellnessIndexEvolution> evolucionIndiceBienestar, @JsonKey(name: 'historial_peso')  List<WeightHistory> historialPeso, @JsonKey(name: 'metricas_secundarias')  SecondaryMetrics? metricasSecundarias,  CurrentPreviousValue? grasa,  CurrentPreviousValue? musculos,  CaloriasDetail? calorias, @JsonKey(name: 'tiempo_activo')  ActiveTimeDetail? tiempoActivo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProgressReport() when $default != null:
return $default(_that.idReporteSemanal,_that.semanaInfo,_that.fechaInicio,_that.fechaFin,_that.actualizado,_that.alertas,_that.mensajeIa,_that.indiceBienestar,_that.variacionIndiceBienestar,_that.detalleFactorMovement,_that.detalleFactorHidratacion,_that.detalleFactorEdadCorporal,_that.detalleFactorCargaMuscular,_that.detalleFactorPesoComposicion,_that.evolucionIndiceBienestar,_that.historialPeso,_that.metricasSecundarias,_that.grasa,_that.musculos,_that.calorias,_that.tiempoActivo);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id_reporte_semanal')  String? idReporteSemanal, @JsonKey(name: 'semana_info')  String? semanaInfo, @JsonKey(name: 'fecha_inicio')  String? fechaInicio, @JsonKey(name: 'fecha_fin')  String? fechaFin,  String? actualizado,  Alert? alertas, @JsonKey(name: 'mensaje_ia')  String? mensajeIa, @JsonKey(name: 'indice_bienestar')  num? indiceBienestar, @JsonKey(name: 'variacion_indice_bienestar')  num? variacionIndiceBienestar, @JsonKey(name: 'detalle_factor_movimiento')  GeneralFactorDetail? detalleFactorMovement, @JsonKey(name: 'detalle_factor_hidratacion')  FactorHidratacionDetail? detalleFactorHidratacion, @JsonKey(name: 'detalle_factor_edad_corporal')  GeneralFactorDetail? detalleFactorEdadCorporal, @JsonKey(name: 'detalle_factor_carga_muscular')  GeneralFactorDetail? detalleFactorCargaMuscular, @JsonKey(name: 'detalle_factor_peso_composicion')  FactorWeightDetail? detalleFactorPesoComposicion, @JsonKey(name: 'evolucion_indice_bienestar')  List<WellnessIndexEvolution> evolucionIndiceBienestar, @JsonKey(name: 'historial_peso')  List<WeightHistory> historialPeso, @JsonKey(name: 'metricas_secundarias')  SecondaryMetrics? metricasSecundarias,  CurrentPreviousValue? grasa,  CurrentPreviousValue? musculos,  CaloriasDetail? calorias, @JsonKey(name: 'tiempo_activo')  ActiveTimeDetail? tiempoActivo)  $default,) {final _that = this;
switch (_that) {
case _ProgressReport():
return $default(_that.idReporteSemanal,_that.semanaInfo,_that.fechaInicio,_that.fechaFin,_that.actualizado,_that.alertas,_that.mensajeIa,_that.indiceBienestar,_that.variacionIndiceBienestar,_that.detalleFactorMovement,_that.detalleFactorHidratacion,_that.detalleFactorEdadCorporal,_that.detalleFactorCargaMuscular,_that.detalleFactorPesoComposicion,_that.evolucionIndiceBienestar,_that.historialPeso,_that.metricasSecundarias,_that.grasa,_that.musculos,_that.calorias,_that.tiempoActivo);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id_reporte_semanal')  String? idReporteSemanal, @JsonKey(name: 'semana_info')  String? semanaInfo, @JsonKey(name: 'fecha_inicio')  String? fechaInicio, @JsonKey(name: 'fecha_fin')  String? fechaFin,  String? actualizado,  Alert? alertas, @JsonKey(name: 'mensaje_ia')  String? mensajeIa, @JsonKey(name: 'indice_bienestar')  num? indiceBienestar, @JsonKey(name: 'variacion_indice_bienestar')  num? variacionIndiceBienestar, @JsonKey(name: 'detalle_factor_movimiento')  GeneralFactorDetail? detalleFactorMovement, @JsonKey(name: 'detalle_factor_hidratacion')  FactorHidratacionDetail? detalleFactorHidratacion, @JsonKey(name: 'detalle_factor_edad_corporal')  GeneralFactorDetail? detalleFactorEdadCorporal, @JsonKey(name: 'detalle_factor_carga_muscular')  GeneralFactorDetail? detalleFactorCargaMuscular, @JsonKey(name: 'detalle_factor_peso_composicion')  FactorWeightDetail? detalleFactorPesoComposicion, @JsonKey(name: 'evolucion_indice_bienestar')  List<WellnessIndexEvolution> evolucionIndiceBienestar, @JsonKey(name: 'historial_peso')  List<WeightHistory> historialPeso, @JsonKey(name: 'metricas_secundarias')  SecondaryMetrics? metricasSecundarias,  CurrentPreviousValue? grasa,  CurrentPreviousValue? musculos,  CaloriasDetail? calorias, @JsonKey(name: 'tiempo_activo')  ActiveTimeDetail? tiempoActivo)?  $default,) {final _that = this;
switch (_that) {
case _ProgressReport() when $default != null:
return $default(_that.idReporteSemanal,_that.semanaInfo,_that.fechaInicio,_that.fechaFin,_that.actualizado,_that.alertas,_that.mensajeIa,_that.indiceBienestar,_that.variacionIndiceBienestar,_that.detalleFactorMovement,_that.detalleFactorHidratacion,_that.detalleFactorEdadCorporal,_that.detalleFactorCargaMuscular,_that.detalleFactorPesoComposicion,_that.evolucionIndiceBienestar,_that.historialPeso,_that.metricasSecundarias,_that.grasa,_that.musculos,_that.calorias,_that.tiempoActivo);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProgressReport implements ProgressReport {
  const _ProgressReport({@JsonKey(name: 'id_reporte_semanal') this.idReporteSemanal, @JsonKey(name: 'semana_info') this.semanaInfo, @JsonKey(name: 'fecha_inicio') this.fechaInicio, @JsonKey(name: 'fecha_fin') this.fechaFin, this.actualizado, this.alertas, @JsonKey(name: 'mensaje_ia') this.mensajeIa, @JsonKey(name: 'indice_bienestar') this.indiceBienestar, @JsonKey(name: 'variacion_indice_bienestar') this.variacionIndiceBienestar, @JsonKey(name: 'detalle_factor_movimiento') this.detalleFactorMovement, @JsonKey(name: 'detalle_factor_hidratacion') this.detalleFactorHidratacion, @JsonKey(name: 'detalle_factor_edad_corporal') this.detalleFactorEdadCorporal, @JsonKey(name: 'detalle_factor_carga_muscular') this.detalleFactorCargaMuscular, @JsonKey(name: 'detalle_factor_peso_composicion') this.detalleFactorPesoComposicion, @JsonKey(name: 'evolucion_indice_bienestar')  List<WellnessIndexEvolution> evolucionIndiceBienestar = const [], @JsonKey(name: 'historial_peso')  List<WeightHistory> historialPeso = const [], @JsonKey(name: 'metricas_secundarias') this.metricasSecundarias, this.grasa, this.musculos, this.calorias, @JsonKey(name: 'tiempo_activo') this.tiempoActivo}): _evolucionIndiceBienestar = evolucionIndiceBienestar,_historialPeso = historialPeso;
  factory _ProgressReport.fromJson(Map<String, dynamic> json) => _$ProgressReportFromJson(json);

@override@JsonKey(name: 'id_reporte_semanal') final  String? idReporteSemanal;
@override@JsonKey(name: 'semana_info') final  String? semanaInfo;
@override@JsonKey(name: 'fecha_inicio') final  String? fechaInicio;
@override@JsonKey(name: 'fecha_fin') final  String? fechaFin;
@override final  String? actualizado;
@override final  Alert? alertas;
@override@JsonKey(name: 'mensaje_ia') final  String? mensajeIa;
@override@JsonKey(name: 'indice_bienestar') final  num? indiceBienestar;
@override@JsonKey(name: 'variacion_indice_bienestar') final  num? variacionIndiceBienestar;
@override@JsonKey(name: 'detalle_factor_movimiento') final  GeneralFactorDetail? detalleFactorMovement;
@override@JsonKey(name: 'detalle_factor_hidratacion') final  FactorHidratacionDetail? detalleFactorHidratacion;
@override@JsonKey(name: 'detalle_factor_edad_corporal') final  GeneralFactorDetail? detalleFactorEdadCorporal;
@override@JsonKey(name: 'detalle_factor_carga_muscular') final  GeneralFactorDetail? detalleFactorCargaMuscular;
@override@JsonKey(name: 'detalle_factor_peso_composicion') final  FactorWeightDetail? detalleFactorPesoComposicion;
 final  List<WellnessIndexEvolution> _evolucionIndiceBienestar;
@override@JsonKey(name: 'evolucion_indice_bienestar') List<WellnessIndexEvolution> get evolucionIndiceBienestar {
  if (_evolucionIndiceBienestar is EqualUnmodifiableListView) return _evolucionIndiceBienestar;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_evolucionIndiceBienestar);
}

 final  List<WeightHistory> _historialPeso;
@override@JsonKey(name: 'historial_peso') List<WeightHistory> get historialPeso {
  if (_historialPeso is EqualUnmodifiableListView) return _historialPeso;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_historialPeso);
}

@override@JsonKey(name: 'metricas_secundarias') final  SecondaryMetrics? metricasSecundarias;
@override final  CurrentPreviousValue? grasa;
@override final  CurrentPreviousValue? musculos;
@override final  CaloriasDetail? calorias;
@override@JsonKey(name: 'tiempo_activo') final  ActiveTimeDetail? tiempoActivo;

/// Create a copy of ProgressReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProgressReportCopyWith<_ProgressReport> get copyWith => __$ProgressReportCopyWithImpl<_ProgressReport>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProgressReportToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProgressReport&&(identical(other.idReporteSemanal, idReporteSemanal) || other.idReporteSemanal == idReporteSemanal)&&(identical(other.semanaInfo, semanaInfo) || other.semanaInfo == semanaInfo)&&(identical(other.fechaInicio, fechaInicio) || other.fechaInicio == fechaInicio)&&(identical(other.fechaFin, fechaFin) || other.fechaFin == fechaFin)&&(identical(other.actualizado, actualizado) || other.actualizado == actualizado)&&(identical(other.alertas, alertas) || other.alertas == alertas)&&(identical(other.mensajeIa, mensajeIa) || other.mensajeIa == mensajeIa)&&(identical(other.indiceBienestar, indiceBienestar) || other.indiceBienestar == indiceBienestar)&&(identical(other.variacionIndiceBienestar, variacionIndiceBienestar) || other.variacionIndiceBienestar == variacionIndiceBienestar)&&(identical(other.detalleFactorMovement, detalleFactorMovement) || other.detalleFactorMovement == detalleFactorMovement)&&(identical(other.detalleFactorHidratacion, detalleFactorHidratacion) || other.detalleFactorHidratacion == detalleFactorHidratacion)&&(identical(other.detalleFactorEdadCorporal, detalleFactorEdadCorporal) || other.detalleFactorEdadCorporal == detalleFactorEdadCorporal)&&(identical(other.detalleFactorCargaMuscular, detalleFactorCargaMuscular) || other.detalleFactorCargaMuscular == detalleFactorCargaMuscular)&&(identical(other.detalleFactorPesoComposicion, detalleFactorPesoComposicion) || other.detalleFactorPesoComposicion == detalleFactorPesoComposicion)&&const DeepCollectionEquality().equals(other._evolucionIndiceBienestar, _evolucionIndiceBienestar)&&const DeepCollectionEquality().equals(other._historialPeso, _historialPeso)&&(identical(other.metricasSecundarias, metricasSecundarias) || other.metricasSecundarias == metricasSecundarias)&&(identical(other.grasa, grasa) || other.grasa == grasa)&&(identical(other.musculos, musculos) || other.musculos == musculos)&&(identical(other.calorias, calorias) || other.calorias == calorias)&&(identical(other.tiempoActivo, tiempoActivo) || other.tiempoActivo == tiempoActivo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,idReporteSemanal,semanaInfo,fechaInicio,fechaFin,actualizado,alertas,mensajeIa,indiceBienestar,variacionIndiceBienestar,detalleFactorMovement,detalleFactorHidratacion,detalleFactorEdadCorporal,detalleFactorCargaMuscular,detalleFactorPesoComposicion,const DeepCollectionEquality().hash(_evolucionIndiceBienestar),const DeepCollectionEquality().hash(_historialPeso),metricasSecundarias,grasa,musculos,calorias,tiempoActivo]);

@override
String toString() {
  return 'ProgressReport(idReporteSemanal: $idReporteSemanal, semanaInfo: $semanaInfo, fechaInicio: $fechaInicio, fechaFin: $fechaFin, actualizado: $actualizado, alertas: $alertas, mensajeIa: $mensajeIa, indiceBienestar: $indiceBienestar, variacionIndiceBienestar: $variacionIndiceBienestar, detalleFactorMovement: $detalleFactorMovement, detalleFactorHidratacion: $detalleFactorHidratacion, detalleFactorEdadCorporal: $detalleFactorEdadCorporal, detalleFactorCargaMuscular: $detalleFactorCargaMuscular, detalleFactorPesoComposicion: $detalleFactorPesoComposicion, evolucionIndiceBienestar: $evolucionIndiceBienestar, historialPeso: $historialPeso, metricasSecundarias: $metricasSecundarias, grasa: $grasa, musculos: $musculos, calorias: $calorias, tiempoActivo: $tiempoActivo)';
}


}

/// @nodoc
abstract mixin class _$ProgressReportCopyWith<$Res> implements $ProgressReportCopyWith<$Res> {
  factory _$ProgressReportCopyWith(_ProgressReport value, $Res Function(_ProgressReport) _then) = __$ProgressReportCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id_reporte_semanal') String? idReporteSemanal,@JsonKey(name: 'semana_info') String? semanaInfo,@JsonKey(name: 'fecha_inicio') String? fechaInicio,@JsonKey(name: 'fecha_fin') String? fechaFin, String? actualizado, Alert? alertas,@JsonKey(name: 'mensaje_ia') String? mensajeIa,@JsonKey(name: 'indice_bienestar') num? indiceBienestar,@JsonKey(name: 'variacion_indice_bienestar') num? variacionIndiceBienestar,@JsonKey(name: 'detalle_factor_movimiento') GeneralFactorDetail? detalleFactorMovement,@JsonKey(name: 'detalle_factor_hidratacion') FactorHidratacionDetail? detalleFactorHidratacion,@JsonKey(name: 'detalle_factor_edad_corporal') GeneralFactorDetail? detalleFactorEdadCorporal,@JsonKey(name: 'detalle_factor_carga_muscular') GeneralFactorDetail? detalleFactorCargaMuscular,@JsonKey(name: 'detalle_factor_peso_composicion') FactorWeightDetail? detalleFactorPesoComposicion,@JsonKey(name: 'evolucion_indice_bienestar') List<WellnessIndexEvolution> evolucionIndiceBienestar,@JsonKey(name: 'historial_peso') List<WeightHistory> historialPeso,@JsonKey(name: 'metricas_secundarias') SecondaryMetrics? metricasSecundarias, CurrentPreviousValue? grasa, CurrentPreviousValue? musculos, CaloriasDetail? calorias,@JsonKey(name: 'tiempo_activo') ActiveTimeDetail? tiempoActivo
});


@override $AlertCopyWith<$Res>? get alertas;@override $GeneralFactorDetailCopyWith<$Res>? get detalleFactorMovement;@override $FactorHidratacionDetailCopyWith<$Res>? get detalleFactorHidratacion;@override $GeneralFactorDetailCopyWith<$Res>? get detalleFactorEdadCorporal;@override $GeneralFactorDetailCopyWith<$Res>? get detalleFactorCargaMuscular;@override $FactorWeightDetailCopyWith<$Res>? get detalleFactorPesoComposicion;@override $SecondaryMetricsCopyWith<$Res>? get metricasSecundarias;@override $CurrentPreviousValueCopyWith<$Res>? get grasa;@override $CurrentPreviousValueCopyWith<$Res>? get musculos;@override $CaloriasDetailCopyWith<$Res>? get calorias;@override $ActiveTimeDetailCopyWith<$Res>? get tiempoActivo;

}
/// @nodoc
class __$ProgressReportCopyWithImpl<$Res>
    implements _$ProgressReportCopyWith<$Res> {
  __$ProgressReportCopyWithImpl(this._self, this._then);

  final _ProgressReport _self;
  final $Res Function(_ProgressReport) _then;

/// Create a copy of ProgressReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? idReporteSemanal = freezed,Object? semanaInfo = freezed,Object? fechaInicio = freezed,Object? fechaFin = freezed,Object? actualizado = freezed,Object? alertas = freezed,Object? mensajeIa = freezed,Object? indiceBienestar = freezed,Object? variacionIndiceBienestar = freezed,Object? detalleFactorMovement = freezed,Object? detalleFactorHidratacion = freezed,Object? detalleFactorEdadCorporal = freezed,Object? detalleFactorCargaMuscular = freezed,Object? detalleFactorPesoComposicion = freezed,Object? evolucionIndiceBienestar = null,Object? historialPeso = null,Object? metricasSecundarias = freezed,Object? grasa = freezed,Object? musculos = freezed,Object? calorias = freezed,Object? tiempoActivo = freezed,}) {
  return _then(_ProgressReport(
idReporteSemanal: freezed == idReporteSemanal ? _self.idReporteSemanal : idReporteSemanal // ignore: cast_nullable_to_non_nullable
as String?,semanaInfo: freezed == semanaInfo ? _self.semanaInfo : semanaInfo // ignore: cast_nullable_to_non_nullable
as String?,fechaInicio: freezed == fechaInicio ? _self.fechaInicio : fechaInicio // ignore: cast_nullable_to_non_nullable
as String?,fechaFin: freezed == fechaFin ? _self.fechaFin : fechaFin // ignore: cast_nullable_to_non_nullable
as String?,actualizado: freezed == actualizado ? _self.actualizado : actualizado // ignore: cast_nullable_to_non_nullable
as String?,alertas: freezed == alertas ? _self.alertas : alertas // ignore: cast_nullable_to_non_nullable
as Alert?,mensajeIa: freezed == mensajeIa ? _self.mensajeIa : mensajeIa // ignore: cast_nullable_to_non_nullable
as String?,indiceBienestar: freezed == indiceBienestar ? _self.indiceBienestar : indiceBienestar // ignore: cast_nullable_to_non_nullable
as num?,variacionIndiceBienestar: freezed == variacionIndiceBienestar ? _self.variacionIndiceBienestar : variacionIndiceBienestar // ignore: cast_nullable_to_non_nullable
as num?,detalleFactorMovement: freezed == detalleFactorMovement ? _self.detalleFactorMovement : detalleFactorMovement // ignore: cast_nullable_to_non_nullable
as GeneralFactorDetail?,detalleFactorHidratacion: freezed == detalleFactorHidratacion ? _self.detalleFactorHidratacion : detalleFactorHidratacion // ignore: cast_nullable_to_non_nullable
as FactorHidratacionDetail?,detalleFactorEdadCorporal: freezed == detalleFactorEdadCorporal ? _self.detalleFactorEdadCorporal : detalleFactorEdadCorporal // ignore: cast_nullable_to_non_nullable
as GeneralFactorDetail?,detalleFactorCargaMuscular: freezed == detalleFactorCargaMuscular ? _self.detalleFactorCargaMuscular : detalleFactorCargaMuscular // ignore: cast_nullable_to_non_nullable
as GeneralFactorDetail?,detalleFactorPesoComposicion: freezed == detalleFactorPesoComposicion ? _self.detalleFactorPesoComposicion : detalleFactorPesoComposicion // ignore: cast_nullable_to_non_nullable
as FactorWeightDetail?,evolucionIndiceBienestar: null == evolucionIndiceBienestar ? _self._evolucionIndiceBienestar : evolucionIndiceBienestar // ignore: cast_nullable_to_non_nullable
as List<WellnessIndexEvolution>,historialPeso: null == historialPeso ? _self._historialPeso : historialPeso // ignore: cast_nullable_to_non_nullable
as List<WeightHistory>,metricasSecundarias: freezed == metricasSecundarias ? _self.metricasSecundarias : metricasSecundarias // ignore: cast_nullable_to_non_nullable
as SecondaryMetrics?,grasa: freezed == grasa ? _self.grasa : grasa // ignore: cast_nullable_to_non_nullable
as CurrentPreviousValue?,musculos: freezed == musculos ? _self.musculos : musculos // ignore: cast_nullable_to_non_nullable
as CurrentPreviousValue?,calorias: freezed == calorias ? _self.calorias : calorias // ignore: cast_nullable_to_non_nullable
as CaloriasDetail?,tiempoActivo: freezed == tiempoActivo ? _self.tiempoActivo : tiempoActivo // ignore: cast_nullable_to_non_nullable
as ActiveTimeDetail?,
  ));
}

/// Create a copy of ProgressReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AlertCopyWith<$Res>? get alertas {
    if (_self.alertas == null) {
    return null;
  }

  return $AlertCopyWith<$Res>(_self.alertas!, (value) {
    return _then(_self.copyWith(alertas: value));
  });
}/// Create a copy of ProgressReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeneralFactorDetailCopyWith<$Res>? get detalleFactorMovement {
    if (_self.detalleFactorMovement == null) {
    return null;
  }

  return $GeneralFactorDetailCopyWith<$Res>(_self.detalleFactorMovement!, (value) {
    return _then(_self.copyWith(detalleFactorMovement: value));
  });
}/// Create a copy of ProgressReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FactorHidratacionDetailCopyWith<$Res>? get detalleFactorHidratacion {
    if (_self.detalleFactorHidratacion == null) {
    return null;
  }

  return $FactorHidratacionDetailCopyWith<$Res>(_self.detalleFactorHidratacion!, (value) {
    return _then(_self.copyWith(detalleFactorHidratacion: value));
  });
}/// Create a copy of ProgressReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeneralFactorDetailCopyWith<$Res>? get detalleFactorEdadCorporal {
    if (_self.detalleFactorEdadCorporal == null) {
    return null;
  }

  return $GeneralFactorDetailCopyWith<$Res>(_self.detalleFactorEdadCorporal!, (value) {
    return _then(_self.copyWith(detalleFactorEdadCorporal: value));
  });
}/// Create a copy of ProgressReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeneralFactorDetailCopyWith<$Res>? get detalleFactorCargaMuscular {
    if (_self.detalleFactorCargaMuscular == null) {
    return null;
  }

  return $GeneralFactorDetailCopyWith<$Res>(_self.detalleFactorCargaMuscular!, (value) {
    return _then(_self.copyWith(detalleFactorCargaMuscular: value));
  });
}/// Create a copy of ProgressReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FactorWeightDetailCopyWith<$Res>? get detalleFactorPesoComposicion {
    if (_self.detalleFactorPesoComposicion == null) {
    return null;
  }

  return $FactorWeightDetailCopyWith<$Res>(_self.detalleFactorPesoComposicion!, (value) {
    return _then(_self.copyWith(detalleFactorPesoComposicion: value));
  });
}/// Create a copy of ProgressReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SecondaryMetricsCopyWith<$Res>? get metricasSecundarias {
    if (_self.metricasSecundarias == null) {
    return null;
  }

  return $SecondaryMetricsCopyWith<$Res>(_self.metricasSecundarias!, (value) {
    return _then(_self.copyWith(metricasSecundarias: value));
  });
}/// Create a copy of ProgressReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CurrentPreviousValueCopyWith<$Res>? get grasa {
    if (_self.grasa == null) {
    return null;
  }

  return $CurrentPreviousValueCopyWith<$Res>(_self.grasa!, (value) {
    return _then(_self.copyWith(grasa: value));
  });
}/// Create a copy of ProgressReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CurrentPreviousValueCopyWith<$Res>? get musculos {
    if (_self.musculos == null) {
    return null;
  }

  return $CurrentPreviousValueCopyWith<$Res>(_self.musculos!, (value) {
    return _then(_self.copyWith(musculos: value));
  });
}/// Create a copy of ProgressReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CaloriasDetailCopyWith<$Res>? get calorias {
    if (_self.calorias == null) {
    return null;
  }

  return $CaloriasDetailCopyWith<$Res>(_self.calorias!, (value) {
    return _then(_self.copyWith(calorias: value));
  });
}/// Create a copy of ProgressReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActiveTimeDetailCopyWith<$Res>? get tiempoActivo {
    if (_self.tiempoActivo == null) {
    return null;
  }

  return $ActiveTimeDetailCopyWith<$Res>(_self.tiempoActivo!, (value) {
    return _then(_self.copyWith(tiempoActivo: value));
  });
}
}


/// @nodoc
mixin _$Alert {

 bool get activa; String? get detalle;
/// Create a copy of Alert
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlertCopyWith<Alert> get copyWith => _$AlertCopyWithImpl<Alert>(this as Alert, _$identity);

  /// Serializes this Alert to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Alert&&(identical(other.activa, activa) || other.activa == activa)&&(identical(other.detalle, detalle) || other.detalle == detalle));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,activa,detalle);

@override
String toString() {
  return 'Alert(activa: $activa, detalle: $detalle)';
}


}

/// @nodoc
abstract mixin class $AlertCopyWith<$Res>  {
  factory $AlertCopyWith(Alert value, $Res Function(Alert) _then) = _$AlertCopyWithImpl;
@useResult
$Res call({
 bool activa, String? detalle
});




}
/// @nodoc
class _$AlertCopyWithImpl<$Res>
    implements $AlertCopyWith<$Res> {
  _$AlertCopyWithImpl(this._self, this._then);

  final Alert _self;
  final $Res Function(Alert) _then;

/// Create a copy of Alert
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? activa = null,Object? detalle = freezed,}) {
  return _then(Alert(
activa: null == activa ? _self.activa : activa // ignore: cast_nullable_to_non_nullable
as bool,detalle: freezed == detalle ? _self.detalle : detalle // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Alert].
extension AlertPatterns on Alert {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Alert value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Alert() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Alert value)  $default,){
final _that = this;
switch (_that) {
case _Alert():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Alert value)?  $default,){
final _that = this;
switch (_that) {
case _Alert() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool activa,  String? detalle)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Alert() when $default != null:
return $default(_that.activa,_that.detalle);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool activa,  String? detalle)  $default,) {final _that = this;
switch (_that) {
case _Alert():
return $default(_that.activa,_that.detalle);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool activa,  String? detalle)?  $default,) {final _that = this;
switch (_that) {
case _Alert() when $default != null:
return $default(_that.activa,_that.detalle);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Alert implements Alert {
  const _Alert({this.activa = false, this.detalle});
  factory _Alert.fromJson(Map<String, dynamic> json) => _$AlertFromJson(json);

@override@JsonKey() final  bool activa;
@override final  String? detalle;

/// Create a copy of Alert
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlertCopyWith<_Alert> get copyWith => __$AlertCopyWithImpl<_Alert>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AlertToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Alert&&(identical(other.activa, activa) || other.activa == activa)&&(identical(other.detalle, detalle) || other.detalle == detalle));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,activa,detalle);

@override
String toString() {
  return 'Alert(activa: $activa, detalle: $detalle)';
}


}

/// @nodoc
abstract mixin class _$AlertCopyWith<$Res> implements $AlertCopyWith<$Res> {
  factory _$AlertCopyWith(_Alert value, $Res Function(_Alert) _then) = __$AlertCopyWithImpl;
@override @useResult
$Res call({
 bool activa, String? detalle
});




}
/// @nodoc
class __$AlertCopyWithImpl<$Res>
    implements _$AlertCopyWith<$Res> {
  __$AlertCopyWithImpl(this._self, this._then);

  final _Alert _self;
  final $Res Function(_Alert) _then;

/// Create a copy of Alert
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? activa = null,Object? detalle = freezed,}) {
  return _then(_Alert(
activa: null == activa ? _self.activa : activa // ignore: cast_nullable_to_non_nullable
as bool,detalle: freezed == detalle ? _self.detalle : detalle // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$GeneralFactorDetail {

 num? get puntaje; num? get variacion;
/// Create a copy of GeneralFactorDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GeneralFactorDetailCopyWith<GeneralFactorDetail> get copyWith => _$GeneralFactorDetailCopyWithImpl<GeneralFactorDetail>(this as GeneralFactorDetail, _$identity);

  /// Serializes this GeneralFactorDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GeneralFactorDetail&&(identical(other.puntaje, puntaje) || other.puntaje == puntaje)&&(identical(other.variacion, variacion) || other.variacion == variacion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,puntaje,variacion);

@override
String toString() {
  return 'GeneralFactorDetail(puntaje: $puntaje, variacion: $variacion)';
}


}

/// @nodoc
abstract mixin class $GeneralFactorDetailCopyWith<$Res>  {
  factory $GeneralFactorDetailCopyWith(GeneralFactorDetail value, $Res Function(GeneralFactorDetail) _then) = _$GeneralFactorDetailCopyWithImpl;
@useResult
$Res call({
 num? puntaje, num? variacion
});




}
/// @nodoc
class _$GeneralFactorDetailCopyWithImpl<$Res>
    implements $GeneralFactorDetailCopyWith<$Res> {
  _$GeneralFactorDetailCopyWithImpl(this._self, this._then);

  final GeneralFactorDetail _self;
  final $Res Function(GeneralFactorDetail) _then;

/// Create a copy of GeneralFactorDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? puntaje = freezed,Object? variacion = freezed,}) {
  return _then(GeneralFactorDetail(
puntaje: freezed == puntaje ? _self.puntaje : puntaje // ignore: cast_nullable_to_non_nullable
as num?,variacion: freezed == variacion ? _self.variacion : variacion // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}

}


/// Adds pattern-matching-related methods to [GeneralFactorDetail].
extension GeneralFactorDetailPatterns on GeneralFactorDetail {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GeneralFactorDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GeneralFactorDetail() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GeneralFactorDetail value)  $default,){
final _that = this;
switch (_that) {
case _GeneralFactorDetail():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GeneralFactorDetail value)?  $default,){
final _that = this;
switch (_that) {
case _GeneralFactorDetail() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( num? puntaje,  num? variacion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GeneralFactorDetail() when $default != null:
return $default(_that.puntaje,_that.variacion);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( num? puntaje,  num? variacion)  $default,) {final _that = this;
switch (_that) {
case _GeneralFactorDetail():
return $default(_that.puntaje,_that.variacion);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( num? puntaje,  num? variacion)?  $default,) {final _that = this;
switch (_that) {
case _GeneralFactorDetail() when $default != null:
return $default(_that.puntaje,_that.variacion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GeneralFactorDetail implements GeneralFactorDetail {
  const _GeneralFactorDetail({this.puntaje, this.variacion});
  factory _GeneralFactorDetail.fromJson(Map<String, dynamic> json) => _$GeneralFactorDetailFromJson(json);

@override final  num? puntaje;
@override final  num? variacion;

/// Create a copy of GeneralFactorDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GeneralFactorDetailCopyWith<_GeneralFactorDetail> get copyWith => __$GeneralFactorDetailCopyWithImpl<_GeneralFactorDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GeneralFactorDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GeneralFactorDetail&&(identical(other.puntaje, puntaje) || other.puntaje == puntaje)&&(identical(other.variacion, variacion) || other.variacion == variacion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,puntaje,variacion);

@override
String toString() {
  return 'GeneralFactorDetail(puntaje: $puntaje, variacion: $variacion)';
}


}

/// @nodoc
abstract mixin class _$GeneralFactorDetailCopyWith<$Res> implements $GeneralFactorDetailCopyWith<$Res> {
  factory _$GeneralFactorDetailCopyWith(_GeneralFactorDetail value, $Res Function(_GeneralFactorDetail) _then) = __$GeneralFactorDetailCopyWithImpl;
@override @useResult
$Res call({
 num? puntaje, num? variacion
});




}
/// @nodoc
class __$GeneralFactorDetailCopyWithImpl<$Res>
    implements _$GeneralFactorDetailCopyWith<$Res> {
  __$GeneralFactorDetailCopyWithImpl(this._self, this._then);

  final _GeneralFactorDetail _self;
  final $Res Function(_GeneralFactorDetail) _then;

/// Create a copy of GeneralFactorDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? puntaje = freezed,Object? variacion = freezed,}) {
  return _then(_GeneralFactorDetail(
puntaje: freezed == puntaje ? _self.puntaje : puntaje // ignore: cast_nullable_to_non_nullable
as num?,variacion: freezed == variacion ? _self.variacion : variacion // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}


}


/// @nodoc
mixin _$FactorHidratacionDetail {

 HidratacionPuntajeDetail? get puntaje; num? get variacion;
/// Create a copy of FactorHidratacionDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FactorHidratacionDetailCopyWith<FactorHidratacionDetail> get copyWith => _$FactorHidratacionDetailCopyWithImpl<FactorHidratacionDetail>(this as FactorHidratacionDetail, _$identity);

  /// Serializes this FactorHidratacionDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FactorHidratacionDetail&&(identical(other.puntaje, puntaje) || other.puntaje == puntaje)&&(identical(other.variacion, variacion) || other.variacion == variacion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,puntaje,variacion);

@override
String toString() {
  return 'FactorHidratacionDetail(puntaje: $puntaje, variacion: $variacion)';
}


}

/// @nodoc
abstract mixin class $FactorHidratacionDetailCopyWith<$Res>  {
  factory $FactorHidratacionDetailCopyWith(FactorHidratacionDetail value, $Res Function(FactorHidratacionDetail) _then) = _$FactorHidratacionDetailCopyWithImpl;
@useResult
$Res call({
 HidratacionPuntajeDetail? puntaje, num? variacion
});


$HidratacionPuntajeDetailCopyWith<$Res>? get puntaje;

}
/// @nodoc
class _$FactorHidratacionDetailCopyWithImpl<$Res>
    implements $FactorHidratacionDetailCopyWith<$Res> {
  _$FactorHidratacionDetailCopyWithImpl(this._self, this._then);

  final FactorHidratacionDetail _self;
  final $Res Function(FactorHidratacionDetail) _then;

/// Create a copy of FactorHidratacionDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? puntaje = freezed,Object? variacion = freezed,}) {
  return _then(FactorHidratacionDetail(
puntaje: freezed == puntaje ? _self.puntaje : puntaje // ignore: cast_nullable_to_non_nullable
as HidratacionPuntajeDetail?,variacion: freezed == variacion ? _self.variacion : variacion // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}
/// Create a copy of FactorHidratacionDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HidratacionPuntajeDetailCopyWith<$Res>? get puntaje {
    if (_self.puntaje == null) {
    return null;
  }

  return $HidratacionPuntajeDetailCopyWith<$Res>(_self.puntaje!, (value) {
    return _then(_self.copyWith(puntaje: value));
  });
}
}


/// Adds pattern-matching-related methods to [FactorHidratacionDetail].
extension FactorHidratacionDetailPatterns on FactorHidratacionDetail {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FactorHidratacionDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FactorHidratacionDetail() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FactorHidratacionDetail value)  $default,){
final _that = this;
switch (_that) {
case _FactorHidratacionDetail():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FactorHidratacionDetail value)?  $default,){
final _that = this;
switch (_that) {
case _FactorHidratacionDetail() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( HidratacionPuntajeDetail? puntaje,  num? variacion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FactorHidratacionDetail() when $default != null:
return $default(_that.puntaje,_that.variacion);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( HidratacionPuntajeDetail? puntaje,  num? variacion)  $default,) {final _that = this;
switch (_that) {
case _FactorHidratacionDetail():
return $default(_that.puntaje,_that.variacion);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( HidratacionPuntajeDetail? puntaje,  num? variacion)?  $default,) {final _that = this;
switch (_that) {
case _FactorHidratacionDetail() when $default != null:
return $default(_that.puntaje,_that.variacion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FactorHidratacionDetail implements FactorHidratacionDetail {
  const _FactorHidratacionDetail({this.puntaje, this.variacion});
  factory _FactorHidratacionDetail.fromJson(Map<String, dynamic> json) => _$FactorHidratacionDetailFromJson(json);

@override final  HidratacionPuntajeDetail? puntaje;
@override final  num? variacion;

/// Create a copy of FactorHidratacionDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FactorHidratacionDetailCopyWith<_FactorHidratacionDetail> get copyWith => __$FactorHidratacionDetailCopyWithImpl<_FactorHidratacionDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FactorHidratacionDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FactorHidratacionDetail&&(identical(other.puntaje, puntaje) || other.puntaje == puntaje)&&(identical(other.variacion, variacion) || other.variacion == variacion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,puntaje,variacion);

@override
String toString() {
  return 'FactorHidratacionDetail(puntaje: $puntaje, variacion: $variacion)';
}


}

/// @nodoc
abstract mixin class _$FactorHidratacionDetailCopyWith<$Res> implements $FactorHidratacionDetailCopyWith<$Res> {
  factory _$FactorHidratacionDetailCopyWith(_FactorHidratacionDetail value, $Res Function(_FactorHidratacionDetail) _then) = __$FactorHidratacionDetailCopyWithImpl;
@override @useResult
$Res call({
 HidratacionPuntajeDetail? puntaje, num? variacion
});


@override $HidratacionPuntajeDetailCopyWith<$Res>? get puntaje;

}
/// @nodoc
class __$FactorHidratacionDetailCopyWithImpl<$Res>
    implements _$FactorHidratacionDetailCopyWith<$Res> {
  __$FactorHidratacionDetailCopyWithImpl(this._self, this._then);

  final _FactorHidratacionDetail _self;
  final $Res Function(_FactorHidratacionDetail) _then;

/// Create a copy of FactorHidratacionDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? puntaje = freezed,Object? variacion = freezed,}) {
  return _then(_FactorHidratacionDetail(
puntaje: freezed == puntaje ? _self.puntaje : puntaje // ignore: cast_nullable_to_non_nullable
as HidratacionPuntajeDetail?,variacion: freezed == variacion ? _self.variacion : variacion // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}

/// Create a copy of FactorHidratacionDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HidratacionPuntajeDetailCopyWith<$Res>? get puntaje {
    if (_self.puntaje == null) {
    return null;
  }

  return $HidratacionPuntajeDetailCopyWith<$Res>(_self.puntaje!, (value) {
    return _then(_self.copyWith(puntaje: value));
  });
}
}


/// @nodoc
mixin _$HidratacionPuntajeDetail {

@JsonKey(name: 'consumo_total_ml') num? get consumoTotalMl;@JsonKey(name: 'score_hidratacion') num? get scoreHidratacion;@JsonKey(name: 'requerimiento_total_ml') num? get requerimientoTotalMl;
/// Create a copy of HidratacionPuntajeDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HidratacionPuntajeDetailCopyWith<HidratacionPuntajeDetail> get copyWith => _$HidratacionPuntajeDetailCopyWithImpl<HidratacionPuntajeDetail>(this as HidratacionPuntajeDetail, _$identity);

  /// Serializes this HidratacionPuntajeDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HidratacionPuntajeDetail&&(identical(other.consumoTotalMl, consumoTotalMl) || other.consumoTotalMl == consumoTotalMl)&&(identical(other.scoreHidratacion, scoreHidratacion) || other.scoreHidratacion == scoreHidratacion)&&(identical(other.requerimientoTotalMl, requerimientoTotalMl) || other.requerimientoTotalMl == requerimientoTotalMl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,consumoTotalMl,scoreHidratacion,requerimientoTotalMl);

@override
String toString() {
  return 'HidratacionPuntajeDetail(consumoTotalMl: $consumoTotalMl, scoreHidratacion: $scoreHidratacion, requerimientoTotalMl: $requerimientoTotalMl)';
}


}

/// @nodoc
abstract mixin class $HidratacionPuntajeDetailCopyWith<$Res>  {
  factory $HidratacionPuntajeDetailCopyWith(HidratacionPuntajeDetail value, $Res Function(HidratacionPuntajeDetail) _then) = _$HidratacionPuntajeDetailCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'consumo_total_ml') num? consumoTotalMl,@JsonKey(name: 'score_hidratacion') num? scoreHidratacion,@JsonKey(name: 'requerimiento_total_ml') num? requerimientoTotalMl
});




}
/// @nodoc
class _$HidratacionPuntajeDetailCopyWithImpl<$Res>
    implements $HidratacionPuntajeDetailCopyWith<$Res> {
  _$HidratacionPuntajeDetailCopyWithImpl(this._self, this._then);

  final HidratacionPuntajeDetail _self;
  final $Res Function(HidratacionPuntajeDetail) _then;

/// Create a copy of HidratacionPuntajeDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? consumoTotalMl = freezed,Object? scoreHidratacion = freezed,Object? requerimientoTotalMl = freezed,}) {
  return _then(HidratacionPuntajeDetail(
consumoTotalMl: freezed == consumoTotalMl ? _self.consumoTotalMl : consumoTotalMl // ignore: cast_nullable_to_non_nullable
as num?,scoreHidratacion: freezed == scoreHidratacion ? _self.scoreHidratacion : scoreHidratacion // ignore: cast_nullable_to_non_nullable
as num?,requerimientoTotalMl: freezed == requerimientoTotalMl ? _self.requerimientoTotalMl : requerimientoTotalMl // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}

}


/// Adds pattern-matching-related methods to [HidratacionPuntajeDetail].
extension HidratacionPuntajeDetailPatterns on HidratacionPuntajeDetail {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HidratacionPuntajeDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HidratacionPuntajeDetail() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HidratacionPuntajeDetail value)  $default,){
final _that = this;
switch (_that) {
case _HidratacionPuntajeDetail():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HidratacionPuntajeDetail value)?  $default,){
final _that = this;
switch (_that) {
case _HidratacionPuntajeDetail() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'consumo_total_ml')  num? consumoTotalMl, @JsonKey(name: 'score_hidratacion')  num? scoreHidratacion, @JsonKey(name: 'requerimiento_total_ml')  num? requerimientoTotalMl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HidratacionPuntajeDetail() when $default != null:
return $default(_that.consumoTotalMl,_that.scoreHidratacion,_that.requerimientoTotalMl);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'consumo_total_ml')  num? consumoTotalMl, @JsonKey(name: 'score_hidratacion')  num? scoreHidratacion, @JsonKey(name: 'requerimiento_total_ml')  num? requerimientoTotalMl)  $default,) {final _that = this;
switch (_that) {
case _HidratacionPuntajeDetail():
return $default(_that.consumoTotalMl,_that.scoreHidratacion,_that.requerimientoTotalMl);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'consumo_total_ml')  num? consumoTotalMl, @JsonKey(name: 'score_hidratacion')  num? scoreHidratacion, @JsonKey(name: 'requerimiento_total_ml')  num? requerimientoTotalMl)?  $default,) {final _that = this;
switch (_that) {
case _HidratacionPuntajeDetail() when $default != null:
return $default(_that.consumoTotalMl,_that.scoreHidratacion,_that.requerimientoTotalMl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HidratacionPuntajeDetail implements HidratacionPuntajeDetail {
  const _HidratacionPuntajeDetail({@JsonKey(name: 'consumo_total_ml') this.consumoTotalMl, @JsonKey(name: 'score_hidratacion') this.scoreHidratacion, @JsonKey(name: 'requerimiento_total_ml') this.requerimientoTotalMl});
  factory _HidratacionPuntajeDetail.fromJson(Map<String, dynamic> json) => _$HidratacionPuntajeDetailFromJson(json);

@override@JsonKey(name: 'consumo_total_ml') final  num? consumoTotalMl;
@override@JsonKey(name: 'score_hidratacion') final  num? scoreHidratacion;
@override@JsonKey(name: 'requerimiento_total_ml') final  num? requerimientoTotalMl;

/// Create a copy of HidratacionPuntajeDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HidratacionPuntajeDetailCopyWith<_HidratacionPuntajeDetail> get copyWith => __$HidratacionPuntajeDetailCopyWithImpl<_HidratacionPuntajeDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HidratacionPuntajeDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HidratacionPuntajeDetail&&(identical(other.consumoTotalMl, consumoTotalMl) || other.consumoTotalMl == consumoTotalMl)&&(identical(other.scoreHidratacion, scoreHidratacion) || other.scoreHidratacion == scoreHidratacion)&&(identical(other.requerimientoTotalMl, requerimientoTotalMl) || other.requerimientoTotalMl == requerimientoTotalMl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,consumoTotalMl,scoreHidratacion,requerimientoTotalMl);

@override
String toString() {
  return 'HidratacionPuntajeDetail(consumoTotalMl: $consumoTotalMl, scoreHidratacion: $scoreHidratacion, requerimientoTotalMl: $requerimientoTotalMl)';
}


}

/// @nodoc
abstract mixin class _$HidratacionPuntajeDetailCopyWith<$Res> implements $HidratacionPuntajeDetailCopyWith<$Res> {
  factory _$HidratacionPuntajeDetailCopyWith(_HidratacionPuntajeDetail value, $Res Function(_HidratacionPuntajeDetail) _then) = __$HidratacionPuntajeDetailCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'consumo_total_ml') num? consumoTotalMl,@JsonKey(name: 'score_hidratacion') num? scoreHidratacion,@JsonKey(name: 'requerimiento_total_ml') num? requerimientoTotalMl
});




}
/// @nodoc
class __$HidratacionPuntajeDetailCopyWithImpl<$Res>
    implements _$HidratacionPuntajeDetailCopyWith<$Res> {
  __$HidratacionPuntajeDetailCopyWithImpl(this._self, this._then);

  final _HidratacionPuntajeDetail _self;
  final $Res Function(_HidratacionPuntajeDetail) _then;

/// Create a copy of HidratacionPuntajeDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? consumoTotalMl = freezed,Object? scoreHidratacion = freezed,Object? requerimientoTotalMl = freezed,}) {
  return _then(_HidratacionPuntajeDetail(
consumoTotalMl: freezed == consumoTotalMl ? _self.consumoTotalMl : consumoTotalMl // ignore: cast_nullable_to_non_nullable
as num?,scoreHidratacion: freezed == scoreHidratacion ? _self.scoreHidratacion : scoreHidratacion // ignore: cast_nullable_to_non_nullable
as num?,requerimientoTotalMl: freezed == requerimientoTotalMl ? _self.requerimientoTotalMl : requerimientoTotalMl // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}


}


/// @nodoc
mixin _$FactorWeightDetail {

 WeightPuntajeDetail? get puntaje; num? get variacion; num? get imc;@JsonKey(name: 'peso_registrado') num? get pesoRegistrado;
/// Create a copy of FactorWeightDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FactorWeightDetailCopyWith<FactorWeightDetail> get copyWith => _$FactorWeightDetailCopyWithImpl<FactorWeightDetail>(this as FactorWeightDetail, _$identity);

  /// Serializes this FactorWeightDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FactorWeightDetail&&(identical(other.puntaje, puntaje) || other.puntaje == puntaje)&&(identical(other.variacion, variacion) || other.variacion == variacion)&&(identical(other.imc, imc) || other.imc == imc)&&(identical(other.pesoRegistrado, pesoRegistrado) || other.pesoRegistrado == pesoRegistrado));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,puntaje,variacion,imc,pesoRegistrado);

@override
String toString() {
  return 'FactorWeightDetail(puntaje: $puntaje, variacion: $variacion, imc: $imc, pesoRegistrado: $pesoRegistrado)';
}


}

/// @nodoc
abstract mixin class $FactorWeightDetailCopyWith<$Res>  {
  factory $FactorWeightDetailCopyWith(FactorWeightDetail value, $Res Function(FactorWeightDetail) _then) = _$FactorWeightDetailCopyWithImpl;
@useResult
$Res call({
 WeightPuntajeDetail? puntaje, num? variacion, num? imc,@JsonKey(name: 'peso_registrado') num? pesoRegistrado
});


$WeightPuntajeDetailCopyWith<$Res>? get puntaje;

}
/// @nodoc
class _$FactorWeightDetailCopyWithImpl<$Res>
    implements $FactorWeightDetailCopyWith<$Res> {
  _$FactorWeightDetailCopyWithImpl(this._self, this._then);

  final FactorWeightDetail _self;
  final $Res Function(FactorWeightDetail) _then;

/// Create a copy of FactorWeightDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? puntaje = freezed,Object? variacion = freezed,Object? imc = freezed,Object? pesoRegistrado = freezed,}) {
  return _then(FactorWeightDetail(
puntaje: freezed == puntaje ? _self.puntaje : puntaje // ignore: cast_nullable_to_non_nullable
as WeightPuntajeDetail?,variacion: freezed == variacion ? _self.variacion : variacion // ignore: cast_nullable_to_non_nullable
as num?,imc: freezed == imc ? _self.imc : imc // ignore: cast_nullable_to_non_nullable
as num?,pesoRegistrado: freezed == pesoRegistrado ? _self.pesoRegistrado : pesoRegistrado // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}
/// Create a copy of FactorWeightDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeightPuntajeDetailCopyWith<$Res>? get puntaje {
    if (_self.puntaje == null) {
    return null;
  }

  return $WeightPuntajeDetailCopyWith<$Res>(_self.puntaje!, (value) {
    return _then(_self.copyWith(puntaje: value));
  });
}
}


/// Adds pattern-matching-related methods to [FactorWeightDetail].
extension FactorWeightDetailPatterns on FactorWeightDetail {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FactorWeightDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FactorWeightDetail() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FactorWeightDetail value)  $default,){
final _that = this;
switch (_that) {
case _FactorWeightDetail():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FactorWeightDetail value)?  $default,){
final _that = this;
switch (_that) {
case _FactorWeightDetail() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( WeightPuntajeDetail? puntaje,  num? variacion,  num? imc, @JsonKey(name: 'peso_registrado')  num? pesoRegistrado)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FactorWeightDetail() when $default != null:
return $default(_that.puntaje,_that.variacion,_that.imc,_that.pesoRegistrado);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( WeightPuntajeDetail? puntaje,  num? variacion,  num? imc, @JsonKey(name: 'peso_registrado')  num? pesoRegistrado)  $default,) {final _that = this;
switch (_that) {
case _FactorWeightDetail():
return $default(_that.puntaje,_that.variacion,_that.imc,_that.pesoRegistrado);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( WeightPuntajeDetail? puntaje,  num? variacion,  num? imc, @JsonKey(name: 'peso_registrado')  num? pesoRegistrado)?  $default,) {final _that = this;
switch (_that) {
case _FactorWeightDetail() when $default != null:
return $default(_that.puntaje,_that.variacion,_that.imc,_that.pesoRegistrado);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FactorWeightDetail implements FactorWeightDetail {
  const _FactorWeightDetail({this.puntaje, this.variacion, this.imc, @JsonKey(name: 'peso_registrado') this.pesoRegistrado});
  factory _FactorWeightDetail.fromJson(Map<String, dynamic> json) => _$FactorWeightDetailFromJson(json);

@override final  WeightPuntajeDetail? puntaje;
@override final  num? variacion;
@override final  num? imc;
@override@JsonKey(name: 'peso_registrado') final  num? pesoRegistrado;

/// Create a copy of FactorWeightDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FactorWeightDetailCopyWith<_FactorWeightDetail> get copyWith => __$FactorWeightDetailCopyWithImpl<_FactorWeightDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FactorWeightDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FactorWeightDetail&&(identical(other.puntaje, puntaje) || other.puntaje == puntaje)&&(identical(other.variacion, variacion) || other.variacion == variacion)&&(identical(other.imc, imc) || other.imc == imc)&&(identical(other.pesoRegistrado, pesoRegistrado) || other.pesoRegistrado == pesoRegistrado));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,puntaje,variacion,imc,pesoRegistrado);

@override
String toString() {
  return 'FactorWeightDetail(puntaje: $puntaje, variacion: $variacion, imc: $imc, pesoRegistrado: $pesoRegistrado)';
}


}

/// @nodoc
abstract mixin class _$FactorWeightDetailCopyWith<$Res> implements $FactorWeightDetailCopyWith<$Res> {
  factory _$FactorWeightDetailCopyWith(_FactorWeightDetail value, $Res Function(_FactorWeightDetail) _then) = __$FactorWeightDetailCopyWithImpl;
@override @useResult
$Res call({
 WeightPuntajeDetail? puntaje, num? variacion, num? imc,@JsonKey(name: 'peso_registrado') num? pesoRegistrado
});


@override $WeightPuntajeDetailCopyWith<$Res>? get puntaje;

}
/// @nodoc
class __$FactorWeightDetailCopyWithImpl<$Res>
    implements _$FactorWeightDetailCopyWith<$Res> {
  __$FactorWeightDetailCopyWithImpl(this._self, this._then);

  final _FactorWeightDetail _self;
  final $Res Function(_FactorWeightDetail) _then;

/// Create a copy of FactorWeightDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? puntaje = freezed,Object? variacion = freezed,Object? imc = freezed,Object? pesoRegistrado = freezed,}) {
  return _then(_FactorWeightDetail(
puntaje: freezed == puntaje ? _self.puntaje : puntaje // ignore: cast_nullable_to_non_nullable
as WeightPuntajeDetail?,variacion: freezed == variacion ? _self.variacion : variacion // ignore: cast_nullable_to_non_nullable
as num?,imc: freezed == imc ? _self.imc : imc // ignore: cast_nullable_to_non_nullable
as num?,pesoRegistrado: freezed == pesoRegistrado ? _self.pesoRegistrado : pesoRegistrado // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}

/// Create a copy of FactorWeightDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeightPuntajeDetailCopyWith<$Res>? get puntaje {
    if (_self.puntaje == null) {
    return null;
  }

  return $WeightPuntajeDetailCopyWith<$Res>(_self.puntaje!, (value) {
    return _then(_self.copyWith(puntaje: value));
  });
}
}


/// @nodoc
mixin _$WeightPuntajeDetail {

 String? get tag; num? get puntaje;
/// Create a copy of WeightPuntajeDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeightPuntajeDetailCopyWith<WeightPuntajeDetail> get copyWith => _$WeightPuntajeDetailCopyWithImpl<WeightPuntajeDetail>(this as WeightPuntajeDetail, _$identity);

  /// Serializes this WeightPuntajeDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeightPuntajeDetail&&(identical(other.tag, tag) || other.tag == tag)&&(identical(other.puntaje, puntaje) || other.puntaje == puntaje));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tag,puntaje);

@override
String toString() {
  return 'WeightPuntajeDetail(tag: $tag, puntaje: $puntaje)';
}


}

/// @nodoc
abstract mixin class $WeightPuntajeDetailCopyWith<$Res>  {
  factory $WeightPuntajeDetailCopyWith(WeightPuntajeDetail value, $Res Function(WeightPuntajeDetail) _then) = _$WeightPuntajeDetailCopyWithImpl;
@useResult
$Res call({
 String? tag, num? puntaje
});




}
/// @nodoc
class _$WeightPuntajeDetailCopyWithImpl<$Res>
    implements $WeightPuntajeDetailCopyWith<$Res> {
  _$WeightPuntajeDetailCopyWithImpl(this._self, this._then);

  final WeightPuntajeDetail _self;
  final $Res Function(WeightPuntajeDetail) _then;

/// Create a copy of WeightPuntajeDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tag = freezed,Object? puntaje = freezed,}) {
  return _then(WeightPuntajeDetail(
tag: freezed == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as String?,puntaje: freezed == puntaje ? _self.puntaje : puntaje // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}

}


/// Adds pattern-matching-related methods to [WeightPuntajeDetail].
extension WeightPuntajeDetailPatterns on WeightPuntajeDetail {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeightPuntajeDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeightPuntajeDetail() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeightPuntajeDetail value)  $default,){
final _that = this;
switch (_that) {
case _WeightPuntajeDetail():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeightPuntajeDetail value)?  $default,){
final _that = this;
switch (_that) {
case _WeightPuntajeDetail() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? tag,  num? puntaje)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeightPuntajeDetail() when $default != null:
return $default(_that.tag,_that.puntaje);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? tag,  num? puntaje)  $default,) {final _that = this;
switch (_that) {
case _WeightPuntajeDetail():
return $default(_that.tag,_that.puntaje);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? tag,  num? puntaje)?  $default,) {final _that = this;
switch (_that) {
case _WeightPuntajeDetail() when $default != null:
return $default(_that.tag,_that.puntaje);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WeightPuntajeDetail implements WeightPuntajeDetail {
  const _WeightPuntajeDetail({this.tag, this.puntaje});
  factory _WeightPuntajeDetail.fromJson(Map<String, dynamic> json) => _$WeightPuntajeDetailFromJson(json);

@override final  String? tag;
@override final  num? puntaje;

/// Create a copy of WeightPuntajeDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeightPuntajeDetailCopyWith<_WeightPuntajeDetail> get copyWith => __$WeightPuntajeDetailCopyWithImpl<_WeightPuntajeDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WeightPuntajeDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeightPuntajeDetail&&(identical(other.tag, tag) || other.tag == tag)&&(identical(other.puntaje, puntaje) || other.puntaje == puntaje));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tag,puntaje);

@override
String toString() {
  return 'WeightPuntajeDetail(tag: $tag, puntaje: $puntaje)';
}


}

/// @nodoc
abstract mixin class _$WeightPuntajeDetailCopyWith<$Res> implements $WeightPuntajeDetailCopyWith<$Res> {
  factory _$WeightPuntajeDetailCopyWith(_WeightPuntajeDetail value, $Res Function(_WeightPuntajeDetail) _then) = __$WeightPuntajeDetailCopyWithImpl;
@override @useResult
$Res call({
 String? tag, num? puntaje
});




}
/// @nodoc
class __$WeightPuntajeDetailCopyWithImpl<$Res>
    implements _$WeightPuntajeDetailCopyWith<$Res> {
  __$WeightPuntajeDetailCopyWithImpl(this._self, this._then);

  final _WeightPuntajeDetail _self;
  final $Res Function(_WeightPuntajeDetail) _then;

/// Create a copy of WeightPuntajeDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tag = freezed,Object? puntaje = freezed,}) {
  return _then(_WeightPuntajeDetail(
tag: freezed == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as String?,puntaje: freezed == puntaje ? _self.puntaje : puntaje // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}


}


/// @nodoc
mixin _$CurrentPreviousValue {

@JsonKey(fromJson: _parseNumericOrString) num? get actual;@JsonKey(fromJson: _parseNumericOrString) num? get anterior;
/// Create a copy of CurrentPreviousValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CurrentPreviousValueCopyWith<CurrentPreviousValue> get copyWith => _$CurrentPreviousValueCopyWithImpl<CurrentPreviousValue>(this as CurrentPreviousValue, _$identity);

  /// Serializes this CurrentPreviousValue to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CurrentPreviousValue&&(identical(other.actual, actual) || other.actual == actual)&&(identical(other.anterior, anterior) || other.anterior == anterior));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,actual,anterior);

@override
String toString() {
  return 'CurrentPreviousValue(actual: $actual, anterior: $anterior)';
}


}

/// @nodoc
abstract mixin class $CurrentPreviousValueCopyWith<$Res>  {
  factory $CurrentPreviousValueCopyWith(CurrentPreviousValue value, $Res Function(CurrentPreviousValue) _then) = _$CurrentPreviousValueCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _parseNumericOrString) num? actual,@JsonKey(fromJson: _parseNumericOrString) num? anterior
});




}
/// @nodoc
class _$CurrentPreviousValueCopyWithImpl<$Res>
    implements $CurrentPreviousValueCopyWith<$Res> {
  _$CurrentPreviousValueCopyWithImpl(this._self, this._then);

  final CurrentPreviousValue _self;
  final $Res Function(CurrentPreviousValue) _then;

/// Create a copy of CurrentPreviousValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? actual = freezed,Object? anterior = freezed,}) {
  return _then(CurrentPreviousValue(
actual: freezed == actual ? _self.actual : actual // ignore: cast_nullable_to_non_nullable
as num?,anterior: freezed == anterior ? _self.anterior : anterior // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}

}


/// Adds pattern-matching-related methods to [CurrentPreviousValue].
extension CurrentPreviousValuePatterns on CurrentPreviousValue {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CurrentPreviousValue value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CurrentPreviousValue() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CurrentPreviousValue value)  $default,){
final _that = this;
switch (_that) {
case _CurrentPreviousValue():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CurrentPreviousValue value)?  $default,){
final _that = this;
switch (_that) {
case _CurrentPreviousValue() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _parseNumericOrString)  num? actual, @JsonKey(fromJson: _parseNumericOrString)  num? anterior)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CurrentPreviousValue() when $default != null:
return $default(_that.actual,_that.anterior);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _parseNumericOrString)  num? actual, @JsonKey(fromJson: _parseNumericOrString)  num? anterior)  $default,) {final _that = this;
switch (_that) {
case _CurrentPreviousValue():
return $default(_that.actual,_that.anterior);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _parseNumericOrString)  num? actual, @JsonKey(fromJson: _parseNumericOrString)  num? anterior)?  $default,) {final _that = this;
switch (_that) {
case _CurrentPreviousValue() when $default != null:
return $default(_that.actual,_that.anterior);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CurrentPreviousValue implements CurrentPreviousValue {
  const _CurrentPreviousValue({@JsonKey(fromJson: _parseNumericOrString) this.actual, @JsonKey(fromJson: _parseNumericOrString) this.anterior});
  factory _CurrentPreviousValue.fromJson(Map<String, dynamic> json) => _$CurrentPreviousValueFromJson(json);

@override@JsonKey(fromJson: _parseNumericOrString) final  num? actual;
@override@JsonKey(fromJson: _parseNumericOrString) final  num? anterior;

/// Create a copy of CurrentPreviousValue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CurrentPreviousValueCopyWith<_CurrentPreviousValue> get copyWith => __$CurrentPreviousValueCopyWithImpl<_CurrentPreviousValue>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CurrentPreviousValueToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CurrentPreviousValue&&(identical(other.actual, actual) || other.actual == actual)&&(identical(other.anterior, anterior) || other.anterior == anterior));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,actual,anterior);

@override
String toString() {
  return 'CurrentPreviousValue(actual: $actual, anterior: $anterior)';
}


}

/// @nodoc
abstract mixin class _$CurrentPreviousValueCopyWith<$Res> implements $CurrentPreviousValueCopyWith<$Res> {
  factory _$CurrentPreviousValueCopyWith(_CurrentPreviousValue value, $Res Function(_CurrentPreviousValue) _then) = __$CurrentPreviousValueCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _parseNumericOrString) num? actual,@JsonKey(fromJson: _parseNumericOrString) num? anterior
});




}
/// @nodoc
class __$CurrentPreviousValueCopyWithImpl<$Res>
    implements _$CurrentPreviousValueCopyWith<$Res> {
  __$CurrentPreviousValueCopyWithImpl(this._self, this._then);

  final _CurrentPreviousValue _self;
  final $Res Function(_CurrentPreviousValue) _then;

/// Create a copy of CurrentPreviousValue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? actual = freezed,Object? anterior = freezed,}) {
  return _then(_CurrentPreviousValue(
actual: freezed == actual ? _self.actual : actual // ignore: cast_nullable_to_non_nullable
as num?,anterior: freezed == anterior ? _self.anterior : anterior // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}


}


/// @nodoc
mixin _$ActiveTimeDetail {

@JsonKey(name: 'total_minutos') num? get totalMinutos;@JsonKey(name: 'sesiones_completadas') num? get sesionesCompletadas;@JsonKey(name: 'sesiones_totales') num? get sesionesTotales;@JsonKey(name: 'diferencia_sesiones') num? get diferenciaSesiones;
/// Create a copy of ActiveTimeDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActiveTimeDetailCopyWith<ActiveTimeDetail> get copyWith => _$ActiveTimeDetailCopyWithImpl<ActiveTimeDetail>(this as ActiveTimeDetail, _$identity);

  /// Serializes this ActiveTimeDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActiveTimeDetail&&(identical(other.totalMinutos, totalMinutos) || other.totalMinutos == totalMinutos)&&(identical(other.sesionesCompletadas, sesionesCompletadas) || other.sesionesCompletadas == sesionesCompletadas)&&(identical(other.sesionesTotales, sesionesTotales) || other.sesionesTotales == sesionesTotales)&&(identical(other.diferenciaSesiones, diferenciaSesiones) || other.diferenciaSesiones == diferenciaSesiones));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalMinutos,sesionesCompletadas,sesionesTotales,diferenciaSesiones);

@override
String toString() {
  return 'ActiveTimeDetail(totalMinutos: $totalMinutos, sesionesCompletadas: $sesionesCompletadas, sesionesTotales: $sesionesTotales, diferenciaSesiones: $diferenciaSesiones)';
}


}

/// @nodoc
abstract mixin class $ActiveTimeDetailCopyWith<$Res>  {
  factory $ActiveTimeDetailCopyWith(ActiveTimeDetail value, $Res Function(ActiveTimeDetail) _then) = _$ActiveTimeDetailCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'total_minutos') num? totalMinutos,@JsonKey(name: 'sesiones_completadas') num? sesionesCompletadas,@JsonKey(name: 'sesiones_totales') num? sesionesTotales,@JsonKey(name: 'diferencia_sesiones') num? diferenciaSesiones
});




}
/// @nodoc
class _$ActiveTimeDetailCopyWithImpl<$Res>
    implements $ActiveTimeDetailCopyWith<$Res> {
  _$ActiveTimeDetailCopyWithImpl(this._self, this._then);

  final ActiveTimeDetail _self;
  final $Res Function(ActiveTimeDetail) _then;

/// Create a copy of ActiveTimeDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalMinutos = freezed,Object? sesionesCompletadas = freezed,Object? sesionesTotales = freezed,Object? diferenciaSesiones = freezed,}) {
  return _then(ActiveTimeDetail(
totalMinutos: freezed == totalMinutos ? _self.totalMinutos : totalMinutos // ignore: cast_nullable_to_non_nullable
as num?,sesionesCompletadas: freezed == sesionesCompletadas ? _self.sesionesCompletadas : sesionesCompletadas // ignore: cast_nullable_to_non_nullable
as num?,sesionesTotales: freezed == sesionesTotales ? _self.sesionesTotales : sesionesTotales // ignore: cast_nullable_to_non_nullable
as num?,diferenciaSesiones: freezed == diferenciaSesiones ? _self.diferenciaSesiones : diferenciaSesiones // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}

}


/// Adds pattern-matching-related methods to [ActiveTimeDetail].
extension ActiveTimeDetailPatterns on ActiveTimeDetail {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActiveTimeDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActiveTimeDetail() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActiveTimeDetail value)  $default,){
final _that = this;
switch (_that) {
case _ActiveTimeDetail():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActiveTimeDetail value)?  $default,){
final _that = this;
switch (_that) {
case _ActiveTimeDetail() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_minutos')  num? totalMinutos, @JsonKey(name: 'sesiones_completadas')  num? sesionesCompletadas, @JsonKey(name: 'sesiones_totales')  num? sesionesTotales, @JsonKey(name: 'diferencia_sesiones')  num? diferenciaSesiones)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActiveTimeDetail() when $default != null:
return $default(_that.totalMinutos,_that.sesionesCompletadas,_that.sesionesTotales,_that.diferenciaSesiones);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_minutos')  num? totalMinutos, @JsonKey(name: 'sesiones_completadas')  num? sesionesCompletadas, @JsonKey(name: 'sesiones_totales')  num? sesionesTotales, @JsonKey(name: 'diferencia_sesiones')  num? diferenciaSesiones)  $default,) {final _that = this;
switch (_that) {
case _ActiveTimeDetail():
return $default(_that.totalMinutos,_that.sesionesCompletadas,_that.sesionesTotales,_that.diferenciaSesiones);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'total_minutos')  num? totalMinutos, @JsonKey(name: 'sesiones_completadas')  num? sesionesCompletadas, @JsonKey(name: 'sesiones_totales')  num? sesionesTotales, @JsonKey(name: 'diferencia_sesiones')  num? diferenciaSesiones)?  $default,) {final _that = this;
switch (_that) {
case _ActiveTimeDetail() when $default != null:
return $default(_that.totalMinutos,_that.sesionesCompletadas,_that.sesionesTotales,_that.diferenciaSesiones);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActiveTimeDetail implements ActiveTimeDetail {
  const _ActiveTimeDetail({@JsonKey(name: 'total_minutos') this.totalMinutos, @JsonKey(name: 'sesiones_completadas') this.sesionesCompletadas, @JsonKey(name: 'sesiones_totales') this.sesionesTotales, @JsonKey(name: 'diferencia_sesiones') this.diferenciaSesiones});
  factory _ActiveTimeDetail.fromJson(Map<String, dynamic> json) => _$ActiveTimeDetailFromJson(json);

@override@JsonKey(name: 'total_minutos') final  num? totalMinutos;
@override@JsonKey(name: 'sesiones_completadas') final  num? sesionesCompletadas;
@override@JsonKey(name: 'sesiones_totales') final  num? sesionesTotales;
@override@JsonKey(name: 'diferencia_sesiones') final  num? diferenciaSesiones;

/// Create a copy of ActiveTimeDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActiveTimeDetailCopyWith<_ActiveTimeDetail> get copyWith => __$ActiveTimeDetailCopyWithImpl<_ActiveTimeDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActiveTimeDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActiveTimeDetail&&(identical(other.totalMinutos, totalMinutos) || other.totalMinutos == totalMinutos)&&(identical(other.sesionesCompletadas, sesionesCompletadas) || other.sesionesCompletadas == sesionesCompletadas)&&(identical(other.sesionesTotales, sesionesTotales) || other.sesionesTotales == sesionesTotales)&&(identical(other.diferenciaSesiones, diferenciaSesiones) || other.diferenciaSesiones == diferenciaSesiones));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalMinutos,sesionesCompletadas,sesionesTotales,diferenciaSesiones);

@override
String toString() {
  return 'ActiveTimeDetail(totalMinutos: $totalMinutos, sesionesCompletadas: $sesionesCompletadas, sesionesTotales: $sesionesTotales, diferenciaSesiones: $diferenciaSesiones)';
}


}

/// @nodoc
abstract mixin class _$ActiveTimeDetailCopyWith<$Res> implements $ActiveTimeDetailCopyWith<$Res> {
  factory _$ActiveTimeDetailCopyWith(_ActiveTimeDetail value, $Res Function(_ActiveTimeDetail) _then) = __$ActiveTimeDetailCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'total_minutos') num? totalMinutos,@JsonKey(name: 'sesiones_completadas') num? sesionesCompletadas,@JsonKey(name: 'sesiones_totales') num? sesionesTotales,@JsonKey(name: 'diferencia_sesiones') num? diferenciaSesiones
});




}
/// @nodoc
class __$ActiveTimeDetailCopyWithImpl<$Res>
    implements _$ActiveTimeDetailCopyWith<$Res> {
  __$ActiveTimeDetailCopyWithImpl(this._self, this._then);

  final _ActiveTimeDetail _self;
  final $Res Function(_ActiveTimeDetail) _then;

/// Create a copy of ActiveTimeDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalMinutos = freezed,Object? sesionesCompletadas = freezed,Object? sesionesTotales = freezed,Object? diferenciaSesiones = freezed,}) {
  return _then(_ActiveTimeDetail(
totalMinutos: freezed == totalMinutos ? _self.totalMinutos : totalMinutos // ignore: cast_nullable_to_non_nullable
as num?,sesionesCompletadas: freezed == sesionesCompletadas ? _self.sesionesCompletadas : sesionesCompletadas // ignore: cast_nullable_to_non_nullable
as num?,sesionesTotales: freezed == sesionesTotales ? _self.sesionesTotales : sesionesTotales // ignore: cast_nullable_to_non_nullable
as num?,diferenciaSesiones: freezed == diferenciaSesiones ? _self.diferenciaSesiones : diferenciaSesiones // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}


}


/// @nodoc
mixin _$SecondaryMetrics {

 SecondaryMetricValues? get actual; SecondaryMetricValues? get anterior;
/// Create a copy of SecondaryMetrics
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SecondaryMetricsCopyWith<SecondaryMetrics> get copyWith => _$SecondaryMetricsCopyWithImpl<SecondaryMetrics>(this as SecondaryMetrics, _$identity);

  /// Serializes this SecondaryMetrics to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SecondaryMetrics&&(identical(other.actual, actual) || other.actual == actual)&&(identical(other.anterior, anterior) || other.anterior == anterior));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,actual,anterior);

@override
String toString() {
  return 'SecondaryMetrics(actual: $actual, anterior: $anterior)';
}


}

/// @nodoc
abstract mixin class $SecondaryMetricsCopyWith<$Res>  {
  factory $SecondaryMetricsCopyWith(SecondaryMetrics value, $Res Function(SecondaryMetrics) _then) = _$SecondaryMetricsCopyWithImpl;
@useResult
$Res call({
 SecondaryMetricValues? actual, SecondaryMetricValues? anterior
});


$SecondaryMetricValuesCopyWith<$Res>? get actual;$SecondaryMetricValuesCopyWith<$Res>? get anterior;

}
/// @nodoc
class _$SecondaryMetricsCopyWithImpl<$Res>
    implements $SecondaryMetricsCopyWith<$Res> {
  _$SecondaryMetricsCopyWithImpl(this._self, this._then);

  final SecondaryMetrics _self;
  final $Res Function(SecondaryMetrics) _then;

/// Create a copy of SecondaryMetrics
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? actual = freezed,Object? anterior = freezed,}) {
  return _then(SecondaryMetrics(
actual: freezed == actual ? _self.actual : actual // ignore: cast_nullable_to_non_nullable
as SecondaryMetricValues?,anterior: freezed == anterior ? _self.anterior : anterior // ignore: cast_nullable_to_non_nullable
as SecondaryMetricValues?,
  ));
}
/// Create a copy of SecondaryMetrics
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SecondaryMetricValuesCopyWith<$Res>? get actual {
    if (_self.actual == null) {
    return null;
  }

  return $SecondaryMetricValuesCopyWith<$Res>(_self.actual!, (value) {
    return _then(_self.copyWith(actual: value));
  });
}/// Create a copy of SecondaryMetrics
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SecondaryMetricValuesCopyWith<$Res>? get anterior {
    if (_self.anterior == null) {
    return null;
  }

  return $SecondaryMetricValuesCopyWith<$Res>(_self.anterior!, (value) {
    return _then(_self.copyWith(anterior: value));
  });
}
}


/// Adds pattern-matching-related methods to [SecondaryMetrics].
extension SecondaryMetricsPatterns on SecondaryMetrics {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SecondaryMetrics value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SecondaryMetrics() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SecondaryMetrics value)  $default,){
final _that = this;
switch (_that) {
case _SecondaryMetrics():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SecondaryMetrics value)?  $default,){
final _that = this;
switch (_that) {
case _SecondaryMetrics() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SecondaryMetricValues? actual,  SecondaryMetricValues? anterior)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SecondaryMetrics() when $default != null:
return $default(_that.actual,_that.anterior);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SecondaryMetricValues? actual,  SecondaryMetricValues? anterior)  $default,) {final _that = this;
switch (_that) {
case _SecondaryMetrics():
return $default(_that.actual,_that.anterior);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SecondaryMetricValues? actual,  SecondaryMetricValues? anterior)?  $default,) {final _that = this;
switch (_that) {
case _SecondaryMetrics() when $default != null:
return $default(_that.actual,_that.anterior);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SecondaryMetrics implements SecondaryMetrics {
  const _SecondaryMetrics({this.actual, this.anterior});
  factory _SecondaryMetrics.fromJson(Map<String, dynamic> json) => _$SecondaryMetricsFromJson(json);

@override final  SecondaryMetricValues? actual;
@override final  SecondaryMetricValues? anterior;

/// Create a copy of SecondaryMetrics
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SecondaryMetricsCopyWith<_SecondaryMetrics> get copyWith => __$SecondaryMetricsCopyWithImpl<_SecondaryMetrics>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SecondaryMetricsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SecondaryMetrics&&(identical(other.actual, actual) || other.actual == actual)&&(identical(other.anterior, anterior) || other.anterior == anterior));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,actual,anterior);

@override
String toString() {
  return 'SecondaryMetrics(actual: $actual, anterior: $anterior)';
}


}

/// @nodoc
abstract mixin class _$SecondaryMetricsCopyWith<$Res> implements $SecondaryMetricsCopyWith<$Res> {
  factory _$SecondaryMetricsCopyWith(_SecondaryMetrics value, $Res Function(_SecondaryMetrics) _then) = __$SecondaryMetricsCopyWithImpl;
@override @useResult
$Res call({
 SecondaryMetricValues? actual, SecondaryMetricValues? anterior
});


@override $SecondaryMetricValuesCopyWith<$Res>? get actual;@override $SecondaryMetricValuesCopyWith<$Res>? get anterior;

}
/// @nodoc
class __$SecondaryMetricsCopyWithImpl<$Res>
    implements _$SecondaryMetricsCopyWith<$Res> {
  __$SecondaryMetricsCopyWithImpl(this._self, this._then);

  final _SecondaryMetrics _self;
  final $Res Function(_SecondaryMetrics) _then;

/// Create a copy of SecondaryMetrics
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? actual = freezed,Object? anterior = freezed,}) {
  return _then(_SecondaryMetrics(
actual: freezed == actual ? _self.actual : actual // ignore: cast_nullable_to_non_nullable
as SecondaryMetricValues?,anterior: freezed == anterior ? _self.anterior : anterior // ignore: cast_nullable_to_non_nullable
as SecondaryMetricValues?,
  ));
}

/// Create a copy of SecondaryMetrics
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SecondaryMetricValuesCopyWith<$Res>? get actual {
    if (_self.actual == null) {
    return null;
  }

  return $SecondaryMetricValuesCopyWith<$Res>(_self.actual!, (value) {
    return _then(_self.copyWith(actual: value));
  });
}/// Create a copy of SecondaryMetrics
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SecondaryMetricValuesCopyWith<$Res>? get anterior {
    if (_self.anterior == null) {
    return null;
  }

  return $SecondaryMetricValuesCopyWith<$Res>(_self.anterior!, (value) {
    return _then(_self.copyWith(anterior: value));
  });
}
}


/// @nodoc
mixin _$SecondaryMetricValues {

@JsonKey(name: 'deficit_hidrico') num? get deficitHidrico;@JsonKey(name: 'vo2_max') num? get vo2Max;
/// Create a copy of SecondaryMetricValues
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SecondaryMetricValuesCopyWith<SecondaryMetricValues> get copyWith => _$SecondaryMetricValuesCopyWithImpl<SecondaryMetricValues>(this as SecondaryMetricValues, _$identity);

  /// Serializes this SecondaryMetricValues to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SecondaryMetricValues&&(identical(other.deficitHidrico, deficitHidrico) || other.deficitHidrico == deficitHidrico)&&(identical(other.vo2Max, vo2Max) || other.vo2Max == vo2Max));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,deficitHidrico,vo2Max);

@override
String toString() {
  return 'SecondaryMetricValues(deficitHidrico: $deficitHidrico, vo2Max: $vo2Max)';
}


}

/// @nodoc
abstract mixin class $SecondaryMetricValuesCopyWith<$Res>  {
  factory $SecondaryMetricValuesCopyWith(SecondaryMetricValues value, $Res Function(SecondaryMetricValues) _then) = _$SecondaryMetricValuesCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'deficit_hidrico') num? deficitHidrico,@JsonKey(name: 'vo2_max') num? vo2Max
});




}
/// @nodoc
class _$SecondaryMetricValuesCopyWithImpl<$Res>
    implements $SecondaryMetricValuesCopyWith<$Res> {
  _$SecondaryMetricValuesCopyWithImpl(this._self, this._then);

  final SecondaryMetricValues _self;
  final $Res Function(SecondaryMetricValues) _then;

/// Create a copy of SecondaryMetricValues
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? deficitHidrico = freezed,Object? vo2Max = freezed,}) {
  return _then(SecondaryMetricValues(
deficitHidrico: freezed == deficitHidrico ? _self.deficitHidrico : deficitHidrico // ignore: cast_nullable_to_non_nullable
as num?,vo2Max: freezed == vo2Max ? _self.vo2Max : vo2Max // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}

}


/// Adds pattern-matching-related methods to [SecondaryMetricValues].
extension SecondaryMetricValuesPatterns on SecondaryMetricValues {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SecondaryMetricValues value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SecondaryMetricValues() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SecondaryMetricValues value)  $default,){
final _that = this;
switch (_that) {
case _SecondaryMetricValues():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SecondaryMetricValues value)?  $default,){
final _that = this;
switch (_that) {
case _SecondaryMetricValues() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'deficit_hidrico')  num? deficitHidrico, @JsonKey(name: 'vo2_max')  num? vo2Max)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SecondaryMetricValues() when $default != null:
return $default(_that.deficitHidrico,_that.vo2Max);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'deficit_hidrico')  num? deficitHidrico, @JsonKey(name: 'vo2_max')  num? vo2Max)  $default,) {final _that = this;
switch (_that) {
case _SecondaryMetricValues():
return $default(_that.deficitHidrico,_that.vo2Max);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'deficit_hidrico')  num? deficitHidrico, @JsonKey(name: 'vo2_max')  num? vo2Max)?  $default,) {final _that = this;
switch (_that) {
case _SecondaryMetricValues() when $default != null:
return $default(_that.deficitHidrico,_that.vo2Max);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SecondaryMetricValues implements SecondaryMetricValues {
  const _SecondaryMetricValues({@JsonKey(name: 'deficit_hidrico') this.deficitHidrico, @JsonKey(name: 'vo2_max') this.vo2Max});
  factory _SecondaryMetricValues.fromJson(Map<String, dynamic> json) => _$SecondaryMetricValuesFromJson(json);

@override@JsonKey(name: 'deficit_hidrico') final  num? deficitHidrico;
@override@JsonKey(name: 'vo2_max') final  num? vo2Max;

/// Create a copy of SecondaryMetricValues
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SecondaryMetricValuesCopyWith<_SecondaryMetricValues> get copyWith => __$SecondaryMetricValuesCopyWithImpl<_SecondaryMetricValues>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SecondaryMetricValuesToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SecondaryMetricValues&&(identical(other.deficitHidrico, deficitHidrico) || other.deficitHidrico == deficitHidrico)&&(identical(other.vo2Max, vo2Max) || other.vo2Max == vo2Max));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,deficitHidrico,vo2Max);

@override
String toString() {
  return 'SecondaryMetricValues(deficitHidrico: $deficitHidrico, vo2Max: $vo2Max)';
}


}

/// @nodoc
abstract mixin class _$SecondaryMetricValuesCopyWith<$Res> implements $SecondaryMetricValuesCopyWith<$Res> {
  factory _$SecondaryMetricValuesCopyWith(_SecondaryMetricValues value, $Res Function(_SecondaryMetricValues) _then) = __$SecondaryMetricValuesCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'deficit_hidrico') num? deficitHidrico,@JsonKey(name: 'vo2_max') num? vo2Max
});




}
/// @nodoc
class __$SecondaryMetricValuesCopyWithImpl<$Res>
    implements _$SecondaryMetricValuesCopyWith<$Res> {
  __$SecondaryMetricValuesCopyWithImpl(this._self, this._then);

  final _SecondaryMetricValues _self;
  final $Res Function(_SecondaryMetricValues) _then;

/// Create a copy of SecondaryMetricValues
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? deficitHidrico = freezed,Object? vo2Max = freezed,}) {
  return _then(_SecondaryMetricValues(
deficitHidrico: freezed == deficitHidrico ? _self.deficitHidrico : deficitHidrico // ignore: cast_nullable_to_non_nullable
as num?,vo2Max: freezed == vo2Max ? _self.vo2Max : vo2Max // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}


}


/// @nodoc
mixin _$WellnessIndexEvolution {

 String? get fecha;@JsonKey(name: 'semana_actual') num? get semanaActual; num? get puntaje;
/// Create a copy of WellnessIndexEvolution
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WellnessIndexEvolutionCopyWith<WellnessIndexEvolution> get copyWith => _$WellnessIndexEvolutionCopyWithImpl<WellnessIndexEvolution>(this as WellnessIndexEvolution, _$identity);

  /// Serializes this WellnessIndexEvolution to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WellnessIndexEvolution&&(identical(other.fecha, fecha) || other.fecha == fecha)&&(identical(other.semanaActual, semanaActual) || other.semanaActual == semanaActual)&&(identical(other.puntaje, puntaje) || other.puntaje == puntaje));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fecha,semanaActual,puntaje);

@override
String toString() {
  return 'WellnessIndexEvolution(fecha: $fecha, semanaActual: $semanaActual, puntaje: $puntaje)';
}


}

/// @nodoc
abstract mixin class $WellnessIndexEvolutionCopyWith<$Res>  {
  factory $WellnessIndexEvolutionCopyWith(WellnessIndexEvolution value, $Res Function(WellnessIndexEvolution) _then) = _$WellnessIndexEvolutionCopyWithImpl;
@useResult
$Res call({
 String? fecha,@JsonKey(name: 'semana_actual') num? semanaActual, num? puntaje
});




}
/// @nodoc
class _$WellnessIndexEvolutionCopyWithImpl<$Res>
    implements $WellnessIndexEvolutionCopyWith<$Res> {
  _$WellnessIndexEvolutionCopyWithImpl(this._self, this._then);

  final WellnessIndexEvolution _self;
  final $Res Function(WellnessIndexEvolution) _then;

/// Create a copy of WellnessIndexEvolution
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fecha = freezed,Object? semanaActual = freezed,Object? puntaje = freezed,}) {
  return _then(WellnessIndexEvolution(
fecha: freezed == fecha ? _self.fecha : fecha // ignore: cast_nullable_to_non_nullable
as String?,semanaActual: freezed == semanaActual ? _self.semanaActual : semanaActual // ignore: cast_nullable_to_non_nullable
as num?,puntaje: freezed == puntaje ? _self.puntaje : puntaje // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}

}


/// Adds pattern-matching-related methods to [WellnessIndexEvolution].
extension WellnessIndexEvolutionPatterns on WellnessIndexEvolution {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WellnessIndexEvolution value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WellnessIndexEvolution() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WellnessIndexEvolution value)  $default,){
final _that = this;
switch (_that) {
case _WellnessIndexEvolution():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WellnessIndexEvolution value)?  $default,){
final _that = this;
switch (_that) {
case _WellnessIndexEvolution() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? fecha, @JsonKey(name: 'semana_actual')  num? semanaActual,  num? puntaje)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WellnessIndexEvolution() when $default != null:
return $default(_that.fecha,_that.semanaActual,_that.puntaje);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? fecha, @JsonKey(name: 'semana_actual')  num? semanaActual,  num? puntaje)  $default,) {final _that = this;
switch (_that) {
case _WellnessIndexEvolution():
return $default(_that.fecha,_that.semanaActual,_that.puntaje);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? fecha, @JsonKey(name: 'semana_actual')  num? semanaActual,  num? puntaje)?  $default,) {final _that = this;
switch (_that) {
case _WellnessIndexEvolution() when $default != null:
return $default(_that.fecha,_that.semanaActual,_that.puntaje);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WellnessIndexEvolution implements WellnessIndexEvolution {
  const _WellnessIndexEvolution({this.fecha, @JsonKey(name: 'semana_actual') this.semanaActual, this.puntaje});
  factory _WellnessIndexEvolution.fromJson(Map<String, dynamic> json) => _$WellnessIndexEvolutionFromJson(json);

@override final  String? fecha;
@override@JsonKey(name: 'semana_actual') final  num? semanaActual;
@override final  num? puntaje;

/// Create a copy of WellnessIndexEvolution
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WellnessIndexEvolutionCopyWith<_WellnessIndexEvolution> get copyWith => __$WellnessIndexEvolutionCopyWithImpl<_WellnessIndexEvolution>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WellnessIndexEvolutionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WellnessIndexEvolution&&(identical(other.fecha, fecha) || other.fecha == fecha)&&(identical(other.semanaActual, semanaActual) || other.semanaActual == semanaActual)&&(identical(other.puntaje, puntaje) || other.puntaje == puntaje));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fecha,semanaActual,puntaje);

@override
String toString() {
  return 'WellnessIndexEvolution(fecha: $fecha, semanaActual: $semanaActual, puntaje: $puntaje)';
}


}

/// @nodoc
abstract mixin class _$WellnessIndexEvolutionCopyWith<$Res> implements $WellnessIndexEvolutionCopyWith<$Res> {
  factory _$WellnessIndexEvolutionCopyWith(_WellnessIndexEvolution value, $Res Function(_WellnessIndexEvolution) _then) = __$WellnessIndexEvolutionCopyWithImpl;
@override @useResult
$Res call({
 String? fecha,@JsonKey(name: 'semana_actual') num? semanaActual, num? puntaje
});




}
/// @nodoc
class __$WellnessIndexEvolutionCopyWithImpl<$Res>
    implements _$WellnessIndexEvolutionCopyWith<$Res> {
  __$WellnessIndexEvolutionCopyWithImpl(this._self, this._then);

  final _WellnessIndexEvolution _self;
  final $Res Function(_WellnessIndexEvolution) _then;

/// Create a copy of WellnessIndexEvolution
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fecha = freezed,Object? semanaActual = freezed,Object? puntaje = freezed,}) {
  return _then(_WellnessIndexEvolution(
fecha: freezed == fecha ? _self.fecha : fecha // ignore: cast_nullable_to_non_nullable
as String?,semanaActual: freezed == semanaActual ? _self.semanaActual : semanaActual // ignore: cast_nullable_to_non_nullable
as num?,puntaje: freezed == puntaje ? _self.puntaje : puntaje // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}


}


/// @nodoc
mixin _$WeightHistory {

 num? get semana; String? get fecha;@JsonKey(fromJson: _parseNumericOrString) num? get peso;@JsonKey(fromJson: _parseNumericOrString) num? get musculo;@JsonKey(fromJson: _parseNumericOrString) num? get grasa;
/// Create a copy of WeightHistory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeightHistoryCopyWith<WeightHistory> get copyWith => _$WeightHistoryCopyWithImpl<WeightHistory>(this as WeightHistory, _$identity);

  /// Serializes this WeightHistory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeightHistory&&(identical(other.semana, semana) || other.semana == semana)&&(identical(other.fecha, fecha) || other.fecha == fecha)&&(identical(other.peso, peso) || other.peso == peso)&&(identical(other.musculo, musculo) || other.musculo == musculo)&&(identical(other.grasa, grasa) || other.grasa == grasa));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,semana,fecha,peso,musculo,grasa);

@override
String toString() {
  return 'WeightHistory(semana: $semana, fecha: $fecha, peso: $peso, musculo: $musculo, grasa: $grasa)';
}


}

/// @nodoc
abstract mixin class $WeightHistoryCopyWith<$Res>  {
  factory $WeightHistoryCopyWith(WeightHistory value, $Res Function(WeightHistory) _then) = _$WeightHistoryCopyWithImpl;
@useResult
$Res call({
 num? semana, String? fecha,@JsonKey(fromJson: _parseNumericOrString) num? peso,@JsonKey(fromJson: _parseNumericOrString) num? musculo,@JsonKey(fromJson: _parseNumericOrString) num? grasa
});




}
/// @nodoc
class _$WeightHistoryCopyWithImpl<$Res>
    implements $WeightHistoryCopyWith<$Res> {
  _$WeightHistoryCopyWithImpl(this._self, this._then);

  final WeightHistory _self;
  final $Res Function(WeightHistory) _then;

/// Create a copy of WeightHistory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? semana = freezed,Object? fecha = freezed,Object? peso = freezed,Object? musculo = freezed,Object? grasa = freezed,}) {
  return _then(WeightHistory(
semana: freezed == semana ? _self.semana : semana // ignore: cast_nullable_to_non_nullable
as num?,fecha: freezed == fecha ? _self.fecha : fecha // ignore: cast_nullable_to_non_nullable
as String?,peso: freezed == peso ? _self.peso : peso // ignore: cast_nullable_to_non_nullable
as num?,musculo: freezed == musculo ? _self.musculo : musculo // ignore: cast_nullable_to_non_nullable
as num?,grasa: freezed == grasa ? _self.grasa : grasa // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}

}


/// Adds pattern-matching-related methods to [WeightHistory].
extension WeightHistoryPatterns on WeightHistory {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeightHistory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeightHistory() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeightHistory value)  $default,){
final _that = this;
switch (_that) {
case _WeightHistory():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeightHistory value)?  $default,){
final _that = this;
switch (_that) {
case _WeightHistory() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( num? semana,  String? fecha, @JsonKey(fromJson: _parseNumericOrString)  num? peso, @JsonKey(fromJson: _parseNumericOrString)  num? musculo, @JsonKey(fromJson: _parseNumericOrString)  num? grasa)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeightHistory() when $default != null:
return $default(_that.semana,_that.fecha,_that.peso,_that.musculo,_that.grasa);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( num? semana,  String? fecha, @JsonKey(fromJson: _parseNumericOrString)  num? peso, @JsonKey(fromJson: _parseNumericOrString)  num? musculo, @JsonKey(fromJson: _parseNumericOrString)  num? grasa)  $default,) {final _that = this;
switch (_that) {
case _WeightHistory():
return $default(_that.semana,_that.fecha,_that.peso,_that.musculo,_that.grasa);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( num? semana,  String? fecha, @JsonKey(fromJson: _parseNumericOrString)  num? peso, @JsonKey(fromJson: _parseNumericOrString)  num? musculo, @JsonKey(fromJson: _parseNumericOrString)  num? grasa)?  $default,) {final _that = this;
switch (_that) {
case _WeightHistory() when $default != null:
return $default(_that.semana,_that.fecha,_that.peso,_that.musculo,_that.grasa);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WeightHistory implements WeightHistory {
  const _WeightHistory({this.semana, this.fecha, @JsonKey(fromJson: _parseNumericOrString) this.peso, @JsonKey(fromJson: _parseNumericOrString) this.musculo, @JsonKey(fromJson: _parseNumericOrString) this.grasa});
  factory _WeightHistory.fromJson(Map<String, dynamic> json) => _$WeightHistoryFromJson(json);

@override final  num? semana;
@override final  String? fecha;
@override@JsonKey(fromJson: _parseNumericOrString) final  num? peso;
@override@JsonKey(fromJson: _parseNumericOrString) final  num? musculo;
@override@JsonKey(fromJson: _parseNumericOrString) final  num? grasa;

/// Create a copy of WeightHistory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeightHistoryCopyWith<_WeightHistory> get copyWith => __$WeightHistoryCopyWithImpl<_WeightHistory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WeightHistoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeightHistory&&(identical(other.semana, semana) || other.semana == semana)&&(identical(other.fecha, fecha) || other.fecha == fecha)&&(identical(other.peso, peso) || other.peso == peso)&&(identical(other.musculo, musculo) || other.musculo == musculo)&&(identical(other.grasa, grasa) || other.grasa == grasa));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,semana,fecha,peso,musculo,grasa);

@override
String toString() {
  return 'WeightHistory(semana: $semana, fecha: $fecha, peso: $peso, musculo: $musculo, grasa: $grasa)';
}


}

/// @nodoc
abstract mixin class _$WeightHistoryCopyWith<$Res> implements $WeightHistoryCopyWith<$Res> {
  factory _$WeightHistoryCopyWith(_WeightHistory value, $Res Function(_WeightHistory) _then) = __$WeightHistoryCopyWithImpl;
@override @useResult
$Res call({
 num? semana, String? fecha,@JsonKey(fromJson: _parseNumericOrString) num? peso,@JsonKey(fromJson: _parseNumericOrString) num? musculo,@JsonKey(fromJson: _parseNumericOrString) num? grasa
});




}
/// @nodoc
class __$WeightHistoryCopyWithImpl<$Res>
    implements _$WeightHistoryCopyWith<$Res> {
  __$WeightHistoryCopyWithImpl(this._self, this._then);

  final _WeightHistory _self;
  final $Res Function(_WeightHistory) _then;

/// Create a copy of WeightHistory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? semana = freezed,Object? fecha = freezed,Object? peso = freezed,Object? musculo = freezed,Object? grasa = freezed,}) {
  return _then(_WeightHistory(
semana: freezed == semana ? _self.semana : semana // ignore: cast_nullable_to_non_nullable
as num?,fecha: freezed == fecha ? _self.fecha : fecha // ignore: cast_nullable_to_non_nullable
as String?,peso: freezed == peso ? _self.peso : peso // ignore: cast_nullable_to_non_nullable
as num?,musculo: freezed == musculo ? _self.musculo : musculo // ignore: cast_nullable_to_non_nullable
as num?,grasa: freezed == grasa ? _self.grasa : grasa // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}


}


/// @nodoc
mixin _$CaloriasDetail {

@JsonKey(name: 'calorias_act') num? get caloriasAct;@JsonKey(name: 'calorias_ant') num? get caloriasAnt; num? get diferencia;
/// Create a copy of CaloriasDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CaloriasDetailCopyWith<CaloriasDetail> get copyWith => _$CaloriasDetailCopyWithImpl<CaloriasDetail>(this as CaloriasDetail, _$identity);

  /// Serializes this CaloriasDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CaloriasDetail&&(identical(other.caloriasAct, caloriasAct) || other.caloriasAct == caloriasAct)&&(identical(other.caloriasAnt, caloriasAnt) || other.caloriasAnt == caloriasAnt)&&(identical(other.diferencia, diferencia) || other.diferencia == diferencia));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,caloriasAct,caloriasAnt,diferencia);

@override
String toString() {
  return 'CaloriasDetail(caloriasAct: $caloriasAct, caloriasAnt: $caloriasAnt, diferencia: $diferencia)';
}


}

/// @nodoc
abstract mixin class $CaloriasDetailCopyWith<$Res>  {
  factory $CaloriasDetailCopyWith(CaloriasDetail value, $Res Function(CaloriasDetail) _then) = _$CaloriasDetailCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'calorias_act') num? caloriasAct,@JsonKey(name: 'calorias_ant') num? caloriasAnt, num? diferencia
});




}
/// @nodoc
class _$CaloriasDetailCopyWithImpl<$Res>
    implements $CaloriasDetailCopyWith<$Res> {
  _$CaloriasDetailCopyWithImpl(this._self, this._then);

  final CaloriasDetail _self;
  final $Res Function(CaloriasDetail) _then;

/// Create a copy of CaloriasDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? caloriasAct = freezed,Object? caloriasAnt = freezed,Object? diferencia = freezed,}) {
  return _then(CaloriasDetail(
caloriasAct: freezed == caloriasAct ? _self.caloriasAct : caloriasAct // ignore: cast_nullable_to_non_nullable
as num?,caloriasAnt: freezed == caloriasAnt ? _self.caloriasAnt : caloriasAnt // ignore: cast_nullable_to_non_nullable
as num?,diferencia: freezed == diferencia ? _self.diferencia : diferencia // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}

}


/// Adds pattern-matching-related methods to [CaloriasDetail].
extension CaloriasDetailPatterns on CaloriasDetail {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CaloriasDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CaloriasDetail() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CaloriasDetail value)  $default,){
final _that = this;
switch (_that) {
case _CaloriasDetail():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CaloriasDetail value)?  $default,){
final _that = this;
switch (_that) {
case _CaloriasDetail() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'calorias_act')  num? caloriasAct, @JsonKey(name: 'calorias_ant')  num? caloriasAnt,  num? diferencia)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CaloriasDetail() when $default != null:
return $default(_that.caloriasAct,_that.caloriasAnt,_that.diferencia);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'calorias_act')  num? caloriasAct, @JsonKey(name: 'calorias_ant')  num? caloriasAnt,  num? diferencia)  $default,) {final _that = this;
switch (_that) {
case _CaloriasDetail():
return $default(_that.caloriasAct,_that.caloriasAnt,_that.diferencia);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'calorias_act')  num? caloriasAct, @JsonKey(name: 'calorias_ant')  num? caloriasAnt,  num? diferencia)?  $default,) {final _that = this;
switch (_that) {
case _CaloriasDetail() when $default != null:
return $default(_that.caloriasAct,_that.caloriasAnt,_that.diferencia);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CaloriasDetail implements CaloriasDetail {
  const _CaloriasDetail({@JsonKey(name: 'calorias_act') this.caloriasAct, @JsonKey(name: 'calorias_ant') this.caloriasAnt, this.diferencia});
  factory _CaloriasDetail.fromJson(Map<String, dynamic> json) => _$CaloriasDetailFromJson(json);

@override@JsonKey(name: 'calorias_act') final  num? caloriasAct;
@override@JsonKey(name: 'calorias_ant') final  num? caloriasAnt;
@override final  num? diferencia;

/// Create a copy of CaloriasDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CaloriasDetailCopyWith<_CaloriasDetail> get copyWith => __$CaloriasDetailCopyWithImpl<_CaloriasDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CaloriasDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CaloriasDetail&&(identical(other.caloriasAct, caloriasAct) || other.caloriasAct == caloriasAct)&&(identical(other.caloriasAnt, caloriasAnt) || other.caloriasAnt == caloriasAnt)&&(identical(other.diferencia, diferencia) || other.diferencia == diferencia));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,caloriasAct,caloriasAnt,diferencia);

@override
String toString() {
  return 'CaloriasDetail(caloriasAct: $caloriasAct, caloriasAnt: $caloriasAnt, diferencia: $diferencia)';
}


}

/// @nodoc
abstract mixin class _$CaloriasDetailCopyWith<$Res> implements $CaloriasDetailCopyWith<$Res> {
  factory _$CaloriasDetailCopyWith(_CaloriasDetail value, $Res Function(_CaloriasDetail) _then) = __$CaloriasDetailCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'calorias_act') num? caloriasAct,@JsonKey(name: 'calorias_ant') num? caloriasAnt, num? diferencia
});




}
/// @nodoc
class __$CaloriasDetailCopyWithImpl<$Res>
    implements _$CaloriasDetailCopyWith<$Res> {
  __$CaloriasDetailCopyWithImpl(this._self, this._then);

  final _CaloriasDetail _self;
  final $Res Function(_CaloriasDetail) _then;

/// Create a copy of CaloriasDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? caloriasAct = freezed,Object? caloriasAnt = freezed,Object? diferencia = freezed,}) {
  return _then(_CaloriasDetail(
caloriasAct: freezed == caloriasAct ? _self.caloriasAct : caloriasAct // ignore: cast_nullable_to_non_nullable
as num?,caloriasAnt: freezed == caloriasAnt ? _self.caloriasAnt : caloriasAnt // ignore: cast_nullable_to_non_nullable
as num?,diferencia: freezed == diferencia ? _self.diferencia : diferencia // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}


}

// dart format on
