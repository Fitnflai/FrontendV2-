import 'package:flutter/material.dart';
import '../../../../config/app_theme_extension.dart';
import '../../../../models/activity_detail.dart';

class ActivityHrZonesCard extends StatelessWidget {
  final List<HrZoneDetail> zones;

  const ActivityHrZonesCard({super.key, required this.zones});

  String _formatDuration(int seconds) {
    final mins = seconds ~/ 60;
    final remainingSecs = seconds % 60;
    return '$mins:${remainingSecs.toString().padLeft(2, '0')}';
  }

  Color _getZoneColor(int zoneNumber) {
    switch (zoneNumber) {
      case 1:
        return const Color(0xFF607D8B); // Slate Grey
      case 2:
        return const Color(0xFF2196F3); // Blue
      case 3:
        return const Color(0xFF4CAF50); // Green
      case 4:
        return const Color(0xFFFF9800); // Orange
      case 5:
        return const Color(0xFFF44336); // Red
      default:
        return const Color(0xFF9E9E9E);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (zones.isEmpty || zones.every((z) => z.percentage <= 0 && z.timeInSeconds <= 0)) {
      return const SizedBox.shrink();
    }

    final theme = context.themeColors;

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
              Text(
                'Zonas de ritmo cardíaco',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: theme.text,
                ),
              ),
              const Spacer(),
              Icon(Icons.help_outline, size: 16, color: theme.textMuted),
            ],
          ),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: zones.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final zone = zones[index];
              final percentDisplay = (zone.percentage * 100).round();
              final color = _getZoneColor(zone.zoneNumber);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Zona ${zone.zoneNumber}  ${zone.minBpm}-${zone.maxBpm} bpm',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: theme.text,
                        ),
                      ),
                      Text(
                        '$percentDisplay%  ${_formatDuration(zone.timeInSeconds)}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: theme.textMuted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Container(
                      height: 8,
                      width: double.infinity,
                      color: theme.border.withValues(alpha: 0.3),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: zone.percentage.clamp(0.0, 1.0),
                        child: Container(color: color),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
