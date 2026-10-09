import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_constants.dart';
import '../../services/cached_http.dart';
import '../../config/app_theme_extension.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/shared_widgets.dart';
import '../../l10n/app_localizations.dart';

class CompetitionsScreen extends StatefulWidget {
  const CompetitionsScreen({super.key});
  @override
  State<CompetitionsScreen> createState() => _CompetitionsScreenState();
}

class _CompetitionsScreenState extends State<CompetitionsScreen> {
  final List<_Competencia> _items = [];
  bool _loading = false;

  static const _tipos = [
    'Carrera 5K', 'Carrera 10K', 'Media Maratón', 'Maratón',
    'Trail running', 'Triatlón', 'Ciclismo', 'Natación', 'Otro',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadFromApi());
  }

  Future<void> _loadFromApi() async {
    if (_loading) return;
    setState(() => _loading = true);
    try {
      final token = context.read<AuthProvider>().token ?? '';
      final res = await CachedHttp.get(
        Uri.parse('${AppConstants.baseUrl}/event/mis-eventos'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      debugPrint('COMPETENCIAS GET: ${res.statusCode} ${res.body}');
      if (res.statusCode == 200 && mounted) {
        final List<dynamic> list = jsonDecode(res.body);
        setState(() {
          _items.clear();
          for (final item in list) {
            final map = item as Map<String, dynamic>;
            _items.add(_Competencia(
              idEvento: map['id_evento'],
              nombre: map['nombre'] ?? '',
              tipoEvento: map['tipo_evento'] ?? map['tipo'] ?? _tipos[0],
              lugar: map['lugar'] ?? '',
              fecha: DateTime.tryParse(map['fecha'] ?? '') ?? DateTime.now(),
              distancia: (map['distancia'] as num?)?.toDouble() ?? 0.0,
              tiempoEstimado: map['tiempo_estimado'] ?? map['tiempo'] ?? '',
              unidadDistancia: map['unidad_distancia'] ?? 'km',
              esPrincipal: map['es_principal'] ?? false,
            ));
          }
        });
      }
    } catch (e) {
      debugPrint('COMPETENCIAS GET ERROR: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themeColors;
    return Scaffold(
      backgroundColor: theme.bg,
      appBar: FitnflaiAppBar(title: l10n.competitionsTitle),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddSheet,
        backgroundColor: theme.orange,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: _loading && _items.isEmpty
          ? Center(child: CircularProgressIndicator(color: theme.orange))
          : _items.isEmpty
              ? _EmptyState(onAdd: _showAddSheet)
              : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              itemCount: _items.length,
              itemBuilder: (_, i) => _EventCard(
                item: _items[i],
                onEdit:   () => _showAddSheet(editing: _items[i], index: i),
                onDelete: () => _confirmDelete(i),
              ),
            ),
    );
  }

  void _showAddSheet({_Competencia? editing, int? index}) {
    final isEdit = editing != null;
    final theme = context.themeColors;
    final nombreCtrl = TextEditingController(text: editing?.nombre ?? '');
    final lugarCtrl  = TextEditingController(text: editing?.lugar  ?? '');
    final distanciaCtrl = TextEditingController(text: (editing != null && editing.distancia != 0.0) ? '${editing.distancia}' : '');
    final tiempoCtrl    = TextEditingController(text: editing?.tiempoEstimado ?? '');
    String tipo      = editing?.tipoEvento ?? _tipos[0];
    if (!_tipos.contains(tipo)) {
      if (tipo == 'Trail') {
        tipo = 'Trail running';
      } else {
        tipo = 'Otro';
      }
    }
    String unidadDistancia = editing?.unidadDistancia ?? 'km';
    final unidades = ['km', 'm', 'millas', 'mi'];
    DateTime? fecha  = editing?.fecha;
    bool esPrincipal = editing?.esPrincipal ?? false;

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.card,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) {
          final l10n = AppLocalizations.of(ctx);
          final theme = ctx.themeColors;
          final isEs = Localizations.localeOf(ctx).languageCode == 'es';
          return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
            left: 20, right: 20, top: 16,
          ),
          child: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              // Handle
              Container(width: 40, height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(color: theme.border,
                      borderRadius: BorderRadius.circular(2))),

              Text(isEdit ? l10n.competitionsEditEvent : l10n.competitionsAddEvent,
                  style: TextStyle(color: theme.text,
                      fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 20),

              // Nombre
              FieldLabel(text: l10n.competitionsFieldName),
              const SizedBox(height: 8),
              AppTextField(
                hint: l10n.competitionsFieldNameHint,
                controller: nombreCtrl,
                prefixIcon: Icon(Icons.emoji_events_outlined,
                    color: theme.textMuted, size: 20),
              ),
              const SizedBox(height: 16),

              // Tipo
              FieldLabel(text: l10n.competitionsFieldType),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: theme.cardDark,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.border),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: tipo,
                    isExpanded: true,
                    dropdownColor: theme.card,
                    style: TextStyle(color: theme.text, fontSize: 15),
                    icon: Icon(Icons.keyboard_arrow_down,
                        color: theme.textMuted),
                    items: _tipos.map((t) => DropdownMenuItem(
                        value: t, child: Text(localizeTipo(t, ctx)))).toList(),
                    onChanged: (v) => setModal(() => tipo = v!),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Lugar
              FieldLabel(text: l10n.competitionsFieldLocation),
              const SizedBox(height: 8),
              AppTextField(
                hint: l10n.competitionsFieldLocationHint,
                controller: lugarCtrl,
                prefixIcon: Icon(Icons.location_on_outlined,
                    color: theme.textMuted, size: 20),
              ),
              const SizedBox(height: 16),

              // Distancia y Unidad
              FieldLabel(text: isEs ? 'Distancia del evento' : 'Event distance'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      hint: isEs ? 'Ej: 42.1' : 'E.g.: 42.1',
                      controller: distanciaCtrl,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      prefixIcon: Icon(Icons.speed_outlined,
                          color: theme.textMuted, size: 20),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 110,
                    height: 48,
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.cardDark,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: theme.border),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: unidadDistancia,
                          isExpanded: true,
                          dropdownColor: theme.card,
                          style: TextStyle(color: theme.text, fontSize: 15),
                          icon: Icon(Icons.keyboard_arrow_down,
                              color: theme.textMuted),
                          items: unidades.map((u) => DropdownMenuItem(
                              value: u, child: Text(u))).toList(),
                          onChanged: (v) => setModal(() => unidadDistancia = v!),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Tiempo objetivo
              FieldLabel(text: isEs ? 'Tiempo objetivo' : 'Target time'),
              const SizedBox(height: 8),
              AppTextField(
                hint: isEs ? 'hh:mm:ss (ej: 03:30:00)' : 'hh:mm:ss (e.g.: 03:30:00)',
                controller: tiempoCtrl,
                prefixIcon: Icon(Icons.timer_outlined,
                    color: theme.textMuted, size: 20),
              ),
              const SizedBox(height: 16),

              // Fecha
              FieldLabel(text: l10n.competitionsFieldDate),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: ctx,
                    initialDate: fecha ?? DateTime.now().add(
                        const Duration(days: 30)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(
                        const Duration(days: 365 * 3)),
                    builder: (c, child) => Theme(
                      data: Theme.of(c).copyWith(
                        colorScheme: ColorScheme.fromSeed(
                          seedColor: theme.orange,
                          brightness: Theme.of(c).brightness,
                          primary: theme.orange,
                          surface: theme.card,
                        ),
                      ),
                      child: child!,
                    ),
                  );
                  if (picked != null) setModal(() => fecha = picked);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                  color: theme.cardDark,
                    borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.border),
                  ),
                  child: Row(children: [
                    Icon(Icons.calendar_today_outlined,
                        color: theme.textMuted, size: 18),
                    const SizedBox(width: 12),
                    Text(
                      fecha != null
                          ? _formatFecha(fecha!, ctx)
                          : l10n.competitionsSelectDate,
                      style: TextStyle(
                          color: fecha != null
                              ? theme.text : theme.textMuted,
                          fontSize: 15),
                    ),
                  ]),
                ),
              ),
              const SizedBox(height: 24),

              // Es evento principal
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FieldLabel(text: isEs ? 'Evento principal' : 'Main event'),
                        const SizedBox(height: 4),
                        Text(
                          isEs
                              ? 'Define este evento como tu objetivo principal.'
                              : 'Set this event as your main objective.',
                          style: TextStyle(color: theme.textMuted, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: esPrincipal,
                    onChanged: (v) => setModal(() => esPrincipal = v),
                    activeThumbColor: theme.orange,
                    activeTrackColor: theme.orange.withValues(alpha: 0.5),
                    inactiveThumbColor: theme.textMuted,
                    inactiveTrackColor: theme.border,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Guardar
              SizedBox(
                width: double.infinity, height: 50,
                child: ElevatedButton(
                  onPressed: nombreCtrl.text.trim().isNotEmpty && fecha != null
                      ? () {
                          final comp = _Competencia(
                            idEvento: isEdit ? editing.idEvento : null,
                            nombre: nombreCtrl.text.trim(),
                            tipoEvento:   tipo,
                            lugar:  lugarCtrl.text.trim(),
                            fecha:  fecha!,
                            distancia: double.tryParse(distanciaCtrl.text.trim().replaceAll(',', '.')) ?? 0.0,
                            tiempoEstimado: tiempoCtrl.text.trim(),
                            unidadDistancia: unidadDistancia,
                            esPrincipal: esPrincipal,
                          );
                          setState(() {
                            if (isEdit && index != null) {
                              _items[index] = comp;
                            } else {
                              _items.add(comp);
                            }
                          });
                          Navigator.pop(ctx);
                          if (isEdit) {
                            _updateEvent(comp);
                          } else {
                            _createEvent(comp);
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.orange,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: theme.border,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: Text(isEdit ? l10n.competitionsSaveButton : l10n.competitionsAddEvent,
                      style: const TextStyle(fontSize: 15,
                          fontWeight: FontWeight.w700)),
                ),
              ),
            ]),
          ),
        );
        },
      ),
    );
  }

  void _confirmDelete(int index) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themeColors;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
      backgroundColor: theme.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l10n.competitionsDeleteTitle,
            style: TextStyle(color: theme.text, fontSize: 16,
                fontWeight: FontWeight.w700)),
        content: Text(
          l10n.competitionsDeleteDesc(_items[index].nombre),
          style: TextStyle(color: theme.textMuted, fontSize: 13)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.competitionsCancel,
                style: TextStyle(color: theme.textMuted))),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _items.removeAt(index));
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Evento eliminado (temporalmente de forma local)')),
                );
              }
            },
            child: Text(l10n.competitionsDelete,
                style: TextStyle(color: theme.redText,
                    fontWeight: FontWeight.w700))),
        ],
      ),
    );
  }

  Future<void> _createEvent(_Competencia comp) async {
    if (_loading) return;
    setState(() => _loading = true);
    try {
      final token = context.read<AuthProvider>().token ?? '';
      
      // format date to ISO string for backend payload
      final dateIso = comp.fecha.toUtc().toIso8601String();

      final body = {
        'nombre': comp.nombre,
        'fecha': dateIso,
        'lugar': comp.lugar,
        'tipo_evento': comp.tipoEvento,
        'distancia': comp.distancia,
        'unidad_distancia': comp.unidadDistancia,
        'tiempo_estimado': comp.tiempoEstimado,
        'es_principal': comp.esPrincipal,
      };

      final res = await CachedHttp.post(
        Uri.parse('${AppConstants.baseUrl}/event/crear-evento'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      debugPrint('CREAR EVENTO: ${res.statusCode} ${res.body}');
      if (res.statusCode == 200 || res.statusCode == 201) {
        await _loadFromApi();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Evento creado con éxito')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al crear evento: ${res.statusCode}')),
          );
        }
      }
    } catch (e) {
      debugPrint('CREAR EVENTO ERROR: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _updateEvent(_Competencia comp) async {
    if (comp.idEvento == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: ID del evento no encontrado')),
      );
      return;
    }
    if (_loading) return;
    setState(() => _loading = true);
    try {
      final token = context.read<AuthProvider>().token ?? '';
      final body = {
        'nombre': comp.nombre,
        'fecha': comp.fecha.toUtc().toIso8601String(),
        'distancia': comp.distancia,
        'lugar': comp.lugar,
        'tipo_evento': comp.tipoEvento,
        'tiempo_estimado': comp.tiempoEstimado,
        'unidad_distancia': comp.unidadDistancia,
      };

      final res = await CachedHttp.patch(
        Uri.parse('${AppConstants.baseUrl}/event/actualizar-evento?id_evento=${comp.idEvento}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      debugPrint('ACTUALIZAR EVENTO: ${res.statusCode} ${res.body}');
      if (res.statusCode == 200) {
        await _loadFromApi();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Evento actualizado con éxito')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al actualizar evento: ${res.statusCode}')),
          );
        }
      }
    } catch (e) {
      debugPrint('ACTUALIZAR EVENTO ERROR: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _formatFecha(DateTime dt, BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final months = l10n.shortMonths.split(',');
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }
}

String localizeTipo(String tipo, BuildContext context) {
  final l10n = AppLocalizations.of(context);
  switch (tipo) {
    case 'Carrera 5K': return l10n.competitionsType5k;
    case 'Carrera 10K': return l10n.competitionsType10k;
    case 'Media Maratón': return l10n.competitionsTypeHalfMarathon;
    case 'Maratón': return l10n.competitionsTypeMarathon;
    case 'Trail':
    case 'Trail running': return l10n.competitionsTypeTrail;
    case 'Triatlón': return l10n.competitionsTypeTriathlon;
    case 'Ciclismo': return l10n.competitionsTypeCycling;
    case 'Natación': return l10n.competitionsTypeSwimming;
    default: return l10n.competitionsTypeOther;
  }
}

class _EventCard extends StatelessWidget {
  final _Competencia item;
  final VoidCallback onEdit, onDelete;
  const _EventCard({required this.item, required this.onEdit,
      required this.onDelete});

  String _formatFecha(DateTime dt, BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final months = l10n.shortMonths.split(',');
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }

  int _daysLeft() => item.fecha.difference(DateTime.now()).inDays;

  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;
    final days    = _daysLeft();
    final isPast  = days < 0;
    final isClose = days >= 0 && days <= 30;
    final l10n = AppLocalizations.of(context);
    final isEs = Localizations.localeOf(context).languageCode == 'es';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
                color: isPast  ? theme.border
              : isClose ? theme.orange.withValues(alpha: 0.6)
                    : theme.border,
        ),
      ),
      child: Row(children: [
        Container(
          width: 48, height: 48,
          decoration: BoxDecoration(
            color: isPast
                ? theme.cardDark
                : theme.orange.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(child: Text(
            _tipoIcon(item.tipoEvento),
            style: const TextStyle(fontSize: 24),
          )),
        ),
        const SizedBox(width: 14),

        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.nombre,
                    style: TextStyle(
                      color: isPast ? theme.textMuted : theme.text,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (item.esPrincipal) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: theme.orange.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: theme.orange, width: 0.5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, color: theme.orange, size: 10),
                        const SizedBox(width: 2),
                        Text(
                          isEs ? 'Principal' : 'Main',
                          style: TextStyle(color: theme.orange, fontSize: 9, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 2),
            Text(localizeTipo(item.tipoEvento, context), style: TextStyle(
                color: theme.textMuted, fontSize: 12)),
            const SizedBox(height: 4),
            Row(children: [
              Icon(Icons.calendar_today_outlined,
                    color: theme.textMuted, size: 12),
              const SizedBox(width: 4),
              Text(_formatFecha(item.fecha, context),
                  style: TextStyle(color: theme.textMuted, fontSize: 12)),
              if (item.lugar.isNotEmpty) ...[
                Text(' · ',
                    style: TextStyle(color: theme.border)),
                Icon(Icons.location_on_outlined,
                  color: theme.textMuted, size: 12),
                const SizedBox(width: 2),
                Flexible(child: Text(item.lugar,
                    style: TextStyle(
                        color: theme.textMuted, fontSize: 12),
                    overflow: TextOverflow.ellipsis)),
              ],
            ]),
          ],
        )),
        const SizedBox(width: 8),

        Column(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: isPast  ? theme.cardDark
                  : isClose ? theme.orange.withValues(alpha: 0.15)
                  : theme.cardDark,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isPast  ? theme.border
                    : isClose ? theme.orange
                    : theme.border,
              ),
            ),
            child: Text(
              isPast  ? l10n.competitionsStatusPast
                  : days == 0 ? l10n.competitionsStatusToday
                  : l10n.competitionsStatusDays(days),
              style: TextStyle(
                   color: isPast  ? theme.textMuted
                    : isClose ? theme.orange
                      : theme.textSecondary,
                  fontSize: 10,
                  fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 8),
          Row(children: [
            GestureDetector(
              onTap: onEdit,
              child: Icon(Icons.edit_outlined,
                  color: theme.textMuted, size: 18)),
              const SizedBox(width: 12),
            GestureDetector(
              onTap: onDelete,
              child: Icon(Icons.delete_outline,
                  color: theme.redText, size: 18)),
          ]),
        ]),
      ]),
    );
  }

  String _tipoIcon(String tipo) {
    switch (tipo) {
      case 'Carrera 5K':
      case 'Carrera 10K':
      case 'Media Maratón':
      case 'Maratón':        return '🏃';
      case 'Trail':
      case 'Trail running':  return '🏔️';
      case 'Triatlón':       return '🏊';
      case 'Ciclismo':       return '🚴';
      case 'Natación':       return '🏊';
      default:               return '🏆';
    }
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themeColors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('🏆', style: TextStyle(fontSize: 56)),
          const SizedBox(height: 16),
          Text(l10n.competitionsEmptyTitle,
              style: TextStyle(color: theme.text, fontSize: 20,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text(
            l10n.competitionsEmptyDesc,
            textAlign: TextAlign.center,
            style: TextStyle(color: theme.textMuted, fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add, size: 18),
            label: Text(l10n.competitionsAddFirst,
                style: const TextStyle(fontWeight: FontWeight.w700)),
            style: ElevatedButton.styleFrom(
        backgroundColor: theme.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
          ),
        ]),
      ),
    );
  }
}

class _Competencia {
  final String? idEvento;
  final String nombre, tipoEvento, lugar, tiempoEstimado, unidadDistancia;
  final double distancia;
  final DateTime fecha;
  final bool esPrincipal;
  const _Competencia({
    this.idEvento,
    required this.nombre,
    required this.tipoEvento,
    required this.lugar,
    required this.fecha,
    this.distancia = 0.0,
    this.tiempoEstimado = '',
    this.unidadDistancia = 'km',
    this.esPrincipal = false,
  });
}