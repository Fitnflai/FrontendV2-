import 'package:flutter/material.dart';
import '../../../../config/app_theme_extension.dart';
import '../../../../models/activity_detail.dart';

class ActivityExerciseInspectorCard extends StatelessWidget {
  final Map<String, dynamic> exercise;
  final int index;
  final ActivityLap? lap;
  final ActivitySummary sessionSummary;
  final VoidCallback onClose;

  const ActivityExerciseInspectorCard({
    super.key,
    required this.exercise,
    required this.index,
    this.lap,
    required this.sessionSummary,
    required this.onClose,
  });

  String _formatPace(double paceSec) {
    if (paceSec <= 0) return '--:--';
    final mins = (paceSec / 60).floor();
    final secs = (paceSec % 60).round();
    return '$mins:${secs.toString().padLeft(2, '0')}/km';
  }

  String _formatDuration(int seconds) {
    if (seconds <= 0) return '00:00';
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;
    final nombre = exercise['nombre'] as String? ?? 'Ejercicio';
    final rawTipo = (exercise['tipo'] ?? exercise['bloque'] ?? '').toString().toUpperCase();

    final isCardio = rawTipo.contains('CARDIO') || rawTipo.contains('CARRERA') || rawTipo.contains('VELOCIDAD');
    final isFuerza = rawTipo.contains('FUERZA');
    final isMovilidad = rawTipo.contains('MOVILIDAD');

    final color = isFuerza
        ? const Color(0xFFB05A30)
        : (isCardio ? const Color(0xFFD97B4A) : const Color(0xFF2E9E6B));

    final icon = isFuerza
        ? Icons.fitness_center_rounded
        : (isCardio ? Icons.directions_run_outlined : Icons.self_improvement_rounded);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.6),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Icon, Name, Badge, Close button
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 20, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            rawTipo.isNotEmpty ? rawTipo : 'EJERCICIO',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.6,
                              color: color,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Paso ${index + 1}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: theme.textMuted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      nombre,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: theme.text,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: theme.textMuted, size: 20),
                tooltip: 'Ver sesión completa',
                onPressed: onClose,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: theme.border.withValues(alpha: 0.3), height: 1),
          const SizedBox(height: 14),

          // Body metrics depending on discipline
          if (isCardio)
            _buildCardioMetrics(theme, color)
          else if (isFuerza)
            _buildFuerzaMetrics(theme, color)
          else
            _buildMovilidadMetrics(theme, color),

          const SizedBox(height: 12),
          // Action button to deselect
          InkWell(
            onTap: onClose,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.unfold_less, size: 14, color: theme.primary),
                  const SizedBox(width: 6),
                  Text(
                    'Volver al resumen general de la sesión',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: theme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardioMetrics(AppThemeExtensionWrapper theme, Color color) {
    final distanceM = lap?.distanceMeters ?? 0.0;
    final paceSec = lap?.actualPaceSecPerKm ?? 0.0;
    final targetPace = lap?.targetPaceSecPerKm;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _MetricTile(
                label: 'DISTANCIA TRAMO',
                value: distanceM >= 1000
                    ? '${(distanceM / 1000).toStringAsFixed(2)} km'
                    : '${distanceM.toStringAsFixed(0)} m',
                theme: theme,
              ),
            ),
            Expanded(
              child: _MetricTile(
                label: 'RITMO DEL TRAMO',
                value: _formatPace(paceSec),
                theme: theme,
              ),
            ),
            Expanded(
              child: _MetricTile(
                label: 'PULSO MEDIO',
                value: sessionSummary.avgHeartRate > 0
                    ? '${sessionSummary.avgHeartRate} bpm'
                    : '-- bpm',
                theme: theme,
              ),
            ),
          ],
        ),
        if (targetPace != null) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: theme.cardDark,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: theme.border.withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                Icon(Icons.flag_outlined, size: 14, color: theme.primary),
                const SizedBox(width: 6),
                Text(
                  'Objetivo: ${_formatPace(targetPace)}',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: theme.text),
                ),
                const Spacer(),
                Text(
                  paceSec <= targetPace ? '✓ Cumplido' : '+ Ritmo alto',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: paceSec <= targetPace ? const Color(0xFF4CAF50) : const Color(0xFFEF5350),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.my_location, size: 12, color: color),
            const SizedBox(width: 6),
            Text(
              'Tramo resaltado en el mapa superior',
              style: TextStyle(fontSize: 11, color: theme.textMuted, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFuerzaMetrics(AppThemeExtensionWrapper theme, Color color) {
    final series = exercise['series']?.toString() ?? '1';
    final reps = exercise['reps']?.toString() ?? exercise['repeticiones']?.toString() ?? '1';
    final descanso = exercise['descanso_seg'] ?? exercise['descanso_segundos'] ?? 60;
    final pesoStr = exercise['peso']?.toString() ?? '';

    final numSeries = int.tryParse(series) ?? 1;
    final numReps = int.tryParse(reps) ?? 1;
    final numPeso = double.tryParse(pesoStr) ?? 0.0;
    final totalVolumen = numSeries * numReps * (numPeso > 0 ? numPeso : 0);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _MetricTile(
                label: 'SERIES × REPS',
                value: '$series × $reps',
                theme: theme,
              ),
            ),
            Expanded(
              child: _MetricTile(
                label: 'PESO / CARGA',
                value: numPeso > 0 ? '${numPeso.toStringAsFixed(0)} kg' : 'Corporal',
                theme: theme,
              ),
            ),
            Expanded(
              child: _MetricTile(
                label: 'VOLUMEN CARGA',
                value: totalVolumen > 0
                    ? '${totalVolumen.toStringAsFixed(0)} kg'
                    : '${numSeries * numReps} reps',
                theme: theme,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _MetricTile(
                label: 'DESCANSO PLAN.',
                value: '${descanso}s',
                prefixIcon: Icons.timer_outlined,
                theme: theme,
              ),
            ),
            Expanded(
              child: _MetricTile(
                label: 'PULSO DE ESFUERZO',
                value: sessionSummary.avgHeartRate > 0
                    ? '${sessionSummary.avgHeartRate} bpm'
                    : '-- bpm',
                prefixIcon: Icons.favorite_border,
                theme: theme,
              ),
            ),
            Expanded(
              child: _MetricTile(
                label: 'TUT ESTIMADO',
                value: '${numReps * 3}s / serie',
                theme: theme,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMovilidadMetrics(AppThemeExtensionWrapper theme, Color color) {
    final dur = exercise['dur']?.toString() ?? '5 min';
    final durSeg = int.tryParse(exercise['dur_seg']?.toString() ?? '') ?? 300;

    return Row(
      children: [
        Expanded(
          child: _MetricTile(
            label: 'DURACIÓN SOSTENIDA',
            value: dur.isNotEmpty ? dur : _formatDuration(durSeg),
            theme: theme,
          ),
        ),
        Expanded(
          child: _MetricTile(
            label: 'ENFOQUE',
            value: 'Vuelta a la calma',
            theme: theme,
          ),
        ),
        Expanded(
          child: _MetricTile(
            label: 'PULSO DE RECUP.',
            value: sessionSummary.avgHeartRate > 0
                ? '< ${sessionSummary.avgHeartRate} bpm'
                : '--',
            theme: theme,
          ),
        ),
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData? prefixIcon;
  final AppThemeExtensionWrapper theme;

  const _MetricTile({
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
            fontWeight: FontWeight.w700,
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
