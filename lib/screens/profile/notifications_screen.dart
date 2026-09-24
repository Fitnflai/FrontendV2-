import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitnflaifrontendv2/providers/notification_provider.dart'; // Added import
import '../../config/app_theme_extension.dart';
import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';
import '../../widgets/shared_widgets.dart';
import '../../l10n/app_localizations.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});
  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _entrenamientos = true;
  bool _recordatorios  = true;
  bool _progreso       = true;
  bool _nutricion      = false;
  bool _ofertas        = false;
  String _intensidad   = 'media';
  TimeOfDay? _selectedTime;
  bool _dirty = false;

  static const _intensidades = ['baja', 'media', 'alta'];

  @override
  void initState() {
    super.initState();
    final data = context.read<ProfileProvider>().profileData;
    if (data != null) {
      _intensidad = data['intensidad_notificaciones'] as String? ?? 'media';
    }

    final notificationProvider = context.read<NotificationProvider>();
    if (notificationProvider.notificationTime != null) {
      try {
        final parts = notificationProvider.notificationTime!.split(':');
        _selectedTime = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
      } catch (_) {
        _selectedTime = const TimeOfDay(hour: 8, minute: 0); // Default if parsing fails
      }
    } else {
      _selectedTime = const TimeOfDay(hour: 8, minute: 0); // Default if null
    }
  }

  String _localizarIntensidad(BuildContext context, String nivel) {
    final l10n = AppLocalizations.of(context);
    switch (nivel) {
      case 'baja':
        return l10n.notificationsIntensityLow;
      case 'media':
        return l10n.notificationsIntensityMedium;
      case 'alta':
        return l10n.notificationsIntensityHigh;
      default:
        return nivel;
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final theme = context.themeColors;
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime!, // Use ! as it's initialized in initState
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          timePickerTheme: TimePickerThemeData(
            backgroundColor: theme.card,
            dialHandColor: theme.orange, // Using this for both hour and minute hand
            dialBackgroundColor: theme.cardDark,
            dialTextColor: WidgetStateColor.resolveWith((states) =>
                states.contains(WidgetState.selected) ? Colors.white : theme.text),
            hourMinuteTextColor: WidgetStateColor.resolveWith((states) =>
                states.contains(WidgetState.selected) ? Colors.white : theme.text),
            hourMinuteColor: WidgetStateColor.resolveWith((states) =>
                states.contains(WidgetState.selected) ? theme.orange : theme.cardDark),
            dayPeriodColor: WidgetStateColor.resolveWith((states) =>
                states.contains(WidgetState.selected) ? theme.orange.withAlpha((255 * 0.2).round()) : theme.cardDark),
            dayPeriodTextColor: theme.text,
            entryModeIconColor: theme.orange,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(foregroundColor: theme.orange),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        _dirty = true;
      });
    }
  }

  Future<void> _save() async {
    final token = context.read<AuthProvider>().token;
    final theme = context.themeColors;
    if (token == null) return;

    try {
      // 1. Save notification schedule first
      final scheduleStr = "${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}";
      await context.read<NotificationProvider>().setSchedule(token, scheduleStr);
      if (!mounted) return;

      // 2. If successful, proceed to call ProfileProvider.saveProfile
      final ok = await context.read<ProfileProvider>().saveProfile(
        token,
        intensidadNotificaciones: _intensidad,
      );

      if (!mounted) return;
      if (ok) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context).notificationsSettingsSaveSuccess),
          backgroundColor: theme.successBorder,
        ));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context).notificationsSettingsSaveError),
          backgroundColor: theme.redMid,
        ));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error saving notification settings: ${e.toString()}"), // Generic error message
        backgroundColor: theme.redMid,
      ));
      debugPrint("Error in _save: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSaving = context.watch<ProfileProvider>().isSaving;
    final theme = context.themeColors;

    return Scaffold(
      backgroundColor: theme.bg,
      appBar: FitnflaiAppBar(title: AppLocalizations.of(context).notificationsSettingsTitle),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          _SectionLabel(AppLocalizations.of(context).notificationsSettingsIntensityHeader),
          Container(
            decoration: BoxDecoration(
              color: theme.card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: theme.border),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(AppLocalizations.of(context).notificationsSettingsIntensityLabel,
                  style: TextStyle(color: theme.text, fontSize: 14)),
              const SizedBox(height: 4),
              Text(AppLocalizations.of(context).notificationsSettingsIntensityDesc,
                  style: TextStyle(color: theme.textMuted, fontSize: 12)),
              const SizedBox(height: 12),
              Row(children: _intensidades.map((nivel) => Expanded(
                child: GestureDetector(
                  onTap: () => setState(() { _intensidad = nivel; _dirty = true; }),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: _intensidad == nivel
                          ? theme.primary : theme.cardDark,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _intensidad == nivel
                            ? theme.primary : theme.border,
                      ),
                    ),
                    child: Text(
                      _localizarIntensidad(context, nivel),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _intensidad == nivel
                            ? Colors.white : theme.textMuted,
                        fontSize: 13,
                        fontWeight: _intensidad == nivel
                            ? FontWeight.w700 : FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              )).toList()),
            ]),
          ),
          const SizedBox(height: 20),

          _SectionLabel("HORARIO DE NOTIFICACIONES"),
          GestureDetector(
            onTap: () => _selectTime(context),
            child: Container(
              decoration: BoxDecoration(
                color: theme.card,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: theme.border),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Icon(Icons.access_time, color: theme.textSecondary, size: 20),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Horario de Notificaciones",
                          style: TextStyle(color: theme.text, fontSize: 14),
                        ),
                        Text(
                          "${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}",
                          style: TextStyle(color: theme.textMuted, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.edit, color: theme.textSecondary, size: 20),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          _SectionLabel(AppLocalizations.of(context).notificationsSettingsTypesHeader),
          Container(
            decoration: BoxDecoration(
              color: theme.card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: theme.border),
            ),
            child: Column(children: [
              _NotifToggle(
                icon: Icons.fitness_center_outlined,
                label: AppLocalizations.of(context).notificationsSettingsWorkoutsLabel,
                subtitle: AppLocalizations.of(context).notificationsSettingsWorkoutsDesc,
                value: _entrenamientos,
                onChanged: (v) => setState(() { _entrenamientos = v; _dirty = true; }),
              ),
              Divider(color: theme.border, height: 1, indent: 50),
              _NotifToggle(
                icon: Icons.alarm_outlined,
                label: AppLocalizations.of(context).notificationsSettingsRemindersLabel,
                subtitle: AppLocalizations.of(context).notificationsSettingsRemindersDesc,
                value: _recordatorios,
                onChanged: (v) => setState(() { _recordatorios = v; _dirty = true; }),
              ),
              Divider(color: theme.border, height: 1, indent: 50),
              _NotifToggle(
                icon: Icons.bar_chart_outlined,
                label: AppLocalizations.of(context).notificationsSettingsProgressLabel,
                subtitle: AppLocalizations.of(context).notificationsSettingsProgressDesc,
                value: _progreso,
                onChanged: (v) => setState(() { _progreso = v; _dirty = true; }),
              ),
              Divider(color: theme.border, height: 1, indent: 50),
              _NotifToggle(
                icon: Icons.restaurant_outlined,
                label: AppLocalizations.of(context).notificationsSettingsNutritionLabel,
                subtitle: AppLocalizations.of(context).notificationsSettingsNutritionDesc,
                value: _nutricion,
                onChanged: (v) => setState(() { _nutricion = v; _dirty = true; }),
              ),
              Divider(color: theme.border, height: 1, indent: 50),
              _NotifToggle(
                icon: Icons.local_offer_outlined,
                label: AppLocalizations.of(context).notificationsSettingsOffersLabel,
                subtitle: AppLocalizations.of(context).notificationsSettingsOffersDesc,
                value: _ofertas,
                onChanged: (v) => setState(() { _ofertas = v; _dirty = true; }),
                isLast: true,
              ),
            ]),
          ),
          const SizedBox(height: 32),

          PrimaryButton(
            labelWidget: isSaving
                ? const Center(child: SizedBox(
                    width: 24, height: 24,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  ))
                : Text(AppLocalizations.of(context).notificationsSettingsSave, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            enabled: _dirty && !isSaving,
            onTap: _save,
          ),
          const SizedBox(height: 16),
        ]),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);
  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(text, style: TextStyle(
          color: theme.textMuted, fontSize: 11,
          fontWeight: FontWeight.w600, letterSpacing: 0.8)),
    );
  }
}

class _NotifToggle extends StatelessWidget {
  final IconData icon;
  final String label, subtitle;
  final bool value, isLast;
  final ValueChanged<bool> onChanged;
  const _NotifToggle({
    required this.icon, required this.label, required this.subtitle,
    required this.value, required this.onChanged, this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(children: [
        Icon(icon, color: theme.textSecondary, size: 20),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: TextStyle(color: theme.text, fontSize: 14)),
          Text(subtitle, style: TextStyle(
              color: theme.textMuted, fontSize: 11, height: 1.3)),
        ])),
        Switch(
          value: value, onChanged: onChanged,
          activeThumbColor: theme.primary,
          activeTrackColor: theme.primary.withValues(alpha: 0.5),
          inactiveThumbColor: theme.textMuted,
          inactiveTrackColor: theme.border,
        ),
      ]),
    );
  }
}
