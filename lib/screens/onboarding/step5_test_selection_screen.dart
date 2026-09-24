import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../config/app_routes.dart';
import '../../config/onboarding_router.dart'; // Added
import '../../providers/auth_provider.dart';
import '../../l10n/app_localizations.dart';
import 'step5_test_instruction_screen.dart';

class TestSelectionScreen extends StatefulWidget {
  final List<int> completedTests; // índices de tests ya completados
  const TestSelectionScreen({super.key, this.completedTests = const []});

  @override
  State<TestSelectionScreen> createState() => _TestSelectionScreenState();
}

class _TestSelectionScreenState extends State<TestSelectionScreen> {
  late List<int> _completed;
  int _selectedIdx = 0;

  List<_Test> _getTests(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return [
      _Test(
        icon: '🦵',
        tag: l10n.testSquatsTag,
        title: l10n.testSquatsTitle,
        desc: l10n.testSquatsDescShort,
        duration: l10n.testSquatsDurationLabel,
        obligatory: true,
      ),
      _Test(
        icon: '🏃‍♂️',
        tag: l10n.testCooperTag,
        title: l10n.testCooperTitle,
        desc: l10n.testCooperDescShort,
        duration: l10n.testCooperDurationLabel,
        obligatory: false,
      ),
      _Test(
        icon: '💪',
        tag: l10n.testPushupsTag,
        title: l10n.testPushupsTitle,
        desc: l10n.testPushupsDescShort,
        duration: l10n.testPushupsDurationLabel,
        obligatory: false,
      ),
      _Test(
        icon: '🧘',
        tag: l10n.testPlankTag,
        title: l10n.testPlankTitle,
        desc: l10n.testPlankDescShort,
        duration: l10n.testPlankDurationLabel,
        obligatory: false,
      ),
      _Test(
        icon: '🤸‍♀️',
        tag: l10n.testFlexibilityTag,
        title: l10n.testFlexibilityTitle,
        desc: l10n.testFlexibilityDescShort,
        duration: l10n.testFlexibilityDurationLabel,
        obligatory: false,
      ),
    ];
  }

  static const _testKeys = [
    'sentadillas', 'cooper', 'flexiones', 'plancha', 'inclinacion',
  ];

  @override
  void initState() {
    super.initState();
    _completed = List<int>.from(widget.completedTests);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadResultados());
  }

  Future<void> _loadResultados() async {
    final token = context.read<AuthProvider>().token ?? '';
    try {
      final res = await http.get(
        Uri.parse('https://apifitnflai.com/evaluacion/listar-resultados-tests'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (res.statusCode == 200 && mounted) {
        final raw = jsonDecode(res.body);
        if (raw is List) {
          final completados = <int>[];
          for (final r in raw) {
            final nombre = (r['nombre_test'] as String?)?.toLowerCase() ?? '';
            final idx = _testKeys.indexOf(nombre);
            if (idx != -1 && !completados.contains(idx)) completados.add(idx);
          }
          setState(() {
            _completed = completados;
            if (_completed.contains(0)) {
              final next = List.generate(5, (i) => i)
                  .firstWhere((i) => !_completed.contains(i), orElse: () => -1);
              if (next != -1) _selectedIdx = next;
            }
          });
        }
      }
    } catch (e) {
      debugPrint('TEST SELECTION LOAD ERROR: $e');
    }
  }

  bool get _sentadillasCompleted => _completed.contains(0);

  @override
  Widget build(BuildContext context) {
    final tests = _getTests(context);
    final current = tests[_selectedIdx];
    final isDone  = _completed.contains(_selectedIdx);
    final l10n    = AppLocalizations.of(context);
    final allOptionalsDone = _completed.length == tests.length;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(children: [
          // ── Header ──────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(children: [
              if (!_sentadillasCompleted)
                GestureDetector(
                  onTap: () => Navigator.pushReplacementNamed(
                      context, AppRoutes.step4Body),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Icon(Icons.arrow_back_ios_new,
                        color: AppColors.orange, size: 16),
                  ),
                ),
              const Spacer(),
              Text(
                _sentadillasCompleted
                    ? l10n.onboardingTestSelectionCompletedCount(_completed.length, tests.length)
                    : l10n.onboardingStepLabel(4, 6),
                style: const TextStyle(color: AppColors.grey,
                    fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ]),
          ),
          const SizedBox(height: 8),

          // ── Header naranja ───────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
            color: AppColors.orange,
            child: Column(children: [
              const Text('🧪', style: TextStyle(fontSize: 28)),
              const SizedBox(height: 6),
              Text(
                _sentadillasCompleted
                    ? l10n.onboardingTestSelectionCompletedTitle
                    : l10n.onboardingTestSelectionTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white,
                    fontSize: 16, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              Text(
                _sentadillasCompleted
                    ? l10n.onboardingTestSelectionCompletedDesc
                    : l10n.onboardingTestSelectionDesc,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFFFFD0B0),
                    fontSize: 11, height: 1.4),
              ),
            ]),
          ),

          // ── Lista de tests ───────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Column(
                children: List.generate(tests.length, (i) {
                  final t        = tests[i];
                  final selected = i == _selectedIdx;
                  final done     = _completed.contains(i);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: GestureDetector(
                      onTap: done ? null : () => setState(() => _selectedIdx = i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: done
                              ? const Color(0xFF0D2E1A)
                              : selected
                                  ? const Color(0xFF3A1F0A)
                                  : AppColors.card,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: done
                                ? AppColors.greenText.withValues(alpha: 0.6)
                                : selected
                                    ? AppColors.orange
                                    : AppColors.border,
                            width: (done || selected) ? 1.5 : 1,
                          ),
                        ),
                        child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Container(
                            width: 36, height: 36,
                            decoration: BoxDecoration(
                              color: done
                                  ? const Color(0xFF1A4A2A)
                                  : selected
                                      ? const Color(0xFF5A2E0A)
                                      : const Color(0xFF2A2A2A),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(child: Text(t.icon,
                                style: const TextStyle(fontSize: 18))),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              Text(t.tag,
                                  style: TextStyle(
                                      color: done
                                          ? AppColors.greenText
                                          : selected
                                              ? AppColors.orange
                                              : AppColors.grey,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600)),
                              const SizedBox(height: 2),
                              Row(children: [
                                Expanded(
                                  child: Text(t.title,
                                      style: TextStyle(
                                          color: done
                                              ? AppColors.greenText
                                              : selected
                                                  ? AppColors.orange
                                                  : AppColors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700)),
                                ),
                                if (t.obligatory && !done)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF3A1515),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(l10n.onboardingTestSelectionObligatory,
                                        style: const TextStyle(
                                            color: AppColors.redText,
                                            fontSize: 9,
                                            fontWeight: FontWeight.w600)),
                                  ),
                              ]),
                              const SizedBox(height: 3),
                              if (!done)
                                Text(t.desc,
                                    style: const TextStyle(
                                        color: AppColors.grey,
                                        fontSize: 11, height: 1.3)),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(
                                  color: done
                                      ? const Color(0xFF1A4A2A)
                                      : selected
                                          ? const Color(0xFF5A2E0A)
                                          : const Color(0xFF2A2A2A),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  done ? l10n.onboardingTestSelectionCompletedBadge : '⏱ ${t.duration}',
                                  style: TextStyle(
                                      color: done
                                          ? AppColors.greenText
                                          : selected
                                              ? AppColors.orange
                                              : AppColors.grey,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500)),
                              ),
                            ]),
                          ),
                          const SizedBox(width: 8),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            width: 22, height: 22,
                            decoration: BoxDecoration(
                              color: done
                                  ? AppColors.greenText
                                  : selected
                                      ? AppColors.orange
                                      : Colors.transparent,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: done
                                    ? AppColors.greenText
                                    : selected
                                        ? AppColors.orange
                                        : AppColors.border,
                                width: 1.5,
                              ),
                            ),
                            child: (done || selected)
                                ? Icon(
                                    done ? Icons.check : Icons.check,
                                    color: Colors.white, size: 13)
                                : null,
                          ),
                        ]),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),

          // ── Info ─────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF1A2A3A),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF2A4A6A)),
              ),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                const Icon(Icons.info_outline,
                    color: Color(0xFF4A90D9), size: 14),
                const SizedBox(width: 6),
                Expanded(child: Text(
                  _sentadillasCompleted
                      ? l10n.onboardingTestSelectionCompletedInfo
                      : l10n.onboardingTestSelectionInfo,
                  style: const TextStyle(color: Color(0xFF4A90D9),
                      fontSize: 11, height: 1.4),
                )),
              ]),
            ),
          ),

          // ── Botones CTA ───────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(children: [
              // Botón principal: hacer test seleccionado
              if (!isDone)
                SizedBox(
                  width: double.infinity, height: 50,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => TestInstructionScreen(
                        testIndex:      _selectedIdx,
                        fromOnboarding: true,
                        completedTests: _completed,
                      )),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.orange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: Text(l10n.onboardingTestSelectionStartBtn(current.title),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700)),
                  ),
                ),
              // Botón continuar (solo visible si sentadillas completado)
              if (_sentadillasCompleted) ...[
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity, height: 46,
                  child: OutlinedButton(
                    onPressed: () async {
                      final authProvider = Provider.of<AuthProvider>(context, listen: false);
                      final userId = authProvider.user?.id;
                      if (userId != null) {
                        await OnboardingRouter.saveCompletedStep(userId, 5);
                      }
                      if (!context.mounted) return;
                      Navigator.pushReplacementNamed(
                          context, AppRoutes.step6Sport);
                    },                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.white,
                      side: const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      allOptionalsDone
                          ? l10n.onboardingTestSelectionContinueToPlan
                          : l10n.onboardingTestSelectionContinueWithoutTests,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ]),
          ),
        ]),
      ),
    );
  }
}

class _Test {
  final String icon, tag, title, desc, duration;
  final bool obligatory;
  const _Test({required this.icon, required this.tag, required this.title,
      required this.desc, required this.duration, required this.obligatory});
}