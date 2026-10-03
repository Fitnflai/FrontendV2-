import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme_extension.dart';
import '../../config/app_text_styles.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/shared_widgets.dart';
import '../../services/cached_http.dart';

class ReporteConfigScreen extends StatefulWidget {
  const ReporteConfigScreen({super.key});

  @override
  State<ReporteConfigScreen> createState() => _ReporteConfigScreenState();
}

class _ReporteConfigScreenState extends State<ReporteConfigScreen> {
  String? _dia;
  TimeOfDay? _hora;
  bool _dirty   = false;
  bool _loading = true;
  bool _saving  = false;

  static const _dias = ['Lunes','Martes','Miércoles','Jueves','Viernes','Sábado','Domingo'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  Future<void> _loadData() async {
    final token = context.read<AuthProvider>().token ?? '';
    try {
      final res = await CachedHttp.get(
        Uri.parse('https://apifitnflai.com/users/me'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (res.statusCode == 200 && mounted) {
        final d = jsonDecode(res.body) as Map<String, dynamic>;
        final diaRaw  = d['dia_reporte']  as String?;
        final horaStr = d['hora_reporte'] as String?;
        TimeOfDay? hora;
        if (horaStr != null) {
          final parts = horaStr.split(':');
          if (parts.length >= 2) {
            hora = TimeOfDay(
              hour:   int.tryParse(parts[0]) ?? 8,
              minute: int.tryParse(parts[1]) ?? 0,
            );
          }
        }
        setState(() { _dia = diaRaw; _hora = hora; });
      }
    } catch (e) {
      debugPrint('REPORTE CONFIG LOAD ERROR: $e');
    } finally {
      if (mounted) setState(() { _loading = false; _dirty = false; });
    }
  }

  Future<void> _pickTime() async {
    final theme = context.themeColors;
    DateTime tempDateTime = DateTime(
      2026, 1, 1, 
      _hora?.hour ?? 8, 
      _hora?.minute ?? 0,
    );

    await showCupertinoModalPopup(
      context: context,
      builder: (ctx) {
        return Container(
          height: 300,
          color: theme.card,
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                // Header con botones de acción
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: theme.border,
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CupertinoButton(
                        child: Text(
                          'Cancelar',
                          style: TextStyle(
                            color: theme.textSecondary,
                            fontSize: 16,
                          ),
                        ),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                      CupertinoButton(
                        child: Text(
                          'Aceptar',
                          style: TextStyle(
                            color: theme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _hora = TimeOfDay(
                              hour: tempDateTime.hour,
                              minute: tempDateTime.minute,
                            );
                            _dirty = true;
                          });
                          Navigator.pop(ctx);
                        },
                      ),
                    ],
                  ),
                ),
                // Selector
                Expanded(
                  child: CupertinoTheme(
                    data: CupertinoThemeData(
                      brightness: Brightness.dark,
                      textTheme: CupertinoTextThemeData(
                        dateTimePickerTextStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      ),
                    ),
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.time,
                      initialDateTime: tempDateTime,
                      use24hFormat: false,
                      onDateTimeChanged: (DateTime newDateTime) {
                        tempDateTime = newDateTime;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _save() async {
    debugPrint('SAVE CALLED: dia=$_dia hora=$_hora');
    if (_dia == null || _hora == null) return;
    final token = context.read<AuthProvider>().token ?? '';
    final theme = context.themeColors;
    final horaStr = '${_hora!.hour.toString().padLeft(2,'0')}:${_hora!.minute.toString().padLeft(2,'0')}';
    setState(() => _saving = true);
    try {
      final res = await CachedHttp.patch(
        Uri.parse('https://apifitnflai.com/users/configurar-reporte'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'dia_reporte':  _dia,
          'hora_reporte': horaStr,
        }),
      );
      debugPrint('REPORTE PATCH STATUS: ${res.statusCode}');
      debugPrint('REPORTE PATCH BODY: ${res.body}');
      if (!mounted) return;
      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Configuración guardada'),
          backgroundColor: theme.successBorder,
        ));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error al guardar. Intenta de nuevo.'),
          backgroundColor: theme.redMid,
        ));
      }
    } catch (e) {
      debugPrint('REPORTE CONFIG SAVE ERROR: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;
    if (_loading) {
      return Scaffold(
        backgroundColor: theme.bg,
        appBar: FitnflaiAppBar(title: 'Configurar reporte'),
        body: Center(child: CircularProgressIndicator(color: theme.primary)),
      );
    }

    final horaLabel = _hora != null
        ? '${_hora!.hour.toString().padLeft(2,'0')}:${_hora!.minute.toString().padLeft(2,'0')}'
        : 'Seleccionar hora';

    return Scaffold(
      backgroundColor: theme.bg,
      appBar: FitnflaiAppBar(title: 'Configurar reporte'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: theme.card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.primary.withValues(alpha: 0.3)),
              ),
              child: Row(children: [
                Icon(Icons.info_outline, color: theme.primary, size: 16),
                const SizedBox(width: 10),
                Expanded(child: Text(
                  'Recibirás un resumen semanal de tu progreso el día y hora que elijas.',
                  style: AppTextStyles.bodySmall,
                )),
              ]),
            ),
            const SizedBox(height: 24),
            const FieldLabel(text: 'Día del reporte'),
            const SizedBox(height: 8),
            _buildDaySelector(),
            const SizedBox(height: 24),
            const FieldLabel(text: 'Hora del reporte'),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickTime,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                decoration: BoxDecoration(
                  color: theme.card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.border),
                ),
                child: Row(children: [
                  Text(
                    horaLabel,
                    style: TextStyle(
                      color: _hora != null ? theme.text : theme.textMuted,
                      fontSize: 15,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.access_time_outlined, color: theme.textMuted, size: 18),
                ]),
              ),
            ),
            const Spacer(),
            PrimaryButton(
              labelWidget: _saving
                  ? const Center(child: SizedBox(
                      width: 24, height: 24,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    ))
                  : const Text('Guardar configuración', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              enabled: _dirty && !_saving && _dia != null && _hora != null,
              onTap: _save,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDaySelector() => Wrap(
    spacing: 8,
    runSpacing: 8,
    children: _dias.map((dia) => SelChip(
      label: dia,
      selected: _dia == dia,
      onTap: () => setState(() { _dia = dia; _dirty = true; }),
    )).toList(),
  );
}