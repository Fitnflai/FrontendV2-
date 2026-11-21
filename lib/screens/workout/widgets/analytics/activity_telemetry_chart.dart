import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../config/app_theme_extension.dart';

enum TelemetryType { pace, elevation, heartRate }

class ActivityTelemetryChart extends StatelessWidget {
  final String title;
  final String yAxisLabel;
  final List<FlSpot> spots;
  final TelemetryType type;
  final Color primaryColor;
  final String? footerStat1Label;
  final String? footerStat1Value;
  final String? footerStat2Label;
  final String? footerStat2Value;

  const ActivityTelemetryChart({
    super.key,
    required this.title,
    required this.yAxisLabel,
    required this.spots,
    required this.type,
    required this.primaryColor,
    this.footerStat1Label,
    this.footerStat1Value,
    this.footerStat2Label,
    this.footerStat2Value,
  });

  String _formatYValue(double value) {
    if (type == TelemetryType.pace) {
      final mins = (value / 60).floor();
      final secs = (value % 60).round();
      return '$mins:${secs.toString().padLeft(2, '0')}';
    }
    return value.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    if (spots.isEmpty) return const SizedBox.shrink();

    final theme = context.themeColors;

    final xValues = spots.map((s) => s.x).toList();
    final minX = xValues.reduce((a, b) => a < b ? a : b);
    final rawMaxX = xValues.reduce((a, b) => a > b ? a : b);
    final chartMinX = minX;
    final chartMaxX = (rawMaxX <= minX) ? minX + 1.0 : rawMaxX;

    final yValues = spots.map((s) => s.y).toList();
    final minY = yValues.reduce((a, b) => a < b ? a : b);
    final rawMaxY = yValues.reduce((a, b) => a > b ? a : b);

    // Padding on Y axis and guarantee maxY > minY
    final yRange = (rawMaxY - minY == 0) ? 10.0 : (rawMaxY - minY);
    final chartMinY = (minY - (yRange * 0.1)).clamp(0.0, double.infinity);
    final chartMaxY = (rawMaxY <= chartMinY) ? chartMinY + yRange : (rawMaxY + (yRange * 0.1));

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
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: theme.text,
                ),
              ),
              const Spacer(),
              Text(
                yAxisLabel,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: theme.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 180,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: theme.border.withValues(alpha: 0.25),
                    strokeWidth: 1,
                  ),
                  getDrawingVerticalLine: (value) => FlLine(
                    color: theme.border.withValues(alpha: 0.25),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            value.toStringAsFixed(0),
                            style: TextStyle(fontSize: 10, color: theme.textMuted),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 38,
                      getTitlesWidget: (value, meta) {
                        if (value == meta.min || value == meta.max) {
                          return const SizedBox.shrink();
                        }
                        return Text(
                          _formatYValue(value),
                          style: TextStyle(fontSize: 9, color: theme.textMuted),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    bottom: BorderSide(color: theme.border.withValues(alpha: 0.4)),
                    left: BorderSide(color: theme.border.withValues(alpha: 0.4)),
                  ),
                ),
                minX: chartMinX,
                maxX: chartMaxX,
                minY: chartMinY,
                maxY: chartMaxY,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    curveSmoothness: 0.35,
                    color: primaryColor,
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          primaryColor.withValues(alpha: 0.35),
                          primaryColor.withValues(alpha: 0.05),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'km',
              style: TextStyle(fontSize: 10, color: theme.textMuted),
            ),
          ),
          if (footerStat1Label != null || footerStat2Label != null) ...[
            const SizedBox(height: 12),
            Divider(color: theme.border.withValues(alpha: 0.3), height: 1),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (footerStat1Label != null && footerStat1Value != null)
                  _StatFooterItem(
                    label: footerStat1Label!,
                    value: footerStat1Value!,
                    theme: theme,
                  ),
                if (footerStat2Label != null && footerStat2Value != null)
                  _StatFooterItem(
                    label: footerStat2Label!,
                    value: footerStat2Value!,
                    theme: theme,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _StatFooterItem extends StatelessWidget {
  final String label;
  final String value;
  final AppThemeExtensionWrapper theme;

  const _StatFooterItem({
    required this.label,
    required this.value,
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
            fontSize: 11,
            color: theme.textMuted,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: theme.text,
          ),
        ),
      ],
    );
  }
}
