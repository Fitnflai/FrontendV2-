import 'package:flutter/material.dart';
import '../../../../config/app_theme_extension.dart';
import '../../../../models/activity_detail.dart';

class ActivityLapsChart extends StatelessWidget {
  final List<ActivityLap> laps;

  const ActivityLapsChart({super.key, required this.laps});

  String _formatPace(double paceSec) {
    if (paceSec <= 0) return '--:--';
    final mins = (paceSec / 60).floor();
    final secs = (paceSec % 60).round();
    return '$mins:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (laps.isEmpty) return const SizedBox.shrink();

    final theme = context.themeColors;
    final hasTargets = laps.any((l) => l.targetPaceSecPerKm != null);

    // Calculate maximum pace to scale bars
    final allPaces = laps.map((l) => l.actualPaceSecPerKm).toList();
    if (hasTargets) {
      allPaces.addAll(laps.where((l) => l.targetPaceSecPerKm != null).map((l) => l.targetPaceSecPerKm!));
    }
    final maxPace = allPaces.isNotEmpty ? allPaces.reduce((a, b) => a > b ? a : b) : 400.0;
    const chartHeight = 160.0;

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
                'Vueltas',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: theme.text,
                ),
              ),
              const Spacer(),
              if (hasTargets) ...[
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: theme.textSecondary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'OBJETIVO',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                    color: theme.textMuted,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: chartHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: laps.map((lap) {
                // In running, lower paceSec is faster, but visually a taller bar represents more effort or relative pace
                final safeMaxPace = maxPace > 0 ? maxPace : 1.0;
                final barRatio = maxPace > 0
                    ? (lap.actualPaceSecPerKm / safeMaxPace).clamp(0.2, 1.0)
                    : 0.2;
                final actualBarHeight = chartHeight * barRatio * 0.85;

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Target indicator bar (if defined)
                        if (lap.targetPaceSecPerKm != null) ...[
                          Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: theme.border,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          const SizedBox(height: 6),
                        ],
                        // Actual pace bar
                        Container(
                          height: actualBarHeight,
                          decoration: BoxDecoration(
                            color: const Color(0xFF66BB6A).withValues(alpha: 0.85),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Center(
                            child: Text(
                              _formatPace(lap.actualPaceSecPerKm),
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'V${lap.lapOrder}',
                          style: TextStyle(
                            fontSize: 10,
                            color: theme.textMuted,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
