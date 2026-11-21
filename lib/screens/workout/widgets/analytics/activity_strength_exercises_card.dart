import 'package:flutter/material.dart';
import '../../../../config/app_theme_extension.dart';

class ActivityStrengthExercisesCard extends StatelessWidget {
  final List<Map<String, dynamic>> exercises;
  final int? selectedIndex;
  final ValueChanged<int>? onSelectExercise;

  const ActivityStrengthExercisesCard({
    super.key,
    required this.exercises,
    this.selectedIndex,
    this.onSelectExercise,
  });

  Color _badgeBgColor(String tipo) {
    final t = tipo.toUpperCase();
    if (t.contains('FUERZA')) return const Color(0xFFB05A30);
    if (t.contains('CARDIO') || t.contains('CARRERA')) return const Color(0xFFD97B4A);
    if (t.contains('MOVILIDAD')) return const Color(0xFF2E9E6B);
    return const Color(0xFF4A90D9);
  }

  String _formatMetric(Map<String, dynamic> ej) {
    final parts = <String>[];
    final series = ej['series']?.toString() ?? '';
    final reps = ej['reps']?.toString() ?? ej['repeticiones']?.toString() ?? '';
    final dur = ej['dur']?.toString() ?? '';
    final durSeg = int.tryParse(ej['dur_seg']?.toString() ?? ej['duracion_segundos']?.toString() ?? '') ?? 0;
    final descanso = int.tryParse(ej['descanso_seg']?.toString() ?? ej['descanso_segundos']?.toString() ?? '') ?? 0;

    if (series.isNotEmpty && reps.isNotEmpty && series != '0' && reps != '0') {
      parts.add('$series × $reps');
    } else if (series.isNotEmpty && series != '0') {
      parts.add('$series series');
    }

    if (dur.isNotEmpty && dur != '0') {
      parts.add(dur);
    } else if (durSeg > 0) {
      if (durSeg >= 60) {
        parts.add('${durSeg ~/ 60} min');
      } else {
        parts.add('${durSeg}s');
      }
    }

    if (descanso > 0) {
      parts.add('Descanso: ${descanso}s');
    }

    return parts.join('  •  ');
  }

  @override
  Widget build(BuildContext context) {
    if (exercises.isEmpty) return const SizedBox.shrink();

    final theme = context.themeColors;

    final fuerzaCount = exercises.where((e) {
      final t = (e['tipo'] ?? e['bloque'] ?? '').toString().toUpperCase();
      return t.contains('FUERZA');
    }).length;

    final cardioCount = exercises.where((e) {
      final t = (e['tipo'] ?? e['bloque'] ?? '').toString().toUpperCase();
      return t.contains('CARDIO') || t.contains('CARRERA');
    }).length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.border.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: theme.primary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.fitness_center_rounded, size: 18, color: theme.primary),
              ),
              const SizedBox(width: 10),
              Text(
                'Ejercicios de la sesión',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: theme.text,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: theme.cardDark,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: theme.border.withValues(alpha: 0.5)),
                ),
                child: Text(
                  '${exercises.length} bloques',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: theme.textMuted,
                  ),
                ),
              ),
            ],
          ),
          if (fuerzaCount > 0 || cardioCount > 0) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                if (cardioCount > 0)
                  _TagSummary(
                    label: '$cardioCount Cardio/Velocidad',
                    color: const Color(0xFFD97B4A),
                    icon: Icons.directions_run_outlined,
                  ),
                if (cardioCount > 0 && fuerzaCount > 0)
                  const SizedBox(width: 8),
                if (fuerzaCount > 0)
                  _TagSummary(
                    label: '$fuerzaCount Fuerza',
                    color: const Color(0xFFB05A30),
                    icon: Icons.fitness_center_outlined,
                  ),
              ],
            ),
          ],
          const SizedBox(height: 16),
          Divider(color: theme.border.withValues(alpha: 0.3), height: 1),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: exercises.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final ej = exercises[index];
              final nombre = ej['nombre'] as String? ?? 'Ejercicio';
              final rawTipo = (ej['tipo'] ?? ej['bloque'] ?? '').toString();
              final tipoUpper = rawTipo.toUpperCase();
              final metricStr = _formatMetric(ej);
              final badgeColor = _badgeBgColor(tipoUpper);
              final isSelected = selectedIndex == index;

              return InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: onSelectExercise != null
                    ? () => onSelectExercise!(index)
                    : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.primary.withValues(alpha: 0.12)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected
                          ? theme.primary
                          : theme.border.withValues(alpha: 0.25),
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? theme.primary
                              : const Color(0xFF4CAF50).withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isSelected ? Icons.touch_app : Icons.check,
                          size: 14,
                          color: isSelected ? Colors.white : const Color(0xFF4CAF50),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              nombre,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                color: isSelected ? theme.primary : theme.text,
                              ),
                            ),
                            if (metricStr.isNotEmpty) ...[
                              const SizedBox(height: 3),
                              Text(
                                metricStr,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: theme.textMuted,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (rawTipo.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: badgeColor.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            tipoUpper,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.6,
                              color: badgeColor,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _TagSummary extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;

  const _TagSummary({
    required this.label,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
