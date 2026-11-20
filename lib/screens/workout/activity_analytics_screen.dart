import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme_extension.dart';
import '../../models/activity_detail.dart';
import '../../providers/auth_provider.dart';
import '../../services/activity_analytics_service.dart';
import 'widgets/analytics/activity_best_efforts_card.dart';
import 'widgets/analytics/activity_hr_zones_card.dart';
import 'widgets/analytics/activity_kpi_grid.dart';
import 'widgets/analytics/activity_laps_chart.dart';
import 'widgets/analytics/activity_map_header.dart';
import 'widgets/analytics/activity_splits_list.dart';
import 'widgets/analytics/activity_telemetry_chart.dart';

class ActivityAnalyticsScreen extends StatefulWidget {
  final String activityId;
  final ActivityDetail? initialActivity;

  const ActivityAnalyticsScreen({
    super.key,
    required this.activityId,
    this.initialActivity,
  });

  @override
  State<ActivityAnalyticsScreen> createState() => _ActivityAnalyticsScreenState();
}

class _ActivityAnalyticsScreenState extends State<ActivityAnalyticsScreen> {
  final ActivityAnalyticsService _service = ActivityAnalyticsService();
  ActivityDetail? _activity;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _activity = widget.initialActivity;
    if (_activity == null) {
      _loadActivity();
    }
  }

  Future<void> _loadActivity() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final auth = context.read<AuthProvider>();
      final userId = auth.user?.id.toString() ?? '';
      final token = auth.token ?? '';

      final data = await _service.getActivityAnalytics(
        activityId: widget.activityId,
        userId: userId,
        token: token,
      );

      if (mounted) {
        setState(() {
          _activity = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'No se pudieron cargar los datos de la actividad.';
          _isLoading = false;
        });
      }
    }
  }

  String _formatPace(double paceSec) {
    if (paceSec <= 0) return '--:--';
    final mins = (paceSec / 60).floor();
    final secs = (paceSec % 60).round();
    return '$mins:${secs.toString().padLeft(2, '0')}/km';
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;

    return Scaffold(
      backgroundColor: theme.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: theme.text, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _activity?.title ?? 'Resumen de actividad',
          style: TextStyle(
            color: theme.text,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: theme.text),
            onPressed: () {},
          ),
        ],
      ),
      body: _buildBody(theme),
    );
  }

  Widget _buildBody(AppThemeExtensionWrapper theme) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(color: theme.primary),
      );
    }

    if (_errorMessage != null || _activity == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 48, color: theme.errorText),
              const SizedBox(height: 16),
              Text(
                _errorMessage ?? 'Actividad no encontrada',
                textAlign: TextAlign.center,
                style: TextStyle(color: theme.text, fontSize: 15),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadActivity,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    final act = _activity!;
    final paceSpots = act.telemetry
        .map((t) => FlSpot(t.distanceKm, t.paceSecPerKm))
        .toList();
    final elevationSpots = act.telemetry
        .map((t) => FlSpot(t.distanceKm, t.elevationMeters))
        .toList();
    final hrSpots = act.telemetry
        .map((t) => FlSpot(t.distanceKm, t.heartRateBpm.toDouble()))
        .toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          ActivityMapHeader(
            activity: act,
            onShare: () {},
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                ActivityKpiGrid(summary: act.summary),
                if (act.bestEfforts.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  ActivityBestEffortsCard(bestEfforts: act.bestEfforts),
                ],
                if (act.laps.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  ActivityLapsChart(laps: act.laps),
                ],
                if (act.splits.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  ActivitySplitsList(splits: act.splits),
                ],
                if (paceSpots.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  ActivityTelemetryChart(
                    title: 'Ritmo',
                    yAxisLabel: '/km',
                    spots: paceSpots,
                    type: TelemetryType.pace,
                    primaryColor: const Color(0xFF26A69A), // Cyan / Teal
                    footerStat1Label: 'Ritmo prom.',
                    footerStat1Value: _formatPace(act.summary.avgPaceSecPerKm),
                    footerStat2Label: 'Ritmo máx.',
                    footerStat2Value: act.summary.maxPaceSecPerKm != null
                        ? _formatPace(act.summary.maxPaceSecPerKm!)
                        : null,
                  ),
                ],
                if (elevationSpots.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  ActivityTelemetryChart(
                    title: 'Desnivel',
                    yAxisLabel: 'm',
                    spots: elevationSpots,
                    type: TelemetryType.elevation,
                    primaryColor: const Color(0xFF42A5F5), // Blue
                    footerStat1Label: 'Desnivel positivo',
                    footerStat1Value: '${act.summary.elevationGainMeters.toStringAsFixed(0)} m',
                    footerStat2Label: 'Desnivel máx.',
                    footerStat2Value: act.summary.maxElevationMeters != null
                        ? '${act.summary.maxElevationMeters!.toStringAsFixed(0)} m'
                        : null,
                  ),
                ],
                if (hrSpots.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  ActivityTelemetryChart(
                    title: 'Ritmo cardíaco',
                    yAxisLabel: 'bpm',
                    spots: hrSpots,
                    type: TelemetryType.heartRate,
                    primaryColor: const Color(0xFFEF5350), // Red / Coral
                    footerStat1Label: 'Ritmo cardiaco med.',
                    footerStat1Value: '${act.summary.avgHeartRate} bpm',
                    footerStat2Label: 'Ritmo cardiaco máx.',
                    footerStat2Value: act.summary.maxHeartRate != null
                        ? '${act.summary.maxHeartRate} bpm'
                        : null,
                  ),
                ],
                if (act.hrZones.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  ActivityHrZonesCard(zones: act.hrZones),
                ],
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
