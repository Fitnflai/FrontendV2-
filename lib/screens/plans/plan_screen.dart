import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/cached_http.dart';
import '../../config/app_theme_extension.dart';
import '../../config/workout_types.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/bottom_nav.dart';
import '../../widgets/interactive_glossary_text.dart';
import '../../widgets/shared_widgets.dart';
import '../workout/workout_detail_screen.dart';
import '../workout/widgets/workout_adjustment_bottom_sheet.dart';
import '../../l10n/app_localizations.dart';

// ═══════════════════════════════════════════════════════════════
// SCREEN
// ═══════════════════════════════════════════════════════════════
class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  // Semana actual como punto de referencia
  late DateTime _weekStart;
  int _weekOffset = 0;
  bool _loading = true;
  String? _error;
  DateTime? _createdAt; // fecha de registro del usuario
  bool _hasFetched = false;
  DateTime? _selectedDate;

  final Map<String, GlobalKey> _dayKeys = {};

  void _scrollToDate(String dateKey) {
    final key = _dayKeys[dateKey];
    if (key != null && key.currentContext != null && mounted) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
        alignment: 0.05,
      );
    }
  }

  void _scrollToToday() {
    final now = DateTime.now();
    final todayKey =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    _scrollToDate(todayKey);
  }

  // Cache por semana (key = 'YYYY-MM-DD' del lunes)
  final Map<String, List<Map<String, dynamic>>> _cache = {};

  List<Map<String, dynamic>> get _sessions {
    final rawSessions = _cache[_weekKey(_weekStart)] ?? [];
    final start = DateTime(_weekStart.year, _weekStart.month, _weekStart.day);
    final end = start.add(const Duration(days: 7));

    return rawSessions.where((s) {
      final fechaStr = s['fecha_programada'] as String? ?? '';
      if (fechaStr.isEmpty) return false;
      final dateParsed = DateTime.tryParse(fechaStr.split('T')[0]);
      if (dateParsed == null) return false;

      return (dateParsed.isAtSameMomentAs(start) || dateParsed.isAfter(start)) &&
          dateParsed.isBefore(end);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _weekStart = _mondayOf(now);
    _selectedDate = now;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final auth = Provider.of<AuthProvider>(context);
    if (auth.status == AuthStatus.authenticated && !_hasFetched) {
      _hasFetched = true;
      Future.microtask(() => _loadUserAndWeek());
    }
  }

  Future<void> _loadUserAndWeek() async {
    final token = context.read<AuthProvider>().token ?? '';
    try {
      final res = await CachedHttp.get(
        Uri.parse('https://apifitnflai.com/users/me'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (!mounted) return;
      if (res.statusCode == 200) {
        final d = jsonDecode(res.body) as Map<String, dynamic>;
        final raw = d['created_at'] as String?;
        if (raw != null) {
          final dt = DateTime.tryParse(raw);
          if (dt != null) {
            _createdAt = DateTime(dt.year, dt.month, dt.day);
            debugPrint('CREATED_AT: $_createdAt');
          }
        }
      }
    } catch (e) {
      debugPrint('USER LOAD ERROR: $e');
    }
    if (!mounted) return;
    _cache.clear();
    _loadWeek(_weekStart);
  }

  DateTime _mondayOf(DateTime d) {
    final midnight = DateTime(d.year, d.month, d.day);
    return midnight.subtract(Duration(days: midnight.weekday - 1));
  }

  String _weekKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  bool _isCurrentWeek(DateTime monday) {
    final nowMonday = _mondayOf(DateTime.now());
    return monday.year == nowMonday.year &&
        monday.month == nowMonday.month &&
        monday.day == nowMonday.day;
  }

  Future<void> _loadWeek(DateTime monday) async {
    final key = _weekKey(monday);
    if (_cache.containsKey(key)) {
      if (mounted) {
        setState(() => _loading = false);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_isCurrentWeek(monday)) {
            _scrollToToday();
          }
        });
      }
      return;
    }
    if (mounted) setState(() { _loading = true; _error = null; });
    try {
      final token = context.read<AuthProvider>().token ?? '';
      final res = await CachedHttp.get(
        Uri.parse('https://apifitnflai.com/entrenamientos/semana?start_date=$key'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (!mounted) return;
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body) as Map<String, dynamic>;
        final plan = (body['plan'] as List<dynamic>? ?? [])
            .whereType<Map<String, dynamic>>()
            .toList();
        _cache[key] = plan;
      } else {
        _cache[key] = [];
        if (mounted) setState(() => _error = 'Error al cargar el plan');
      }
    } catch (e) {
      _cache[_weekKey(monday)] = [];
      if (mounted) setState(() => _error = 'Error de conexión');
    } finally {
      if (mounted) {
        setState(() => _loading = false);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_isCurrentWeek(monday)) {
            _scrollToToday();
          }
        });
      }
    }
  }

  void _prevWeek() {
    final prev = _weekStart.subtract(const Duration(days: 7));
    setState(() {
      _weekStart = prev;
      _weekOffset--;
      _selectedDate = _isCurrentWeek(prev) ? DateTime.now() : prev;
      _dayKeys.clear();
    });
    _loadWeek(prev);
  }

  void _nextWeek() {
    final next = _weekStart.add(const Duration(days: 7));
    setState(() {
      _weekStart = next;
      _weekOffset++;
      _selectedDate = _isCurrentWeek(next) ? DateTime.now() : next;
      _dayKeys.clear();
    });
    _loadWeek(next);
  }

  _WeekContext get _weekContext {
    if (_weekOffset < 0) return _WeekContext.past;
    if (_weekOffset > 0) return _WeekContext.future;
    return _WeekContext.current;
  }

  String _weekLabel() {
    final end = _weekStart.add(const Duration(days: 6));
    const m = ['ene','feb','mar','abr','may','jun',
                'jul','ago','sep','oct','nov','dic'];
    return '${_weekStart.day} ${m[_weekStart.month-1]} – ${end.day} ${m[end.month-1]} ${end.year}';
  }

  bool _isWorkout(Map<String, dynamic> s) {
    final tipo = (s['tipo'] as String? ?? '').toLowerCase().trim();
    final titulo = (s['titulo_entrenamiento'] as String? ?? '').trim();
    if (tipo == 'descanso_activo' ||
        tipo == 'descanso' ||
        tipo.contains('descanso') ||
        tipo.contains('rest')) {
      return false;
    }
    return titulo.isNotEmpty;
  }

  List<Map<String, dynamic>> get _workoutSessions =>
      _sessions.where(_isWorkout).toList();

  int get _completedCount =>
      _workoutSessions.where((s) {
        final e = (s['estado'] as String? ?? '').toLowerCase();
        return e == 'completado' || e == 'completo' || e == 'done';
      }).length;

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
        bottomNavigationBar: const AppBottomNav(selectedIndex: 1),
      );
    }

    final completed = _completedCount;
    final total     = _workoutSessions.length;

    return Scaffold(
      backgroundColor: theme.bg,
      body: SafeArea(
        bottom: false,
        child: Column(children: [
          AppHeader(section: l10n.planHeaderSection),
          Expanded(
            child: RefreshIndicator(
              color: theme.primary,
              backgroundColor: theme.card,
              onRefresh: () async {
                _cache.remove(_weekKey(_weekStart));
                _dayKeys.clear();
                await _loadWeek(_weekStart);
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // ── Week navigator ───────────────
                    _WeekNavigatorBar(
                      label:       _weekLabel(),
                      weekContext: _weekContext,
                      onPrev:      _prevWeek,
                      onNext:      _nextWeek,
                      canGoPrev:   true,
                    ),
                    const SizedBox(height: 12),

                    // ── 7-Day Week Strip ──────────────
                    if (!_loading)
                      _WeekDaysStrip(
                        weekStart: _weekStart,
                        selectedDate: _selectedDate,
                        sessions: _sessions,
                        onSelectDay: (dayDate) {
                          setState(() => _selectedDate = dayDate);
                          final dayKey =
                              '${dayDate.year}-${dayDate.month.toString().padLeft(2, '0')}-${dayDate.day.toString().padLeft(2, '0')}';
                          _scrollToDate(dayKey);
                        },
                      ),
                    if (!_loading)
                      const SizedBox(height: 12),

                    // ── Compact Metrics Row ───────────
                    if (!_loading && _sessions.isNotEmpty)
                      _CompactMetricsBar(completed: completed, total: total),
                    if (!_loading && _sessions.isNotEmpty)
                      const SizedBox(height: 8),

                    // ── Progress bar ──────────────────
                    if (!_loading && total > 0) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: total == 0 ? 0 : completed / total,
                          minHeight: 5,
                          backgroundColor: theme.border,
                          valueColor: AlwaysStoppedAnimation<Color>(theme.primary),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // ── Context label ─────────────────
                    _ContextBanner(weekContext: _weekContext),
                    const SizedBox(height: 12),

                    // ── Content ───────────────────────
                    if (_loading)
                      Center(child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: CircularProgressIndicator(color: theme.primary),
                      ))
                    else if (_error != null)
                      _ErrorCard(message: _error!, onRetry: () {
                        _cache.remove(_weekKey(_weekStart));
                        _loadWeek(_weekStart);
                      })
                    else if (_sessions.isEmpty)
                      _EmptyWeek(weekContext: _weekContext)
                    else
                      ..._sessions
                        .where((s) {
                          final tipo   = (s['tipo'] as String? ?? '').toLowerCase();
                          final titulo = (s['titulo_entrenamiento'] as String? ?? '').trim();
                          return titulo.isNotEmpty ||
                              tipo.contains('descanso') ||
                              tipo.contains('rest');
                        })
                        .map((s) {
                          final fecha = (s['fecha_programada'] as String? ?? '').split('T')[0];
                          final itemKey = _dayKeys.putIfAbsent(fecha, () => GlobalKey());
                          return Padding(
                            key: itemKey,
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _SessionCard(
                              data: s,
                              weekContext: _weekContext,
                              onAdjusted: () {
                                CachedHttp.clearCache();
                                _cache.clear();
                                _dayKeys.clear();
                                _loadWeek(_weekStart);
                              },
                            ),
                          );
                        }),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
          const AppBottomNav(selectedIndex: 1),
        ]),
      ),
    );
  }
}

enum _WeekContext { past, current, future }

// ═══════════════════════════════════════════════════════════════
// CONTEXT BANNER
// ═══════════════════════════════════════════════════════════════
class _ContextBanner extends StatelessWidget {
  final _WeekContext weekContext;
  const _ContextBanner({required this.weekContext});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>() ?? AppThemeExtension.dark;
    final l10n  = AppLocalizations.of(context);
    final label = weekContext == _WeekContext.past ? l10n.planContextPast
        : weekContext == _WeekContext.future ? l10n.planContextFuture : l10n.planContextCurrent;
    final icon  = weekContext == _WeekContext.past ? Icons.history
        : weekContext == _WeekContext.future ? Icons.upcoming_outlined : Icons.today_outlined;
    final color = weekContext == _WeekContext.past ? theme.grey
        : weekContext == _WeekContext.future ? Colors.blue : theme.primary;
    return Row(children: [
      Icon(icon, color: color, size: 14),
      const SizedBox(width: 6),
      Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
    ]);
  }
}

// ═══════════════════════════════════════════════════════════════
// WEEK NAVIGATOR BAR
// ═══════════════════════════════════════════════════════════════
class _WeekNavigatorBar extends StatelessWidget {
  final String label;
  final _WeekContext weekContext;
  final VoidCallback onPrev, onNext;
  final bool canGoPrev;
  const _WeekNavigatorBar({
    required this.label,
    required this.weekContext,
    required this.onPrev,
    required this.onNext,
    this.canGoPrev = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>() ?? AppThemeExtension.dark;
    final l10n  = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.border.withValues(alpha: 0.5)),
      ),
      child: Row(children: [
        GestureDetector(
          onTap: canGoPrev ? onPrev : null,
          child: Container(
            width: 34, height: 34,
            decoration: BoxDecoration(
              color: theme.cardDark,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: theme.border),
            ),
            child: Icon(Icons.keyboard_double_arrow_left,
                color: canGoPrev ? theme.greyLight : theme.border,
                size: 16),
          ),
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.planWeekNavTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: theme.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: theme.grey,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: onNext,
          child: Container(
            width: 34, height: 34,
            decoration: BoxDecoration(
              color: theme.cardDark,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: theme.border),
            ),
            child: Icon(Icons.keyboard_double_arrow_right,
                color: theme.greyLight, size: 16),
          ),
        ),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// 7-DAY WEEK STRIP
// ═══════════════════════════════════════════════════════════════
class _WeekDaysStrip extends StatelessWidget {
  final DateTime weekStart;
  final DateTime? selectedDate;
  final List<Map<String, dynamic>> sessions;
  final ValueChanged<DateTime> onSelectDay;

  const _WeekDaysStrip({
    required this.weekStart,
    required this.selectedDate,
    required this.sessions,
    required this.onSelectDay,
  });

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool _isToday(DateTime d) {
    final now = DateTime.now();
    return d.year == now.year && d.month == now.month && d.day == now.day;
  }

  bool _isWorkout(Map<String, dynamic> s) {
    final tipo = (s['tipo'] as String? ?? '').toLowerCase().trim();
    final titulo = (s['titulo_entrenamiento'] as String? ?? '').trim();
    if (tipo == 'descanso_activo' ||
        tipo == 'descanso' ||
        tipo.contains('descanso') ||
        tipo.contains('rest')) {
      return false;
    }
    return titulo.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>() ?? AppThemeExtension.dark;
    const dayLetters = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];

    final Map<String, Map<String, dynamic>> sessionByDay = {};
    for (final s in sessions) {
      final f = (s['fecha_programada'] as String? ?? '').split('T')[0];
      if (f.isNotEmpty) {
        sessionByDay[f] = s;
      }
    }

    return Row(
      children: List.generate(7, (index) {
        final dayDate = weekStart.add(Duration(days: index));
        final dateKey =
            '${dayDate.year}-${dayDate.month.toString().padLeft(2, '0')}-${dayDate.day.toString().padLeft(2, '0')}';
        final session = sessionByDay[dateKey];

        final bool isToday = _isToday(dayDate);
        final bool isSelected = selectedDate != null && _isSameDay(selectedDate!, dayDate);

        String emoji = '🌙';
        bool isDone = false;

        if (session != null) {
          if (_isWorkout(session)) {
            final tipo = session['tipo'] as String? ?? '';
            emoji = WorkoutTypes.fromTipo(tipo).emoji;
            final estado = (session['estado'] as String? ?? '').toLowerCase();
            isDone = estado == 'completado' || estado == 'completo' || estado == 'done';
          } else {
            emoji = '🌙';
          }
        }

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: GestureDetector(
              onTap: () => onSelectDay(dayDate),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.primary.withValues(alpha: 0.16)
                      : (isToday ? theme.cardDark : theme.card),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? theme.primary
                        : (isToday
                            ? theme.primary.withValues(alpha: 0.5)
                            : theme.border.withValues(alpha: 0.6)),
                    width: isSelected ? 1.5 : 1.0,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      dayLetters[index],
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? theme.primary
                            : (isToday ? theme.primary : theme.grey),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${dayDate.day}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: isSelected || isToday ? theme.white : theme.greyLight,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        Text(
                          emoji,
                          style: const TextStyle(fontSize: 15),
                        ),
                        if (isDone)
                          Positioned(
                            right: -5,
                            bottom: -2,
                            child: Container(
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(
                                color: theme.greenText,
                                shape: BoxShape.circle,
                                border: Border.all(color: theme.cardDark, width: 1),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// COMPACT METRICS BAR
// ═══════════════════════════════════════════════════════════════
class _CompactMetricsBar extends StatelessWidget {
  final int completed;
  final int total;

  const _CompactMetricsBar({required this.completed, required this.total});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>() ?? AppThemeExtension.dark;
    final l10n  = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.border.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Icon(Icons.fitness_center, size: 14, color: theme.primary),
                const SizedBox(width: 8),
                Flexible(
                  child: RichText(
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      style: TextStyle(fontSize: 12, color: theme.greyLight),
                      children: [
                        TextSpan(text: '${l10n.planScheduledTrainings}: '),
                        TextSpan(
                          text: '$total',
                          style: TextStyle(fontWeight: FontWeight.w700, color: theme.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(width: 1, height: 16, color: theme.border, margin: const EdgeInsets.symmetric(horizontal: 8)),
          Expanded(
            child: Row(
              children: [
                Icon(Icons.check_circle_outline, size: 14, color: theme.greenText),
                const SizedBox(width: 8),
                Flexible(
                  child: RichText(
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      style: TextStyle(fontSize: 12, color: theme.greyLight),
                      children: [
                        TextSpan(text: '${l10n.planCompletedSummary}: '),
                        TextSpan(
                          text: '$completed',
                          style: TextStyle(fontWeight: FontWeight.w700, color: theme.greenText),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (total > 0) ...[
            Container(width: 1, height: 16, color: theme.border, margin: const EdgeInsets.symmetric(horizontal: 8)),
            Text(
              '${(completed / total * 100).round()}%',
              style: TextStyle(color: theme.primary, fontSize: 13, fontWeight: FontWeight.w800),
            ),
          ],
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// SESSION CARD (Collapsible & Compact)
// ═══════════════════════════════════════════════════════════════
class _SessionCard extends StatefulWidget {
  final Map<String, dynamic> data;
  final _WeekContext weekContext;
  final VoidCallback? onAdjusted;
  const _SessionCard({
    required this.data,
    required this.weekContext,
    this.onAdjusted,
  });

  @override
  State<_SessionCard> createState() => _SessionCardState();
}

class _SessionCardState extends State<_SessionCard> {
  late bool _expanded;

  bool _isToday(String? fecha) {
    if (fecha == null || fecha.isEmpty) return false;
    final d = DateTime.tryParse(fecha.split('T')[0]);
    if (d == null) return false;
    final now = DateTime.now();
    return d.year == now.year && d.month == now.month && d.day == now.day;
  }

  bool _isPast(String? fecha) {
    if (fecha == null || fecha.isEmpty) return false;
    final d = DateTime.tryParse(fecha.split('T')[0]);
    if (d == null) return false;
    final now = DateTime.now();
    return d.isBefore(DateTime(now.year, now.month, now.day));
  }

  String _formatDateHeader(String f) {
    final d = DateTime.tryParse(f.split('T')[0]);
    if (d == null) return f;
    const dias = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
    const meses = ['ene', 'feb', 'mar', 'abr', 'may', 'jun', 'jul', 'ago', 'sep', 'oct', 'nov', 'dic'];
    final diaNombre = dias[d.weekday - 1];
    return '$diaNombre ${d.day} ${meses[d.month - 1]}';
  }

  @override
  void initState() {
    super.initState();
    final fecha = widget.data['fecha_programada'] as String? ?? '';
    final isToday = _isToday(fecha) && widget.weekContext == _WeekContext.current;
    final estado = (widget.data['estado'] as String? ?? '').toLowerCase();
    final isCompleted = estado == 'completado' || estado == 'completo' || estado == 'done';
    // Por defecto, si es la sesión de hoy y no está completada, se muestra abierta.
    // El resto de días comienzan contraídas para optimizar el espacio vertical.
    _expanded = isToday && !isCompleted;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>() ?? AppThemeExtension.dark;
    final l10n  = AppLocalizations.of(context);
    final tipo   = widget.data['tipo'] as String? ?? '';
    final fecha  = widget.data['fecha_programada'] as String? ?? '';
    final tipoLower = tipo.toLowerCase().trim();

    // ── Día de descanso activo / total ──────────────────────────
    if (tipoLower == 'descanso_activo' ||
        tipoLower == 'descanso' ||
        tipoLower.contains('descanso') ||
        tipoLower.contains('rest')) {
      return _RestDayCard(data: widget.data, fecha: fecha);
    }

    final titulo     = widget.data['titulo_entrenamiento'] as String? ?? '';
    final estado     = (widget.data['estado']              as String? ?? '').toLowerCase();
    final ejercicios = widget.data['ejercicios_asociados'] as List<dynamic>? ?? [];
    final cfg        = WorkoutTypes.fromTipo(tipo);

    final isToday     = _isToday(fecha) && widget.weekContext == _WeekContext.current;
    final isCompleted = estado == 'completado' || estado == 'completo' || estado == 'done';
    final isMissed    = !isCompleted && _isPast(fecha) && !_isToday(fecha);

    Color borderColor = cfg.bgColor.withValues(alpha: 0.6);
    if (isToday)     borderColor = theme.primary;
    if (isCompleted) borderColor = theme.greenMid;
    if (isMissed)    borderColor = theme.redMid;

    final bgBase = cfg.bgColor.withValues(alpha: isToday ? 0.18 : 0.10);
    final dayHeader = _formatDateHeader(fecha);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isMissed ? theme.redMid.withValues(alpha: 0.1) : bgBase,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: isToday ? 1.5 : 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Top Header Row (Siempre visible y limpio) ─────────────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: cfg.bgColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(cfg.emoji, style: const TextStyle(fontSize: 22)),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              if (isToday) ...[
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  margin: const EdgeInsets.only(right: 6),
                                  decoration: BoxDecoration(
                                    color: theme.primary.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: theme.primary.withValues(alpha: 0.5)),
                                  ),
                                  child: Text(
                                    l10n.planSessionCardTodayBadge.toUpperCase(),
                                    style: TextStyle(
                                      color: theme.primary,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ],
                              Text(
                                dayHeader,
                                style: TextStyle(
                                  color: theme.grey,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          InteractiveGlossaryText(
                            text: titulo,
                            style: TextStyle(
                              color: theme.white,
                              fontSize: isToday ? 17 : 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          if (!_expanded && ejercicios.isNotEmpty) ...[
                            const SizedBox(height: 3),
                            Text(
                              '${ejercicios.length} ejercicios · $tipo',
                              style: TextStyle(
                                color: theme.greyLight.withValues(alpha: 0.8),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (isCompleted)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: theme.greenMid.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: theme.greenMid),
                            ),
                            child: Text(
                              'Completado',
                              style: TextStyle(
                                color: theme.greenText,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        else if (isMissed)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: theme.redMid.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: theme.redMid),
                            ),
                            child: Text(
                              l10n.planSessionCardMissedBadge,
                              style: TextStyle(
                                color: theme.redText,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        else if (tipo.isNotEmpty && _expanded) ...[
                          Text(
                            tipo,
                            style: TextStyle(
                              color: cfg.bgColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                        const SizedBox(height: 4),
                        AnimatedRotation(
                          turns: _expanded ? 0.5 : 0.0,
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: theme.grey,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // ── Contenido Expandible (Ejercicios y Acciones) ──────────────────────
                if (_expanded) ...[
                  if (ejercicios.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Divider(color: theme.border, height: 1),
                    const SizedBox(height: 10),
                    ...ejercicios.take(4).map((e) {
                      final ej     = (e is Map) ? e['ejercicio'] as Map<String, dynamic>? : null;
                      final nombre = ej?['nombre'] as String? ?? '';
                      if (nombre.isEmpty) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: InteractiveGlossaryText(
                          text: '· $nombre',
                          style: TextStyle(color: theme.greyLight, fontSize: 12, height: 1.3),
                        ),
                      );
                    }),
                    if (ejercicios.length > 4)
                      Text(
                        '+ ${ejercicios.length - 4} más',
                        style: TextStyle(color: theme.grey, fontSize: 11),
                      ),
                  ],

                  // ── Botón Iniciar entrenamiento (solo hoy y no completado) ───────────
                  if (isToday && !isCompleted) ...[
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => WorkoutDetailScreen(entrenamiento: widget.data),
                            ),
                          );
                          widget.onAdjusted?.call();
                        },
                        icon: const Icon(Icons.play_arrow, size: 18),
                        label: Text(
                          l10n.planSessionCardStartBtn,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primary,
                          foregroundColor: theme.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],

                  // ── Botón Ajustar (solo si es hoy y no completado) ─────────────────────
                  if (isToday && !isCompleted)
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: OutlinedButton(
                        onPressed: () async {
                          final id = widget.data['id_entrenamiento'] ?? widget.data['id'];
                          if (id == null) return;
                          final result = await showModalBottomSheet<bool>(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => WorkoutAdjustmentBottomSheet(workoutId: id),
                          );
                          if (result == true) {
                            widget.onAdjusted?.call();
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: theme.greyLight,
                          side: BorderSide(color: theme.border),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(l10n.planSessionCardAdjustBtn, style: const TextStyle(fontSize: 13)),
                      ),
                    )
                  // ── Botón Ver detalle (si NO es hoy, o si es hoy pero YA está completado) ───
                  else if (!isToday || isCompleted) ...[
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => WorkoutDetailScreen(entrenamiento: widget.data),
                            ),
                          );
                          widget.onAdjusted?.call();
                        },
                        icon: const Icon(Icons.info_outline, size: 16),
                        label: Text(l10n.planSessionCardDetailBtn, style: const TextStyle(fontSize: 13)),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: theme.greyLight,
                          side: BorderSide(color: theme.border),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ],

                  // ── Semana futura aviso ───────────────────────────────────────────────
                  if (widget.weekContext == _WeekContext.future) ...[
                    const SizedBox(height: 8),
                    Row(children: [
                      Icon(Icons.lock_outline, color: theme.grey, size: 13),
                      const SizedBox(width: 4),
                      Text(
                        l10n.planSessionCardLockDesc,
                        style: TextStyle(color: theme.grey, fontSize: 11),
                      ),
                    ]),
                  ],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// EMPTY / ERROR STATES
// ═══════════════════════════════════════════════════════════════
class _EmptyWeek extends StatelessWidget {
  final _WeekContext weekContext;
  const _EmptyWeek({required this.weekContext});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>() ?? AppThemeExtension.dark;
    final l10n  = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: theme.card,
          borderRadius: BorderRadius.circular(14)),
      child: Column(children: [
        Text(weekContext == _WeekContext.future ? '📅' : '😴',
            style: const TextStyle(fontSize: 36)),
        const SizedBox(height: 12),
        Text(weekContext == _WeekContext.future
            ? l10n.planEmptyFutureTitle
            : l10n.planEmptyPastTitle,
            textAlign: TextAlign.center,
            style: TextStyle(color: theme.white, fontSize: 15,
                fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Text(l10n.planEmptyFutureDesc,
            textAlign: TextAlign.center,
            style: TextStyle(color: theme.grey, fontSize: 12)),
      ]),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorCard({required this.message, required this.onRetry});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>() ?? AppThemeExtension.dark;
    final l10n  = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: theme.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: theme.redMid)),
      child: Column(children: [
        Icon(Icons.error_outline, color: theme.redText, size: 32),
        const SizedBox(height: 8),
        Text(message, style: TextStyle(color: theme.greyLight, fontSize: 13)),
        const SizedBox(height: 12),
        TextButton(onPressed: onRetry,
            child: Text(l10n.planRetry, style: TextStyle(color: theme.primary))),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// REST DAY CARD (Compact ~55px, Expandable & Methodologically Sound)
// ═══════════════════════════════════════════════════════════════
class _RestDayCard extends StatefulWidget {
  final Map<String, dynamic> data;
  final String fecha;
  const _RestDayCard({required this.data, required this.fecha});

  @override
  State<_RestDayCard> createState() => _RestDayCardState();
}

class _RestDayCardState extends State<_RestDayCard> {
  bool _expanded = false;

  bool _isToday(String f) {
    final d = DateTime.tryParse(f.split('T')[0]);
    if (d == null) return false;
    final now = DateTime.now();
    return d.year == now.year && d.month == now.month && d.day == now.day;
  }

  String _formatDateHeader(String f) {
    final d = DateTime.tryParse(f.split('T')[0]);
    if (d == null) return f;
    const dias = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
    final diaNombre = dias[d.weekday - 1];
    return '$diaNombre ${d.day}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>() ?? AppThemeExtension.dark;
    final l10n  = AppLocalizations.of(context);
    final isToday = _isToday(widget.fecha);
    final cfg     = WorkoutTypes.fromTipo('Descanso');

    final tipoStr = (widget.data['tipo'] as String? ?? '').toLowerCase();
    final mensajeStr = (widget.data['mensaje'] as String? ?? '').toLowerCase();

    // Detección rigurosa de descanso total vs recuperación activa
    final isExplicitTotalRest = tipoStr == 'descanso' ||
        tipoStr == 'descanso_total' ||
        tipoStr == 'descanso_pasivo' ||
        mensajeStr.contains('descanso total') ||
        mensajeStr.contains('no entrenar');

    final isRecovery = !isExplicitTotalRest &&
        (tipoStr.contains('activo') ||
         tipoStr.contains('recuperaci') ||
         mensajeStr.contains('recuperación activa') ||
         mensajeStr.contains('caminata suave'));

    final restTitle = isRecovery ? l10n.planActiveRecoveryLabel : l10n.planRestLabel;
    final subtitle  = isRecovery ? l10n.planRestActiveSubtitle : l10n.planRestPassiveSubtitle;
    final mensaje   = widget.data['mensaje'] as String? ?? l10n.planActiveRestDefaultMsg;
    final dayHeader = _formatDateHeader(widget.fecha);

    final allTips = [
      (key: 'caminata', icon: Icons.directions_walk_outlined, title: l10n.planActiveRestTipWalk, isActive: true),
      (key: 'movilidad', icon: Icons.self_improvement_outlined, title: l10n.planActiveRestTipMobility, isActive: true),
      (key: 'hidratacion', icon: Icons.water_drop_outlined, title: l10n.planActiveRestTipHydration, isActive: false),
      (key: 'sueno', icon: Icons.bedtime_outlined, title: l10n.planActiveRestTipSleep, isActive: false),
    ];

    // Regla metodológica: Si es descanso total, se suprimen tips activos (caminata, movilidad)
    final filteredTips = allTips.where((t) {
      if (!isRecovery && t.isActive) return false;
      final val = widget.data[t.key] as String?;
      return val != null && val.isNotEmpty;
    }).toList();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: cfg.bgColor.withValues(alpha: isToday ? 0.16 : 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isToday ? theme.primary : cfg.bgColor.withValues(alpha: 0.5),
          width: isToday ? 1.5 : 1.0,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Compact Header (~55px height collapsed) ─────────
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: cfg.bgColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text('🌙', style: TextStyle(fontSize: 18)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '$dayHeader · ',
                                style: TextStyle(
                                  color: theme.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                restTitle,
                                style: TextStyle(
                                  color: cfg.bgColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            subtitle,
                            style: TextStyle(
                              color: theme.grey,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isToday) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: theme.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: theme.primary),
                        ),
                        child: Text(
                          l10n.planSessionCardTodayBadge,
                          style: TextStyle(
                            color: theme.primary,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                    ],
                    AnimatedRotation(
                      turns: _expanded ? 0.5 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: theme.grey,
                        size: 20,
                      ),
                    ),
                  ],
                ),

                // ── Expandable Details ─────────────────────────────
                if (_expanded) ...[
                  const SizedBox(height: 12),
                  Divider(color: cfg.bgColor.withValues(alpha: 0.2), height: 1),
                  const SizedBox(height: 12),
                  InteractiveGlossaryText(
                    text: mensaje,
                    style: TextStyle(
                      color: theme.greyLight,
                      fontSize: 12,
                      height: 1.45,
                    ),
                  ),
                  if (filteredTips.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      l10n.planActiveRestRecs,
                      style: TextStyle(
                        color: cfg.bgColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...filteredTips.map((tip) {
                      final val = widget.data[tip.key] as String? ?? '';
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: cfg.bgColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: cfg.bgColor.withValues(alpha: 0.3)),
                              ),
                              child: Icon(tip.icon, color: cfg.bgColor, size: 14),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tip.title,
                                    style: TextStyle(
                                      color: theme.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    val,
                                    style: TextStyle(
                                      color: theme.grey,
                                      fontSize: 11,
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
