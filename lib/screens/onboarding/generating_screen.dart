import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../config/app_colors.dart';
import '../../config/app_routes.dart';
import '../../providers/auth_provider.dart';

class GeneratingScreen extends StatefulWidget {
  const GeneratingScreen({super.key});
  @override
  State<GeneratingScreen> createState() => _GeneratingScreenState();
}

class _GeneratingScreenState extends State<GeneratingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotCtrl;
  int _visibleStep = -1;

  List<_PlanStep> _getSteps(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return [
      _PlanStep(l10n.onboardingGeneratingStepParq,                          _StepState.done),
      _PlanStep(l10n.onboardingGeneratingStepUserProfile,                    _StepState.done),
      _PlanStep(l10n.onboardingGeneratingStepPhysical,                       _StepState.done),
      _PlanStep(l10n.onboardingGeneratingStepFitness,                        _StepState.done),
      _PlanStep(l10n.onboardingGeneratingStepMedical,                        _StepState.done),
      _PlanStep(l10n.onboardingGeneratingStepFunctionalTest,                 _StepState.done),
      _PlanStep(l10n.onboardingGeneratingStepStructuring,                     _StepState.active),
      _PlanStep(l10n.onboardingGeneratingStepWeeklySessions,                  _StepState.pending),
    ];
  }

  @override
  void initState() {
    super.initState();
    _rotCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animateSteps();
    });
  }

  Future<void> _animateSteps() async {
    // Llamar al endpoint mientras se anima
    final planFuture = _generatePlan();

    for (int i = 0; i < 8; i++) {
      await Future.delayed(Duration(milliseconds: i == 0 ? 600 : 1000));
      if (!mounted) return;
      setState(() => _visibleStep = i);
    }

    // Esperar que el plan termine si aún no acabó
    await planFuture;
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.onboardingFeedback);
  }

  Future<void> _generatePlan() async {
    try {
      final token = context.read<AuthProvider>().token;
      final res = await http.post(
        Uri.parse('https://apifitnflai.com/onboarding/generate-initial-plan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      debugPrint('GENERATE PLAN: ${res.statusCode} ${res.body}');
    } catch (e) {
      debugPrint('GENERATE PLAN ERROR: $e');
    }
  }

  @override
  void dispose() {
    _rotCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final steps = _getSteps(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.onboardingGeneratingPlanTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.orange,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 24),
                AnimatedBuilder(
                  animation: _rotCtrl,
                  builder: (context, child) => SizedBox(
                    width: 80,
                    height: 80,
                    child: CustomPaint(painter: _RingPainter(_rotCtrl.value)),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.onboardingGeneratingWorking,
                  style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.onboardingGeneratingAnalyzing,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: AppColors.grey, fontSize: 13, height: 1.4),
                ),
                const SizedBox(height: 24),
                ...List.generate(steps.length, (i) => _StepRow(
                  step: steps[i],
                  visible: i <= _visibleStep,
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Step model ────────────────────────────────────────────────
enum _StepState { done, active, pending }

class _PlanStep {
  final String label;
  final _StepState state;
  const _PlanStep(this.label, this.state);
}

// ─── Step row ──────────────────────────────────────────────────
class _StepRow extends StatelessWidget {
  final _PlanStep step;
  final bool visible;
  const _StepRow({required this.step, required this.visible});

  @override
  Widget build(BuildContext context) {
    Color dotColor;
    Color textColor;

    if (!visible) {
      dotColor  = AppColors.grey.withValues(alpha: 0.3);
      textColor = AppColors.grey.withValues(alpha: 0.3);
    } else {
      switch (step.state) {
        case _StepState.done:
          dotColor  = AppColors.greenText;
          textColor = AppColors.greenText;
          break;
        case _StepState.active:
          dotColor  = AppColors.orange;
          textColor = AppColors.orange;
          break;
        case _StepState.pending:
          dotColor  = AppColors.grey.withValues(alpha: 0.5);
          textColor = AppColors.grey.withValues(alpha: 0.5);
          break;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AnimatedOpacity(
        opacity: visible ? 1.0 : 0.3,
        duration: const Duration(milliseconds: 400),
        child: Row(children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 10, height: 10,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(step.label,
                style: TextStyle(
                  color: textColor,
                  fontSize: 12,
                  height: 1.4,
                  fontWeight: visible && step.state != _StepState.pending
                      ? FontWeight.w500
                      : FontWeight.w400,
                )),
          ),
        ]),
      ),
    );
  }
}

// ─── Ring painter ──────────────────────────────────────────────
class _RingPainter extends CustomPainter {
  final double progress;
  _RingPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 7;
    canvas.drawCircle(center, radius,
      Paint()
        ..color = AppColors.border
        ..style = PaintingStyle.stroke
        ..strokeWidth = 7);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2 + (progress * 2 * pi),
      pi * 1.1,
      false,
      Paint()
        ..color = AppColors.orange
        ..style = PaintingStyle.stroke
        ..strokeWidth = 7
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.progress != progress;
}