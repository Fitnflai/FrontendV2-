import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../l10n/app_localizations.dart';
import 'step5_test_selection_screen.dart';
import 'step5_test_timer_screen.dart';

// ═══════════════════════════════════════════════════════════════
// DATA MODEL
// ═══════════════════════════════════════════════════════════════
class TestData {
  final String icon, tag, title, description;
  final List<TestStep> steps;
  final List<String> errors;
  final String measuresTitle, measuresDesc;
  final String startLabel;
  final String? imageAsset;

  const TestData({
    required this.icon,
    required this.tag,
    required this.title,
    required this.description,
    required this.steps,
    required this.errors,
    required this.measuresTitle,
    required this.measuresDesc,
    required this.startLabel,
    this.imageAsset,
  });
}

class TestStep {
  final String main;
  final String? tip;
  const TestStep(this.main, [this.tip]);
}

// ─── All tests data ────────────────────────────────────────────
List<TestData> getTests(BuildContext context) {
  final l10n = AppLocalizations.of(context);
  return [
    // 1. Sentadillas en 1 minuto
    TestData(
      icon: '🦵',
      tag: l10n.testSquatsTag,
      title: l10n.testSquatsTitle,
      description: l10n.testSquatsDescLong,
      steps: [
        TestStep(l10n.testSquatsStep1Main, l10n.testSquatsStep1Tip),
        TestStep(l10n.testSquatsStep2Main, l10n.testSquatsStep2Tip),
        TestStep(l10n.testSquatsStep3Main, l10n.testSquatsStep3Tip),
        TestStep(l10n.testSquatsStep4Main, l10n.testSquatsStep4Tip),
      ],
      errors: [
        l10n.testSquatsError1,
        l10n.testSquatsError2,
        l10n.testSquatsError3,
      ],
      measuresTitle: l10n.onboardingTestInstructionMeasuresTitle,
      measuresDesc: l10n.testSquatsMeasuresDesc,
      startLabel: l10n.testSquatsStartLabel,
      imageAsset: 'assets/images/tests/sentadillas.jpg',
    ),

    // 2. Test de Cooper
    TestData(
      icon: '🏃‍♂️',
      tag: l10n.testCooperTag,
      title: l10n.testCooperTitle,
      description: l10n.testCooperDescLong,
      steps: [
        TestStep(l10n.testCooperStep1Main, l10n.testCooperStep1Tip),
        TestStep(l10n.testCooperStep2Main),
        TestStep(l10n.testCooperStep3Main, l10n.testCooperStep3Tip),
        TestStep(l10n.testCooperStep4Main, l10n.testCooperStep4Tip),
      ],
      errors: [
        l10n.testCooperError1,
        l10n.testCooperError2,
        l10n.testCooperError3,
      ],
      measuresTitle: l10n.onboardingTestInstructionMeasuresTitle,
      measuresDesc: l10n.testCooperMeasuresDesc,
      startLabel: l10n.testCooperStartLabel,
      imageAsset: 'assets/images/tests/test_de_cooper.jpg',
    ),

    // 3. Flexiones en 1 minuto
    TestData(
      icon: '💪',
      tag: l10n.testPushupsTag,
      title: l10n.testPushupsTitle,
      description: l10n.testPushupsDescLong,
      steps: [
        TestStep(l10n.testPushupsStep1Main, l10n.testPushupsStep1Tip),
        TestStep(l10n.testPushupsStep2Main, l10n.testPushupsStep2Tip),
        TestStep(l10n.testPushupsStep3Main),
        TestStep(l10n.testPushupsStep4Main, l10n.testPushupsStep4Tip),
      ],
      errors: [
        l10n.testPushupsError1,
        l10n.testPushupsError2,
        l10n.testPushupsError3,
      ],
      measuresTitle: l10n.onboardingTestInstructionMeasuresTitle,
      measuresDesc: l10n.testPushupsMeasuresDesc,
      startLabel: l10n.testPushupsStartLabel,
      imageAsset: 'assets/images/tests/flexiones_de_pecho.jpg',
    ),

    // 4. Plancha abdominal
    TestData(
      icon: '🧘',
      tag: l10n.testPlankTag,
      title: l10n.testPlankTitle,
      description: l10n.testPlankDescLong,
      steps: [
        TestStep(l10n.testPlankStep1Main, l10n.testPlankStep1Tip),
        TestStep(l10n.testPlankStep2Main, l10n.testPlankStep2Tip),
        TestStep(l10n.testPlankStep3Main),
        TestStep(l10n.testPlankStep4Main, l10n.testPlankStep4Tip),
      ],
      errors: [
        l10n.testPlankError1,
        l10n.testPlankError2,
        l10n.testPlankError3,
        l10n.testPlankError4,
      ],
      measuresTitle: l10n.onboardingTestInstructionMeasuresTitle,
      measuresDesc: l10n.testPlankMeasuresDesc,
      startLabel: l10n.testPlankStartLabel,
      imageAsset: 'assets/images/tests/plancha_abdominal.jpeg',
    ),

    // 5. Inclinación hacia adelante
    TestData(
      icon: '🤸‍♀️',
      tag: l10n.testFlexibilityTag,
      title: l10n.testFlexibilityTitle,
      description: l10n.testFlexibilityDescLong,
      steps: [
        TestStep(l10n.testFlexibilityStep1Main, l10n.testFlexibilityStep1Tip),
        TestStep(l10n.testFlexibilityStep2Main, l10n.testFlexibilityStep2Tip),
        TestStep(l10n.testFlexibilityStep3Main, l10n.testFlexibilityStep3Tip),
        TestStep(l10n.testFlexibilityStep4Main, l10n.testFlexibilityStep4Tip),
      ],
      errors: [
        l10n.testFlexibilityError1,
        l10n.testFlexibilityError2,
        l10n.testFlexibilityError3,
      ],
      measuresTitle: l10n.onboardingTestInstructionMeasuresTitle,
      measuresDesc: l10n.testFlexibilityMeasuresDesc,
      startLabel: l10n.testFlexibilityStartLabel,
      imageAsset: 'assets/images/tests/inclinacion_hacia_adelante.jpg',
    ),
  ];
}

// ═══════════════════════════════════════════════════════════════
// SCREEN
// ═══════════════════════════════════════════════════════════════
class TestInstructionScreen extends StatelessWidget {
  final int testIndex;
  final bool fromOnboarding;
  final List<int> completedTests;
  const TestInstructionScreen({
    super.key,
    required this.testIndex,
    this.fromOnboarding = false,
    this.completedTests = const [],
  });

  @override
  Widget build(BuildContext context) {
    final test = getTests(context)[testIndex];
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(children: [
          // ── Top bar ──────────────────────────────
          fromOnboarding
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Row(children: [
                    GestureDetector(
                      onTap: () => Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) => const TestSelectionScreen())),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Icon(Icons.arrow_back_ios_new, color: AppColors.orange, size: 16),
                      ),
                    ),
                    const Spacer(),
                    Text(l10n.onboardingStepLabel(4, 6),
                        style: const TextStyle(color: AppColors.grey, fontSize: 14, fontWeight: FontWeight.w500)),
                  ]),
                )
              : _TopBar(),
          // ── Step tabs ────────────────────────────
          _StepTabs(currentStep: 0),
          const SizedBox(height: 16),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ── Test header card ──────────────
                  _TestHeaderCard(test: test),
                  const SizedBox(height: 14),

                  // ── Illustration placeholder ──────
                  _IllustrationBox(icon: test.icon, imageAsset: test.imageAsset),
                  const SizedBox(height: 20),

                  // ── Cómo hacerlo ──────────────────
                  Text(l10n.onboardingTestInstructionHowToTitle,
                      style: const TextStyle(
                          color: AppColors.orange,
                          fontSize: 16,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 14),
                  ...test.steps.asMap().entries.map((e) =>
                      _StepCard(number: e.key + 1, step: e.value)),
                  const SizedBox(height: 20),

                  // ── Errores comunes ───────────────
                  _ErrorsCard(errors: test.errors),
                  const SizedBox(height: 14),

                  // ── Qué mide ─────────────────────
                  _MeasuresCard(
                      title: test.measuresTitle, desc: test.measuresDesc),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // ── CTA button ───────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TestTimerScreen(
                      testIndex:      testIndex,
                      fromOnboarding: fromOnboarding,
                      completedTests: completedTests,
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: Text(test.startLabel,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// TOP BAR
// ═══════════════════════════════════════════════════════════════
class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(l10n.onboardingTestInstructionGreeting('Nico'),
              style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w800)),
          Text(l10n.onboardingTestInstructionDateSubtitle('Martes', 2),
              style: const TextStyle(color: AppColors.grey, fontSize: 13)),
        ]),
        const Spacer(),
        // Menú
        const Icon(Icons.more_horiz, color: AppColors.grey, size: 24),
        const SizedBox(width: 12),
        // Avatar
        Container(
          width: 40, height: 40,
          decoration: const BoxDecoration(
              color: AppColors.orange, shape: BoxShape.circle),
          child: const Center(
              child: Text('N',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700))),
        ),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// STEP TABS  (1 Instrucción · 2 Registro · 3 Feedback)
// ═══════════════════════════════════════════════════════════════
class _StepTabs extends StatelessWidget {
  final int currentStep;
  const _StepTabs({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final labels = [
      l10n.onboardingTestInstructionTabInstruction,
      l10n.onboardingTestInstructionTabRecord,
      l10n.onboardingTestInstructionTabFeedback
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Row(
        children: List.generate(3, (i) {
          final active = i == currentStep;
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: i < 2 ? 8 : 0),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: active ? AppColors.orange : AppColors.card,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(children: [
                Text('${i + 1}',
                    style: TextStyle(
                        color: active ? Colors.white : AppColors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w800)),
                Text(labels[i],
                    style: TextStyle(
                        color: active ? Colors.white : AppColors.grey,
                        fontSize: 11,
                        fontWeight: active
                            ? FontWeight.w600
                            : FontWeight.w400)),
              ]),
            ),
          );
        }),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// TEST HEADER CARD
// ═══════════════════════════════════════════════════════════════
class _TestHeaderCard extends StatelessWidget {
  final TestData test;
  const _TestHeaderCard({required this.test});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: AppColors.card, borderRadius: BorderRadius.circular(14)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text(test.icon, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(test.title,
                style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700)),
          ),
        ]),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
              color: const Color(0xFF3A1515),
              borderRadius: BorderRadius.circular(20)),
          child: Text(l10n.onboardingTestSelectionObligatory,
              style: const TextStyle(
                  color: AppColors.redText,
                  fontSize: 10,
                  fontWeight: FontWeight.w600)),
        ),
        const SizedBox(height: 10),
        Text(test.description,
            style: const TextStyle(
                color: AppColors.greyLight, fontSize: 13, height: 1.55)),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// ILLUSTRATION BOX
// ═══════════════════════════════════════════════════════════════
class _IllustrationBox extends StatelessWidget {
  final String icon;
  final String? imageAsset;
  const _IllustrationBox({required this.icon, this.imageAsset});

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(14),
    child: Container(
      width: double.infinity,
      height: 180,
      color: AppColors.card,
      child: imageAsset != null
          ? Image.asset(
              imageAsset!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Center(
                child: Text(icon, style: const TextStyle(fontSize: 64)),
              ),
            )
          : Center(
              child: Text(icon, style: const TextStyle(fontSize: 64)),
            ),
    ),
  );
}

// ═══════════════════════════════════════════════════════════════
// STEP CARD
// ═══════════════════════════════════════════════════════════════
class _StepCard extends StatelessWidget {
  final int number;
  final TestStep step;
  const _StepCard({required this.number, required this.step});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Number circle
        Container(
          width: 26, height: 26,
          decoration: const BoxDecoration(
              color: AppColors.orange, shape: BoxShape.circle),
          child: Center(
            child: Text('$number',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(step.main,
              style: const TextStyle(
                  color: AppColors.white, fontSize: 14, height: 1.5)),
        ),
      ]),
      if (step.tip != null) ...[
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 38),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const CircleAvatar(
                radius: 3, backgroundColor: AppColors.orange),
            const SizedBox(width: 8),
            Expanded(
              child: Text(step.tip!,
                  style: const TextStyle(
                      color: AppColors.orange,
                      fontSize: 12,
                      height: 1.4,
                      fontStyle: FontStyle.italic)),
            ),
          ]),
        ),
      ],
    ]),
  );
}

// ═══════════════════════════════════════════════════════════════
// ERRORS CARD
// ═══════════════════════════════════════════════════════════════
class _ErrorsCard extends StatelessWidget {
  final List<String> errors;
  const _ErrorsCard({required this.errors});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2E1515),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF6B2020)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.warning_amber_rounded,
              color: AppColors.orange, size: 18),
          const SizedBox(width: 8),
          Text(l10n.onboardingTestInstructionErrorsTitle,
              style: const TextStyle(
                  color: AppColors.orange,
                  fontSize: 14,
                  fontWeight: FontWeight.w700)),
        ]),
        const SizedBox(height: 12),
        ...errors.map((e) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Padding(
              padding: EdgeInsets.only(top: 5),
              child: CircleAvatar(
                  radius: 3, backgroundColor: AppColors.redText),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(e,
                  style: const TextStyle(
                      color: AppColors.greyLight,
                      fontSize: 13,
                      height: 1.4)),
            ),
          ]),
        )),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// MEASURES CARD
// ═══════════════════════════════════════════════════════════════
class _MeasuresCard extends StatelessWidget {
  final String title, desc;
  const _MeasuresCard({required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A3A2A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.greenMid),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Text('✅', style: TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(l10n.onboardingTestInstructionMeasuresTitle,
                style: const TextStyle(
                    color: AppColors.greenText,
                    fontSize: 14,
                    fontWeight: FontWeight.w700)),
          ),
        ]),
        const SizedBox(height: 8),
        Text(desc,
            style: const TextStyle(
                color: AppColors.greyLight, fontSize: 13, height: 1.5)),
      ]),
    );
  }
}