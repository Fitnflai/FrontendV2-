import 'package:flutter/material.dart';

// ═══════════════════════════════════════════════════════════════
// WORKOUT TYPE CONFIG
// Usar en toda la app para consistencia visual
// Uso: WorkoutTypes.fromTipo('Carrera')
// ═══════════════════════════════════════════════════════════════

class WorkoutTypeConfig {
  final String tipo;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final String emoji;
  final String shortLabel;

  const WorkoutTypeConfig({
    required this.tipo,
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.emoji,
    required this.shortLabel,
  });
}

class WorkoutTypes {

  // ── Configs ───────────────────────────────────────────────────
  static const _carrera = WorkoutTypeConfig(
    tipo:       'Carrera',
    icon:       Icons.directions_run,
    color:      Color(0xFF0D1A2E),
    bgColor:    Color(0xFF4A90D9),
    emoji:      '🏃',
    shortLabel: 'Carrera',
  );

  static const _fuerza = WorkoutTypeConfig(
    tipo:       'Fuerza',
    icon:       Icons.fitness_center,
    color:      Color(0xFF2E1A0D),
    bgColor:    Color(0xFFB05A30),
    emoji:      '💪',
    shortLabel: 'Fuerza',
  );

  static const _natacion = WorkoutTypeConfig(
    tipo:       'Natacion',
    icon:       Icons.pool,
    color:      Color(0xFF1A0D2E),
    bgColor:    Color(0xFF7B4FBF),
    emoji:      '🏊',
    shortLabel: 'Nat.',
  );

  static const _bicicleta = WorkoutTypeConfig(
    tipo:       'Bicicleta',
    icon:       Icons.directions_bike,
    color:      Color(0xFF2E1A0D),
    bgColor:    Color(0xFFD97B4A),
    emoji:      '🚴',
    shortLabel: 'Bci',
  );

  static const _movilidad = WorkoutTypeConfig(
    tipo:       'Movilidad',
    icon:       Icons.self_improvement,
    color:      Color(0xFF0D2E1A),
    bgColor:    Color(0xFF2E9E6B),
    emoji:      '🤸',
    shortLabel: 'Mov.',
  );

  static const _descanso = WorkoutTypeConfig(
    tipo:       'Descanso',
    icon:       Icons.bedtime_outlined,
    color:      Color(0xFF1A1A1A),
    bgColor:    Color(0xFF555555),
    emoji:      '😴',
    shortLabel: 'Des.',
  );

  static const _default = WorkoutTypeConfig(
    tipo:       'Entrenamiento',
    icon:       Icons.sports,
    color:      Color(0xFF2E1A0D),
    bgColor:    Color(0xFFFF6B35),
    emoji:      '🏋️',
    shortLabel: 'Ent.',
  );

  // ── Lista completa ────────────────────────────────────────────
  static const all = [
    _carrera,
    _fuerza,
    _natacion,
    _bicicleta,
    _movilidad,
    _descanso,
  ];

  // ── Lookup por tipo string (case-insensitive, acepta variantes) ─
  static WorkoutTypeConfig fromTipo(String? tipo) {
    if (tipo == null || tipo.isEmpty) return _default;
    final t = tipo.toLowerCase().trim();

    if (t.contains('carrera') || t.contains('running') ||
        t.contains('correr') || t.contains('run'))
      return _carrera;

    if (t.contains('fuerza') || t.contains('strength') ||
        t.contains('inferior') || t.contains('superior'))
      return _fuerza;

    if (t.contains('nataci') || t.contains('swim') ||
        t.contains('piscina') || t.contains('acuático'))
      return _natacion;

    if (t.contains('biciclet') || t.contains('bci') ||
        t.contains('ciclism') || t.contains('bike') ||
        t.contains('cycling'))
      return _bicicleta;

    if (t.contains('movilidad') || t.contains('mobility') ||
        t.contains('stretching') || t.contains('flexibilidad') ||
        t.contains('yoga'))
      return _movilidad;

    if (t.contains('descanso') || t.contains('rest') ||
        t.contains('recuperaci'))
      return _descanso;

    return _default;
  }
}