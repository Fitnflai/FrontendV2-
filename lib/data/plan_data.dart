// ─── Plan data centralizado ────────────────────────────────────

enum SessionStatus { completed, today, pending, rest }

class SessionModel {
  final String date;
  final String title;
  final String subtitle;
  final String? completionText;
  final List<String> tags;
  final SessionStatus status;
  final String duration;
  final bool isKey;

  const SessionModel({
    required this.date,
    required this.title,
    required this.subtitle,
    this.completionText,
    required this.tags,
    required this.status,
    required this.duration,
    this.isKey = false,
  });
}

class WeekModel {
  final int weekNumber;
  final int totalWeeks;
  final String dateRange;
  final String weekType;
  final String volume;
  final List<SessionModel> sessions;

  const WeekModel({
    required this.weekNumber,
    required this.totalWeeks,
    required this.dateRange,
    required this.weekType,
    required this.volume,
    required this.sessions,
  });

  int get completedCount =>
      sessions.where((s) => s.status == SessionStatus.completed).length;
  int get totalCount => sessions.length;
  int get completedPercent =>
      totalCount == 0 ? 0 : (completedCount / totalCount * 100).round();
}

// ─── Semana 1 — Pasada (todo completado) ────────────────────────
const week1 = WeekModel(
  weekNumber: 1,
  totalWeeks: 12,
  dateRange: 'Lunes 14 abr  –  Dom 20 abr',
  weekType: 'base',
  volume: '4h 20m',
  sessions: [
    SessionModel(
      date: 'Lunes 14 abr',
      title: 'Carrera Z2 – base aeróbica',
      subtitle: '50 min  –  Zona 2  –  60–70% FCmáx',
      completionText: '50 min completados  –  100% adherencia',
      tags: ['Carrera', 'Completada'],
      status: SessionStatus.completed,
      duration: '50 min',
    ),
    SessionModel(
      date: 'Martes 15 abr',
      title: 'Carrera Z2 – base aeróbica',
      subtitle: '50 min  –  Zona 2  –  60–70% FCmáx',
      completionText: '50 min completados  –  100% adherencia',
      tags: ['Fuerza', 'Completada'],
      status: SessionStatus.completed,
      duration: '50 min',
    ),
    SessionModel(
      date: 'Miércoles 16 abr',
      title: 'Carrera Z2 – base aeróbica',
      subtitle: '50 min  –  Zona 2  –  60–70% FCmáx',
      completionText: '50 min completados  –  100% adherencia',
      tags: ['Natación', 'Completada'],
      status: SessionStatus.completed,
      duration: '50 min',
    ),
    SessionModel(
      date: 'Jueves 17 abr',
      title: 'Descanso activo',
      subtitle: 'Caminata suave o movilidad  –  sin carga',
      tags: ['Descanso'],
      status: SessionStatus.rest,
      duration: '',
    ),
    SessionModel(
      date: 'Viernes 18 abr',
      title: 'Carrera Z2 – base aeróbica',
      subtitle: '50 min  –  Zona 2  –  60–70% FCmáx',
      completionText: '45 min completados  –  90% adherencia',
      tags: ['Fuerza', 'Completada'],
      status: SessionStatus.completed,
      duration: '50 min',
    ),
    SessionModel(
      date: 'Sábado 19 abr',
      title: 'Carrera Z2 – base aeróbica',
      subtitle: '50 min  –  Zona 2  –  60–70% FCmáx',
      completionText: '50 min completados  –  100% adherencia',
      tags: ['Carrera', 'Completada'],
      status: SessionStatus.completed,
      duration: '50 min',
    ),
    SessionModel(
      date: 'Domingo 20 abr',
      title: 'Descanso activo',
      subtitle: 'Caminata suave o movilidad  –  sin carga',
      tags: ['Descanso'],
      status: SessionStatus.rest,
      duration: '',
    ),
  ],
);

// ─── Semana 2 — Pasada (con no completada) ──────────────────────
const week2 = WeekModel(
  weekNumber: 2,
  totalWeeks: 12,
  dateRange: 'Lunes 21 abr  –  Dom 27 abr',
  weekType: 'carga',
  volume: '5h 0m',
  sessions: [
    SessionModel(
      date: 'Lunes 21 abr',
      title: 'Carrera Z2 – base aeróbica',
      subtitle: '50 min  –  Zona 2  –  60–70% FCmáx',
      completionText: '50 min completados  –  100% adherencia',
      tags: ['Carrera', 'Completada'],
      status: SessionStatus.completed,
      duration: '50 min',
    ),
    SessionModel(
      date: 'Martes 22 abr',
      title: 'Carrera Z2 – base aeróbica',
      subtitle: '50 min  –  Zona 2  –  60–70% FCmáx',
      completionText: '50 min completados  –  100% adherencia',
      tags: ['Fuerza', 'Completada'],
      status: SessionStatus.completed,
      duration: '50 min',
    ),
    SessionModel(
      date: 'Miércoles 23 abr',
      title: 'Carrera Z2 – base aeróbica',
      subtitle: '50 min  –  Zona 2  –  60–70% FCmáx',
      completionText: '50 min completados  –  100% adherencia',
      tags: ['Natación', 'Completada'],
      status: SessionStatus.completed,
      duration: '50 min',
    ),
    SessionModel(
      date: 'Jueves 24 abr',
      title: 'Descanso activo',
      subtitle: 'Caminata suave o movilidad  –  sin carga',
      tags: ['Descanso'],
      status: SessionStatus.rest,
      duration: '',
    ),
    SessionModel(
      date: 'Viernes 25 abr',
      title: 'Carrera Z2 – base aeróbica',
      subtitle: '50 min  –  Zona 2  –  60–70% FCmáx',
      tags: ['Fuerza', 'No completada'],
      status: SessionStatus.pending,
      duration: '50 min',
    ),
    SessionModel(
      date: 'Sábado 26 abr',
      title: 'Carrera Z2 – base aeróbica',
      subtitle: '50 min  –  Zona 2  –  60–70% FCmáx',
      completionText: '50 min completados  –  100% adherencia',
      tags: ['Carrera', 'Completada'],
      status: SessionStatus.completed,
      duration: '50 min',
    ),
    SessionModel(
      date: 'Domingo 27 abr',
      title: 'Descanso activo',
      subtitle: 'Caminata suave o movilidad  –  sin carga',
      tags: ['Descanso'],
      status: SessionStatus.rest,
      duration: '',
    ),
  ],
);

// ─── Semana 3 — Actual (mix completado/hoy/pendiente) ───────────
const week3 = WeekModel(
  weekNumber: 3,
  totalWeeks: 12,
  dateRange: 'Lunes 28 abr  –  Dom 4 may',
  weekType: 'carga',
  volume: '5h 20m',
  sessions: [
    SessionModel(
      date: 'Lunes 28 abr',
      title: 'Carrera Z2 – base aeróbica',
      subtitle: '50 min  –  Zona 2  –  60–70% FCmáx',
      completionText: '50 min completados  –  100% adherencia',
      tags: ['Carrera', 'Completada'],
      status: SessionStatus.completed,
      duration: '50 min',
    ),
    SessionModel(
      date: 'Martes 29 abr',
      title: 'Carrera Z2 – base aeróbica',
      subtitle: '50 min  –  Zona 2  –  60–70% FCmáx',
      completionText: '50 min completados  –  100% adherencia',
      tags: ['Fuerza', 'Completada'],
      status: SessionStatus.completed,
      duration: '50 min',
    ),
    SessionModel(
      date: 'Miércoles 30 abr',
      title: 'Carrera Z2 – base aeróbica',
      subtitle: '50 min  –  Zona 2  –  60–70% FCmáx',
      completionText: '50 min completados  –  100% adherencia',
      tags: ['Natación', 'Completada'],
      status: SessionStatus.completed,
      duration: '50 min',
    ),
    SessionModel(
      date: 'Jueves 1 may',
      title: 'Descanso activo',
      subtitle: 'Caminata suave o movilidad  –  sin carga',
      tags: ['Descanso'],
      status: SessionStatus.rest,
      duration: '',
    ),
    SessionModel(
      date: 'Viernes 2 may',
      title: 'Tri-Bici : Zona 2 - 70 min',
      subtitle: '70 min – Pedaleo constante  –  60–70% FCmáx',
      tags: ['Bici', 'Pendiente'],
      status: SessionStatus.today,
      duration: '70 min',
      isKey: true,
    ),
    SessionModel(
      date: 'Sábado 3 may',
      title: 'Tri-Bici : Zona 2 - 70 min',
      subtitle: '70 min – Pedaleo constante  –  60–70% FCmáx',
      tags: ['Fuerza'],
      status: SessionStatus.pending,
      duration: '70 min',
    ),
    SessionModel(
      date: 'Domingo 4 may',
      title: 'Descanso activo',
      subtitle: 'Caminata suave o movilidad  –  sin carga',
      tags: ['Descanso'],
      status: SessionStatus.pending,
      duration: '',
    ),
  ],
);

// ─── Semana 4 — Próxima (todo pendiente) ────────────────────────
const week4 = WeekModel(
  weekNumber: 4,
  totalWeeks: 12,
  dateRange: 'Lunes 5 may  –  Dom 11 may',
  weekType: 'descarga',
  volume: '3h 30m',
  sessions: [
    SessionModel(
      date: 'Lunes 5 may',
      title: 'Tri-Bici : Zona 2 - 70 min',
      subtitle: '70 min – Pedaleo constante  –  60–70% FCmáx',
      tags: ['Natación'],
      status: SessionStatus.pending,
      duration: '30 min',
    ),
    SessionModel(
      date: 'Martes 6 may',
      title: 'Tri-Bici : Zona 2 - 70 min',
      subtitle: '70 min – Pedaleo constante  –  60–70% FCmáx',
      tags: ['Natación'],
      status: SessionStatus.pending,
      duration: '30 min',
    ),
    SessionModel(
      date: 'Miércoles 7 may',
      title: 'Tri-Bici : Zona 2 - 70 min',
      subtitle: '70 min – Pedaleo constante  –  60–70% FCmáx',
      tags: ['Carrera'],
      status: SessionStatus.pending,
      duration: '30 min',
    ),
    SessionModel(
      date: 'Jueves 8 may',
      title: 'Descanso activo',
      subtitle: 'Caminata suave o movilidad  –  sin carga',
      tags: ['Descanso'],
      status: SessionStatus.rest,
      duration: '',
    ),
    SessionModel(
      date: 'Viernes 9 may',
      title: 'Tri-Bici : Zona 2 - 70 min',
      subtitle: '70 min – Pedaleo constante  –  60–70% FCmáx',
      tags: ['Natación'],
      status: SessionStatus.pending,
      duration: '30 min',
    ),
    SessionModel(
      date: 'Sábado 10 may',
      title: 'Tri-Bici : Zona 2 - 70 min',
      subtitle: '70 min – Pedaleo constante  –  60–70% FCmáx',
      tags: ['Carrera'],
      status: SessionStatus.pending,
      duration: '30 min',
    ),
    SessionModel(
      date: 'Domingo 11 may',
      title: 'Descanso activo',
      subtitle: 'Caminata suave o movilidad  –  sin carga',
      tags: ['Descanso'],
      status: SessionStatus.rest,
      duration: '',
    ),
  ],
);

// ─── Semanas 5-12 — Futuras (pendiente) ─────────────────────────
WeekModel _buildFutureWeek(int n, String dateRange, String weekType, String volume) =>
  WeekModel(
    weekNumber: n,
    totalWeeks: 12,
    dateRange: dateRange,
    weekType: weekType,
    volume: volume,
    sessions: [
      SessionModel(date: 'Lunes', title: 'Tri-Bici : Zona 2 - 70 min', subtitle: '70 min – Pedaleo constante  –  60–70% FCmáx', tags: ['Natación'], status: SessionStatus.pending, duration: '70 min'),
      SessionModel(date: 'Martes', title: 'Tri-Bici : Zona 2 - 70 min', subtitle: '70 min – Pedaleo constante  –  60–70% FCmáx', tags: ['Bici'], status: SessionStatus.pending, duration: '70 min'),
      SessionModel(date: 'Miércoles', title: 'Tri-Bici : Zona 2 - 70 min', subtitle: '70 min – Pedaleo constante  –  60–70% FCmáx', tags: ['Carrera'], status: SessionStatus.pending, duration: '70 min'),
      SessionModel(date: 'Jueves', title: 'Descanso activo', subtitle: 'Caminata suave o movilidad  –  sin carga', tags: ['Descanso'], status: SessionStatus.rest, duration: ''),
      SessionModel(date: 'Viernes', title: 'Tri-Bici : Zona 2 - 70 min', subtitle: '70 min – Pedaleo constante  –  60–70% FCmáx', tags: ['Natación'], status: SessionStatus.pending, duration: '70 min'),
      SessionModel(date: 'Sábado', title: 'Tri-Bici : Zona 2 - 70 min', subtitle: '70 min – Pedaleo constante  –  60–70% FCmáx', tags: ['Carrera'], status: SessionStatus.pending, duration: '70 min'),
      SessionModel(date: 'Domingo', title: 'Descanso activo', subtitle: 'Caminata suave o movilidad  –  sin carga', tags: ['Descanso'], status: SessionStatus.rest, duration: ''),
    ],
  );

// ─── Lista completa de semanas ───────────────────────────────────
final allWeeks = <WeekModel>[
  week1,
  week2,
  week3,
  week4,
  _buildFutureWeek(5,  'Lunes 12 may  –  Dom 18 may', 'carga',       '5h 40m'),
  _buildFutureWeek(6,  'Lunes 19 may  –  Dom 25 may', 'descarga',    '3h 0m'),
  _buildFutureWeek(7,  'Lunes 26 may  –  Dom 1 jun',  'carga',       '6h 0m'),
  _buildFutureWeek(8,  'Lunes 2 jun   –  Dom 8 jun',  'carga',       '6h 20m'),
  _buildFutureWeek(9,  'Lunes 9 jun   –  Dom 15 jun', 'descarga',    '3h 30m'),
  _buildFutureWeek(10, 'Lunes 16 jun  –  Dom 22 jun', 'pico',        '7h 0m'),
  _buildFutureWeek(11, 'Lunes 23 jun  –  Dom 29 jun', 'pico',        '7h 20m'),
  _buildFutureWeek(12, 'Lunes 30 jun  –  Dom 6 jul',  'recuperación','2h 0m'),
];

// Semana actual (índice 2 = semana 3)
const currentWeekIndex = 2;
// Keep for backwards compat
const sampleWeek = week3;