import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/shared_widgets.dart';
import '../../l10n/app_localizations.dart';
import 'step1_parq_result_clear_screen.dart';
import 'step1_parq_result_warning_screen.dart';

class PARQQuestion {
  final String text;
  final String shortLabel;
  bool? answer;
  PARQQuestion({required this.text, required this.shortLabel});
}

class PARQScreen extends StatefulWidget {
  const PARQScreen({super.key});
  @override
  State<PARQScreen> createState() => _PARQScreenState();
}

class _PARQScreenState extends State<PARQScreen> {
  List<PARQQuestion>? _qs;

  List<PARQQuestion> get qs {
    if (_qs == null) {
      final l10n = AppLocalizations.of(context);
      _qs = [
        PARQQuestion(text: l10n.parqQuestion1, shortLabel: l10n.parqShortLabel1),
        PARQQuestion(text: l10n.parqQuestion2, shortLabel: l10n.parqShortLabel2),
        PARQQuestion(text: l10n.parqQuestion3, shortLabel: l10n.parqShortLabel3),
        PARQQuestion(text: l10n.parqQuestion4, shortLabel: l10n.parqShortLabel4),
        PARQQuestion(text: l10n.parqQuestion5, shortLabel: l10n.parqShortLabel5),
        PARQQuestion(text: l10n.parqQuestion6, shortLabel: l10n.parqShortLabel6),
        PARQQuestion(text: l10n.parqQuestion7, shortLabel: l10n.parqShortLabel7),
      ];
    } else {
      final l10n = AppLocalizations.of(context);
      _qs![0] = PARQQuestion(text: l10n.parqQuestion1, shortLabel: l10n.parqShortLabel1)..answer = _qs![0].answer;
      _qs![1] = PARQQuestion(text: l10n.parqQuestion2, shortLabel: l10n.parqShortLabel2)..answer = _qs![1].answer;
      _qs![2] = PARQQuestion(text: l10n.parqQuestion3, shortLabel: l10n.parqShortLabel3)..answer = _qs![2].answer;
      _qs![3] = PARQQuestion(text: l10n.parqQuestion4, shortLabel: l10n.parqShortLabel4)..answer = _qs![3].answer;
      _qs![4] = PARQQuestion(text: l10n.parqQuestion5, shortLabel: l10n.parqShortLabel5)..answer = _qs![4].answer;
      _qs![5] = PARQQuestion(text: l10n.parqQuestion6, shortLabel: l10n.parqShortLabel6)..answer = _qs![5].answer;
      _qs![6] = PARQQuestion(text: l10n.parqQuestion7, shortLabel: l10n.parqShortLabel7)..answer = _qs![6].answer;
    }
    return _qs!;
  }

  bool get _allAnswered => qs.every((q) => q.answer != null);

  bool _loading = false;

  Future<void> _onContinue() async {
    if (!_allAnswered) return;
    setState(() => _loading = true);

    try {
      final token = context.read<AuthProvider>().token;
      await http.post(
        Uri.parse('https://apifitnflai.com/onboarding/validar-y-guardar-parq'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'p1': qs[0].answer ?? false,
          'p2': qs[1].answer ?? false,
          'p3': qs[2].answer ?? false,
          'p4': qs[3].answer ?? false,
          'p5': qs[4].answer ?? false,
          'p6': qs[5].answer ?? false,
          'p7': qs[6].answer ?? false,
          'p7_detalles': '',
          'acepto_declaracion_jurada': true,
        }),
      );
    } catch (_) {
      // Continúa aunque falle — no bloquear el onboarding
    } finally {
      setState(() => _loading = false);
    }

    if (!mounted) return;
    final hasCritical = qs.any((q) => q.answer == true);
    final triggered   = qs.where((q) => q.answer == true)
                          .map((q) => q.shortLabel).toList();
    Navigator.push(context, MaterialPageRoute(builder: (_) =>
      hasCritical
        ? PARQResultWarningScreen(triggered: triggered)
        : const PARQResultClearScreen()));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.bg,
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(children: [
          _buildHeader(),
          const SizedBox(height: 20),
          ...List.generate(qs.length, (i) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _buildQuestionCard(i))),
          const SizedBox(height: 8),
          _loading
              ? const Center(child: CircularProgressIndicator(color: AppColors.orange))
              : ContinueButton(enabled: _allAnswered, onTap: _onContinue),
          const SizedBox(height: 20),
        ]),
      ),
    ),
  );

  Widget _buildHeader() {
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(width: 32, height: 32,
            decoration: const BoxDecoration(color: Color(0xFF7B2D2D), shape: BoxShape.circle),
            child: const Icon(Icons.favorite, color: AppColors.redText, size: 18)),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(l10n.onboardingParqTitle,
                style: const TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w700)),
            Text(l10n.onboardingParqSubtitle,
                style: const TextStyle(color: AppColors.grey, fontSize: 12)),
          ]),
        ]),
        const SizedBox(height: 14),
        Text(
          l10n.onboardingParqDesc,
          style: const TextStyle(color: AppColors.greyLight, fontSize: 13, height: 1.5)),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
              border: Border.all(color: AppColors.orange),
              borderRadius: BorderRadius.circular(20)),
          child: Text(l10n.onboardingParqValidated,
              style: const TextStyle(color: AppColors.orange, fontSize: 11, fontWeight: FontWeight.w500)),
        ),
      ]),
    );
  }

  Widget _buildQuestionCard(int i) {
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(l10n.onboardingParqQuestionLabel(i + 1, qs.length),
            style: const TextStyle(color: AppColors.orange, fontSize: 13, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Text(qs[i].text, style: const TextStyle(color: AppColors.white, fontSize: 14, height: 1.5)),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: _answerButton(i, false)),
          const SizedBox(width: 10),
          Expanded(child: _answerButton(i, true)),
        ]),
      ]),
    );
  }

  Widget _answerButton(int i, bool value) {
    final selected = qs[i].answer == value;
    final l10n = AppLocalizations.of(context);
    return GestureDetector(
      onTap: () => setState(() => qs[i].answer = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 44,
        decoration: BoxDecoration(
          color: selected ? (value ? AppColors.redMid : AppColors.greenMid) : Colors.transparent,
          border: Border.all(
              color: selected ? (value ? AppColors.redMid : AppColors.greenMid) : AppColors.border,
              width: 1.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(child: Text(value ? l10n.yes : l10n.no,
            style: const TextStyle(color: AppColors.white, fontSize: 15, fontWeight: FontWeight.w600))),
      ),
    );
  }
}