// ─── Progress data centralizado ────────────────────────────────
import 'package:flutter/material.dart';
import '../config/app_colors.dart';

// ─── Summary ────────────────────────────────────────────────────
class SummaryStats {
  final String sessions, hours, fatChange;
  const SummaryStats({
    required this.sessions,
    required this.hours,
    required this.fatChange,
  });
}

const summaryStats = SummaryStats(
  sessions:  '47',
  hours:     '156h',
  fatChange: '-2.8%',
);

// ─── Biological age ─────────────────────────────────────────────
class BioAge {
  final int currentAge;
  final int realAge;
  final String note;
  const BioAge({
    required this.currentAge,
    required this.realAge,
    required this.note,
  });
}

const bioAge = BioAge(
  currentAge: 34,
  realAge:    36,
  note:       '6.2 años desde que empezaste',
);

// ─── Body indicators ────────────────────────────────────────────
class BodyIndicator {
  final String icon, title, change, desc, before, target;
  final double currentValue, progress;
  final Color barColor;
  const BodyIndicator({
    required this.icon,
    required this.title,
    required this.change,
    required this.desc,
    required this.currentValue,
    required this.before,
    required this.target,
    required this.barColor,
    required this.progress,
  });
}

const bodyIndicators = [
  BodyIndicator(
    icon: '🔥', title: 'Grasa corporal',
    change: '↓ 2.8% · mejorando',
    desc: 'Más músculo = metabolismo más activo, mejor postura y más fuerza para el deporte.',
    currentValue: -2.8, before: '39.8%', target: '<20%',
    barColor: AppColors.orange, progress: 0.55,
  ),
  BodyIndicator(
    icon: '💪', title: 'Masa muscular',
    change: '↓ 2.8% · mejorando',
    desc: 'Más músculo = metabolismo más activo, mejor postura y más fuerza para el deporte.',
    currentValue: -2.8, before: '39.8%', target: '<20%',
    barColor: Color(0xFF4A90D9), progress: 0.65,
  ),
  BodyIndicator(
    icon: '💧', title: 'Agua corporal',
    change: '↓ 2.8% · mejorando',
    desc: 'Más músculo = metabolismo más activo, mejor postura y más fuerza para el deporte.',
    currentValue: -2.8, before: '39.8%', target: '<20%',
    barColor: Color(0xFF9B7FE8), progress: 0.72,
  ),
];

// ─── Cardiovascular metrics ──────────────────────────────────────
class CardioMetric {
  final String trend, value, unit, label, desc, before, after;
  final List<double> barValues;
  final Color barColor, trendColor;
  const CardioMetric({
    required this.trend, required this.trendColor,
    required this.value, required this.unit,
    required this.label, required this.desc,
    required this.before, required this.after,
    required this.barValues, required this.barColor,
  });
}

const cardioMetrics = [
  CardioMetric(
    trend: '↓ 6 lpm', trendColor: AppColors.greenText,
    value: '62', unit: 'lpm', label: 'FC en reposo',
    desc: 'Tu FC baja, más eficiente es tu corazón. La señal más clara de mejora cardiovascular.',
    before: 'antes: 68', after: 'meta: <60 lpm',
    barValues: [0.6, 0.65, 0.7, 0.72, 0.75, 0.78, 0.82],
    barColor: AppColors.greenText,
  ),
  CardioMetric(
    trend: '↑ 2.1', trendColor: AppColors.orange,
    value: '46.6', unit: 'lpm', label: 'VO2 Máx',
    desc: 'Cuanto más sube, más oxígeno tu cuerpo al ejercitarte. Más alto = mejor resistencia.',
    before: '50/50', after: 'mejor que 80% de tu grupo',
    barValues: [0.5, 0.55, 0.6, 0.65, 0.68, 0.72, 0.75],
    barColor: AppColors.orange,
  ),
];

// ─── Plan compliance ────────────────────────────────────────────
class WeekCompliance {
  final String week, value;
  const WeekCompliance(this.week, this.value);
}

const complianceWeeks = [
  WeekCompliance('Semana 9',  '6/6 · 100%'),
  WeekCompliance('Semana 10', '6/6 · 33%'),
  WeekCompliance('Semana 11', '6/6 · 67%'),
  WeekCompliance('Semana 12', '6/6 · 0%'),
];

const complianceNote =
    'Tu cumplimiento mejora un 18% vs tus primeras 4 semanas. La constancia está dando frutos.';

// ─── Weekly load bars ────────────────────────────────────────────
const loadBarValues  = [0.5, 0.6, 0.4, 0.65, 0.7, 0.45, 0.8];
const loadBarDates   = ['02', '09', '16', '23', '30', '31', '05'];
const loadBarPlanned = [false, false, false, false, false, true, true];

// ─── RPE bars ────────────────────────────────────────────────────
const rpeBarValues = [0.7, 0.6, 0.75, 0.5, 0.65, 0.8, 0.55];
const rpeNote =
    'Tu RPE bajó de 7.5 a 5.8 para la misma carga. Tu cuerpo se está adaptando.';

// ─── IA bullets ──────────────────────────────────────────────────
class IABullet {
  final Color color;
  final String text;
  const IABullet(this.color, this.text);
}

const iaBullets = [
  IABullet(AppColors.greenText,
      'Grasa, músculo, FC reposo y VO2 Máx — todos mejorando.'),
  IABullet(AppColors.greenText,
      'Tu cumplimiento del plan es sólido y va en ascenso.'),
  IABullet(AppColors.orange,
      'Tu mayor área de mejora sigue siendo el agua corporal — hidratarte mejor esta semana puede marcar la diferencia.'),
];