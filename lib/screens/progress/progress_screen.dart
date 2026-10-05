import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/wellness_factor.dart';
import '../../models/progress_report.dart';
import '../../providers/auth_provider.dart';
import '../../providers/progress_report_provider.dart';
import '../../providers/wellness_index_provider.dart';

import '../../config/app_theme_extension.dart';
import '../../widgets/bottom_nav.dart';
import '../../widgets/shared_widgets.dart';
import '../../l10n/app_localizations.dart';

// ─────────────────────────────────────────────
// SCREEN
// ─────────────────────────────────────────────
class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});
  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  late ProgressReportProvider _progressReportProvider;
  late WellnessIndexProvider _wellnessIndexProvider;

  bool _hasFetched = false;

  @override
  void initState() {
    super.initState();
    _progressReportProvider = Provider.of<ProgressReportProvider>(context, listen: false);
    _wellnessIndexProvider  = Provider.of<WellnessIndexProvider>(context, listen: false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final auth = Provider.of<AuthProvider>(context);
    if (auth.status == AuthStatus.authenticated && !_hasFetched) {
      _hasFetched = true;
      Future.microtask(() => _fetchData(_progressReportProvider.weekOffset));
    }
  }

  Future<void> _fetchData(int weekOffset) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;

    if (token != null) {
      await _progressReportProvider.fetchProgressReport(token: token, weekOffset: weekOffset);
      if (_progressReportProvider.status == ProgressReportStatus.loaded && _progressReportProvider.report != null) {
        _wellnessIndexProvider.updateFromProgressReport(_progressReportProvider.report!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>() ?? AppThemeExtension.dark;
    final l10n  = AppLocalizations.of(context);

    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;
    final tienePlan = user?.tienePlanActivo == true;

    if (!tienePlan) {
      return Scaffold(
        backgroundColor: theme.bg,
        body: const BlockingMembershipOverlay(),
        bottomNavigationBar: const AppBottomNav(selectedIndex: 2),
      );
    }

    return Scaffold(
      backgroundColor: theme.bg,
      body: SafeArea(
        bottom: false,
        child: Column(children: [
          AppHeader(section: l10n.progressHeaderSection),
          Expanded(
            child: Consumer<ProgressReportProvider>(
              builder: (context, provider, child) {
                if (provider.status == ProgressReportStatus.loading && provider.report == null) {
                  return const Center(child: CircularProgressIndicator());
                } else if (provider.status == ProgressReportStatus.error) {
                  final isEs = Localizations.localeOf(context).languageCode == 'es';
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          provider.errorMessage ?? (isEs ? 'Error al cargar el informe' : 'Error loading report'),
                          style: TextStyle(color: theme.redText),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => _fetchData(provider.weekOffset),
                          child: Text(isEs ? 'Reintentar' : 'Retry'),
                        ),
                      ],
                    ),
                  );
                } else if (provider.report != null) {
                  final report = provider.report!;
                  final isEs = Localizations.localeOf(context).languageCode == 'es';
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),

                        if (provider.hasNoData) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2A1E08),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: const Color(0xFFEF9F27)),
                            ),
                            child: Row(children: [
                              const Icon(Icons.info_outline, color: Color(0xFFEF9F27), size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  isEs 
                                      ? 'Aún no tenemos datos suficientes para medir tu progreso. Regresa cuando pase una semana y verás tu progreso registrado.'
                                      : 'We do not have enough data to measure your progress yet. Come back in a week to see your progress registered.',
                                  style: const TextStyle(color: Color(0xFFEF9F27), fontSize: 11, fontWeight: FontWeight.w600, height: 1.4),
                                ),
                              ),
                            ]),
                          ),
                          const SizedBox(height: 12),
                        ],

                        // ── Selector de semana ────────────────────
                        _WeekSelector(
                          report: report,
                          weekOffset: provider.weekOffset,
                          onPrev: () => _fetchData(provider.weekOffset - 1),
                          onNext: provider.weekOffset < 0 ? () => _fetchData(provider.weekOffset + 1) : () {},
                        ),
                        const SizedBox(height: 16),

                        // ── Banner de estado ─────────────────────
                        if (!provider.hasNoData) ...[
                          _StatusBanner(report: report),
                          const SizedBox(height: 12),
                        ],

                        // ── Alerta de dolor ──────────────────────
                        _PainAlert(report: report),
                        const SizedBox(height: 16),

                        // ── Índice de Bienestar ──────────────────
                        _WellnessIndexCard(report: report),
                        const SizedBox(height: 16),

                        // ── Detalle de peso ──────────────────────
                        _WeightDetailCard(report: report),
                        const SizedBox(height: 16),

                        // ══ COLUMNA DERECHA (métricas secundarias) ══
                        _SecondaryMetricsSection(report: report),
                        const SizedBox(height: 16),

                        // ── También esta semana ──────────────────
                        _AlsoThisWeekSection(report: report),
                        const SizedBox(height: 16),

                        // ── Zonas de entrenamiento ────────────────
                        const _TrainingZonesCard(),
                        const SizedBox(height: 16),

                        // ── Enviar informe ───────────────────────
                        _SendReportCard(report: report),
                        const SizedBox(height: 24),
                      ],
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
          const AppBottomNav(selectedIndex: 2),
        ]),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// WEEK SELECTOR
// ─────────────────────────────────────────────
class _WeekSelector extends StatelessWidget {
  final ProgressReport report;
  final int weekOffset;
  final VoidCallback onPrev, onNext;
  const _WeekSelector({
    required this.report,
    required this.weekOffset,
    required this.onPrev,
    required this.onNext,
  });

  String _getWeekRangeLabel(int offset, bool isEs) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final currentMonday = today.subtract(Duration(days: today.weekday - 1));
    final targetMonday = currentMonday.add(Duration(days: offset * 7));
    final targetSunday = targetMonday.add(const Duration(days: 6));

    String format(DateTime d) {
      final day = d.day.toString().padLeft(2, '0');
      final month = d.month.toString().padLeft(2, '0');
      final year = d.year;
      return '$day/$month/$year';
    }

    return '${format(targetMonday)} - ${format(targetSunday)}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>() ?? AppThemeExtension.dark;
    final isEs  = Localizations.localeOf(context).languageCode == 'es';
    
    final dateRange = _getWeekRangeLabel(weekOffset, isEs);
    final semInfo = (report.semanaInfo != null && report.semanaInfo != "Semana --")
        ? report.semanaInfo!
        : (weekOffset == 0 
            ? (isEs ? 'Semana actual' : 'Current week') 
            : (isEs ? 'Semana' : 'Week'));
    final label = '$semInfo · $dateRange';
    
    final sub = report.actualizado != null && report.actualizado != '-'
        ? (isEs ? 'Actualizado: ${report.actualizado}' : 'Updated: ${report.actualizado}')
        : (isEs ? 'Sin actualizar' : 'Not updated');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.border),
      ),
      child: Row(children: [
        Icon(Icons.calendar_today_outlined, color: theme.grey, size: 18),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: TextStyle(color: theme.white, fontSize: 13, fontWeight: FontWeight.w700)),
          Text(sub,   style: TextStyle(color: theme.grey,  fontSize: 11)),
        ])),
        GestureDetector(
          onTap: onPrev,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: theme.cardDark, borderRadius: BorderRadius.circular(8)),
            child: Icon(Icons.chevron_left, color: theme.grey, size: 18),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: weekOffset < 0 ? onNext : null,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: weekOffset < 0 ? theme.cardDark : theme.cardDark.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.chevron_right,
              color: weekOffset < 0 ? theme.grey : theme.grey.withValues(alpha: 0.3),
              size: 18,
            ),
          ),
        ),
      ]),
    );
  }
}

// ─────────────────────────────────────────────
// STATUS BANNER
// ─────────────────────────────────────────────
class _StatusBanner extends StatelessWidget {
  final ProgressReport report;
  const _StatusBanner({required this.report});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>() ?? AppThemeExtension.dark;
    final isEs  = Localizations.localeOf(context).languageCode == 'es';

    final wellbeingIdx = report.indiceBienestar ?? 0;
    final isGood = wellbeingIdx >= 60;
    final title = isGood 
        ? (isEs ? 'Vas por buen camino' : 'Keep it up') 
        : (isEs ? 'Enfoque en recuperación' : 'Focus on recovery');
        
    final aiMsg = report.mensajeIa ?? '';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.border),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: isGood ? theme.greenBg : const Color(0xFF2A1E08),
            shape: BoxShape.circle,
            border: Border.all(color: isGood ? theme.greenText : const Color(0xFFEF9F27), width: 2),
          ),
          child: Icon(
            isGood ? Icons.check : Icons.warning_amber_outlined,
            color: isGood ? theme.greenText : const Color(0xFFEF9F27),
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: TextStyle(color: isGood ? theme.greenText : const Color(0xFFEF9F27), fontSize: 16, fontWeight: FontWeight.w800)),
          if (aiMsg.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(aiMsg, style: TextStyle(color: theme.greyLight, fontSize: 13, height: 1.4)),
          ],
        ])),
      ]),
    );
  }
}

// ─────────────────────────────────────────────
// PAIN ALERT
// ─────────────────────────────────────────────
class _PainAlert extends StatelessWidget {
  final ProgressReport report;
  const _PainAlert({required this.report});

  @override
  Widget build(BuildContext context) {
    final alertActive = report.alertas?.activa ?? false;
    final body   = report.alertas?.detalle ?? '';
    if (!alertActive || body.trim().isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context).extension<AppThemeExtension>() ?? AppThemeExtension.dark;
    final isEs  = Localizations.localeOf(context).languageCode == 'es';

    final title  = isEs ? 'Alerta de dolor activa' : 'Active pain alert';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: theme.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.redMid),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(Icons.water_drop_outlined, color: theme.redText, size: 20),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Text(title,
                style: TextStyle(color: theme.redText, fontSize: 13, fontWeight: FontWeight.w700))),
            Icon(Icons.chevron_right, color: theme.grey, size: 18),
          ]),
          const SizedBox(height: 4),
          Text(body, style: TextStyle(color: theme.greyLight, fontSize: 12, height: 1.4)),
        ])),
      ]),
    );
  }
}

// ─────────────────────────────────────────────
// WELLNESS INDEX CARD
// ─────────────────────────────────────────────
class _WellnessIndexCard extends StatelessWidget {
  final ProgressReport report;
  const _WellnessIndexCard({required this.report});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>() ?? AppThemeExtension.dark;
    final isEs  = Localizations.localeOf(context).languageCode == 'es';

    final title       = isEs ? 'Índice de Bienestar' : 'Wellness Index';
    final wellbeingIdx = report.indiceBienestar ?? 0;
    final isGood      = wellbeingIdx >= 60;
    final statusLabel = isGood 
        ? (isEs ? 'Buen estado' : 'Good condition') 
        : (isEs ? 'Por mejorar' : 'Needs work');
        
    final variationVal = report.variacionIndiceBienestar ?? 0;
    final isPositive  = variationVal >= 0;
    final changeLabel = isEs 
        ? '${isPositive ? "↑" : "↓"} ${variationVal.abs().toStringAsFixed(0)} pts\nvs semana anterior'
        : '${isPositive ? "↑" : "↓"} ${variationVal.abs().toStringAsFixed(0)} pts\nvs prev. week';

    double maxWell = wellbeingIdx.toDouble();
    int bestSem = 1;
    if (report.evolucionIndiceBienestar.isNotEmpty) {
      for (var ev in report.evolucionIndiceBienestar) {
        final score = ev.puntaje ?? 0.0;
        if (score > maxWell) {
          maxWell = score.toDouble();
          bestSem = (ev.semanaActual ?? 1).toInt();
        }
      }
    }
    final bestLabel = isEs 
        ? 'Mejor: ${maxWell.toStringAsFixed(0)} pts\nSemana $bestSem'
        : 'Best: ${maxWell.toStringAsFixed(0)} pts\nWeek $bestSem';
        
    final evolutionLabel = isEs ? 'Evolución de Bienestar' : 'Wellness Evolution';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.border),
      ),
      child: Consumer<WellnessIndexProvider>(
        builder: (context, provider, child) {
          final WellnessFactor selectedFactor = provider.selectedFactor;
          final factorScores = selectedFactor.scores;
          final factorLabels = selectedFactor.labels;
          final yBounds = selectedFactor.getYBounds();
          final chartMinY = yBounds['minY']!;
          final chartMaxY = yBounds['maxY']!;
          final factorLineColor = selectedFactor.colorResolver(theme);

          final maxScore = factorScores.isNotEmpty ? factorScores.reduce(math.max) : 0.0;
          final minScore = factorScores.isNotEmpty ? factorScores.reduce(math.min) : 0.0;
          final currentScore = factorScores.isNotEmpty ? factorScores.last : 0.0;

          final maxLabel    = isEs ? 'Máximo (${maxScore.toInt()})' : 'Maximum (${maxScore.toInt()})';
          final minLabel    = isEs ? 'Mínimo (${minScore.toInt()})' : 'Minimum (${minScore.toInt()})';
          final actualLabel = isEs ? 'Actual (${currentScore.toInt()})' : 'Current (${currentScore.toInt()})';

          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Header
            Row(children: [
              Text(title, style: TextStyle(color: theme.white, fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(width: 6),
              Icon(Icons.info_outline, color: theme.grey, size: 16),
            ]),
            const SizedBox(height: 16),

            // Score row
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Ring
              SizedBox(
                width: 90, height: 90,
                child: Stack(alignment: Alignment.center, children: [
                  CustomPaint(
                    size: const Size(90, 90),
                    painter: _RingPainter(
                      value: (wellbeingIdx / 100.0).clamp(0.0, 1.0),
                      trackColor: theme.border,
                      fillColor: isGood ? theme.greenText : const Color(0xFFEF9F27),
                    ),
                  ),
                  Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(wellbeingIdx.toInt().toString(), style: TextStyle(color: theme.white, fontSize: 26, fontWeight: FontWeight.w800)),
                    Text('/100', style: TextStyle(color: theme.grey, fontSize: 11)),
                  ]),
                ]),
              ),
              const SizedBox(width: 16),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(statusLabel,
                    style: TextStyle(color: isGood ? theme.greenText : const Color(0xFFEF9F27), fontSize: 18, fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text(changeLabel,
                    style: TextStyle(color: isPositive ? theme.greenText : theme.redText, fontSize: 12, fontWeight: FontWeight.w600, height: 1.4)),
                const SizedBox(height: 6),
                Text(bestLabel,
                    style: TextStyle(color: theme.grey, fontSize: 11, height: 1.4)),
              ])),
            ]),
            const SizedBox(height: 14),

            // Progress bar 0-100
            Row(children: [
              Text('0', style: TextStyle(color: theme.grey, fontSize: 10)),
              Expanded(child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Stack(children: [
                  Container(height: 6,
                      decoration: BoxDecoration(color: theme.border, borderRadius: BorderRadius.circular(3))),
                  FractionallySizedBox(
                    widthFactor: (wellbeingIdx / 100.0).clamp(0.0, 1.0),
                    child: Container(height: 6,
                        decoration: BoxDecoration(
                          color: isGood ? theme.greenText : const Color(0xFFEF9F27),
                          borderRadius: BorderRadius.circular(3),
                        )),
                  ),
                ]),
              )),
              Text('100', style: TextStyle(color: theme.grey, fontSize: 10)),
            ]),
            const SizedBox(height: 14),

            // Interactive Factor Dropdown
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: theme.cardDark,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(Icons.stars_outlined, color: selectedFactor.colorResolver(theme), size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedFactor.id,
                        dropdownColor: theme.cardDark,
                        icon: Icon(Icons.keyboard_arrow_down, color: theme.grey, size: 20),
                        isExpanded: true,
                        onChanged: (String? newValue) {
                          if (newValue != null) provider.selectFactor(newValue);
                        },
                        selectedItemBuilder: (BuildContext context) {
                          return provider.factors.map((factor) {
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                factor.getName(context),
                                style: TextStyle(
                                  color: theme.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }).toList();
                        },
                        items: provider.factors.map((factor) {
                          return DropdownMenuItem<String>(
                            value: factor.id,
                            child: Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: factor.colorResolver(theme),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  factor.getName(context),
                                  style: TextStyle(
                                    color: theme.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Evolución label
            Text(evolutionLabel,
                style: TextStyle(color: theme.greyLight, fontSize: 12, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),

            // Mini line chart
            SizedBox(
              height: 100,
              child: CustomPaint(
                size: const Size(double.infinity, 100),
                painter: _LineChartPainter(
                  scores: factorScores,
                  labels: factorLabels,
                  lineColor: factorLineColor,
                  gridColor: theme.border,
                  textColor: theme.grey,
                  highlightColor: factorLineColor,
                  maxRefColor: factorLineColor.withValues(alpha: 0.4),
                  minRefColor: theme.grey.withValues(alpha: 0.4),
                  minY: chartMinY,
                  maxY: chartMaxY,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Leyenda
            Row(children: [
              _LegendDot(color: factorLineColor, dashed: true, label: maxLabel),
              const SizedBox(width: 14),
              _LegendDot(color: theme.grey, dashed: true, label: minLabel),
              const SizedBox(width: 14),
              _LegendDot(color: factorLineColor, dashed: false, label: actualLabel),
            ]),
          ]);
        },
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final bool dashed;
  final String label;
  const _LegendDot({required this.color, required this.dashed, required this.label});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>() ?? AppThemeExtension.dark;
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 10, height: 10, decoration: BoxDecoration(
        color: dashed ? Colors.transparent : color,
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
      )),
      const SizedBox(width: 4),
      Text(label, style: TextStyle(color: theme.grey, fontSize: 9)),
    ]);
  }
}

// ─────────────────────────────────────────────
// WEIGHT DETAIL CARD
// ─────────────────────────────────────────────
class _WeightDetailCard extends StatelessWidget {
  final ProgressReport report;
  const _WeightDetailCard({required this.report});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>() ?? AppThemeExtension.dark;
    final isEs  = Localizations.localeOf(context).languageCode == 'es';

    final title       = isEs ? 'Detalle de peso'         : 'Weight detail';
    final objective   = isEs ? 'Objetivo: bajar peso'    : 'Goal: lose weight';
    final currentW    = isEs ? 'Peso actual'             : 'Current weight';
    final vsPrevWeek  = isEs ? 'vs semana anterior'      : 'vs prev. week';
    final vs4Weeks    = isEs ? 'vs hace 4 semanas'       : 'vs 4 weeks ago';
    final trendLabel  = isEs ? 'Tendencia de peso'       : 'Weight trend';
    final muscleLabel = isEs ? 'Músculo estimado'        : 'Est. muscle';
    final fatLabel    = isEs ? 'Grasa estimada'          : 'Est. fat';
    final compNote    = isEs ? 'Composición estimada por actividad ⓘ' : 'Activity-estimated composition ⓘ';

    final List<double> weightData = report.historialPeso.isNotEmpty
        ? report.historialPeso.map((e) => (e.peso ?? 0.0).toDouble()).toList()
        : [0.0];
    final List<String> weekLabels = report.historialPeso.isNotEmpty
        ? report.historialPeso.map((e) => e.semana != null ? 'S${e.semana!.toInt()}' : 'S1').toList()
        : ['S1'];

    final double currentWeight = report.historialPeso.isNotEmpty ? (report.historialPeso.last.peso ?? 0.0).toDouble() : 0.0;
    final double prevWeight = report.historialPeso.length >= 2 ? (report.historialPeso[report.historialPeso.length - 2].peso ?? currentWeight).toDouble() : currentWeight;
    final double weight4WeeksAgo = report.historialPeso.length >= 5 ? (report.historialPeso[report.historialPeso.length - 5].peso ?? currentWeight).toDouble() : (report.historialPeso.isNotEmpty ? (report.historialPeso.first.peso ?? currentWeight).toDouble() : currentWeight);

    final double deltaPrev = currentWeight - prevWeight;
    final double delta4Weeks = currentWeight - weight4WeeksAgo;

    final String deltaPrevStr = deltaPrev >= 0 ? '↑ ${deltaPrev.abs().toStringAsFixed(1)} kg' : '↓ ${deltaPrev.abs().toStringAsFixed(1)} kg';
    final String delta4WeeksStr = delta4Weeks >= 0 ? '↑ ${delta4Weeks.abs().toStringAsFixed(1)} kg' : '↓ ${delta4Weeks.abs().toStringAsFixed(1)} kg';

    final double muscleActual = (report.musculos?.actual ?? 0.0).toDouble();
    final double muscleAnterior = (report.musculos?.anterior ?? muscleActual).toDouble();
    final double muscleDelta = muscleActual - muscleAnterior;
    final String muscleDeltaStr = muscleDelta >= 0 ? '↑ ${muscleDelta.abs().toStringAsFixed(1)}%' : '↓ ${muscleDelta.abs().toStringAsFixed(1)}%';

    final double fatActual = (report.grasa?.actual ?? 0.0).toDouble();
    final double fatAnterior = (report.grasa?.anterior ?? fatActual).toDouble();
    final double fatDelta = fatActual - fatAnterior;
    final String fatDeltaStr = fatDelta >= 0 ? '↑ ${fatDelta.abs().toStringAsFixed(1)}%' : '↓ ${fatDelta.abs().toStringAsFixed(1)}%';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Header
        Row(children: [
          Expanded(child: Text(title,
              style: TextStyle(color: theme.white, fontSize: 16, fontWeight: FontWeight.w700))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: theme.greenBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(objective,
                style: TextStyle(color: theme.greenText, fontSize: 11, fontWeight: FontWeight.w600)),
          ),
        ]),
        const SizedBox(height: 14),

        // Peso actual row
        Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${currentWeight.toStringAsFixed(1)} kg',
                style: TextStyle(color: theme.white, fontSize: 28, fontWeight: FontWeight.w800)),
            Text(currentW, style: TextStyle(color: theme.grey, fontSize: 12)),
          ]),
          const SizedBox(width: 20),
          Expanded(child: Row(children: [
            Expanded(child: _WeightDelta(label: vsPrevWeek, value: '${prevWeight.toStringAsFixed(1)} kg', delta: deltaPrevStr, positive: deltaPrev <= 0, theme: theme)),
            const SizedBox(width: 12),
            Expanded(child: _WeightDelta(label: vs4Weeks,  value: '${weight4WeeksAgo.toStringAsFixed(1)} kg', delta: delta4WeeksStr, positive: delta4Weeks <= 0, theme: theme)),
          ])),
        ]),
        const SizedBox(height: 16),

        // Trend label
        Text(trendLabel,
            style: TextStyle(color: theme.greyLight, fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),

        // Line chart peso
        SizedBox(
          height: 90,
          child: CustomPaint(
            size: const Size(double.infinity, 90),
            painter: _WeightChartPainter(
              data: weightData,
              labels: weekLabels,
              lineColor: theme.greenText,
              dotColor: theme.greenText,
              gridColor: theme.border,
              textColor: theme.grey,
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Músculo / Grasa
        Row(children: [
          Expanded(child: _CompositionBox(
            label: muscleLabel, value: '${muscleActual.toStringAsFixed(1)} %',
            delta: muscleDeltaStr, deltaColor: muscleDelta >= 0 ? theme.greenText : theme.redText,
            sub: isEs ? 'vs semana anterior' : 'vs prev. week', theme: theme,
          )),
          const SizedBox(width: 10),
          Expanded(child: _CompositionBox(
            label: fatLabel, value: '${fatActual.toStringAsFixed(1)} %',
            delta: fatDeltaStr, deltaColor: fatDelta <= 0 ? theme.greenText : theme.redText,
            sub: isEs ? 'vs semana anterior' : 'vs prev. week', theme: theme,
          )),
        ]),
        const SizedBox(height: 10),
        Row(children: [
          Icon(Icons.info_outline, color: theme.grey, size: 13),
          const SizedBox(width: 4),
          Text(compNote, style: TextStyle(color: theme.grey, fontSize: 11)),
        ]),
      ]),
    );
  }
}

class _WeightDelta extends StatelessWidget {
  final String label, value, delta;
  final bool positive;
  final AppThemeExtension theme;
  const _WeightDelta({required this.label, required this.value,
    required this.delta, required this.positive, required this.theme});
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(label, style: TextStyle(color: theme.grey, fontSize: 10)),
    Text(value,  style: TextStyle(color: theme.greyLight, fontSize: 14, fontWeight: FontWeight.w600)),
    Text(delta,  style: TextStyle(
        color: positive ? theme.greenText : theme.redText, fontSize: 12, fontWeight: FontWeight.w600)),
  ]);
}

class _CompositionBox extends StatelessWidget {
  final String label, value, delta, sub;
  final Color deltaColor;
  final AppThemeExtension theme;
  const _CompositionBox({required this.label, required this.value, required this.delta,
    required this.deltaColor, required this.sub, required this.theme});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: theme.cardDark, borderRadius: BorderRadius.circular(10)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: TextStyle(color: theme.grey, fontSize: 11)),
      const SizedBox(height: 4),
      Text(value, style: TextStyle(color: theme.white, fontSize: 20, fontWeight: FontWeight.w800)),
      const SizedBox(height: 2),
      Text(delta, style: TextStyle(color: deltaColor, fontSize: 12, fontWeight: FontWeight.w600)),
      Text(sub,   style: TextStyle(color: theme.grey, fontSize: 10)),
    ]),
  );
}

// ─────────────────────────────────────────────
// SECONDARY METRICS  (Edad corporal + Déficit hídrico)
// ─────────────────────────────────────────────
class _SecondaryMetricsSection extends StatelessWidget {
  final ProgressReport report;
  const _SecondaryMetricsSection({required this.report});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>() ?? AppThemeExtension.dark;
    final isEs  = Localizations.localeOf(context).languageCode == 'es';

    final sectionTitle = isEs ? 'Métricas secundarias'      : 'Secondary metrics';
    final bodyAgeTitle = isEs ? 'Edad corporal'             : 'Body age';
    
    final int bodyAgeValue = (report.detalleFactorEdadCorporal?.puntaje ?? 0).toInt();
    final double ageVar = (report.detalleFactorEdadCorporal?.variacion ?? 0.0).toDouble();
    final bodyAgeDelta = ageVar >= 0 ? '↑ ${ageVar.toStringAsFixed(1)} años' : '↓ ${ageVar.abs().toStringAsFixed(1)} años';
    
    final bodyAgeUnit  = isEs ? 'años'                      : 'years';
    final bodyAgeSub   = isEs ? 'Edad según tus mediciones' : 'Age based on metrics';
    final bodyAgeBadge = isEs ? 'Estable'                   : 'Stable';
    final bodyAgePrev  = isEs ? 'vs semana anterior'        : 'vs prev. week';

    final hydroTitle   = isEs ? 'Déficit hídrico semanal'   : 'Weekly hydration deficit';
    final double hydroActual = (report.metricasSecundarias?.actual?.deficitHidrico ?? 0.0).toDouble();
    final double hydroAnterior = (report.metricasSecundarias?.anterior?.deficitHidrico ?? hydroActual).toDouble();
    final double hydroVar = hydroActual - hydroAnterior;
    final String hydroDelta = hydroVar >= 0 ? '↑ ${hydroVar.abs().toStringAsFixed(1)} L' : '↓ ${hydroVar.abs().toStringAsFixed(1)} L';
    
    final hydroValue   = hydroActual.toStringAsFixed(1);
    const hydroUnit    = 'L';
    final hydroSub     = isEs ? 'Déficit acumulado esta semana' : 'Accumulated deficit this week';
    final hydroBadge   = hydroActual > 1.5 ? (isEs ? 'Moderado' : 'Moderate') : (isEs ? 'Excelente' : 'Excellent');
    final hydroPrev    = isEs ? 'vs semana anterior'        : 'vs prev. week';

    final double vo2Actual = (report.metricasSecundarias?.actual?.vo2Max ?? 0.0).toDouble();
    final double vo2Anterior = (report.metricasSecundarias?.anterior?.vo2Max ?? vo2Actual).toDouble();
    final double vo2Var = vo2Actual - vo2Anterior;
    final String vo2Delta = vo2Var >= 0 ? '↑ ${vo2Var.abs().toStringAsFixed(1)}' : '↓ ${vo2Var.abs().toStringAsFixed(1)}';

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(sectionTitle,
          style: TextStyle(color: theme.white, fontSize: 16, fontWeight: FontWeight.w700)),
      const SizedBox(height: 12),
      IntrinsicHeight(
        child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Expanded(child: _SecondaryMetricCard(
            icon: Icons.person_outline,
            iconColor: theme.grey,
            title: bodyAgeTitle,
            value: bodyAgeValue.toString(),
            unit: bodyAgeUnit,
            sub: bodyAgeSub,
            badgeText: bodyAgeBadge,
            badgeColor: theme.greenText,
            badgeBg: theme.greenBg,
            delta: bodyAgeDelta,
            deltaColor: ageVar <= 0 ? theme.greenText : theme.redText,
            prevLabel: bodyAgePrev,
            theme: theme,
          )),
          const SizedBox(width: 10),
          Expanded(child: _SecondaryMetricCard(
            icon: Icons.water_drop_outlined,
            iconColor: const Color(0xFF4A90D9),
            title: hydroTitle,
            value: hydroValue,
            unit: hydroUnit,
            sub: hydroSub,
            badgeText: hydroBadge,
            badgeColor: hydroActual > 1.5 ? const Color(0xFFEF9F27) : theme.greenText,
            badgeBg: hydroActual > 1.5 ? const Color(0xFF2A1E08) : theme.greenBg,
            delta: hydroDelta,
            deltaColor: hydroVar <= 0 ? theme.greenText : theme.redText,
            prevLabel: hydroPrev,
            theme: theme,
          )),
        ]),
      ),
      const SizedBox(height: 10),
      _SecondaryMetricCard(
        icon: Icons.favorite_outline,
        iconColor: theme.redMid,
        title: isEs ? 'VO2 Max estimado' : 'Estimated VO2 Max',
        value: vo2Actual.toStringAsFixed(1),
        unit: 'ml/kg/min',
        sub: isEs ? 'Capacidad aeróbica en rango excelente' : 'Aerobic capacity in excellent range',
        badgeText: isEs ? 'Excelente' : 'Excellent',
        badgeColor: theme.greenText,
        badgeBg: theme.greenBg,
        delta: vo2Delta,
        deltaColor: vo2Var >= 0 ? theme.greenText : theme.redText,
        prevLabel: isEs ? 'vs semana anterior' : 'vs prev. week',
        theme: theme,
        isFullWidth: true,
      ),
    ]);
  }
}

class _SecondaryMetricCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor, badgeColor, badgeBg, deltaColor;
  final String title, value, unit, sub, badgeText, delta, prevLabel;
  final AppThemeExtension theme;
  final bool isFullWidth;
  const _SecondaryMetricCard({
    required this.icon, required this.iconColor, required this.title,
    required this.value, required this.unit, required this.sub,
    required this.badgeText, required this.badgeColor, required this.badgeBg,
    required this.delta, required this.deltaColor, required this.prevLabel,
    required this.theme,
    this.isFullWidth = false,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.border),
      ),
      child: isFullWidth
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(icon, color: iconColor, size: 18),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              title,
                              style: TextStyle(
                                color: theme.greyLight,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: value,
                              style: TextStyle(
                                color: theme.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            TextSpan(
                              text: ' $unit',
                              style: TextStyle(color: theme.grey, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        sub,
                        style: TextStyle(color: theme.grey, fontSize: 11, height: 1.3),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: badgeBg, borderRadius: BorderRadius.circular(20)),
                      child: Text(badgeText, style: TextStyle(color: badgeColor, fontSize: 11, fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(height: 6),
                    Text(prevLabel, style: TextStyle(color: theme.grey, fontSize: 10)),
                    Text(delta,     style: TextStyle(color: deltaColor, fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Icon(icon, color: iconColor, size: 18),
                  const SizedBox(width: 6),
                  Expanded(child: Text(title,
                      style: TextStyle(color: theme.greyLight, fontSize: 12, fontWeight: FontWeight.w600))),
                ]),
                const SizedBox(height: 8),
                RichText(text: TextSpan(children: [
                  TextSpan(text: value, style: TextStyle(color: theme.white, fontSize: 26, fontWeight: FontWeight.w800)),
                  TextSpan(text: ' $unit', style: TextStyle(color: theme.grey, fontSize: 14)),
                ])),
                const SizedBox(height: 4),
                Text(sub, style: TextStyle(color: theme.grey, fontSize: 11, height: 1.3)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: badgeBg, borderRadius: BorderRadius.circular(20)),
                  child: Text(badgeText, style: TextStyle(color: badgeColor, fontSize: 11, fontWeight: FontWeight.w600)),
                ),
                const SizedBox(height: 6),
                Text(prevLabel, style: TextStyle(color: theme.grey, fontSize: 10)),
                Text(delta,     style: TextStyle(color: deltaColor, fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ),
    );
  }
}

// ─────────────────────────────────────────────
// TAMBIÉN ESTA SEMANA (4 cards en grid 2x2)
// ─────────────────────────────────────────────
class _AlsoThisWeekSection extends StatelessWidget {
  final ProgressReport report;
  const _AlsoThisWeekSection({required this.report});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>() ?? AppThemeExtension.dark;
    final isEs  = Localizations.localeOf(context).languageCode == 'es';

    final sectionTitle = isEs ? 'También esta semana' : 'Also this week';

    final caloriesBurned = (report.calorias?.caloriasAct ?? 0.0).toDouble();
    final caloriesDiff = (report.calorias?.diferencia ?? 0.0).toDouble();
    
    final activeMinutes = (report.tiempoActivo?.totalMinutos ?? 0).toInt();
    final compSessions = (report.tiempoActivo?.sesionesCompletadas ?? 0).toInt();
    final totalSessions = (report.tiempoActivo?.sesionesTotales ?? 0).toInt();
    final diffSessions = (report.tiempoActivo?.diferenciaSesiones ?? 0).toInt();

    final cards = [
      _WeekCardData(
        icon: '🔥',
        title: isEs ? 'Acumulación de grasa' : 'Fat accumulation',
        value: isEs ? 'Normal' : 'Normal',
        valueColor: theme.greenText,
        sub: isEs ? 'Dentro del rango saludable' : 'Within healthy range',
      ),
      _WeekCardData(
        icon: '💪',
        title: isEs ? 'Tus músculos' : 'Your muscles',
        value: isEs ? 'Descansados' : 'Rested',
        valueColor: theme.greenText,
        sub: isEs ? 'Buena recuperación. Sigue así.' : 'Good recovery. Keep it up.',
      ),
      _WeekCardData(
        icon: '🔥',
        title: isEs ? 'Calorías quemadas\n(entrenamiento)' : 'Calories burned\n(training)',
        value: '${caloriesBurned.toInt().toString()} kcal',
        valueColor: theme.white,
        sub: isEs 
            ? '↑ ${caloriesDiff.toInt().toString()} kcal\nvs semana anterior' 
            : '↑ ${caloriesDiff.toInt().toString()} kcal\nvs prev. week',
        subColor: theme.greenText,
      ),
      _WeekCardData(
        icon: '🕐',
        title: isEs ? 'Tiempo activo' : 'Active time',
        value: '${(activeMinutes / 60).floor()}h ${activeMinutes % 60}m',
        valueColor: theme.white,
        sub: isEs 
            ? '$compSessions/$totalSessions sesiones\n↑ $diffSessions sesión vs sem. ant.' 
            : '$compSessions/$totalSessions sessions\n↑ $diffSessions session vs prev.',
        subColor: theme.greyLight,
        subHighlight: isEs ? '↑ 1 sesión' : '↑ 1 session',
        subHighlightColor: theme.greenText,
      ),
    ];

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(sectionTitle,
          style: TextStyle(color: theme.white, fontSize: 16, fontWeight: FontWeight.w700)),
      const SizedBox(height: 12),
      Column(children: [
        IntrinsicHeight(
          child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Expanded(child: _WeekSmallCard(data: cards[0], theme: theme)),
            const SizedBox(width: 10),
            Expanded(child: _WeekSmallCard(data: cards[1], theme: theme)),
          ]),
        ),
        const SizedBox(height: 10),
        IntrinsicHeight(
          child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Expanded(child: _WeekSmallCard(data: cards[2], theme: theme)),
            const SizedBox(width: 10),
            Expanded(child: _WeekSmallCard(data: cards[3], theme: theme)),
          ]),
        ),
      ]),
    ]);
  }
}

class _WeekCardData {
  final String icon, title, value, sub;
  final Color valueColor;
  final Color? subColor, subHighlightColor;
  final String? subHighlight;
  const _WeekCardData({
    required this.icon, required this.title, required this.value,
    required this.valueColor, required this.sub,
    this.subColor, this.subHighlight, this.subHighlightColor,
  });
}

class _WeekSmallCard extends StatelessWidget {
  final _WeekCardData data;
  final AppThemeExtension theme;
  const _WeekSmallCard({required this.data, required this.theme});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: theme.card,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: theme.border),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(data.icon, style: const TextStyle(fontSize: 18)),
      const SizedBox(height: 4),
      Text(data.title,
          style: TextStyle(color: theme.grey, fontSize: 11, height: 1.3),
          maxLines: 2, overflow: TextOverflow.ellipsis),
      const SizedBox(height: 4),
      Text(data.value,
          style: TextStyle(color: data.valueColor, fontSize: 16, fontWeight: FontWeight.w800)),
      const SizedBox(height: 2),
      Text(data.sub,
          style: TextStyle(color: data.subColor ?? theme.grey, fontSize: 10, height: 1.3),
          maxLines: 2),
    ]),
  );
}

// ─────────────────────────────────────────────
// SEND REPORT CARD
// ─────────────────────────────────────────────
class _SendReportCard extends StatelessWidget {
  final ProgressReport report;
  const _SendReportCard({required this.report});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>() ?? AppThemeExtension.dark;
    final isEs  = Localizations.localeOf(context).languageCode == 'es';

    final title  = isEs ? 'Generar informe\nsemanal'              : 'Generate weekly\nreport';
    final sub    = isEs
        ? 'Generamos un informe en PDF con tus métricas, entrenamientos y evolución para que lo descargues.'
        : 'We generate a PDF report with your metrics, workouts, and progress for you to download.';
    final btnTxt = isEs ? 'Generar y descargar PDF'              : 'Generate and download PDF';
    final last   = isEs ? 'Último informe generado: ${report.actualizado ?? ''}'
                        : 'Last report generated: ${report.actualizado ?? ''}';

    return Container(
      decoration: BoxDecoration(
        color: theme.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.description_outlined, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(
                  color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800, height: 1.2)),
              const SizedBox(height: 6),
              Text(sub, style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85), fontSize: 12, height: 1.4)),
            ])),
          ]),
        ),

        // Botón
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: SizedBox(
            width: double.infinity,
            child: Consumer<ProgressReportProvider>(
              builder: (context, provider, child) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: theme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  onPressed: provider.isGeneratingReport
                      ? null
                      : () async {
                          final token = context.read<AuthProvider>().token;
                          if (token == null) return;

                          final reportId = provider.recentReportId;
                          if (reportId == null || reportId.trim().isEmpty) {
                            if (context.mounted) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: theme.card,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      side: BorderSide(color: theme.border),
                                    ),
                                    title: Row(
                                      children: [
                                        Icon(Icons.info_outline, color: theme.primary, size: 24),
                                        const SizedBox(width: 8),
                                        Text(
                                          isEs ? 'Reporte no disponible' : 'Report not available',
                                          style: TextStyle(
                                            color: theme.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    content: Text(
                                      isEs
                                          ? 'No se ha generado el reporte de esta semana. Ten en cuenta que los informes se generan automáticamente todos los lunes a las 12:00 PM.'
                                          : 'This week\'s report has not been generated yet. Please note that reports are automatically generated every Monday at 12:00 PM.',
                                      style: TextStyle(
                                        color: theme.greyLight,
                                        fontSize: 14,
                                        height: 1.4,
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(),
                                        child: Text(
                                          isEs ? 'Entendido' : 'OK',
                                          style: TextStyle(
                                            color: theme.primary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                            return;
                          }

                          final url = await provider.generarReportePDF(token: token);

                          if (url == null && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(provider.errorMessage ?? (isEs ? 'Error al generar el informe' : 'Error generating report')),
                                backgroundColor: theme.redMid,
                              ),
                            );
                          }
                        },
                  child: provider.isGeneratingReport
                      ? const SizedBox(
                          width: 24, height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(btnTxt, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                );
              },
            ),
          ),
        ),

        // Footer
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.15),
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
          ),
          child: Text(last,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 11)),
        ),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// CUSTOM PAINTERS
// ═══════════════════════════════════════════════════════════════

class _RingPainter extends CustomPainter {
  final double value;
  final Color trackColor, fillColor;
  const _RingPainter({required this.value, required this.trackColor, required this.fillColor});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r  = math.min(cx, cy) - 8;
    const stroke = 8.0;

    final trackPaint = Paint()
      ..color = trackColor
      ..strokeWidth = stroke
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = fillColor
      ..strokeWidth = stroke
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(Offset(cx, cy), r, trackPaint);

    final rect = Rect.fromCircle(center: Offset(cx, cy), radius: r);
    canvas.drawArc(rect, -math.pi / 2, 2 * math.pi * value, false, fillPaint);
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.value != value;
}

class _LineChartPainter extends CustomPainter {
  final List<double> scores;
  final List<String> labels;
  final Color lineColor, gridColor, textColor, highlightColor, maxRefColor, minRefColor;
  final double minY, maxY;

  const _LineChartPainter({
    required this.scores, required this.labels,
    required this.lineColor, required this.gridColor, required this.textColor,
    required this.highlightColor, required this.maxRefColor, required this.minRefColor,
    required this.minY, required this.maxY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (scores.isEmpty) return;
    const double paddingTop    = 8;
    const double paddingBottom = 20;
    const double paddingLeft   = 24;
    const double paddingRight  = 8;
    final double chartH = size.height - paddingTop - paddingBottom;
    final double chartW = size.width  - paddingLeft - paddingRight;

    final double minV = minY, maxV = maxY;

    double xOf(int i) => scores.length > 1
        ? paddingLeft + (i / (scores.length - 1)) * chartW
        : paddingLeft + chartW / 2;
    double yOf(double v) {
      if (maxV == minV) return paddingTop + chartH / 2;
      return paddingTop + chartH - ((v - minV) / (maxV - minV)) * chartH;
    }

    final gridPaint = Paint()..color = gridColor..strokeWidth = 0.5;
    final labelStyle = TextStyle(color: textColor, fontSize: 9);
    final double gridInterval = maxV != minV ? (maxV - minV) / 3.0 : 10.0;

    for (int i = 0; i <= 3; i++) {
      final double currentGridValue = minY + i * gridInterval;
      final y = yOf(currentGridValue);
      if (y < paddingTop || y > size.height - paddingBottom) continue;
      canvas.drawLine(Offset(paddingLeft, y), Offset(size.width - paddingRight, y), gridPaint);
      final tp = TextPainter(
        text: TextSpan(text: currentGridValue.round().toString(), style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(0, y - 5));
    }

    final actualMaxScore = scores.reduce(math.max);
    final actualMinScore = scores.reduce(math.min);

    _drawDashed(canvas, Offset(paddingLeft, yOf(actualMaxScore)), Offset(size.width - paddingRight, yOf(actualMaxScore)), maxRefColor);
    _drawDashed(canvas, Offset(paddingLeft, yOf(actualMinScore)), Offset(size.width - paddingRight, yOf(actualMinScore)), minRefColor);

    final linePaint = Paint()
      ..color = lineColor..strokeWidth = 2..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    final path = Path();
    for (int i = 0; i < scores.length; i++) {
      final p = Offset(xOf(i), yOf(scores[i]));
      if (i == 0) path.moveTo(p.dx, p.dy); else path.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(path, linePaint);

    for (int i = 0; i < scores.length; i++) {
      final isLast = i == scores.length - 1;
      final dotColor = isLast ? highlightColor : lineColor;
      final x = xOf(i); final y = yOf(scores[i]);

      canvas.drawCircle(Offset(x, y), 4, Paint()..color = dotColor);

      if (isLast || scores[i] == actualMaxScore) {
        final tp = TextPainter(
          text: TextSpan(text: scores[i].toInt().toString(),
              style: TextStyle(color: dotColor, fontSize: 9, fontWeight: FontWeight.w700)),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(canvas, Offset(x - tp.width / 2, y - 14));
      }

      if (i < labels.length) {
        final lp = TextPainter(
          text: TextSpan(text: labels[i], style: labelStyle),
          textDirection: TextDirection.ltr,
        )..layout();
        lp.paint(canvas, Offset(x - lp.width / 2, size.height - paddingBottom + 4));
      }
    }
  }

  void _drawDashed(Canvas canvas, Offset start, Offset end, Color color) {
    final paint = Paint()..color = color..strokeWidth = 1;
    const dashW = 6.0, gapW = 4.0;
    final dx = end.dx - start.dx;
    final total = dx;
    double drawn = 0;
    while (drawn < total) {
      final from = Offset(start.dx + drawn, start.dy);
      final to   = Offset(start.dx + math.min(drawn + dashW, total), start.dy);
      canvas.drawLine(from, to, paint);
      drawn += dashW + gapW;
    }
  }

  @override
  bool shouldRepaint(_LineChartPainter old) {
    return old.lineColor != lineColor ||
        old.minY != minY || old.maxY != maxY ||
        !_listEquals(old.scores, scores) || !_listEquals(old.labels, labels);
  }

  bool _listEquals(List a, List b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

class _WeightChartPainter extends CustomPainter {
  final List<double> data;
  final List<String> labels;
  final Color lineColor, dotColor, gridColor, textColor;

  const _WeightChartPainter({
    required this.data, required this.labels,
    required this.lineColor, required this.dotColor,
    required this.gridColor, required this.textColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;
    const double pTop = 8, pBottom = 18, pLeft = 28, pRight = 8;
    final double chartH = size.height - pTop - pBottom;
    final double chartW = size.width  - pLeft - pRight;

    final minD = data.reduce(math.min) - 1;
    final maxD = data.reduce(math.max) + 1;

    double xOf(int i) => data.length > 1
        ? pLeft + (i / (data.length - 1)) * chartW
        : pLeft + chartW / 2;
    double yOf(double v) {
      if (maxD == minD) return pTop + chartH / 2;
      return pTop + chartH - ((v - minD) / (maxD - minD)) * chartH;
    }

    final gridPaint = Paint()..color = gridColor..strokeWidth = 0.5;
    final labelStyle = TextStyle(color: textColor, fontSize: 9);

    final double gridInterval = maxD != minD ? (maxD - minD) / 3.0 : 5.0;
    for (int i = 0; i <= 3; i++) {
      final double currentGridValue = minD + i * gridInterval;
      final y = yOf(currentGridValue);
      canvas.drawLine(Offset(pLeft, y), Offset(size.width - pRight, y), gridPaint);
      final tp = TextPainter(
          text: TextSpan(text: currentGridValue.round().toString(), style: labelStyle),
          textDirection: TextDirection.ltr)..layout();
      tp.paint(canvas, Offset(0, y - 5));
    }

    final path = Path();
    for (int i = 0; i < data.length; i++) {
      final p = Offset(xOf(i), yOf(data[i]));
      if (i == 0) path.moveTo(p.dx, p.dy); else path.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(path, Paint()
      ..color = lineColor..strokeWidth = 2..style = PaintingStyle.stroke..strokeCap = StrokeCap.round);

    for (int i = 0; i < data.length; i++) {
      canvas.drawCircle(Offset(xOf(i), yOf(data[i])), 4, Paint()..color = dotColor);
      if (i < labels.length) {
        final lp = TextPainter(
            text: TextSpan(text: labels[i], style: labelStyle),
            textDirection: TextDirection.ltr)..layout();
        lp.paint(canvas, Offset(xOf(i) - lp.width / 2, size.height - pBottom + 4));
      }
    }
  }

  @override
  bool shouldRepaint(_WeightChartPainter old) => false;
}

// ─────────────────────────────────────────────
// TRAINING ZONES CARD
// ─────────────────────────────────────────────
class _TrainingZonesCard extends StatelessWidget {
  const _TrainingZonesCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>() ?? AppThemeExtension.dark;
    final isEs  = Localizations.localeOf(context).languageCode == 'es';

    final title = isEs ? 'Zonas de entrenamiento' : 'Training Heart Rate Zones';
    final sub   = isEs 
        ? 'Zonas de esfuerzo según tu frecuencia cardíaca máxima (% FC Máx).' 
        : 'Effort zones based on your maximum heart rate (% Max HR).';

    final List<_ZoneData> zones = [
      _ZoneData(
        label: 'Z5',
        name: isEs ? 'MÁXIMO' : 'MAXIMUM',
        range: '90-100%',
        lpm: isEs ? '171-190 Lpm' : '171-190 bpm',
        duration: isEs ? '0-2 min.' : '0-2 min',
        benefit: isEs 
            ? 'Mejora la velocidad y tonifica el sistema neuromuscular.' 
            : 'Improves speed and tones the neuromuscular system.',
        color: const Color(0xFFFF3B30), // Red
      ),
      _ZoneData(
        label: 'Z4',
        name: isEs ? 'INTENSO' : 'HARD',
        range: '80-90%',
        lpm: isEs ? '152-172 Lpm' : '152-172 bpm',
        duration: isEs ? '2-10 min.' : '2-10 min',
        benefit: isEs 
            ? 'Incrementa la resistencia anaeróbica en sesiones cortas.' 
            : 'Increases anaerobic endurance in short sessions.',
        color: const Color(0xFFFF9500), // Orange
      ),
      _ZoneData(
        label: 'Z3',
        name: isEs ? 'MODERADO' : 'MODERATE',
        range: '70-80%',
        lpm: isEs ? '133-152 Lpm' : '133-152 bpm',
        duration: isEs ? '10-40 min.' : '10-40 min',
        benefit: isEs 
            ? 'Mejora la resistencia aeróbica y capacidad cardiovascular.' 
            : 'Improves aerobic endurance and cardiovascular capacity.',
        color: const Color(0xFF34C759), // Green
      ),
      _ZoneData(
        label: 'Z2',
        name: isEs ? 'SUAVE' : 'LIGHT',
        range: '60-70%',
        lpm: isEs ? '114-133 Lpm' : '114-133 bpm',
        duration: isEs ? '40-80 min.' : '40-80 min',
        benefit: isEs 
            ? 'Mejora la resistencia básica y estimula la quema de grasas.' 
            : 'Improves basic endurance and stimulates fat burning.',
        color: const Color(0xFF007AFF), // Blue
      ),
      _ZoneData(
        label: 'Z1',
        name: isEs ? 'MUY SUAVE' : 'VERY LIGHT',
        range: '50-60%',
        lpm: isEs ? '104-114 Lpm' : '104-114 bpm',
        duration: isEs ? '20-40 min.' : '20-40 min',
        benefit: isEs 
            ? 'Ayuda a la recuperación post-esfuerzo y calentamiento.' 
            : 'Aids post-exercise recovery and warm-up.',
        color: const Color(0xFF8E8E93), // Grey
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Header
        Row(children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(
              color: theme.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.favorite_border, color: theme.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: theme.white, fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(sub, style: TextStyle(color: theme.grey, fontSize: 11, height: 1.3)),
            ],
          )),
        ]),
        const SizedBox(height: 18),

        // Zones List
        ...zones.map((z) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.cardDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.border.withValues(alpha: 0.5)),
            ),
            child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              // Colored Label Pill
              Container(
                width: 76,
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                decoration: BoxDecoration(
                  color: z.color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Text(z.label, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w900)),
                  Text(z.range, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold, height: 1)),
                ]),
              ),
              const SizedBox(width: 12),
              // Name, Lpm, Duration and Benefit
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(z.name, style: TextStyle(color: z.color, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                  const SizedBox(height: 4),
                  Row(children: [
                    Icon(Icons.favorite, color: z.color, size: 11),
                    const SizedBox(width: 4),
                    Text(z.lpm, style: TextStyle(color: theme.white, fontSize: 10, fontWeight: FontWeight.w700)),
                    const SizedBox(width: 16),
                    Icon(Icons.timer_outlined, color: theme.grey, size: 11),
                    const SizedBox(width: 4),
                    Text(z.duration, style: TextStyle(color: theme.greyLight, fontSize: 10, fontWeight: FontWeight.w600)),
                  ]),
                  const SizedBox(height: 6),
                  Text(z.benefit, style: TextStyle(color: theme.greyLight, fontSize: 11, height: 1.3)),
                ],
              )),
            ]),
          ),
        )),
      ]),
    );
  }
}

class _ZoneData {
  final String label, name, range, lpm, duration, benefit;
  final Color color;
  const _ZoneData({required this.label, required this.name, required this.range, required this.lpm, required this.duration, required this.benefit, required this.color});
}
