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
  FactorHydrationDetail? get detalleFactorHidratacion =>
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
    FactorHydrationDetail? detalleFactorHidratacion,
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
  });

  $AlertCopyWith<$Res>? get alertas;
  $GeneralFactorDetailCopyWith<$Res>? get detalleFactorMovement;
  $FactorHydrationDetailCopyWith<$Res>? get detalleFactorHidratacion;
  $GeneralFactorDetailCopyWith<$Res>? get detalleFactorEdadCorporal;
  $GeneralFactorDetailCopyWith<$Res>? get detalleFactorCargaMuscular;
  $FactorWeightDetailCopyWith<$Res>? get detalleFactorPesoComposicion;
  $SecondaryMetricsCopyWith<$Res>? get metricasSecundarias;
  $CurrentPreviousValueCopyWith<$Res>? get grasa;
  $CurrentPreviousValueCopyWith<$Res>? get musculos;
  $CaloriasDetailCopyWith<$Res>? get calorias;
  $ActiveTimeDetailCopyWith<$Res>? get tiempoActivo;
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
                      as FactorHydrationDetail?,
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
  $FactorHydrationDetailCopyWith<$Res>? get detalleFactorHidratacion {
    if (_value.detalleFactorHidratacion == null) {
      return null;
    }

    return $FactorHydrationDetailCopyWith<$Res>(
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
    FactorHydrationDetail? detalleFactorHidratacion,
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
  });

  @override
  $AlertCopyWith<$Res>? get alertas;
  @override
  $GeneralFactorDetailCopyWith<$Res>? get detalleFactorMovement;
  @override
  $FactorHydrationDetailCopyWith<$Res>? get detalleFactorHidratacion;
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
                  as FactorHydrationDetail?,
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
  final FactorHydrationDetail? detalleFactorHidratacion;
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
  String toString() {
    return 'ProgressReport(idReporteSemanal: $idReporteSemanal, semanaInfo: $semanaInfo, fechaInicio: $fechaInicio, fechaFin: $fechaFin, actualizado: $actualizado, alertas: $alertas, mensajeIa: $mensajeIa, indiceBienestar: $indiceBienestar, variacionIndiceBienestar: $variacionIndiceBienestar, detalleFactorMovement: $detalleFactorMovement, detalleFactorHidratacion: $detalleFactorHidratacion, detalleFactorEdadCorporal: $detalleFactorEdadCorporal, detalleFactorCargaMuscular: $detalleFactorCargaMuscular, detalleFactorPesoComposicion: $detalleFactorPesoComposicion, evolucionIndiceBienestar: $evolucionIndiceBienestar, historialPeso: $historialPeso, metricasSecundarias: $metricasSecundarias, grasa: $grasa, musculos: $musculos, calorias: $calorias, tiempoActivo: $tiempoActivo)';
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
                other.tiempoActivo == tiempoActivo));
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
    final FactorHydrationDetail? detalleFactorHidratacion,
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
  FactorHydrationDetail? get detalleFactorHidratacion;
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

FactorHydrationDetail _$FactorHydrationDetailFromJson(
  Map<String, dynamic> json,
) {
  return _FactorHydrationDetail.fromJson(json);
}

/// @nodoc
mixin _$FactorHydrationDetail {
  HydrationPuntaje? get puntaje => throw _privateConstructorUsedError;
  num? get variacion => throw _privateConstructorUsedError;

  /// Serializes this FactorHydrationDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FactorHydrationDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FactorHydrationDetailCopyWith<FactorHydrationDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FactorHydrationDetailCopyWith<$Res> {
  factory $FactorHydrationDetailCopyWith(
    FactorHydrationDetail value,
    $Res Function(FactorHydrationDetail) then,
  ) = _$FactorHydrationDetailCopyWithImpl<$Res, FactorHydrationDetail>;
  @useResult
  $Res call({HydrationPuntaje? puntaje, num? variacion});

  $HydrationPuntajeCopyWith<$Res>? get puntaje;
}

/// @nodoc
class _$FactorHydrationDetailCopyWithImpl<
  $Res,
  $Val extends FactorHydrationDetail
>
    implements $FactorHydrationDetailCopyWith<$Res> {
  _$FactorHydrationDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FactorHydrationDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? puntaje = freezed, Object? variacion = freezed}) {
    return _then(
      _value.copyWith(
            puntaje: freezed == puntaje
                ? _value.puntaje
                : puntaje // ignore: cast_nullable_to_non_nullable
                      as HydrationPuntaje?,
            variacion: freezed == variacion
                ? _value.variacion
                : variacion // ignore: cast_nullable_to_non_nullable
                      as num?,
          )
          as $Val,
    );
  }

  /// Create a copy of FactorHydrationDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $HydrationPuntajeCopyWith<$Res>? get puntaje {
    if (_value.puntaje == null) {
      return null;
    }

    return $HydrationPuntajeCopyWith<$Res>(_value.puntaje!, (value) {
      return _then(_value.copyWith(puntaje: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FactorHydrationDetailImplCopyWith<$Res>
    implements $FactorHydrationDetailCopyWith<$Res> {
  factory _$$FactorHydrationDetailImplCopyWith(
    _$FactorHydrationDetailImpl value,
    $Res Function(_$FactorHydrationDetailImpl) then,
  ) = __$$FactorHydrationDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({HydrationPuntaje? puntaje, num? variacion});

  @override
  $HydrationPuntajeCopyWith<$Res>? get puntaje;
}

/// @nodoc
class __$$FactorHydrationDetailImplCopyWithImpl<$Res>
    extends
        _$FactorHydrationDetailCopyWithImpl<$Res, _$FactorHydrationDetailImpl>
    implements _$$FactorHydrationDetailImplCopyWith<$Res> {
  __$$FactorHydrationDetailImplCopyWithImpl(
    _$FactorHydrationDetailImpl _value,
    $Res Function(_$FactorHydrationDetailImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FactorHydrationDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? puntaje = freezed, Object? variacion = freezed}) {
    return _then(
      _$FactorHydrationDetailImpl(
        puntaje: freezed == puntaje
            ? _value.puntaje
            : puntaje // ignore: cast_nullable_to_non_nullable
                  as HydrationPuntaje?,
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
class _$FactorHydrationDetailImpl implements _FactorHydrationDetail {
  const _$FactorHydrationDetailImpl({this.puntaje, this.variacion});

  factory _$FactorHydrationDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$FactorHydrationDetailImplFromJson(json);

  @override
  final HydrationPuntaje? puntaje;
  @override
  final num? variacion;

  @override
  String toString() {
    return 'FactorHydrationDetail(puntaje: $puntaje, variacion: $variacion)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FactorHydrationDetailImpl &&
            (identical(other.puntaje, puntaje) || other.puntaje == puntaje) &&
            (identical(other.variacion, variacion) ||
                other.variacion == variacion));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, puntaje, variacion);

  /// Create a copy of FactorHydrationDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FactorHydrationDetailImplCopyWith<_$FactorHydrationDetailImpl>
  get copyWith =>
      __$$FactorHydrationDetailImplCopyWithImpl<_$FactorHydrationDetailImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FactorHydrationDetailImplToJson(this);
  }
}

abstract class _FactorHydrationDetail implements FactorHydrationDetail {
  const factory _FactorHydrationDetail({
    final HydrationPuntaje? puntaje,
    final num? variacion,
  }) = _$FactorHydrationDetailImpl;

  factory _FactorHydrationDetail.fromJson(Map<String, dynamic> json) =
      _$FactorHydrationDetailImpl.fromJson;

  @override
  HydrationPuntaje? get puntaje;
  @override
  num? get variacion;

  /// Create a copy of FactorHydrationDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FactorHydrationDetailImplCopyWith<_$FactorHydrationDetailImpl>
  get copyWith => throw _privateConstructorUsedError;
}

HydrationPuntaje _$HydrationPuntajeFromJson(Map<String, dynamic> json) {
  return _HydrationPuntaje.fromJson(json);
}

/// @nodoc
mixin _$HydrationPuntaje {
  @JsonKey(name: 'consumo_total_ml')
  num? get consumoTotalMl => throw _privateConstructorUsedError;
  @JsonKey(name: 'score_hidratacion')
  num? get scoreHidratacion => throw _privateConstructorUsedError;
  @JsonKey(name: 'requerimiento_total_ml')
  num? get requerimientoTotalMl => throw _privateConstructorUsedError;

  /// Serializes this HydrationPuntaje to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HydrationPuntaje
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HydrationPuntajeCopyWith<HydrationPuntaje> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HydrationPuntajeCopyWith<$Res> {
  factory $HydrationPuntajeCopyWith(
    HydrationPuntaje value,
    $Res Function(HydrationPuntaje) then,
  ) = _$HydrationPuntajeCopyWithImpl<$Res, HydrationPuntaje>;
  @useResult
  $Res call({
    @JsonKey(name: 'consumo_total_ml') num? consumoTotalMl,
    @JsonKey(name: 'score_hidratacion') num? scoreHidratacion,
    @JsonKey(name: 'requerimiento_total_ml') num? requerimientoTotalMl,
  });
}

/// @nodoc
class _$HydrationPuntajeCopyWithImpl<$Res, $Val extends HydrationPuntaje>
    implements $HydrationPuntajeCopyWith<$Res> {
  _$HydrationPuntajeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HydrationPuntaje
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
abstract class _$$HydrationPuntajeImplCopyWith<$Res>
    implements $HydrationPuntajeCopyWith<$Res> {
  factory _$$HydrationPuntajeImplCopyWith(
    _$HydrationPuntajeImpl value,
    $Res Function(_$HydrationPuntajeImpl) then,
  ) = __$$HydrationPuntajeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'consumo_total_ml') num? consumoTotalMl,
    @JsonKey(name: 'score_hidratacion') num? scoreHidratacion,
    @JsonKey(name: 'requerimiento_total_ml') num? requerimientoTotalMl,
  });
}

/// @nodoc
class __$$HydrationPuntajeImplCopyWithImpl<$Res>
    extends _$HydrationPuntajeCopyWithImpl<$Res, _$HydrationPuntajeImpl>
    implements _$$HydrationPuntajeImplCopyWith<$Res> {
  __$$HydrationPuntajeImplCopyWithImpl(
    _$HydrationPuntajeImpl _value,
    $Res Function(_$HydrationPuntajeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HydrationPuntaje
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? consumoTotalMl = freezed,
    Object? scoreHidratacion = freezed,
    Object? requerimientoTotalMl = freezed,
  }) {
    return _then(
      _$HydrationPuntajeImpl(
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
class _$HydrationPuntajeImpl implements _HydrationPuntaje {
  const _$HydrationPuntajeImpl({
    @JsonKey(name: 'consumo_total_ml') this.consumoTotalMl,
    @JsonKey(name: 'score_hidratacion') this.scoreHidratacion,
    @JsonKey(name: 'requerimiento_total_ml') this.requerimientoTotalMl,
  });

  factory _$HydrationPuntajeImpl.fromJson(Map<String, dynamic> json) =>
      _$$HydrationPuntajeImplFromJson(json);

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
    return 'HydrationPuntaje(consumoTotalMl: $consumoTotalMl, scoreHidratacion: $scoreHidratacion, requerimientoTotalMl: $requerimientoTotalMl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HydrationPuntajeImpl &&
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

  /// Create a copy of HydrationPuntaje
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HydrationPuntajeImplCopyWith<_$HydrationPuntajeImpl> get copyWith =>
      __$$HydrationPuntajeImplCopyWithImpl<_$HydrationPuntajeImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$HydrationPuntajeImplToJson(this);
  }
}

abstract class _HydrationPuntaje implements HydrationPuntaje {
  const factory _HydrationPuntaje({
    @JsonKey(name: 'consumo_total_ml') final num? consumoTotalMl,
    @JsonKey(name: 'score_hidratacion') final num? scoreHidratacion,
    @JsonKey(name: 'requerimiento_total_ml') final num? requerimientoTotalMl,
  }) = _$HydrationPuntajeImpl;

  factory _HydrationPuntaje.fromJson(Map<String, dynamic> json) =
      _$HydrationPuntajeImpl.fromJson;

  @override
  @JsonKey(name: 'consumo_total_ml')
  num? get consumoTotalMl;
  @override
  @JsonKey(name: 'score_hidratacion')
  num? get scoreHidratacion;
  @override
  @JsonKey(name: 'requerimiento_total_ml')
  num? get requerimientoTotalMl;

  /// Create a copy of HydrationPuntaje
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HydrationPuntajeImplCopyWith<_$HydrationPuntajeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FactorWeightDetail _$FactorWeightDetailFromJson(Map<String, dynamic> json) {
  return _FactorWeightDetail.fromJson(json);
}

/// @nodoc
mixin _$FactorWeightDetail {
  WeightPuntaje? get puntaje => throw _privateConstructorUsedError;
  num? get variacion => throw _privateConstructorUsedError;

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
  $Res call({WeightPuntaje? puntaje, num? variacion});

  $WeightPuntajeCopyWith<$Res>? get puntaje;
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
  $Res call({Object? puntaje = freezed, Object? variacion = freezed}) {
    return _then(
      _value.copyWith(
            puntaje: freezed == puntaje
                ? _value.puntaje
                : puntaje // ignore: cast_nullable_to_non_nullable
                      as WeightPuntaje?,
            variacion: freezed == variacion
                ? _value.variacion
                : variacion // ignore: cast_nullable_to_non_nullable
                      as num?,
          )
          as $Val,
    );
  }

  /// Create a copy of FactorWeightDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WeightPuntajeCopyWith<$Res>? get puntaje {
    if (_value.puntaje == null) {
      return null;
    }

    return $WeightPuntajeCopyWith<$Res>(_value.puntaje!, (value) {
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
  $Res call({WeightPuntaje? puntaje, num? variacion});

  @override
  $WeightPuntajeCopyWith<$Res>? get puntaje;
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
  $Res call({Object? puntaje = freezed, Object? variacion = freezed}) {
    return _then(
      _$FactorWeightDetailImpl(
        puntaje: freezed == puntaje
            ? _value.puntaje
            : puntaje // ignore: cast_nullable_to_non_nullable
                  as WeightPuntaje?,
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
class _$FactorWeightDetailImpl implements _FactorWeightDetail {
  const _$FactorWeightDetailImpl({this.puntaje, this.variacion});

  factory _$FactorWeightDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$FactorWeightDetailImplFromJson(json);

  @override
  final WeightPuntaje? puntaje;
  @override
  final num? variacion;

  @override
  String toString() {
    return 'FactorWeightDetail(puntaje: $puntaje, variacion: $variacion)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FactorWeightDetailImpl &&
            (identical(other.puntaje, puntaje) || other.puntaje == puntaje) &&
            (identical(other.variacion, variacion) ||
                other.variacion == variacion));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, puntaje, variacion);

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
    final WeightPuntaje? puntaje,
    final num? variacion,
  }) = _$FactorWeightDetailImpl;

  factory _FactorWeightDetail.fromJson(Map<String, dynamic> json) =
      _$FactorWeightDetailImpl.fromJson;

  @override
  WeightPuntaje? get puntaje;
  @override
  num? get variacion;

  /// Create a copy of FactorWeightDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FactorWeightDetailImplCopyWith<_$FactorWeightDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WeightPuntaje _$WeightPuntajeFromJson(Map<String, dynamic> json) {
  return _WeightPuntaje.fromJson(json);
}

/// @nodoc
mixin _$WeightPuntaje {
  String? get tag => throw _privateConstructorUsedError;
  num? get puntaje => throw _privateConstructorUsedError;

  /// Serializes this WeightPuntaje to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WeightPuntaje
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WeightPuntajeCopyWith<WeightPuntaje> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeightPuntajeCopyWith<$Res> {
  factory $WeightPuntajeCopyWith(
    WeightPuntaje value,
    $Res Function(WeightPuntaje) then,
  ) = _$WeightPuntajeCopyWithImpl<$Res, WeightPuntaje>;
  @useResult
  $Res call({String? tag, num? puntaje});
}

/// @nodoc
class _$WeightPuntajeCopyWithImpl<$Res, $Val extends WeightPuntaje>
    implements $WeightPuntajeCopyWith<$Res> {
  _$WeightPuntajeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WeightPuntaje
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
abstract class _$$WeightPuntajeImplCopyWith<$Res>
    implements $WeightPuntajeCopyWith<$Res> {
  factory _$$WeightPuntajeImplCopyWith(
    _$WeightPuntajeImpl value,
    $Res Function(_$WeightPuntajeImpl) then,
  ) = __$$WeightPuntajeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? tag, num? puntaje});
}

/// @nodoc
class __$$WeightPuntajeImplCopyWithImpl<$Res>
    extends _$WeightPuntajeCopyWithImpl<$Res, _$WeightPuntajeImpl>
    implements _$$WeightPuntajeImplCopyWith<$Res> {
  __$$WeightPuntajeImplCopyWithImpl(
    _$WeightPuntajeImpl _value,
    $Res Function(_$WeightPuntajeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WeightPuntaje
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? tag = freezed, Object? puntaje = freezed}) {
    return _then(
      _$WeightPuntajeImpl(
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
class _$WeightPuntajeImpl implements _WeightPuntaje {
  const _$WeightPuntajeImpl({this.tag, this.puntaje});

  factory _$WeightPuntajeImpl.fromJson(Map<String, dynamic> json) =>
      _$$WeightPuntajeImplFromJson(json);

  @override
  final String? tag;
  @override
  final num? puntaje;

  @override
  String toString() {
    return 'WeightPuntaje(tag: $tag, puntaje: $puntaje)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeightPuntajeImpl &&
            (identical(other.tag, tag) || other.tag == tag) &&
            (identical(other.puntaje, puntaje) || other.puntaje == puntaje));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, tag, puntaje);

  /// Create a copy of WeightPuntaje
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WeightPuntajeImplCopyWith<_$WeightPuntajeImpl> get copyWith =>
      __$$WeightPuntajeImplCopyWithImpl<_$WeightPuntajeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WeightPuntajeImplToJson(this);
  }
}

abstract class _WeightPuntaje implements WeightPuntaje {
  const factory _WeightPuntaje({final String? tag, final num? puntaje}) =
      _$WeightPuntajeImpl;

  factory _WeightPuntaje.fromJson(Map<String, dynamic> json) =
      _$WeightPuntajeImpl.fromJson;

  @override
  String? get tag;
  @override
  num? get puntaje;

  /// Create a copy of WeightPuntaje
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WeightPuntajeImplCopyWith<_$WeightPuntajeImpl> get copyWith =>
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
