import 'package:flutter/material.dart';
import '../../../../config/app_theme_extension.dart';
import '../../../../models/activity_detail.dart';

class ActivityLapsChart extends StatelessWidget {
  final List<ActivityLap> laps;
  final int? selectedLapOrder;
  final ValueChanged<int>? onSelectLap;

  const ActivityLapsChart({
    super.key,
    required this.laps,
    this.selectedLapOrder,
    this.onSelectLap,
  });

  String _formatPace(double paceSec) {
    if (paceSec <= 0) return '--:--';
    final mins = (paceSec / 60).floor();
    final secs = (paceSec % 60).round();
    return '$mins:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (laps.isEmpty || laps.every((l) => l.actualPaceSecPerKm <= 0 && l.distanceMeters <= 0)) {
      return const SizedBox.shrink();
    }

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
                'Vueltas / Intervalos',
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
                final isSelected = selectedLapOrder == lap.lapOrder;
                // In running, lower paceSec is faster, but visually a taller bar represents more effort or relative pace
                final safeMaxPace = maxPace > 0 ? maxPace : 1.0;
                final barRatio = maxPace > 0
                    ? (lap.actualPaceSecPerKm / safeMaxPace).clamp(0.2, 1.0)
                    : 0.2;
                final actualBarHeight = chartHeight * barRatio * 0.85;

                return Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(6),
                    onTap: onSelectLap != null ? () => onSelectLap!(lap.lapOrder) : null,
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
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            height: actualBarHeight,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? theme.primary
                                  : const Color(0xFF66BB6A).withValues(alpha: 0.85),
                              borderRadius: BorderRadius.circular(6),
                              border: isSelected
                                  ? Border.all(color: Colors.white, width: 2)
                                  : null,
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: theme.primary.withValues(alpha: 0.5),
                                        blurRadius: 8,
                                      ),
                                    ]
                                  : null,
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
                              color: isSelected ? theme.primary : theme.textMuted,
                              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
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
