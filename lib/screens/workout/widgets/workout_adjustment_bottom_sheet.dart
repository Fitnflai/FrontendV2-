import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/app_theme_extension.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/cached_http.dart';
import '../../../providers/auth_provider.dart';

/// ═══════════════════════════════════════════════════════════════
/// WORKOUT ADJUSTMENT BOTTOM SHEET
/// ═══════════════════════════════════════════════════════════════
class WorkoutAdjustmentBottomSheet extends StatefulWidget {
  final String workoutId;
  const WorkoutAdjustmentBottomSheet({super.key, required this.workoutId});

  @override
  State<WorkoutAdjustmentBottomSheet> createState() =>
      _WorkoutAdjustmentBottomSheetState();
}

class _WorkoutAdjustmentBottomSheetState
    extends State<WorkoutAdjustmentBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  String? _actionType;      // 'adjust' o 'cancel'
  String? _selectedReason;  // 'weather', 'tired', 'injury', 'time'
  int? _fatigueLevel;       // 1 - 5 (para adjust + tired)
  final _lesionZoneController = TextEditingController(); // Input de texto para lesión
  int? _availableMinutes;   // 30, 45, 60, 90, 120 (para adjust + time)

  bool _isSubmitting = false;

  static const _timeOptions = [30, 45, 60, 90, 120];

  @override
  void dispose() {
    _lesionZoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_actionType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecciona si deseas Ajustar o Cancelar el entrenamiento.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    if (_selectedReason == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecciona un motivo.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    if (_actionType == 'adjust') {
      if (_selectedReason == 'tired' && _fatigueLevel == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor, selecciona tu nivel de fatiga.'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
      if (_selectedReason == 'injury' && _lesionZoneController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor, escribe la zona de la molestia o lesión.'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
      if (_selectedReason == 'time' && _availableMinutes == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor, selecciona tu tiempo disponible.'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
    }

    setState(() {
      _isSubmitting = true;
    });

    final token = context.read<AuthProvider>().token ?? '';
    const url = 'https://apifitnflai.com/entrenamientos/recalcular_entrenamiento';
    final l10n = AppLocalizations.of(context);

    String tipoAjustePayload = '';
    if (_actionType == 'cancel') {
      String motivo = 'otro';
      if (_selectedReason == 'weather') motivo = 'clima';
      if (_selectedReason == 'tired') motivo = 'fatiga';
      if (_selectedReason == 'injury') motivo = 'lesion';
      if (_selectedReason == 'time') motivo = 'tiempo';
      tipoAjustePayload = 'cancelacion_$motivo';
    } else {
      // _actionType == 'adjust'
      if (_selectedReason == 'weather') {
        tipoAjustePayload = 'clima';
      } else if (_selectedReason == 'injury') {
        String zoneText = _lesionZoneController.text.trim().toLowerCase();
        zoneText = zoneText.replaceAll(' ', '_');
        zoneText = zoneText
            .replaceAll('á', 'a')
            .replaceAll('é', 'e')
            .replaceAll('í', 'i')
            .replaceAll('ó', 'o')
            .replaceAll('ú', 'u')
            .replaceAll('ñ', 'n');
        tipoAjustePayload = 'lesion_$zoneText';
      } else if (_selectedReason == 'time') {
        tipoAjustePayload = 'tiempo_$_availableMinutes';
      } else if (_selectedReason == 'tired') {
        tipoAjustePayload = 'fatiga_$_fatigueLevel';
      }
    }

    try {
      final res = await CachedHttp.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "entrenamiento_id": widget.workoutId,
          "tipo_ajuste": tipoAjustePayload,
        }),
      );

      debugPrint('RECALCULAR WORKOUT STATUS: ${res.statusCode}');
      debugPrint('RECALCULAR WORKOUT BODY: ${res.body}');

      if (res.statusCode == 200 || res.statusCode == 201) {
        final decoded = jsonDecode(res.body) as Map<String, dynamic>;
        final String status = decoded['status'] as String? ?? 'Success';
        final String message = decoded['message'] as String? ?? '';

        if (status.toLowerCase() == 'error') {
          throw Exception(message.isNotEmpty ? message : 'Error devuelto por el servidor');
        }

        // Clear cached requests so the new workout displays on the dashboard/plan screen
        CachedHttp.clearCache();

        if (mounted) {
          final theme = context.themeColors;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                l10n.workoutAdjustmentSuccessMessage,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              backgroundColor: theme.successBorder,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }

        if (mounted) {
          Navigator.of(context).pop(true);
        }
      } else {
        throw Exception('Server returned ${res.statusCode}');
      }
    } catch (e) {
      debugPrint('RECALCULAR WORKOUT ERROR: $e');
      if (mounted) {
        final theme = context.themeColors;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Error al ajustar el entrenamiento: ${e.toString().replaceAll('Exception:', '').trim()}",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            backgroundColor: theme.redMid,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;
    final l10n = AppLocalizations.of(context);

    final inputDecorationTheme = InputDecoration(
      filled: true,
      fillColor: theme.cardDark,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      hintStyle: TextStyle(color: theme.grey),
      labelStyle: TextStyle(color: theme.textSecondary, fontSize: 14),
      errorStyle: const TextStyle(color: Colors.redAccent, fontSize: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: theme.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: theme.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: theme.orange, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
    );

    return Container(
      decoration: BoxDecoration(
        color: theme.bg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(color: theme.border, width: 0.5),
        ),
      ),
      child: SafeArea(
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 8,
            bottom: 20 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Pull bar indicator
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: theme.grey.withAlpha(76),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Sheet Title
                  Text(
                    l10n.workoutAdjustmentTitle,
                    style: TextStyle(
                      color: theme.text,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // ── SECCIÓN 1: ACCIÓN A REALIZAR ──
                  Text(
                    '¿Qué deseas hacer hoy con tu sesión?',
                    style: TextStyle(
                      color: theme.textSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      // Opción Ajustar
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() {
                            _actionType = 'adjust';
                          }),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: _actionType == 'adjust'
                                  ? theme.orange.withValues(alpha: 0.15)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _actionType == 'adjust'
                                    ? theme.orange
                                    : theme.border,
                                width: _actionType == 'adjust' ? 1.5 : 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                const Text('⚙️', style: TextStyle(fontSize: 22)),
                                const SizedBox(height: 6),
                                Text(
                                  'Ajustar rutina',
                                  style: TextStyle(
                                    color: _actionType == 'adjust'
                                        ? theme.orange
                                        : theme.textSecondary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Opción Cancelar
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() {
                            _actionType = 'cancel';
                          }),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: _actionType == 'cancel'
                                  ? theme.redText.withValues(alpha: 0.12)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _actionType == 'cancel'
                                    ? theme.redText
                                    : theme.border,
                                width: _actionType == 'cancel' ? 1.5 : 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                const Text('❌', style: TextStyle(fontSize: 22)),
                                const SizedBox(height: 6),
                                Text(
                                  'Cancelar hoy',
                                  style: TextStyle(
                                    color: _actionType == 'cancel'
                                        ? theme.redText
                                        : theme.textSecondary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ── SECCIÓN 2: SELECCIONAR MOTIVO (Solo si ya eligió acción) ──
                  if (_actionType != null) ...[
                    Text(
                      _actionType == 'cancel'
                          ? 'Selecciona el motivo de la cancelación:'
                          : 'Selecciona el motivo del ajuste:',
                      style: TextStyle(
                        color: theme.textSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Dropdown de motivos
                    DropdownButtonFormField<String>(
                      initialValue: _selectedReason,
                      dropdownColor: theme.cardDark,
                      style: TextStyle(color: theme.text, fontSize: 15),
                      icon: Icon(Icons.keyboard_arrow_down, color: theme.grey),
                      decoration: inputDecorationTheme.copyWith(
                        hintText: 'Selecciona un motivo',
                      ),
                      onChanged: (value) {
                        setState(() {
                          _selectedReason = value;
                          // Reset inputs de detalle
                          _fatigueLevel = null;
                          _lesionZoneController.clear();
                          _availableMinutes = null;
                        });
                      },
                      items: [
                        DropdownMenuItem(
                          value: 'weather',
                          child: Text(l10n.workoutAdjustmentReasonWeather),
                        ),
                        DropdownMenuItem(
                          value: 'tired',
                          child: Text(l10n.workoutAdjustmentReasonTired),
                        ),
                        DropdownMenuItem(
                          value: 'injury',
                          child: Text(l10n.workoutAdjustmentReasonInjury),
                        ),
                        DropdownMenuItem(
                          value: 'time',
                          child: const Text('Falta de tiempo disponible'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],

                  // ── SECCIÓN 3: CAMPOS CONDICIONALES PARA AJUSTAR ──
                  if (_actionType == 'adjust' && _selectedReason != null) ...[
                    // Caso 3a: Fatiga (nivel 1 a 5)
                    if (_selectedReason == 'tired') ...[
                      Text(
                        'Selecciona tu nivel de fatiga (1 = Leve, 5 = Extrema):',
                        style: TextStyle(
                          color: theme.textSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(5, (index) {
                          final level = index + 1;
                          final isSelected = _fatigueLevel == level;
                          return GestureDetector(
                            onTap: () => setState(() => _fatigueLevel = level),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? theme.orange.withValues(alpha: 0.2)
                                    : theme.cardDark,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isSelected ? theme.orange : theme.border,
                                  width: isSelected ? 1.5 : 1,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '$level',
                                  style: TextStyle(
                                    color: isSelected ? theme.orange : theme.text,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Caso 3b: Lesión / Molestia (zona del cuerpo como INPUT DE TEXTO)
                    if (_selectedReason == 'injury') ...[
                      Text(
                        'Escribe la zona de la molestia o lesión (ej: Rodilla, Tobillo):',
                        style: TextStyle(
                          color: theme.textSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _lesionZoneController,
                        style: TextStyle(color: theme.text, fontSize: 15),
                        decoration: inputDecorationTheme.copyWith(
                          hintText: 'Ej: Rodilla derecha, Hombro',
                        ),
                        validator: (value) => _selectedReason == 'injury' && (value == null || value.trim().isEmpty)
                            ? 'Por favor ingresa la zona de la lesión'
                            : null,
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Caso 3c: Tiempo disponible (minutos)
                    if (_selectedReason == 'time') ...[
                      Text(
                        'Selecciona los minutos que tenés disponibles hoy:',
                        style: TextStyle(
                          color: theme.textSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: _timeOptions.map((minutes) {
                          final isSelected = _availableMinutes == minutes;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _availableMinutes = minutes),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? theme.orange.withValues(alpha: 0.2)
                                      : theme.cardDark,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: isSelected ? theme.orange : theme.border,
                                    width: isSelected ? 1.5 : 1,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    '$minutes\'',
                                    style: TextStyle(
                                      color: isSelected ? theme.orange : theme.text,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ],

                  // ── BOTONES DE ACCIÓN (Enviar y Cancelar) ──
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      // Botón Cancelar
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: OutlinedButton(
                            onPressed: _isSubmitting
                                ? null
                                : () => Navigator.of(context).pop(),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: theme.border),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              foregroundColor: theme.textSecondary,
                            ),
                            child: Text(
                              l10n.workoutAdjustmentBtnCancel,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Botón Confirmar
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _isSubmitting ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.orange,
                              disabledBackgroundColor: theme.disabledBg,
                              foregroundColor: Colors.white,
                              disabledForegroundColor: theme.grey,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isSubmitting
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: theme.bg,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Confirmar',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
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
      ),
    );
  }
}