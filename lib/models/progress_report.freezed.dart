// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'progress_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProgressReport _$ProgressReportFromJson(Map<String, dynamic> json) {
  return _ProgressReport.fromJson(json);
}

/// @nodoc
mixin _$ProgressReport {
  @JsonKey(name: 'id_reporte_semanal')
  String? get idReporteSemanal => throw _privateConstructorUsedError;
  @JsonKey(name: 'semana_info')
  String? get semanaInfo => throw _privateConstructorUsedError;
  @JsonKey(name: 'fecha_inicio')
  String? get fechaInicio => throw _privateConstructorUsedError;
  @JsonKey(name: 'fecha_fin')
  String? get fechaFin => throw _privateConstructorUsedError;
  String? get actualizado => throw _privateConstructorUsedError;
  Alert? get alertas => throw _privateConstructorUsedError;
  @JsonKey(name: 'mensaje_ia')
  String? get mensajeIa => throw _privateConstructorUsedError;
  @JsonKey(name: 'indice_bienestar')
  num? get indiceBienestar => throw _privateConstructorUsedError;
  @JsonKey(name: 'variacion_indice_bienestar')
  num? get variacionIndiceBienestar => throw _privateConstructorUsedError;
  @JsonKey(name: 'detalle_factor_movimiento')
  GeneralFactorDetail? get detalleFactorMovement =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'detalle_factor_hidratacion')
  FactorHidratacionDetail? get detalleFactorHidratacion =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'detalle_factor_edad_corporal')
  GeneralFactorDetail? get detalleFactorEdadCorporal =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'detalle_factor_carga_muscular')
  GeneralFactorDetail? get detalleFactorCargaMuscular =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'detalle_factor_peso_composicion')
  FactorWeightDetail? get detalleFactorPesoComposicion =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'evolucion_indice_bienestar')
  List<WellnessIndexEvolution> get evolucionIndiceBienestar =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'historial_peso')
  List<WeightHistory> get historialPeso => throw _privateConstructorUsedError;
  @JsonKey(name: 'metricas_secundarias')
  SecondaryMetrics? get metricasSecundarias =>
      throw _privateConstructorUsedError;
  CurrentPreviousValue? get grasa => throw _privateConstructorUsedError;
  CurrentPreviousValue? get musculos => throw _privateConstructorUsedError;
  CaloriasDetail? get calorias => throw _privateConstructorUsedError;
  @JsonKey(name: 'tiempo_activo')
  ActiveTimeDetail? get tiempoActivo => throw _privateConstructorUsedError;
  @JsonKey(name: 'zonas_esfuerzo')
  ZonasEsfuerzo? get zonasEsfuerzo => throw _privateConstructorUsedError;

  /// Serializes this ProgressReport to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProgressReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProgressReportCopyWith<ProgressReport> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProgressReportCopyWith<$Res> {
  factory $ProgressReportCopyWith(
    ProgressReport value,
    $Res Function(ProgressReport) then,
  ) = _$ProgressReportCopyWithImpl<$Res, ProgressReport>;
  @useResult
  $Res call({
    @JsonKey(name: 'id_reporte_semanal') String? idReporteSemanal,
    @JsonKey(name: 'semana_info') String? semanaInfo,
    @JsonKey(name: 'fecha_inicio') String? fechaInicio,
    @JsonKey(name: 'fecha_fin') String? fechaFin,
    String? actualizado,
    Alert? alertas,
    @JsonKey(name: 'mensaje_ia') String? mensajeIa,
    @JsonKey(name: 'indice_bienestar') num? indiceBienestar,
    @JsonKey(name: 'variacion_indice_bienestar') num? variacionIndiceBienestar,
    @JsonKey(name: 'detalle_factor_movimiento')
    GeneralFactorDetail? detalleFactorMovement,
    @JsonKey(name: 'detalle_factor_hidratacion')
    FactorHidratacionDetail? detalleFactorHidratacion,
    @JsonKey(name: 'detalle_factor_edad_corporal')
    GeneralFactorDetail? detalleFactorEdadCorporal,
    @JsonKey(name: 'detalle_factor_carga_muscular')
    GeneralFactorDetail? detalleFactorCargaMuscular,
    @JsonKey(name: 'detalle_factor_peso_composicion')
    FactorWeightDetail? detalleFactorPesoComposicion,
    @JsonKey(name: 'evolucion_indice_bienestar')
    List<WellnessIndexEvolution> evolucionIndiceBienestar,
    @JsonKey(name: 'historial_peso') List<WeightHistory> historialPeso,
    @JsonKey(name: 'metricas_secundarias')
    SecondaryMetrics? metricasSecundarias,
    CurrentPreviousValue? grasa,
    CurrentPreviousValue? musculos,
    CaloriasDetail? calorias,
    @JsonKey(name: 'tiempo_activo') ActiveTimeDetail? tiempoActivo,
    @JsonKey(name: 'zonas_esfuerzo') ZonasEsfuerzo? zonasEsfuerzo,
  });

  $AlertCopyWith<$Res>? get alertas;
  $GeneralFactorDetailCopyWith<$Res>? get detalleFactorMovement;
  $FactorHidratacionDetailCopyWith<$Res>? get detalleFactorHidratacion;
  $GeneralFactorDetailCopyWith<$Res>? get detalleFactorEdadCorporal;
  $GeneralFactorDetailCopyWith<$Res>? get detalleFactorCargaMuscular;
  $FactorWeightDetailCopyWith<$Res>? get detalleFactorPesoComposicion;
  $SecondaryMetricsCopyWith<$Res>? get metricasSecundarias;
  $CurrentPreviousValueCopyWith<$Res>? get grasa;
  $CurrentPreviousValueCopyWith<$Res>? get musculos;
  $CaloriasDetailCopyWith<$Res>? get calorias;
  $ActiveTimeDetailCopyWith<$Res>? get tiempoActivo;
  $ZonasEsfuerzoCopyWith<$Res>? get zonasEsfuerzo;
}

/// @nodoc
class _$ProgressReportCopyWithImpl<$Res, $Val extends ProgressReport>
    implements $ProgressReportCopyWith<$Res> {
  _$ProgressReportCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProgressReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idReporteSemanal = freezed,
    Object? semanaInfo = freezed,
    Object? fechaInicio = freezed,
    Object? fechaFin = freezed,
    Object? actualizado = freezed,
    Object? alertas = freezed,
    Object? mensajeIa = freezed,
    Object? indiceBienestar = freezed,
    Object? variacionIndiceBienestar = freezed,
    Object? detalleFactorMovement = freezed,
    Object? detalleFactorHidratacion = freezed,
    Object? detalleFactorEdadCorporal = freezed,
    Object? detalleFactorCargaMuscular = freezed,
    Object? detalleFactorPesoComposicion = freezed,
    Object? evolucionIndiceBienestar = null,
    Object? historialPeso = null,
    Object? metricasSecundarias = freezed,
    Object? grasa = freezed,
    Object? musculos = freezed,
    Object? calorias = freezed,
    Object? tiempoActivo = freezed,
    Object? zonasEsfuerzo = freezed,
  }) {
    return _then(
      _value.copyWith(
            idReporteSemanal: freezed == idReporteSemanal
                ? _value.idReporteSemanal
                : idReporteSemanal // ignore: cast_nullable_to_non_nullable
                      as String?,
            semanaInfo: freezed == semanaInfo
                ? _value.semanaInfo
                : semanaInfo // ignore: cast_nullable_to_non_nullable
                      as String?,
            fechaInicio: freezed == fechaInicio
                ? _value.fechaInicio
                : fechaInicio // ignore: cast_nullable_to_non_nullable
                      as String?,
            fechaFin: freezed == fechaFin
                ? _value.fechaFin
                : fechaFin // ignore: cast_nullable_to_non_nullable
                      as String?,
            actualizado: freezed == actualizado
                ? _value.actualizado
                : actualizado // ignore: cast_nullable_to_non_nullable
                      as String?,
            alertas: freezed == alertas
                ? _value.alertas
                : alertas // ignore: cast_nullable_to_non_nullable
                      as Alert?,
            mensajeIa: freezed == mensajeIa
                ? _value.mensajeIa
                : mensajeIa // ignore: cast_nullable_to_non_nullable
                      as String?,
            indiceBienestar: freezed == indiceBienestar
                ? _value.indiceBienestar
                : indiceBienestar // ignore: cast_nullable_to_non_nullable
                      as num?,
            variacionIndiceBienestar: freezed == variacionIndiceBienestar
                ? _value.variacionIndiceBienestar
                : variacionIndiceBienestar // ignore: cast_nullable_to_non_nullable
                      as num?,
            detalleFactorMovement: freezed == detalleFactorMovement
                ? _value.detalleFactorMovement
                : detalleFactorMovement // ignore: cast_nullable_to_non_nullable
                      as GeneralFactorDetail?,
            detalleFactorHidratacion: freezed == detalleFactorHidratacion
                ? _value.detalleFactorHidratacion
                : detalleFactorHidratacion // ignore: cast_nullable_to_non_nullable
                      as FactorHidratacionDetail?,
            detalleFactorEdadCorporal: freezed == detalleFactorEdadCorporal
                ? _value.detalleFactorEdadCorporal
                : detalleFactorEdadCorporal // ignore: cast_nullable_to_non_nullable
                      as GeneralFactorDetail?,
            detalleFactorCargaMuscular: freezed == detalleFactorCargaMuscular
                ? _value.detalleFactorCargaMuscular
                : detalleFactorCargaMuscular // ignore: cast_nullable_to_non_nullable
                      as GeneralFactorDetail?,
            detalleFactorPesoComposicion:
                freezed == detalleFactorPesoComposicion
                ? _value.detalleFactorPesoComposicion
                : detalleFactorPesoComposicion // ignore: cast_nullable_to_non_nullable
                      as FactorWeightDetail?,
            evolucionIndiceBienestar: null == evolucionIndiceBienestar
                ? _value.evolucionIndiceBienestar
                : evolucionIndiceBienestar // ignore: cast_nullable_to_non_nullable
                      as List<WellnessIndexEvolution>,
            historialPeso: null == historialPeso
                ? _value.historialPeso
                : historialPeso // ignore: cast_nullable_to_non_nullable
                      as List<WeightHistory>,
            metricasSecundarias: freezed == metricasSecundarias
                ? _value.metricasSecundarias
                : metricasSecundarias // ignore: cast_nullable_to_non_nullable
                      as SecondaryMetrics?,
            grasa: freezed == grasa
                ? _value.grasa
                : grasa // ignore: cast_nullable_to_non_nullable
                      as CurrentPreviousValue?,
            musculos: freezed == musculos
                ? _value.musculos
                : musculos // ignore: cast_nullable_to_non_nullable
                      as CurrentPreviousValue?,
            calorias: freezed == calorias
                ? _value.calorias
                : calorias // ignore: cast_nullable_to_non_nullable
                      as CaloriasDetail?,
            tiempoActivo: freezed == tiempoActivo
                ? _value.tiempoActivo
                : tiempoActivo // ignore: cast_nullable_to_non_nullable
                      as ActiveTimeDetail?,
            zonasEsfuerzo: freezed == zonasEsfuerzo
                ? _value.zonasEsfuerzo
                : zonasEsfuerzo // ignore: cast_nullable_to_non_nullable
                      as ZonasEsfuerzo?,
          )
          as $Val,
    );
  }

  /// Create a copy of ProgressReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AlertCopyWith<$Res>? get alertas {
    if (_value.alertas == null) {
      return null;
    }

    return $AlertCopyWith<$Res>(_value.alertas!, (value) {
      return _then(_value.copyWith(alertas: value) as $Val);
    });
  }

  /// Create a copy of ProgressReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GeneralFactorDetailCopyWith<$Res>? get detalleFactorMovement {
    if (_value.detalleFactorMovement == null) {
      return null;
    }

    return $GeneralFactorDetailCopyWith<$Res>(_value.detalleFactorMovement!, (
      value,
    ) {
      return _then(_value.copyWith(detalleFactorMovement: value) as $Val);
    });
  }

  /// Create a copy of ProgressReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FactorHidratacionDetailCopyWith<$Res>? get detalleFactorHidratacion {
    if (_value.detalleFactorHidratacion == null) {
      return null;
    }

    return $FactorHidratacionDetailCopyWith<$Res>(
      _value.detalleFactorHidratacion!,
      (value) {
        return _then(_value.copyWith(detalleFactorHidratacion: value) as $Val);
      },
    );
  }

  /// Create a copy of ProgressReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GeneralFactorDetailCopyWith<$Res>? get detalleFactorEdadCorporal {
    if (_value.detalleFactorEdadCorporal == null) {
      return null;
    }

    return $GeneralFactorDetailCopyWith<$Res>(
      _value.detalleFactorEdadCorporal!,
      (value) {
        return _then(_value.copyWith(detalleFactorEdadCorporal: value) as $Val);
      },
    );
  }

  /// Create a copy of ProgressReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GeneralFactorDetailCopyWith<$Res>? get detalleFactorCargaMuscular {
    if (_value.detalleFactorCargaMuscular == null) {
      return null;
    }

    return $GeneralFactorDetailCopyWith<$Res>(
      _value.detalleFactorCargaMuscular!,
      (value) {
        return _then(
          _value.copyWith(detalleFactorCargaMuscular: value) as $Val,
        );
      },
    );
  }

  /// Create a copy of ProgressReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FactorWeightDetailCopyWith<$Res>? get detalleFactorPesoComposicion {
    if (_value.detalleFactorPesoComposicion == null) {
      return null;
    }

    return $FactorWeightDetailCopyWith<$Res>(
      _value.detalleFactorPesoComposicion!,
      (value) {
        return _then(
          _value.copyWith(detalleFactorPesoComposicion: value) as $Val,
        );
      },
    );
  }

  /// Create a copy of ProgressReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SecondaryMetricsCopyWith<$Res>? get metricasSecundarias {
    if (_value.metricasSecundarias == null) {
      return null;
    }

    return $SecondaryMetricsCopyWith<$Res>(_value.metricasSecundarias!, (
      value,
    ) {
      return _then(_value.copyWith(metricasSecundarias: value) as $Val);
    });
  }

  /// Create a copy of ProgressReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CurrentPreviousValueCopyWith<$Res>? get grasa {
    if (_value.grasa == null) {
      return null;
    }

    return $CurrentPreviousValueCopyWith<$Res>(_value.grasa!, (value) {
      return _then(_value.copyWith(grasa: value) as $Val);
    });
  }

  /// Create a copy of ProgressReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CurrentPreviousValueCopyWith<$Res>? get musculos {
    if (_value.musculos == null) {
      return null;
    }

    return $CurrentPreviousValueCopyWith<$Res>(_value.musculos!, (value) {
      return _then(_value.copyWith(musculos: value) as $Val);
    });
  }

  /// Create a copy of ProgressReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CaloriasDetailCopyWith<$Res>? get calorias {
    if (_value.calorias == null) {
      return null;
    }

    return $CaloriasDetailCopyWith<$Res>(_value.calorias!, (value) {
      return _then(_value.copyWith(calorias: value) as $Val);
    });
  }

  /// Create a copy of ProgressReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ActiveTimeDetailCopyWith<$Res>? get tiempoActivo {
    if (_value.tiempoActivo == null) {
      return null;
    }

    return $ActiveTimeDetailCopyWith<$Res>(_value.tiempoActivo!, (value) {
      return _then(_value.copyWith(tiempoActivo: value) as $Val);
    });
  }

  /// Create a copy of ProgressReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ZonasEsfuerzoCopyWith<$Res>? get zonasEsfuerzo {
    if (_value.zonasEsfuerzo == null) {
      return null;
    }

    return $ZonasEsfuerzoCopyWith<$Res>(_value.zonasEsfuerzo!, (value) {
      return _then(_value.copyWith(zonasEsfuerzo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ProgressReportImplCopyWith<$Res>
    implements $ProgressReportCopyWith<$Res> {
  factory _$$ProgressReportImplCopyWith(
    _$ProgressReportImpl value,
    $Res Function(_$ProgressReportImpl) then,
  ) = __$$ProgressReportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'id_reporte_semanal') String? idReporteSemanal,
    @JsonKey(name: 'semana_info') String? semanaInfo,
    @JsonKey(name: 'fecha_inicio') String? fechaInicio,
    @JsonKey(name: 'fecha_fin') String? fechaFin,
    String? actualizado,
    Alert? alertas,
    @JsonKey(name: 'mensaje_ia') String? mensajeIa,
    @JsonKey(name: 'indice_bienestar') num? indiceBienestar,
    @JsonKey(name: 'variacion_indice_bienestar') num? variacionIndiceBienestar,
    @JsonKey(name: 'detalle_factor_movimiento')
    GeneralFactorDetail? detalleFactorMovement,
    @JsonKey(name: 'detalle_factor_hidratacion')
    FactorHidratacionDetail? detalleFactorHidratacion,
    @JsonKey(name: 'detalle_factor_edad_corporal')
    GeneralFactorDetail? detalleFactorEdadCorporal,
    @JsonKey(name: 'detalle_factor_carga_muscular')
    GeneralFactorDetail? detalleFactorCargaMuscular,
    @JsonKey(name: 'detalle_factor_peso_composicion')
    FactorWeightDetail? detalleFactorPesoComposicion,
    @JsonKey(name: 'evolucion_indice_bienestar')
    List<WellnessIndexEvolution> evolucionIndiceBienestar,
    @JsonKey(name: 'historial_peso') List<WeightHistory> historialPeso,
    @JsonKey(name: 'metricas_secundarias')
    SecondaryMetrics? metricasSecundarias,
    CurrentPreviousValue? grasa,
    CurrentPreviousValue? musculos,
    CaloriasDetail? calorias,
    @JsonKey(name: 'tiempo_activo') ActiveTimeDetail? tiempoActivo,
    @JsonKey(name: 'zonas_esfuerzo') ZonasEsfuerzo? zonasEsfuerzo,
  });

  @override
  $AlertCopyWith<$Res>? get alertas;
  @override
  $GeneralFactorDetailCopyWith<$Res>? get detalleFactorMovement;
  @override
  $FactorHidratacionDetailCopyWith<$Res>? get detalleFactorHidratacion;
  @override
  $GeneralFactorDetailCopyWith<$Res>? get detalleFactorEdadCorporal;
  @override
  $GeneralFactorDetailCopyWith<$Res>? get detalleFactorCargaMuscular;
  @override
  $FactorWeightDetailCopyWith<$Res>? get detalleFactorPesoComposicion;
  @override
  $SecondaryMetricsCopyWith<$Res>? get metricasSecundarias;
  @override
  $CurrentPreviousValueCopyWith<$Res>? get grasa;
  @override
  $CurrentPreviousValueCopyWith<$Res>? get musculos;
  @override
  $CaloriasDetailCopyWith<$Res>? get calorias;
  @override
  $ActiveTimeDetailCopyWith<$Res>? get tiempoActivo;
  @override
  $ZonasEsfuerzoCopyWith<$Res>? get zonasEsfuerzo;
}

/// @nodoc
class __$$ProgressReportImplCopyWithImpl<$Res>
    extends _$ProgressReportCopyWithImpl<$Res, _$ProgressReportImpl>
    implements _$$ProgressReportImplCopyWith<$Res> {
  __$$ProgressReportImplCopyWithImpl(
    _$ProgressReportImpl _value,
    $Res Function(_$ProgressReportImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProgressReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idReporteSemanal = freezed,
    Object? semanaInfo = freezed,
    Object? fechaInicio = freezed,
    Object? fechaFin = freezed,
    Object? actualizado = freezed,
    Object? alertas = freezed,
    Object? mensajeIa = freezed,
    Object? indiceBienestar = freezed,
    Object? variacionIndiceBienestar = freezed,
    Object? detalleFactorMovement = freezed,
    Object? detalleFactorHidratacion = freezed,
    Object? detalleFactorEdadCorporal = freezed,
    Object? detalleFactorCargaMuscular = freezed,
    Object? detalleFactorPesoComposicion = freezed,
    Object? evolucionIndiceBienestar = null,
    Object? historialPeso = null,
    Object? metricasSecundarias = freezed,
    Object? grasa = freezed,
    Object? musculos = freezed,
    Object? calorias = freezed,
    Object? tiempoActivo = freezed,
    Object? zonasEsfuerzo = freezed,
  }) {
    return _then(
      _$ProgressReportImpl(
        idReporteSemanal: freezed == idReporteSemanal
            ? _value.idReporteSemanal
            : idReporteSemanal // ignore: cast_nullable_to_non_nullable
                  as String?,
        semanaInfo: freezed == semanaInfo
            ? _value.semanaInfo
            : semanaInfo // ignore: cast_nullable_to_non_nullable
                  as String?,
        fechaInicio: freezed == fechaInicio
            ? _value.fechaInicio
            : fechaInicio // ignore: cast_nullable_to_non_nullable
                  as String?,
        fechaFin: freezed == fechaFin
            ? _value.fechaFin
            : fechaFin // ignore: cast_nullable_to_non_nullable
                  as String?,
        actualizado: freezed == actualizado
            ? _value.actualizado
            : actualizado // ignore: cast_nullable_to_non_nullable
                  as String?,
        alertas: freezed == alertas
            ? _value.alertas
            : alertas // ignore: cast_nullable_to_non_nullable
                  as Alert?,
        mensajeIa: freezed == mensajeIa
            ? _value.mensajeIa
            : mensajeIa // ignore: cast_nullable_to_non_nullable
                  as String?,
        indiceBienestar: freezed == indiceBienestar
            ? _value.indiceBienestar
            : indiceBienestar // ignore: cast_nullable_to_non_nullable
                  as num?,
        variacionIndiceBienestar: freezed == variacionIndiceBienestar
            ? _value.variacionIndiceBienestar
            : variacionIndiceBienestar // ignore: cast_nullable_to_non_nullable
                  as num?,
        detalleFactorMovement: freezed == detalleFactorMovement
            ? _value.detalleFactorMovement
            : detalleFactorMovement // ignore: cast_nullable_to_non_nullable
                  as GeneralFactorDetail?,
        detalleFactorHidratacion: freezed == detalleFactorHidratacion
            ? _value.detalleFactorHidratacion
            : detalleFactorHidratacion // ignore: cast_nullable_to_non_nullable
                  as FactorHidratacionDetail?,
        detalleFactorEdadCorporal: freezed == detalleFactorEdadCorporal
            ? _value.detalleFactorEdadCorporal
            : detalleFactorEdadCorporal // ignore: cast_nullable_to_non_nullable
                  as GeneralFactorDetail?,
        detalleFactorCargaMuscular: freezed == detalleFactorCargaMuscular
            ? _value.detalleFactorCargaMuscular
            : detalleFactorCargaMuscular // ignore: cast_nullable_to_non_nullable
                  as GeneralFactorDetail?,
        detalleFactorPesoComposicion: freezed == detalleFactorPesoComposicion
            ? _value.detalleFactorPesoComposicion
            : detalleFactorPesoComposicion // ignore: cast_nullable_to_non_nullable
                  as FactorWeightDetail?,
        evolucionIndiceBienestar: null == evolucionIndiceBienestar
            ? _value._evolucionIndiceBienestar
            : evolucionIndiceBienestar // ignore: cast_nullable_to_non_nullable
                  as List<WellnessIndexEvolution>,
        historialPeso: null == historialPeso
            ? _value._historialPeso
            : historialPeso // ignore: cast_nullable_to_non_nullable
                  as List<WeightHistory>,
        metricasSecundarias: freezed == metricasSecundarias
            ? _value.metricasSecundarias
            : metricasSecundarias // ignore: cast_nullable_to_non_nullable
                  as SecondaryMetrics?,
        grasa: freezed == grasa
            ? _value.grasa
            : grasa // ignore: cast_nullable_to_non_nullable
                  as CurrentPreviousValue?,
        musculos: freezed == musculos
            ? _value.musculos
            : musculos // ignore: cast_nullable_to_non_nullable
                  as CurrentPreviousValue?,
        calorias: freezed == calorias
            ? _value.calorias
            : calorias // ignore: cast_nullable_to_non_nullable
                  as CaloriasDetail?,
        tiempoActivo: freezed == tiempoActivo
            ? _value.tiempoActivo
            : tiempoActivo // ignore: cast_nullable_to_non_nullable
                  as ActiveTimeDetail?,
        zonasEsfuerzo: freezed == zonasEsfuerzo
            ? _value.zonasEsfuerzo
            : zonasEsfuerzo // ignore: cast_nullable_to_non_nullable
                  as ZonasEsfuerzo?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProgressReportImpl implements _ProgressReport {
  const _$ProgressReportImpl({
    @JsonKey(name: 'id_reporte_semanal') this.idReporteSemanal,
    @JsonKey(name: 'semana_info') this.semanaInfo,
    @JsonKey(name: 'fecha_inicio') this.fechaInicio,
    @JsonKey(name: 'fecha_fin') this.fechaFin,
    this.actualizado,
    this.alertas,
    @JsonKey(name: 'mensaje_ia') this.mensajeIa,
    @JsonKey(name: 'indice_bienestar') this.indiceBienestar,
    @JsonKey(name: 'variacion_indice_bienestar') this.variacionIndiceBienestar,
    @JsonKey(name: 'detalle_factor_movimiento') this.detalleFactorMovement,
    @JsonKey(name: 'detalle_factor_hidratacion') this.detalleFactorHidratacion,
    @JsonKey(name: 'detalle_factor_edad_corporal')
    this.detalleFactorEdadCorporal,
    @JsonKey(name: 'detalle_factor_carga_muscular')
    this.detalleFactorCargaMuscular,
    @JsonKey(name: 'detalle_factor_peso_composicion')
    this.detalleFactorPesoComposicion,
    @JsonKey(name: 'evolucion_indice_bienestar')
    final List<WellnessIndexEvolution> evolucionIndiceBienestar = const [],
    @JsonKey(name: 'historial_peso')
    final List<WeightHistory> historialPeso = const [],
    @JsonKey(name: 'metricas_secundarias') this.metricasSecundarias,
    this.grasa,
    this.musculos,
    this.calorias,
    @JsonKey(name: 'tiempo_activo') this.tiempoActivo,
    @JsonKey(name: 'zonas_esfuerzo') this.zonasEsfuerzo,
  }) : _evolucionIndiceBienestar = evolucionIndiceBienestar,
       _historialPeso = historialPeso;

  factory _$ProgressReportImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProgressReportImplFromJson(json);

  @override
  @JsonKey(name: 'id_reporte_semanal')
  final String? idReporteSemanal;
  @override
  @JsonKey(name: 'semana_info')
  final String? semanaInfo;
  @override
  @JsonKey(name: 'fecha_inicio')
  final String? fechaInicio;
  @override
  @JsonKey(name: 'fecha_fin')
  final String? fechaFin;
  @override
  final String? actualizado;
  @override
  final Alert? alertas;
  @override
  @JsonKey(name: 'mensaje_ia')
  final String? mensajeIa;
  @override
  @JsonKey(name: 'indice_bienestar')
  final num? indiceBienestar;
  @override
  @JsonKey(name: 'variacion_indice_bienestar')
  final num? variacionIndiceBienestar;
  @override
  @JsonKey(name: 'detalle_factor_movimiento')
  final GeneralFactorDetail? detalleFactorMovement;
  @override
  @JsonKey(name: 'detalle_factor_hidratacion')
  final FactorHidratacionDetail? detalleFactorHidratacion;
  @override
  @JsonKey(name: 'detalle_factor_edad_corporal')
  final GeneralFactorDetail? detalleFactorEdadCorporal;
  @override
  @JsonKey(name: 'detalle_factor_carga_muscular')
  final GeneralFactorDetail? detalleFactorCargaMuscular;
  @override
  @JsonKey(name: 'detalle_factor_peso_composicion')
  final FactorWeightDetail? detalleFactorPesoComposicion;
  final List<WellnessIndexEvolution> _evolucionIndiceBienestar;
  @override
  @JsonKey(name: 'evolucion_indice_bienestar')
  List<WellnessIndexEvolution> get evolucionIndiceBienestar {
    if (_evolucionIndiceBienestar is EqualUnmodifiableListView)
      return _evolucionIndiceBienestar;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_evolucionIndiceBienestar);
  }

  final List<WeightHistory> _historialPeso;
  @override
  @JsonKey(name: 'historial_peso')
  List<WeightHistory> get historialPeso {
    if (_historialPeso is EqualUnmodifiableListView) return _historialPeso;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_historialPeso);
  }

  @override
  @JsonKey(name: 'metricas_secundarias')
  final SecondaryMetrics? metricasSecundarias;
  @override
  final CurrentPreviousValue? grasa;
  @override
  final CurrentPreviousValue? musculos;
  @override
  final CaloriasDetail? calorias;
  @override
  @JsonKey(name: 'tiempo_activo')
  final ActiveTimeDetail? tiempoActivo;
  @override
  @JsonKey(name: 'zonas_esfuerzo')
  final ZonasEsfuerzo? zonasEsfuerzo;

  @override
  String toString() {
    return 'ProgressReport(idReporteSemanal: $idReporteSemanal, semanaInfo: $semanaInfo, fechaInicio: $fechaInicio, fechaFin: $fechaFin, actualizado: $actualizado, alertas: $alertas, mensajeIa: $mensajeIa, indiceBienestar: $indiceBienestar, variacionIndiceBienestar: $variacionIndiceBienestar, detalleFactorMovement: $detalleFactorMovement, detalleFactorHidratacion: $detalleFactorHidratacion, detalleFactorEdadCorporal: $detalleFactorEdadCorporal, detalleFactorCargaMuscular: $detalleFactorCargaMuscular, detalleFactorPesoComposicion: $detalleFactorPesoComposicion, evolucionIndiceBienestar: $evolucionIndiceBienestar, historialPeso: $historialPeso, metricasSecundarias: $metricasSecundarias, grasa: $grasa, musculos: $musculos, calorias: $calorias, tiempoActivo: $tiempoActivo, zonasEsfuerzo: $zonasEsfuerzo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProgressReportImpl &&
            (identical(other.idReporteSemanal, idReporteSemanal) ||
                other.idReporteSemanal == idReporteSemanal) &&
            (identical(other.semanaInfo, semanaInfo) ||
                other.semanaInfo == semanaInfo) &&
            (identical(other.fechaInicio, fechaInicio) ||
                other.fechaInicio == fechaInicio) &&
            (identical(other.fechaFin, fechaFin) ||
                other.fechaFin == fechaFin) &&
            (identical(other.actualizado, actualizado) ||
                other.actualizado == actualizado) &&
            (identical(other.alertas, alertas) || other.alertas == alertas) &&
            (identical(other.mensajeIa, mensajeIa) ||
                other.mensajeIa == mensajeIa) &&
            (identical(other.indiceBienestar, indiceBienestar) ||
                other.indiceBienestar == indiceBienestar) &&
            (identical(
                  other.variacionIndiceBienestar,
                  variacionIndiceBienestar,
                ) ||
                other.variacionIndiceBienestar == variacionIndiceBienestar) &&
            (identical(other.detalleFactorMovement, detalleFactorMovement) ||
                other.detalleFactorMovement == detalleFactorMovement) &&
            (identical(
                  other.detalleFactorHidratacion,
                  detalleFactorHidratacion,
                ) ||
                other.detalleFactorHidratacion == detalleFactorHidratacion) &&
            (identical(
                  other.detalleFactorEdadCorporal,
                  detalleFactorEdadCorporal,
                ) ||
                other.detalleFactorEdadCorporal == detalleFactorEdadCorporal) &&
            (identical(
                  other.detalleFactorCargaMuscular,
                  detalleFactorCargaMuscular,
                ) ||
                other.detalleFactorCargaMuscular ==
                    detalleFactorCargaMuscular) &&
            (identical(
                  other.detalleFactorPesoComposicion,
                  detalleFactorPesoComposicion,
                ) ||
                other.detalleFactorPesoComposicion ==
                    detalleFactorPesoComposicion) &&
            const DeepCollectionEquality().equals(
              other._evolucionIndiceBienestar,
              _evolucionIndiceBienestar,
            ) &&
            const DeepCollectionEquality().equals(
              other._historialPeso,
              _historialPeso,
            ) &&
            (identical(other.metricasSecundarias, metricasSecundarias) ||
                other.metricasSecundarias == metricasSecundarias) &&
            (identical(other.grasa, grasa) || other.grasa == grasa) &&
            (identical(other.musculos, musculos) ||
                other.musculos == musculos) &&
            (identical(other.calorias, calorias) ||
                other.calorias == calorias) &&
            (identical(other.tiempoActivo, tiempoActivo) ||
                other.tiempoActivo == tiempoActivo) &&
            (identical(other.zonasEsfuerzo, zonasEsfuerzo) ||
                other.zonasEsfuerzo == zonasEsfuerzo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    idReporteSemanal,
    semanaInfo,
    fechaInicio,
    fechaFin,
    actualizado,
    alertas,
    mensajeIa,
    indiceBienestar,
    variacionIndiceBienestar,
    detalleFactorMovement,
    detalleFactorHidratacion,
    detalleFactorEdadCorporal,
    detalleFactorCargaMuscular,
    detalleFactorPesoComposicion,
    const DeepCollectionEquality().hash(_evolucionIndiceBienestar),
    const DeepCollectionEquality().hash(_historialPeso),
    metricasSecundarias,
    grasa,
    musculos,
    calorias,
    tiempoActivo,
    zonasEsfuerzo,
  ]);

  /// Create a copy of ProgressReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProgressReportImplCopyWith<_$ProgressReportImpl> get copyWith =>
      __$$ProgressReportImplCopyWithImpl<_$ProgressReportImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ProgressReportImplToJson(this);
  }
}

abstract class _ProgressReport implements ProgressReport {
  const factory _ProgressReport({
    @JsonKey(name: 'id_reporte_semanal') final String? idReporteSemanal,
    @JsonKey(name: 'semana_info') final String? semanaInfo,
    @JsonKey(name: 'fecha_inicio') final String? fechaInicio,
    @JsonKey(name: 'fecha_fin') final String? fechaFin,
    final String? actualizado,
    final Alert? alertas,
    @JsonKey(name: 'mensaje_ia') final String? mensajeIa,
    @JsonKey(name: 'indice_bienestar') final num? indiceBienestar,
    @JsonKey(name: 'variacion_indice_bienestar')
    final num? variacionIndiceBienestar,
    @JsonKey(name: 'detalle_factor_movimiento')
    final GeneralFactorDetail? detalleFactorMovement,
    @JsonKey(name: 'detalle_factor_hidratacion')
    final FactorHidratacionDetail? detalleFactorHidratacion,
    @JsonKey(name: 'detalle_factor_edad_corporal')
    final GeneralFactorDetail? detalleFactorEdadCorporal,
    @JsonKey(name: 'detalle_factor_carga_muscular')
    final GeneralFactorDetail? detalleFactorCargaMuscular,
    @JsonKey(name: 'detalle_factor_peso_composicion')
    final FactorWeightDetail? detalleFactorPesoComposicion,
    @JsonKey(name: 'evolucion_indice_bienestar')
    final List<WellnessIndexEvolution> evolucionIndiceBienestar,
    @JsonKey(name: 'historial_peso') final List<WeightHistory> historialPeso,
    @JsonKey(name: 'metricas_secundarias')
    final SecondaryMetrics? metricasSecundarias,
    final CurrentPreviousValue? grasa,
    final CurrentPreviousValue? musculos,
    final CaloriasDetail? calorias,
    @JsonKey(name: 'tiempo_activo') final ActiveTimeDetail? tiempoActivo,
    @JsonKey(name: 'zonas_esfuerzo') final ZonasEsfuerzo? zonasEsfuerzo,
  }) = _$ProgressReportImpl;

  factory _ProgressReport.fromJson(Map<String, dynamic> json) =
      _$ProgressReportImpl.fromJson;

  @override
  @JsonKey(name: 'id_reporte_semanal')
  String? get idReporteSemanal;
  @override
  @JsonKey(name: 'semana_info')
  String? get semanaInfo;
  @override
  @JsonKey(name: 'fecha_inicio')
  String? get fechaInicio;
  @override
  @JsonKey(name: 'fecha_fin')
  String? get fechaFin;
  @override
  String? get actualizado;
  @override
  Alert? get alertas;
  @override
  @JsonKey(name: 'mensaje_ia')
  String? get mensajeIa;
  @override
  @JsonKey(name: 'indice_bienestar')
  num? get indiceBienestar;
  @override
  @JsonKey(name: 'variacion_indice_bienestar')
  num? get variacionIndiceBienestar;
  @override
  @JsonKey(name: 'detalle_factor_movimiento')
  GeneralFactorDetail? get detalleFactorMovement;
  @override
  @JsonKey(name: 'detalle_factor_hidratacion')
  FactorHidratacionDetail? get detalleFactorHidratacion;
  @override
  @JsonKey(name: 'detalle_factor_edad_corporal')
  GeneralFactorDetail? get detalleFactorEdadCorporal;
  @override
  @JsonKey(name: 'detalle_factor_carga_muscular')
  GeneralFactorDetail? get detalleFactorCargaMuscular;
  @override
  @JsonKey(name: 'detalle_factor_peso_composicion')
  FactorWeightDetail? get detalleFactorPesoComposicion;
  @override
  @JsonKey(name: 'evolucion_indice_bienestar')
  List<WellnessIndexEvolution> get evolucionIndiceBienestar;
  @override
  @JsonKey(name: 'historial_peso')
  List<WeightHistory> get historialPeso;
  @override
  @JsonKey(name: 'metricas_secundarias')
  SecondaryMetrics? get metricasSecundarias;
  @override
  CurrentPreviousValue? get grasa;
  @override
  CurrentPreviousValue? get musculos;
  @override
  CaloriasDetail? get calorias;
  @override
  @JsonKey(name: 'tiempo_activo')
  ActiveTimeDetail? get tiempoActivo;
  @override
  @JsonKey(name: 'zonas_esfuerzo')
  ZonasEsfuerzo? get zonasEsfuerzo;

  /// Create a copy of ProgressReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProgressReportImplCopyWith<_$ProgressReportImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Alert _$AlertFromJson(Map<String, dynamic> json) {
  return _Alert.fromJson(json);
}

/// @nodoc
mixin _$Alert {
  bool get activa => throw _privateConstructorUsedError;
  String? get detalle => throw _privateConstructorUsedError;

  /// Serializes this Alert to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Alert
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AlertCopyWith<Alert> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlertCopyWith<$Res> {
  factory $AlertCopyWith(Alert value, $Res Function(Alert) then) =
      _$AlertCopyWithImpl<$Res, Alert>;
  @useResult
  $Res call({bool activa, String? detalle});
}

/// @nodoc
class _$AlertCopyWithImpl<$Res, $Val extends Alert>
    implements $AlertCopyWith<$Res> {
  _$AlertCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Alert
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? activa = null, Object? detalle = freezed}) {
    return _then(
      _value.copyWith(
            activa: null == activa
                ? _value.activa
                : activa // ignore: cast_nullable_to_non_nullable
                      as bool,
            detalle: freezed == detalle
                ? _value.detalle
                : detalle // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AlertImplCopyWith<$Res> implements $AlertCopyWith<$Res> {
  factory _$$AlertImplCopyWith(
    _$AlertImpl value,
    $Res Function(_$AlertImpl) then,
  ) = __$$AlertImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool activa, String? detalle});
}

/// @nodoc
class __$$AlertImplCopyWithImpl<$Res>
    extends _$AlertCopyWithImpl<$Res, _$AlertImpl>
    implements _$$AlertImplCopyWith<$Res> {
  __$$AlertImplCopyWithImpl(
    _$AlertImpl _value,
    $Res Function(_$AlertImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Alert
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? activa = null, Object? detalle = freezed}) {
    return _then(
      _$AlertImpl(
        activa: null == activa
            ? _value.activa
            : activa // ignore: cast_nullable_to_non_nullable
                  as bool,
        detalle: freezed == detalle
            ? _value.detalle
            : detalle // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AlertImpl implements _Alert {
  const _$AlertImpl({this.activa = false, this.detalle});

  factory _$AlertImpl.fromJson(Map<String, dynamic> json) =>
      _$$AlertImplFromJson(json);

  @override
  @JsonKey()
  final bool activa;
  @override
  final String? detalle;

  @override
  String toString() {
    return 'Alert(activa: $activa, detalle: $detalle)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlertImpl &&
            (identical(other.activa, activa) || other.activa == activa) &&
            (identical(other.detalle, detalle) || other.detalle == detalle));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, activa, detalle);

  /// Create a copy of Alert
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AlertImplCopyWith<_$AlertImpl> get copyWith =>
      __$$AlertImplCopyWithImpl<_$AlertImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AlertImplToJson(this);
  }
}

abstract class _Alert implements Alert {
  const factory _Alert({final bool activa, final String? detalle}) =
      _$AlertImpl;

  factory _Alert.fromJson(Map<String, dynamic> json) = _$AlertImpl.fromJson;

  @override
  bool get activa;
  @override
  String? get detalle;

  /// Create a copy of Alert
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AlertImplCopyWith<_$AlertImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GeneralFactorDetail _$GeneralFactorDetailFromJson(Map<String, dynamic> json) {
  return _GeneralFactorDetail.fromJson(json);
}

/// @nodoc
mixin _$GeneralFactorDetail {
  num? get puntaje => throw _privateConstructorUsedError;
  num? get variacion => throw _privateConstructorUsedError;

  /// Serializes this GeneralFactorDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GeneralFactorDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GeneralFactorDetailCopyWith<GeneralFactorDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GeneralFactorDetailCopyWith<$Res> {
  factory $GeneralFactorDetailCopyWith(
    GeneralFactorDetail value,
    $Res Function(GeneralFactorDetail) then,
  ) = _$GeneralFactorDetailCopyWithImpl<$Res, GeneralFactorDetail>;
  @useResult
  $Res call({num? puntaje, num? variacion});
}

/// @nodoc
class _$GeneralFactorDetailCopyWithImpl<$Res, $Val extends GeneralFactorDetail>
    implements $GeneralFactorDetailCopyWith<$Res> {
  _$GeneralFactorDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GeneralFactorDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? puntaje = freezed, Object? variacion = freezed}) {
    return _then(
      _value.copyWith(
            puntaje: freezed == puntaje
                ? _value.puntaje
                : puntaje // ignore: cast_nullable_to_non_nullable
                      as num?,
            variacion: freezed == variacion
                ? _value.variacion
                : variacion // ignore: cast_nullable_to_non_nullable
                      as num?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GeneralFactorDetailImplCopyWith<$Res>
    implements $GeneralFactorDetailCopyWith<$Res> {
  factory _$$GeneralFactorDetailImplCopyWith(
    _$GeneralFactorDetailImpl value,
    $Res Function(_$GeneralFactorDetailImpl) then,
  ) = __$$GeneralFactorDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({num? puntaje, num? variacion});
}

/// @nodoc
class __$$GeneralFactorDetailImplCopyWithImpl<$Res>
    extends _$GeneralFactorDetailCopyWithImpl<$Res, _$GeneralFactorDetailImpl>
    implements _$$GeneralFactorDetailImplCopyWith<$Res> {
  __$$GeneralFactorDetailImplCopyWithImpl(
    _$GeneralFactorDetailImpl _value,
    $Res Function(_$GeneralFactorDetailImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GeneralFactorDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? puntaje = freezed, Object? variacion = freezed}) {
    return _then(
      _$GeneralFactorDetailImpl(
        puntaje: freezed == puntaje
            ? _value.puntaje
            : puntaje // ignore: cast_nullable_to_non_nullable
                  as num?,
        variacion: freezed == variacion
            ? _value.variacion
            : variacion // ignore: cast_nullable_to_non_nullable
                  as num?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GeneralFactorDetailImpl implements _GeneralFactorDetail {
  const _$GeneralFactorDetailImpl({this.puntaje, this.variacion});

  factory _$GeneralFactorDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$GeneralFactorDetailImplFromJson(json);

  @override
  final num? puntaje;
  @override
  final num? variacion;

  @override
  String toString() {
    return 'GeneralFactorDetail(puntaje: $puntaje, variacion: $variacion)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GeneralFactorDetailImpl &&
            (identical(other.puntaje, puntaje) || other.puntaje == puntaje) &&
            (identical(other.variacion, variacion) ||
                other.variacion == variacion));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, puntaje, variacion);

  /// Create a copy of GeneralFactorDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GeneralFactorDetailImplCopyWith<_$GeneralFactorDetailImpl> get copyWith =>
      __$$GeneralFactorDetailImplCopyWithImpl<_$GeneralFactorDetailImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$GeneralFactorDetailImplToJson(this);
  }
}

abstract class _GeneralFactorDetail implements GeneralFactorDetail {
  const factory _GeneralFactorDetail({
    final num? puntaje,
    final num? variacion,
  }) = _$GeneralFactorDetailImpl;

  factory _GeneralFactorDetail.fromJson(Map<String, dynamic> json) =
      _$GeneralFactorDetailImpl.fromJson;

  @override
  num? get puntaje;
  @override
  num? get variacion;

  /// Create a copy of GeneralFactorDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GeneralFactorDetailImplCopyWith<_$GeneralFactorDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FactorHidratacionDetail _$FactorHidratacionDetailFromJson(
  Map<String, dynamic> json,
) {
  return _FactorHidratacionDetail.fromJson(json);
}

/// @nodoc
mixin _$FactorHidratacionDetail {
  HidratacionPuntajeDetail? get puntaje => throw _privateConstructorUsedError;
  num? get variacion => throw _privateConstructorUsedError;

  /// Serializes this FactorHidratacionDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FactorHidratacionDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FactorHidratacionDetailCopyWith<FactorHidratacionDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FactorHidratacionDetailCopyWith<$Res> {
  factory $FactorHidratacionDetailCopyWith(
    FactorHidratacionDetail value,
    $Res Function(FactorHidratacionDetail) then,
  ) = _$FactorHidratacionDetailCopyWithImpl<$Res, FactorHidratacionDetail>;
  @useResult
  $Res call({HidratacionPuntajeDetail? puntaje, num? variacion});

  $HidratacionPuntajeDetailCopyWith<$Res>? get puntaje;
}

/// @nodoc
class _$FactorHidratacionDetailCopyWithImpl<
  $Res,
  $Val extends FactorHidratacionDetail
>
    implements $FactorHidratacionDetailCopyWith<$Res> {
  _$FactorHidratacionDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FactorHidratacionDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? puntaje = freezed, Object? variacion = freezed}) {
    return _then(
      _value.copyWith(
            puntaje: freezed == puntaje
                ? _value.puntaje
                : puntaje // ignore: cast_nullable_to_non_nullable
                      as HidratacionPuntajeDetail?,
            variacion: freezed == variacion
                ? _value.variacion
                : variacion // ignore: cast_nullable_to_non_nullable
                      as num?,
          )
          as $Val,
    );
  }

  /// Create a copy of FactorHidratacionDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $HidratacionPuntajeDetailCopyWith<$Res>? get puntaje {
    if (_value.puntaje == null) {
      return null;
    }

    return $HidratacionPuntajeDetailCopyWith<$Res>(_value.puntaje!, (value) {
      return _then(_value.copyWith(puntaje: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FactorHidratacionDetailImplCopyWith<$Res>
    implements $FactorHidratacionDetailCopyWith<$Res> {
  factory _$$FactorHidratacionDetailImplCopyWith(
    _$FactorHidratacionDetailImpl value,
    $Res Function(_$FactorHidratacionDetailImpl) then,
  ) = __$$FactorHidratacionDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({HidratacionPuntajeDetail? puntaje, num? variacion});

  @override
  $HidratacionPuntajeDetailCopyWith<$Res>? get puntaje;
}

/// @nodoc
class __$$FactorHidratacionDetailImplCopyWithImpl<$Res>
    extends
        _$FactorHidratacionDetailCopyWithImpl<
          $Res,
          _$FactorHidratacionDetailImpl
        >
    implements _$$FactorHidratacionDetailImplCopyWith<$Res> {
  __$$FactorHidratacionDetailImplCopyWithImpl(
    _$FactorHidratacionDetailImpl _value,
    $Res Function(_$FactorHidratacionDetailImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FactorHidratacionDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? puntaje = freezed, Object? variacion = freezed}) {
    return _then(
      _$FactorHidratacionDetailImpl(
        puntaje: freezed == puntaje
            ? _value.puntaje
            : puntaje // ignore: cast_nullable_to_non_nullable
                  as HidratacionPuntajeDetail?,
        variacion: freezed == variacion
            ? _value.variacion
            : variacion // ignore: cast_nullable_to_non_nullable
                  as num?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FactorHidratacionDetailImpl implements _FactorHidratacionDetail {
  const _$FactorHidratacionDetailImpl({this.puntaje, this.variacion});

  factory _$FactorHidratacionDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$FactorHidratacionDetailImplFromJson(json);

  @override
  final HidratacionPuntajeDetail? puntaje;
  @override
  final num? variacion;

  @override
  String toString() {
    return 'FactorHidratacionDetail(puntaje: $puntaje, variacion: $variacion)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FactorHidratacionDetailImpl &&
            (identical(other.puntaje, puntaje) || other.puntaje == puntaje) &&
            (identical(other.variacion, variacion) ||
                other.variacion == variacion));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, puntaje, variacion);

  /// Create a copy of FactorHidratacionDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FactorHidratacionDetailImplCopyWith<_$FactorHidratacionDetailImpl>
  get copyWith =>
      __$$FactorHidratacionDetailImplCopyWithImpl<
        _$FactorHidratacionDetailImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FactorHidratacionDetailImplToJson(this);
  }
}

abstract class _FactorHidratacionDetail implements FactorHidratacionDetail {
  const factory _FactorHidratacionDetail({
    final HidratacionPuntajeDetail? puntaje,
    final num? variacion,
  }) = _$FactorHidratacionDetailImpl;

  factory _FactorHidratacionDetail.fromJson(Map<String, dynamic> json) =
      _$FactorHidratacionDetailImpl.fromJson;

  @override
  HidratacionPuntajeDetail? get puntaje;
  @override
  num? get variacion;

  /// Create a copy of FactorHidratacionDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FactorHidratacionDetailImplCopyWith<_$FactorHidratacionDetailImpl>
  get copyWith => throw _privateConstructorUsedError;
}

HidratacionPuntajeDetail _$HidratacionPuntajeDetailFromJson(
  Map<String, dynamic> json,
) {
  return _HidratacionPuntajeDetail.fromJson(json);
}

/// @nodoc
mixin _$HidratacionPuntajeDetail {
  @JsonKey(name: 'consumo_total_ml')
  num? get consumoTotalMl => throw _privateConstructorUsedError;
  @JsonKey(name: 'score_hidratacion')
  num? get scoreHidratacion => throw _privateConstructorUsedError;
  @JsonKey(name: 'requerimiento_total_ml')
  num? get requerimientoTotalMl => throw _privateConstructorUsedError;

  /// Serializes this HidratacionPuntajeDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HidratacionPuntajeDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HidratacionPuntajeDetailCopyWith<HidratacionPuntajeDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HidratacionPuntajeDetailCopyWith<$Res> {
  factory $HidratacionPuntajeDetailCopyWith(
    HidratacionPuntajeDetail value,
    $Res Function(HidratacionPuntajeDetail) then,
  ) = _$HidratacionPuntajeDetailCopyWithImpl<$Res, HidratacionPuntajeDetail>;
  @useResult
  $Res call({
    @JsonKey(name: 'consumo_total_ml') num? consumoTotalMl,
    @JsonKey(name: 'score_hidratacion') num? scoreHidratacion,
    @JsonKey(name: 'requerimiento_total_ml') num? requerimientoTotalMl,
  });
}

/// @nodoc
class _$HidratacionPuntajeDetailCopyWithImpl<
  $Res,
  $Val extends HidratacionPuntajeDetail
>
    implements $HidratacionPuntajeDetailCopyWith<$Res> {
  _$HidratacionPuntajeDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HidratacionPuntajeDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? consumoTotalMl = freezed,
    Object? scoreHidratacion = freezed,
    Object? requerimientoTotalMl = freezed,
  }) {
    return _then(
      _value.copyWith(
            consumoTotalMl: freezed == consumoTotalMl
                ? _value.consumoTotalMl
                : consumoTotalMl // ignore: cast_nullable_to_non_nullable
                      as num?,
            scoreHidratacion: freezed == scoreHidratacion
                ? _value.scoreHidratacion
                : scoreHidratacion // ignore: cast_nullable_to_non_nullable
                      as num?,
            requerimientoTotalMl: freezed == requerimientoTotalMl
                ? _value.requerimientoTotalMl
                : requerimientoTotalMl // ignore: cast_nullable_to_non_nullable
                      as num?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HidratacionPuntajeDetailImplCopyWith<$Res>
    implements $HidratacionPuntajeDetailCopyWith<$Res> {
  factory _$$HidratacionPuntajeDetailImplCopyWith(
    _$HidratacionPuntajeDetailImpl value,
    $Res Function(_$HidratacionPuntajeDetailImpl) then,
  ) = __$$HidratacionPuntajeDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'consumo_total_ml') num? consumoTotalMl,
    @JsonKey(name: 'score_hidratacion') num? scoreHidratacion,
    @JsonKey(name: 'requerimiento_total_ml') num? requerimientoTotalMl,
  });
}

/// @nodoc
class __$$HidratacionPuntajeDetailImplCopyWithImpl<$Res>
    extends
        _$HidratacionPuntajeDetailCopyWithImpl<
          $Res,
          _$HidratacionPuntajeDetailImpl
        >
    implements _$$HidratacionPuntajeDetailImplCopyWith<$Res> {
  __$$HidratacionPuntajeDetailImplCopyWithImpl(
    _$HidratacionPuntajeDetailImpl _value,
    $Res Function(_$HidratacionPuntajeDetailImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HidratacionPuntajeDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? consumoTotalMl = freezed,
    Object? scoreHidratacion = freezed,
    Object? requerimientoTotalMl = freezed,
  }) {
    return _then(
      _$HidratacionPuntajeDetailImpl(
        consumoTotalMl: freezed == consumoTotalMl
            ? _value.consumoTotalMl
            : consumoTotalMl // ignore: cast_nullable_to_non_nullable
                  as num?,
        scoreHidratacion: freezed == scoreHidratacion
            ? _value.scoreHidratacion
            : scoreHidratacion // ignore: cast_nullable_to_non_nullable
                  as num?,
        requerimientoTotalMl: freezed == requerimientoTotalMl
            ? _value.requerimientoTotalMl
            : requerimientoTotalMl // ignore: cast_nullable_to_non_nullable
                  as num?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$HidratacionPuntajeDetailImpl implements _HidratacionPuntajeDetail {
  const _$HidratacionPuntajeDetailImpl({
    @JsonKey(name: 'consumo_total_ml') this.consumoTotalMl,
    @JsonKey(name: 'score_hidratacion') this.scoreHidratacion,
    @JsonKey(name: 'requerimiento_total_ml') this.requerimientoTotalMl,
  });

  factory _$HidratacionPuntajeDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$HidratacionPuntajeDetailImplFromJson(json);

  @override
  @JsonKey(name: 'consumo_total_ml')
  final num? consumoTotalMl;
  @override
  @JsonKey(name: 'score_hidratacion')
  final num? scoreHidratacion;
  @override
  @JsonKey(name: 'requerimiento_total_ml')
  final num? requerimientoTotalMl;

  @override
  String toString() {
    return 'HidratacionPuntajeDetail(consumoTotalMl: $consumoTotalMl, scoreHidratacion: $scoreHidratacion, requerimientoTotalMl: $requerimientoTotalMl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HidratacionPuntajeDetailImpl &&
            (identical(other.consumoTotalMl, consumoTotalMl) ||
                other.consumoTotalMl == consumoTotalMl) &&
            (identical(other.scoreHidratacion, scoreHidratacion) ||
                other.scoreHidratacion == scoreHidratacion) &&
            (identical(other.requerimientoTotalMl, requerimientoTotalMl) ||
                other.requerimientoTotalMl == requerimientoTotalMl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    consumoTotalMl,
    scoreHidratacion,
    requerimientoTotalMl,
  );

  /// Create a copy of HidratacionPuntajeDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HidratacionPuntajeDetailImplCopyWith<_$HidratacionPuntajeDetailImpl>
  get copyWith =>
      __$$HidratacionPuntajeDetailImplCopyWithImpl<
        _$HidratacionPuntajeDetailImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HidratacionPuntajeDetailImplToJson(this);
  }
}

abstract class _HidratacionPuntajeDetail implements HidratacionPuntajeDetail {
  const factory _HidratacionPuntajeDetail({
    @JsonKey(name: 'consumo_total_ml') final num? consumoTotalMl,
    @JsonKey(name: 'score_hidratacion') final num? scoreHidratacion,
    @JsonKey(name: 'requerimiento_total_ml') final num? requerimientoTotalMl,
  }) = _$HidratacionPuntajeDetailImpl;

  factory _HidratacionPuntajeDetail.fromJson(Map<String, dynamic> json) =
      _$HidratacionPuntajeDetailImpl.fromJson;

  @override
  @JsonKey(name: 'consumo_total_ml')
  num? get consumoTotalMl;
  @override
  @JsonKey(name: 'score_hidratacion')
  num? get scoreHidratacion;
  @override
  @JsonKey(name: 'requerimiento_total_ml')
  num? get requerimientoTotalMl;

  /// Create a copy of HidratacionPuntajeDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HidratacionPuntajeDetailImplCopyWith<_$HidratacionPuntajeDetailImpl>
  get copyWith => throw _privateConstructorUsedError;
}

FactorWeightDetail _$FactorWeightDetailFromJson(Map<String, dynamic> json) {
  return _FactorWeightDetail.fromJson(json);
}

/// @nodoc
mixin _$FactorWeightDetail {
  WeightPuntajeDetail? get puntaje => throw _privateConstructorUsedError;
  num? get variacion => throw _privateConstructorUsedError;
  num? get imc => throw _privateConstructorUsedError;
  @JsonKey(name: 'peso_registrado')
  num? get pesoRegistrado => throw _privateConstructorUsedError;

  /// Serializes this FactorWeightDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FactorWeightDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FactorWeightDetailCopyWith<FactorWeightDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FactorWeightDetailCopyWith<$Res> {
  factory $FactorWeightDetailCopyWith(
    FactorWeightDetail value,
    $Res Function(FactorWeightDetail) then,
  ) = _$FactorWeightDetailCopyWithImpl<$Res, FactorWeightDetail>;
  @useResult
  $Res call({
    WeightPuntajeDetail? puntaje,
    num? variacion,
    num? imc,
    @JsonKey(name: 'peso_registrado') num? pesoRegistrado,
  });

  $WeightPuntajeDetailCopyWith<$Res>? get puntaje;
}

/// @nodoc
class _$FactorWeightDetailCopyWithImpl<$Res, $Val extends FactorWeightDetail>
    implements $FactorWeightDetailCopyWith<$Res> {
  _$FactorWeightDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FactorWeightDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? puntaje = freezed,
    Object? variacion = freezed,
    Object? imc = freezed,
    Object? pesoRegistrado = freezed,
  }) {
    return _then(
      _value.copyWith(
            puntaje: freezed == puntaje
                ? _value.puntaje
                : puntaje // ignore: cast_nullable_to_non_nullable
                      as WeightPuntajeDetail?,
            variacion: freezed == variacion
                ? _value.variacion
                : variacion // ignore: cast_nullable_to_non_nullable
                      as num?,
            imc: freezed == imc
                ? _value.imc
                : imc // ignore: cast_nullable_to_non_nullable
                      as num?,
            pesoRegistrado: freezed == pesoRegistrado
                ? _value.pesoRegistrado
                : pesoRegistrado // ignore: cast_nullable_to_non_nullable
                      as num?,
          )
          as $Val,
    );
  }

  /// Create a copy of FactorWeightDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WeightPuntajeDetailCopyWith<$Res>? get puntaje {
    if (_value.puntaje == null) {
      return null;
    }

    return $WeightPuntajeDetailCopyWith<$Res>(_value.puntaje!, (value) {
      return _then(_value.copyWith(puntaje: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FactorWeightDetailImplCopyWith<$Res>
    implements $FactorWeightDetailCopyWith<$Res> {
  factory _$$FactorWeightDetailImplCopyWith(
    _$FactorWeightDetailImpl value,
    $Res Function(_$FactorWeightDetailImpl) then,
  ) = __$$FactorWeightDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    WeightPuntajeDetail? puntaje,
    num? variacion,
    num? imc,
    @JsonKey(name: 'peso_registrado') num? pesoRegistrado,
  });

  @override
  $WeightPuntajeDetailCopyWith<$Res>? get puntaje;
}

/// @nodoc
class __$$FactorWeightDetailImplCopyWithImpl<$Res>
    extends _$FactorWeightDetailCopyWithImpl<$Res, _$FactorWeightDetailImpl>
    implements _$$FactorWeightDetailImplCopyWith<$Res> {
  __$$FactorWeightDetailImplCopyWithImpl(
    _$FactorWeightDetailImpl _value,
    $Res Function(_$FactorWeightDetailImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FactorWeightDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? puntaje = freezed,
    Object? variacion = freezed,
    Object? imc = freezed,
    Object? pesoRegistrado = freezed,
  }) {
    return _then(
      _$FactorWeightDetailImpl(
        puntaje: freezed == puntaje
            ? _value.puntaje
            : puntaje // ignore: cast_nullable_to_non_nullable
                  as WeightPuntajeDetail?,
        variacion: freezed == variacion
            ? _value.variacion
            : variacion // ignore: cast_nullable_to_non_nullable
                  as num?,
        imc: freezed == imc
            ? _value.imc
            : imc // ignore: cast_nullable_to_non_nullable
                  as num?,
        pesoRegistrado: freezed == pesoRegistrado
            ? _value.pesoRegistrado
            : pesoRegistrado // ignore: cast_nullable_to_non_nullable
                  as num?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FactorWeightDetailImpl implements _FactorWeightDetail {
  const _$FactorWeightDetailImpl({
    this.puntaje,
    this.variacion,
    this.imc,
    @JsonKey(name: 'peso_registrado') this.pesoRegistrado,
  });

  factory _$FactorWeightDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$FactorWeightDetailImplFromJson(json);

  @override
  final WeightPuntajeDetail? puntaje;
  @override
  final num? variacion;
  @override
  final num? imc;
  @override
  @JsonKey(name: 'peso_registrado')
  final num? pesoRegistrado;

  @override
  String toString() {
    return 'FactorWeightDetail(puntaje: $puntaje, variacion: $variacion, imc: $imc, pesoRegistrado: $pesoRegistrado)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FactorWeightDetailImpl &&
            (identical(other.puntaje, puntaje) || other.puntaje == puntaje) &&
            (identical(other.variacion, variacion) ||
                other.variacion == variacion) &&
            (identical(other.imc, imc) || other.imc == imc) &&
            (identical(other.pesoRegistrado, pesoRegistrado) ||
                other.pesoRegistrado == pesoRegistrado));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, puntaje, variacion, imc, pesoRegistrado);

  /// Create a copy of FactorWeightDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FactorWeightDetailImplCopyWith<_$FactorWeightDetailImpl> get copyWith =>
      __$$FactorWeightDetailImplCopyWithImpl<_$FactorWeightDetailImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FactorWeightDetailImplToJson(this);
  }
}

abstract class _FactorWeightDetail implements FactorWeightDetail {
  const factory _FactorWeightDetail({
    final WeightPuntajeDetail? puntaje,
    final num? variacion,
    final num? imc,
    @JsonKey(name: 'peso_registrado') final num? pesoRegistrado,
  }) = _$FactorWeightDetailImpl;

  factory _FactorWeightDetail.fromJson(Map<String, dynamic> json) =
      _$FactorWeightDetailImpl.fromJson;

  @override
  WeightPuntajeDetail? get puntaje;
  @override
  num? get variacion;
  @override
  num? get imc;
  @override
  @JsonKey(name: 'peso_registrado')
  num? get pesoRegistrado;

  /// Create a copy of FactorWeightDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FactorWeightDetailImplCopyWith<_$FactorWeightDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WeightPuntajeDetail _$WeightPuntajeDetailFromJson(Map<String, dynamic> json) {
  return _WeightPuntajeDetail.fromJson(json);
}

/// @nodoc
mixin _$WeightPuntajeDetail {
  String? get tag => throw _privateConstructorUsedError;
  num? get puntaje => throw _privateConstructorUsedError;

  /// Serializes this WeightPuntajeDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WeightPuntajeDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WeightPuntajeDetailCopyWith<WeightPuntajeDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeightPuntajeDetailCopyWith<$Res> {
  factory $WeightPuntajeDetailCopyWith(
    WeightPuntajeDetail value,
    $Res Function(WeightPuntajeDetail) then,
  ) = _$WeightPuntajeDetailCopyWithImpl<$Res, WeightPuntajeDetail>;
  @useResult
  $Res call({String? tag, num? puntaje});
}

/// @nodoc
class _$WeightPuntajeDetailCopyWithImpl<$Res, $Val extends WeightPuntajeDetail>
    implements $WeightPuntajeDetailCopyWith<$Res> {
  _$WeightPuntajeDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WeightPuntajeDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? tag = freezed, Object? puntaje = freezed}) {
    return _then(
      _value.copyWith(
            tag: freezed == tag
                ? _value.tag
                : tag // ignore: cast_nullable_to_non_nullable
                      as String?,
            puntaje: freezed == puntaje
                ? _value.puntaje
                : puntaje // ignore: cast_nullable_to_non_nullable
                      as num?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WeightPuntajeDetailImplCopyWith<$Res>
    implements $WeightPuntajeDetailCopyWith<$Res> {
  factory _$$WeightPuntajeDetailImplCopyWith(
    _$WeightPuntajeDetailImpl value,
    $Res Function(_$WeightPuntajeDetailImpl) then,
  ) = __$$WeightPuntajeDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? tag, num? puntaje});
}

/// @nodoc
class __$$WeightPuntajeDetailImplCopyWithImpl<$Res>
    extends _$WeightPuntajeDetailCopyWithImpl<$Res, _$WeightPuntajeDetailImpl>
    implements _$$WeightPuntajeDetailImplCopyWith<$Res> {
  __$$WeightPuntajeDetailImplCopyWithImpl(
    _$WeightPuntajeDetailImpl _value,
    $Res Function(_$WeightPuntajeDetailImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WeightPuntajeDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? tag = freezed, Object? puntaje = freezed}) {
    return _then(
      _$WeightPuntajeDetailImpl(
        tag: freezed == tag
            ? _value.tag
            : tag // ignore: cast_nullable_to_non_nullable
                  as String?,
        puntaje: freezed == puntaje
            ? _value.puntaje
            : puntaje // ignore: cast_nullable_to_non_nullable
                  as num?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WeightPuntajeDetailImpl implements _WeightPuntajeDetail {
  const _$WeightPuntajeDetailImpl({this.tag, this.puntaje});

  factory _$WeightPuntajeDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$WeightPuntajeDetailImplFromJson(json);

  @override
  final String? tag;
  @override
  final num? puntaje;

  @override
  String toString() {
    return 'WeightPuntajeDetail(tag: $tag, puntaje: $puntaje)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeightPuntajeDetailImpl &&
            (identical(other.tag, tag) || other.tag == tag) &&
            (identical(other.puntaje, puntaje) || other.puntaje == puntaje));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, tag, puntaje);

  /// Create a copy of WeightPuntajeDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WeightPuntajeDetailImplCopyWith<_$WeightPuntajeDetailImpl> get copyWith =>
      __$$WeightPuntajeDetailImplCopyWithImpl<_$WeightPuntajeDetailImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$WeightPuntajeDetailImplToJson(this);
  }
}

abstract class _WeightPuntajeDetail implements WeightPuntajeDetail {
  const factory _WeightPuntajeDetail({final String? tag, final num? puntaje}) =
      _$WeightPuntajeDetailImpl;

  factory _WeightPuntajeDetail.fromJson(Map<String, dynamic> json) =
      _$WeightPuntajeDetailImpl.fromJson;

  @override
  String? get tag;
  @override
  num? get puntaje;

  /// Create a copy of WeightPuntajeDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WeightPuntajeDetailImplCopyWith<_$WeightPuntajeDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CurrentPreviousValue _$CurrentPreviousValueFromJson(Map<String, dynamic> json) {
  return _CurrentPreviousValue.fromJson(json);
}

/// @nodoc
mixin _$CurrentPreviousValue {
  @JsonKey(fromJson: _parseNumericOrString)
  num? get actual => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseNumericOrString)
  num? get anterior => throw _privateConstructorUsedError;

  /// Serializes this CurrentPreviousValue to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CurrentPreviousValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CurrentPreviousValueCopyWith<CurrentPreviousValue> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CurrentPreviousValueCopyWith<$Res> {
  factory $CurrentPreviousValueCopyWith(
    CurrentPreviousValue value,
    $Res Function(CurrentPreviousValue) then,
  ) = _$CurrentPreviousValueCopyWithImpl<$Res, CurrentPreviousValue>;
  @useResult
  $Res call({
    @JsonKey(fromJson: _parseNumericOrString) num? actual,
    @JsonKey(fromJson: _parseNumericOrString) num? anterior,
  });
}

/// @nodoc
class _$CurrentPreviousValueCopyWithImpl<
  $Res,
  $Val extends CurrentPreviousValue
>
    implements $CurrentPreviousValueCopyWith<$Res> {
  _$CurrentPreviousValueCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CurrentPreviousValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? actual = freezed, Object? anterior = freezed}) {
    return _then(
      _value.copyWith(
            actual: freezed == actual
                ? _value.actual
                : actual // ignore: cast_nullable_to_non_nullable
                      as num?,
            anterior: freezed == anterior
                ? _value.anterior
                : anterior // ignore: cast_nullable_to_non_nullable
                      as num?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CurrentPreviousValueImplCopyWith<$Res>
    implements $CurrentPreviousValueCopyWith<$Res> {
  factory _$$CurrentPreviousValueImplCopyWith(
    _$CurrentPreviousValueImpl value,
    $Res Function(_$CurrentPreviousValueImpl) then,
  ) = __$$CurrentPreviousValueImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: _parseNumericOrString) num? actual,
    @JsonKey(fromJson: _parseNumericOrString) num? anterior,
  });
}

/// @nodoc
class __$$CurrentPreviousValueImplCopyWithImpl<$Res>
    extends _$CurrentPreviousValueCopyWithImpl<$Res, _$CurrentPreviousValueImpl>
    implements _$$CurrentPreviousValueImplCopyWith<$Res> {
  __$$CurrentPreviousValueImplCopyWithImpl(
    _$CurrentPreviousValueImpl _value,
    $Res Function(_$CurrentPreviousValueImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CurrentPreviousValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? actual = freezed, Object? anterior = freezed}) {
    return _then(
      _$CurrentPreviousValueImpl(
        actual: freezed == actual
            ? _value.actual
            : actual // ignore: cast_nullable_to_non_nullable
                  as num?,
        anterior: freezed == anterior
            ? _value.anterior
            : anterior // ignore: cast_nullable_to_non_nullable
                  as num?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CurrentPreviousValueImpl implements _CurrentPreviousValue {
  const _$CurrentPreviousValueImpl({
    @JsonKey(fromJson: _parseNumericOrString) this.actual,
    @JsonKey(fromJson: _parseNumericOrString) this.anterior,
  });

  factory _$CurrentPreviousValueImpl.fromJson(Map<String, dynamic> json) =>
      _$$CurrentPreviousValueImplFromJson(json);

  @override
  @JsonKey(fromJson: _parseNumericOrString)
  final num? actual;
  @override
  @JsonKey(fromJson: _parseNumericOrString)
  final num? anterior;

  @override
  String toString() {
    return 'CurrentPreviousValue(actual: $actual, anterior: $anterior)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CurrentPreviousValueImpl &&
            (identical(other.actual, actual) || other.actual == actual) &&
            (identical(other.anterior, anterior) ||
                other.anterior == anterior));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, actual, anterior);

  /// Create a copy of CurrentPreviousValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CurrentPreviousValueImplCopyWith<_$CurrentPreviousValueImpl>
  get copyWith =>
      __$$CurrentPreviousValueImplCopyWithImpl<_$CurrentPreviousValueImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CurrentPreviousValueImplToJson(this);
  }
}

abstract class _CurrentPreviousValue implements CurrentPreviousValue {
  const factory _CurrentPreviousValue({
    @JsonKey(fromJson: _parseNumericOrString) final num? actual,
    @JsonKey(fromJson: _parseNumericOrString) final num? anterior,
  }) = _$CurrentPreviousValueImpl;

  factory _CurrentPreviousValue.fromJson(Map<String, dynamic> json) =
      _$CurrentPreviousValueImpl.fromJson;

  @override
  @JsonKey(fromJson: _parseNumericOrString)
  num? get actual;
  @override
  @JsonKey(fromJson: _parseNumericOrString)
  num? get anterior;

  /// Create a copy of CurrentPreviousValue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CurrentPreviousValueImplCopyWith<_$CurrentPreviousValueImpl>
  get copyWith => throw _privateConstructorUsedError;
}

ActiveTimeDetail _$ActiveTimeDetailFromJson(Map<String, dynamic> json) {
  return _ActiveTimeDetail.fromJson(json);
}

/// @nodoc
mixin _$ActiveTimeDetail {
  @JsonKey(name: 'total_minutos')
  num? get totalMinutos => throw _privateConstructorUsedError;
  @JsonKey(name: 'sesiones_completadas')
  num? get sesionesCompletadas => throw _privateConstructorUsedError;
  @JsonKey(name: 'sesiones_totales')
  num? get sesionesTotales => throw _privateConstructorUsedError;
  @JsonKey(name: 'diferencia_sesiones')
  num? get diferenciaSesiones => throw _privateConstructorUsedError;

  /// Serializes this ActiveTimeDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActiveTimeDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActiveTimeDetailCopyWith<ActiveTimeDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActiveTimeDetailCopyWith<$Res> {
  factory $ActiveTimeDetailCopyWith(
    ActiveTimeDetail value,
    $Res Function(ActiveTimeDetail) then,
  ) = _$ActiveTimeDetailCopyWithImpl<$Res, ActiveTimeDetail>;
  @useResult
  $Res call({
    @JsonKey(name: 'total_minutos') num? totalMinutos,
    @JsonKey(name: 'sesiones_completadas') num? sesionesCompletadas,
    @JsonKey(name: 'sesiones_totales') num? sesionesTotales,
    @JsonKey(name: 'diferencia_sesiones') num? diferenciaSesiones,
  });
}

/// @nodoc
class _$ActiveTimeDetailCopyWithImpl<$Res, $Val extends ActiveTimeDetail>
    implements $ActiveTimeDetailCopyWith<$Res> {
  _$ActiveTimeDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActiveTimeDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalMinutos = freezed,
    Object? sesionesCompletadas = freezed,
    Object? sesionesTotales = freezed,
    Object? diferenciaSesiones = freezed,
  }) {
    return _then(
      _value.copyWith(
            totalMinutos: freezed == totalMinutos
                ? _value.totalMinutos
                : totalMinutos // ignore: cast_nullable_to_non_nullable
                      as num?,
            sesionesCompletadas: freezed == sesionesCompletadas
                ? _value.sesionesCompletadas
                : sesionesCompletadas // ignore: cast_nullable_to_non_nullable
                      as num?,
            sesionesTotales: freezed == sesionesTotales
                ? _value.sesionesTotales
                : sesionesTotales // ignore: cast_nullable_to_non_nullable
                      as num?,
            diferenciaSesiones: freezed == diferenciaSesiones
                ? _value.diferenciaSesiones
                : diferenciaSesiones // ignore: cast_nullable_to_non_nullable
                      as num?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ActiveTimeDetailImplCopyWith<$Res>
    implements $ActiveTimeDetailCopyWith<$Res> {
  factory _$$ActiveTimeDetailImplCopyWith(
    _$ActiveTimeDetailImpl value,
    $Res Function(_$ActiveTimeDetailImpl) then,
  ) = __$$ActiveTimeDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'total_minutos') num? totalMinutos,
    @JsonKey(name: 'sesiones_completadas') num? sesionesCompletadas,
    @JsonKey(name: 'sesiones_totales') num? sesionesTotales,
    @JsonKey(name: 'diferencia_sesiones') num? diferenciaSesiones,
  });
}

/// @nodoc
class __$$ActiveTimeDetailImplCopyWithImpl<$Res>
    extends _$ActiveTimeDetailCopyWithImpl<$Res, _$ActiveTimeDetailImpl>
    implements _$$ActiveTimeDetailImplCopyWith<$Res> {
  __$$ActiveTimeDetailImplCopyWithImpl(
    _$ActiveTimeDetailImpl _value,
    $Res Function(_$ActiveTimeDetailImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ActiveTimeDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalMinutos = freezed,
    Object? sesionesCompletadas = freezed,
    Object? sesionesTotales = freezed,
    Object? diferenciaSesiones = freezed,
  }) {
    return _then(
      _$ActiveTimeDetailImpl(
        totalMinutos: freezed == totalMinutos
            ? _value.totalMinutos
            : totalMinutos // ignore: cast_nullable_to_non_nullable
                  as num?,
        sesionesCompletadas: freezed == sesionesCompletadas
            ? _value.sesionesCompletadas
            : sesionesCompletadas // ignore: cast_nullable_to_non_nullable
                  as num?,
        sesionesTotales: freezed == sesionesTotales
            ? _value.sesionesTotales
            : sesionesTotales // ignore: cast_nullable_to_non_nullable
                  as num?,
        diferenciaSesiones: freezed == diferenciaSesiones
            ? _value.diferenciaSesiones
            : diferenciaSesiones // ignore: cast_nullable_to_non_nullable
                  as num?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ActiveTimeDetailImpl implements _ActiveTimeDetail {
  const _$ActiveTimeDetailImpl({
    @JsonKey(name: 'total_minutos') this.totalMinutos,
    @JsonKey(name: 'sesiones_completadas') this.sesionesCompletadas,
    @JsonKey(name: 'sesiones_totales') this.sesionesTotales,
    @JsonKey(name: 'diferencia_sesiones') this.diferenciaSesiones,
  });

  factory _$ActiveTimeDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActiveTimeDetailImplFromJson(json);

  @override
  @JsonKey(name: 'total_minutos')
  final num? totalMinutos;
  @override
  @JsonKey(name: 'sesiones_completadas')
  final num? sesionesCompletadas;
  @override
  @JsonKey(name: 'sesiones_totales')
  final num? sesionesTotales;
  @override
  @JsonKey(name: 'diferencia_sesiones')
  final num? diferenciaSesiones;

  @override
  String toString() {
    return 'ActiveTimeDetail(totalMinutos: $totalMinutos, sesionesCompletadas: $sesionesCompletadas, sesionesTotales: $sesionesTotales, diferenciaSesiones: $diferenciaSesiones)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActiveTimeDetailImpl &&
            (identical(other.totalMinutos, totalMinutos) ||
                other.totalMinutos == totalMinutos) &&
            (identical(other.sesionesCompletadas, sesionesCompletadas) ||
                other.sesionesCompletadas == sesionesCompletadas) &&
            (identical(other.sesionesTotales, sesionesTotales) ||
                other.sesionesTotales == sesionesTotales) &&
            (identical(other.diferenciaSesiones, diferenciaSesiones) ||
                other.diferenciaSesiones == diferenciaSesiones));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalMinutos,
    sesionesCompletadas,
    sesionesTotales,
    diferenciaSesiones,
  );

  /// Create a copy of ActiveTimeDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActiveTimeDetailImplCopyWith<_$ActiveTimeDetailImpl> get copyWith =>
      __$$ActiveTimeDetailImplCopyWithImpl<_$ActiveTimeDetailImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ActiveTimeDetailImplToJson(this);
  }
}

abstract class _ActiveTimeDetail implements ActiveTimeDetail {
  const factory _ActiveTimeDetail({
    @JsonKey(name: 'total_minutos') final num? totalMinutos,
    @JsonKey(name: 'sesiones_completadas') final num? sesionesCompletadas,
    @JsonKey(name: 'sesiones_totales') final num? sesionesTotales,
    @JsonKey(name: 'diferencia_sesiones') final num? diferenciaSesiones,
  }) = _$ActiveTimeDetailImpl;

  factory _ActiveTimeDetail.fromJson(Map<String, dynamic> json) =
      _$ActiveTimeDetailImpl.fromJson;

  @override
  @JsonKey(name: 'total_minutos')
  num? get totalMinutos;
  @override
  @JsonKey(name: 'sesiones_completadas')
  num? get sesionesCompletadas;
  @override
  @JsonKey(name: 'sesiones_totales')
  num? get sesionesTotales;
  @override
  @JsonKey(name: 'diferencia_sesiones')
  num? get diferenciaSesiones;

  /// Create a copy of ActiveTimeDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActiveTimeDetailImplCopyWith<_$ActiveTimeDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SecondaryMetrics _$SecondaryMetricsFromJson(Map<String, dynamic> json) {
  return _SecondaryMetrics.fromJson(json);
}

/// @nodoc
mixin _$SecondaryMetrics {
  SecondaryMetricValues? get actual => throw _privateConstructorUsedError;
  SecondaryMetricValues? get anterior => throw _privateConstructorUsedError;

  /// Serializes this SecondaryMetrics to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SecondaryMetrics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SecondaryMetricsCopyWith<SecondaryMetrics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SecondaryMetricsCopyWith<$Res> {
  factory $SecondaryMetricsCopyWith(
    SecondaryMetrics value,
    $Res Function(SecondaryMetrics) then,
  ) = _$SecondaryMetricsCopyWithImpl<$Res, SecondaryMetrics>;
  @useResult
  $Res call({SecondaryMetricValues? actual, SecondaryMetricValues? anterior});

  $SecondaryMetricValuesCopyWith<$Res>? get actual;
  $SecondaryMetricValuesCopyWith<$Res>? get anterior;
}

/// @nodoc
class _$SecondaryMetricsCopyWithImpl<$Res, $Val extends SecondaryMetrics>
    implements $SecondaryMetricsCopyWith<$Res> {
  _$SecondaryMetricsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SecondaryMetrics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? actual = freezed, Object? anterior = freezed}) {
    return _then(
      _value.copyWith(
            actual: freezed == actual
                ? _value.actual
                : actual // ignore: cast_nullable_to_non_nullable
                      as SecondaryMetricValues?,
            anterior: freezed == anterior
                ? _value.anterior
                : anterior // ignore: cast_nullable_to_non_nullable
                      as SecondaryMetricValues?,
          )
          as $Val,
    );
  }

  /// Create a copy of SecondaryMetrics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SecondaryMetricValuesCopyWith<$Res>? get actual {
    if (_value.actual == null) {
      return null;
    }

    return $SecondaryMetricValuesCopyWith<$Res>(_value.actual!, (value) {
      return _then(_value.copyWith(actual: value) as $Val);
    });
  }

  /// Create a copy of SecondaryMetrics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SecondaryMetricValuesCopyWith<$Res>? get anterior {
    if (_value.anterior == null) {
      return null;
    }

    return $SecondaryMetricValuesCopyWith<$Res>(_value.anterior!, (value) {
      return _then(_value.copyWith(anterior: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SecondaryMetricsImplCopyWith<$Res>
    implements $SecondaryMetricsCopyWith<$Res> {
  factory _$$SecondaryMetricsImplCopyWith(
    _$SecondaryMetricsImpl value,
    $Res Function(_$SecondaryMetricsImpl) then,
  ) = __$$SecondaryMetricsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({SecondaryMetricValues? actual, SecondaryMetricValues? anterior});

  @override
  $SecondaryMetricValuesCopyWith<$Res>? get actual;
  @override
  $SecondaryMetricValuesCopyWith<$Res>? get anterior;
}

/// @nodoc
class __$$SecondaryMetricsImplCopyWithImpl<$Res>
    extends _$SecondaryMetricsCopyWithImpl<$Res, _$SecondaryMetricsImpl>
    implements _$$SecondaryMetricsImplCopyWith<$Res> {
  __$$SecondaryMetricsImplCopyWithImpl(
    _$SecondaryMetricsImpl _value,
    $Res Function(_$SecondaryMetricsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SecondaryMetrics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? actual = freezed, Object? anterior = freezed}) {
    return _then(
      _$SecondaryMetricsImpl(
        actual: freezed == actual
            ? _value.actual
            : actual // ignore: cast_nullable_to_non_nullable
                  as SecondaryMetricValues?,
        anterior: freezed == anterior
            ? _value.anterior
            : anterior // ignore: cast_nullable_to_non_nullable
                  as SecondaryMetricValues?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SecondaryMetricsImpl implements _SecondaryMetrics {
  const _$SecondaryMetricsImpl({this.actual, this.anterior});

  factory _$SecondaryMetricsImpl.fromJson(Map<String, dynamic> json) =>
      _$$SecondaryMetricsImplFromJson(json);

  @override
  final SecondaryMetricValues? actual;
  @override
  final SecondaryMetricValues? anterior;

  @override
  String toString() {
    return 'SecondaryMetrics(actual: $actual, anterior: $anterior)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SecondaryMetricsImpl &&
            (identical(other.actual, actual) || other.actual == actual) &&
            (identical(other.anterior, anterior) ||
                other.anterior == anterior));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, actual, anterior);

  /// Create a copy of SecondaryMetrics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SecondaryMetricsImplCopyWith<_$SecondaryMetricsImpl> get copyWith =>
      __$$SecondaryMetricsImplCopyWithImpl<_$SecondaryMetricsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SecondaryMetricsImplToJson(this);
  }
}

abstract class _SecondaryMetrics implements SecondaryMetrics {
  const factory _SecondaryMetrics({
    final SecondaryMetricValues? actual,
    final SecondaryMetricValues? anterior,
  }) = _$SecondaryMetricsImpl;

  factory _SecondaryMetrics.fromJson(Map<String, dynamic> json) =
      _$SecondaryMetricsImpl.fromJson;

  @override
  SecondaryMetricValues? get actual;
  @override
  SecondaryMetricValues? get anterior;

  /// Create a copy of SecondaryMetrics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SecondaryMetricsImplCopyWith<_$SecondaryMetricsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SecondaryMetricValues _$SecondaryMetricValuesFromJson(
  Map<String, dynamic> json,
) {
  return _SecondaryMetricValues.fromJson(json);
}

/// @nodoc
mixin _$SecondaryMetricValues {
  @JsonKey(name: 'deficit_hidrico')
  num? get deficitHidrico => throw _privateConstructorUsedError;
  @JsonKey(name: 'vo2_max')
  num? get vo2Max => throw _privateConstructorUsedError;

  /// Serializes this SecondaryMetricValues to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SecondaryMetricValues
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SecondaryMetricValuesCopyWith<SecondaryMetricValues> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SecondaryMetricValuesCopyWith<$Res> {
  factory $SecondaryMetricValuesCopyWith(
    SecondaryMetricValues value,
    $Res Function(SecondaryMetricValues) then,
  ) = _$SecondaryMetricValuesCopyWithImpl<$Res, SecondaryMetricValues>;
  @useResult
  $Res call({
    @JsonKey(name: 'deficit_hidrico') num? deficitHidrico,
    @JsonKey(name: 'vo2_max') num? vo2Max,
  });
}

/// @nodoc
class _$SecondaryMetricValuesCopyWithImpl<
  $Res,
  $Val extends SecondaryMetricValues
>
    implements $SecondaryMetricValuesCopyWith<$Res> {
  _$SecondaryMetricValuesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SecondaryMetricValues
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? deficitHidrico = freezed, Object? vo2Max = freezed}) {
    return _then(
      _value.copyWith(
            deficitHidrico: freezed == deficitHidrico
                ? _value.deficitHidrico
                : deficitHidrico // ignore: cast_nullable_to_non_nullable
                      as num?,
            vo2Max: freezed == vo2Max
                ? _value.vo2Max
                : vo2Max // ignore: cast_nullable_to_non_nullable
                      as num?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SecondaryMetricValuesImplCopyWith<$Res>
    implements $SecondaryMetricValuesCopyWith<$Res> {
  factory _$$SecondaryMetricValuesImplCopyWith(
    _$SecondaryMetricValuesImpl value,
    $Res Function(_$SecondaryMetricValuesImpl) then,
  ) = __$$SecondaryMetricValuesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'deficit_hidrico') num? deficitHidrico,
    @JsonKey(name: 'vo2_max') num? vo2Max,
  });
}

/// @nodoc
class __$$SecondaryMetricValuesImplCopyWithImpl<$Res>
    extends
        _$SecondaryMetricValuesCopyWithImpl<$Res, _$SecondaryMetricValuesImpl>
    implements _$$SecondaryMetricValuesImplCopyWith<$Res> {
  __$$SecondaryMetricValuesImplCopyWithImpl(
    _$SecondaryMetricValuesImpl _value,
    $Res Function(_$SecondaryMetricValuesImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SecondaryMetricValues
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? deficitHidrico = freezed, Object? vo2Max = freezed}) {
    return _then(
      _$SecondaryMetricValuesImpl(
        deficitHidrico: freezed == deficitHidrico
            ? _value.deficitHidrico
            : deficitHidrico // ignore: cast_nullable_to_non_nullable
                  as num?,
        vo2Max: freezed == vo2Max
            ? _value.vo2Max
            : vo2Max // ignore: cast_nullable_to_non_nullable
                  as num?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SecondaryMetricValuesImpl implements _SecondaryMetricValues {
  const _$SecondaryMetricValuesImpl({
    @JsonKey(name: 'deficit_hidrico') this.deficitHidrico,
    @JsonKey(name: 'vo2_max') this.vo2Max,
  });

  factory _$SecondaryMetricValuesImpl.fromJson(Map<String, dynamic> json) =>
      _$$SecondaryMetricValuesImplFromJson(json);

  @override
  @JsonKey(name: 'deficit_hidrico')
  final num? deficitHidrico;
  @override
  @JsonKey(name: 'vo2_max')
  final num? vo2Max;

  @override
  String toString() {
    return 'SecondaryMetricValues(deficitHidrico: $deficitHidrico, vo2Max: $vo2Max)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SecondaryMetricValuesImpl &&
            (identical(other.deficitHidrico, deficitHidrico) ||
                other.deficitHidrico == deficitHidrico) &&
            (identical(other.vo2Max, vo2Max) || other.vo2Max == vo2Max));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, deficitHidrico, vo2Max);

  /// Create a copy of SecondaryMetricValues
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SecondaryMetricValuesImplCopyWith<_$SecondaryMetricValuesImpl>
  get copyWith =>
      __$$SecondaryMetricValuesImplCopyWithImpl<_$SecondaryMetricValuesImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SecondaryMetricValuesImplToJson(this);
  }
}

abstract class _SecondaryMetricValues implements SecondaryMetricValues {
  const factory _SecondaryMetricValues({
    @JsonKey(name: 'deficit_hidrico') final num? deficitHidrico,
    @JsonKey(name: 'vo2_max') final num? vo2Max,
  }) = _$SecondaryMetricValuesImpl;

  factory _SecondaryMetricValues.fromJson(Map<String, dynamic> json) =
      _$SecondaryMetricValuesImpl.fromJson;

  @override
  @JsonKey(name: 'deficit_hidrico')
  num? get deficitHidrico;
  @override
  @JsonKey(name: 'vo2_max')
  num? get vo2Max;

  /// Create a copy of SecondaryMetricValues
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SecondaryMetricValuesImplCopyWith<_$SecondaryMetricValuesImpl>
  get copyWith => throw _privateConstructorUsedError;
}

WellnessIndexEvolution _$WellnessIndexEvolutionFromJson(
  Map<String, dynamic> json,
) {
  return _WellnessIndexEvolution.fromJson(json);
}

/// @nodoc
mixin _$WellnessIndexEvolution {
  String? get fecha => throw _privateConstructorUsedError;
  @JsonKey(name: 'semana_actual')
  num? get semanaActual => throw _privateConstructorUsedError;
  num? get puntaje => throw _privateConstructorUsedError;

  /// Serializes this WellnessIndexEvolution to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WellnessIndexEvolution
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WellnessIndexEvolutionCopyWith<WellnessIndexEvolution> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WellnessIndexEvolutionCopyWith<$Res> {
  factory $WellnessIndexEvolutionCopyWith(
    WellnessIndexEvolution value,
    $Res Function(WellnessIndexEvolution) then,
  ) = _$WellnessIndexEvolutionCopyWithImpl<$Res, WellnessIndexEvolution>;
  @useResult
  $Res call({
    String? fecha,
    @JsonKey(name: 'semana_actual') num? semanaActual,
    num? puntaje,
  });
}

/// @nodoc
class _$WellnessIndexEvolutionCopyWithImpl<
  $Res,
  $Val extends WellnessIndexEvolution
>
    implements $WellnessIndexEvolutionCopyWith<$Res> {
  _$WellnessIndexEvolutionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WellnessIndexEvolution
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fecha = freezed,
    Object? semanaActual = freezed,
    Object? puntaje = freezed,
  }) {
    return _then(
      _value.copyWith(
            fecha: freezed == fecha
                ? _value.fecha
                : fecha // ignore: cast_nullable_to_non_nullable
                      as String?,
            semanaActual: freezed == semanaActual
                ? _value.semanaActual
                : semanaActual // ignore: cast_nullable_to_non_nullable
                      as num?,
            puntaje: freezed == puntaje
                ? _value.puntaje
                : puntaje // ignore: cast_nullable_to_non_nullable
                      as num?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WellnessIndexEvolutionImplCopyWith<$Res>
    implements $WellnessIndexEvolutionCopyWith<$Res> {
  factory _$$WellnessIndexEvolutionImplCopyWith(
    _$WellnessIndexEvolutionImpl value,
    $Res Function(_$WellnessIndexEvolutionImpl) then,
  ) = __$$WellnessIndexEvolutionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? fecha,
    @JsonKey(name: 'semana_actual') num? semanaActual,
    num? puntaje,
  });
}

/// @nodoc
class __$$WellnessIndexEvolutionImplCopyWithImpl<$Res>
    extends
        _$WellnessIndexEvolutionCopyWithImpl<$Res, _$WellnessIndexEvolutionImpl>
    implements _$$WellnessIndexEvolutionImplCopyWith<$Res> {
  __$$WellnessIndexEvolutionImplCopyWithImpl(
    _$WellnessIndexEvolutionImpl _value,
    $Res Function(_$WellnessIndexEvolutionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WellnessIndexEvolution
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fecha = freezed,
    Object? semanaActual = freezed,
    Object? puntaje = freezed,
  }) {
    return _then(
      _$WellnessIndexEvolutionImpl(
        fecha: freezed == fecha
            ? _value.fecha
            : fecha // ignore: cast_nullable_to_non_nullable
                  as String?,
        semanaActual: freezed == semanaActual
            ? _value.semanaActual
            : semanaActual // ignore: cast_nullable_to_non_nullable
                  as num?,
        puntaje: freezed == puntaje
            ? _value.puntaje
            : puntaje // ignore: cast_nullable_to_non_nullable
                  as num?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WellnessIndexEvolutionImpl implements _WellnessIndexEvolution {
  const _$WellnessIndexEvolutionImpl({
    this.fecha,
    @JsonKey(name: 'semana_actual') this.semanaActual,
    this.puntaje,
  });

  factory _$WellnessIndexEvolutionImpl.fromJson(Map<String, dynamic> json) =>
      _$$WellnessIndexEvolutionImplFromJson(json);

  @override
  final String? fecha;
  @override
  @JsonKey(name: 'semana_actual')
  final num? semanaActual;
  @override
  final num? puntaje;

  @override
  String toString() {
    return 'WellnessIndexEvolution(fecha: $fecha, semanaActual: $semanaActual, puntaje: $puntaje)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WellnessIndexEvolutionImpl &&
            (identical(other.fecha, fecha) || other.fecha == fecha) &&
            (identical(other.semanaActual, semanaActual) ||
                other.semanaActual == semanaActual) &&
            (identical(other.puntaje, puntaje) || other.puntaje == puntaje));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, fecha, semanaActual, puntaje);

  /// Create a copy of WellnessIndexEvolution
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WellnessIndexEvolutionImplCopyWith<_$WellnessIndexEvolutionImpl>
  get copyWith =>
      __$$WellnessIndexEvolutionImplCopyWithImpl<_$WellnessIndexEvolutionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$WellnessIndexEvolutionImplToJson(this);
  }
}

abstract class _WellnessIndexEvolution implements WellnessIndexEvolution {
  const factory _WellnessIndexEvolution({
    final String? fecha,
    @JsonKey(name: 'semana_actual') final num? semanaActual,
    final num? puntaje,
  }) = _$WellnessIndexEvolutionImpl;

  factory _WellnessIndexEvolution.fromJson(Map<String, dynamic> json) =
      _$WellnessIndexEvolutionImpl.fromJson;

  @override
  String? get fecha;
  @override
  @JsonKey(name: 'semana_actual')
  num? get semanaActual;
  @override
  num? get puntaje;

  /// Create a copy of WellnessIndexEvolution
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WellnessIndexEvolutionImplCopyWith<_$WellnessIndexEvolutionImpl>
  get copyWith => throw _privateConstructorUsedError;
}

WeightHistory _$WeightHistoryFromJson(Map<String, dynamic> json) {
  return _WeightHistory.fromJson(json);
}

/// @nodoc
mixin _$WeightHistory {
  num? get semana => throw _privateConstructorUsedError;
  String? get fecha => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseNumericOrString)
  num? get peso => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseNumericOrString)
  num? get musculo => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseNumericOrString)
  num? get grasa => throw _privateConstructorUsedError;

  /// Serializes this WeightHistory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WeightHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WeightHistoryCopyWith<WeightHistory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeightHistoryCopyWith<$Res> {
  factory $WeightHistoryCopyWith(
    WeightHistory value,
    $Res Function(WeightHistory) then,
  ) = _$WeightHistoryCopyWithImpl<$Res, WeightHistory>;
  @useResult
  $Res call({
    num? semana,
    String? fecha,
    @JsonKey(fromJson: _parseNumericOrString) num? peso,
    @JsonKey(fromJson: _parseNumericOrString) num? musculo,
    @JsonKey(fromJson: _parseNumericOrString) num? grasa,
  });
}

/// @nodoc
class _$WeightHistoryCopyWithImpl<$Res, $Val extends WeightHistory>
    implements $WeightHistoryCopyWith<$Res> {
  _$WeightHistoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WeightHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? semana = freezed,
    Object? fecha = freezed,
    Object? peso = freezed,
    Object? musculo = freezed,
    Object? grasa = freezed,
  }) {
    return _then(
      _value.copyWith(
            semana: freezed == semana
                ? _value.semana
                : semana // ignore: cast_nullable_to_non_nullable
                      as num?,
            fecha: freezed == fecha
                ? _value.fecha
                : fecha // ignore: cast_nullable_to_non_nullable
                      as String?,
            peso: freezed == peso
                ? _value.peso
                : peso // ignore: cast_nullable_to_non_nullable
                      as num?,
            musculo: freezed == musculo
                ? _value.musculo
                : musculo // ignore: cast_nullable_to_non_nullable
                      as num?,
            grasa: freezed == grasa
                ? _value.grasa
                : grasa // ignore: cast_nullable_to_non_nullable
                      as num?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WeightHistoryImplCopyWith<$Res>
    implements $WeightHistoryCopyWith<$Res> {
  factory _$$WeightHistoryImplCopyWith(
    _$WeightHistoryImpl value,
    $Res Function(_$WeightHistoryImpl) then,
  ) = __$$WeightHistoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    num? semana,
    String? fecha,
    @JsonKey(fromJson: _parseNumericOrString) num? peso,
    @JsonKey(fromJson: _parseNumericOrString) num? musculo,
    @JsonKey(fromJson: _parseNumericOrString) num? grasa,
  });
}

/// @nodoc
class __$$WeightHistoryImplCopyWithImpl<$Res>
    extends _$WeightHistoryCopyWithImpl<$Res, _$WeightHistoryImpl>
    implements _$$WeightHistoryImplCopyWith<$Res> {
  __$$WeightHistoryImplCopyWithImpl(
    _$WeightHistoryImpl _value,
    $Res Function(_$WeightHistoryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WeightHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? semana = freezed,
    Object? fecha = freezed,
    Object? peso = freezed,
    Object? musculo = freezed,
    Object? grasa = freezed,
  }) {
    return _then(
      _$WeightHistoryImpl(
        semana: freezed == semana
            ? _value.semana
            : semana // ignore: cast_nullable_to_non_nullable
                  as num?,
        fecha: freezed == fecha
            ? _value.fecha
            : fecha // ignore: cast_nullable_to_non_nullable
                  as String?,
        peso: freezed == peso
            ? _value.peso
            : peso // ignore: cast_nullable_to_non_nullable
                  as num?,
        musculo: freezed == musculo
            ? _value.musculo
            : musculo // ignore: cast_nullable_to_non_nullable
                  as num?,
        grasa: freezed == grasa
            ? _value.grasa
            : grasa // ignore: cast_nullable_to_non_nullable
                  as num?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WeightHistoryImpl implements _WeightHistory {
  const _$WeightHistoryImpl({
    this.semana,
    this.fecha,
    @JsonKey(fromJson: _parseNumericOrString) this.peso,
    @JsonKey(fromJson: _parseNumericOrString) this.musculo,
    @JsonKey(fromJson: _parseNumericOrString) this.grasa,
  });

  factory _$WeightHistoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$WeightHistoryImplFromJson(json);

  @override
  final num? semana;
  @override
  final String? fecha;
  @override
  @JsonKey(fromJson: _parseNumericOrString)
  final num? peso;
  @override
  @JsonKey(fromJson: _parseNumericOrString)
  final num? musculo;
  @override
  @JsonKey(fromJson: _parseNumericOrString)
  final num? grasa;

  @override
  String toString() {
    return 'WeightHistory(semana: $semana, fecha: $fecha, peso: $peso, musculo: $musculo, grasa: $grasa)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeightHistoryImpl &&
            (identical(other.semana, semana) || other.semana == semana) &&
            (identical(other.fecha, fecha) || other.fecha == fecha) &&
            (identical(other.peso, peso) || other.peso == peso) &&
            (identical(other.musculo, musculo) || other.musculo == musculo) &&
            (identical(other.grasa, grasa) || other.grasa == grasa));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, semana, fecha, peso, musculo, grasa);

  /// Create a copy of WeightHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WeightHistoryImplCopyWith<_$WeightHistoryImpl> get copyWith =>
      __$$WeightHistoryImplCopyWithImpl<_$WeightHistoryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WeightHistoryImplToJson(this);
  }
}

abstract class _WeightHistory implements WeightHistory {
  const factory _WeightHistory({
    final num? semana,
    final String? fecha,
    @JsonKey(fromJson: _parseNumericOrString) final num? peso,
    @JsonKey(fromJson: _parseNumericOrString) final num? musculo,
    @JsonKey(fromJson: _parseNumericOrString) final num? grasa,
  }) = _$WeightHistoryImpl;

  factory _WeightHistory.fromJson(Map<String, dynamic> json) =
      _$WeightHistoryImpl.fromJson;

  @override
  num? get semana;
  @override
  String? get fecha;
  @override
  @JsonKey(fromJson: _parseNumericOrString)
  num? get peso;
  @override
  @JsonKey(fromJson: _parseNumericOrString)
  num? get musculo;
  @override
  @JsonKey(fromJson: _parseNumericOrString)
  num? get grasa;

  /// Create a copy of WeightHistory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WeightHistoryImplCopyWith<_$WeightHistoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CaloriasDetail _$CaloriasDetailFromJson(Map<String, dynamic> json) {
  return _CaloriasDetail.fromJson(json);
}

/// @nodoc
mixin _$CaloriasDetail {
  @JsonKey(name: 'calorias_act')
  num? get caloriasAct => throw _privateConstructorUsedError;
  @JsonKey(name: 'calorias_ant')
  num? get caloriasAnt => throw _privateConstructorUsedError;
  num? get diferencia => throw _privateConstructorUsedError;

  /// Serializes this CaloriasDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CaloriasDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CaloriasDetailCopyWith<CaloriasDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CaloriasDetailCopyWith<$Res> {
  factory $CaloriasDetailCopyWith(
    CaloriasDetail value,
    $Res Function(CaloriasDetail) then,
  ) = _$CaloriasDetailCopyWithImpl<$Res, CaloriasDetail>;
  @useResult
  $Res call({
    @JsonKey(name: 'calorias_act') num? caloriasAct,
    @JsonKey(name: 'calorias_ant') num? caloriasAnt,
    num? diferencia,
  });
}

/// @nodoc
class _$CaloriasDetailCopyWithImpl<$Res, $Val extends CaloriasDetail>
    implements $CaloriasDetailCopyWith<$Res> {
  _$CaloriasDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CaloriasDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? caloriasAct = freezed,
    Object? caloriasAnt = freezed,
    Object? diferencia = freezed,
  }) {
    return _then(
      _value.copyWith(
            caloriasAct: freezed == caloriasAct
                ? _value.caloriasAct
                : caloriasAct // ignore: cast_nullable_to_non_nullable
                      as num?,
            caloriasAnt: freezed == caloriasAnt
                ? _value.caloriasAnt
                : caloriasAnt // ignore: cast_nullable_to_non_nullable
                      as num?,
            diferencia: freezed == diferencia
                ? _value.diferencia
                : diferencia // ignore: cast_nullable_to_non_nullable
                      as num?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CaloriasDetailImplCopyWith<$Res>
    implements $CaloriasDetailCopyWith<$Res> {
  factory _$$CaloriasDetailImplCopyWith(
    _$CaloriasDetailImpl value,
    $Res Function(_$CaloriasDetailImpl) then,
  ) = __$$CaloriasDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'calorias_act') num? caloriasAct,
    @JsonKey(name: 'calorias_ant') num? caloriasAnt,
    num? diferencia,
  });
}

/// @nodoc
class __$$CaloriasDetailImplCopyWithImpl<$Res>
    extends _$CaloriasDetailCopyWithImpl<$Res, _$CaloriasDetailImpl>
    implements _$$CaloriasDetailImplCopyWith<$Res> {
  __$$CaloriasDetailImplCopyWithImpl(
    _$CaloriasDetailImpl _value,
    $Res Function(_$CaloriasDetailImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CaloriasDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? caloriasAct = freezed,
    Object? caloriasAnt = freezed,
    Object? diferencia = freezed,
  }) {
    return _then(
      _$CaloriasDetailImpl(
        caloriasAct: freezed == caloriasAct
            ? _value.caloriasAct
            : caloriasAct // ignore: cast_nullable_to_non_nullable
                  as num?,
        caloriasAnt: freezed == caloriasAnt
            ? _value.caloriasAnt
            : caloriasAnt // ignore: cast_nullable_to_non_nullable
                  as num?,
        diferencia: freezed == diferencia
            ? _value.diferencia
            : diferencia // ignore: cast_nullable_to_non_nullable
                  as num?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CaloriasDetailImpl implements _CaloriasDetail {
  const _$CaloriasDetailImpl({
    @JsonKey(name: 'calorias_act') this.caloriasAct,
    @JsonKey(name: 'calorias_ant') this.caloriasAnt,
    this.diferencia,
  });

  factory _$CaloriasDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$CaloriasDetailImplFromJson(json);

  @override
  @JsonKey(name: 'calorias_act')
  final num? caloriasAct;
  @override
  @JsonKey(name: 'calorias_ant')
  final num? caloriasAnt;
  @override
  final num? diferencia;

  @override
  String toString() {
    return 'CaloriasDetail(caloriasAct: $caloriasAct, caloriasAnt: $caloriasAnt, diferencia: $diferencia)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CaloriasDetailImpl &&
            (identical(other.caloriasAct, caloriasAct) ||
                other.caloriasAct == caloriasAct) &&
            (identical(other.caloriasAnt, caloriasAnt) ||
                other.caloriasAnt == caloriasAnt) &&
            (identical(other.diferencia, diferencia) ||
                other.diferencia == diferencia));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, caloriasAct, caloriasAnt, diferencia);

  /// Create a copy of CaloriasDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CaloriasDetailImplCopyWith<_$CaloriasDetailImpl> get copyWith =>
      __$$CaloriasDetailImplCopyWithImpl<_$CaloriasDetailImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CaloriasDetailImplToJson(this);
  }
}

abstract class _CaloriasDetail implements CaloriasDetail {
  const factory _CaloriasDetail({
    @JsonKey(name: 'calorias_act') final num? caloriasAct,
    @JsonKey(name: 'calorias_ant') final num? caloriasAnt,
    final num? diferencia,
  }) = _$CaloriasDetailImpl;

  factory _CaloriasDetail.fromJson(Map<String, dynamic> json) =
      _$CaloriasDetailImpl.fromJson;

  @override
  @JsonKey(name: 'calorias_act')
  num? get caloriasAct;
  @override
  @JsonKey(name: 'calorias_ant')
  num? get caloriasAnt;
  @override
  num? get diferencia;

  /// Create a copy of CaloriasDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CaloriasDetailImplCopyWith<_$CaloriasDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ZonasEsfuerzo _$ZonasEsfuerzoFromJson(Map<String, dynamic> json) {
  return _ZonasEsfuerzo.fromJson(json);
}

/// @nodoc
mixin _$ZonasEsfuerzo {
  @JsonKey(name: 'fc_max')
  num? get fcMax => throw _privateConstructorUsedError;
  @JsonKey(name: 'fc_reposo_utilizada')
  num? get fcReposoUtilizada => throw _privateConstructorUsedError;
  @JsonKey(name: 'fc_reserva')
  num? get fcReserva => throw _privateConstructorUsedError;
  @JsonKey(name: 'rangos_fc')
  RangosFc? get rangosFc => throw _privateConstructorUsedError;

  /// Serializes this ZonasEsfuerzo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ZonasEsfuerzo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ZonasEsfuerzoCopyWith<ZonasEsfuerzo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ZonasEsfuerzoCopyWith<$Res> {
  factory $ZonasEsfuerzoCopyWith(
    ZonasEsfuerzo value,
    $Res Function(ZonasEsfuerzo) then,
  ) = _$ZonasEsfuerzoCopyWithImpl<$Res, ZonasEsfuerzo>;
  @useResult
  $Res call({
    @JsonKey(name: 'fc_max') num? fcMax,
    @JsonKey(name: 'fc_reposo_utilizada') num? fcReposoUtilizada,
    @JsonKey(name: 'fc_reserva') num? fcReserva,
    @JsonKey(name: 'rangos_fc') RangosFc? rangosFc,
  });

  $RangosFcCopyWith<$Res>? get rangosFc;
}

/// @nodoc
class _$ZonasEsfuerzoCopyWithImpl<$Res, $Val extends ZonasEsfuerzo>
    implements $ZonasEsfuerzoCopyWith<$Res> {
  _$ZonasEsfuerzoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ZonasEsfuerzo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fcMax = freezed,
    Object? fcReposoUtilizada = freezed,
    Object? fcReserva = freezed,
    Object? rangosFc = freezed,
  }) {
    return _then(
      _value.copyWith(
            fcMax: freezed == fcMax
                ? _value.fcMax
                : fcMax // ignore: cast_nullable_to_non_nullable
                      as num?,
            fcReposoUtilizada: freezed == fcReposoUtilizada
                ? _value.fcReposoUtilizada
                : fcReposoUtilizada // ignore: cast_nullable_to_non_nullable
                      as num?,
            fcReserva: freezed == fcReserva
                ? _value.fcReserva
                : fcReserva // ignore: cast_nullable_to_non_nullable
                      as num?,
            rangosFc: freezed == rangosFc
                ? _value.rangosFc
                : rangosFc // ignore: cast_nullable_to_non_nullable
                      as RangosFc?,
          )
          as $Val,
    );
  }

  /// Create a copy of ZonasEsfuerzo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RangosFcCopyWith<$Res>? get rangosFc {
    if (_value.rangosFc == null) {
      return null;
    }

    return $RangosFcCopyWith<$Res>(_value.rangosFc!, (value) {
      return _then(_value.copyWith(rangosFc: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ZonasEsfuerzoImplCopyWith<$Res>
    implements $ZonasEsfuerzoCopyWith<$Res> {
  factory _$$ZonasEsfuerzoImplCopyWith(
    _$ZonasEsfuerzoImpl value,
    $Res Function(_$ZonasEsfuerzoImpl) then,
  ) = __$$ZonasEsfuerzoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'fc_max') num? fcMax,
    @JsonKey(name: 'fc_reposo_utilizada') num? fcReposoUtilizada,
    @JsonKey(name: 'fc_reserva') num? fcReserva,
    @JsonKey(name: 'rangos_fc') RangosFc? rangosFc,
  });

  @override
  $RangosFcCopyWith<$Res>? get rangosFc;
}

/// @nodoc
class __$$ZonasEsfuerzoImplCopyWithImpl<$Res>
    extends _$ZonasEsfuerzoCopyWithImpl<$Res, _$ZonasEsfuerzoImpl>
    implements _$$ZonasEsfuerzoImplCopyWith<$Res> {
  __$$ZonasEsfuerzoImplCopyWithImpl(
    _$ZonasEsfuerzoImpl _value,
    $Res Function(_$ZonasEsfuerzoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ZonasEsfuerzo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fcMax = freezed,
    Object? fcReposoUtilizada = freezed,
    Object? fcReserva = freezed,
    Object? rangosFc = freezed,
  }) {
    return _then(
      _$ZonasEsfuerzoImpl(
        fcMax: freezed == fcMax
            ? _value.fcMax
            : fcMax // ignore: cast_nullable_to_non_nullable
                  as num?,
        fcReposoUtilizada: freezed == fcReposoUtilizada
            ? _value.fcReposoUtilizada
            : fcReposoUtilizada // ignore: cast_nullable_to_non_nullable
                  as num?,
        fcReserva: freezed == fcReserva
            ? _value.fcReserva
            : fcReserva // ignore: cast_nullable_to_non_nullable
                  as num?,
        rangosFc: freezed == rangosFc
            ? _value.rangosFc
            : rangosFc // ignore: cast_nullable_to_non_nullable
                  as RangosFc?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ZonasEsfuerzoImpl implements _ZonasEsfuerzo {
  const _$ZonasEsfuerzoImpl({
    @JsonKey(name: 'fc_max') this.fcMax,
    @JsonKey(name: 'fc_reposo_utilizada') this.fcReposoUtilizada,
    @JsonKey(name: 'fc_reserva') this.fcReserva,
    @JsonKey(name: 'rangos_fc') this.rangosFc,
  });

  factory _$ZonasEsfuerzoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ZonasEsfuerzoImplFromJson(json);

  @override
  @JsonKey(name: 'fc_max')
  final num? fcMax;
  @override
  @JsonKey(name: 'fc_reposo_utilizada')
  final num? fcReposoUtilizada;
  @override
  @JsonKey(name: 'fc_reserva')
  final num? fcReserva;
  @override
  @JsonKey(name: 'rangos_fc')
  final RangosFc? rangosFc;

  @override
  String toString() {
    return 'ZonasEsfuerzo(fcMax: $fcMax, fcReposoUtilizada: $fcReposoUtilizada, fcReserva: $fcReserva, rangosFc: $rangosFc)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ZonasEsfuerzoImpl &&
            (identical(other.fcMax, fcMax) || other.fcMax == fcMax) &&
            (identical(other.fcReposoUtilizada, fcReposoUtilizada) ||
                other.fcReposoUtilizada == fcReposoUtilizada) &&
            (identical(other.fcReserva, fcReserva) ||
                other.fcReserva == fcReserva) &&
            (identical(other.rangosFc, rangosFc) ||
                other.rangosFc == rangosFc));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, fcMax, fcReposoUtilizada, fcReserva, rangosFc);

  /// Create a copy of ZonasEsfuerzo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ZonasEsfuerzoImplCopyWith<_$ZonasEsfuerzoImpl> get copyWith =>
      __$$ZonasEsfuerzoImplCopyWithImpl<_$ZonasEsfuerzoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ZonasEsfuerzoImplToJson(this);
  }
}

abstract class _ZonasEsfuerzo implements ZonasEsfuerzo {
  const factory _ZonasEsfuerzo({
    @JsonKey(name: 'fc_max') final num? fcMax,
    @JsonKey(name: 'fc_reposo_utilizada') final num? fcReposoUtilizada,
    @JsonKey(name: 'fc_reserva') final num? fcReserva,
    @JsonKey(name: 'rangos_fc') final RangosFc? rangosFc,
  }) = _$ZonasEsfuerzoImpl;

  factory _ZonasEsfuerzo.fromJson(Map<String, dynamic> json) =
      _$ZonasEsfuerzoImpl.fromJson;

  @override
  @JsonKey(name: 'fc_max')
  num? get fcMax;
  @override
  @JsonKey(name: 'fc_reposo_utilizada')
  num? get fcReposoUtilizada;
  @override
  @JsonKey(name: 'fc_reserva')
  num? get fcReserva;
  @override
  @JsonKey(name: 'rangos_fc')
  RangosFc? get rangosFc;

  /// Create a copy of ZonasEsfuerzo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ZonasEsfuerzoImplCopyWith<_$ZonasEsfuerzoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RangosFc _$RangosFcFromJson(Map<String, dynamic> json) {
  return _RangosFc.fromJson(json);
}

/// @nodoc
mixin _$RangosFc {
  @JsonKey(name: 'zona_1')
  ZonaRango? get zona1 => throw _privateConstructorUsedError;
  @JsonKey(name: 'zona_2')
  ZonaRango? get zona2 => throw _privateConstructorUsedError;
  @JsonKey(name: 'zona_3')
  ZonaRango? get zona3 => throw _privateConstructorUsedError;
  @JsonKey(name: 'zona_4')
  ZonaRango? get zona4 => throw _privateConstructorUsedError;
  @JsonKey(name: 'zona_5')
  ZonaRango? get zona5 => throw _privateConstructorUsedError;

  /// Serializes this RangosFc to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RangosFc
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RangosFcCopyWith<RangosFc> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RangosFcCopyWith<$Res> {
  factory $RangosFcCopyWith(RangosFc value, $Res Function(RangosFc) then) =
      _$RangosFcCopyWithImpl<$Res, RangosFc>;
  @useResult
  $Res call({
    @JsonKey(name: 'zona_1') ZonaRango? zona1,
    @JsonKey(name: 'zona_2') ZonaRango? zona2,
    @JsonKey(name: 'zona_3') ZonaRango? zona3,
    @JsonKey(name: 'zona_4') ZonaRango? zona4,
    @JsonKey(name: 'zona_5') ZonaRango? zona5,
  });

  $ZonaRangoCopyWith<$Res>? get zona1;
  $ZonaRangoCopyWith<$Res>? get zona2;
  $ZonaRangoCopyWith<$Res>? get zona3;
  $ZonaRangoCopyWith<$Res>? get zona4;
  $ZonaRangoCopyWith<$Res>? get zona5;
}

/// @nodoc
class _$RangosFcCopyWithImpl<$Res, $Val extends RangosFc>
    implements $RangosFcCopyWith<$Res> {
  _$RangosFcCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RangosFc
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? zona1 = freezed,
    Object? zona2 = freezed,
    Object? zona3 = freezed,
    Object? zona4 = freezed,
    Object? zona5 = freezed,
  }) {
    return _then(
      _value.copyWith(
            zona1: freezed == zona1
                ? _value.zona1
                : zona1 // ignore: cast_nullable_to_non_nullable
                      as ZonaRango?,
            zona2: freezed == zona2
                ? _value.zona2
                : zona2 // ignore: cast_nullable_to_non_nullable
                      as ZonaRango?,
            zona3: freezed == zona3
                ? _value.zona3
                : zona3 // ignore: cast_nullable_to_non_nullable
                      as ZonaRango?,
            zona4: freezed == zona4
                ? _value.zona4
                : zona4 // ignore: cast_nullable_to_non_nullable
                      as ZonaRango?,
            zona5: freezed == zona5
                ? _value.zona5
                : zona5 // ignore: cast_nullable_to_non_nullable
                      as ZonaRango?,
          )
          as $Val,
    );
  }

  /// Create a copy of RangosFc
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ZonaRangoCopyWith<$Res>? get zona1 {
    if (_value.zona1 == null) {
      return null;
    }

    return $ZonaRangoCopyWith<$Res>(_value.zona1!, (value) {
      return _then(_value.copyWith(zona1: value) as $Val);
    });
  }

  /// Create a copy of RangosFc
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ZonaRangoCopyWith<$Res>? get zona2 {
    if (_value.zona2 == null) {
      return null;
    }

    return $ZonaRangoCopyWith<$Res>(_value.zona2!, (value) {
      return _then(_value.copyWith(zona2: value) as $Val);
    });
  }

  /// Create a copy of RangosFc
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ZonaRangoCopyWith<$Res>? get zona3 {
    if (_value.zona3 == null) {
      return null;
    }

    return $ZonaRangoCopyWith<$Res>(_value.zona3!, (value) {
      return _then(_value.copyWith(zona3: value) as $Val);
    });
  }

  /// Create a copy of RangosFc
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ZonaRangoCopyWith<$Res>? get zona4 {
    if (_value.zona4 == null) {
      return null;
    }

    return $ZonaRangoCopyWith<$Res>(_value.zona4!, (value) {
      return _then(_value.copyWith(zona4: value) as $Val);
    });
  }

  /// Create a copy of RangosFc
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ZonaRangoCopyWith<$Res>? get zona5 {
    if (_value.zona5 == null) {
      return null;
    }

    return $ZonaRangoCopyWith<$Res>(_value.zona5!, (value) {
      return _then(_value.copyWith(zona5: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RangosFcImplCopyWith<$Res>
    implements $RangosFcCopyWith<$Res> {
  factory _$$RangosFcImplCopyWith(
    _$RangosFcImpl value,
    $Res Function(_$RangosFcImpl) then,
  ) = __$$RangosFcImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'zona_1') ZonaRango? zona1,
    @JsonKey(name: 'zona_2') ZonaRango? zona2,
    @JsonKey(name: 'zona_3') ZonaRango? zona3,
    @JsonKey(name: 'zona_4') ZonaRango? zona4,
    @JsonKey(name: 'zona_5') ZonaRango? zona5,
  });

  @override
  $ZonaRangoCopyWith<$Res>? get zona1;
  @override
  $ZonaRangoCopyWith<$Res>? get zona2;
  @override
  $ZonaRangoCopyWith<$Res>? get zona3;
  @override
  $ZonaRangoCopyWith<$Res>? get zona4;
  @override
  $ZonaRangoCopyWith<$Res>? get zona5;
}

/// @nodoc
class __$$RangosFcImplCopyWithImpl<$Res>
    extends _$RangosFcCopyWithImpl<$Res, _$RangosFcImpl>
    implements _$$RangosFcImplCopyWith<$Res> {
  __$$RangosFcImplCopyWithImpl(
    _$RangosFcImpl _value,
    $Res Function(_$RangosFcImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RangosFc
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? zona1 = freezed,
    Object? zona2 = freezed,
    Object? zona3 = freezed,
    Object? zona4 = freezed,
    Object? zona5 = freezed,
  }) {
    return _then(
      _$RangosFcImpl(
        zona1: freezed == zona1
            ? _value.zona1
            : zona1 // ignore: cast_nullable_to_non_nullable
                  as ZonaRango?,
        zona2: freezed == zona2
            ? _value.zona2
            : zona2 // ignore: cast_nullable_to_non_nullable
                  as ZonaRango?,
        zona3: freezed == zona3
            ? _value.zona3
            : zona3 // ignore: cast_nullable_to_non_nullable
                  as ZonaRango?,
        zona4: freezed == zona4
            ? _value.zona4
            : zona4 // ignore: cast_nullable_to_non_nullable
                  as ZonaRango?,
        zona5: freezed == zona5
            ? _value.zona5
            : zona5 // ignore: cast_nullable_to_non_nullable
                  as ZonaRango?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RangosFcImpl implements _RangosFc {
  const _$RangosFcImpl({
    @JsonKey(name: 'zona_1') this.zona1,
    @JsonKey(name: 'zona_2') this.zona2,
    @JsonKey(name: 'zona_3') this.zona3,
    @JsonKey(name: 'zona_4') this.zona4,
    @JsonKey(name: 'zona_5') this.zona5,
  });

  factory _$RangosFcImpl.fromJson(Map<String, dynamic> json) =>
      _$$RangosFcImplFromJson(json);

  @override
  @JsonKey(name: 'zona_1')
  final ZonaRango? zona1;
  @override
  @JsonKey(name: 'zona_2')
  final ZonaRango? zona2;
  @override
  @JsonKey(name: 'zona_3')
  final ZonaRango? zona3;
  @override
  @JsonKey(name: 'zona_4')
  final ZonaRango? zona4;
  @override
  @JsonKey(name: 'zona_5')
  final ZonaRango? zona5;

  @override
  String toString() {
    return 'RangosFc(zona1: $zona1, zona2: $zona2, zona3: $zona3, zona4: $zona4, zona5: $zona5)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RangosFcImpl &&
            (identical(other.zona1, zona1) || other.zona1 == zona1) &&
            (identical(other.zona2, zona2) || other.zona2 == zona2) &&
            (identical(other.zona3, zona3) || other.zona3 == zona3) &&
            (identical(other.zona4, zona4) || other.zona4 == zona4) &&
            (identical(other.zona5, zona5) || other.zona5 == zona5));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, zona1, zona2, zona3, zona4, zona5);

  /// Create a copy of RangosFc
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RangosFcImplCopyWith<_$RangosFcImpl> get copyWith =>
      __$$RangosFcImplCopyWithImpl<_$RangosFcImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RangosFcImplToJson(this);
  }
}

abstract class _RangosFc implements RangosFc {
  const factory _RangosFc({
    @JsonKey(name: 'zona_1') final ZonaRango? zona1,
    @JsonKey(name: 'zona_2') final ZonaRango? zona2,
    @JsonKey(name: 'zona_3') final ZonaRango? zona3,
    @JsonKey(name: 'zona_4') final ZonaRango? zona4,
    @JsonKey(name: 'zona_5') final ZonaRango? zona5,
  }) = _$RangosFcImpl;

  factory _RangosFc.fromJson(Map<String, dynamic> json) =
      _$RangosFcImpl.fromJson;

  @override
  @JsonKey(name: 'zona_1')
  ZonaRango? get zona1;
  @override
  @JsonKey(name: 'zona_2')
  ZonaRango? get zona2;
  @override
  @JsonKey(name: 'zona_3')
  ZonaRango? get zona3;
  @override
  @JsonKey(name: 'zona_4')
  ZonaRango? get zona4;
  @override
  @JsonKey(name: 'zona_5')
  ZonaRango? get zona5;

  /// Create a copy of RangosFc
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RangosFcImplCopyWith<_$RangosFcImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ZonaRango _$ZonaRangoFromJson(Map<String, dynamic> json) {
  return _ZonaRango.fromJson(json);
}

/// @nodoc
mixin _$ZonaRango {
  num? get min => throw _privateConstructorUsedError;
  num? get max => throw _privateConstructorUsedError;

  /// Serializes this ZonaRango to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ZonaRango
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ZonaRangoCopyWith<ZonaRango> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ZonaRangoCopyWith<$Res> {
  factory $ZonaRangoCopyWith(ZonaRango value, $Res Function(ZonaRango) then) =
      _$ZonaRangoCopyWithImpl<$Res, ZonaRango>;
  @useResult
  $Res call({num? min, num? max});
}

/// @nodoc
class _$ZonaRangoCopyWithImpl<$Res, $Val extends ZonaRango>
    implements $ZonaRangoCopyWith<$Res> {
  _$ZonaRangoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ZonaRango
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? min = freezed, Object? max = freezed}) {
    return _then(
      _value.copyWith(
            min: freezed == min
                ? _value.min
                : min // ignore: cast_nullable_to_non_nullable
                      as num?,
            max: freezed == max
                ? _value.max
                : max // ignore: cast_nullable_to_non_nullable
                      as num?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ZonaRangoImplCopyWith<$Res>
    implements $ZonaRangoCopyWith<$Res> {
  factory _$$ZonaRangoImplCopyWith(
    _$ZonaRangoImpl value,
    $Res Function(_$ZonaRangoImpl) then,
  ) = __$$ZonaRangoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({num? min, num? max});
}

/// @nodoc
class __$$ZonaRangoImplCopyWithImpl<$Res>
    extends _$ZonaRangoCopyWithImpl<$Res, _$ZonaRangoImpl>
    implements _$$ZonaRangoImplCopyWith<$Res> {
  __$$ZonaRangoImplCopyWithImpl(
    _$ZonaRangoImpl _value,
    $Res Function(_$ZonaRangoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ZonaRango
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? min = freezed, Object? max = freezed}) {
    return _then(
      _$ZonaRangoImpl(
        min: freezed == min
            ? _value.min
            : min // ignore: cast_nullable_to_non_nullable
                  as num?,
        max: freezed == max
            ? _value.max
            : max // ignore: cast_nullable_to_non_nullable
                  as num?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ZonaRangoImpl implements _ZonaRango {
  const _$ZonaRangoImpl({this.min, this.max});

  factory _$ZonaRangoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ZonaRangoImplFromJson(json);

  @override
  final num? min;
  @override
  final num? max;

  @override
  String toString() {
    return 'ZonaRango(min: $min, max: $max)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ZonaRangoImpl &&
            (identical(other.min, min) || other.min == min) &&
            (identical(other.max, max) || other.max == max));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, min, max);

  /// Create a copy of ZonaRango
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ZonaRangoImplCopyWith<_$ZonaRangoImpl> get copyWith =>
      __$$ZonaRangoImplCopyWithImpl<_$ZonaRangoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ZonaRangoImplToJson(this);
  }
}

abstract class _ZonaRango implements ZonaRango {
  const factory _ZonaRango({final num? min, final num? max}) = _$ZonaRangoImpl;

  factory _ZonaRango.fromJson(Map<String, dynamic> json) =
      _$ZonaRangoImpl.fromJson;

  @override
  num? get min;
  @override
  num? get max;

  /// Create a copy of ZonaRango
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ZonaRangoImplCopyWith<_$ZonaRangoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
