class PasswordValidator {
  static bool hasMinLength(String password, [int min = 8]) => password.length >= min;
  static bool hasUppercase(String password) => RegExp(r'[A-Z]').hasMatch(password);
  static bool hasNumber(String password) => RegExp(r'[0-9]').hasMatch(password);
  static bool hasSpecialChar(String password) => RegExp(r'[^A-Za-z0-9]').hasMatch(password);

  static bool isSecure(String password) {
    return hasMinLength(password, 8) &&
        hasUppercase(password) &&
        hasNumber(password) &&
        hasSpecialChar(password);
  }

  static String? validate(String? value, {String? requiredMsg}) {
    if (value == null || value.trim().isEmpty) {
      return requiredMsg ?? 'Ingresa una contraseña';
    }
    final pwd = value.trim();
    if (!hasMinLength(pwd, 8)) {
      return 'Debe tener al menos 8 caracteres';
    }
    if (!hasUppercase(pwd)) {
      return 'Debe incluir al menos una letra mayúscula';
    }
    if (!hasNumber(pwd)) {
      return 'Debe incluir al menos un número';
    }
    if (!hasSpecialChar(pwd)) {
      return 'Debe incluir al menos un carácter especial (ej. !@#\$%*)';
    }
    return null;
  }
}
