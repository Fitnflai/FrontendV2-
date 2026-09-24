import 'dart:convert';
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme_extension.dart';
import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';
import '../../widgets/shared_widgets.dart';
import 'competitions_screen.dart';
import '../../services/cached_http.dart';

class TrainingSettingsScreen extends StatefulWidget {
  const TrainingSettingsScreen({super.key});
  @override
  State<TrainingSettingsScreen> createState() => _TrainingSettingsScreenState();
}

class _TrainingSettingsScreenState extends State<TrainingSettingsScreen> {
  bool  _adaptacionAltura = true;
  bool  _alertasLesion    = true;
  String _nivelDificultad = 'Moderado';
  String _disciplina      = 'Trail running';
  int    _tiempoPorSesion = 60;
  List<String> _diasEntrenamiento = [];
  bool _dirty   = false;
  bool _loading = true;

  static const _nivelActividad = ['Suave', 'Moderado', 'Exigente', 'Competitivo'];
  List<String> _disciplinas = [];
  static const _disciplinaEmojis = <String, String>{};
  static const _tiempos    = [30, 45, 60, 75, 90, 120];
  static const _diasKeys   = ['lunes', 'martes', 'miércoles', 'jueves', 'viernes', 'sábado', 'domingo'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  Future<void> _loadData() async {
    final token = context.read<AuthProvider>().token ?? '';
    try {
      final results = await Future.wait([
        CachedHttp.get(Uri.parse('https://apifitnflai.com/users/me'),
            headers: {'Authorization': 'Bearer $token'}),
        CachedHttp.get(Uri.parse('https://apifitnflai.com/onboarding/obtener-disciplinas'),
            headers: {'Authorization': 'Bearer $token'}),
      ]);

      if (results[1].statusCode == 200) {
        final list = jsonDecode(results[1].body) as List;
        _disciplinas = list
            .map((e) => (e['nombre'] as String?) ?? '')
            .where((n) => n.isNotEmpty)
            .toList();
      }

      if (results[0].statusCode == 200 && mounted) {
        final d = jsonDecode(results[0].body) as Map<String, dynamic>;
        final nivelIdx = (d['nivel_actividad'] as num?)?.toInt() ?? 1;
        final nombreDisciplina = d['nombre_disciplina'] as String?;
        setState(() {
          if (nombreDisciplina != null && !_disciplinas.contains(nombreDisciplina)) {
            _disciplinas.add(nombreDisciplina);
          }
          _disciplina      = nombreDisciplina ?? (_disciplinas.isNotEmpty ? _disciplinas.first : '');
          _nivelDificultad = _nivelActividad[nivelIdx.clamp(0, 3)];
          final dias = d['dias_entrenamiento'] as List<dynamic>?;
          if (dias != null) {
            _diasEntrenamiento = dias.map((e) => e.toString().toLowerCase()).toList();
          }
          _loading = false;
          _dirty   = false;
        });
      }
    } catch (e) {
      debugPrint('TRAINING SETTINGS LOAD ERROR: $e');
    } finally {
      if (mounted && _loading) setState(() => _loading = false);
    }
  }

  String _getLocalizedDifficulty(BuildContext context, String rawDifficulty) {
    final l10n = AppLocalizations.of(context);
    switch (rawDifficulty) {
      case 'Suave': return l10n.difficultyEasy;
      case 'Moderado': return l10n.difficultyModerate;
      case 'Exigente': return l10n.difficultyChallenging;
      case 'Competitivo': return l10n.difficultyCompetitive;
      default: return rawDifficulty;
    }
  }

  String _getLocalizedDiscipline(BuildContext context, String rawDiscipline) {
    final l10n = AppLocalizations.of(context);
    final lower = rawDiscipline.toLowerCase();
    if (lower.contains('trail')) return l10n.onboardingSportTrailRunning;
    if (lower.contains('triat') || lower.contains('triathlon')) return l10n.onboardingSportTriathlon;
    if (lower.contains('ruta') || lower.contains('road')) return l10n.onboardingSportRoadCycling;
    if (lower.contains('mtb') || lower.contains('mountain')) return l10n.onboardingSportMtb;
    if (lower.contains('sender') || lower.contains('hiking')) return l10n.onboardingSportHiking;
    if (lower.contains('acond') || lower.contains('conditioning')) return l10n.onboardingSportConditioning;
    return rawDiscipline;
  }

  String _getLocalizedWeekday(BuildContext context, int index) {
    final l10n = AppLocalizations.of(context);
    switch (index) {
      case 0: return l10n.weekdayMon;
      case 1: return l10n.weekdayTue;
      case 2: return l10n.weekdayWed;
      case 3: return l10n.weekdayThu;
      case 4: return l10n.weekdayFri;
      case 5: return l10n.weekdaySat;
      case 6: return l10n.weekdaySun;
      default: return '';
    }
  }

  String _getLocalizedTime(BuildContext context, String timeStr) {
    final numStr = RegExp(r'\d+').stringMatch(timeStr) ?? '60';
    final minutes = int.tryParse(numStr) ?? 60;
    return AppLocalizations.of(context).trainingSettingsMinutes(minutes);
  }

  @override
  Widget build(BuildContext context) {
    final isSaving = context.watch<ProfileProvider>().isSaving;
    final theme = context.themeColors;
    final l10n = AppLocalizations.of(context);

    if (_loading) {
      return Scaffold(
        backgroundColor: theme.bg,
        appBar: FitnflaiAppBar(title: l10n.trainingSettingsTitle),
        body: Center(child: CircularProgressIndicator(color: theme.primary)),
      );
    }

    return Scaffold(
      backgroundColor: theme.bg,
      appBar: FitnflaiAppBar(title: l10n.trainingSettingsTitle),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          _SectionLabel(l10n.trainingSettingsSmartAdaptations),
          _SettingsCard(children: [
            _SwitchTile(
              icon: Icons.terrain_outlined,
              label: l10n.trainingSettingsSmartAltitude,
              subtitle: l10n.trainingSettingsSmartAltitudeDesc,
              value: _adaptacionAltura,
              onChanged: (v) => setState(() { _adaptacionAltura = v; _dirty = true; }),
            ),
            _SwitchTile(
              icon: Icons.warning_amber_outlined,
              label: l10n.trainingSettingsInjuryAlerts,
              subtitle: l10n.trainingSettingsInjuryAlertsDesc,
              value: _alertasLesion,
              onChanged: (v) => setState(() { _alertasLesion = v; _dirty = true; }),
              isLast: true,
            ),
          ]),
          const SizedBox(height: 20),

          _SectionLabel(l10n.trainingSettingsPlanPrefs),
          _SettingsCard(children: [
            _DropTile(
              icon: Icons.directions_run_outlined,
              label: l10n.trainingSettingsDiscipline,
              value: _disciplina,
              options: _disciplinas,
              emojis: _disciplinaEmojis,
              displayValueMapper: (v) => _getLocalizedDiscipline(context, v),
              onChanged: (v) => setState(() { _disciplina = v!; _dirty = true; }),
            ),
            _DropTile(
              icon: Icons.speed_outlined,
              label: l10n.trainingSettingsDifficulty,
              value: _nivelDificultad,
              options: _nivelActividad,
              displayValueMapper: (v) => _getLocalizedDifficulty(context, v),
              onChanged: (v) => setState(() { _nivelDificultad = v!; _dirty = true; }),
            ),
            _DropTile(
              icon: Icons.timer_outlined,
              label: l10n.trainingSettingsTimePerSession,
              value: '$_tiempoPorSesion min',
              options: _tiempos.map((t) => '$t min').toList(),
              displayValueMapper: (v) => _getLocalizedTime(context, v),
              onChanged: (v) => setState(() {
                _tiempoPorSesion = int.tryParse(v!.replaceAll(' min', '')) ?? 60;
                _dirty = true;
              }),
              isLast: true,
            ),
          ]),
          const SizedBox(height: 20),

          _SectionLabel(l10n.trainingSettingsTrainingDays),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: theme.border),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(l10n.trainingSettingsSelectDays,
                  style: TextStyle(color: theme.textMuted, fontSize: 12)),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(7, (i) {
                  final key = _diasKeys[i];
                  final sel = _diasEntrenamiento.contains(key);
                  return GestureDetector(
                    onTap: () => setState(() {
                      sel ? _diasEntrenamiento.remove(key)
                          : _diasEntrenamiento.add(key);
                      _dirty = true;
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: 38, height: 38,
                      decoration: BoxDecoration(
                        color: sel ? theme.primary : theme.cardDark,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: sel ? theme.primary : theme.border,
                        ),
                      ),
                      child: Center(child: Text(_getLocalizedWeekday(context, i),
                          style: TextStyle(
                              color: sel ? Colors.white : theme.textMuted,
                              fontSize: 10,
                              fontWeight: sel ? FontWeight.w700 : FontWeight.w400))),
                    ),
                  );
                }),
              ),
            ]),
          ),
          const SizedBox(height: 20),

          _SectionLabel(l10n.trainingSettingsCompetitions),
          _SettingsCard(children: [
            _NavTile(
              icon: Icons.emoji_events_outlined,
              label: l10n.trainingSettingsMyCompetitions,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) =>
                      const CompetitionsScreen())),
              isLast: true,
            ),
          ]),
          const SizedBox(height: 20),

          const SizedBox(height: 32),

          PrimaryButton(
            labelWidget: isSaving
                ? const Center(child: SizedBox(
                    width: 24, height: 24,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  ))
                : Text(l10n.editProfileSave, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            enabled: _dirty && !isSaving,
            onTap: _save,
          ),
        ]),
      ),
    );
  }

  Future<void> _save() async {
    if (!mounted) return;
    final theme = context.themeColors;
    setState(() => _dirty = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(AppLocalizations.of(context).trainingSettingsSaved),
      backgroundColor: theme.successBorder,
    ));
    Navigator.pop(context);
  }
}

// ── Shared components ─────────────────────────────────────────
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

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});
  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;
    return Container(
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.border),
      ),
      child: Column(children: children),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final String label, subtitle;
  final bool value, isLast;
  final ValueChanged<bool> onChanged;
  const _SwitchTile({required this.icon, required this.label,
      required this.subtitle, required this.value, required this.onChanged,
      this.isLast = false});
  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;
    return Column(children: [
      Padding(
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
      ),
      if (!isLast) Divider(color: theme.border, height: 1, indent: 50),
    ]);
  }
}

class _DropTile extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final List<String> options;
  final Map<String, String>? emojis;
  final ValueChanged<String?> onChanged;
  final bool isLast;
  final String Function(String)? displayValueMapper;

  const _DropTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    this.emojis,
    this.isLast = false,
    this.displayValueMapper,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;

    // Asegurar defensivamente que value esté en options para evitar fallos de aserción en DropdownButton
    final safeOptions = List<String>.from(options);
    if (value.isNotEmpty && !safeOptions.contains(value)) {
      safeOptions.add(value);
    }

    final dropdownValue = safeOptions.contains(value) ? value : (safeOptions.isNotEmpty ? safeOptions.first : null);

    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Row(children: [
          Icon(icon, color: theme.textSecondary, size: 20),
          const SizedBox(width: 14),
          Expanded(child: Text(label,
              style: TextStyle(color: theme.text, fontSize: 15))),
          DropdownButton<String>(
            value: dropdownValue,
            dropdownColor: theme.card,
            underline: const SizedBox(),
            style: TextStyle(color: theme.primary, fontSize: 14,
                fontWeight: FontWeight.w600),
            icon: Icon(Icons.keyboard_arrow_down, color: theme.textMuted, size: 18),
            selectedItemBuilder: (context) => safeOptions.map((o) {
              final mapped = displayValueMapper != null ? displayValueMapper!(o) : o;
              return Center(child: Text(emojis != null ? '${emojis![o] ?? ''} $mapped' : mapped,
                  style: TextStyle(color: theme.primary, fontSize: 14,
                      fontWeight: FontWeight.w600)));
            }).toList(),
            items: safeOptions.map((o) {
              final mapped = displayValueMapper != null ? displayValueMapper!(o) : o;
              return DropdownMenuItem(
                value: o,
                child: emojis != null
                    ? Row(children: [
                        Text(emojis![o] ?? '', style: const TextStyle(fontSize: 16)),
                        const SizedBox(width: 8),
                        Text(mapped, style: TextStyle(color: theme.text)),
                      ])
                    : Text(mapped, style: TextStyle(color: theme.text)),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ]),
      ),
      if (!isLast) Divider(color: theme.border, height: 1, indent: 50),
    ]);
  }
}

class _NavTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isLast;
  const _NavTile({required this.icon, required this.label,
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
