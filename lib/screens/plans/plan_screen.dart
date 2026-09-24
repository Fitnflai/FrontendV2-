import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/cached_http.dart';
import '../../config/app_theme_extension.dart';
import '../../config/workout_types.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/bottom_nav.dart';
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
  int  _weekOffset = 0;
  bool _loading    = true;
  String? _error;
  DateTime? _createdAt; // fecha de registro del usuario
  bool _hasFetched = false;


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
    _weekStart = _mondayOf(DateTime.now());

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
            // Usar fecha exacta sin hora para comparar solo por día
            _createdAt = DateTime(dt.year, dt.month, dt.day);
            debugPrint('CREATED_AT: $_createdAt');
          }
        }
      }
    } catch (e) {
      debugPrint('USER LOAD ERROR: $e');
    }
    if (!mounted) return;
    // Limpiar cache para que el filtro aplique con _createdAt ya asignado
    _cache.clear();
    _loadWeek(_weekStart);
  }

  DateTime _mondayOf(DateTime d) {
    final midnight = DateTime(d.year, d.month, d.day);
    return midnight.subtract(Duration(days: midnight.weekday - 1));
  }
  String _weekKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2,'0')}-${d.day.toString().padLeft(2,'0')}';

  Future<void> _loadWeek(DateTime monday) async {
    final key = _weekKey(monday);
    if (_cache.containsKey(key)) {
      if (mounted) setState(() => _loading = false);
      return;
    }
    if (mounted) setState(() { _loading = true; _error = null; });
    try {
      final token = context.read<AuthProvider>().token ?? '';
      final res   = await CachedHttp.get(
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
      if (mounted) setState(() => _loading = false);
    }
  }

  void _prevWeek() {
    final prev = _weekStart.subtract(const Duration(days: 7));

    setState(() { _weekStart = prev; _weekOffset--; });
    _loadWeek(prev);
  }

  void _nextWeek() {
    final next = _weekStart.add(const Duration(days: 7));
    setState(() { _weekStart = next; _weekOffset++; });
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

  int get _completedCount =>
      _sessions.where((s) {
        final e = (s['estado'] as String? ?? '').toLowerCase();
        return e == 'completado' || e == 'completo' || e == 'done';
      }).length;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>() ?? AppThemeExtension.dark;
    final l10n  = AppLocalizations.of(context);
    final completed = _completedCount;
    final total     = _sessions.length;

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
                      label:      _weekLabel(),
                      weekContext: _weekContext,
                      onPrev:     _prevWeek,
                      onNext:     _nextWeek,
                      canGoPrev:  true,
                    ),
                    const SizedBox(height: 14),

                    // ── Stats row ─────────────────────
                    if (!_loading && _sessions.isNotEmpty)
                      _StatsRow(completed: completed, total: total),
                    if (!_loading && _sessions.isNotEmpty)
                      const SizedBox(height: 10),

                    // ── Progress bar ──────────────────
                    if (!_loading && total > 0) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: total == 0 ? 0 : completed / total,
                          minHeight: 6,
                          backgroundColor: theme.border,
                          valueColor: AlwaysStoppedAnimation<Color>(theme.primary),
                        ),
                      ),
                      const SizedBox(height: 20),
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
                          final tipo   = s['tipo'] as String? ?? '';
                          final titulo = s['titulo_entrenamiento'] as String? ?? '';
                          // Mostrar si tiene entrenamiento o si es descanso activo
                          return titulo.isNotEmpty || tipo == 'descanso_activo';
                        })
                        .map((s) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _SessionCard(data: s, weekContext: _weekContext),
                        )),

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
  const _WeekNavigatorBar({required this.label, required this.weekContext,
      required this.onPrev, required this.onNext, this.canGoPrev = true});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>() ?? AppThemeExtension.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
          color: theme.card, borderRadius: BorderRadius.circular(14)),
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
          child: Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(color: theme.white, fontSize: 14,
                  fontWeight: FontWeight.w700)),
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
// STATS ROW
// ═══════════════════════════════════════════════════════════════
class _StatsRow extends StatelessWidget {
  final int completed, total;
  const _StatsRow({required this.completed, required this.total});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>() ?? AppThemeExtension.dark;
    final l10n  = AppLocalizations.of(context);
    return Row(children: [
      Expanded(child: _StatBox(value: '$completed/$total', label: l10n.planSessionsLabel, valueColor: theme.primary)),
      const SizedBox(width: 10),
      Expanded(child: _StatBox(
        value: total == 0 ? '0%' : '${(completed / total * 100).round()}%',
        label: l10n.planCompletedLabel,
        valueColor: theme.greenText,
      )),
    ]);
  }
}

class _StatBox extends StatelessWidget {
  final String value, label;
  final Color valueColor;
  const _StatBox({required this.value, required this.label, required this.valueColor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>() ?? AppThemeExtension.dark;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(color: theme.card, borderRadius: BorderRadius.circular(12)),
      child: Column(children: [
        Text(value, style: TextStyle(color: valueColor, fontSize: 20, fontWeight: FontWeight.w800)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(color: theme.grey, fontSize: 11)),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// SESSION CARD
// ═══════════════════════════════════════════════════════════════
class _SessionCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final _WeekContext weekContext;
  const _SessionCard({required this.data, required this.weekContext});

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


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>() ?? AppThemeExtension.dark;
    final l10n  = AppLocalizations.of(context);
    final tipo   = data['tipo'] as String? ?? '';
    final fecha  = data['fecha_programada'] as String? ?? '';

    // ── Día de descanso activo ──────────────────────────────────
    if (tipo == 'descanso_activo') {
      return _RestDayCard(data: data, fecha: fecha);
    }

    final titulo     = data['titulo_entrenamiento'] as String? ?? '';
    final estado     = (data['estado']              as String? ?? '').toLowerCase();
    final ejercicios = data['ejercicios_asociados'] as List<dynamic>? ?? [];
    final cfg        = WorkoutTypes.fromTipo(tipo);

    final isToday     = _isToday(fecha) && weekContext == _WeekContext.current;
    final isCompleted = estado == 'completado' || estado == 'completo' || estado == 'done';
    final isMissed    = !isCompleted && _isPast(fecha) && !_isToday(fecha);

    Color borderColor = cfg.bgColor.withValues(alpha: 0.6);
    if (isToday)     borderColor = theme.primary;
    if (isCompleted) borderColor = theme.greenMid;
    if (isMissed)    borderColor = theme.redMid;

    // Color de fondo basado en el tipo
    final bgBase = cfg.bgColor.withValues(alpha: isToday ? 0.18 : 0.10);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isMissed ? theme.redMid.withValues(alpha: 0.1) : bgBase,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: isToday ? 1.5 : 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          // ── Top row ───────────────────────────
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Icono del tipo
            Container(
              width: 40, height: 40,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: cfg.bgColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(child: Text(cfg.emoji,
                  style: const TextStyle(fontSize: 24))),
            ),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                if (isToday)
                  Text(l10n.planSessionCardTodayHeader,
                      style: TextStyle(color: theme.primary, fontSize: 11,
                          fontWeight: FontWeight.w800, letterSpacing: 0.5))
                else
                  Text(fecha, style: TextStyle(color: theme.grey, fontSize: 11)),
                const SizedBox(height: 4),
                Text(titulo, style: TextStyle(
                    color: theme.white,
                    fontSize: isToday ? 19 : 16,
                    fontWeight: FontWeight.w800)),
              ]),
            ),
            const SizedBox(width: 8),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              if (isToday)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                      color: theme.primary, borderRadius: BorderRadius.circular(20)),
                  child: Text(l10n.planSessionCardTodayBadge,
                      style: TextStyle(color: theme.white, fontSize: 11, fontWeight: FontWeight.w700)),
                ),
              if (isCompleted)
                Container(
                  width: 28, height: 28,
                  decoration: BoxDecoration(
                      color: theme.greenMid, borderRadius: BorderRadius.circular(8)),
                  child: Icon(Icons.check, color: theme.white, size: 16),
                ),
              if (isMissed)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: theme.redMid.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: theme.redMid),
                  ),
                  child: Text(l10n.planSessionCardMissedBadge,
                      style: TextStyle(color: theme.redText, fontSize: 10, fontWeight: FontWeight.w600)),
                ),
              if (tipo.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(tipo, style: TextStyle(color: cfg.bgColor, fontSize: 11,
                    fontWeight: FontWeight.w600)),
              ],
            ]),
          ]),

          // ── Ejercicios ────────────────────────
          if (ejercicios.isNotEmpty) ...[
            const SizedBox(height: 8),
            Divider(color: theme.border, height: 1),
            const SizedBox(height: 8),
            ...ejercicios.take(4).map((e) {
              final ej     = (e is Map) ? e['ejercicio'] as Map<String, dynamic>? : null;
              final nombre = ej?['nombre'] as String? ?? '';
              if (nombre.isEmpty) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text('· $nombre',
                    style: TextStyle(color: theme.greyLight, fontSize: 12, height: 1.3)),
              );
            }),
            if (ejercicios.length > 4)
              Text('+ ${ejercicios.length - 4} más',
                  style: TextStyle(color: theme.grey, fontSize: 11)),
          ],

          // ── Botones hoy ───────────────────────
          if (isToday) ...[
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity, height: 44,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => WorkoutDetailScreen(entrenamiento: data))),
                icon: const Icon(Icons.play_arrow, size: 18),
                label: Text(l10n.planSessionCardStartBtn,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primary, foregroundColor: theme.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],

          // ── Botón Ajustar (solo si es hoy) ─────────────
          const SizedBox(height: 4),
          if (isToday)
            SizedBox(
              width: double.infinity,
              height: 40,
              child: OutlinedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => const WorkoutAdjustmentBottomSheet(),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.greyLight,
                  side: BorderSide(color: theme.border),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(l10n.planSessionCardAdjustBtn, style: TextStyle(fontSize: 13)),
              ),
            )
          // ── Botón Ver detalle (si NO es hoy) ─────────────
          else
            SizedBox(
              width: double.infinity,
              height: 40,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => WorkoutDetailScreen(entrenamiento: data)),
                ),
                icon: Icon(Icons.info_outline, size: 16),
                label: Text(l10n.planSessionCardDetailBtn, style: TextStyle(fontSize: 13)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.greyLight,
                  side: BorderSide(color: theme.border),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),

          // ── Semana futura ─────────────────────
          if (weekContext == _WeekContext.future) ...[
            const SizedBox(height: 8),
            Row(children: [
              Icon(Icons.lock_outline, color: theme.grey, size: 13),
              const SizedBox(width: 4),
              Text(l10n.planSessionCardLockDesc,
                  style: TextStyle(color: theme.grey, fontSize: 11)),
            ]),
          ],
        ]),
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
// REST DAY CARD
// ═══════════════════════════════════════════════════════════════
class _RestDayCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final String fecha;
  const _RestDayCard({required this.data, required this.fecha});

  bool _isToday(String f) {
    final d = DateTime.tryParse(f.split('T')[0]);
    if (d == null) return false;
    final now = DateTime.now();
    return d.year == now.year && d.month == now.month && d.day == now.day;
  }

  static const _tips = [
    (Icons.directions_walk_outlined, 'Caminata'),
    (Icons.self_improvement_outlined, 'Movilidad'),
    (Icons.water_drop_outlined,       'Hidratación'),
    (Icons.bedtime_outlined,          'Sueño'),
  ];
  static const _keys = ['caminata', 'movilidad', 'hidratacion', 'sueno'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>() ?? AppThemeExtension.dark;
    final l10n  = AppLocalizations.of(context);
    final isToday = _isToday(fecha);
    final cfg     = WorkoutTypes.fromTipo('Descanso');
    final mensaje = data['mensaje'] as String?
        ?? l10n.planActiveRestDefaultMsg;

    final recTitles = [
      l10n.planActiveRestTipWalk,
      l10n.planActiveRestTipMobility,
      l10n.planActiveRestTipHydration,
      l10n.planActiveRestTipSleep
    ];

    return Container(
      decoration: BoxDecoration(
        color: cfg.bgColor.withValues(alpha: isToday ? 0.18 : 0.10),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isToday ? theme.primary : cfg.bgColor.withValues(alpha: 0.6),
          width: isToday ? 1.5 : 1.2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          // ── Header ──────────────────────────────
          Row(children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: cfg.bgColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Center(
                  child: Text('😴', style: TextStyle(fontSize: 22))),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.planActiveRestLabel,
                    style: TextStyle(color: cfg.bgColor, fontSize: 11,
                        fontWeight: FontWeight.w800, letterSpacing: 0.8)),
                const SizedBox(height: 2),
                Text(fecha, style: TextStyle(
                    color: theme.grey, fontSize: 11)),
              ],
            )),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: cfg.bgColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: cfg.bgColor.withValues(alpha: 0.6)),
              ),
              child: Text(
                isToday ? l10n.planActiveRestToday : l10n.planActiveRestActive,
                style: TextStyle(
                    color: cfg.bgColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w600)),
            ),
          ]),
          const SizedBox(height: 12),

          // ── Mensaje ──────────────────────────────
          Text(mensaje,
              style: TextStyle(color: theme.greyLight,
                  fontSize: 13, height: 1.5)),
          const SizedBox(height: 14),
          Divider(color: cfg.bgColor.withValues(alpha: 0.2), height: 1),
          const SizedBox(height: 12),

          // ── Tips ─────────────────────────────────
          Text(l10n.planActiveRestRecs,
              style: TextStyle(color: cfg.bgColor, fontSize: 10,
                  fontWeight: FontWeight.w700, letterSpacing: 0.8)),
          const SizedBox(height: 10),
          ...List.generate(_tips.length, (i) {
            final val = data[_keys[i]] as String?;
            if (val == null || val.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(children: [
                Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(
                    color: cfg.bgColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: cfg.bgColor.withValues(alpha: 0.3)),
                  ),
                  child: Icon(_tips[i].$1, color: cfg.bgColor, size: 16),
                ),
                const SizedBox(width: 10),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(recTitles[i],
                        style: TextStyle(color: theme.white,
                            fontSize: 12, fontWeight: FontWeight.w600)),
                    Text(val, style: TextStyle(
                        color: theme.grey, fontSize: 11, height: 1.3)),
                  ],
                )),
              ]),
            );
          }),
        ]),
      ),
    );
  }
}