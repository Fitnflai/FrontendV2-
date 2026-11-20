import 'package:flutter/material.dart';
import '../../../../config/app_theme_extension.dart';
import '../../../../models/activity_detail.dart';

class ActivitySplitsList extends StatelessWidget {
  final List<ActivitySplit> splits;

  const ActivitySplitsList({super.key, required this.splits});

  String _formatPace(double paceSec) {
    if (paceSec <= 0) return '--:--';
    final mins = (paceSec / 60).floor();
    final secs = (paceSec % 60).round();
    return '$mins:${secs.toString().padLeft(2, '0')}/km';
  }

  String _formatDiff(int diffSec) {
    if (diffSec == 0) return '-';
    final sign = diffSec > 0 ? '+' : '-';
    final abs = diffSec.abs();
    final mins = abs ~/ 60;
    final secs = abs % 60;
    if (mins > 0) {
      return '$sign$mins:${secs.toString().padLeft(2, '0')}';
    }
    return '${sign}0:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (splits.isEmpty) return const SizedBox.shrink();

    final theme = context.themeColors;
    final maxPace = splits.map((s) => s.paceSecPerKm).reduce((a, b) => a > b ? a : b);

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
          Text(
            'Parciales',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: theme.text,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              SizedBox(
                width: 32,
                child: Text(
                  'KM',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: theme.textMuted,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'RITMO PROMEDIO',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: theme.textMuted,
                  ),
                ),
              ),
              Text(
                '+/-',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: theme.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: splits.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final split = splits[index];
              final ratio = (split.paceSecPerKm / maxPace).clamp(0.4, 1.0);

              // In running: negative diff means faster than previous split (green/good), positive means slower
              final isFaster = split.diffPreviousSplitSec < 0;
              final isNeutral = split.diffPreviousSplitSec == 0;
              final diffColor = isNeutral
                  ? theme.textMuted
                  : (isFaster ? const Color(0xFF4CAF50) : const Color(0xFFEF5350));

              return Row(
                children: [
                  SizedBox(
                    width: 32,
                    child: Text(
                      '${split.kilometer}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: theme.text,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: ratio,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE57373).withValues(alpha: 0.85),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            _formatPace(split.paceSecPerKm),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 50,
                    child: Text(
                      _formatDiff(split.diffPreviousSplitSec),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: diffColor,
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
