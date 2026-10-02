import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../config/app_colors.dart';
import '../../config/onboarding_router.dart'; // Added
import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';
import '../../widgets/shared_widgets.dart';
import '../home/home_screen.dart';

class OnboardingFeedbackScreen extends StatefulWidget {
  final String? fechaInicio; // pasada desde generating_screen si está disponible
  const OnboardingFeedbackScreen({super.key, this.fechaInicio});
  @override
  State<OnboardingFeedbackScreen> createState() => _OnboardingFeedbackScreenState();
}

class _OnboardingFeedbackScreenState extends State<OnboardingFeedbackScreen> {
  Map<String, dynamic>? _user;
  Map<String, dynamic>? _plan;
  List<Map<String, dynamic>> _tests = [];
  bool _loading = true;
  String? _fechaInicioLocal;
  int?    _semanasLocal;

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthProvider>();
    _fechaInicioLocal = auth.onboardingFechaInicio;
    _semanasLocal     = auth.onboardingSemanas;
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final token = context.read<AuthProvider>().token ?? '';
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final results = await Future.wait([
        http.get(Uri.parse('https://apifitnflai.com/users/me'), headers: headers),
        http.get(Uri.parse('https://apifitnflai.com/onboarding/plan/resumen'), headers: headers),
        http.get(Uri.parse('https://apifitnflai.com/evaluacion/listar-resultados-tests'), headers: headers),
      ]);

      if (results[0].statusCode == 200) {
        _user = jsonDecode(results[0].body) as Map<String, dynamic>;
      }
      if (results[1].statusCode == 200) {
        _plan = jsonDecode(results[1].body) as Map<String, dynamic>;
      }
      if (results[2].statusCode == 200) {
        final raw = jsonDecode(results[2].body);
        if (raw is List) {
          _tests = raw.cast<Map<String, dynamic>>();
        }
        debugPrint('TESTS: ${_tests.length} → $_tests');
      }
      if (_plan != null && _plan!['fecha_inicio'] == null) {
        _plan!['fecha_inicio'] = widget.fechaInicio
            ?? _user?['fecha_inicio_deseada']
            ?? _user?['fecha_inicio'];
      }
    } catch (e) {
      debugPrint('FEEDBACK ERROR: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  /// Deduce el nombre del día de la semana a partir de una fecha ISO string
  String _diaDeSemana(BuildContext context, String? fechaIso) {
    if (fechaIso == null || fechaIso.isEmpty) return '—';
    try {
      final dt = DateTime.parse(fechaIso);
      final locale = Localizations.localeOf(context).languageCode;
      final diasEs = ['Lunes','Martes','Miércoles','Jueves','Viernes','Sábado','Domingo'];
      final diasEn = ['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'];
      return locale == 'es' ? diasEs[dt.weekday - 1] : diasEn[dt.weekday - 1];
    } catch (_) {
      return '—';
    }
  }

  String _formatFecha(BuildContext context, String? fechaIso) {
    if (fechaIso == null || fechaIso.isEmpty) return '—';
    try {
      final dt = DateTime.parse(fechaIso);
      final locale = Localizations.localeOf(context).languageCode;
      final mesesEs = ['ene','feb','mar','abr','may','jun',
                     'jul','ago','sep','oct','nov','dic'];
      final mesesEn = ['Jan','Feb','Mar','Apr','May','Jun',
                     'Jul','Aug','Sep','Oct','Nov','Dec'];
      return locale == 'es'
          ? '${dt.day} ${mesesEs[dt.month - 1]} ${dt.year}'
          : '${dt.day} ${mesesEn[dt.month - 1]} ${dt.year}';
    } catch (_) {
      return fechaIso;
    }
  }

  @override
  Widget build(BuildContext context) {
    final apodo  = (_user?['apodo']  as String?)?.trim() ?? '';
    final nombre = (_user?['nombre'] as String?)?.trim() ?? '';
    final nombreMostrado = apodo.isNotEmpty ? apodo : (nombre.isNotEmpty ? nombre : 'Campeón');

    // Datos del plan
    String tituloPlan = _plan?['titulo_plan'] as String? ?? '—';
    if (tituloPlan.toLowerCase().contains('kilómetros')) {
      tituloPlan = tituloPlan.toLowerCase().replaceAll('kilómetros', 'k');
      tituloPlan = tituloPlan.substring(0, 1).toUpperCase() + tituloPlan.substring(1);
    }
    final rawResumen = (_plan?['resumen_personalizado'] as List<dynamic>?)
                            ?.map((e) => e.toString()).toList() ?? [];
    final List<String> resumenList = [];
    for (var line in rawResumen) {
      if (line.contains('Consideramos que entrenas') || (line.contains('entrenas a') && (line.contains('msnm') || line.contains('s.n.m.')))) {
        continue;
      }
      if (line.contains('a nivel del mar') && (line.contains('altitud') || line.contains('metros') || line.contains('m '))) {
        line = line.replaceAll('a nivel del mar', 'sobre el nivel del mar');
      }
      resumenList.add(line);
    }

    // Duración en semanas — del AuthProvider (guardado en step2) o del plan
    final semanasRaw  = _semanasLocal                            ??
                        _plan?['duracion_semanas']               ??
                        _plan?['duracion_semanas_objetivo']      ??
                        _plan?['semanas_entrenamiento'];
    final weeksSuffix = Localizations.localeOf(context).languageCode == 'es' ? 'semanas' : 'weeks';
    final semanas = semanasRaw != null ? '$semanasRaw $weeksSuffix' : '—';

    // Disciplina desde usuario
    final disciplina = (_user?['objetivo_principal']  as String?) ?? '—';
    final nombreDisciplina = (_user?['nombre_disciplina'] as String?);
    final diasEntrenamiento = (_user?['dias_entrenamiento'] as List<dynamic>?)?.map((e) => e.toString()).join(', ');
    final ciudad = (_user?['ciudad'] as String?);
    final altitud = (_user?['altitud'] as num?)?.toString();

    // Fecha de inicio — del AuthProvider (guardado en step4) o del plan/usuario
    final fechaInicioStr = _fechaInicioLocal
                        ?? (_plan?['fecha_inicio']         as String?)
                        ?? (_user?['fecha_inicio_deseada'] as String?)
                        ?? (_user?['fecha_inicio']         as String?);
    final diaInicio   = _diaDeSemana(context, fechaInicioStr);
    final fechaInicio = _formatFecha(context, fechaInicioStr);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator(color: AppColors.orange))
                : SingleChildScrollView(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                      // ── Hero con imagen de fondo ─────────
                      _PlanHeroCard(
                        nombreMostrado: nombreMostrado,
                        disciplina:     disciplina,
                        nombreDisciplina: nombreDisciplina,
                        diasEntrenamiento: diasEntrenamiento,
                        ciudad: ciudad,
                        altitud: altitud != null ? '$altitud m.s.n.m.' : null,
                        tituloPlan:     tituloPlan,
                        semanas:        semanas,
                        diaInicio:      diaInicio,
                        fechaInicio:    fechaInicio,
                      ),

                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                      // ── Resumen personalizado ─────────────
                      if (resumenList.isNotEmpty) ...[
                        Text(AppLocalizations.of(context).onboardingFeedbackDetailTitle,
                            style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w800)),
                        const SizedBox(height: 10),
                        ...resumenList.map((linea) => _ResumenItem(texto: linea)),
                        const SizedBox(height: 20),
                      ],

                      // ── Tarjetas métricas de tests ───────
                      _TestResultCards(tests: _tests),
                      const SizedBox(height: 10),
                      _ZonasCard(user: _user),
                      const SizedBox(height: 16),

                      // ── Cierre ───────────────────────────
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1400),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.orange.withValues(alpha: 0.6)),
                        ),
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                                color: Color(0xFFAAAAAA), fontSize: 12, height: 1.8),
                            children: [
                              TextSpan(text: AppLocalizations.of(context).onboardingFeedbackEcosystemTitle),
                              TextSpan(text: AppLocalizations.of(context).onboardingFeedbackEcosystemHighlight,
                                  style: const TextStyle(
                                      color: AppColors.orange,
                                      fontWeight: FontWeight.w600)),
                              TextSpan(text: AppLocalizations.of(context).onboardingFeedbackWorkingForYou),
                              TextSpan(text: AppLocalizations.of(context).onboardingFeedbackHasReason,
                                  style: const TextStyle(
                                      color: AppColors.orange,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                        ]),
                      ),  // end Padding
                    ]),  // end outer Column
                  ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: Consumer<ProfileProvider>(
              builder: (context, profileProvider, child) {
                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                final token = authProvider.token ?? '';
                final isLoading = profileProvider.isLoadingSubscription;
                final errorMessage = profileProvider.subscriptionError;

                return PrimaryButton(
                  labelWidget: isLoading
                      ? const Center(child: SizedBox(
                          width: 24, height: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        ))
                      : Text(
                          AppLocalizations.of(context).onboardingFeedbackStartFreeTrial,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)
                        ),
                  onTap: isLoading
                      ? null
                      : () async {
                          final success = await profileProvider.startFreeTrial(token);
                          if (success) {
                            if (!context.mounted) return;
                            final authProvider = Provider.of<AuthProvider>(context, listen: false);
                            await authProvider.refreshUser();
                            final userId = authProvider.user?.id;
                            if (userId != null) {
                              await OnboardingRouter.saveCompletedStep(userId, 8);
                            }
                            if (!context.mounted) return;
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (_) => const HomeScreen(fromOnboarding: true)),
                              (_) => false,
                            );
                          } else {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(errorMessage ?? 'Error desconocido')),
                            );
                          }
                        },
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// PLAN HERO CARD
// ═══════════════════════════════════════════════════════════════
class _PlanHeroCard extends StatelessWidget {
  final String nombreMostrado, disciplina, tituloPlan, semanas, diaInicio, fechaInicio;
  final String? nombreDisciplina, diasEntrenamiento, ciudad, altitud;
  const _PlanHeroCard({
    required this.nombreMostrado,
    required this.disciplina,
    required this.tituloPlan,
    required this.semanas,
    required this.diaInicio,
    required this.fechaInicio,
    this.nombreDisciplina,
    this.diasEntrenamiento,
    this.ciudad,
    this.altitud,
  });

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    return SizedBox(
      height: screenH * 0.70,
      child: Stack(children: [
        // ── Imagen de fondo ────────────────────────
        Positioned.fill(
          child: Image.asset(
            'assets/images/Frame_111.png',
            fit: BoxFit.cover,
          ),
        ),
        // Círculos decorativos
        Positioned(
          top: -40, right: -40,
          child: Container(
            width: 200, height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.orange.withValues(alpha: 0.06),
            ),
          ),
        ),

        // ── Degradado: transparente arriba → negro abajo ────
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x00000000),
                  Color(0x44000000),
                  Color(0xDD000000),
                  Color(0xFF000000),
                ],
                stops: [0.0, 0.35, 0.75, 1.0],
              ),
            ),
          ),
        ),

        // ── Contenido ───────────────────────────────
        Positioned(
          bottom: 28, left: 20, right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Emoji + saludo centrado
              Center(child: Column(children: [
                const Text('😁', style: TextStyle(fontSize: 64)),
                const SizedBox(height: 12),
                Text(AppLocalizations.of(context).onboardingFeedbackReadyTitle(nombreMostrado),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context).onboardingFeedbackReadySubtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Color(0xFFE8C090), fontSize: 15, height: 1.5)),
              ])),
              const SizedBox(height: 28),

              // Título del plan
              Text(disciplina,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      height: 1.2)),
              const SizedBox(height: 12),
              
              // Tags
              Wrap(spacing: 8, runSpacing: 8, children: [
                if (nombreDisciplina != null) _Tag(nombreDisciplina!),
                if (diasEntrenamiento != null) _Tag(diasEntrenamiento!),
                if (ciudad != null) _Tag(ciudad!),
                if (altitud != null) _Tag(altitud!),
              ]),
              const SizedBox(height: 18),

              // Métricas en dos columnas
              Row(children: [
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      const Text('🎯', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 6),
                      Text(AppLocalizations.of(context).onboardingFeedbackDurationLabel,
                          style: const TextStyle(color: Colors.white54, fontSize: 13)),
                    ]),
                    const SizedBox(height: 4),
                    Text(semanas,
                        style: const TextStyle(
                            color: AppColors.orange,
                            fontSize: 18,
                            fontWeight: FontWeight.w800)),
                  ],
                )),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      const Text('📅', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 6),
                      Text(AppLocalizations.of(context).onboardingFeedbackStartLabel,
                          style: const TextStyle(color: Colors.white54, fontSize: 13)),
                    ]),
                    const SizedBox(height: 4),
                    Text(diaInicio != '—'
                            ? '$diaInicio, $fechaInicio' : fechaInicio,
                        style: const TextStyle(
                            color: AppColors.orange,
                            fontSize: 16,
                            fontWeight: FontWeight.w800)),
                  ],
                )),
              ]),
            ],
          ),
        ),
      ]),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  const _Tag(this.label);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
    decoration: BoxDecoration(
      color: Colors.black.withValues(alpha: 0.5),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: Colors.white.withValues(alpha: 0.25), width: 1),
    ),
    child: Text(label,
        style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w500)),
  );
}

// ═══════════════════════════════════════════════════════════════
// RESUMEN ITEM
// ═══════════════════════════════════════════════════════════════
class _ResumenItem extends StatelessWidget {
  final String texto;
  const _ResumenItem({required this.texto});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('• ', style: TextStyle(color: AppColors.orange, fontSize: 16, height: 1.3)),
      Expanded(
        child: Text(texto,
            style: const TextStyle(
                color: AppColors.greyLight, fontSize: 13, height: 1.5)),
      ),
    ]),
  );
}

// ═══════════════════════════════════════════════════════════════
// METRIC BASE CARD
// ═══════════════════════════════════════════════════════════════
class _MetricCard extends StatelessWidget {
  final String title, explain, explainHighlight;
  final Widget body;
  const _MetricCard({
    required this.title,
    required this.explain,
    required this.explainHighlight,
    required this.body,
  });

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.border),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title,
          style: const TextStyle(
              color: AppColors.white, fontSize: 14, fontWeight: FontWeight.w700)),
      const SizedBox(height: 6),
      RichText(
        text: TextSpan(
          style: const TextStyle(color: AppColors.grey, fontSize: 12, height: 1.6),
          children: [
            TextSpan(text: explain),
            TextSpan(text: ' $explainHighlight',
                style: const TextStyle(color: Color(0xFFAAAAAA))),
          ],
        ),
      ),
      const SizedBox(height: 12),
      body,
    ]),
  );
}

// ═══════════════════════════════════════════════════════════════
// TEST RESULT CARDS
// ═══════════════════════════════════════════════════════════════
class _TestResultCards extends StatelessWidget {
  final List<Map<String, dynamic>> tests;
  const _TestResultCards({required this.tests});

  List<Map<String, dynamic>> _getLocalizedTestConfig(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final isEs = locale == 'es';
    return [
      {
        'nombre': 'cooper',
        'titulo': isEs ? 'Resistencia cardiovascular' : 'Cardiovascular endurance',
        'subtitulo': isEs ? 'Test de Cooper' : 'Cooper test',
        'emoji': '🫀',
        'accent': const Color(0xFF1A5A8A),
        'bg': const Color(0xFF080E1A),
        'labels': isEs ? ['Bajo', 'Medio', 'Bueno', 'Alto', 'Élite'] : ['Low', 'Medium', 'Good', 'High', 'Elite'],
        'desc': isEs ? 'Refleja qué tan eficiente es tu corazón cuando te esfuerzas.' : 'Reflects how efficient your heart is when you exert yourself.',
      },
      {
        'nombre': 'flexiones',
        'titulo': isEs ? 'Fuerza de tren superior' : 'Upper body strength',
        'subtitulo': isEs ? 'Flexiones en 1 minuto' : 'Push-ups in 1 minute',
        'emoji': '💪',
        'accent': const Color(0xFF8A3A3A),
        'bg': const Color(0xFF1A0808),
        'labels': isEs ? ['Bajo', 'Medio', 'Bueno', 'Alto', 'Élite'] : ['Low', 'Medium', 'Good', 'High', 'Elite'],
        'desc': isEs ? 'Indica la capacidad de empuje y resistencia muscular del tren superior.' : 'Indicates pushing capacity and muscular endurance of the upper body.',
      },
      {
        'nombre': 'plancha',
        'titulo': isEs ? 'Core / Estabilidad' : 'Core / Stability',
        'subtitulo': isEs ? 'Plancha abdominal' : 'Abdominal plank',
        'emoji': '🧘',
        'accent': const Color(0xFF6B3A9B),
        'bg': const Color(0xFF130A1E),
        'labels': isEs ? ['Bajo', 'Medio', 'Bueno', 'Alto', 'Élite'] : ['Low', 'Medium', 'Good', 'High', 'Elite'],
        'desc': isEs ? 'El core es la base de todo movimiento. Un core fuerte reduce lesiones.' : 'The core is the foundation of all movement. A strong core reduces injuries.',
      },
      {
        'nombre': 'sentadillas',
        'titulo': isEs ? 'Fuerza de tren inferior' : 'Lower body strength',
        'subtitulo': isEs ? 'Sentadillas en 1 minuto' : 'Squats in 1 minute',
        'emoji': '🦵',
        'accent': const Color(0xFF8A4A10),
        'bg': const Color(0xFF1E1208),
        'labels': isEs ? ['Bajo', 'Medio', 'Bueno', 'Alto', 'Élite'] : ['Low', 'Medium', 'Good', 'High', 'Elite'],
        'desc': isEs ? 'La fuerza de tus piernas determina cuánto puedes sostener el ritmo sin lesionarte.' : 'Your leg strength determines how long you can sustain the pace without injury.',
      },
      {
        'nombre': 'inclinacion',
        'titulo': isEs ? 'Flexibilidad' : 'Flexibility',
        'subtitulo': isEs ? 'Inclinación hacia adelante' : 'Forward bend',
        'emoji': '🤸',
        'accent': const Color(0xFF1A6A3A),
        'bg': const Color(0xFF081A10),
        'labels': isEs ? ['Bajo', 'Medio', 'Bueno', 'Alto'] : ['Low', 'Medium', 'Good', 'High'],
        'desc': isEs ? 'La flexibilidad reduce el riesgo de lesiones y mejora la economía de movimiento.' : 'Flexibility reduces risk of injury and improves movement economy.',
      },
    ];
  }

  Map<String, dynamic>? _findTest(String nombre) {
    try {
      return tests.firstWhere(
        (t) => (t['nombre_test'] as String?)?.toLowerCase() == nombre,
      );
    } catch (_) {
      return null;
    }
  }

  double _calcPuntaje(String nombre, double valor) {
    switch (nombre) {
      case 'sentadillas':
        if (valor >= 45) return 4;
        if (valor >= 35) return 3;
        if (valor >= 25) return 2;
        if (valor >= 15) return 1;
        return 0;
      case 'flexiones':
        if (valor >= 40) return 4;
        if (valor >= 25) return 3;
        if (valor >= 15) return 2;
        if (valor >= 8)  return 1;
        return 0;
      case 'plancha':
        if (valor >= 120) return 4;
        if (valor >= 60)  return 3;
        if (valor >= 30)  return 2;
        if (valor >= 15)  return 1;
        return 0;
      case 'cooper':
        if (valor >= 2800) return 4;
        if (valor >= 2400) return 3;
        if (valor >= 2000) return 2;
        if (valor >= 1600) return 1;
        return 0;
      case 'inclinacion':
        return valor.clamp(0, 3);
      default:
        return 0;
    }
  }

  Color _colorForPct(double pct) {
    if (pct >= 0.75) return AppColors.greenText;
    if (pct >= 0.50) return const Color(0xFF81C784);
    if (pct >= 0.25) return AppColors.orange;
    return AppColors.redText;
  }

  @override
  Widget build(BuildContext context) {
    final widgets = <Widget>[];
    final testConfig = _getLocalizedTestConfig(context);

    for (final cfg in testConfig) {
      final nombre = cfg['nombre'] as String;
      final test   = _findTest(nombre);
      if (test == null) continue;

      final puntajeRaw = (test['puntaje_calculado'] as num?)?.toDouble();
      final resultadoValor = (test['resultado_valor'] as num?)?.toDouble() ?? 0;
      final puntaje = puntajeRaw ?? _calcPuntaje(nombre, resultadoValor);
      final labels  = cfg['labels'] as List<String>;
      // Escala 0-3 o 0-4 según cantidad de labels
      final maxPts  = (labels.length - 1).toDouble();
      final pct     = maxPts > 0 ? (puntaje / maxPts).clamp(0.0, 1.0) : 0.0;
      final labelIdx = puntaje.round().clamp(0, labels.length - 1);
      final label    = labels[labelIdx];
      final accent   = cfg['accent'] as Color;
      final bg       = cfg['bg'] as Color;
      final nivelColor = _colorForPct(pct);

      widgets.add(Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: accent.withValues(alpha: 0.5)),
          boxShadow: [BoxShadow(color: accent.withValues(alpha: 0.07),
              blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.15),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
            ),
            child: Row(children: [
              Text(cfg['emoji'] as String, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Text((cfg['titulo'] as String).toUpperCase(),
                      style: TextStyle(color: accent, fontSize: 13,
                          fontWeight: FontWeight.w800, letterSpacing: 0.7)),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: nivelColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: nivelColor.withValues(alpha: 0.4)),
                    ),
                    child: Text(label, style: TextStyle(
                        color: nivelColor, fontSize: 10, fontWeight: FontWeight.w700)),
                  ),
                ]),
              ])),
            ]),
          ),
          // Body
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: pct,
                  minHeight: 8,
                  backgroundColor: const Color(0xFF2A2A2A),
                  valueColor: AlwaysStoppedAnimation<Color>(nivelColor),
                ),
              ),
              const SizedBox(height: 5),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: labels.map((l) => Text(l, style: const TextStyle(
                      color: AppColors.greyLight, fontSize: 10))).toList()),
              const SizedBox(height: 10),
              Text(cfg['desc'] as String,
                  style: const TextStyle(
                      color: AppColors.grey, fontSize: 12, height: 1.5)),
            ]),
          ),
        ]),
      ));
      widgets.add(const SizedBox(height: 10));
    }

    if (widgets.isEmpty) return const SizedBox.shrink();
    return Column(children: widgets);
  }
}

// ═══════════════════════════════════════════════════════════════
// ZONAS DE ENTRENAMIENTO CARD
// ═══════════════════════════════════════════════════════════════
class _ZonasCard extends StatelessWidget {
  final Map<String, dynamic>? user;
  const _ZonasCard({this.user});

  // FC máx estimada: 220 - edad
  int _fcMax() {
    final fechaNac = user?['fecha_nacimiento'] as String?;
    if (fechaNac == null) return 190;
    try {
      final dt  = DateTime.parse(fechaNac);
      final age = DateTime.now().year - dt.year;
      return 220 - age;
    } catch (_) { return 190; }
  }

  @override
  Widget build(BuildContext context) {
    final fcMax = _fcMax();
    final locale = Localizations.localeOf(context).languageCode;
    final l10n = AppLocalizations.of(context);
    final isEs = locale == 'es';
    final unit = isEs ? 'lpm' : 'bpm';

    final zonas = [
      _Zona('Z1', isEs ? 'Recuperación activa' : 'Active recovery',  0.50, 0.60, const Color(0xFF4FC3F7)),
      _Zona('Z2', isEs ? 'Base aeróbica' : 'Aerobic base',        0.60, 0.70, const Color(0xFF81C784)),
      _Zona('Z3', isEs ? 'Resistencia aeróbica' : 'Aerobic endurance', 0.70, 0.80, const Color(0xFFFFF176)),
      _Zona('Z4', isEs ? 'Umbral anaeróbico' : 'Anaerobic threshold',    0.80, 0.90, const Color(0xFFFFB74D)),
      _Zona('Z5', isEs ? 'Máximo esfuerzo' : 'Maximum effort',      0.90, 1.00, const Color(0xFFE57373)),
    ];

    return _MetricCard(
      title: l10n.onboardingFeedbackZonesTitle,
      explain: l10n.onboardingFeedbackZonesDesc,
      explainHighlight: l10n.onboardingFeedbackZonesHighlight,
      body: Column(children: [
        ...zonas.map((z) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(children: [
            Container(width: 8, height: 8,
                decoration: BoxDecoration(color: z.color, shape: BoxShape.circle)),
            const SizedBox(width: 8),
            SizedBox(width: 24,
                child: Text(z.name,
                    style: TextStyle(color: z.color, fontSize: 11, fontWeight: FontWeight.w600))),
            Expanded(child: Text(z.desc,
                style: const TextStyle(color: AppColors.grey, fontSize: 11))),
            Text('${(fcMax * z.pctMin).round()}–${(fcMax * z.pctMax).round()} $unit',
                style: TextStyle(color: z.color, fontSize: 11, fontWeight: FontWeight.w600)),
          ]),
        )),
        const Divider(color: Color(0xFF222222), height: 16),
        RichText(
          text: TextSpan(
            style: const TextStyle(color: Color(0xFF444444), fontSize: 10, height: 1.6),
            children: [
              TextSpan(text: l10n.onboardingFeedbackZonesDisclaimer),
              TextSpan(text: l10n.onboardingFeedbackZonesDisclaimerAction,
                  style: const TextStyle(color: AppColors.orange)),
            ],
          ),
        ),
      ]),
    );
  }
}

class _Zona {
  final String name, desc;
  final double pctMin, pctMax;
  final Color color;
  const _Zona(this.name, this.desc, this.pctMin, this.pctMax, this.color);
}

// fin del archivo