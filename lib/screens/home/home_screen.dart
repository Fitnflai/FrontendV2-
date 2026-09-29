import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fitnflaifrontendv2/services/weather_service.dart';
import 'package:provider/provider.dart';
import '../../services/cached_http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/app_theme_extension.dart';
import '../../config/workout_types.dart';
import '../../providers/notification_provider.dart';
import '../../providers/auth_provider.dart';

import 'package:fitnflaifrontendv2/providers/health_provider.dart';
import 'package:fitnflaifrontendv2/services/health/health_repository.dart';
import '../profile/connected_apps_screen.dart';
import 'daily_checkin_screen.dart';
import '../workout/widgets/workout_adjustment_bottom_sheet.dart';
import '../workout/workout_detail_screen.dart';
import '../../widgets/bottom_nav.dart';
import '../../widgets/shared_widgets.dart';
import '../../l10n/app_localizations.dart';
import '../../config/app_constants.dart';

class HomeScreen extends StatefulWidget {
  final bool fromOnboarding;
  const HomeScreen({super.key, this.fromOnboarding = false});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedDay  = DateTime.now();
  bool     _calExpanded  = false;

  Map<String, dynamic>? _entrenamientoHoy;
  final Map<String, Map<String, dynamic>> _planPorFecha = {};
  bool _deviceConnected = false;
  bool _checkinDone     = false;
  bool _hasFetched = false;
  bool _isLoading = false;
  String? _errorMessage;
  DateTime? _creationDate;


  // Clave para guardar la fecha del último checkin
  static const _checkinKey = 'last_checkin_date';
  static const _deviceConnectedKey = 'device_connected_state';

  @override
  void initState() {
    super.initState();
    _loadCheckinState();
    _loadDeviceConnectedState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final healthProvider = context.read<HealthProvider>();
      if (healthProvider.connectedProvider != HealthProviderType.none) {
        healthProvider.silentSyncToday();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final auth = Provider.of<AuthProvider>(context);
    if (auth.status == AuthStatus.authenticated && !_hasFetched) {
      _hasFetched = true;
      Future.microtask(() => _loadWeek(_selectedDay));
    }
  }

  Future<void> _loadCheckinState() async {
    final prefs     = await SharedPreferences.getInstance();
    final lastDate  = prefs.getString(_checkinKey) ?? '';
    final today     = _fmt(DateTime.now());
    if (mounted) setState(() => _checkinDone = lastDate == today);
  }

  Future<void> _loadDeviceConnectedState() async {
    final prefs = await SharedPreferences.getInstance();
    final isConnected = prefs.getBool(_deviceConnectedKey) ?? false;
    if (mounted && isConnected) {
      setState(() => _deviceConnected = true);
    }
  }

  Future<void> _markCheckinDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_checkinKey, _fmt(DateTime.now()));
    if (mounted) setState(() => _checkinDone = true);
  }

  Future<void> _loadWeek(DateTime day, {bool silent = false}) async {
    final token = context.read<AuthProvider>().token;
    if (token == null) {
      debugPrint('🛑 DIAGNÓSTICO: El token de autenticación es NULL. Cancelando carga.');
      return;
    }
    
    context.read<NotificationProvider>().initPushNotifications(token);
    context.read<NotificationProvider>().loadNotifications(token);
    
    if (mounted && !silent) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    CachedHttp.clearCache();

    // Default robusto: 90 días atrás para asegurar que traemos el plan activo entero
    // incluso si fallan los pasos intermedios.
    final robustFallback = DateTime.now().subtract(const Duration(days: 90));
    String startDateQuery = _fmt(robustFallback);
    _creationDate ??= robustFallback;

    debugPrint('🔍 DIAGNÓSTICO - INICIO DE CARGA: Día seleccionado: ${_fmt(day)}');
    debugPrint('🔍 DIAGNÓSTICO - PASO 1: Consultando /users/me...');

    try {
      final userRes = await CachedHttp.get(
        Uri.parse('${AppConstants.baseUrl}/users/me'),
        headers: {'Authorization': 'Bearer $token'},
      );

      debugPrint('🔍 DIAGNÓSTICO - PASO 1 RESPUESTA: Código ${userRes.statusCode}');
      if (userRes.statusCode == 200) {
        final userData = jsonDecode(userRes.body) as Map<String, dynamic>;
        debugPrint('🔍 DIAGNÓSTICO - PASO 1 BODY: ${userRes.body}');
        final rawCreatedAt = userData['created_at'] as String?;
        if (rawCreatedAt != null && rawCreatedAt.isNotEmpty) {
          startDateQuery = rawCreatedAt.split('T')[0].split(' ')[0];
          debugPrint('🔍 DIAGNÓSTICO - FECHA REGISTRO PARSEADA: $startDateQuery');
          final parsedDate = DateTime.tryParse(startDateQuery);
          if (parsedDate != null && mounted) {
            setState(() {
              _creationDate = parsedDate;
            });
          }
        } else {
          debugPrint('⚠️ DIAGNÓSTICO: "created_at" es nulo o vacío en /users/me. Usando fallback robusto: $startDateQuery');
        }
      } else {
        debugPrint('⚠️ DIAGNÓSTICO: Falló /users/me con código ${userRes.statusCode}. Usando fallback robusto: $startDateQuery');
      }
    } catch (e) {
      debugPrint('❌ DIAGNÓSTICO: Excepción en PASO 1: $e. Usando fallback robusto: $startDateQuery');
    }

    debugPrint('🔍 DIAGNÓSTICO - PASO 2: Consultando /entrenamientos/semana con start_date=$startDateQuery...');

    try {
      final planRes = await CachedHttp.get(
        Uri.parse('${AppConstants.baseUrl}/entrenamientos/semana?start_date=$startDateQuery'),
        headers: {'Authorization': 'Bearer $token'},
      );

      debugPrint('🔍 DIAGNÓSTICO - PASO 2 RESPUESTA: Código ${planRes.statusCode}');

      if (planRes.statusCode == 200) {
        final decoded = jsonDecode(planRes.body) as Map<String, dynamic>;
        final planRaw = decoded['plan'] as List<dynamic>? ?? [];
        debugPrint('🔍 DIAGNÓSTICO - CANTIDAD DE ELEMENTOS EN PLAN: ${planRaw.length}');

        if (mounted && !silent) { // Clear plan por fecha only if not silent
          _planPorFecha.clear();
        } else if (silent && mounted) {
          // If silent, only update _entrenamientoHoy, don't clear the whole map
          // This ensures existing plan stays on screen
        }

        for (final item in planRaw) {
          if (item is! Map) continue;
          final mapItem = Map<String, dynamic>.from(item);

          final rawFecha = mapItem['fecha_programada'] as String?;
          if (rawFecha != null && rawFecha.isNotEmpty) {
            // Súper robusto: divide tanto por 'T' como por espacio ' ' para limpiar la fecha
            final fechaKey = rawFecha.split('T')[0].split(' ')[0];
            mapItem['fecha_local'] = fechaKey;
            _planPorFecha[fechaKey] = mapItem;
          }
        }

        final targetDayKey = _fmt(day);
        final tieneEntrenamientoHoy = _planPorFecha.containsKey(targetDayKey);
        debugPrint('🔍 DIAGNÓSTICO - MAPA DE FECHAS EN MEMORIA: ${_planPorFecha.keys.toList()}');
        debugPrint('🔍 DIAGNÓSTICO - ¿HAY PLAN PARA HOY ($targetDayKey)?: $tieneEntrenamientoHoy');

        if (mounted) {
          setState(() {
            _entrenamientoHoy = _planPorFecha[targetDayKey];
            _isLoading = false;
          });
        }
      } else {
        debugPrint('❌ DIAGNÓSTICO: /entrenamientos/semana retornó código ${planRes.statusCode}');
        throw Exception('Servidor retornó código: ${planRes.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ DIAGNÓSTICO: Excepción en PASO 2: $e');
      if (mounted) {
        if (silent) {
          final themeColors = Theme.of(context).extension<AppThemeExtension>() ?? AppThemeExtension.dark;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("No se pudieron actualizar tus entrenamientos.", style: TextStyle(color: themeColors.white)),
              backgroundColor: themeColors.redMid,
              behavior: SnackBarBehavior.floating,
            ),
          );
          setState(() {
            _isLoading = false; // Only set loading to false
          });
        } else {
          setState(() {
            _errorMessage = 'No se pudieron cargar tus entrenamientos.';
            _isLoading = false;
          });
        }
      }
    }
  }

  String _fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2,'0')}-${d.day.toString().padLeft(2,'0')}';

  DateTime _weekMonday(DateTime d) => d.subtract(Duration(days: d.weekday - 1));

  void _fetchDay(DateTime day) {
    if (mounted) {
      setState(() {
        _selectedDay = day;
        _entrenamientoHoy = _planPorFecha[_fmt(day)];
      });
    }
  }

  Future<void> _loadMonthDots(DateTime d) async {
    // No se requiere llamada individual porque todo el plan ya está precargado en memoria.
  }

  Set<String> get _monthsWithData {
    final months = <String>{};
    _planPorFecha.forEach((fechaKey, workout) {
      final tipo = workout['tipo'] as String? ?? '';
      if (tipo != 'descanso_activo' && tipo != 'Descanso') {
        final titulo = workout['titulo_entrenamiento'] as String? ?? '';
        if (titulo.isNotEmpty) {
          if (fechaKey.length >= 7) {
            months.add(fechaKey.substring(0, 7));
          }
        }
      }
    });
    return months;
  }

  bool hasDot(DateTime d) {
    final key = _fmt(d);
    final workout = _planPorFecha[key];
    if (workout == null) return false;
    
    final tipo = workout['tipo'] as String? ?? '';
    if (tipo == 'descanso_activo' || tipo == 'Descanso') return false;
    
    final titulo = workout['titulo_entrenamiento'] as String? ?? '';
    return titulo.isNotEmpty;
  }

  List<Map<String, dynamic>> get _weekSessions {
    final monday = _weekMonday(_selectedDay);
    return List.generate(7, (i) {
      final day = monday.add(Duration(days: i));
      final key = _fmt(day);
      return _planPorFecha[key] ?? {
        'fecha_programada': key,
        'tipo': 'Descanso',
        'mensaje': 'Día libre'
      };
    });
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
        bottomNavigationBar: const AppBottomNav(selectedIndex: 0),
      );
    }

    // ── Datos hardcoded (se reemplazarán con API) ────────────────


    return Scaffold(
      backgroundColor: theme.bg,
      body: SafeArea(
        bottom: false,
        child: Column(children: [
          // ── Header estático ──────────────────────
          AppHeader(section: l10n.homeHeaderSection, showGreeting: true),
          _CalendarWidget(
            selectedDay:    _selectedDay,
            expanded:       _calExpanded,
            onToggle:       () => setState(() => _calExpanded = !_calExpanded),
            onDaySelect:    _fetchDay,
            hasDot:         hasDot,
            monthsWithData: _monthsWithData,
            onMonthChange:  _loadMonthDots,
            startMonth:     _creationDate,
          ),
          const SizedBox(height: 16),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ── Daily check banner — oculto si ya completó hoy ──
                  if (!_checkinDone) ...[
                    _DailyCheckBanner(onTap: () async {
                      final completed = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const DailyCheckinScreen()),
                      );
                      if (completed == true) {
                        await _markCheckinDone();
                        if (mounted) {
                          await Future.delayed(const Duration(seconds: 2));
                          if (mounted) {
                            await _loadWeek(_selectedDay, silent: true);
                          }
                        }
                      }
                    }),
                    const SizedBox(height: 14),
                  ],

                  // ── Device banner ────────────────
                  _deviceConnected
                      ? _DeviceConnectedBanner()
                      : _DeviceBanner(onTap: () async {
                          await Navigator.push(context, MaterialPageRoute(
                              builder: (_) => const ConnectedAppsScreen()));
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setBool(_deviceConnectedKey, true);
                          if (mounted) setState(() => _deviceConnected = true);
                        }),
                  const SizedBox(height: 14),

                  // ── Stats row — solo si hay dispositivo ──
                  if (_deviceConnected) ...[
                    const _StatsRow(),
                    const SizedBox(height: 14),
                  ],

                  // ── Today's session ─────────────
                  if (_isLoading)
                    const _LoadingSessionCard()
                  else if (_errorMessage != null)
                    _ErrorSessionCard(
                      message: _errorMessage!,
                      onRetry: () => _loadWeek(_selectedDay),
                    )
                  else
                    _TodaySession(
                      data: _entrenamientoHoy,
                      onAdjusted: () {
                        _loadWeek(_selectedDay, silent: true);
                      },
                    ),
                  // ── Tip del día (moved) ─────────────────
                  Builder(builder: (context) {
                    final hasTip = _entrenamientoHoy?['tip_diario'] != null && (_entrenamientoHoy?['tip_diario'] as String).trim().isNotEmpty;
                    if (hasTip) {
                      return Column(
                        children: [
                          const SizedBox(height: 20),
                          _TipCard(tip: _entrenamientoHoy?['tip_diario'] as String?),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  }),


                  const SizedBox(height: 24),
                  // ── Distribución semanal ────────
                  _SectionLabel(l10n.homeSectionWeeklyDist),
                  const SizedBox(height: 12),
                  _WeeklyGrid(
                    weekSessions: _weekSessions,
                    todayIdx:    DateTime.now().weekday - 1,
                    selectedIdx: _selectedDay.weekday - 1,
                  ),
                  const SizedBox(height: 12),

                  // ── Coach comment ──────────
                  Builder(
                    builder: (context) {
                      final coachComment = _entrenamientoHoy?['comentario'] as String? ?? _entrenamientoHoy?['mensaje'] as String? ?? '';
                      if (coachComment.trim().isNotEmpty) {
                        return Column(
                          children: [
                            const SizedBox(height: 20),
                            CoachCommentCard(
                              comentario: coachComment.trim(),
                              tipo: _entrenamientoHoy?['tipo'] as String? ?? '',
                              isElite: context.watch<AuthProvider>().user?.isElite == true,
                            ),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const SizedBox(height: 20),



                  // ── Intensity bar chart ─────────
                  _SectionLabel(l10n.homeSectionWeeklyIntensity),
                  const SizedBox(height: 12),
                  _IntensityChart(
                    weekSessions: _weekSessions,
                    todayIdx:    DateTime.now().weekday - 1,
                    selectedIdx: _selectedDay.weekday - 1,
                  ),
                  const SizedBox(height: 20),

                  // ── Adherencia semanal ──────────
                  _AdherenciaCard(sessions: _weekSessions),
                  const SizedBox(height: 20),




                ],
              ),
            ),
          ),

          // ── Bottom nav ───────────────────────────
          const AppBottomNav(selectedIndex: 0),
        ]),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// DEVICE BANNER — no conectado
// ═══════════════════════════════════════════════════════════════
class _DeviceBanner extends StatelessWidget {
  final VoidCallback onTap;
  const _DeviceBanner({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>() ?? AppThemeExtension.dark;
    final l10n  = AppLocalizations.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: theme.cardDark,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: theme.border),
        ),
        child: Row(children: [
          Container(
            width: 48, height: 48,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.primary.withValues(alpha: 0.15),
              Colors.purple.withValues(alpha: 0.08),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: theme.primary.withValues(alpha: 0.4),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.primary.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
            child: const Center(child: Text('🕐', style: TextStyle(fontSize: 26))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(l10n.homeConnectDevicesTitle,
                  style: TextStyle(
                      color: theme.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(
                l10n.homeConnectDevicesDesc,
                style: TextStyle(color: theme.grey, fontSize: 11, height: 1.4),
              ),
            ]),
          ),
          const SizedBox(width: 8),
          Icon(Icons.chevron_right, color: theme.grey, size: 20),
        ]),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// DEVICE BANNER — conectado
// ═══════════════════════════════════════════════════════════════
class _DeviceConnectedBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>() ?? AppThemeExtension.dark;
    final l10n  = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.greenBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.greenMid),
      ),
      child: Row(children: [
        Container(
          width: 48, height: 48,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.primary.withValues(alpha: 0.15),
              Colors.purple.withValues(alpha: 0.08),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: theme.primary.withValues(alpha: 0.4),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.primary.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
          child: const Center(child: Text('🕐', style: TextStyle(fontSize: 26))),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(l10n.homeDeviceConnectedTitle,
                style: TextStyle(
                    color: theme.greenText,
                    fontSize: 14,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(l10n.homeDeviceConnectedDesc,
                style: TextStyle(color: theme.grey, fontSize: 11, height: 1.4)),
          ]),
        ),
        Icon(Icons.check_circle, color: theme.greenText, size: 22),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// CALENDARIO DESPLEGABLE
// ═══════════════════════════════════════════════════════════════
class _CalendarWidget extends StatelessWidget {
  final DateTime selectedDay;
  final bool expanded;
  final VoidCallback onToggle;
  final ValueChanged<DateTime> onDaySelect;
  final bool Function(DateTime) hasDot;
  final Set<String> monthsWithData;
  final void Function(DateTime)? onMonthChange;
  final DateTime? startMonth;

  const _CalendarWidget({
    required this.selectedDay,
    required this.expanded,
    required this.onToggle,
    required this.onDaySelect,
    required this.hasDot,
    required this.monthsWithData,
    this.onMonthChange,
    this.startMonth,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>() ?? AppThemeExtension.dark;
    final l10n  = AppLocalizations.of(context);
    final now = DateTime.now();

    final isEs = Localizations.localeOf(context).languageCode == 'es';
    final dias = isEs
        ? const ['LUN','MAR','MIÉ','JUE','VIE','SÁB','DOM']
        : const ['MON','TUE','WED','THU','FRI','SAT','SUN'];
    final meses = isEs
        ? const ['Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre']
        : const ['January','February','March','April','May','June','July','August','September','October','November','December'];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Column(children: [
        // ── Header: toggle ──────────────────
        GestureDetector(
          onTap: onToggle,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(children: [
              // Muestra el mes actual siempre en el header
              Text(
                '${meses[now.month - 1]} ${now.year}',
                style: TextStyle(
                    color: theme.white, fontSize: 14,
                    fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              // Chip día seleccionado
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
              color: theme.primary.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _isToday(selectedDay, now)
                       ? l10n.homeCalendarToday
                      : '${dias[(selectedDay.weekday - 1) % 7]} ${selectedDay.day}',
                  style: TextStyle(
                      color: theme.primary, fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(width: 8),
              AnimatedRotation(
                turns: expanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 200),
                child: Icon(Icons.keyboard_arrow_down,
                    color: theme.grey, size: 20),
              ),
            ]),
          ),
        ),

        // ── Fila de la semana actual (solo si no está expandido) ──
        if (!expanded)
          _WeekRow(
            weekStart: _weekStart(now), // siempre semana de HOY
            selectedDay: selectedDay,
            now: now,
            onDaySelect: onDaySelect,
            hasDot: hasDot,
          ),

        // ── Meses expandidos ──────────────────
        if (expanded) ...[
          Divider(color: theme.border, height: 1),
          _MultiMonthGrid(
            startMonth:     startMonth ?? DateTime(now.year, now.month),
            selectedDay:    selectedDay,
            now:            now,
            onDaySelect:    onDaySelect,
            hasDot:         hasDot,
            monthsWithData: monthsWithData,
            onMonthChange:  onMonthChange,
          ),
        ],
      ]),
    );
  }

  bool _isToday(DateTime d, DateTime now) =>
      d.year == now.year && d.month == now.month && d.day == now.day;

  DateTime _weekStart(DateTime d) {
    return d.subtract(Duration(days: d.weekday - 1));
  }
}

// ── Fila de días de la semana ──────────────────────────────────
class _WeekRow extends StatelessWidget {
  final DateTime weekStart, selectedDay, now;
  final ValueChanged<DateTime> onDaySelect;
  final bool Function(DateTime) hasDot;
  const _WeekRow({required this.weekStart, required this.selectedDay,
      required this.now, required this.onDaySelect, required this.hasDot});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>() ?? AppThemeExtension.dark;
    final isEs = Localizations.localeOf(context).languageCode == 'es';
    final labels = isEs
        ? const ['LUN','MAR','MIÉ','JUE','VIE','SÁB','DOM']
        : const ['MON','TUE','WED','THU','FRI','SAT','SUN'];

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 10),
      child: Column(children: [
        // Headers
        Row(children: List.generate(7, (i) => Expanded(
          child: Center(child: Text(labels[i],
              style: TextStyle(color: theme.grey,
                  fontSize: 10, fontWeight: FontWeight.w600))),
        ))),
        const SizedBox(height: 6),
        // Days
        Row(children: List.generate(7, (i) {
          final day = weekStart.add(Duration(days: i));
          return Expanded(child: _DayCell(
            day: day, selectedDay: selectedDay, now: now,
            showDot: hasDot(day),
            onTap: () => onDaySelect(day),
          ));
        })),
      ]),
    );
  }
}

// ── Grid multi-mes con navegación lateral ──────────────────────
class _MultiMonthGrid extends StatefulWidget {
  final DateTime startMonth, selectedDay, now;
  final ValueChanged<DateTime> onDaySelect;
  final bool Function(DateTime) hasDot;
  final Set<String> monthsWithData;
  final void Function(DateTime)? onMonthChange;

  const _MultiMonthGrid({
    required this.startMonth, required this.selectedDay,
    required this.now, required this.onDaySelect,
    required this.hasDot, required this.monthsWithData,
    this.onMonthChange,
  });

  @override
  State<_MultiMonthGrid> createState() => _MultiMonthGridState();
}

class _MultiMonthGridState extends State<_MultiMonthGrid> {
  late DateTime _viewMonth;

  @override
  void initState() {
    super.initState();
    final targetMonth = DateTime(widget.selectedDay.year, widget.selectedDay.month);
    _viewMonth = targetMonth.isBefore(widget.startMonth)
        ? DateTime(widget.startMonth.year, widget.startMonth.month)
        : targetMonth;
  }

  // Permitir navegar hacia atrás únicamente hasta el mes de registro del usuario (startMonth)
  DateTime get _minMonth =>
      DateTime(widget.startMonth.year, widget.startMonth.month);

  // Permitir navegar hasta 12 meses hacia adelante
  DateTime get _maxMonth =>
      DateTime(widget.now.year, widget.now.month + 12);

  bool get _canGoPrev =>
      _viewMonth.isAfter(_minMonth);

  bool get _canGoNext =>
      _viewMonth.isBefore(_maxMonth);

  void _prevMonth() {
    if (!_canGoPrev) return;
    final prev = DateTime(_viewMonth.year, _viewMonth.month - 1);
    setState(() => _viewMonth = prev);
    widget.onMonthChange?.call(prev);
  }

  void _nextMonth() {
    if (!_canGoNext) return;
    final next = DateTime(_viewMonth.year, _viewMonth.month + 1);
    setState(() => _viewMonth = next);
    widget.onMonthChange?.call(next);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>() ?? AppThemeExtension.dark;
    final firstDay    = _viewMonth;
    final startOffset = (firstDay.weekday - 1) % 7;
    final gridStart   = firstDay.subtract(Duration(days: startOffset));
    final days        = List.generate(42, (i) => gridStart.add(Duration(days: i)));

    final isEs = Localizations.localeOf(context).languageCode == 'es';
    final labels = isEs
        ? const ['LUN','MAR','MIÉ','JUE','VIE','SÁB','DOM']
        : const ['MON','TUE','WED','THU','FRI','SAT','SUN'];
    final meses = isEs
        ? const ['Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre']
        : const ['January','February','March','April','May','June','July','August','September','October','November','December'];

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
      child: Column(children: [

        // ── Navegación de mes ──────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Row(children: [
            GestureDetector(
              onTap: _canGoPrev ? _prevMonth : null,
              child: Icon(Icons.chevron_left,
                  color: _canGoPrev ? theme.greyLight : theme.border,
                  size: 22),
            ),
            Expanded(
              child: Text(
                '${meses[_viewMonth.month - 1]} ${_viewMonth.year}',
                textAlign: TextAlign.center,
                style: TextStyle(color: theme.white,
                    fontSize: 13, fontWeight: FontWeight.w700),
              ),
            ),
            GestureDetector(
              onTap: _canGoNext ? _nextMonth : null,
              child: Icon(Icons.chevron_right,
                  color: _canGoNext ? theme.greyLight : theme.border,
                  size: 22),
            ),
          ]),
        ),
        const SizedBox(height: 6),

        // ── Headers días ───────────────────────────
        Row(children: labels.map((l) => Expanded(
          child: Center(child: Text(l, style: TextStyle(
              color: theme.grey, fontSize: 10,
              fontWeight: FontWeight.w600))),
        )).toList()),
        const SizedBox(height: 6),

        // ── Semanas ────────────────────────────────
        ...List.generate(6, (week) {
          final weekDays = List.generate(7, (d) => days[week * 7 + d]);
          final anyInMonth = weekDays.any((d) => d.month == _viewMonth.month);
          if (!anyInMonth) return const SizedBox.shrink();
          return Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Row(children: weekDays.map((day) {
              final inMonth = day.month == _viewMonth.month;
              return Expanded(child: Opacity(
                opacity: inMonth ? 1.0 : 0.25,
                child: _DayCell(
                  day: day, selectedDay: widget.selectedDay, now: widget.now,
                  showDot: inMonth ? widget.hasDot(day) : false,
                  onTap: inMonth ? () => widget.onDaySelect(day) : null,
                ),
              ));
            }).toList()),
          );
        }),
      ]),
    );
  }
}

// ── Celda de día ───────────────────────────────────────────────
class _DayCell extends StatelessWidget {
  final DateTime day, selectedDay, now;
  final VoidCallback? onTap;
  final bool showDot;
  const _DayCell({required this.day, required this.selectedDay,
      required this.now, required this.showDot, this.onTap});

  bool get _isSelected => day.year == selectedDay.year &&
      day.month == selectedDay.month && day.day == selectedDay.day;
  bool get _isToday => day.year == now.year &&
      day.month == now.month && day.day == now.day;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>() ?? AppThemeExtension.dark;
    return GestureDetector(
      onTap: onTap,
      child: Column(children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 32, height: 32,
          decoration: BoxDecoration(
            color: _isSelected
                ? theme.white
                : _isToday
                    ? theme.primary
                    : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Center(child: Text('${day.day}',
              style: TextStyle(
                  color: _isSelected
                      ? theme.bg
                      : _isToday
                          ? theme.white
                          : theme.greyLight,
                  fontSize: 13,
                  fontWeight: (_isSelected || _isToday)
                      ? FontWeight.w700 : FontWeight.w400))),
        ),
        const SizedBox(height: 2),
        // Dot indicador (entrenamiento programado)
        Container(
          width: 5, height: 5,
          decoration: BoxDecoration(
            color: showDot ? theme.greenText : Colors.transparent,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 2),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// STATS ROW — con clima real de Open-Meteo
// ═══════════════════════════════════════════════════════════════
class _StatsRow extends StatefulWidget {
  const _StatsRow();
  @override
  State<_StatsRow> createState() => _StatsRowState();
}

class _StatsRowState extends State<_StatsRow> {
  final WeatherService _weatherService = WeatherService();
  String _temp     = '--';
  String _condIcon = '⛅';
  String _condText = '--';

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    final userCiudad = context.read<AuthProvider>().user?.ciudad;
    final weatherData = await _weatherService.fetchWeather(profileCity: userCiudad);

    if (weatherData != null && mounted) {
      setState(() {
        _temp     = '${weatherData.temp}°C';
        _condIcon = _mapIconTextToEmoji(weatherData.icon); // Map string icon to emoji
        _condText = weatherData.text;
      });
    }
  }

  String _mapIconTextToEmoji(String iconText) {
    // This mapping should ideally be more robust and perhaps externalized
    // For now, simple mapping based on previous logic and new icon names
    switch (iconText.toLowerCase()) {
      case 'wb_sunny': return '☀️';
      case 'foggy': return '🌫️';
      case 'rainy': return '🌧️';
      case 'ac_unit': return '🌨️';
      case 'thunderstorm': return '⛈️';
      case 'snowing': return '🌨️';
      case 'cloud': return '☁️'; // Default from weather_service
      default: return '⛅'; // Default or unknown
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final healthProvider = context.watch<HealthProvider>();

    final isEs = Localizations.localeOf(context).languageCode == 'es';
    final stepsLabel = isEs ? 'Pasos\nhoy' : 'Steps\ntoday';
    final caloriesLabel = isEs ? 'Calorías\nhoy' : 'Calories\ntoday';
    final distanceLabel = isEs ? 'Distancia\nhoy' : 'Distance\ntoday';

    final stats = [
      ('👟', '${healthProvider.steps}', stepsLabel),
      ('🔥', '${healthProvider.calories.toStringAsFixed(0)} kcal', caloriesLabel),
      ('🏃', '${healthProvider.distance.toStringAsFixed(1)} km', distanceLabel),
      ('🌡️', _temp,  l10n.homeTemperatureLabel),
      (_condIcon, _condText, l10n.homeWeatherLabel),
    ];

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: stats.asMap().entries.map((e) {
          final isLast = e.key == stats.length - 1;
          final s = e.value;
          return Expanded(child: Padding(
            padding: EdgeInsets.only(right: isLast ? 0 : 6),
            child: _StatCard(icon: s.$1, value: s.$2, label: s.$3),
          ));
        }).toList(),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String icon, value, label;
  const _StatCard({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>() ?? AppThemeExtension.dark;
    return IntrinsicHeight(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        decoration: BoxDecoration(
          color: theme.card,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 3),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(value,
                  style: TextStyle(
                      color: theme.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700)),
            ),
            const SizedBox(height: 2),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(
                      color: theme.grey, fontSize: 9, height: 1.3)),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// DAILY CHECK BANNER
// ═══════════════════════════════════════════════════════════════
class _DailyCheckBanner extends StatelessWidget {
  final VoidCallback? onTap;
  const _DailyCheckBanner({this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>() ?? AppThemeExtension.dark;
    final l10n  = AppLocalizations.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.primary.withValues(alpha: 0.30),
              Colors.purple.withValues(alpha: 0.18),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: theme.primary.withValues(alpha: 0.65),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.primary.withValues(alpha: 0.12),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(children: [
          const Text('👋', style: TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(l10n.homeDailyCheckinTitle,
                  style: TextStyle(
                      color: theme.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 3),
              Text(
                l10n.homeDailyCheckinDesc,
                style: TextStyle(
                    color: theme.grey, fontSize: 12, height: 1.4),
              ),
            ]),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.primary.withValues(alpha: 0.15),
            ),
            child: Icon(Icons.chevron_right, color: theme.primary, size: 20),
          ),
        ]),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// TODAY'S SESSION
// ═══════════════════════════════════════════════════════════════

class _TodaySession extends StatelessWidget {
  final Map<String, dynamic>? data;
  final VoidCallback? onAdjusted;
  const _TodaySession({this.data, this.onAdjusted});

  bool _isToday(String fechaStr) {
    if (fechaStr.isEmpty) return false;
    try {
      final d   = DateTime.parse(fechaStr.split('T')[0]);
      final now = DateTime.now();
      return d.year == now.year && d.month == now.month && d.day == now.day;
    } catch (_) { return false; }
  }

  bool _isPast(String fechaStr) {
    if (fechaStr.isEmpty) return false;
    try {
      final d   = DateTime.parse(fechaStr.split('T')[0]);
      final now = DateTime.now();
      return d.isBefore(DateTime(now.year, now.month, now.day));
    } catch (_) { return false; }
  }

  Color _estadoColor(String estado, AppThemeExtension theme) {
    final e = estado.toLowerCase();
    if (e == 'completado' || e == 'completo' || e == 'done') return theme.greenText;
    if (e == 'pendiente' || e == 'pending') return theme.redText;
    if (e == 'en_progreso' || e == 'en progreso') return theme.primary;
    return theme.grey;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>() ?? AppThemeExtension.dark;
    final l10n  = AppLocalizations.of(context);
    // Sin entrenamiento → tarjeta de descanso
    final titulo     = data?['titulo_entrenamiento'] as String? ?? '';
    final ejercicios = data?['ejercicios_asociados'] as List<dynamic>? ?? [];

    if (data == null || titulo.isEmpty) return _NoWorkoutCard();

    final fecha  = data?['fecha_programada'] as String? ?? '';
    final tipo   = data?['tipo'] as String? ?? '';
    final estado = data?['estado'] as String? ?? '';
    final isCompletado = estado.toLowerCase() == 'completado' ||
        estado.toLowerCase() == 'completo' ||
        estado.toLowerCase() == 'done';
    final cfg    = WorkoutTypes.fromTipo(tipo);

    // Día de descanso → misma tarjeta que "sin entrenamiento"
    if (cfg.tipo == 'Descanso') return _RestDayCard();

    final isMissed = _isPast(fecha) &&
        estado.toLowerCase() != 'completado' &&
        estado.toLowerCase() != 'completo' &&
        estado.toLowerCase() != 'done';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isMissed
            ? theme.redMid.withValues(alpha: 0.1)
            : cfg.bgColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isMissed ? theme.redMid : cfg.bgColor.withValues(alpha: 0.6),
          width: isMissed ? 1.2 : 1,
        ),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Emoji + tipo + fecha + Etiqueta de estado arriba a la derecha
        Row(children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: cfg.bgColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(child: Text(cfg.emoji,
                style: const TextStyle(fontSize: 22))),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (tipo.isNotEmpty)
              Text(tipo.toUpperCase(), style: TextStyle(
                  color: cfg.bgColor, fontSize: 10,
                  fontWeight: FontWeight.w700, letterSpacing: 0.8)),
            if (fecha.isNotEmpty)
              Text(fecha, style: TextStyle(
                  color: theme.grey, fontSize: 11)),
          ])),
          const SizedBox(width: 8),
          if (isMissed)
            _Tag(l10n.homeSessionMissed, theme.redText,
                bg: theme.redMid.withValues(alpha: 0.1))
          else if (estado.isNotEmpty && cfg.tipo != 'Descanso')
            _Tag(estado, _estadoColor(estado, theme),
                bg: _estadoColor(estado, theme).withValues(alpha: 0.15)),
        ]),
        const SizedBox(height: 10),

        // Título
        Text(titulo,
            style: TextStyle(
                color: theme.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
                height: 1.2)),
        const SizedBox(height: 6),

        // Ejercicios asociados — solo nombre del ejercicio
        if (ejercicios.isNotEmpty) ...[
          Divider(color: cfg.bgColor.withValues(alpha: 0.2), height: 16),
          ...ejercicios.take(6).map((e) {
            if (e is! Map) return const SizedBox.shrink();
            final ej = e['ejercicio'] as Map<String, dynamic>?;
            final nombre = ej?['nombre'] as String? ?? '';
            if (nombre.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text('· $nombre',
                  style: TextStyle(
                      color: theme.greyLight,
                      fontSize: 13,
                      height: 1.4)),
            );
          }),
          if (ejercicios.length > 6)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text('+ ${ejercicios.length - 6} más...',
                  style: TextStyle(
                      color: theme.grey, fontSize: 12)),
            ),
          const SizedBox(height: 10),
        ],

        // Badges: tipo (disciplina) abajo para equilibrio visual
        if (tipo.isNotEmpty && !isMissed) ...[
          Row(children: [
            _Tag(tipo, cfg.bgColor,
                bg: cfg.bgColor.withValues(alpha: 0.15)),
          ]),
          const SizedBox(height: 14),
        ] else ...[
          const SizedBox(height: 14),
        ],

        // Botón Ver detalle — cuando NO es hoy o cuando YA está completado
        if (!_isToday(fecha) || isCompletado)
        SizedBox(
          width: double.infinity,
          height: 44,
          child: OutlinedButton.icon(
            onPressed: data != null ? () => Navigator.push(context,
                MaterialPageRoute(builder: (_) =>
                    WorkoutDetailScreen(entrenamiento: data))) : null,
            icon: Icon(Icons.info_outline, size: 16),
            label: Text(l10n.homeWorkoutDetailButton,
                style: TextStyle(fontSize: 14)),
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.greyLight,
              side: BorderSide(color: theme.border),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),

        // Botones solo si es hoy, NO está completado y NO es un día de descanso
        if (_isToday(fecha) && !isCompletado && cfg.tipo != 'Descanso') ...[
          const SizedBox(height: 8),
          // Botón Iniciar → va al detalle
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: data != null ? () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) =>
                      WorkoutDetailScreen(entrenamiento: data))) : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primary,
                disabledBackgroundColor: theme.cardDark,
                foregroundColor: theme.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
              child: Text(l10n.homeWorkoutStartButton,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 8),

          // Botón Ajustar
          SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton(
              onPressed: () async {
                final id = data?['id_entrenamiento'] ?? data?['id'];
                if (id == null) return;
                final result = await showModalBottomSheet<bool>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => WorkoutAdjustmentBottomSheet(workoutId: id),
                );
                if (result == true) {
                  onAdjusted?.call();
                }
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.greyLight,
                side: BorderSide(color: theme.border),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(l10n.homeWorkoutAdjustButton,
                  style: TextStyle(fontSize: 14)),
            ),
          ),
        ],
      ]),
);
  }
}


// ════════════════════════════════════════════════════════════════
// NO WORKOUT CARD — Sin entrenamiento programado hoy
// ════════════════════════════════════════════════════════════════
class _NoWorkoutCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>() ?? AppThemeExtension.dark;
    final l10n  = AppLocalizations.of(context);
    final user   = context.read<AuthProvider>().user;
    final nombre = user?.apodo
                ?? (user?.nombre != null ? user!.nombre.split(' ').first : null)
                ?? 'Campeón';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.border),
      ),
      child: Column(children: [
        // Ícono
        Container(
          width: 72, height: 72,
          decoration: BoxDecoration(
            color: theme.bg,
            shape: BoxShape.circle,
            border: Border.all(
                color: theme.grey.withValues(alpha: 0.3),
                width: 2),
          ),
          child: const Center(
            child: Text('📭', style: TextStyle(fontSize: 32)),
          ),
        ),
        const SizedBox(height: 16),

        // Título
        Text(l10n.homeNoWorkoutTitle(nombre),
            textAlign: TextAlign.center,
            style: TextStyle(
                color: theme.white,
                fontSize: 22,
                fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        Text(
          l10n.homeNoWorkoutDesc,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: theme.grey, fontSize: 13, height: 1.5),
        ),
        const SizedBox(height: 20),
      ]),
    );
  }
}


// ════════════════════════════════════════════════════════════════
// REST DAY CARD — Día de descanso programado
// ════════════════════════════════════════════════════════════════
class _RestDayCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>() ?? AppThemeExtension.dark;
    final l10n  = AppLocalizations.of(context);
    final user   = context.read<AuthProvider>().user;
    final nombre = user?.apodo
                ?? (user?.nombre != null ? user!.nombre.split(' ').first : null)
                ?? 'Campeón';

    final tips = [
      ('🚶', l10n.homeRestTipWalkTitle, l10n.homeRestTipWalkDesc),
      ('🧘', l10n.homeRestTipMobilityTitle, l10n.homeRestTipMobilityDesc),
      ('💧', l10n.homeRestTipHydrationTitle, l10n.homeRestTipHydrationDesc),
      ('😴', l10n.homeRestTipSleepTitle, l10n.homeRestTipSleepDesc),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.border),
      ),
      child: Column(children: [
        // Ícono
        Container(
          width: 72, height: 72,
          decoration: BoxDecoration(
            color: theme.bg,
            shape: BoxShape.circle,
            border: Border.all(
                color: theme.primary.withValues(alpha: 0.5),
                width: 2),
          ),
          child: const Center(
            child: Text('😴', style: TextStyle(fontSize: 32)),
          ),
        ),
        const SizedBox(height: 16),

        // Título
        Text(l10n.homeRestDayTitle(nombre),
            textAlign: TextAlign.center,
            style: TextStyle(
                color: theme.white,
                fontSize: 22,
                fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        Text(
          l10n.homeRestDayDesc,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: theme.grey, fontSize: 13, height: 1.5),
        ),
        const SizedBox(height: 20),
        Divider(color: theme.border),
        const SizedBox(height: 12),

        // Tips de descanso activo
        Align(
          alignment: Alignment.centerLeft,
          child: Text(l10n.homeRestDayActiveSection,
              style: TextStyle(
                  color: theme.grey,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8)),
        ),
        const SizedBox(height: 10),
        ...tips.map((t) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(children: [
            Container(
              width: 38, height: 38,
              decoration: BoxDecoration(
                color: theme.cardDark,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                  child: Text(t.$1,
                      style: const TextStyle(fontSize: 18))),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.$2, style: TextStyle(
                    color: theme.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600)),
                Text(t.$3, style: TextStyle(
                    color: theme.grey,
                    fontSize: 11)),
              ],
            )),
          ]),
        )),
      ]),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color color;
  final Color? bg;
  const _Tag(this.label, this.color, {this.bg});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: bg ?? color.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: color.withValues(alpha: 0.5)),
    ),
    child: Text(label,
        style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.w600)),
  );
}

// ═══════════════════════════════════════════════════════════════
// SECTION LABEL
// ═══════════════════════════════════════════════════════════════
class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>() ?? AppThemeExtension.dark;
    return Text(text,
        style: TextStyle(color: theme.primary, fontSize: 13,
            fontWeight: FontWeight.w800, letterSpacing: 0.8));
  }
}

// ═══════════════════════════════════════════════════════════════
// WEEKLY GRID — usa datos reales del plan + WorkoutTypes
// ═══════════════════════════════════════════════════════════════
class _WeeklyGrid extends StatelessWidget {
  final List<Map<String, dynamic>> weekSessions;
  final int todayIdx, selectedIdx;
  const _WeeklyGrid({required this.weekSessions, required this.todayIdx, required this.selectedIdx});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>() ?? AppThemeExtension.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (i) {
        final session = weekSessions.firstWhere(
          (s) {
             final dateStr = s['fecha_programada'] as String?;
             if (dateStr == null) return false;
             final d = DateTime.parse(dateStr.split('T')[0]);
             return d.weekday == i + 1;
          },
          orElse: () => {},
        );
        final isSelected = i == selectedIdx;
        final isToday = i == todayIdx;
        final tipo = session['tipo']?.toString() ?? '';
        final cfg = WorkoutTypes.fromTipo(tipo);
        
        return Column(
          children: [
            Text(
              ['L','M','X','J','V','S','D'][i],
              style: TextStyle(
                color: isToday ? theme.white : theme.grey,
                fontSize: 10,
                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: session.isNotEmpty ? (isSelected ? cfg.bgColor : cfg.bgColor.withValues(alpha: 0.2)) : theme.cardDark,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: isToday ? theme.primary : theme.border, width: isToday ? 2 : 1),
              ),
              child: Center(
                child: Text(
                  session.isNotEmpty ? cfg.emoji : '-',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              session.isNotEmpty ? (session['tipo_corto'] ?? cfg.shortLabel ?? '') : '',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.greyLight,
                fontSize: 9,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        );
      }),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// INTENSITY CHART
// ═══════════════════════════════════════════════════════════════
class _IntensityChart extends StatelessWidget {
  final List<Map<String, dynamic>> weekSessions;
  final int todayIdx, selectedIdx;
  const _IntensityChart({required this.weekSessions, required this.todayIdx, required this.selectedIdx});
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>() ?? AppThemeExtension.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: theme.card, borderRadius: BorderRadius.circular(14)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(7, (i) {
          final session = weekSessions.firstWhere(
            (s) {
              final dateStr = s['fecha_programada'] as String?;
              if (dateStr == null) return false;
              final d = DateTime.parse(dateStr.split('T')[0]);
              return d.weekday == i + 1;
            },
            orElse: () => {'intensidad': 0},
          );
          // Mapeo de zona de esfuerzo de string a número
          int getZonaInt(dynamic zona) {
            final s = zona.toString().toLowerCase();
            if (s.contains('5')) return 5;
            if (s.contains('4')) return 4;
            if (s.contains('3')) return 3;
            if (s.contains('2')) return 2;
            if (s.contains('1')) return 1;
            return 0;
          }

          final intensity = (session.isNotEmpty && session['zona_esfuerzo'] != null)
              ? getZonaInt(session['zona_esfuerzo']).toDouble()
              : 0.0;
          
          final tipo = (session.isNotEmpty) ? session['tipo']?.toString() ?? '' : '';
          final cfg = WorkoutTypes.fromTipo(tipo);

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    session.isNotEmpty && session['zona_esfuerzo'] != null 
                        ? 'Z${getZonaInt(session['zona_esfuerzo'])}' 
                        : '',
                    style: TextStyle(color: theme.grey, fontSize: 9, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    height: intensity > 0 ? (intensity * 20.0) : 10,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: session.isNotEmpty ? cfg.bgColor : theme.cardDark,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(['L','M','X','J','V','S','D'][i], style: TextStyle(color: theme.grey, fontSize: 10)),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// ADHERENCIA CARD
// ═══════════════════════════════════════════════════════════════
class _AdherenciaCard extends StatelessWidget {
  final List<Map<String, dynamic>> sessions;
  const _AdherenciaCard({required this.sessions});
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>() ?? AppThemeExtension.dark;
    final l10n  = AppLocalizations.of(context);
    // Filtrar solo las sesiones que NO son de descanso
    final workoutSessions = sessions.where((s) {
      final tipo = (s['tipo'] as String?)?.toLowerCase() ?? '';
      return tipo != 'descanso' && tipo != 'descanso_activo';
    }).toList();
    final total = workoutSessions.length;
    final completed = workoutSessions.where((s) {
      final estado = (s['estado'] as String?)?.toLowerCase() ?? '';
      return estado == 'completado' || estado == 'done';
    }).length;
    
    final pct = total > 0 ? (completed / total * 100).toInt() : 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: theme.card, borderRadius: BorderRadius.circular(14)),
      child: Column(children: [
        Row(children: [
          Icon(Icons.analytics, color: theme.primary, size: 20),
          const SizedBox(width: 8),
          Text(l10n.homeSectionWeeklyAdherence, style: TextStyle(color: theme.white, fontWeight: FontWeight.bold, fontSize: 12)),
          const Spacer(),
          Text(l10n.homeAdherencePct(pct), style: TextStyle(color: theme.primary, fontWeight: FontWeight.bold, fontSize: 16)),
        ]),
        const SizedBox(height: 12),
        // Fila de puntos
        Align(
          alignment: Alignment.centerLeft,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(total, (i) {
              final session = workoutSessions[i];
              final estado = (session['estado'] as String?)?.toLowerCase() ?? '';
              final fechaStr = session['fecha_programada'] as String?;
              
              Color dotColor = theme.grey; // Default (neutro)
              if (estado == 'completado' || estado == 'done') {
                dotColor = theme.greenText;
              } else if (fechaStr != null) {
                final d = DateTime.parse(fechaStr.split('T')[0]);
                if (d.isBefore(DateTime.now())) {
                  dotColor = theme.redText; // Vencido y no completado
                }
              }

              return Container(
                width: 12, height: 12,
                decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
              );
            }),
          ),
        ),
        const SizedBox(height: 12),
        Text(l10n.homeSessionCompleted(completed, total), style: TextStyle(color: theme.grey, fontSize: 12)),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// TIP CARD
// ═══════════════════════════════════════════════════════════════
class _TipCard extends StatelessWidget {
  final String? tip;
  const _TipCard({this.tip});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>() ?? AppThemeExtension.dark;
    final l10n  = AppLocalizations.of(context);
    final hasTip = tip != null && tip!.trim().isNotEmpty;
    final displayText = hasTip ? tip!.trim() : l10n.homeTipOfTheDayDesc;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.yellow.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.yellow.withValues(alpha: 0.25)),
      ),
      child: Row(children: [
        const Text('💡', style: TextStyle(fontSize: 24)),
        const SizedBox(width: 12),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.homeTipOfTheDayTitle, style: TextStyle(color: theme.white, fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(
              displayText,
              style: TextStyle(color: theme.greyLight, fontSize: 13),
            ),
          ],
        )),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// LOADING SESSION CARD
// ═══════════════════════════════════════════════════════════════
class _LoadingSessionCard extends StatelessWidget {
  const _LoadingSessionCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>() ?? AppThemeExtension.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
      decoration: BoxDecoration(
        color: theme.cardDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 28,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(theme.primary),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Cargando entrenamiento...',
            style: TextStyle(color: theme.greyLight, fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// ERROR SESSION CARD
// ═══════════════════════════════════════════════════════════════
class _ErrorSessionCard extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorSessionCard({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>() ?? AppThemeExtension.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.redMid.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.redMid, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('⚠️', style: TextStyle(fontSize: 28)),
          const SizedBox(height: 12),
          Text(
            'Error de conexión',
            style: TextStyle(color: theme.white, fontSize: 16, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: theme.grey, fontSize: 13, height: 1.4),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('Reintentar', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primary,
                foregroundColor: theme.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}