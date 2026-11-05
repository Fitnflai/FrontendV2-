import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/app_colors.dart';
import '../../config/app_theme_extension.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/shared_widgets.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPassCtrl = TextEditingController();
  final _newPassCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  bool _loading = false;

  @override
  void dispose() {
    _currentPassCtrl.dispose();
    _newPassCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    setState(() => _loading = true);

    try {
      final auth = context.read<AuthProvider>();
      await auth.changePassword(
        _currentPassCtrl.text.trim(),
        _newPassCtrl.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Contraseña actualizada exitosamente.'),
          backgroundColor: AppColors.greenMid,
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      final errorMsg = e.toString().replaceAll('Exception: ', '');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMsg),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;

    return Scaffold(
      backgroundColor: theme.bg,
      appBar: const FitnflaiAppBar(title: 'Cambiar contraseña'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Actualiza tu contraseña',
                style: TextStyle(
                  color: theme.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Ingresa tu contraseña actual y define una nueva para proteger tu cuenta.',
                style: TextStyle(
                  color: theme.textMuted,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 28),

              // Contraseña actual
              const FieldLabel(text: 'Contraseña actual'),
              const SizedBox(height: 8),
              AppTextField(
                hint: 'Ingresa tu contraseña actual',
                controller: _currentPassCtrl,
                obscure: true,
                prefixIcon: Icon(Icons.lock_outline, color: theme.textMuted, size: 20),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Ingresa tu contraseña actual';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Nueva contraseña
              const FieldLabel(text: 'Nueva contraseña'),
              const SizedBox(height: 8),
              AppTextField(
                hint: 'Mínimo 6 caracteres',
                controller: _newPassCtrl,
                obscure: true,
                prefixIcon: Icon(Icons.lock_reset_outlined, color: theme.textMuted, size: 20),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Ingresa la nueva contraseña';
                  }
                  if (val.trim().length < 6) {
                    return 'La contraseña debe tener al menos 6 caracteres';
                  }
                  if (val.trim() == _currentPassCtrl.text.trim()) {
                    return 'La nueva contraseña debe ser diferente a la actual';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Confirmar nueva contraseña
              const FieldLabel(text: 'Confirmar nueva contraseña'),
              const SizedBox(height: 8),
              AppTextField(
                hint: 'Repite la nueva contraseña',
                controller: _confirmPassCtrl,
                obscure: true,
                prefixIcon: Icon(Icons.check_circle_outline, color: theme.textMuted, size: 20),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Confirma tu nueva contraseña';
                  }
                  if (val.trim() != _newPassCtrl.text.trim()) {
                    return 'Las contraseñas no coinciden';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 36),

              PrimaryButton(
                enabled: !_loading,
                labelWidget: _loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Guardar nueva contraseña',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                onTap: _loading ? null : _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
