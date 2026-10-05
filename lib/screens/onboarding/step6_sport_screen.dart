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

// ─── Models ────────────────────────────────────────────────────
class SportOption {
  final String name;
  final String subtitle;
  final String emoji;
  bool selected;

  SportOption({
    required this.name,
    required this.subtitle,
    required this.emoji,
    this.selected = false,
  });
}

class GoalOption {
  final String title;
  final String subtitle;
  final String emoji;
  bool selected;

  GoalOption({
    required this.title,
    required this.subtitle,
    required this.emoji,
    this.selected = false,
  });
}

// ─── Screen ────────────────────────────────────────────────────
class Step6SportScreen extends StatefulWidget {
  const Step6SportScreen({super.key});

  @override
  State<Step6SportScreen> createState() => _Step6SportScreenState();
}

class _Step6SportScreenState extends State<Step6SportScreen> {
  // Índice del deporte seleccionado (-1 = ninguno)
  int _selectedSportIdx = -1;

  final List<SportOption> _sports = [
    SportOption(name: 'Trail running',     subtitle: 'Carrera en montaña y senderos.', emoji: '🏃‍♀️'),
    SportOption(name: 'Triatlón',          subtitle: 'Nado, bici, carrera.',           emoji: '🚴'),
    SportOption(name: 'Ciclismo de ruta',  subtitle: 'Ruta y velocidad.',              emoji: '🚴'),
    SportOption(name: 'MTB',              subtitle: 'Ciclismo de montaña.',             emoji: '🚵'),
    SportOption(name: 'Senderismo',        subtitle: 'Caminatas y trekking.',           emoji: '🥾'),
    SportOption(name: 'Acondicionamiento', subtitle: 'Fitness y fuerza general.',       emoji: '💪'),
  ];

  // Índice del objetivo seleccionado (-1 = ninguno)
  int _selectedGoalIdx = -1;

  // Opciones de competencia por disciplina (índice = _selectedSportIdx)
  static const _competenciaOpciones = <int, List<String>>{
    0: [ // Trail running
      '5 Kilómetros',
      '10 Kilómetros',
      'Media Maratón (21K)',
      'Maratón (42K)',
      'Otro',
    ],
    1: [ // Triatlón
      'Sprint (750m/20km/5km)',
      'Olímpico (1.5km/40km/10km)',
      'Ironman 70.3',
      'Ironman Completo',
      'Otro',
    ],
    2: [ // Ciclismo de ruta
      'Paseo / Salud (30–60 km)',
      'Fondo medio (80–120 km)',
      'Gran Fondo (160–200 km)',
      'Altitud ≥2500m (Altitud Inteligente)',
      'Otro',
    ],
    3: [ // MTB
      'MTB Cross-Country (XC) — terreno moderado <30 km',
      'MTB Cross-Country (XC) largo 30–60 km',
      'MTB Enduro / Trail técnico (descensos, drops, roots)',
      'MTB Descenso (DH) puro',
      'Ajuste altitud ≥2500m (Altitud Inteligente)',
      'Otro',
    ],
    4: [ // Senderismo
      'Senderismo suave (<5 km, desnivel <200m)',
      'Senderismo moderado (5–15 km, desnivel 200–800m)',
      'Senderismo exigente (15–25 km, desnivel 800–1500m)',
      'Trekking / Expedición (>25 km/día, desnivel >1500m o multiday)',
      'Ajuste altitud ≥3500m (Altitud Inteligente)',
      'Otro',
    ],
    // índice 5 = Acondicionamiento — sin opciones de competencia
  };

  // Competencia seleccionada del dropdown
  String? _selectedCompetencia;

  // Goal 0: Competencia
  DateTime? _raceDate;
  final _raceNameCtrl = TextEditingController();
  final _raceDistCtrl = TextEditingController();
  String _raceDistUnit = 'km';

  // Goal 1: Mejorar tiempo personal
  final _timeDistCtrl = TextEditingController();
  String _timeDistUnit = 'km';
  int _timeHours = 0;
  int _timeMin   = 0;
  int _timeSec   = 0;
  // Tiempo objetivo
  int _timeTargetHours = 0;
  int _timeTargetMin   = 0;
  int _timeTargetSec   = 0;

  // Goal 2: Mejorar condición general
  final _condicionCtrl = TextEditingController();
  String? _condicionCategoria;
  String? _condicionSubcategoria;

  // Semanas
  int _semanas = 18;
  final _semanasOptions = List.generate(51, (i) => i + 2); // 2..52

  static const List<String> _months = [
    '', 'ene', 'feb', 'mar', 'abr', 'may',
    'jun', 'jul', 'ago', 'sep', 'oct', 'nov', 'dic'
  ];

  final List<GoalOption> _goals = [
    GoalOption(
      title: 'Prepararme para una competencia',
      subtitle: 'Tengo una fecha objetivo en mente',
      emoji: '🏆',
    ),
    GoalOption(
      title: 'Mejorar mi tiempo personal',
      subtitle: 'Ya compito, quiero ser más rápido',
      emoji: '⏱️',
    ),
    GoalOption(
      title: 'Mejorar mi condición general',
      subtitle: 'Sin competencia específica por ahora',
      emoji: '🌱',
    ),
  ];

  bool get _isValid {
    if (_selectedSportIdx < 0 || _selectedGoalIdx < 0) return false;
    if (_selectedGoalIdx == 0) {
      final comp = _selectedCompetencia;
      if (comp == null) return false;
      if (comp == 'Otro') {
        if (!(_raceNameCtrl.text.isNotEmpty && _raceDate != null && _raceDistCtrl.text.isNotEmpty)) return false;
      } else {
        if (_raceDate == null) return false;
      }
      // Bloquear si hay alerta y no fue aceptada
      if (_showRiskAlert && !_riskAccepted) return false;
      return true;
    }
    if (_selectedGoalIdx == 1) {
      if (_showSemanasAlert && !_semanasRiskAccepted) return false;
      if (_targetExceedsActual) return false;
      return _timeDistCtrl.text.isNotEmpty &&
             (_timeHours > 0 || _timeMin > 0 || _timeSec > 0);
    }
    if (_selectedGoalIdx == 2) {
      if (_showSemanasAlert && !_semanasRiskAccepted) return false;
      return _condicionCategoria != null && _condicionSubcategoria != null;
    }
    return false;
  }
  bool get _showDatePicker => false; // handled inline now

  // Tiempo objetivo >= tiempo actual → no es mejora
  int get _actualTotalSecs  => _timeHours * 3600 + _timeMin * 60 + _timeSec;
  bool get _targetExceedsActual =>
      _selectedGoalIdx == 1 &&
      _actualTotalSecs > 0 &&
      _timeTargetHours * 3600 + _timeTargetMin * 60 + _timeTargetSec >= _actualTotalSecs;

  int get _weeksUntilRace =>
      _raceDate != null
          ? _raceDate!.difference(DateTime.now()).inDays ~/ 7
          : 0;

  void _selectSport(int i) => setState(() {
    _selectedSportIdx = i;
    _selectedCompetencia = null;
    // Si elige Acondicionamiento y tenía goal 0 seleccionado, lo resetea
    if (i == 5 && _selectedGoalIdx == 0) _selectedGoalIdx = -1;
  });
  void _selectGoal(int i)  => setState(() => _selectedGoalIdx  = i);

  bool _loading = false;
  bool _riskAccepted = false;
  bool _semanasRiskAccepted = false;
  final ScrollController _scrollCtrl = ScrollController();

  // Semanas mínimas recomendadas por [sportIdx][competencia][nivelActividad]
  // nivel: 0=sedentario, 1=principiante, 2=intermedio, 3=avanzado
  static const _minWeeks = <int, Map<String, List<int>>>{
    0: { // Trail running
      '5 Kilómetros':        [10, 5, 3, 2],
      '10 Kilómetros':       [16, 10, 6, 3],
      'Media Maratón (21K)': [28, 20, 14, 8],
      'Maratón (42K)':       [52, 36, 24, 16],
    },
    1: { // Triatlón
      'Sprint (750m/20km/5km)':    [20, 12, 8, 4],
      'Olímpico (1.5km/40km/10km)':[32, 24, 16, 10],
      'Ironman 70.3':              [52, 40, 28, 20],
      'Ironman Completo':          [104, 80, 60, 40],
    },
    2: { // Ciclismo
      'Paseo / Salud (30–60 km)':  [4, 2, 0, 0],
      'Fondo medio (80–120 km)':   [16, 10, 6, 3],
      'Gran Fondo (160–200 km)':   [28, 20, 14, 8],
    },
    3: { // MTB
      'MTB Cross-Country (XC) — terreno moderado <30 km': [8, 4, 2, 0],
      'MTB Cross-Country (XC) largo 30–60 km':            [16, 10, 6, 3],
      'MTB Enduro / Trail técnico (descensos, drops, roots)': [20, 16, 10, 4],
      'MTB Descenso (DH) puro':                           [999, 999, 20, 8],
    },
    4: { // Senderismo
      'Senderismo suave (<5 km, desnivel <200m)':          [0, 0, 0, 0],
      'Senderismo moderado (5–15 km, desnivel 200–800m)':  [6, 3, 1, 0],
      'Senderismo exigente (15–25 km, desnivel 800–1500m)':[12, 8, 4, 2],
      'Trekking / Expedición (>25 km/día, desnivel >1500m o multiday)': [20, 14, 8, 4],
    },
  };

  int _nivelIndex(String? nivel) {
    switch (nivel) {
      case 'sedentario':   return 0;
      case 'principiante': return 1;
      case 'intermedio':   return 2;
      case 'avanzado':     return 3;
      default:             return 0;
    }
  }

  /// Semanas mínimas necesarias según deporte + competencia + nivel
  int get _requiredWeeks {
    final comp = _selectedCompetencia;
    if (comp == null || comp == 'Otro') return 0;
    final sportMap = _minWeeks[_selectedSportIdx];
    if (sportMap == null) return 0;
    final levels = sportMap[comp];
    if (levels == null) return 0;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    // ignore: invalid_use_of_protected_member — usa nivelActividad si existe, si no nivel 0
    final String? nivel = authProvider.nivelActividad;
    return levels[_nivelIndex(nivel)];
  }

  /// Mínimo de semanas para el selector según deporte + objetivo + nivel
  /// Reutiliza _minWeeks para goal 0 (competencia) y agrega tabla propia para goals 1/2
  int get _minSemanasRequeridas {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final ni = _nivelIndex(authProvider.nivelActividad);
    // Para goal 0 con competencia seleccionada
    if (_selectedGoalIdx == 0 && _selectedCompetencia != null && _selectedCompetencia != 'Otro') {
      return _requiredWeeks;
    }
    // Para goal 1 / goal 2 — mínimos generales por deporte y nivel
    // [nivel0, nivel1, nivel2, nivel3]
    const generalMins = <int, List<int>>{
      0: [10, 6, 4, 2],  // Trail running
      1: [12, 8, 6, 4],  // Triatlón
      2: [6,  4, 2, 2],  // Ciclismo
      3: [8,  4, 2, 2],  // MTB
      4: [4,  2, 1, 1],  // Senderismo
      5: [4,  2, 2, 1],  // Acondicionamiento
    };
    return generalMins[_selectedSportIdx]?[ni] ?? 2;
  }

  bool get _showSemanasAlert =>
      _selectedSportIdx >= 0 &&
      _semanas < _minSemanasRequeridas;

  /// Semanas reales disponibles desde hoy hasta un día antes de la competencia
  int get _weeksAvailableForRace =>
      _raceDate != null
          ? (_raceDate!.subtract(const Duration(days: 1)))
                .difference(DateTime.now())
                .inDays ~/
              7
          : 0;

  bool get _showRiskAlert =>
      _selectedGoalIdx == 0 &&
      _raceDate != null &&
      _selectedCompetencia != null &&
      _selectedCompetencia != 'Otro' &&
      _weeksAvailableForRace < _requiredWeeks;


  // IDs del backend — ajustar cuando se conozcan los UUIDs reales
  static const _sportIds = [
    '1', '4', '2', '3', '5', '6',
  ];
  static const _goalIds = [
    'f7ed624a-0873-488a-acaa-32b53718d5fc', 'c40ff70d-9f95-4a1e-9aa4-03a5b9f232fb', '252e0cf2-d36a-4e71-a950-46f23b83914b',
  ];

  Future<void> _saveAndContinue() async {
    final authProvider = context.read<AuthProvider>();
    final token = authProvider.token;
    final userId = authProvider.user?.id;
    setState(() => _loading = true);

    // Helpers de tiempo en ISO 8601 duration-like string "HH:MM:SS"
    String toTimeStr(int h, int m, int s) =>
        '${h.toString().padLeft(2,'0')}:${m.toString().padLeft(2,'0')}:${s.toString().padLeft(2,'0')}';

    // Si es competencia, la duración en semanas es igual a las semanas disponibles para la competencia
    if (_selectedGoalIdx == 0) {
      _semanas = _weeksAvailableForRace;
    }

    try {

      // ── Campos comunes ──────────────────────────────────────
      final body = <String, dynamic>{
        'disciplina_ids':           [int.tryParse(_sportIds[_selectedSportIdx]) ?? _sportIds[_selectedSportIdx]],
        'id_objetivo':              _goalIds[_selectedGoalIdx],
        'duracion_semanas_objetivo': _semanas,
      };

      // ── Goal 0: Competencia ─────────────────────────────────
      if (_selectedGoalIdx == 0) {
        final comp = _selectedCompetencia ?? '';
        body['nombre_competencia'] = comp == 'Otro'
            ? _raceNameCtrl.text.trim()
            : comp;

        if (_raceDate != null) {
          body['fecha_competencia'] = _raceDate!.toIso8601String().split('T')[0];
        }

        // Distancia: si es 'Otro' usa el campo manual; si no, extraemos número del nombre
        if (comp == 'Otro' && _raceDistCtrl.text.isNotEmpty) {
          body['distancia_objetivo'] = double.tryParse(_raceDistCtrl.text) ?? 0;
          body['unidad_distancia']   = _raceDistUnit;
        } else {
          // Intenta extraer km del nombre de la competencia (ej. "5 Kilómetros" → 5)
          final match = RegExp(r'(\d+(?:\.\d+)?)').firstMatch(comp);
          if (match != null) {
            body['distancia_objetivo'] = double.tryParse(match.group(1)!) ?? 0;
            body['unidad_distancia']   = 'km';
          }
        }
      }

      // ── Goal 1: Mejorar tiempo ──────────────────────────────
      if (_selectedGoalIdx == 1) {
        if (_timeDistCtrl.text.isNotEmpty) {
          body['distancia_objetivo'] = double.tryParse(_timeDistCtrl.text) ?? 0;
          body['unidad_distancia']   = _timeDistUnit;
        }
        if (_timeHours > 0 || _timeMin > 0 || _timeSec > 0) {
          body['tiempo_actual'] = toTimeStr(_timeHours, _timeMin, _timeSec);
        }
        if (_timeTargetHours > 0 || _timeTargetMin > 0 || _timeTargetSec > 0) {
          body['tiempo_meta'] = toTimeStr(_timeTargetHours, _timeTargetMin, _timeTargetSec);
        }
      }

      // ── Goal 2: Condición general ───────────────────────────
      if (_selectedGoalIdx == 2) {
        if (_condicionCategoria != null) {
          body['que_quieres_mejorar_cg'] = _condicionCategoria;
        }
        if (_condicionSubcategoria != null) {
          body['objetivo_especifico_cg'] = _condicionSubcategoria;
        }
      }

      final response = await http.post(
        Uri.parse('https://apifitnflai.com/onboarding/save-discipline-event-objective-data'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );
      debugPrint('SAVE RESPONSE: ${response.statusCode} ${response.body}');

      if (response.statusCode != 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context).onboardingSaveError(response.statusCode)),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }
      // Save completed step 6 after successful API response
      if (userId != null) {
        await OnboardingRouter.saveCompletedStep(userId, 6);
      }
    } catch (e) {
      debugPrint('SAVE ERROR: $e');
      return;
    } finally {
      setState(() => _loading = false);
    }
    if (!mounted) return;
    context.read<AuthProvider>().onboardingSemanas = _semanas;
    Navigator.pushNamed(context, AppRoutes.generating);
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: _raceDate ?? today,
      firstDate: today,
      lastDate: DateTime(2028),
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
    if (picked != null && mounted) setState(() => _raceDate = picked);
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  String _getSportName(BuildContext context, String rawName) {
    final l10n = AppLocalizations.of(context);
    switch (rawName) {
      case 'Trail running':
        return l10n.onboardingSportTrailRunning;
      case 'Triatlón':
      case 'Triathlon':
        return l10n.onboardingSportTriathlon;
      case 'Ciclismo de ruta':
      case 'Road cycling':
        return l10n.onboardingSportRoadCycling;
      case 'MTB':
        return l10n.onboardingSportMtb;
      case 'Senderismo':
      case 'Hiking':
        return l10n.onboardingSportHiking;
      case 'Acondicionamiento':
      case 'Conditioning':
        return l10n.onboardingSportConditioning;
      default:
        return rawName;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEs = Localizations.localeOf(context).languageCode == 'es';
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.bg,
        body: SafeArea(
          child: Column(children: [
            // ── Top bar ──────────────────────────────
            const StepHeader(stepLabel: 'Paso 5 de 6'),
            const SizedBox(height: 16),
  
            // ── Scrollable content ───────────────────
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                controller: _scrollCtrl,
                padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(children: [
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context).onboardingSportSelectionHeader,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Sport grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.3,
                  ),
                  itemCount: _sports.length,
                  itemBuilder: (_, i) => _SportCard(
                    sport: _sports[i],
                    selected: i == _selectedSportIdx,
                    onTap: () => _selectSport(i),
                  ),
                ),
                const SizedBox(height: 12),

                // Selection hint
                if (_selectedSportIdx >= 0) ...[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppLocalizations.of(context).onboardingSportSelected(_getSportName(context, _sports[_selectedSportIdx].name)),
                      style: const TextStyle(
                        color: AppColors.greenText,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                ],

                const SizedBox(height: 10),

                // Goals section title
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    isEs ? 'Selecciona tu objetivo de entrenamiento' : 'Select your training goal',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Date picker card (only when competition goal selected)
                if (_showDatePicker) ...[
                  _DatePickerCard(
                    raceDate: _raceDate,
                    weeksUntil: _weeksUntilRace,
                    months: _months,
                    onTap: _pickDate,
                  ),
                  const SizedBox(height: 10),
                ],

                // ── Goal options with expandable forms ──
                ...List.generate(_goals.length, (i) {
                  // Ocultar "Prepararme para una competencia" si es Acondicionamiento
                  if (i == 0 && _selectedSportIdx == 5) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(children: [
                      _GoalCard(
                        goal: _goals[i],
                        selected: i == _selectedGoalIdx,
                        onTap: () => _selectGoal(i),
                      ),
                      if (i == _selectedGoalIdx) ...[
                        const SizedBox(height: 4),
                        _GoalForm(
                          goalIdx: i,
                          selectedSportIdx: _selectedSportIdx,
                          competenciaOpciones: _competenciaOpciones[_selectedSportIdx] ?? [],
                          selectedCompetencia: _selectedCompetencia,
                          onCompetenciaChanged: (v) => setState(() {
                            _selectedCompetencia = v;
                            _riskAccepted = false;
                          }),
                          showRiskAlert: _showRiskAlert,
                          requiredWeeks: _requiredWeeks,
                          weeksAvailable: _weeksAvailableForRace,
                          riskAccepted: _riskAccepted,
                          onRiskAcceptedChanged: (v) => setState(() => _riskAccepted = v),
                          // Goal 0
                          raceNameCtrl: _raceNameCtrl,
                          raceDate: _raceDate,
                          raceDistCtrl: _raceDistCtrl,
                          raceDistUnit: _raceDistUnit,
                          onPickDate: _pickDate,
                          onRaceUnitChanged: (v) => setState(() => _raceDistUnit = v),
                          // Goal 1
                          timeDistCtrl: _timeDistCtrl,
                          timeDistUnit: _timeDistUnit,
                          timeHours: _timeHours,
                          timeMin: _timeMin,
                          timeSec: _timeSec,
                          timeTargetHours: _timeTargetHours,
                          timeTargetMin: _timeTargetMin,
                          timeTargetSec: _timeTargetSec,
                          onTimeUnitChanged: (v) => setState(() => _timeDistUnit = v),
                          onTimeChanged: (h, m, s) => setState(() {
                            _timeHours = h; _timeMin = m; _timeSec = s;
                          }),
                          onTargetTimeChanged: (h, m, s) => setState(() {
                            _timeTargetHours = h; _timeTargetMin = m; _timeTargetSec = s;
                          }),
                          targetExceedsActual: _targetExceedsActual,
                          // Goal 2
                          condicionCtrl: _condicionCtrl,
                          condicionCategoria: _condicionCategoria,
                          condicionSubcategoria: _condicionSubcategoria,
                          onCondicionCategoriaChanged: (v) => setState(() {
                            _condicionCategoria = v;
                            _condicionSubcategoria = null;
                          }),
                          onCondicionSubcategoriaChanged: (v) => setState(() => _condicionSubcategoria = v),
                        ),
                      ],
                    ]),
                  );
                }),

                // ── Info banner ───────────────────────

                // ── Cuántas semanas ───────────────────
                if (_selectedGoalIdx != 0) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Expanded(
                          child: Text(AppLocalizations.of(context).onboardingSportWeeksDurationTitle,
                              style: const TextStyle(color: AppColors.orange,
                                  fontSize: 16, fontWeight: FontWeight.w800, height: 1.3)),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3A1515),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            const Icon(Icons.circle, color: AppColors.redText, size: 8),
                            const SizedBox(width: 4),
                            Text(AppLocalizations.of(context).onboardingSportObligatory,
                                style: const TextStyle(color: AppColors.redText, fontSize: 11)),
                          ]),
                        ),
                      ]),
                      const SizedBox(height: 20),
                      _SemanasSlider(
                        value: _semanas,
                        options: _semanasOptions,
                        requiredWeeks: _minSemanasRequeridas,
                        onChanged: (v) {
                          final offset = _scrollCtrl.hasClients ? _scrollCtrl.offset : 0.0;
                          setState(() {
                            _semanas = v;
                            _semanasRiskAccepted = false;
                          });
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (_scrollCtrl.hasClients) {
                              _scrollCtrl.jumpTo(offset);
                            }
                          });
                        },
                      ),
                      // Alerta semanas insuficientes — AnimatedSize evita el salto de scroll
                      AnimatedSize(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                        clipBehavior: Clip.hardEdge,
                        child: _showSemanasAlert
                            ? Padding(
                                padding: const EdgeInsets.only(top: 14),
                                child: Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2A1A00),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: const Color(0xFFCC7700), width: 1.5),
                                  ),
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    Row(children: [
                                      const Text('⚠️', style: TextStyle(fontSize: 16)),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(AppLocalizations.of(context).onboardingSportTimeTight,
                                          style: const TextStyle(color: Color(0xFFFFAA33),
                                              fontSize: 14, fontWeight: FontWeight.w700)),
                                      ),
                                    ]),
                                    const SizedBox(height: 8),
                                    Text(
                                      AppLocalizations.of(context).onboardingSportTimeTightDesc(_minSemanasRequeridas),
                                      style: const TextStyle(color: Color(0xFFFFCC88), fontSize: 13, height: 1.5),
                                    ),
                                    const SizedBox(height: 12),
                                    GestureDetector(
                                      onTap: () => setState(() => _semanasRiskAccepted = !_semanasRiskAccepted),
                                      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        AnimatedContainer(
                                          duration: const Duration(milliseconds: 150),
                                          width: 22, height: 22,
                                          decoration: BoxDecoration(
                                            color: _semanasRiskAccepted ? const Color(0xFFCC7700) : Colors.transparent,
                                            borderRadius: BorderRadius.circular(5),
                                            border: Border.all(color: const Color(0xFFFFAA33), width: 1.5),
                                          ),
                                          child: _semanasRiskAccepted
                                              ? const Icon(Icons.check, color: Colors.white, size: 14)
                                              : null,
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            AppLocalizations.of(context).onboardingSportTimeTightCheckbox,
                                            style: const TextStyle(color: Color(0xFFFFCC88), fontSize: 12, height: 1.5),
                                          ),
                                        ),
                                      ]),
                                    ),
                                  ]),
                                ),
                              )
                            : const SizedBox(width: double.infinity),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 12),
                ],

                // ── Info banner (debajo de semanas) ───
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E1515),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.redMid),
                  ),
                  child: Row(children: [
                    const Icon(Icons.info_outline, color: AppColors.redText, size: 16),
                    const SizedBox(width: 8),
                    Expanded(child: Text(
                      AppLocalizations.of(context).onboardingSportObligatoryBanner,
                      style: const TextStyle(color: AppColors.redText, fontSize: 12),
                    )),
                  ]),
                ),
              ]),
            ),
          ),

          // ── Continue button ──────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: _loading
                ? const Center(child: CircularProgressIndicator(color: AppColors.orange))
                : PrimaryButton(
                    labelWidget: Text(AppLocalizations.of(context).onboardingContinue, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    enabled: _isValid,
                    onTap: _saveAndContinue,
                  ),
          ),
        ]),
      ),
    ),
  );
}
}

// ─── Sport Card ────────────────────────────────────────────────
class _SportCard extends StatelessWidget {
  final SportOption sport;
  final bool selected;
  final VoidCallback onTap;
  const _SportCard({required this.sport, required this.selected, required this.onTap});

  String _getSportName(BuildContext context, String rawName) {
    final l10n = AppLocalizations.of(context);
    switch (rawName) {
      case 'Trail running':
        return l10n.onboardingSportTrailRunning;
      case 'Triatlón':
      case 'Triathlon':
        return l10n.onboardingSportTriathlon;
      case 'Ciclismo de ruta':
      case 'Road cycling':
        return l10n.onboardingSportRoadCycling;
      case 'MTB':
        return l10n.onboardingSportMtb;
      case 'Senderismo':
      case 'Hiking':
        return l10n.onboardingSportHiking;
      case 'Acondicionamiento':
      case 'Conditioning':
        return l10n.onboardingSportConditioning;
      default:
        return rawName;
    }
  }

  String _getSportSubtitle(BuildContext context, String rawName) {
    final l10n = AppLocalizations.of(context);
    switch (rawName) {
      case 'Trail running':
        return l10n.onboardingSportTrailRunningSubtitle;
      case 'Triatlón':
      case 'Triathlon':
        return l10n.onboardingSportTriathlonSubtitle;
      case 'Ciclismo de ruta':
      case 'Road cycling':
        return l10n.onboardingSportRoadCyclingSubtitle;
      case 'MTB':
        return l10n.onboardingSportMtbSubtitle;
      case 'Senderismo':
      case 'Hiking':
        return l10n.onboardingSportHikingSubtitle;
      case 'Acondicionamiento':
      case 'Conditioning':
        return l10n.onboardingSportConditioningSubtitle;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF3A1F0A) : AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.orange : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Stack(children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(sport.emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 4),
            Text(_getSportName(context, sport.name),
                style: TextStyle(
                  color: selected ? AppColors.orange : AppColors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                )),
            Text(_getSportSubtitle(context, sport.name),
                style: const TextStyle(color: AppColors.grey, fontSize: 11)),
          ]),
          Positioned(
            right: 0, top: 0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 22, height: 22,
              decoration: BoxDecoration(
                color: selected ? AppColors.orange : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? AppColors.orange : AppColors.border,
                  width: 1.5,
                ),
              ),
              child: selected
                  ? const Icon(Icons.check, color: Colors.white, size: 13)
                  : null,
            ),
          ),
        ]),
      ),
    );
  }
}

// ─── Date Picker Card ──────────────────────────────────────────
class _DatePickerCard extends StatelessWidget {
  final DateTime? raceDate;
  final int weeksUntil;
  final List<String> months;
  final VoidCallback onTap;
  const _DatePickerCard({
    required this.raceDate,
    required this.weeksUntil,
    required this.months,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF2A1F0A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF5A3A10), width: 1.5),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Header
        Row(children: [
          const Text('📅', style: TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              AppLocalizations.of(context).onboardingSportObligatoryBanner,
              style: const TextStyle(
                  color: AppColors.orange,
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ]),
        const SizedBox(height: 10),

        // Date dropdown
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.cardDark,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(children: [
              Text(
                raceDate != null
                    ? '${raceDate!.day} ${months[raceDate!.month]} ${raceDate!.year}'
                    : AppLocalizations.of(context).onboardingSportSelectDate,
                style: TextStyle(
                    color: raceDate != null ? AppColors.white : AppColors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              const Icon(Icons.keyboard_arrow_down,
                  color: AppColors.orange, size: 22),
            ]),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          AppLocalizations.of(context).onboardingSportFormRaceDataDesc,
          style: const TextStyle(color: AppColors.grey, fontSize: 12, height: 1.4),
        ),
        if (raceDate != null) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFF1A2A1A),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.greenMid),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Text('📅', style: TextStyle(fontSize: 11)),
              const SizedBox(width: 5),
              Text(
                AppLocalizations.of(context).onboardingSportRaceWeeksAvailable(weeksUntil),
                style: const TextStyle(
                    color: AppColors.greenText,
                    fontSize: 11,
                    fontWeight: FontWeight.w500),
              ),
            ]),
          ),
        ],
      ]),
    );
  }
}

// ─── Goal Card ─────────────────────────────────────────────────
class _GoalCard extends StatelessWidget {
  final GoalOption goal;
  final bool selected;
  final VoidCallback onTap;
  const _GoalCard({required this.goal, required this.selected, required this.onTap});

  String _getGoalTitle(BuildContext context, String emoji) {
    final l10n = AppLocalizations.of(context);
    switch (emoji) {
      case '🏆':
        return l10n.onboardingSportPrepRace;
      case '⏱️':
        return l10n.onboardingSportImproveTime;
      case '🌱':
        return l10n.onboardingSportImproveCondition;
      default:
        return '';
    }
  }

  String _getGoalSubtitle(BuildContext context, String emoji) {
    final l10n = AppLocalizations.of(context);
    switch (emoji) {
      case '🏆':
        return l10n.onboardingSportPrepRaceSubtitle;
      case '⏱️':
        return l10n.onboardingSportImproveTimeSubtitle;
      case '🌱':
        return l10n.onboardingSportImproveConditionSubtitle;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF3A1F0A) : AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.orange : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(children: [
          Text(goal.emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(_getGoalTitle(context, goal.emoji),
                  style: TextStyle(
                    color: selected ? AppColors.orange : AppColors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  )),
              const SizedBox(height: 2),
              Text(_getGoalSubtitle(context, goal.emoji),
                  style: const TextStyle(color: AppColors.grey, fontSize: 12)),
            ]),
          ),
          const SizedBox(width: 10),
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 24, height: 24,
            decoration: BoxDecoration(
              color: selected ? AppColors.orange : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? AppColors.orange : AppColors.border,
                width: 1.5,
              ),
            ),
            child: selected
                ? const Icon(Icons.check, color: Colors.white, size: 14)
                : null,
          ),
        ]),
      ),
    );
  }
}
// ═══════════════════════════════════════════════════════════════
// GOAL FORM — Expandable yellow card per goal
// ═══════════════════════════════════════════════════════════════
class _GoalForm extends StatelessWidget {
  final int goalIdx;
  // Competencia dinámica
  final int selectedSportIdx;
  final List<String> competenciaOpciones;
  final String? selectedCompetencia;
  final ValueChanged<String?> onCompetenciaChanged;
  // Alerta de riesgo
  final bool showRiskAlert;
  final int requiredWeeks;
  final int weeksAvailable;
  final bool riskAccepted;
  final ValueChanged<bool> onRiskAcceptedChanged;
  // Goal 0
  final TextEditingController raceNameCtrl;
  final DateTime? raceDate;
  final TextEditingController raceDistCtrl;
  final String raceDistUnit;
  final VoidCallback onPickDate;
  final ValueChanged<String> onRaceUnitChanged;
  // Goal 1
  final TextEditingController timeDistCtrl;
  final String timeDistUnit;
  final int timeHours, timeMin, timeSec;
  final int timeTargetHours, timeTargetMin, timeTargetSec;
  final ValueChanged<String> onTimeUnitChanged;
  final Function(int, int, int) onTimeChanged;
  final Function(int, int, int) onTargetTimeChanged;
  final bool targetExceedsActual;
  // Goal 2
  final TextEditingController condicionCtrl;
  final String? condicionCategoria;
  final String? condicionSubcategoria;
  final ValueChanged<String?> onCondicionCategoriaChanged;
  final ValueChanged<String?> onCondicionSubcategoriaChanged;

  const _GoalForm({
    required this.goalIdx,
    required this.selectedSportIdx,
    required this.competenciaOpciones,
    required this.selectedCompetencia,
    required this.onCompetenciaChanged,
    required this.showRiskAlert,
    required this.requiredWeeks,
    required this.weeksAvailable,
    required this.riskAccepted,
    required this.onRiskAcceptedChanged,
    required this.raceNameCtrl, required this.raceDate,
    required this.raceDistCtrl, required this.raceDistUnit,
    required this.onPickDate, required this.onRaceUnitChanged,
    required this.timeDistCtrl, required this.timeDistUnit,
    required this.timeHours, required this.timeMin, required this.timeSec,
    required this.timeTargetHours, required this.timeTargetMin, required this.timeTargetSec,
    required this.onTimeUnitChanged, required this.onTimeChanged,
    required this.onTargetTimeChanged, required this.targetExceedsActual,
    required this.condicionCtrl,
    required this.condicionCategoria,
    required this.condicionSubcategoria,
    required this.onCondicionCategoriaChanged,
    required this.onCondicionSubcategoriaChanged,
  });

  static const _cardColor = Color(0xFF3A2E00);
  static const _titleColor = Color(0xFFFFCC00);
  static const _borderColor = Color(0xFF5A4800);

  Widget _label(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(t, style: const TextStyle(
        color: _titleColor, fontSize: 13, fontWeight: FontWeight.w600)),
  );

  Widget _unitToggle(String selected, ValueChanged<String> onChange) =>
    GestureDetector(
      onTap: () => onChange(selected == 'km' ? 'Mi' : 'km'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text('$selected ', style: const TextStyle(color: AppColors.white, fontSize: 14)),
          const Icon(Icons.keyboard_arrow_down, color: AppColors.orange, size: 16),
        ]),
      ),
    );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _borderColor),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Header
        Row(children: [
          const Text('📅', style: TextStyle(fontSize: 14)),
          const SizedBox(width: 6),
          Text(
            goalIdx == 0 ? l10n.onboardingSportFormRaceData
                : goalIdx == 1 ? l10n.onboardingSportFormTimeImprove
                : l10n.onboardingSportFormImprove,
            style: const TextStyle(color: _titleColor,
                fontSize: 13, fontWeight: FontWeight.w700),
          ),
        ]),
        const SizedBox(height: 14),

        if (goalIdx == 0) ...[
          // ── Selector de competencia ──────────────
          _label(l10n.onboardingSportDropdownRace),
          _DropdownSelector(
            value: selectedCompetencia,
            hint: competenciaOpciones.isEmpty
                ? l10n.onboardingSportDropdownSelectSportFirst
                : l10n.onboardingSportDropdownSelectRace,
            options: competenciaOpciones,
            onChanged: onCompetenciaChanged,
          ),
          // Si eligió "Otro" → campo libre de nombre
          if (selectedCompetencia == 'Otro') ...[
            const SizedBox(height: 12),
            _label(l10n.onboardingSportRaceName),
            TextField(
              controller: raceNameCtrl,
              style: const TextStyle(color: AppColors.white),
              decoration: InputDecoration(
                hintText: l10n.onboardingSportRaceNameHint,
                hintStyle: const TextStyle(color: AppColors.grey),
                filled: true,
                fillColor: AppColors.cardDark,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
          ],
          if (selectedCompetencia != null) ...[
            const SizedBox(height: 12),
            _label(l10n.onboardingSportDate),
            GestureDetector(
              onTap: onPickDate,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.cardDark,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(children: [
                  Text(
                    raceDate != null
                        ? '${raceDate!.day} ${_mn(raceDate!.month)} ${raceDate!.year}'
                        : l10n.onboardingSportSelectDate,
                    style: TextStyle(
                        color: raceDate != null ? AppColors.white : AppColors.grey,
                        fontSize: 14),
                  ),
                  const Spacer(),
                  const Icon(Icons.keyboard_arrow_down, color: AppColors.orange, size: 18),
                ]),
              ),
            ),
          ],
          // Distancia manual solo si eligió "Otro"
          if (selectedCompetencia == 'Otro') ...[
            const SizedBox(height: 12),
            _label(l10n.onboardingSportDistance),
            Row(children: [
              SizedBox(
                width: 100,
                child: TextField(
                  controller: raceDistCtrl,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: AppColors.white),
                  decoration: InputDecoration(
                    hintText: '15',
                    hintStyle: const TextStyle(color: AppColors.grey),
                    filled: true,
                    fillColor: AppColors.cardDark,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              _unitToggle(raceDistUnit, onRaceUnitChanged),
            ]),
          ],
          const SizedBox(height: 10),
          Text(
            l10n.onboardingSportFormRaceDataDesc,
            style: const TextStyle(color: AppColors.grey, fontSize: 11, height: 1.4),
          ),
          // ── Alerta de riesgo ─────────────────────
          if (showRiskAlert) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF2A1515),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFCC4444), width: 1.5),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  const Text('⚠️', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.onboardingSportRaceWeeksRequiredTitle,
                      style: const TextStyle(
                        color: Color(0xFFFF6B6B),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ]),
                const SizedBox(height: 10),
                Text(
                  l10n.onboardingSportRaceWeeksRequiredDesc(weeksAvailable, requiredWeeks),
                  style: const TextStyle(color: Color(0xFFFFAAAA), fontSize: 13, height: 1.5),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.onboardingSportRaceWeeksRequiredNote,
                  style: const TextStyle(color: Color(0xFFFFCCCC), fontSize: 12, height: 1.4),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () => onRiskAcceptedChanged(!riskAccepted),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: 22, height: 22,
                      decoration: BoxDecoration(
                        color: riskAccepted ? const Color(0xFFCC4444) : Colors.transparent,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: riskAccepted ? const Color(0xFFCC4444) : const Color(0xFFFF6B6B),
                          width: 1.5,
                        ),
                      ),
                      child: riskAccepted
                          ? const Icon(Icons.check, color: Colors.white, size: 14)
                          : null,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        l10n.onboardingSportRaceWeeksRequiredCheckbox,
                        style: const TextStyle(
                          color: Color(0xFFFFAAAA),
                          fontSize: 12,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ]),
                ),
              ]),
            ),
          ],
        ],

        if (goalIdx == 1) ...[
          // ── Mejorar tiempo ───────────────────────
          _label(l10n.onboardingSportDistance),
          Row(children: [
            SizedBox(
              width: 100,
              child: TextField(
                controller: timeDistCtrl,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: AppColors.white),
                decoration: InputDecoration(
                  hintText: '15',
                  hintStyle: const TextStyle(color: AppColors.grey),
                  filled: true,
                  fillColor: AppColors.cardDark,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
            ),
            const SizedBox(width: 10),
            _unitToggle(timeDistUnit, onTimeUnitChanged),
          ]),
          const SizedBox(height: 14),

          // ── Tiempo actual ────────────────────────
          _label(l10n.onboardingSportActualTime),
          _TimeScrollRow(
            hours: timeHours, min: timeMin, sec: timeSec,
            onChanged: (h, m, s) => onTimeChanged(h, m, s),
          ),
          const SizedBox(height: 14),

          // ── Tiempo objetivo ──────────────────────
          _label(l10n.onboardingSportTargetTime),
          _TimeScrollRow(
            hours: timeTargetHours, min: timeTargetMin, sec: timeTargetSec,
            onChanged: (h, m, s) => onTargetTimeChanged(h, m, s),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.onboardingSportActualTimeDesc,
            style: const TextStyle(color: AppColors.grey, fontSize: 11, height: 1.4),
          ),
          if (targetExceedsActual) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF2A1515),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFCC4444), width: 1.5),
              ),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('⚠️', style: TextStyle(fontSize: 14)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.onboardingSportTargetTimeError,
                    style: const TextStyle(color: Color(0xFFFF6B6B), fontSize: 12, height: 1.4),
                  ),
                ),
              ]),
            ),
          ],
        ],

        if (goalIdx == 2) ...[
          // ── Categoría ────────────────────────────
          _label(l10n.onboardingSportWhatToImprove),
          _DropdownSelector(
            value: condicionCategoria,
            hint: l10n.onboardingSportSelectCategory,
            options: const [
              'Fuerza / Musculación',
              'Movilidad, Flexibilidad y Respiración',
              'Cardio General',
            ],
            onChanged: onCondicionCategoriaChanged,
          ),

          if (condicionCategoria != null) ...[
            const SizedBox(height: 12),
            _label(l10n.onboardingSportSpecificGoal),
            _DropdownSelector(
              value: condicionSubcategoria,
              hint: l10n.onboardingSportSelectGoal,
              options: _subcategorias(condicionCategoria!),
              onChanged: onCondicionSubcategoriaChanged,
            ),
          ],
          const SizedBox(height: 10),
          Text(
            l10n.onboardingSportGeneralConditionDesc,
            style: const TextStyle(color: AppColors.grey, fontSize: 11, height: 1.4),
          ),
        ],
      ]),
    );
  }

  static String _mn(int m) => ['ene','feb','mar','abr','may','jun','jul','ago','sep','oct','nov','dic'][m-1];

  static List<String> _subcategorias(String categoria) {
    switch (categoria) {
      case 'Fuerza / Musculación':
        return [
          'Tonificación / salud general',
          'Hipertrofia (masa muscular)',
          'Fuerza máxima',
          'Recomposición corporal',
        ];
      case 'Movilidad, Flexibilidad y Respiración':
        return [
          'Movilidad articular básica',
          'Yoga funcional / Flexibilidad',
          'Respiración / Mindfulness activo',
        ];
      case 'Cardio General':
        return [
          'Salud CV básica (20–30 min ×3/sem)',
          'Cardio zona 2 (fat burning, 45–60 min)',
          'Cardio largo (>60 min constante)',
        ];
      default:
        return [];
    }
  }
}

// ─── Semanas Slider ────────────────────────────────────────────
class _SemanasSlider extends StatelessWidget {
  final int value;
  final List<int> options;
  final int requiredWeeks;
  final ValueChanged<int> onChanged;
  const _SemanasSlider({
    required this.value,
    required this.options,
    required this.requiredWeeks,
    required this.onChanged,
  });

  Color _sliderColor() {
    if (requiredWeeks == 0) return AppColors.orange;
    if (value < requiredWeeks) return const Color(0xFFE53935);       // rojo
    if (value == requiredWeeks) return const Color(0xFFFFB300);      // amarillo
    return const Color(0xFF43A047);                                   // verde
  }

  @override
  Widget build(BuildContext context) {
    final idx = options.indexOf(value).clamp(0, options.length - 1);
    final color = _sliderColor();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Center(
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '$value',
                style: TextStyle(
                  color: color,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
              TextSpan(
                text: ' semanas',
                style: TextStyle(
                  color: color,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 18),
      SliderTheme(
        data: SliderTheme.of(context).copyWith(
          trackHeight: 8,
          activeTrackColor: color,
          inactiveTrackColor: const Color(0xFF3A3A3A),
          thumbColor: color,
          overlayColor: color.withValues(alpha: 0.15),
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 13),
          overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
          trackShape: const RoundedRectSliderTrackShape(),
          showValueIndicator: ShowValueIndicator.never,
        ),
        child: Slider(
          value: idx.toDouble(),
          min: 0,
          max: (options.length - 1).toDouble(),
          divisions: options.length - 1,
          onChanged: (v) => onChanged(options[v.round()]),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${options.first} sem',
                style: const TextStyle(color: AppColors.grey, fontSize: 11)),
            if (requiredWeeks > 0)
              Text('mín. recomendado: $requiredWeeks sem',
                  style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
            Text('${options.last} sem (1 año)',
                style: const TextStyle(color: AppColors.grey, fontSize: 11)),
          ],
        ),
      ),
    ]);
  }
}

// ─── Time Scroll Row ───────────────────────────────────────────
class _TimeScrollRow extends StatelessWidget {
  final int hours, min, sec;
  final Function(int, int, int) onChanged;
  const _TimeScrollRow({
    required this.hours, required this.min, required this.sec,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => Row(children: [
    _TimeWheel(
      label: 'H', value: hours, max: 23,
      onChanged: (v) => onChanged(v, min, sec),
    ),
    const Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Text(' : ', style: TextStyle(color: AppColors.white, fontSize: 20, fontWeight: FontWeight.w700)),
    ),
    _TimeWheel(
      label: 'Min', value: min, max: 59,
      onChanged: (v) => onChanged(hours, v, sec),
    ),
    const Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Text(' : ', style: TextStyle(color: AppColors.white, fontSize: 20, fontWeight: FontWeight.w700)),
    ),
    _TimeWheel(
      label: 'Seg', value: sec, max: 59,
      onChanged: (v) => onChanged(hours, min, v),
    ),
  ]);
}

class _TimeWheel extends StatefulWidget {
  final String label;
  final int value, max;
  final ValueChanged<int> onChanged;
  const _TimeWheel({
    required this.label, required this.value,
    required this.max, required this.onChanged,
  });

  @override
  State<_TimeWheel> createState() => _TimeWheelState();
}

class _TimeWheelState extends State<_TimeWheel> {
  late FixedExtentScrollController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = FixedExtentScrollController(initialItem: widget.value);
  }

  @override
  void didUpdateWidget(_TimeWheel old) {
    super.didUpdateWidget(old);
    if (old.value != widget.value) {
      _ctrl.jumpToItem(widget.value);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(children: [
    Text(widget.label,
        style: const TextStyle(color: AppColors.grey, fontSize: 10)),
    const SizedBox(height: 4),
    Container(
      width: 64,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Stack(children: [
        // Selection highlight
        Center(
          child: Container(
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.orange.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.orange.withValues(alpha: 0.4)),
            ),
          ),
        ),
        ListWheelScrollView.useDelegate(
          controller: _ctrl,
          itemExtent: 36,
          perspective: 0.003,
          diameterRatio: 1.2,
          physics: const FixedExtentScrollPhysics(),
          magnification: 1.2,
          useMagnifier: true,
          overAndUnderCenterOpacity: 0.4,
          onSelectedItemChanged: (i) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              widget.onChanged(i);
            });
          },
          childDelegate: ListWheelChildBuilderDelegate(
            builder: (ctx, i) => Center(
              child: Text(
                i.toString().padLeft(2, '0'),
                style: TextStyle(
                  color: i == widget.value ? AppColors.white : AppColors.grey,
                  fontSize: i == widget.value ? 20 : 14,
                  fontWeight: i == widget.value ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            ),
            childCount: widget.max + 1,
          ),
        ),
      ]),
    ),
  ]);
}
// ─── Dropdown Selector ─────────────────────────────────────────
class _DropdownSelector extends StatelessWidget {
  final String? value;
  final String hint;
  final List<String> options;
  final ValueChanged<String?> onChanged;
  const _DropdownSelector({
    required this.value, required this.hint,
    required this.options, required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => _showPicker(context),
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: value != null ? AppColors.orange : AppColors.border,
          width: value != null ? 1.5 : 1,
        ),
      ),
      child: Row(children: [
        Expanded(
          child: Text(
            value ?? hint,
            style: TextStyle(
              color: value != null ? AppColors.white : AppColors.grey,
              fontSize: 13,
            ),
          ),
        ),
        Icon(Icons.keyboard_arrow_down,
            color: value != null ? AppColors.orange : AppColors.grey, size: 18),
      ]),
    ),
  );

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const SizedBox(height: 16),
          Text(hint,
              style: const TextStyle(
                  color: AppColors.white, fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.5),
            child: ListView(
              shrinkWrap: true,
              children: options.map((o) => ListTile(
                title: Text(o,
                    style: TextStyle(
                        color: o == value ? AppColors.orange : AppColors.white,
                        fontSize: 14)),
                trailing: o == value
                    ? const Icon(Icons.check, color: AppColors.orange)
                    : null,
                onTap: () {
                  onChanged(o);
                  Navigator.pop(context);
                },
              )).toList(),
            ),
          ),
          const SizedBox(height: 8),
        ]),
      ),
    );
  }
}