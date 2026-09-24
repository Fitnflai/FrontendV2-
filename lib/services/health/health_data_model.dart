class HealthDataModel {
  final String fecha;
  final int pasos;
  final double caloriasQuemadas;
  final double distanciaKm;
  final double ritmoCardiacoPromedio;
  final double ritmoCardiacoReposo;
  final double pesoKg;
  final double horasSueno;
  final String fuente;
  final double fcReposo;
  final List<Map<String, dynamic>> workouts;

  HealthDataModel({
    required this.fecha,
    required this.pasos,
    required this.caloriasQuemadas,
    required this.distanciaKm,
    required this.ritmoCardiacoPromedio,
    required this.ritmoCardiacoReposo,
    required this.pesoKg,
    required this.horasSueno,
    required this.fuente,
    required this.fcReposo,
    this.workouts = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'fecha': fecha,
      'pasos': pasos,
      'calorias_quemadas': caloriasQuemadas,
      'distancia_km': distanciaKm,
      'ritmo_cardiaco_promedio': ritmoCardiacoPromedio,
      'ritmo_cardiaco_reposo': ritmoCardiacoReposo,
      'peso_kg': pesoKg,
      'horas_sueno': horasSueno,
      'fuente': fuente,
      'fc_reposo': fcReposo,
      'workouts': workouts,
    };
  }

  factory HealthDataModel.fromMap(Map<String, dynamic> map) {
    return HealthDataModel(
      fecha: map['fecha'] as String,
      pasos: map['pasos'] as int,
      caloriasQuemadas: (map['calorias_quemadas'] as num).toDouble(),
      distanciaKm: (map['distancia_km'] as num).toDouble(),
      ritmoCardiacoPromedio: (map['ritmo_cardiaco_promedio'] as num).toDouble(),
      ritmoCardiacoReposo: (map['ritmo_cardiaco_reposo'] as num).toDouble(),
      pesoKg: (map['peso_kg'] as num).toDouble(),
      horasSueno: (map['horas_sueno'] as num).toDouble(),
      fuente: map['fuente'] as String,
      fcReposo: (map['fc_reposo'] as num).toDouble(),
      workouts: List<Map<String, dynamic>>.from(map['workouts'] as List<dynamic>),
    );
  }
}
