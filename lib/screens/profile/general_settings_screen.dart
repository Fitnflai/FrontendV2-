import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/app_routes.dart';
import '../../config/app_theme_extension.dart';
import '../../widgets/shared_widgets.dart';

import '../../l10n/app_localizations.dart';
import 'support_screen.dart';

class GeneralSettingsScreen extends StatefulWidget {
  const GeneralSettingsScreen({super.key});
  @override
  State<GeneralSettingsScreen> createState() => _GeneralSettingsScreenState();
}

class _GeneralSettingsScreenState extends State<GeneralSettingsScreen> {

  String _unidadDist = 'km';
  String _unidadAltura = 'Cm';
  bool   _modoOscuro = true;

  static const _distancias = ['km', 'mi'];
  static const _alturas = ['Cm', 'In'];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _unidadDist = prefs.getString('selected_distance_unit') ?? 'km';
      _unidadAltura = prefs.getString('selected_height_unit') ?? 'Cm';
      _modoOscuro = prefs.getBool('theme_dark_mode') ?? true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: theme.bg,
      appBar: FitnflaiAppBar(title: l10n.settingsTitle),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _SectionLabel(l10n.settingsSectionAppearance),
          _SettingsGroup(items: [
            _ToggleRow(
              icon: Icons.dark_mode_outlined,
              label: l10n.settingsDarkMode,
              value: _modoOscuro,
              onChanged: (v) => setState(() => _modoOscuro = v),
            ),
          ]),
          const SizedBox(height: 20),
          _SectionLabel(l10n.settingsSectionLanguageUnits),
          _SettingsGroup(items: [
            _DropRow(
              icon: Icons.straighten_outlined,
              label: l10n.settingsDistance,
              value: _unidadDist,
              options: _distancias,
              onChanged: (v) => setState(() => _unidadDist = v!),
              isLast: false,
            ),
            _DropRow(
              icon: Icons.height_outlined,
              label: l10n.settingsHeight,
              value: _unidadAltura,
              options: _alturas,
              onChanged: (v) => setState(() => _unidadAltura = v!),
              isLast: true,
            ),
          ]),
          const SizedBox(height: 20),
          _SectionLabel(l10n.settingsSectionPrivacy),
          _SettingsGroup(items: [
            _NavRow(icon: Icons.privacy_tip_outlined, label: l10n.settingsPrivacyPolicy, onTap: () => Navigator.pushNamed(context, AppRoutes.privacyPolicy)),
            _NavRow(
              icon: Icons.monetization_on_outlined,
              label: l10n.settingsRefundRequest,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SupportScreen(initialSubject: 'Reembolso'),
                ),
              ),
            ),
            _NavRow(icon: Icons.description_outlined, label: l10n.settingsTermsConditions, onTap: () => Navigator.pushNamed(context, AppRoutes.termsConditions), isLast: true),
          ]),
          const SizedBox(height: 32),
          PrimaryButton(labelWidget: Text(l10n.settingsSaveChanges, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)), onTap: _save),
        ]),
      ),
    );
  }

  void _save() async {
    final l10n = AppLocalizations.of(context);

    // Guardar cambios locales de configuración
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_distance_unit', _unidadDist);
    await prefs.setString('selected_height_unit', _unidadAltura);
    await prefs.setBool('theme_dark_mode', _modoOscuro);

    if (!mounted) return;

    final theme = context.themeColors;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(l10n.settingsSavedSuccess),
      backgroundColor: theme.successBorder,
    ));
    Navigator.pop(context);
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

class _SettingsGroup extends StatelessWidget {
  final List<Widget> items;
  const _SettingsGroup({required this.items});
  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;
    return Container(
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.border),
      ),
      child: Column(children: items),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _ToggleRow({required this.icon, required this.label,
      required this.value, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(children: [
        Icon(icon, color: theme.textSecondary, size: 20),
        const SizedBox(width: 14),
        Expanded(child: Text(label,
            style: TextStyle(color: theme.text, fontSize: 15))),
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

class _DropRow extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final List<String> options;
  final ValueChanged<String?> onChanged;
  final bool isLast;
  const _DropRow({required this.icon, required this.label, required this.value,
      required this.options, required this.onChanged, this.isLast = false});
  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Row(children: [
          Icon(icon, color: theme.textSecondary, size: 20),
          const SizedBox(width: 14),
          Expanded(child: Text(label,
              style: TextStyle(color: theme.text, fontSize: 15))),
          DropdownButton<String>(
            value: value,
            dropdownColor: theme.card,
            underline: const SizedBox(),
            style: TextStyle(color: theme.primary, fontSize: 14,
                fontWeight: FontWeight.w600),
            icon: Icon(Icons.keyboard_arrow_down, color: theme.textMuted, size: 18),
            items: options.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
            onChanged: onChanged,
          ),
        ]),
      ),
      if (!isLast) Divider(color: theme.border, height: 1, indent: 50),
    ]);
  }
}

class _NavRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isLast;
  const _NavRow({required this.icon, required this.label,
      required this.onTap, this.isLast = false});
  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;
    return Column(children: [
      InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(children: [
            Icon(icon, color: theme.textSecondary, size: 20),
            const SizedBox(width: 14),
            Expanded(child: Text(label,
                style: TextStyle(color: theme.text, fontSize: 15))),
            Icon(Icons.chevron_right, color: theme.textMuted, size: 20),
          ]),
        ),
      ),
      if (!isLast) Divider(color: theme.border, height: 1, indent: 50),
    ]);
  }
}
