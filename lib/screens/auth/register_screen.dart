import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../config/app_routes.dart';
import '../../config/onboarding_router.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/shared_widgets.dart';
import '../../l10n/app_localizations.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey  = GlobalKey<FormState>();
  final _name     = TextEditingController();
  final _username = TextEditingController();
  final _email    = TextEditingController();
  final _pass     = TextEditingController();
  final _confirm  = TextEditingController();
  bool _terms = false;

  @override
  void dispose() {
    _name.dispose(); _username.dispose();
    _email.dispose(); _pass.dispose(); _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context);
    if (!_terms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.registerTermsSnackBarError),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final auth = context.read<AuthProvider>();
    final ok = await auth.register(
      _email.text.trim(),
      _pass.text,
      _name.text.trim(),
      username: _username.text.trim().isNotEmpty
          ? _username.text.trim()
          : null,
    );

    if (!mounted) return;
    if (ok) {
      if (!mounted) return;
      final targetRoute = await OnboardingRouter.getOnboardingTargetRoute(context);
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
          context, targetRoute, (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: FitnflaiAppBar(
        title: l10n.registerTitle,
        onBack: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
            const Center(child: FitnflaiLogo(fontSize: 32)),
            const SizedBox(height: 6),
            Center(child: Text(l10n.registerSubtitle,
                style: const TextStyle(color: AppColors.grey, fontSize: 14))),
            const SizedBox(height: 32),
 
            // ── Error banner ──────────────────
            if (auth.errorMessage != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E1515),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.redMid),
                ),
                child: Row(children: [
                  const Icon(Icons.error_outline,
                      color: AppColors.redText, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(auth.errorMessage!,
                        style: const TextStyle(
                            color: AppColors.redText,
                            fontSize: 13, height: 1.4)),
                  ),
                  GestureDetector(
                    onTap: auth.clearError,
                    child: const Icon(Icons.close,
                        color: AppColors.redText, size: 16),
                  ),
                ]),
              ),
              const SizedBox(height: 16),
            ],
 
            Align(alignment: Alignment.centerLeft, child: FieldLabel(text: l10n.registerNameLabel)),
            const SizedBox(height: 8),
            AppTextField(
              hint: l10n.registerNameHint, controller: _name,
              prefixIcon: const Icon(Icons.person_outline, color: AppColors.grey, size: 20),
              validator: (v) => (v == null || v.isEmpty) ? l10n.registerNameRequired : null,
            ),
            const SizedBox(height: 16),
 
            Align(alignment: Alignment.centerLeft, child: FieldLabel(text: l10n.registerUsernameLabel)),
            const SizedBox(height: 8),
            AppTextField(
              hint: l10n.registerUsernameHint, controller: _username,
              prefixIcon: const Icon(Icons.alternate_email, color: AppColors.grey, size: 20),
              validator: (v) {
                if (v == null || v.isEmpty) return l10n.registerUsernameRequired;
                if (v.contains(' ')) return l10n.registerUsernameNoSpaces;
                if (v.length < 3) return l10n.registerUsernameTooShort;
                return null;
              },
            ),
            const SizedBox(height: 16),
 
            Align(alignment: Alignment.centerLeft, child: FieldLabel(text: l10n.authEmail)),
            const SizedBox(height: 8),
            AppTextField(
              hint: l10n.authEmailHint, controller: _email,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(Icons.email_outlined, color: AppColors.grey, size: 20),
              validator: (v) {
                if (v == null || v.isEmpty) return l10n.loginEmailRequired;
                final regex = RegExp(r'^[\w\.\-\+]+@[\w\-]+\.[\w\-\.]*[a-zA-Z]{2,}$');
                if (!regex.hasMatch(v)) return l10n.registerEmailInvalid;
                return null;
              },
            ),
            const SizedBox(height: 16),
 
            Align(alignment: Alignment.centerLeft, child: FieldLabel(text: l10n.authPassword)),
            const SizedBox(height: 8),
            AppTextField(
              hint: l10n.authPasswordHint, controller: _pass, obscure: true,
              prefixIcon: const Icon(Icons.lock_outline, color: AppColors.grey, size: 20),
              validator: (v) {
                if (v == null || v.isEmpty) return l10n.registerPasswordRequired;
                if (v.length < 8) return l10n.registerPasswordTooShort;
                return null;
              },
            ),
            const SizedBox(height: 16),
 
            Align(alignment: Alignment.centerLeft, child: FieldLabel(text: l10n.resetPasswordConfirmLabel)),
            const SizedBox(height: 8),
            AppTextField(
              hint: l10n.resetPasswordConfirmHint, controller: _confirm, obscure: true,
              prefixIcon: const Icon(Icons.lock_outline, color: AppColors.grey, size: 20),
              validator: (v) {
                if (v == null || v.isEmpty) return l10n.registerConfirmPasswordRequired;
                if (v != _pass.text) return l10n.registerPasswordsDoNotMatch;
                return null;
              },
            ),
            const SizedBox(height: 24),

            GestureDetector(
              onTap: () => setState(() => _terms = !_terms),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                CheckIcon(checked: _terms),
                const SizedBox(width: 12),
                Expanded(
                  child: Text.rich(TextSpan(
                    style: const TextStyle(color: AppColors.grey, fontSize: 13, height: 1.5),
                    children: [
                      TextSpan(text: l10n.registerTermsAccept),
                      TextSpan(text: l10n.registerTermsLink,
                          style: const TextStyle(color: AppColors.orange, fontWeight: FontWeight.w600)),
                      TextSpan(text: l10n.registerAnd),
                      TextSpan(text: l10n.registerPrivacyLink,
                          style: const TextStyle(color: AppColors.orange, fontWeight: FontWeight.w600)),
                    ],
                  )),
                ),
              ]),
            ),
            const SizedBox(height: 28),

            auth.isLoading
                ? const Center(child: CircularProgressIndicator(
                    color: AppColors.orange))
                : PrimaryButton(
                    labelWidget: Text(l10n.registerTitle, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    enabled: _terms,
                    onTap: _submit),
            const SizedBox(height: 20),
            const AuthDivider(),
            const SizedBox(height: 16),

            SocialButton(
              label: l10n.authGoogleButton,
              icon: googleIcon(),
              onTap: () async {
                final navigator = Navigator.of(context);
                final ok = await auth.loginWithGoogle();
                if (!mounted) return;
                if (ok) {
                  final targetRoute = (auth.user?.onboardingCompleto ?? false)
                      ? AppRoutes.home
                      : AppRoutes.parq;
                  navigator.pushNamedAndRemoveUntil(
                      targetRoute, (_) => false);
                }
              },
            ),
            const SizedBox(height: 10),

            SocialButton(
              label: l10n.authAppleButton,
              icon: appleIcon(),
              onTap: () async {
                final navigator = Navigator.of(context);
                final ok = await auth.loginWithApple();
                if (!mounted) return;
                if (ok) {
                  final targetRoute = (auth.user?.onboardingCompleto ?? false)
                      ? AppRoutes.home
                      : AppRoutes.parq;
                  navigator.pushNamedAndRemoveUntil(
                      targetRoute, (_) => false);
                }
              },
            ),
            const SizedBox(height: 20),

            Center(
              child: GestureDetector(
                onTap: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
                child: Text.rich(TextSpan(children: [
                  TextSpan(text: l10n.registerAlreadyHaveAccount,
                      style: const TextStyle(color: AppColors.grey, fontSize: 14)),
                  TextSpan(text: l10n.registerLoginLink,
                      style: const TextStyle(color: AppColors.orange, fontSize: 14, fontWeight: FontWeight.w600)),
                ])),
              ),
            ),
            const SizedBox(height: 24),
          ]),
        ),
      ),
    );
    }, // Consumer builder
    );
  }
}