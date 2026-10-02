import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../config/app_colors.dart';
import '../../config/app_routes.dart';
import '../../config/onboarding_router.dart'; // Added
import '../../providers/auth_provider.dart';
import '../../widgets/shared_widgets.dart';
import '../../services/cached_http.dart';

class Step3FitnessScreen extends StatefulWidget {
  const Step3FitnessScreen({super.key});
  @override
  State<Step3FitnessScreen> createState() => _Step3FitnessScreenState();
}

class _Step3FitnessScreenState extends State<Step3FitnessScreen> {
  // Nivel de actividad — -1 = ninguno
  int _actLevel = -1;

  // Tiempo por sesión — -1 = ninguno
  int _sessionTime = -1;
  final _sessionTimes = ['30 min', '45 min', '60-90 min', '+90 min'];

  // Equipamiento — Set de id_implemento reales del backend
  final Set<int> _equipment = {};
  List<Map<String, dynamic>> _equipmentList = [];
  bool _loadingEquipment = true;

  // Días disponibles — ninguno seleccionado
  final List<bool> _days = [false, false, false, false, false, false, false];

  // Experiencia — -1 = no seleccionado
  int _yearsIdx = -1;
  final _yearOptions = ['< 1 año', '1-2 años', '3-5 años', '5-10 años', '+10 años'];
  bool _competed = false;

  // ¿Te ejercitas actualmente?
  bool? _ejercitaActualmente; // null = sin respuesta
  int _inactivityIdx = -1;
  final _inactivityOptions = [
    'Menos de 1 mes',
    '1-3 meses',
    '3-6 meses',
    '6 meses - 1 año',
    '1-2 años',
    'Más de 2 años',
  ];

  // Fecha de inicio
  DateTime? _fechaInicio;

  int get _daysSelected => _days.where((d) => d).length;

  // Validación — todos los obligatorios llenos
  bool get _isValid {
    if (_actLevel < 0 || _sessionTime < 0 || _daysSelected == 0) return false;
    if (_fechaInicio == null) return false;
    if (_ejercitaActualmente == null) return false;
    if (_ejercitaActualmente == true  && _yearsIdx < 0) return false;
    if (_ejercitaActualmente == false && _inactivityIdx < 0) return false;
    return true;
  }

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadEquipment();
  }

  Future<void> _loadEquipment() async {
    try {
      final token = context.read<AuthProvider>().token;
      final response = await CachedHttp.get(
        Uri.parse('https://apifitnflai.com/onboarding/equipments'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _equipmentList = data.cast<Map<String, dynamic>>();
          _loadingEquipment = false;
        });
        return;
      }
    } catch (_) {}
    setState(() => _loadingEquipment = false);
  }

  static const _dayLabels = ['lunes','martes','miércoles','jueves','viernes','sábado','domingo'];

  String _monthName(BuildContext context, int m) {
    final locale = Localizations.localeOf(context).languageCode;
    final monthsEs = ['ene','feb','mar','abr','may','jun','jul','ago','sep','oct','nov','dic'];
    final monthsEn = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return locale == 'es' ? monthsEs[m - 1] : monthsEn[m - 1];
  }

  List<String> _getLocalizedActLevels(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return locale == 'es'
        ? ['Sedentario', 'Recreativo', 'Activo', 'Competitivo']
        : ['Sedentary', 'Recreational', 'Active', 'Competitive'];
  }

  List<String> _getLocalizedActDescriptions(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return locale == 'es'
        ? [
            'Sedentario: poca o ninguna actividad física regular.',
            'Recreativo: entrenas de vez en cuando, sin rutina fija.',
            'Activo: entrenas 3-5 veces por semana regularmente.',
            'Competitivo: entrenas con objetivos de rendimiento alto.',
          ]
        : [
            'Sedentary: little or no regular physical activity.',
            'Recreational: you train occasionally, without a fixed routine.',
            'Active: you train 3-5 times a week regularly.',
            'Competitive: you train with high performance goals.',
          ];
  }

  List<String> _getLocalizedYearOptions(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return locale == 'es'
        ? ['< 1 año', '1-2 años', '3-5 años', '5-10 años', '+10 años']
        : ['< 1 year', '1-2 years', '3-5 years', '5-10 years', '+10 years'];
  }

  List<String> _getLocalizedInactivityOptions(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return locale == 'es'
        ? [
            'Menos de 1 mes',
            '1-3 meses',
            '3-6 meses',
            '6 meses - 1 año',
            '1-2 años',
            'Más de 2 años',
          ]
        : [
            'Less than 1 month',
            '1-3 months',
            '3-6 months',
            '6 months - 1 year',
            '1-2 years',
            'More than 2 years',
          ];
  }

  List<String> _getLocalizedDayNames(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return locale == 'es'
        ? ['L', 'M', 'M', 'J', 'V', 'S', 'D']
        : ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  }

  Future<void> _saveAndContinue() async {
    final authProvider = context.read<AuthProvider>();
    final token = authProvider.token;
    final userId = authProvider.user?.id;
    setState(() => _loading = true);
    try {

      // Días en español minúscula
      final diasDisponibles = <String>[];
      for (int i = 0; i < _days.length; i++) {
        if (_days[i]) diasDisponibles.add(_dayLabels[i]);
      }

      // IDs reales de equipamiento del backend (id_implemento)
      final equipIds = _equipment.toList();

      final body = {
        'anos_entrenando':      _ejercitaActualmente == true && _yearsIdx >= 0
            ? _yearOptions[_yearsIdx] : '0',
        'ha_competido_antes':   _competed,
        'nivel_actividad':      _actLevel,
        'tiempo_por_sesion':    _sessionTimes[_sessionTime],
        'equipamiento_ids':     equipIds,
        'dias_disponibles':     diasDisponibles,
        'fecha_inicio_deseada': () {
          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);
          final fecha = _fechaInicio ?? today;
          // Garantiza que sea siempre hoy o posterior
          final fechaFinal = fecha.isBefore(today) ? today : fecha;
          return '${fechaFinal.year}-${fechaFinal.month.toString().padLeft(2,'0')}-${fechaFinal.day.toString().padLeft(2,'0')}';
        }(),
        'tiempo_sin_entrenar':  _ejercitaActualmente == false && _inactivityIdx >= 0
            ? _inactivityOptions[_inactivityIdx] : '0',
      };

      final res = await http.post(
        Uri.parse('https://apifitnflai.com/onboarding/save-fitness-state-data'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );
      debugPrint('STEP4 RESPONSE: ${res.statusCode} ${res.body}');
      if (res.statusCode != 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context).onboardingSaveError(res.statusCode)),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }
      // Save completed step 3 after successful API response
      if (userId != null) {
        await OnboardingRouter.saveCompletedStep(userId, 3);
      }
    } catch (e) {
      debugPrint('STEP4 ERROR: $e');
      return;
    } finally {
      setState(() => _loading = false);
    }
    if (!mounted) return;
    if (_fechaInicio != null) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final fechaFinal = _fechaInicio!.isBefore(today) ? today : _fechaInicio!;
      context.read<AuthProvider>().onboardingFechaInicio =
          '${fechaFinal.year}-${fechaFinal.month.toString().padLeft(2,'0')}-${fechaFinal.day.toString().padLeft(2,'0')}';
    }
    Navigator.pushNamed(context, AppRoutes.step4Body);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final actLevels = _getLocalizedActLevels(context);
    final actDescriptions = _getLocalizedActDescriptions(context);
    final dayNames = _getLocalizedDayNames(context);
    final yearOptions = _getLocalizedYearOptions(context);
    final inactivityOptions = _getLocalizedInactivityOptions(context);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(children: [
          const StepHeader(stepLabel: 'Paso 2 de 6'),
          const SizedBox(height: 16),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(children: [
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    l10n.onboardingFitnessScreenTitle,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ── Nivel de actividad ────────────
                _SectionCard(
                  title: l10n.onboardingFitnessActivityTitle,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: List.generate(actLevels.length, (i) =>
                          _Chip(
                            label: actLevels[i],
                            selected: _actLevel == i,
                            onTap: () => setState(() => _actLevel = i),
                          ),
                        ),
                      ),
                      if (_actLevel >= 0) ...[
                        const SizedBox(height: 10),
                        Text(
                          actDescriptions[_actLevel],
                          style: const TextStyle(
                              color: AppColors.grey, fontSize: 13, height: 1.4),
                        ),
                      ],
                    ],
                  ),
                ),

                // ── Tiempo por sesión ─────────────
                _SectionCard(
                  title: l10n.onboardingFitnessSessionTitle,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(_sessionTimes.length, (i) =>
                      _Chip(
                        label: _sessionTimes[i],
                        selected: _sessionTime == i,
                        onTap: () => setState(() => _sessionTime = i),
                      ),
                    ),
                  ),
                ),

                // ── Equipamiento ──────────────────
                _SectionCard(
                  title: l10n.onboardingFitnessEquipmentTitle,
                  badge: _OptionalBadge(),
                  child: _loadingEquipment
                      ? const Center(child: Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(color: AppColors.orange),
                        ))
                      : Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _equipmentList.map((e) {
                            final id = e['id_implemento'] as int;
                            final nombre = e['nombre'] as String;
                            return _Chip(
                              label: nombre,
                              selected: _equipment.contains(id),
                              onTap: () => setState(() {
                                _equipment.contains(id)
                                    ? _equipment.remove(id)
                                    : _equipment.add(id);
                              }),
                            );
                          }).toList(),
                        ),
                ),

                // ── Días disponibles ──────────────
                _SectionCard(
                  title: l10n.onboardingFitnessDaysTitle,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(7, (i) => _DayCircle(
                          label: dayNames[i],
                          selected: _days[i],
                          onTap: () => setState(() => _days[i] = !_days[i]),
                        )),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _daysSelected == 0
                            ? l10n.onboardingFitnessDaysSelectAtLeastOne
                            : (_daysSelected == 1
                                ? l10n.onboardingFitnessDaysSelected(_daysSelected)
                                : l10n.onboardingFitnessDaysSelectedPlural(_daysSelected)),
                        style: TextStyle(
                            color: _daysSelected == 0
                                ? AppColors.grey
                                : AppColors.greenText,
                            fontSize: 13),
                      ),
                    ],
                  ),
                ),

                // ── Cuando quieres iniciar ────────
                _SectionCard(
                  title: l10n.onboardingFitnessStartTitle,
                  child: Row(children: [
                    Expanded(
                      child: Text(l10n.onboardingFitnessStartDate,
                          style: const TextStyle(
                              color: AppColors.greyLight, fontSize: 14)),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final now = DateTime.now();
                        final today = DateTime(now.year, now.month, now.day);
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _fechaInicio ?? today,
                          firstDate: today,
                          lastDate: today.add(const Duration(days: 365)),
                          builder: (ctx, child) => Theme(
                            data: Theme.of(ctx).copyWith(
                              colorScheme: const ColorScheme.dark(
                                primary: AppColors.orange,
                                surface: AppColors.card,
                              ),
                            ),
                            child: child!,
                          ),
                        );
                        if (picked != null) setState(() => _fechaInicio = picked);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.cardDark,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Text(
                            _fechaInicio != null
                                ? '${_fechaInicio!.day} ${_monthName(context, _fechaInicio!.month)} ${_fechaInicio!.year}'
                                : l10n.onboardingFitnessSelect,
                            style: TextStyle(
                                color: _fechaInicio != null
                                    ? AppColors.white
                                    : AppColors.grey,
                                fontSize: 14),
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.keyboard_arrow_down,
                              color: AppColors.orange, size: 18),
                        ]),
                      ),
                    ),
                  ]),
                ),

                // ── Experiencia ───────────────────
                _SectionCard(
                  title: l10n.onboardingFitnessExperienceTitle,
                  child: Column(children: [
                    // ¿Te ejercitas actualmente?
                    Row(children: [
                      Expanded(
                        child: Text(l10n.onboardingFitnessExercisingNow,
                            style: const TextStyle(
                                color: AppColors.greyLight, fontSize: 14)),
                      ),
                      _YesNoToggle(
                        value: _ejercitaActualmente,
                        onChanged: (v) => setState(() {
                          _ejercitaActualmente = v;
                          _yearsIdx       = -1;
                          _inactivityIdx  = -1;
                        }),
                      ),
                    ]),

                    // Si SÍ → años entrenando
                    if (_ejercitaActualmente == true) ...[
                      const Divider(color: AppColors.border, height: 24),
                      Row(children: [
                        Expanded(
                          child: Text(l10n.onboardingFitnessYearsTraining,
                              style: const TextStyle(
                                  color: AppColors.greyLight, fontSize: 14)),
                        ),
                        GestureDetector(
                          onTap: () => _showPicker(
                            context,
                            title: l10n.onboardingFitnessYearsTraining,
                            options: yearOptions,
                            selectedIdx: _yearsIdx,
                            onSelected: (i) => setState(() => _yearsIdx = i),
                          ),
                          child: _DropdownButton(
                            label: _yearsIdx >= 0
                                ? yearOptions[_yearsIdx] : l10n.onboardingFitnessSelect,
                            selected: _yearsIdx >= 0,
                          ),
                        ),
                      ]),
                    ],

                    // Si NO → desde cuándo no se ejercita
                    if (_ejercitaActualmente == false) ...[
                      const Divider(color: AppColors.border, height: 24),
                      Row(children: [
                        Expanded(
                          child: Text(l10n.onboardingFitnessInactivityDuration,
                              style: const TextStyle(
                                  color: AppColors.greyLight, fontSize: 14)),
                        ),
                        GestureDetector(
                          onTap: () => _showPicker(
                            context,
                            title: l10n.onboardingFitnessInactivityDuration,
                            options: inactivityOptions,
                            selectedIdx: _inactivityIdx,
                            onSelected: (i) => setState(() => _inactivityIdx = i),
                          ),
                          child: _DropdownButton(
                            label: _inactivityIdx >= 0
                                ? inactivityOptions[_inactivityIdx] : l10n.onboardingFitnessSelect,
                            selected: _inactivityIdx >= 0,
                          ),
                        ),
                      ]),
                    ],

                    const Divider(color: AppColors.border, height: 24),
                    Row(children: [
                      Expanded(
                        child: Text(l10n.onboardingFitnessCompetedBefore,
                            style: const TextStyle(
                                color: AppColors.greyLight, fontSize: 14)),
                      ),
                      Switch(
                        value: _competed,
                        onChanged: (v) => setState(() => _competed = v),
                        activeThumbColor: AppColors.orange,
                        activeTrackColor: const Color(0xFF8B3A15),
                        inactiveThumbColor: AppColors.grey,
                        inactiveTrackColor: const Color(0xFF3A3A3A),
                      ),
                    ]),
                  ]),
                ),

                const SizedBox(height: 8),
              ]),
            ),
          ),

          // ── Continue button ──────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: _loading
                ? const Center(child: CircularProgressIndicator(color: AppColors.orange))
                : PrimaryButton(
                    labelWidget: Text(l10n.onboardingContinue, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    enabled: _isValid,
                    onTap: _saveAndContinue,
                  ),
          ),
        ]),
      ),
    );
  }

  void _showPicker(
    BuildContext context, {
    required String title,
    required List<String> options,
    required int selectedIdx,
    required ValueChanged<int> onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title,
                style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            ...options.asMap().entries.map((e) => ListTile(
              title: Text(e.value,
                  style: const TextStyle(color: AppColors.white, fontSize: 15)),
              trailing: e.key == selectedIdx
                  ? const Icon(Icons.check, color: AppColors.orange)
                  : null,
              onTap: () {
                onSelected(e.key);
                Navigator.pop(context);
              },
            )),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// YES / NO TOGGLE
// ═══════════════════════════════════════════════════════════════
class _YesNoToggle extends StatelessWidget {
  final bool? value;
  final ValueChanged<bool> onChanged;
  const _YesNoToggle({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
    _btn('Sí',  true,  value == true),
    const SizedBox(width: 8),
    _btn('No', false, value == false),
  ]);

  Widget _btn(String label, bool btnVal, bool selected) => GestureDetector(
    onTap: () => onChanged(btnVal),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF8B3A15) : AppColors.cardDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: selected ? AppColors.orange : AppColors.border,
          width: selected ? 1.5 : 1,
        ),
      ),
      child: Text(label,
          style: TextStyle(
              color: selected ? AppColors.orange : AppColors.grey,
              fontSize: 13,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w400)),
    ),
  );
}

// ═══════════════════════════════════════════════════════════════
// DROPDOWN BUTTON (reutilizable)
// ═══════════════════════════════════════════════════════════════
class _DropdownButton extends StatelessWidget {
  final String label;
  final bool selected;
  const _DropdownButton({required this.label, required this.selected});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    decoration: BoxDecoration(
      color: AppColors.cardDark,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        color: selected ? AppColors.orange : AppColors.border,
        width: selected ? 1.5 : 1,
      ),
    ),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Text(label,
          style: TextStyle(
              color: selected ? AppColors.white : AppColors.grey,
              fontSize: 14)),
      const SizedBox(width: 6),
      const Icon(Icons.keyboard_arrow_down, color: AppColors.orange, size: 18),
    ]),
  );
}

// ═══════════════════════════════════════════════════════════════
// SECTION CARD
// ═══════════════════════════════════════════════════════════════
class _SectionCard extends StatelessWidget {
  final String title;
  final Widget? badge;
  final Widget child;
  const _SectionCard({required this.title, this.badge, required this.child});

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 14),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
        color: AppColors.card, borderRadius: BorderRadius.circular(14)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Expanded(
          child: Text(title,
              style: const TextStyle(
                  color: AppColors.orange,
                  fontSize: 15,
                  fontWeight: FontWeight.w700)),
        ),
        badge ?? _ObligatoryBadge(),
      ]),
      const SizedBox(height: 14),
      child,
    ]),
  );
}

// ═══════════════════════════════════════════════════════════════
// CHIP
// ═══════════════════════════════════════════════════════════════
class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _Chip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      decoration: BoxDecoration(
        color: selected ? Colors.transparent : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: selected ? AppColors.orange : AppColors.border,
          width: selected ? 2 : 1,
        ),
      ),
      child: Text(label,
          style: TextStyle(
              color: selected ? AppColors.orange : AppColors.greyLight,
              fontSize: 13,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w400)),
    ),
  );
}

// ═══════════════════════════════════════════════════════════════
// DAY CIRCLE
// ═══════════════════════════════════════════════════════════════
class _DayCircle extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _DayCircle({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 40, height: 40,
      decoration: BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? AppColors.orange : AppColors.border,
          width: selected ? 2 : 1,
        ),
      ),
      child: Center(
        child: Text(label,
            style: TextStyle(
                color: selected ? AppColors.orange : AppColors.greyLight,
                fontSize: 14,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w400)),
      ),
    ),
  );
}

class _OptionalBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    padding:
        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
        color: AppColors.greenBg,
        borderRadius: BorderRadius.circular(20)),
    child: Row(mainAxisSize: MainAxisSize.min, children: const [
      CircleAvatar(radius: 3, backgroundColor: AppColors.greenText),
      SizedBox(width: 5),
      Text('Opcional',
          style: TextStyle(
              color: AppColors.greenText,
              fontSize: 11,
              fontWeight: FontWeight.w600)),
    ]),
  );
}

// ═══════════════════════════════════════════════════════════════
// OBLIGATORY BADGE
// ═══════════════════════════════════════════════════════════════
class _ObligatoryBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
        color: const Color(0xFF3A1515),
        borderRadius: BorderRadius.circular(20)),
    child: Row(mainAxisSize: MainAxisSize.min, children: const [
      CircleAvatar(radius: 3, backgroundColor: AppColors.redText),
      SizedBox(width: 5),
      Text('Obligatorio',
          style: TextStyle(
              color: AppColors.redText,
              fontSize: 11,
              fontWeight: FontWeight.w600)),
    ]),
  );
}
