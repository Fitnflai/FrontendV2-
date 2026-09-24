import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../config/app_colors.dart';
import '../../config/app_routes.dart';
import '../../widgets/shared_widgets.dart';
import '../../l10n/app_localizations.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});
  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey   = GlobalKey<FormState>();
  final _tokenCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  final _confCtrl  = TextEditingController();
  bool _loading    = false;
  bool _done       = false;
  bool _showPass   = false;
  bool _showConf   = false;
  String? _error;

  @override
  void dispose() {
    _tokenCtrl.dispose();
    _passCtrl.dispose();
    _confCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _loading = true; _error = null; });
    try {
      final res = await http.post(
        Uri.parse('https://apifitnflai.com/auth/reset-password-confirm'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'token':        _tokenCtrl.text.trim(),
          'new_password': _passCtrl.text,
        }),
      );
      if (!mounted) return;
      if (res.statusCode == 200) {
        setState(() => _done = true);
      } else {
        final body = jsonDecode(res.body);
        final l10n = AppLocalizations.of(context);
        setState(() => _error = body['detail']?.toString()
            ?? l10n.resetPasswordErrorDefault);
      }
    } catch (_) {
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        setState(() => _error = l10n.resetPasswordConnectionError);
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
      appBar: FitnflaiAppBar(title: l10n.resetPasswordTitle),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: _done ? _DoneView(
          onLogin: () => Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.login, (_) => false),
        ) : Form(
          key: _formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const FitnflaiLogo(fontSize: 26),
            const SizedBox(height: 6),
            Text(l10n.resetPasswordInstruction,
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

            // Token
            FieldLabel(text: l10n.resetPasswordTokenLabel),
            const SizedBox(height: 8),
            AppTextField(
              hint: l10n.resetPasswordTokenHint,
              controller: _tokenCtrl,
              prefixIcon: const Icon(Icons.key_outlined, color: AppColors.grey, size: 20),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? l10n.resetPasswordTokenRequired : null,
            ),
            const SizedBox(height: 20),

            // Nueva contraseña
            FieldLabel(text: l10n.resetPasswordNewLabel),
            const SizedBox(height: 8),
            TextFormField(
              controller: _passCtrl,
              obscureText: !_showPass,
              style: const TextStyle(color: AppColors.white, fontSize: 15),
              decoration: InputDecoration(
                hintText: l10n.resetPasswordNewHint,
                hintStyle: const TextStyle(color: AppColors.grey),
                prefixIcon: const Icon(Icons.lock_outline, color: AppColors.grey, size: 20),
                suffixIcon: GestureDetector(
                  onTap: () => setState(() => _showPass = !_showPass),
                  child: Icon(_showPass ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined, color: AppColors.grey, size: 20),
                ),
                filled: true,
                fillColor: AppColors.card,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.border)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.border)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.orange, width: 1.5)),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return l10n.resetPasswordNewRequired;
                if (v.length < 8) return l10n.resetPasswordNewTooShort;
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Confirmar
            FieldLabel(text: l10n.resetPasswordConfirmLabel),
            const SizedBox(height: 8),
            TextFormField(
              controller: _confCtrl,
              obscureText: !_showConf,
              style: const TextStyle(color: AppColors.white, fontSize: 15),
              decoration: InputDecoration(
                hintText: l10n.resetPasswordConfirmHint,
                hintStyle: const TextStyle(color: AppColors.grey),
                prefixIcon: const Icon(Icons.lock_outline, color: AppColors.grey, size: 20),
                suffixIcon: GestureDetector(
                  onTap: () => setState(() => _showConf = !_showConf),
                  child: Icon(_showConf ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined, color: AppColors.grey, size: 20),
                ),
                filled: true,
                fillColor: AppColors.card,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.border)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.border)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.orange, width: 1.5)),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return l10n.resetPasswordConfirmRequired;
                if (v != _passCtrl.text) return l10n.resetPasswordConfirmMismatch;
                return null;
              },
            ),
            const SizedBox(height: 28),

            _loading
                ? const Center(child: CircularProgressIndicator(color: AppColors.orange))
                : PrimaryButton(labelWidget: Text(l10n.resetPasswordChangeButton, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)), onTap: _submit),
            const SizedBox(height: 16),

            Center(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Text(l10n.resetPasswordBackLink,
                    style: const TextStyle(color: AppColors.orange, fontSize: 13,
                        fontWeight: FontWeight.w500)),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class _DoneView extends StatelessWidget {
  final VoidCallback onLogin;
  const _DoneView({required this.onLogin});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(children: [
      const SizedBox(height: 20),
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(color: AppColors.greenBg, shape: BoxShape.circle),
        child: const Icon(Icons.check_circle_outline, color: AppColors.greenText, size: 40),
      ),
      const SizedBox(height: 24),
      Text(l10n.resetPasswordSuccessTitle,
          style: const TextStyle(color: AppColors.white, fontSize: 22,
              fontWeight: FontWeight.w800)),
      const SizedBox(height: 10),
      Text(l10n.resetPasswordSuccessDesc,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.grey, fontSize: 14, height: 1.5)),
      const SizedBox(height: 32),
      PrimaryButton(labelWidget: Text(l10n.resetPasswordGoToLoginButton, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)), onTap: onLogin),
    ]);
  }
}