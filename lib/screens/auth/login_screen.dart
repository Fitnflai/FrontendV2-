import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../config/app_routes.dart';
import '../../config/onboarding_router.dart'; // Added
import '../../providers/auth_provider.dart';
import '../../widgets/shared_widgets.dart';
import '../../l10n/app_localizations.dart';
import 'forgot_password_screen.dart';
 
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
 
class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email   = TextEditingController();
  final _pass    = TextEditingController();
 
  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }
 
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
 
    final auth = context.read<AuthProvider>();
    final ok   = await auth.login(_email.text.trim(), _pass.text);
 
    if (!mounted) return;
 
    if (ok) {
      final targetRoute = await OnboardingRouter.getOnboardingTargetRoute(context);
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
          context, targetRoute, (_) => false);
    }
  }
 
  void _forgotPassword() => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
  );
 
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        return Scaffold(
          backgroundColor: AppColors.bg,
          appBar: FitnflaiAppBar(
            title: l10n.loginTitle,
            onBack: () => Navigator.pushReplacementNamed(context, AppRoutes.welcome),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Form(
              key: _formKey,
              child: Column(
                  children: [
                const Center(child: FitnflaiLogo(fontSize: 32)),
                const SizedBox(height: 6),
                Center(child: Text(l10n.loginWelcomeBack,
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
                                fontSize: 13,
                                height: 1.4)),
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
 
                // ── Email ─────────────────────────
                Align(alignment: Alignment.centerLeft, child: FieldLabel(text: l10n.authEmail)),
                const SizedBox(height: 8),
                AppTextField(
                  hint: l10n.authEmailHint,
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email_outlined,
                      color: AppColors.grey, size: 20),
                  validator: (v) {
                    if (v == null || v.isEmpty) return l10n.loginEmailRequired;
                    final regex = RegExp(r'^[\w\.\-\+]+@[\w\-]+\.[\w\-\.]*[a-zA-Z]{2,}$');
                    if (!regex.hasMatch(v)) return l10n.loginEmailInvalid;
                    return null;
                  },
                ),
                const SizedBox(height: 16),
 
                // ── Password ──────────────────────
                Align(alignment: Alignment.centerLeft, child: FieldLabel(text: l10n.authPassword)),
                const SizedBox(height: 8),
                AppTextField(
                  hint: l10n.authPasswordHint,
                  controller: _pass,
                  obscure: true,
                  prefixIcon: const Icon(Icons.lock_outline,
                      color: AppColors.grey, size: 20),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? l10n.loginPasswordRequired : null,
                ),
                const SizedBox(height: 12),
 
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: _forgotPassword,
                    child: Text(l10n.loginForgotPassword,
                        style: const TextStyle(
                            color: AppColors.orange,
                            fontSize: 13,
                            fontWeight: FontWeight.w500)),
                  ),
                ),
                const SizedBox(height: 28),
 
                // ── Login button ──────────────────
                auth.isLoading
                    ? const Center(child: CircularProgressIndicator(
                        color: AppColors.orange))
                    : PrimaryButton(
                        labelWidget: Text(l10n.loginButton, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                        onTap: _submit,
                      ),
                const SizedBox(height: 20),
                const AuthDivider(),
                const SizedBox(height: 16),
 
                SocialButton(
                  label: l10n.authGoogleButton,
                  icon: googleIcon(),
                  onTap: () async {
                    debugPrint('GOOGLE BTN TAPPED');
                    final navigator = Navigator.of(context);
                    final ok = await auth.loginWithGoogle();
                    if (!mounted) return;
                    if (ok) {
                      if (!context.mounted) return;
                      final targetRoute = await OnboardingRouter.getOnboardingTargetRoute(context);
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
                      if (!context.mounted) return;
                      final targetRoute = await OnboardingRouter.getOnboardingTargetRoute(context);
                      navigator.pushNamedAndRemoveUntil(
                          targetRoute, (_) => false);
                    }
                  },
                ),
                const SizedBox(height: 24),
 
                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.pushReplacementNamed(
                        context, AppRoutes.register),
                    child: Text.rich(TextSpan(children: [
                      TextSpan(text: l10n.loginNoAccount,
                          style: const TextStyle(
                              color: AppColors.grey, fontSize: 14)),
                      TextSpan(text: l10n.loginSignUpLink,
                          style: const TextStyle(
                              color: AppColors.orange,
                              fontSize: 14,
                              fontWeight: FontWeight.w600)),
                    ])),
                  ),
                ),
                const SizedBox(height: 24),
              ]),
            ),
          ),
        );
      },
    );
  }
}