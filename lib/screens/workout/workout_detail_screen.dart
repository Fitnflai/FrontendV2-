import 'package:flutter/material.dart';
import '../../services/cached_http.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import '../../config/app_theme_extension.dart';
import '../../widgets/shared_widgets.dart';
import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';
import 'workout_active_screen.dart';
import 'workout_feedback_screen.dart';
import '../../l10n/app_localizations.dart';

class WorkoutDetailScreen extends StatefulWidget {
  final Map<String, dynamic>? entrenamiento;
  const WorkoutDetailScreen({super.key, this.entrenamiento});

  @override
  State<WorkoutDetailScreen> createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  bool _localCompletado = false;
  bool get _completado {
    if (_localCompletado) return true;
    final estado = _data?['estado'] as String? ?? '';
    return estado == 'completado' || estado == 'completo' || estado == 'done' || (_data?['completado'] as bool? ?? false);
  }
  bool _saving     = false;
  bool _loadingDetail = false;
  Map<String, dynamic>? _fullData;

  Map<String, dynamic>? get _data => _fullData ?? widget.entrenamiento;

  @override
  void initState() {
    super.initState();
    // Si la descripción está vacía, cargar detalle completo del API
    final desc = widget.entrenamiento?['descripcion'] as String? ?? '';
    if (desc.isEmpty) _loadDetail();
  }

  Future<void> _loadDetail() async {
    final id = widget.entrenamiento?['id_entrenamiento']
            ?? widget.entrenamiento?['id'];
    if (id == null) return;
    setState(() => _loadingDetail = true);
    try {
      final token = context.read<AuthProvider>().token ?? '';

      // Consultamos el plan semanal para traer la sesión programada real con sus estados de progreso
      final robustFallback = DateTime.now().subtract(const Duration(days: 90));
      final startDateQuery = robustFallback.toIso8601String().split('T')[0];

      final res = await CachedHttp.get(
        Uri.parse('https://apifitnflai.com/entrenamientos/semana?start_date=$startDateQuery'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (res.statusCode == 200 && mounted) {
        final decoded = jsonDecode(res.body) as Map<String, dynamic>;
        final planRaw = decoded['plan'] as List<dynamic>? ?? [];

        Map<String, dynamic>? matchedTraining;
        for (final item in planRaw) {
          if (item is Map) {
            final mapItem = Map<String, dynamic>.from(item);
            final itemId = mapItem['id_entrenamiento'] ?? mapItem['id'];
            if (itemId?.toString() == id.toString()) {
              matchedTraining = mapItem;
              break;
            }
          }
        }

        if (matchedTraining != null) {
          debugPrint('🎯 REFRESH SUCCESS: Found matching scheduled training with progress!');
          setState(() {
            _fullData = matchedTraining;
          });
          return;
        }
      }

      // Fallback: Si no se encuentra en el plan semanal, llamamos al endpoint de detalle estático
      debugPrint('⚠️ REFRESH FALLBACK: Training not found in weekly plan. Fetching static template.');
      final detailRes = await CachedHttp.get(
        Uri.parse('https://apifitnflai.com/entrenamientos/$id'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (detailRes.statusCode == 200 && mounted) {
        final body = jsonDecode(detailRes.body) as Map<String, dynamic>;
        setState(() => _fullData = body);
      }
    } catch (e) {
      debugPrint('DETAIL LOAD ERROR: $e');
    } finally {
      if (mounted) setState(() => _loadingDetail = false);
    }
  }

  String get _fecha =>
      _data?['fecha_programada'] as String? ?? '';

  String get _tipo =>
      _data?['tipo'] as String? ?? '';

  String get _descripcion =>
      _data?['descripcion_completa'] as String? ??
      _data?['descripcion']         as String? ?? '';

  String get _comentario =>
      _data?['comentario'] as String? ??
      _data?['mensaje']    as String? ?? '';

  List<dynamic> get _ejercicios {
    final rawList = _data?['ejercicios_asociados'] as List<dynamic>? ?? [];
    final list = List<dynamic>.from(rawList);
    list.sort((a, b) {
      final mapA = a is Map ? Map<String, dynamic>.from(a) : <String, dynamic>{};
      final mapB = b is Map ? Map<String, dynamic>.from(b) : <String, dynamic>{};

      final ordA = mapA['orden'] ?? mapA['order'] ?? mapA['ejercicio']?['orden'] ?? mapA['ejercicio']?['order'] ?? 0;
      final ordB = mapB['orden'] ?? mapB['order'] ?? mapB['ejercicio']?['orden'] ?? mapB['ejercicio']?['order'] ?? 0;

      return (int.tryParse(ordA.toString()) ?? 0).compareTo(int.tryParse(ordB.toString()) ?? 0);
    });
    return list;
  }

  bool get _todosEjerciciosCompletados {
    if (_ejercicios.isEmpty) return false;
    return _ejercicios.every((e) {
      final estado = e['estado'] as String? ?? '';
      return estado == 'completado' || estado == 'completo' || estado == 'done';
    });
  }

  Future<void> _marcarCompletado() async {
    setState(() => _saving = true);
    try {
      final token = context.read<AuthProvider>().token ?? '';
      final id    = _data?['id_entrenamiento'] ?? _data?['id'];
      if (id != null) {
        await CachedHttp.post(
          Uri.parse('https://apifitnflai.com/entrenamientos/$id/completar'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      }
      setState(() => _localCompletado = true);
    } catch (e) {
      debugPrint('COMPLETAR ERROR: $e');
    } finally {
      setState(() => _saving = false);
    }
  }

  // Parsea la descripción en secciones con título y contenido
  List<({String titulo, String contenido, _SeccionTipo tipo})> _parseSecciones(String desc, bool canSeeNutrition) {
    final secciones = <({String titulo, String contenido, _SeccionTipo tipo})>[];

    // Keywords que marcan inicio de sección
    final patterns = {
      'OBJETIVO':         _SeccionTipo.objetivo,
      'DURACIÓN':         _SeccionTipo.duracion,
      'DURACION':         _SeccionTipo.duracion,
      'CALENTAMIENTO':    _SeccionTipo.calentamiento,
      'BLOQUE PRINCIPAL': _SeccionTipo.principal,
      'PRINCIPAL':        _SeccionTipo.principal,
      'VUELTA A LA CALMA':_SeccionTipo.vuelta,
      'ENFRIAMIENTO':     _SeccionTipo.vuelta,
      'NUTRICIÓN':        _SeccionTipo.nutricion,
      'NUTRICION':        _SeccionTipo.nutricion,
      'NOTAS':            _SeccionTipo.notas,
      'OBSERVACIONES':    _SeccionTipo.notas,
    };

    // Intentar split por líneas con "KEYWORD:"
    final lines = desc.split('\n');
    String? currentTitle;
    _SeccionTipo currentTipo = _SeccionTipo.notas;
    final buffer = StringBuffer();

    void flush() {
      if (currentTitle != null && buffer.isNotEmpty) {
        secciones.add((
          titulo:   currentTitle,
          contenido: buffer.toString().trim(),
          tipo:     currentTipo,
        ));
        buffer.clear();
      }
    }

    for (final line in lines) {
      final upper = line.trim().toUpperCase();
      bool matched = false;
      for (final entry in patterns.entries) {
        if (upper.startsWith('${entry.key}:') || upper == entry.key) {
          flush();
          currentTitle = line.trim().split(':').first.trim();
          currentTipo  = entry.value;
          final rest   = line.contains(':')
              ? line.substring(line.indexOf(':') + 1).trim()
              : '';
          if (rest.isNotEmpty) buffer.writeln(rest);
          matched = true;
          break;
        }
      }
      if (!matched && currentTitle != null) {
        buffer.writeln(line);
      }
    }
    flush();

    // Si no se encontraron secciones, mostrar todo como una tarjeta general
    if (secciones.isEmpty) {
      secciones.add((
        titulo:   'Descripción',
        contenido: desc.trim(),
        tipo:     _SeccionTipo.notas,
      ));
    }

    return secciones;
  }

  // Agrupa ejercicios por bloque
  List<Map<String, dynamic>> get _bloques {
    final Map<String, List<Map<String, dynamic>>> grouped = {};
    for (final e in _ejercicios) {
      final ej     = e['ejercicio'] as Map<String, dynamic>? ?? e as Map<String, dynamic>? ?? {};
      final bloque = ej['bloque'] as String? ?? e['bloque'] as String? ?? 'Principal';
      final nombre = ej['nombre'] as String? ?? ej['descripcion'] as String? ?? '';
      final tipo   = ej['tipo_movimiento'] as String? ?? ej['tipo'] as String? ?? '';
      final series = ej['series']?.toString() ?? '';
      final reps   = ej['repeticiones']?.toString() ?? ej['reps']?.toString() ?? '';
      final durMin = ej['duracion_minutos']?.toString() ?? '';
      if (nombre.isEmpty) continue;
      grouped.putIfAbsent(bloque, () => []);
      grouped[bloque]!.add({
        'nombre': nombre,
        'tipo':   tipo,
        'series': series,
        'reps':   reps,
        'dur':    durMin,
        'estado': (e['estado'] as String? ?? '').toLowerCase(),
      });
    }
    return grouped.entries
        .map((e) => {'bloque': e.key, 'ejercicios': e.value})
        .toList();
  }

  bool _isToday(String fechaStr) {
    if (fechaStr.isEmpty) return false;
    try {
      final d   = DateTime.parse(fechaStr.split('T')[0]);
      final now = DateTime.now();
      return d.year == now.year && d.month == now.month && d.day == now.day;
    } catch (_) { return false; }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>()!;
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;
    final profileProvider = context.watch<ProfileProvider>();
    final isElite = user?.isElite == true;
    final planNombreProfile = (profileProvider.planActivo?['nombre'] as String?)?.toLowerCase() ?? '';
    final isProOrEliteProfile = planNombreProfile.contains('pro') || planNombreProfile.contains('elite');
    final canSeeNutrition = user?.canSeeNutrition == true || isProOrEliteProfile;
    final displayTitulo = _data?['titulo_entrenamiento'] as String? ??
        _data?['titulo'] as String? ?? AppLocalizations.of(context).workoutDetailTitle;

    final displayDuracion = _data?['duracion_minutos'] != null
        ? AppLocalizations.of(context).statsMinCount(int.tryParse(_data!['duracion_minutos'].toString()) ?? 0)
        : _data?['duracion'] as String? ?? '';

    return Scaffold(
      backgroundColor: theme.bg,
      body: Column(children: [
        // ── Header ──────────────────────────────
        _Header(
          titulo:     displayTitulo,
          fecha:      _fecha,
          duracion:   displayDuracion,
          tipo:       _tipo,
          completado: _completado,
          onBack:     () => Navigator.pop(context),
          onComplete: _saving ? null : _marcarCompletado,
        ),

        // ── Body ────────────────────────────────
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              // Secciones del entrenamiento como tarjetas
              if (_comentario.isNotEmpty) ...[
                const SizedBox(height: 16),
                  CoachCommentCard(
                  comentario: _comentario,
                  tipo: _tipo,
                  isElite: isElite,
                ),
              ],

              if (_loadingDetail)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Center(child: CircularProgressIndicator(
                      color: theme.primary, strokeWidth: 2)),
                )
              else if (_descripcion.isNotEmpty) ...[
                const SizedBox(height: 16),
                ..._parseSecciones(_descripcion, canSeeNutrition)
                    .where((s) => canSeeNutrition || s.tipo != _SeccionTipo.nutricion)
                    .map((s) =>
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _SeccionCard(seccion: s),
                  ),
                ),
              ],

              // Bloques de ejercicios
              if (_bloques.isNotEmpty) ...[
                const SizedBox(height: 20),
                Text(AppLocalizations.of(context).workoutDetailExercises,
                    style: TextStyle(
                        color: theme.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                ..._bloques.map((b) => _BloqueCard(bloque: b)),
              ] else if (_ejercicios.isEmpty && _descripcion.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Center(
                    child: Text(AppLocalizations.of(context).workoutDetailNoExercises,
                        style: TextStyle(color: theme.grey, fontSize: 14)),
                  ),
                ),

              const SizedBox(height: 24),

              // ── Nutrición del día ────────────────────────────
              if (canSeeNutrition && (_data?['comidas'] as List?)?.isNotEmpty == true) ...[
                Text(AppLocalizations.of(context).workoutDetailDayNutrition,
                    style: TextStyle(
                        color: theme.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                ..._comidasOrdenadas().map((c) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _DetailMealCard(comida: c),
                )),
                const SizedBox(height: 8),
              ],
              const SizedBox(height: 80), // Espacio para el botón fijo
            ]),
          ),
        ),
      ]),
      bottomNavigationBar: _isToday(_fecha) && !_completado
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity, height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      if (_todosEjerciciosCompletados) {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => WorkoutFeedbackScreen(
                              entrenamiento: _data,
                              tiempoSecs: 0,
                              distanciaKm: 0.0,
                              isExterior: false,
                            ),
                          ),
                        );
                      } else {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) =>
                              WorkoutActiveScreen(entrenamiento: _data)),
                        );
                      }
                      CachedHttp.clearCache();
                      // Breve retraso para asegurar que el backend asiente cualquier transacción pendiente de completado
                      await Future.delayed(const Duration(milliseconds: 300));
                      _loadDetail();
                    },
                    icon: const Icon(Icons.play_arrow, size: 20),
                    label: Text(AppLocalizations.of(context).workoutActiveStartBtn,
                        style: const TextStyle(fontSize: 15,
                            fontWeight: FontWeight.w700)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                  ),
                ),
              ),
            )
          : _completado
            ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: theme.greenBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.greenText.withValues(alpha: 0.5)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, color: theme.greenText, size: 20),
                      const SizedBox(width: 8),
                      Text(AppLocalizations.of(context).workoutDetailCompletedBanner,
                          style: TextStyle(
                              color: theme.greenText,
                              fontSize: 15,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ),
            )
            : null,
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// HEADER
// ═══════════════════════════════════════════════════════════════
class _Header extends StatelessWidget {
  final String titulo, fecha, duracion, tipo;
  final bool completado;
  final VoidCallback onBack;
  final VoidCallback? onComplete;
  const _Header({
    required this.titulo, required this.fecha,
    required this.duracion, required this.tipo,
    required this.completado, required this.onBack,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>()!;
    return Container(
      color: theme.card,
      child: SafeArea(
        bottom: false,
        child: Column(children: [
          // Nav bar
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: Row(children: [
              GestureDetector(
                onTap: onBack,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.cardDark,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: theme.border),
                  ),
                  child: Icon(Icons.arrow_back_ios_new,
                      color: theme.primary, size: 16),
                ),
              ),
              const Spacer(),
              if (completado)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: theme.greenBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: theme.greenText.withValues(alpha: 0.5)),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.check_circle, color: theme.greenText, size: 14),
                    const SizedBox(width: 5),
                    Text(AppLocalizations.of(context).workoutDetailCompleted,
                        style: TextStyle(
                            color: theme.greenText,
                            fontSize: 12,
                            fontWeight: FontWeight.w600)),
                  ]),
                ),
            ]),
          ),

          // Info del entrenamiento
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              if (fecha.isNotEmpty)
                Text(fecha,
                    style: TextStyle(color: theme.grey, fontSize: 12)),
              const SizedBox(height: 4),
              Text(titulo,
                  style: TextStyle(
                      color: theme.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      height: 1.2)),
              if (tipo.isNotEmpty || duracion.isNotEmpty) ...[
                const SizedBox(height: 4),
                Row(children: [
                  if (tipo.isNotEmpty)
                    Text(tipo,
                        style: TextStyle(
                            color: theme.grey, fontSize: 13)),
                  if (tipo.isNotEmpty && duracion.isNotEmpty)
                    Text(' · ',
                        style: TextStyle(color: theme.grey, fontSize: 13)),
                  if (duracion.isNotEmpty)
                    Row(children: [
                      Icon(Icons.timer_outlined,
                          color: theme.grey, size: 14),
                      const SizedBox(width: 3),
                      Text(duracion,
                          style: TextStyle(
                              color: theme.grey, fontSize: 13)),
                    ]),
                ]),
              ],
            ]),
          ),

          Divider(color: theme.border, height: 1),
        ]),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// BLOQUE CARD
// ═══════════════════════════════════════════════════════════════
class _BloqueCard extends StatelessWidget {
  final Map<String, dynamic> bloque;
  const _BloqueCard({required this.bloque});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>()!;
    final nombre    = bloque['bloque'] as String? ?? '';
    final ejercicios = bloque['ejercicios'] as List<dynamic>? ?? [];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.border),
      ),
      child: Column(children: [
        // Header bloque
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: theme.cardDark,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
          ),
          child: Text(nombre.toUpperCase(),
              style: TextStyle(
                  color: theme.greyLight,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8)),
        ),

        // Ejercicios
        ...ejercicios.asMap().entries.map((entry) {
          final i  = entry.key;
          final ej = entry.value as Map<String, dynamic>;
          final esUltimo  = i == ejercicios.length - 1;
          final estado    = ej['estado'] as String? ?? '';
          final isHecho   = estado == 'completado' || estado == 'completo' || estado == 'done';
          return Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(children: [
                // Número o check
                Container(
                  width: 28, height: 28,
                  decoration: BoxDecoration(
                    color: isHecho
                        ? theme.greenMid.withValues(alpha: 0.2)
                        : theme.cardDark,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                        color: isHecho ? theme.greenMid : theme.border),
                  ),
                  child: Center(
                    child: isHecho
                        ? Icon(Icons.check,
                            color: theme.greenText, size: 16)
                        : Text('${i + 1}',
                            style: TextStyle(
                                color: theme.greyLight,
                                fontSize: 12,
                                fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(width: 12),

                // Nombre + detalle
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(ej['nombre'] as String? ?? '',
                        style: TextStyle(
                            color: isHecho ? theme.greenText : theme.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600)),
                    if ((ej['series'] as String? ?? '').isNotEmpty ||
                        (ej['reps'] as String? ?? '').isNotEmpty ||
                        (ej['dur'] as String? ?? '').isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        [
                          if ((ej['series'] as String? ?? '').isNotEmpty)
                            AppLocalizations.of(context).statsSeriesCount(int.tryParse(ej['series'] as String) ?? 0),
                          if ((ej['reps'] as String? ?? '').isNotEmpty)
                            AppLocalizations.of(context).statsRepsCount(int.tryParse(ej['reps'] as String) ?? 0),
                          if ((ej['dur'] as String? ?? '').isNotEmpty)
                            AppLocalizations.of(context).statsMinCount(int.tryParse(ej['dur'] as String) ?? 0),
                        ].join(' · '),
                        style: TextStyle(
                            color: theme.grey, fontSize: 11),
                      ),
                    ],
                  ]),
                ),

                // Tipo badge
                if ((ej['tipo'] as String? ?? '').isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text((ej['tipo'] as String).toUpperCase(),
                        style: TextStyle(
                            color: theme.primary,
                            fontSize: 10,
                            fontWeight: FontWeight.w700)),
                  ),
              ]),
            ),
            if (!esUltimo)
              Divider(color: theme.border, height: 1, indent: 14, endIndent: 14),
          ]);
        }),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// SECCIÓN TIPO ENUM
// ═══════════════════════════════════════════════════════════════
enum _SeccionTipo { objetivo, duracion, calentamiento, principal, vuelta, nutricion, notas }

// ═══════════════════════════════════════════════════════════════
// SECCIÓN CARD
// ═══════════════════════════════════════════════════════════════
class _SeccionCard extends StatelessWidget {
  final ({String titulo, String contenido, _SeccionTipo tipo}) seccion;
  const _SeccionCard({required this.seccion});

  static const _icons = {
    _SeccionTipo.objetivo:      '🎯',
    _SeccionTipo.duracion:      '⏱️',
    _SeccionTipo.calentamiento: '🔥',
    _SeccionTipo.principal:     '💪',
    _SeccionTipo.vuelta:        '🧘',
    _SeccionTipo.nutricion:     '🥗',
    _SeccionTipo.notas:         '📝',
  };

  // Colores de acento (invariantes al tema — son los colores de marca de cada sección)
  static const _accentColor = {
    _SeccionTipo.objetivo:      Color(0xFFE8700A),
    _SeccionTipo.duracion:      Color(0xFF4A90D9),
    _SeccionTipo.calentamiento: Color(0xFFEF9F27),
    _SeccionTipo.principal:     Color(0xFF4A90D9),
    _SeccionTipo.vuelta:        Color(0xFF00BCD4),
    _SeccionTipo.nutricion:     Color(0xFFB39DDB),
    _SeccionTipo.notas:         Color(0xFF9B8EA8),
  };

  // Obtiene bg y border del SeccionColors del tema (responde a claro/oscuro)
  SeccionColors _seccionColors(AppThemeExtension theme) {
    switch (seccion.tipo) {
      case _SeccionTipo.objetivo:      return theme.objetivo;
      case _SeccionTipo.calentamiento: return theme.calentamiento;
      case _SeccionTipo.principal:     return theme.principal;
      case _SeccionTipo.vuelta:        return theme.vuelta;
      case _SeccionTipo.nutricion:     return theme.nutricion;
      case _SeccionTipo.notas:         return theme.notas;
      case _SeccionTipo.duracion:      return theme.principal; // reutiliza azul
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>()!;
    final secColors = _seccionColors(theme);
    final color     = _accentColor[seccion.tipo]!;
    final icon      = _icons[seccion.tipo]!;
    final lines = seccion.contenido.split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();

    final l10n = AppLocalizations.of(context);
    String displayTitulo = seccion.titulo;
    switch (seccion.tipo) {
      case _SeccionTipo.objetivo:
        displayTitulo = l10n.workoutDetailObj;
        break;
      case _SeccionTipo.duracion:
        displayTitulo = l10n.workoutDetailDurationTitle;
        break;
      case _SeccionTipo.calentamiento:
        displayTitulo = l10n.workoutDetailCal;
        break;
      case _SeccionTipo.principal:
        displayTitulo = l10n.workoutDetailPrinc;
        break;
      case _SeccionTipo.vuelta:
        displayTitulo = l10n.workoutDetailDes;
        break;
      case _SeccionTipo.nutricion:
        displayTitulo = l10n.workoutDetailNutrition;
        break;
      case _SeccionTipo.notas:
        if (seccion.titulo.toLowerCase() == 'descripción' || seccion.titulo.toLowerCase() == 'descripcion') {
          displayTitulo = l10n.workoutDetailDesc;
        } else {
          displayTitulo = l10n.workoutDetailNotes;
        }
        break;
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: secColors.bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: secColors.border, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // ── Header ──────────────────────────────
        Container(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
          ),
          child: Row(children: [
            Text(icon, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Text(displayTitulo.toUpperCase(),
                style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8)),
          ]),
        ),

        // ── Contenido ────────────────────────────
        Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: lines.map((line) {
              // Líneas con → o · son ítems
              final isItem = line.startsWith('→') || line.startsWith('·')
                  || line.startsWith('-') || line.startsWith('•');
              if (isItem) {
                final text = line
                    .replaceFirst(RegExp(r'^[→·\-•]\s*'), '');
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Container(
                          width: 6, height: 6,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.7),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Expanded(child: Text(text,
                          style: TextStyle(
                              color: theme.greyLight,
                              fontSize: 13,
                              height: 1.45))),
                    ],
                  ),
                );
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(line,
                    style: TextStyle(
                        color: theme.greyLight,
                        fontSize: 13,
                        height: 1.5)),
              );
            }).toList(),
          ),
        ),
      ]),
    );
  }
}


// ═══════════════════════════════════════════════════════════════
// COMIDAS HELPERS — método en el state
// ═══════════════════════════════════════════════════════════════
extension _ComidaHelper on _WorkoutDetailScreenState {
  static const _orden = ['DESAYUNO','PRE_ENTRENO','DURANTE','POST_ENTRENO',
                          'ALMUERZO','CENA','SNACK'];

  List<Map<String, dynamic>> _comidasOrdenadas() {
    final raw = (_data?['comidas'] as List?)
        ?.whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList() ?? [];
    raw.sort((a, b) {
      final ta = (a['tipo'] as String? ?? '').toUpperCase();
      final tb = (b['tipo'] as String? ?? '').toUpperCase();
      final ia = _orden.indexOf(ta);
      final ib = _orden.indexOf(tb);
      return (ia < 0 ? 999 : ia).compareTo(ib < 0 ? 999 : ib);
    });
    return raw;
  }
}

// ═══════════════════════════════════════════════════════════════
// DETAIL MEAL CARD — mismo estilo que nutrition_screen
// ═══════════════════════════════════════════════════════════════
class _DetailMealCard extends StatelessWidget {
  final Map<String, dynamic> comida;
  const _DetailMealCard({required this.comida});

  String _getTime(BuildContext context) {
    final t = (comida['tipo'] as String? ?? '').toUpperCase();
    final l10n = AppLocalizations.of(context);
    switch (t) {
      case 'DESAYUNO': return l10n.mealBreakfast;
      case 'ALMUERZO': return l10n.mealLunch;
      case 'CENA': return l10n.mealDinner;
      case 'PRE_ENTRENO': return l10n.mealPreWorkout;
      case 'POST_ENTRENO': return l10n.mealPostWorkout;
      case 'SNACK': return l10n.mealSnack;
      case 'DURANTE': return l10n.mealDuring;
      default: return t;
    }
  }

  String get _emoji {
    final t = (comida['tipo'] as String? ?? '').toUpperCase();
    switch (t) {
      case 'DESAYUNO': return '🍳';
      case 'ALMUERZO': return '🍽️';
      case 'CENA': return '🥗';
      case 'PRE_ENTRENO': return '🍌';
      case 'POST_ENTRENO': return '🍚';
      case 'SNACK': return '🥜';
      case 'DURANTE': return '⚡';
      default: return '🍴';
    }
  }

  List<(String, Color)> _getTags(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>()!;
    final tags = <(String, Color)>[];
    final etiquetas = comida['etiquetas'] as List?;
    final isEs = Localizations.localeOf(context).languageCode == 'es';
    if (etiquetas != null) {
      for (final e in etiquetas) {
        final s = e.toString();
        String displayTag = s;
        if (!isEs) {
          if (s.toLowerCase().contains('ig alto')) displayTag = 'High GI';
          else if (s.toLowerCase().contains('ig bajo')) displayTag = 'Low GI';
          else if (s.toLowerCase().contains('proteín')) displayTag = 'Protein';
          else if (s.toLowerCase().contains('recuper')) displayTag = 'Recovery';
          else if (s.toLowerCase().contains('absorc')) displayTag = 'Fast Absorption';
        }
        Color color = theme.greyLight;
        if (s.toLowerCase().contains('ig alto'))  color = theme.primary;
        else if (s.toLowerCase().contains('ig bajo')) color = theme.greenText;
        else if (s.toLowerCase().contains('proteín')) color = theme.greenText;
        else if (s.toLowerCase().contains('recuper')) color = theme.greenText;
        else if (s.toLowerCase().contains('absorc'))  color = Colors.blue;
        tags.add((displayTag, color));
      }
    }
    return tags;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>()!;
    final kcal = (comida['kcal'] as num?)?.toInt() ?? 0;
    final name = comida['descripcion'] as String? ?? '';
    final desc = comida['instrucciones'] as String? ?? '';
    final tags = _getTags(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text(_getTime(context), style: TextStyle(
              color: theme.primary, fontSize: 10,
              fontWeight: FontWeight.w700, letterSpacing: 0.3)),
          const Spacer(),
          if (kcal > 0)
            Text('$kcal kcal', style: TextStyle(
                color: theme.grey, fontSize: 11)),
        ]),
        const SizedBox(height: 8),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(_emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 10),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (name.isNotEmpty)
                Text(name, style: TextStyle(
                    color: theme.white, fontSize: 14,
                    fontWeight: FontWeight.w600)),
              if (desc.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(desc, style: TextStyle(
                    color: theme.grey, fontSize: 12, height: 1.4)),
              ],
            ],
          )),
        ]),
        if (tags.isNotEmpty) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 6, runSpacing: 6,
            children: tags.map((t) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: t.$2.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: t.$2.withValues(alpha: 0.35)),
              ),
              child: Text(t.$1, style: TextStyle(
                  color: t.$2, fontSize: 11, fontWeight: FontWeight.w500)),
            )).toList(),
          ),
        ],
      ]),
    );
  }
}