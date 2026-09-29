import 'package:freezed_annotation/freezed_annotation.dart';

part 'usuario.freezed.dart';
part 'usuario.g.dart';

@freezed
abstract class Usuario with _$Usuario {
  const factory Usuario({
    required String id,
    required String email,
    required String nombre,
    String? apodo,
    @Default(false) bool onboardingCompleto,
    @Default(true) bool registroActivo,
    String? genero,
    String? ciudad,
    String? altitud,
    String? nivelActividad,
    String? nombreDisciplina,
    String? objetivoPrincipal,
    String? fechaInicioPreferida,
    @Default([]) List<String> diasEntrenamiento,
    String? nombrePlanActivo,
    String? fechaFinSuscripcion,
    String? estadoSuscripcion,
    @Default(false) bool tienePlanActivo,
  }) = _Usuario;

  const Usuario._(); // Required by Freezed to add custom methods
  
  bool get isTrial {
    final plan = nombrePlanActivo?.trim().toLowerCase() ?? '';
    return plan == 'trial';
  }

  bool get isEssential {
    final plan = nombrePlanActivo?.trim().toLowerCase() ?? '';
    return plan == 'essential';
  }

  bool get isPro {
    final plan = nombrePlanActivo?.trim().toLowerCase() ?? '';
    if (plan.isEmpty || plan == 'trial' || plan == 'essential' || plan.contains('elite') || plan.contains('élite')) return false;
    return true;
  }

  bool get isElite {
    final plan = nombrePlanActivo?.trim().toLowerCase() ?? '';
    if (plan.isEmpty || plan == 'trial' || plan == 'essential') return false;
    return plan.contains('elite') || plan.contains('élite');
  }

  bool get canSeeNutrition => isPro || isElite;

  factory Usuario.fromJson(Map<String, dynamic> json) => _$UsuarioFromJson({
    'id': json['id_usuario']?.toString() ?? json['id']?.toString() ?? '',
    'email': json['email'] ?? '',
    'nombre': json['nombre'] ?? '',
    'apodo': json['apodo'],
    'onboardingCompleto': json['onboarding_completo'] ?? false,
    'registroActivo': json['registro_activo'] ?? true,
    'genero': json['genero'],
    'ciudad': json['ciudad'],
    'altitud': json['altitud']?.toString(),
    'nivelActividad': json['nivel_actividad']?.toString(),
    'nombreDisciplina': json['nombre_disciplina'],
    'objetivoPrincipal': json['objetivo_principal'],
    'fechaInicioPreferida': json['fecha_inicio_preferida'] ?? json['fecha_inicio_deseada'],
    'diasEntrenamiento': json['dias_entrenamiento'] ?? [],
    'nombrePlanActivo': (json['nombre_plan_activo'] ?? json['nombrePlanActivo'])?.toString(),
    'fechaFinSuscripcion': (json['fecha_fin_suscripcion'] ?? json['fechaFinSuscripcion'])?.toString(),
    'estadoSuscripcion': (json['estado_suscripcion'] ?? json['estadoSuscripcion'])?.toString(),
    'tienePlanActivo': (json['tiene_plan_activo'] ?? json['tienePlanActivo']) is bool
        ? (json['tiene_plan_activo'] ?? json['tienePlanActivo'])
        : (json['tiene_plan_activo'] ?? json['tienePlanActivo'])?.toString().toLowerCase() == 'true',
  });
}
