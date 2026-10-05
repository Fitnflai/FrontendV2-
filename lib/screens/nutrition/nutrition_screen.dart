import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../../services/cached_http.dart';
import '../../config/app_theme_extension.dart';
import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';
import '../../providers/nutrition_provider.dart';
import '../../widgets/bottom_nav.dart';
import '../../widgets/shared_widgets.dart';
import '../../l10n/app_localizations.dart';
import '../membership/membership_screen.dart';

class NutritionScreen extends StatefulWidget {
  const NutritionScreen({super.key});
  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {

  bool _loading = true;
  List<Map<String, dynamic>> _plan = [];
  int _selectedDayIdx = 0;
  int _weekOffset = 0;
  bool _hasFetched = false;


  @override
  void initState() {
    super.initState();

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final auth = Provider.of<AuthProvider>(context);
    if (auth.status == AuthStatus.authenticated && !_hasFetched) {
      _hasFetched = true;
      Future.microtask(() => _loadPlan());
    }
  }

  Future<void> _loadPlan() async {
    setState(() => _loading = true);
    final token = context.read<AuthProvider>().token ?? '';
    try {
        // Load profile data and active plan to populate planActivo
        await context.read<ProfileProvider>().loadAll(token);
        
        final now    = DateTime.now();
      final monday = now.subtract(Duration(days: now.weekday - 1))
          .add(Duration(days: _weekOffset * 7));
      final start  = '${monday.year}-${monday.month.toString().padLeft(2,'0')}-${monday.day.toString().padLeft(2,'0')}';
      final res = await CachedHttp.get(
        Uri.parse('https://apifitnflai.com/entrenamientos/semana?start_date=$start'),
        headers: {'Authorization': 'Bearer $token'},
      );
      debugPrint('NUTRITION STATUS: ${res.statusCode}');
      if (res.statusCode == 200 && mounted) {
        final body    = jsonDecode(res.body);
        final rawPlan = body['plan'] as List? ?? [];
        final plan    = rawPlan.whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e)).toList();
        final hoy = DateTime.now();
        int todayIdx = 0;
        for (int i = 0; i < plan.length; i++) {
          final fecha = plan[i]['fecha_programada'] as String?;
          if (fecha == null) continue;
          try {
            final dt = DateTime.parse(fecha);
            if (dt.year == hoy.year && dt.month == hoy.month && dt.day == hoy.day) {
              todayIdx = i; break;
            }
          } catch (_) {}
        }
        setState(() {
          _plan = plan;
          _selectedDayIdx = _weekOffset == 0 ? todayIdx : 0;
        });
      }
    } catch (e) {
      debugPrint('NUTRITION LOAD ERROR: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Map<String, dynamic>? get _selectedDay =>
      _plan.isNotEmpty && _selectedDayIdx < _plan.length
          ? _plan[_selectedDayIdx]
          : null;

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;
    final tienePlan = user?.tienePlanActivo == true;
    final theme = Theme.of(context).extension<AppThemeExtension>() ?? AppThemeExtension.dark;

    if (!tienePlan) {
      return Scaffold(
        backgroundColor: theme.bg,
        body: const BlockingMembershipOverlay(),
        bottomNavigationBar: const AppBottomNav(selectedIndex: 3),
      );
    }

    final isLoadingAuth = authProvider.isLoading;
    final nutritionProvider = context.watch<NutritionProvider>();
    final profileProvider = context.watch<ProfileProvider>();

    final planNombreProfile = (profileProvider.planActivo?['nombre'] as String?)?.toLowerCase() ?? '';
    final isProOrEliteProfile = planNombreProfile.contains('pro') || planNombreProfile.contains('elite');
    final canSeeNutrition = user?.canSeeNutrition == true || isProOrEliteProfile;
    debugPrint('🥗 NUTRITION DIAGNOSTIC: hasUser=${user != null}, tienePlanActivo=${user?.tienePlanActivo}, nombrePlanActivo="${user?.nombrePlanActivo}", isPro=${user?.isPro}, isElite=${user?.isElite}, canSeeNutrition=$canSeeNutrition');

    final l10n = AppLocalizations.of(context);
    final isEs = Localizations.localeOf(context).languageCode == 'es';
    final day     = _selectedDay;
    String fechaStr = '';
    final rawFecha = day?['fecha_programada'] as String?;
    if (rawFecha != null) {
      final dt = DateTime.tryParse(rawFecha);
      if (dt != null) {
        fechaStr = '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
      }
    }
    int hidratacionMl = 2000; // Default value
    final rawHidratacionMl = day?['hidratacion_ml'];
    if (rawHidratacionMl != null) {
      if (rawHidratacionMl is num) {
        hidratacionMl = rawHidratacionMl.toInt();
      } else if (rawHidratacionMl is String) {
        hidratacionMl = int.tryParse(rawHidratacionMl) ?? 2000;
      }
    }
    if (hidratacionMl <= 0) {
      hidratacionMl = 2000;
    }
    String sugerencia = day?['sugerencia_hidratacion'] as String? ?? '';
    if (sugerencia.isEmpty) {
      sugerencia = day?['hidratacion'] as String? ?? ''; // Backup field
    }
    final comidas = (day?['comidas'] as List?)
        ?.whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList() ?? [];
    // Orden fijo: DESAYUNO → PRE_ENTRENO → DURANTE → POST_ENTRENO → CENA → resto
    const orden = ['DESAYUNO','PRE_ENTRENO','DURANTE','POST_ENTRENO',
                    'ALMUERZO','CENA','SNACK'];
    comidas.sort((a, b) {
      final ta = (a['tipo'] as String? ?? '').toUpperCase();
      final tb = (b['tipo'] as String? ?? '').toUpperCase();

    final ia = orden.indexOf(ta);
      final ib = orden.indexOf(tb);
      return (ia < 0 ? 999 : ia).compareTo(ib < 0 ? 999 : ib);
    });
    int consumedKcal = 0;
    int consumedCh = 0;
    int consumedProteina = 0;
    int consumedGrasas = 0;
    for (final c in comidas) {
      final mealId = nutritionProvider.getMealId(date: fechaStr, type: c['tipo'] as String? ?? '', description: c['descripcion'] as String? ?? '');
      if (nutritionProvider.checkedMeals.contains(mealId)) {
        consumedKcal += (c['kcal'] as num?)?.toInt() ?? 0;
        consumedCh += (c['ch'] as num?)?.toInt() ?? 0;
        consumedProteina += (c['proteina'] as num?)?.toInt() ?? 0;
        consumedGrasas += (c['grasas'] as num?)?.toInt() ?? 0;
      }
    }
    final kcal     = (day?['macros_objetivo_kcal']     as num?)?.toInt() ?? 0;
    final ch       = (day?['macros_objetivo_ch']        as num?)?.toInt() ?? 0;
    final proteina = (day?['macros_objetivo_proteina']  as num?)?.toInt() ?? 0;
    final grasas   = (day?['macros_objetivo_grasas']    as num?)?.toInt() ?? 0;
    final tipo     = day?['tipo'] as String? ?? '';
    final esDescanso = tipo.toLowerCase().contains('descanso');

    final restDayTitle = isEs ? 'Día de descanso' : 'Rest day';
    final titulo   = esDescanso ? restDayTitle
        : day?['titulo_entrenamiento'] as String? ?? tipo;

    return Scaffold(
      backgroundColor: theme.bg,
      body: SafeArea(
        bottom: false,
        child: Column(children: [
          AppHeader(section: l10n.nutritionHeaderSection),
          if (!_loading && _plan.isNotEmpty && canSeeNutrition) _buildDaySelector(),
          Expanded(
            child: (_loading || isLoadingAuth || user == null)
                ? Center(child: CircularProgressIndicator(color: theme.primary))
                : SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (canSeeNutrition) ...[
                          if (esDescanso) ...[
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: theme.cardDark,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: theme.border),
                              ),
                              child: Row(children: [
                                const Text('😴', style: TextStyle(fontSize: 20)),
                                const SizedBox(width: 10),
                                Expanded(child: Text(
                                  l10n.nutritionRestDayBanner,
                                  style: TextStyle(color: theme.greyLight,
                                      fontSize: 13, height: 1.4),
                                )),
                              ]),
                            ),
                            const SizedBox(height: 16),
                          ],
                          if (kcal > 0) ...[
                            _MacrosCard(
              consumedKcal: consumedKcal,
              targetKcal: kcal,
              consumedCh: consumedCh,
              targetCh: ch,
              consumedProteina: consumedProteina,
              targetProteina: proteina,
              consumedGrasas: consumedGrasas,
              targetGrasas: grasas,
            ),
                            const SizedBox(height: 16),
                          ],
                          if (comidas.isNotEmpty) ...[
                            _SectionLabel(l10n.nutritionSectionPlanTitle(titulo.toUpperCase())),
                            const SizedBox(height: 12),
                            ...comidas.map((c) {
                              final mealId = nutritionProvider.getMealId(date: fechaStr, type: c['tipo'] as String? ?? '', description: c['descripcion'] as String? ?? '');
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: _MealCard(
                                  time: _mealTime(c['tipo'] as String? ?? ''),
                                  emoji: _mealEmoji(c['tipo'] as String? ?? ''),
                                  name: c['descripcion'] as String? ?? '',
                                  description: c['instrucciones'] as String? ?? '',
                                  calories: (c['kcal'] as num?)?.toInt() ?? 0,
                                  tags: _mealTags(c),
                                     isChecked: nutritionProvider.checkedMeals.contains(mealId),
                                     onChecked: (checked) {
                                       context.read<NutritionProvider>().toggleMealCheck(mealId, checked == true);
                                     },
                                ),
                              );
                            }),
                          ],
                          const SizedBox(height: 6),

                          _HydrationCard(
                            key: ValueKey(fechaStr),
                            totalHydrationMl: hidratacionMl <= 0 ? 2000 : hidratacionMl,
                            hydrationSuggestion: sugerencia,
                            filledGlasses: nutritionProvider.hydrationProgress[fechaStr] ?? 0,
                            onGlassesChanged: (val) {
                              context.read<NutritionProvider>().updateHydration(fechaStr, val, token: authProvider.token);
                            },
                          ),
                          const SizedBox(height: 24),
                        ] else ...[
                          _AIBanner(
                            onSubscribeSuccess: () {
                              _hasFetched = false;
                              _loadPlan();
                            },
                          ),
                          const SizedBox(height: 24),
                        ]
                      ],
                    ),
                  ),
          ),
        ]),
      ),
      bottomNavigationBar: const AppBottomNav(selectedIndex: 3),
    );
  }

  Widget _buildDaySelector() {
    final theme = Theme.of(context).extension<AppThemeExtension>() ?? AppThemeExtension.dark;
    final now    = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1))
        .add(Duration(days: _weekOffset * 7));
    final isEs = Localizations.localeOf(context).languageCode == 'es';
    final labels = isEs
        ? ['LUN','MAR','MIÉ','JUE','VIE','SÁB','DOM']
        : ['MON','TUE','WED','THU','FRI','SAT','SUN'];
    final meses = isEs
        ? ['Ene','Feb','Mar','Abr','May','Jun','Jul','Ago','Sep','Oct','Nov','Dic']
        : ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dic'];

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.border),
      ),
      child: Column(children: [
        // Header con mes y flechas
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(children: [
            GestureDetector(
              onTap: () {
                setState(() { _weekOffset--; });
                Future.microtask(() => _loadPlan());
              },
              child: Icon(Icons.chevron_left, color: theme.grey, size: 22),
            ),
            const Spacer(),
            Text(
              '${meses[monday.month - 1]} ${monday.year}',
              style: TextStyle(color: theme.white,
                  fontSize: 13, fontWeight: FontWeight.w700),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                setState(() { _weekOffset++; });
                Future.microtask(() => _loadPlan());
              },
              child: Icon(Icons.chevron_right, color: theme.grey, size: 22),
            ),
          ]),
        ),
        Divider(color: theme.border, height: 1),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
          child: Column(children: [
            // Labels
            Row(children: labels.map((l) => Expanded(
              child: Center(child: Text(l, style: TextStyle(
                  color: theme.grey, fontSize: 10,
                  fontWeight: FontWeight.w600))),
            )).toList()),
            const SizedBox(height: 6),
            // Day cells
            Row(children: List.generate(7, (i) {
              final day = monday.add(Duration(days: i));
              final isToday = day.year == now.year &&
                  day.month == now.month && day.day == now.day;

              // Buscar sesión para este día en el plan
              Map<String, dynamic>? session;
              int? planIdx;
              for (int j = 0; j < _plan.length; j++) {
                final fecha = _plan[j]['fecha_programada'] as String?;
                if (fecha == null) continue;
                try {
                  final dt = DateTime.parse(fecha);
                  if (dt.year == day.year && dt.month == day.month &&
                      dt.day == day.day) {
                    session = _plan[j]; planIdx = j; break;
                  }
                } catch (_) {}
              }

              final isSelected = planIdx != null && planIdx == _selectedDayIdx;
              final comidas = (session?['comidas'] as List?)?.isNotEmpty == true;
              final hasDot = session != null && comidas;

              return Expanded(child: GestureDetector(
                onTap: planIdx != null
                    ? () => setState(() => _selectedDayIdx = planIdx!)
                    : null,
                child: Column(children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 32, height: 32,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? theme.white
                          : isToday
                              ? theme.primary
                              : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Center(child: Text('${day.day}',
                        style: TextStyle(
                            color: isSelected
                                ? theme.bg
                                : isToday
                                    ? Colors.white
                                    : planIdx != null
                                        ? theme.greyLight
                                        : theme.border,
                            fontSize: 13,
                            fontWeight: isSelected || isToday
                                ? FontWeight.w700 : FontWeight.w400))),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    width: 5, height: 5,
                    decoration: BoxDecoration(
                      color: hasDot ? theme.greenText : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(height: 2),
                ]),
              ));
            })),
          ]),
        ),
      ]),
    );
  }

  // ── Helpers de comidas ──────────────────────────────────────
  static const _mealConfig = {
    'DESAYUNO':     ('🍳', 'DESAYUNO'),
    'ALMUERZO':     ('🍽️', 'ALMUERZO'),
    'CENA':         ('🥗', 'CENA'),
    'PRE_ENTRENO':  ('🍌', 'PRE-ENTRENO · 30-60 MIN ANTES'),
    'POST_ENTRENO': ('🍚', 'POST-ENTRENO · +30 MIN DESPUÉS'),
    'SNACK':        ('🥜', 'SNACK'),
    'DURANTE':      ('⚡', 'DURANTE · SI +60 MIN'),
  };

  String _mealTime(String tipo) {
    final isEs = Localizations.localeOf(context).languageCode == 'es';
    final key = tipo.toUpperCase();
    if (isEs) {
      return _mealConfig[key]?.$2 ?? key;
    } else {
      switch (key) {
        case 'DESAYUNO': return 'BREAKFAST';
        case 'ALMUERZO': return 'LUNCH';
        case 'CENA': return 'DINNER';
        case 'PRE_ENTRENO': return 'PRE-WORKOUT · 30-60 MIN BEFORE';
        case 'POST_ENTRENO': return 'POST-WORKOUT · +30 MIN AFTER';
        case 'SNACK': return 'SNACK';
        case 'DURANTE': return 'DURING · IF +60 MIN';
        default: return key;
      }
    }
  }

  String _mealEmoji(String tipo) =>
      _mealConfig[tipo.toUpperCase()]?.$1 ?? '🍴';

  List<(String, Color)> _mealTags(Map<String, dynamic> c) {
    final tags = <(String, Color)>[];
    final etiquetas = c['etiquetas'] as List?;
    final isEs = Localizations.localeOf(context).languageCode == 'es';
    if (etiquetas != null) {
      final theme = Theme.of(context).extension<AppThemeExtension>() ?? AppThemeExtension.dark;
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
        if (s.toLowerCase().contains('ig alto')) color = theme.primary;
        else if (s.toLowerCase().contains('ig bajo')) color = theme.greenText;
        else if (s.toLowerCase().contains('proteín')) color = theme.greenText;
        else if (s.toLowerCase().contains('recuper')) color = theme.greenText;
        else if (s.toLowerCase().contains('absorc')) color = Colors.blue;
        tags.add((displayTag, color));
      }
    }
    return tags;
  }
}

// ─── AI Banner ─────────────────────────────────────────────────
class _AIBanner extends StatelessWidget {
  final VoidCallback? onSubscribeSuccess;
  const _AIBanner({this.onSubscribeSuccess});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>() ?? AppThemeExtension.dark;
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.border),
      ),
      child: Column(
        children: [
          const Text('🧠', style: TextStyle(fontSize: 32)),
          const SizedBox(height: 12),
          Text(l10n.nutritionAIBannerTitle,
              textAlign: TextAlign.center,
              style: TextStyle(color: theme.white, fontSize: 17, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            l10n.nutritionAIBannerDesc,
            textAlign: TextAlign.center,
            style: TextStyle(color: theme.grey, fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 16),
          _ProFeaturesList(),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MembershipScreen()),
                ).then((_) {
                  if (onSubscribeSuccess != null) {
                    onSubscribeSuccess!();
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(l10n.nutritionAIBannerProBtn,
                  style: TextStyle(color: theme.white, fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          ),
          const SizedBox(height: 6),
          Text(l10n.nutritionAIBannerProNote,
              style: TextStyle(color: theme.grey, fontSize: 11)),
        ],
      ),
    );
  }
}

class _ProFeaturesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>() ?? AppThemeExtension.dark;
    final l10n = AppLocalizations.of(context);
    final isEs = Localizations.localeOf(context).languageCode == 'es';
    final features = isEs
        ? [
            'Plan nutricional semanal generado por Fitnflai',
            'Calorías y macros ajustados a tu carga de entrenamiento',
            'Tip nutricional antes de cada sesión (qué comer y cuándo)',
            'Protocolo de hidratación personalizado por sesión',
          ]
        : [
            'Weekly nutritional plan generated by Fitnflai',
            'Calories and macros adjusted to your training load',
            'Nutritional tip before each session (what to eat and when)',
            'Custom hydration protocol per session',
          ];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.auto_awesome, color: theme.primary, size: 13),
            const SizedBox(width: 6),
            Text(l10n.nutritionAIBannerProTitle,
                style: TextStyle(color: theme.primary, fontSize: 12, fontWeight: FontWeight.w600)),
          ]),
          const SizedBox(height: 10),
          ...features.map((f) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(Icons.check, color: theme.greenText, size: 13),
              const SizedBox(width: 8),
              Expanded(child: Text(f, style: TextStyle(color: theme.grey, fontSize: 12))),
            ]),
          )),
        ],
      ),
    );
  }
}

// ─── Macros Card ───────────────────────────────────────────────
class _MacrosCard extends StatelessWidget {
  final int consumedKcal, targetKcal, consumedCh, targetCh, consumedProteina, targetProteina, consumedGrasas, targetGrasas;
  const _MacrosCard({
    required this.consumedKcal,
    required this.targetKcal,
    required this.consumedCh,
    required this.targetCh,
    required this.consumedProteina,
    required this.targetProteina,
    required this.consumedGrasas,
    required this.targetGrasas,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>() ?? AppThemeExtension.dark;
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.border),
      ),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l10n.nutritionMacrosTitle,
                style: TextStyle(color: theme.white, fontSize: 14, fontWeight: FontWeight.w600)),
            Text("${l10n.nutritionMacrosKcal(consumedKcal)} / $targetKcal kcal",
                style: TextStyle(color: theme.primary, fontSize: 14, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 14),
        _MacroRow(l10n.nutritionMacrosCarbs, consumedCh, targetCh, Colors.blue),
        const SizedBox(height: 10),
        _MacroRow(l10n.nutritionMacrosProtein, consumedProteina, targetProteina, theme.primary),
        const SizedBox(height: 10),
        _MacroRow(l10n.nutritionMacrosFat, consumedGrasas, targetGrasas, Colors.purple),
      ]),
    );
  }
}

class _MacroRow extends StatelessWidget {
  final String name;
  final int current, target;
  final Color color;
  const _MacroRow(this.name, this.current, this.target, this.color);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>() ?? AppThemeExtension.dark;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name, style: TextStyle(color: theme.grey, fontSize: 13)),
            Text('${current}g / ${target}g',
                style: TextStyle(color: theme.white, fontSize: 13, fontWeight: FontWeight.w500)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: target > 0 ? (current / target).clamp(0.0, 1.0) : 0.0,
            backgroundColor: theme.border,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}

// ─── Meal Cards ────────────────────────────────────────────────
class _MealCard extends StatelessWidget {
  final String time, emoji, name, description;
  final int calories;
  final List<(String, Color)> tags;
  final bool isChecked;
  final ValueChanged<bool?> onChecked;

  const _MealCard({
    required this.time, required this.emoji, required this.name,
    required this.description, required this.calories, required this.tags,
    required this.isChecked, required this.onChecked,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>() ?? AppThemeExtension.dark;
    return Opacity(opacity: isChecked ? 0.75 : 1.0, child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(time, style: TextStyle(color: theme.primary, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.3)),
              const SizedBox(width: 8),
              Text('$calories kcal', style: TextStyle(color: theme.grey, fontSize: 11)),
              const Spacer(),
              GestureDetector(
                onTap: () => onChecked(!isChecked),
                child: Icon(
                  isChecked ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                  color: isChecked ? Colors.green : theme.greyLight,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 10),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(color: theme.white, fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(description, style: TextStyle(color: theme.grey, fontSize: 12, height: 1.4)),
              ],
            )),
          ]),
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
              child: Text(t.$1, style: TextStyle(color: t.$2, fontSize: 11, fontWeight: FontWeight.w500)),
            )).toList(),
          ),
        ],
      ),
    ));
  }
}

// ─── Hydration Card ────────────────────────────────────────────
class _HydrationCard extends StatefulWidget {
  final int totalHydrationMl;
  final String hydrationSuggestion;
  final int filledGlasses;
  final ValueChanged<int> onGlassesChanged;

  const _HydrationCard({
    super.key,
    required this.totalHydrationMl,
    required this.hydrationSuggestion,
    required this.filledGlasses,
    required this.onGlassesChanged,
  });
  @override
  State<_HydrationCard> createState() => _HydrationCardState();
}

class _HydrationCardState extends State<_HydrationCard> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>() ?? AppThemeExtension.dark;
    final l10n = AppLocalizations.of(context);
    final total = (widget.totalHydrationMl / 350).round().clamp(1, 15);
    final displaySuggestion = widget.hydrationSuggestion.isNotEmpty
        ? widget.hydrationSuggestion
        : l10n.nutritionHydrationInfo(2850, 20);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.water_drop, color: Colors.blue, size: 17),
            const SizedBox(width: 8),
            Text(l10n.nutritionHydrationTitle,
                style: TextStyle(color: theme.white, fontSize: 14, fontWeight: FontWeight.w600)),
            const Spacer(),
            Text(l10n.nutritionHydrationValue(widget.filledGlasses * 350 / 1000, widget.totalHydrationMl / 1000.0),
                style: const TextStyle(color: Colors.blue, fontSize: 14, fontWeight: FontWeight.bold)),
          ]),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: List.generate(total, (i) => GestureDetector(
              onTap: () => widget.onGlassesChanged(widget.filledGlasses == i + 1 ? i : i + 1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 30, height: 30,
                decoration: BoxDecoration(
                  color: i < widget.filledGlasses
                      ? Colors.blue.withValues(alpha: 0.25)
                      : theme.border,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: i < widget.filledGlasses ? Colors.blue : theme.border),
                ),
                child: i < widget.filledGlasses
                    ? const Icon(Icons.check, color: Colors.blue, size: 14)
                    : null,
              ),
            )),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(children: [
              const Icon(Icons.info_outline, color: Colors.blue, size: 13),
              const SizedBox(width: 8),
              Expanded(child: Text(
                displaySuggestion,
                style: TextStyle(color: theme.grey, fontSize: 12, height: 1.4),
              )),
            ]),
          ),
        ],
      ),
    );
  }
}

// ─── Shared helpers ────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>() ?? AppThemeExtension.dark;
    return Text(text,
        style: TextStyle(color: theme.grey, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.4));
  }
}
