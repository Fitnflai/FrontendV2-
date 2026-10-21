import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/onboarding_router.dart';
import '../../providers/auth_provider.dart';
import '../../config/app_colors.dart';
import '../../config/app_routes.dart';
import '../../widgets/shared_widgets.dart';
import '../../l10n/app_localizations.dart';

class PARQResultWarningScreen extends StatefulWidget {
  final List<String> triggered;
  final bool isBlocked;

  const PARQResultWarningScreen({
    super.key,
    required this.triggered,
    this.isBlocked = false,
  });

  @override
  State<PARQResultWarningScreen> createState() => _PARQResultWarningScreenState();
}

class _PARQResultWarningScreenState extends State<PARQResultWarningScreen> {
  bool _accepted = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(child: Column(children: [
        Expanded(child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Red warning card
            Container(
              width: double.infinity, padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF2E1515),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF6B2020), width: 1.5),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  const CircleAvatar(radius: 6, backgroundColor: AppColors.redText),
                  const SizedBox(width: 10),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(l10n.onboardingParqWarningTitle,
                        style: const TextStyle(color: AppColors.redText, fontSize: 16, fontWeight: FontWeight.w800)),
                    Text(l10n.onboardingParqWarningSubtitle,
                        style: const TextStyle(color: Color(0xFF9E5050), fontSize: 12)),
                  ])),
                ]),
                const SizedBox(height: 14),
                Text(
                  l10n.onboardingParqWarningDesc,
                  style: const TextStyle(color: AppColors.greyLight, fontSize: 14, height: 1.55)),
                const SizedBox(height: 18),
                Text(l10n.onboardingParqWarningAlertTitle,
                    style: const TextStyle(color: AppColors.redText, fontSize: 14, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                ...widget.triggered.map((q) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Padding(padding: EdgeInsets.only(top: 5),
                        child: CircleAvatar(radius: 5, backgroundColor: AppColors.redMid)),
                    const SizedBox(width: 12),
                    Expanded(child: Text(q,
                        style: const TextStyle(color: AppColors.greyLight, fontSize: 13, height: 1.5))),
                  ]),
                )),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity, padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3A1A1A), borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF6B2020), width: 1)),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(l10n.onboardingParqWarningHelpTitle,
                        style: const TextStyle(color: AppColors.redText, fontSize: 14, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    Text(
                      l10n.onboardingParqWarningHelpDesc,
                      style: const TextStyle(color: Color(0xFF9E6060), fontSize: 13, height: 1.5)),
                  ]),
                ),
                const SizedBox(height: 18),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: double.infinity, height: 48,
                    decoration: BoxDecoration(
                        color: const Color(0xFF7B2020), borderRadius: BorderRadius.circular(10)),
                    child: Center(child: Text(l10n.onboardingParqWarningUnderstoodButton,
                        style: const TextStyle(color: AppColors.white, fontSize: 14, fontWeight: FontWeight.w600))),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 16),

            if (widget.isBlocked) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A1E08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.orange, width: 1),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: AppColors.orange, size: 20),
                        SizedBox(width: 10),
                        Text(
                          'Restricción del Protocolo',
                          style: TextStyle(color: AppColors.white, fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Por tu seguridad, ante respuestas afirmativas relacionadas con dolor en el pecho o pérdida de conocimiento, no se permite habilitar el plan de entrenamiento únicamente por autodeclaración.',
                      style: TextStyle(color: AppColors.greyLight, fontSize: 13, height: 1.5),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Si cometiste un error al responder, podés tocar el botón de arriba ("Entendido · Lo consultará con mi médico") para volver a la pantalla anterior y corregir tu respuesta.',
                      style: TextStyle(color: AppColors.greyLight, fontSize: 13, height: 1.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ] else ...[
              // Override card
              Container(
                width: double.infinity, padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(l10n.onboardingParqWarningOverrideTitle,
                      style: const TextStyle(color: AppColors.white, fontSize: 15, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Text(
                    l10n.onboardingParqWarningOverrideDesc,
                    style: const TextStyle(color: AppColors.grey, fontSize: 13, height: 1.5)),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => setState(() => _accepted = !_accepted),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      CheckIcon(checked: _accepted),
                      const SizedBox(width: 12),
                      Expanded(child: Text(
                        l10n.onboardingParqWarningOverrideCheckboxLabel,
                        style: const TextStyle(color: AppColors.white, fontSize: 13, height: 1.5))),
                    ]),
                  ),
                ]),
              ),
              const SizedBox(height: 20),
            ],
          ]),
        )),

        if (!widget.isBlocked)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: PrimaryButton(
              labelWidget: Text(l10n.onboardingContinue, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              enabled: _accepted,
              onTap: () async {
                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                final userId = authProvider.user?.id;
                final token = authProvider.token;
                if (userId != null) {
                  await OnboardingRouter.saveCompletedStep(userId, 1, token: token);
                }
                if (!context.mounted) return;
                Navigator.pushNamed(context, AppRoutes.step2Profile);
              },
            ),
          ),
      ])),
    );
  }
}
