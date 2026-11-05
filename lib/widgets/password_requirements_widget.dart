import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../utils/password_validator.dart';

class PasswordRequirementsWidget extends StatelessWidget {
  final TextEditingController controller;

  const PasswordRequirementsWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        final text = value.text;
        final hasLength = PasswordValidator.hasMinLength(text, 8);
        final hasUpper = PasswordValidator.hasUppercase(text);
        final hasNum = PasswordValidator.hasNumber(text);
        final hasSpecial = PasswordValidator.hasSpecialChar(text);

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.cardDark,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'La contraseña debe contener:',
                style: TextStyle(
                  color: AppColors.greyLight,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              _RequirementRow(label: 'Mínimo 8 caracteres', isMet: hasLength),
              const SizedBox(height: 4),
              _RequirementRow(label: 'Al menos una letra mayúscula (A-Z)', isMet: hasUpper),
              const SizedBox(height: 4),
              _RequirementRow(label: 'Al menos un número (0-9)', isMet: hasNum),
              const SizedBox(height: 4),
              _RequirementRow(label: 'Al menos un carácter especial (!@#\$%...)', isMet: hasSpecial),
            ],
          ),
        );
      },
    );
  }
}

class _RequirementRow extends StatelessWidget {
  final String label;
  final bool isMet;

  const _RequirementRow({
    required this.label,
    required this.isMet,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          isMet ? Icons.check_circle : Icons.circle_outlined,
          size: 14,
          color: isMet ? AppColors.greenText : AppColors.grey,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isMet ? AppColors.white : AppColors.grey,
              fontWeight: isMet ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
