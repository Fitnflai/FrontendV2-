import 'package:flutter/material.dart';
import '../../../../config/app_theme_extension.dart';

class ExerciseDetailBottomSheet extends StatelessWidget {
  final Map<String, dynamic> exercise;
  final String badgeText;
  final String workoutSport;

  const ExerciseDetailBottomSheet({
    super.key,
    required this.exercise,
    required this.badgeText,
    required this.workoutSport,
  });

  static Future<void> show(
    BuildContext context, {
    required Map<String, dynamic> exercise,
    required String badgeText,
    required String workoutSport,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ExerciseDetailBottomSheet(
        exercise: exercise,
        badgeText: badgeText,
        workoutSport: workoutSport,
      ),
    );
  }

  Color _badgeColor(String tipo) {
    final t = tipo.toUpperCase();
    if (t.contains('FUERZA')) return const Color(0xFFB05A30);
    if (t.contains('CARDIO') || t.contains('CARRERA')) return const Color(0xFFD97B4A);
    if (t.contains('MOVILIDAD')) return const Color(0xFF2E9E6B);
    if (t.contains('CICLISMO') || t.contains('BIKE')) return const Color(0xFF007DC3);
    if (t.contains('NATACI') || t.contains('SWIM')) return const Color(0xFF1976D2);
    return const Color(0xFFFF6B35);
  }

  IconData _disciplineIcon(String tipo) {
    final t = tipo.toUpperCase();
    if (t.contains('FUERZA')) return Icons.fitness_center_rounded;
    if (t.contains('CARDIO') || t.contains('CARRERA')) return Icons.directions_run_outlined;
    if (t.contains('MOVILIDAD')) return Icons.self_improvement_rounded;
    if (t.contains('CICLISMO')) return Icons.directions_bike_outlined;
    if (t.contains('NATACI')) return Icons.pool_outlined;
    return Icons.sports_gymnastics_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;
    final nombre = exercise['nombre'] as String? ?? 'Ejercicio';
    final estado = (exercise['estado'] as String? ?? '').toLowerCase();
    final isCompletado = estado == 'completado' || estado == 'completo' || estado == 'done';

    final rawTipo = badgeText.isNotEmpty
        ? badgeText
        : (exercise['tipo'] ?? exercise['bloque'] ?? workoutSport).toString();
    final color = _badgeColor(rawTipo);
    final icon = _disciplineIcon(rawTipo);

    final rawSeries = exercise['series']?.toString() ?? '';
    final rawReps = exercise['reps']?.toString() ?? exercise['repeticiones']?.toString() ?? '';
    final seriesVal = int.tryParse(rawSeries) ?? 0;
    final repsVal = int.tryParse(rawReps) ?? 0;

    final distM = exercise['distancia_m'] as int? ?? 0;
    final durSeg = int.tryParse(exercise['dur_seg']?.toString() ?? '') ?? 0;
    final durMinStr = exercise['dur'] as String? ?? '';
    final descansoSeg = int.tryParse(exercise['descanso_seg']?.toString() ?? '') ?? 0;
    final pesoStr = exercise['peso']?.toString() ?? '';
    final pesoVal = double.tryParse(pesoStr) ?? 0.0;

    final isFuerza = rawTipo.toUpperCase().contains('FUERZA');
    final isCardio = rawTipo.toUpperCase().contains('CARDIO') ||
        rawTipo.toUpperCase().contains('CARRERA') ||
        rawTipo.toUpperCase().contains('CICLISMO');

    return Container(
      decoration: BoxDecoration(
        color: theme.cardDark,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: theme.border.withValues(alpha: 0.5)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.border.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Header: Icon, Name, Badge, Status, Close
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 24, color: color),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            rawTipo.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.6,
                              color: color,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (isCompletado)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4CAF50).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.check, size: 12, color: Color(0xFF4CAF50)),
                                SizedBox(width: 4),
                                Text(
                                  'COMPLETADO',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF4CAF50),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      nombre,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: theme.text,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: theme.textMuted, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Divider(color: theme.border.withValues(alpha: 0.3), height: 1),
          const SizedBox(height: 16),

          // Metrics Grid
          Text(
            'MÉTRICAS DEL EJERCICIO',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
              color: theme.textMuted,
            ),
          ),
          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: theme.card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: theme.border.withValues(alpha: 0.4)),
            ),
            child: Column(
              children: [
                if (isFuerza) ...[
                  Row(
                    children: [
                      Expanded(
                        child: _ModalMetric(
                          label: 'SERIES × REPS',
                          value: seriesVal > 0 && repsVal > 0
                              ? '$seriesVal × $repsVal'
                              : (seriesVal > 0 ? '$seriesVal series' : (repsVal > 0 ? '$repsVal reps' : '--')),
                          theme: theme,
                        ),
                      ),
                      Expanded(
                        child: _ModalMetric(
                          label: 'PESO / CARGA',
                          value: pesoVal > 0 ? '${pesoVal.toStringAsFixed(0)} kg' : 'Corporal',
                          theme: theme,
                        ),
                      ),
                      Expanded(
                        child: _ModalMetric(
                          label: 'VOLUMEN CARGA',
                          value: pesoVal > 0 && seriesVal > 0 && repsVal > 0
                              ? '${(pesoVal * seriesVal * repsVal).toStringAsFixed(0)} kg'
                              : (seriesVal > 0 && repsVal > 0 ? '${seriesVal * repsVal} reps' : '--'),
                          theme: theme,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Divider(color: theme.border.withValues(alpha: 0.25), height: 1),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _ModalMetric(
                          label: 'DESCANSO ENTRE SERIES',
                          value: descansoSeg > 0 ? '${descansoSeg}s' : '60s',
                          prefixIcon: Icons.timer_outlined,
                          theme: theme,
                        ),
                      ),
                      Expanded(
                        child: _ModalMetric(
                          label: 'TUT ESTIMADO',
                          value: repsVal > 0 ? '${repsVal * 3}s / serie' : '--',
                          theme: theme,
                        ),
                      ),
                    ],
                  ),
                ] else if (isCardio) ...[
                  Row(
                    children: [
                      Expanded(
                        child: _ModalMetric(
                          label: 'DURACIÓN O TRAMO',
                          value: durSeg > 0
                              ? (durSeg >= 60 ? '${(durSeg / 60).round()} min' : '$durSeg s')
                              : (durMinStr.isNotEmpty ? durMinStr : (distM > 0 ? '$distM m' : '--')),
                          theme: theme,
                        ),
                      ),
                      Expanded(
                        child: _ModalMetric(
                          label: 'DISTANCIA OBJETIVO',
                          value: distM > 0
                              ? (distM >= 1000 ? '${(distM / 1000).toStringAsFixed(2)} km' : '$distM m')
                              : '--',
                          theme: theme,
                        ),
                      ),
                      Expanded(
                        child: _ModalMetric(
                          label: 'DESCANSO',
                          value: descansoSeg > 0 ? '${descansoSeg}s' : '--',
                          theme: theme,
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  Row(
                    children: [
                      Expanded(
                        child: _ModalMetric(
                          label: 'DURACIÓN',
                          value: durSeg > 0
                              ? (durSeg >= 60 ? '${(durSeg / 60).round()} min' : '$durSeg s')
                              : (durMinStr.isNotEmpty ? durMinStr : '5 min'),
                          theme: theme,
                        ),
                      ),
                      Expanded(
                        child: _ModalMetric(
                          label: 'DESCANSO',
                          value: descansoSeg > 0 ? '${descansoSeg}s' : '0s',
                          theme: theme,
                        ),
                      ),
                      Expanded(
                        child: _ModalMetric(
                          label: 'TIPO',
                          value: 'Recuperación',
                          theme: theme,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 16),
          // Ready Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.card,
                foregroundColor: theme.text,
                side: BorderSide(color: theme.border.withValues(alpha: 0.5)),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Entendido', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModalMetric extends StatelessWidget {
  final String label;
  final String value;
  final IconData? prefixIcon;
  final AppThemeExtensionWrapper theme;

  const _ModalMetric({
    required this.label,
    required this.value,
    this.prefixIcon,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.6,
            color: theme.textMuted,
          ),
        ),
        const SizedBox(height: 3),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (prefixIcon != null) ...[
              Icon(prefixIcon, size: 13, color: theme.textMuted),
              const SizedBox(width: 3),
            ],
            Flexible(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: theme.text,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
