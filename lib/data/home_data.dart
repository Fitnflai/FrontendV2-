// ─── Home data centralizado ────────────────────────────────────
import 'package:flutter/material.dart';
import '../config/app_colors.dart';

// ─── User profile ────────────────────────────────────────────────
class UserProfile {
  final String name, initial, dayInfo;
  const UserProfile({
    required this.name,
    required this.initial,
    required this.dayInfo,
  });
}

const currentUser = UserProfile(
  name:    'Nicolas',
  initial: 'N',
  dayInfo: 'Martes · Semana 2',
);

// ─── Daily stats ─────────────────────────────────────────────────
class DailyStat {
  final String icon, value, label;
  const DailyStat({
    required this.icon,
    required this.value,
    required this.label,
  });
}

const dailyStats = [
  DailyStat(icon: '😴', value: '7.2h',  label: 'Sueño anoche'),
  DailyStat(icon: '❤️', value: '64',    label: 'FC reposo'),
  DailyStat(icon: '🌡️', value: '16°C', label: 'Quito ahora'),
  DailyStat(icon: '💧', value: '0.4L', label: 'Hidratación'),
];

// ─── Today's session ─────────────────────────────────────────────
class TodaySession {
  final String title, description, boldWord, boldSuffix, adjustNote;
  final List<SessionTag> tags;
  const TodaySession({
    required this.title,
    required this.description,
    required this.boldWord,
    required this.boldSuffix,
    required this.adjustNote,
    required this.tags,
  });
}

class SessionTag {
  final String label;
  final Color color, bgColor;
  const SessionTag({
    required this.label,
    required this.color,
    required this.bgColor,
  });
}

const todaySession = TodaySession(
  title:       'Carrera base · Zona 2',
  description: 'Pedaleo a baja intensidad (60–70% FCmáx). Mejora tu ',
  boldWord:    'base aeróbica',
  boldSuffix:  ' — el motor del triatlón.',
  adjustNote:  'Se ajusta si tu FC supera el 72% en 2 sesiones seguidas.',
  tags: [
    SessionTag(
      label:   'Mejora: resistencia',
      color:   AppColors.orange,
      bgColor: Color(0xFF2E1A0A),
    ),
    SessionTag(
      label:   'Se mide: FC',
      color:   AppColors.grey,
      bgColor: Color(0xFF2A2A2A),
    ),
  ],
);

// ─── Weekly day data ─────────────────────────────────────────────
class WeekDay {
  final String shortDay, fullLabel;
  final Color bgColor;
  const WeekDay({
    required this.shortDay,
    required this.fullLabel,
    required this.bgColor,
  });
}

const weekDays = [
  WeekDay(shortDay: 'L',     fullLabel: 'Carrera\nZ2',    bgColor: Color(0xFF1A2E4A)),
  WeekDay(shortDay: 'M',     fullLabel: 'Fuerza\nInf.',   bgColor: Color(0xFF3D1A0A)),
  WeekDay(shortDay: 'X',     fullLabel: 'Natación\nTec.', bgColor: Color(0xFF0A1E3D)),
  WeekDay(shortDay: 'J-hoy', fullLabel: 'Bci\n70min',    bgColor: Color(0xFF1A2E4A)),
  WeekDay(shortDay: 'V',     fullLabel: 'Fuerza\nSup.',   bgColor: Color(0xFF3D1A0A)),
  WeekDay(shortDay: 'S',     fullLabel: 'Descanso',       bgColor: Color(0xFF1A1A1A)),
  WeekDay(shortDay: 'D',     fullLabel: 'Sesión\nClave',  bgColor: Color(0xFF0A2A1A)),
];

// ─── Intensity bars ──────────────────────────────────────────────
const intensityHeights = [0.4, 0.55, 0.4, 0.65, 0.55, 0.35, 0.85];
const intensityLabels  = ['Suave','Moderado','Suave','Moderado','Moderado','Suave','Intenso'];
const intensityDays    = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];

// ─── Key session note ────────────────────────────────────────────
const keySessionNote =
    'Domingo · Carrera larga 90 min. Es la sesión que más impacta tu base aeróbica. No la saltes.';

// ─── Strength progress ───────────────────────────────────────────
class ProgressBlock {
  final String title, label, nextLabel;
  final int done, total, count;
  final Color barColor;
  const ProgressBlock({
    required this.title,
    required this.label,
    required this.nextLabel,
    required this.done,
    required this.total,
    required this.count,
    required this.barColor,
  });
}

const progressBlocks = [
  ProgressBlock(
    title:     'Sesiones de fuerza',
    label:     '💪 Fuerza',
    nextLabel: '2 de 3 completadas · Viernes queda la última.',
    done: 2, total: 3, count: 2,
    barColor: AppColors.orange,
  ),
  ProgressBlock(
    title:     'Sesiones de cardio',
    label:     '📋 Cardio',
    nextLabel: '2 de 3 completadas · Viernes queda la última.',
    done: 2, total: 4, count: 3,
    barColor: Color(0xFF4A90D9),
  ),
];

// ─── Tip del día ─────────────────────────────────────────────────
const tipOfDay =
    'Hidratarte 30 min antes de salir en bici mejora tu rendimiento hasta un 8% en sesiones de más de 60 min.';

// ─── Session footer ──────────────────────────────────────────────
class SessionFooter {
  final int done, total;
  final String subtitle;
  const SessionFooter({
    required this.done,
    required this.total,
    required this.subtitle,
  });
}

const sessionFooter = SessionFooter(
  done:     3,
  total:    5,
  subtitle: '2 días restantes esta semana',
);