import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../config/app_colors.dart';
import '../../widgets/shared_widgets.dart';
import '../../l10n/app_localizations.dart';
import 'reset_password_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  bool _loading = false;
  bool _sent    = false;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _loading = true; _error = null; });
    try {
      final res = await http.post(
        Uri.parse('https://apifitnflai.com/auth/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': _emailCtrl.text.trim()}),
      );
      if (!mounted) return;
      if (res.statusCode == 200) {
        setState(() => _sent = true);
      } else {
        final l10n = AppLocalizations.of(context);
        setState(() => _error = l10n.forgotPasswordErrorSending);
      }
    } catch (_) {
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        setState(() => _error = l10n.forgotPasswordConnectionError);
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: FitnflaiAppBar(title: l10n.forgotPasswordTitle),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: _sent ? _SuccessView(
          email: _emailCtrl.text.trim(),
          onEnterCode: () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => const ResetPasswordScreen())),
        ) : Form(
          key: _formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const FitnflaiLogo(fontSize: 26),
            const SizedBox(height: 6),
            Text(l10n.forgotPasswordInstruction,
                style: const TextStyle(color: AppColors.grey, fontSize: 14, height: 1.5)),
            const SizedBox(height: 32),

            // Error
            if (_error != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E1515),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.redMid),
                ),
                child: Row(children: [
                  const Icon(Icons.error_outline, color: AppColors.redText, size: 18),
                  const SizedBox(width: 10),
                  Expanded(child: Text(_error!,
                      style: const TextStyle(color: AppColors.redText, fontSize: 13))),
                  GestureDetector(
                    onTap: () => setState(() => _error = null),
                    child: const Icon(Icons.close, color: AppColors.redText, size: 16),
                  ),
                ]),
              ),
              const SizedBox(height: 16),
            ],

            FieldLabel(text: l10n.authEmail),
            const SizedBox(height: 8),
            AppTextField(
              hint: l10n.authEmailHint,
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(Icons.email_outlined, color: AppColors.grey, size: 20),
              validator: (v) {
                if (v == null || v.isEmpty) return l10n.loginEmailRequired;
                final regex = RegExp(r'^[\w\.\-\+]+@[\w\-]+\.[\w\-\.]*[a-zA-Z]{2,}$');
                if (!regex.hasMatch(v)) return l10n.registerEmailInvalid;
                return null;
              },
            ),
            const SizedBox(height: 28),

            _loading
                ? const Center(child: CircularProgressIndicator(color: AppColors.orange))
                : PrimaryButton(labelWidget: Text(l10n.forgotPasswordSendButton, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)), onTap: _submit),
            const SizedBox(height: 16),

            Center(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Text(l10n.forgotPasswordBackToLogin,
                    style: const TextStyle(color: AppColors.orange, fontSize: 13,
                        fontWeight: FontWeight.w500)),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: GestureDetector(
                onTap: () => Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const ResetPasswordScreen())),
                child: Text(l10n.forgotPasswordHasCode,
                    style: const TextStyle(color: AppColors.grey, fontSize: 13)),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class _SuccessView extends StatelessWidget {
  final String email;
  final VoidCallback onEnterCode;
  const _SuccessView({required this.email, required this.onEnterCode});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(children: [
      const SizedBox(height: 20),
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: AppColors.greenBg,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.mark_email_read_outlined,
            color: AppColors.greenText, size: 40),
      ),
      const SizedBox(height: 24),
      Text(l10n.forgotPasswordSuccessTitle,
          style: const TextStyle(color: AppColors.white, fontSize: 22,
              fontWeight: FontWeight.w800)),
      const SizedBox(height: 10),
      Text(l10n.forgotPasswordSuccessDesc(email),
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.grey, fontSize: 14, height: 1.5)),
      const SizedBox(height: 32),
      PrimaryButton(labelWidget: Text(l10n.forgotPasswordEnterCodeButton, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)), onTap: onEnterCode),
      const SizedBox(height: 12),
      GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Text(l10n.forgotPasswordBackToLogin,
            style: const TextStyle(color: AppColors.orange, fontSize: 13,
                fontWeight: FontWeight.w500)),
      ),
    ]);
  }
}
