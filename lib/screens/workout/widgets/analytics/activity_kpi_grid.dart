import 'package:flutter/material.dart';
import '../../../../config/app_theme_extension.dart';
import '../../../../models/activity_detail.dart';

class ActivityKpiGrid extends StatelessWidget {
  final ActivitySummary summary;

  const ActivityKpiGrid({super.key, required this.summary});

  String _formatPace(double paceSec) {
    if (paceSec <= 0) return '--:--';
    final mins = (paceSec / 60).floor();
    final secs = (paceSec % 60).round();
    return '$mins:${secs.toString().padLeft(2, '0')} /km';
  }

  String _formatDuration(int totalSeconds) {
    if (totalSeconds <= 0) return '00:00';
    final hours = totalSeconds ~/ 3600;
    final mins = (totalSeconds % 3600) ~/ 60;
    final secs = totalSeconds % 60;
    if (hours > 0) {
      return '$hours:${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;
    final km = (summary.distanceMeters / 1000).toStringAsFixed(2);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.border.withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _KpiItem(
                  label: 'DISTANCIA',
                  value: '$km km',
                  theme: theme,
                ),
              ),
              Expanded(
                child: _KpiItem(
                  label: 'TIEMPO',
                  value: _formatDuration(summary.movingTimeSeconds),
                  theme: theme,
                ),
              ),
              Expanded(
                child: _KpiItem(
                  label: 'RITMO PROMEDIO',
                  value: _formatPace(summary.avgPaceSecPerKm),
                  theme: theme,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: theme.border.withValues(alpha: 0.3), height: 1),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _KpiItem(
                  label: 'DESNIVEL POSITIVO',
                  value: '${summary.elevationGainMeters.toStringAsFixed(0)} m',
                  prefixIcon: Icons.arrow_drop_up,
                  theme: theme,
                ),
              ),
              Expanded(
                child: _KpiItem(
                  label: 'FC MEDIA',
                  value: '${summary.avgHeartRate} bpm',
                  theme: theme,
                ),
              ),
              Expanded(
                child: _KpiItem(
                  label: 'CADENCIA',
                  value: '${summary.avgCadence} spm',
                  theme: theme,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: theme.border.withValues(alpha: 0.3), height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _KpiItem(
                  label: 'CALORÍAS',
                  value: '${summary.calories} kcal',
                  theme: theme,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _KpiItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData? prefixIcon;
  final AppThemeExtensionWrapper theme;

  const _KpiItem({
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
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
            color: theme.textMuted,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (prefixIcon != null)
              Icon(prefixIcon, size: 18, color: theme.primary),
            Flexible(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 17,
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
