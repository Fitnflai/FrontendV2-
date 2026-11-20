import 'package:flutter/material.dart';
import '../../../../config/app_theme_extension.dart';
import '../../../../models/activity_detail.dart';

class ActivityBestEffortsCard extends StatelessWidget {
  final List<BestEffort> bestEfforts;

  const ActivityBestEffortsCard({super.key, required this.bestEfforts});

  String _formatDuration(int seconds) {
    final mins = seconds ~/ 60;
    final remainingSecs = seconds % 60;
    return '$mins:${remainingSecs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (bestEfforts.isEmpty) return const SizedBox.shrink();

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
                'Mejores tiempos',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: theme.text,
                ),
              ),
              const Spacer(),
              Icon(Icons.military_tech_outlined, size: 20, color: theme.primary),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: bestEfforts.map((effort) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: theme.cardDark,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.border.withValues(alpha: 0.5)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        effort.label.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: theme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _formatDuration(effort.timeSeconds),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: theme.text,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          Text(
            'Los mejores tiempos se calculan utilizando el tiempo transcurrido total.',
            style: TextStyle(
              fontSize: 11,
              color: theme.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
