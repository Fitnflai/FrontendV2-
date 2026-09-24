import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/onboarding_router.dart';
import '../../providers/auth_provider.dart';
import '../../config/app_colors.dart';
import '../../config/app_routes.dart';
import '../../widgets/shared_widgets.dart';
import '../../l10n/app_localizations.dart';

class PARQResultClearScreen extends StatefulWidget {
  const PARQResultClearScreen({super.key});
  @override
  State<PARQResultClearScreen> createState() => _PARQResultClearScreenState();
}

class _PARQResultClearScreenState extends State<PARQResultClearScreen> {
  bool _accepted = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(child: Column(children: [
        Expanded(child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(children: [
            // Green transparent card
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0x551B3B2B),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFF2E6B4F), width: 1.5),
              ),
              child: Column(children: [
                Container(
                  height: 140, width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
                  child: const Center(child: CircleAvatar(radius: 32, backgroundColor: Color(0xFF3DB87A))),
                ),
                Padding(padding: const EdgeInsets.all(20), child: Column(children: [
                  Text(l10n.onboardingParqClearTitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.white, fontSize: 20, fontWeight: FontWeight.w800, height: 1.3)),
                  const SizedBox(height: 10),
                  Text(
                    l10n.onboardingParqClearDesc,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.greyLight, fontSize: 14, height: 1.55)),
                  const SizedBox(height: 20),
                  _greenBullet(l10n.onboardingParqClearBullet1),
                  const SizedBox(height: 10),
                  _greenBullet(l10n.onboardingParqClearBullet2),
                  const SizedBox(height: 10),
                  _greenBullet(l10n.onboardingParqClearBullet3),
                ])),
              ]),
            ),
            const SizedBox(height: 16),

            // Confirmation card
            Container(
              width: double.infinity, padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(l10n.onboardingParqClearConfirmTitle,
                    style: const TextStyle(color: AppColors.white, fontSize: 15, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text(
                  l10n.onboardingParqClearConfirmDesc,
                  style: const TextStyle(color: AppColors.grey, fontSize: 13, height: 1.5)),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => setState(() => _accepted = !_accepted),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    CheckIcon(checked: _accepted),
                    const SizedBox(width: 12),
                    Expanded(child: Text(
                      l10n.onboardingParqClearCheckboxLabel,
                      style: const TextStyle(color: AppColors.white, fontSize: 13, height: 1.5))),
                  ]),
                ),
              ]),
            ),
            const SizedBox(height: 20),
          ]),
        )),

        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          child: PrimaryButton(
            labelWidget: Text(l10n.onboardingContinue, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            enabled: _accepted,
            onTap: () async {
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              final userId = authProvider.user?.id;
              if (userId != null) {
                await OnboardingRouter.saveCompletedStep(userId, 1);
              }
              if (!context.mounted) return;
              Navigator.pushNamed(context, AppRoutes.step2Profile);
            },
          ),
        ),
      ])),
    );
  }

  Widget _greenBullet(String text) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(padding: EdgeInsets.only(top: 6),
          child: CircleAvatar(radius: 4, backgroundColor: AppColors.greenText)),
      const SizedBox(width: 12),
      Expanded(child: Text(text,
          style: const TextStyle(color: AppColors.greenText, fontSize: 14, height: 1.5))),
    ],
  );
}
