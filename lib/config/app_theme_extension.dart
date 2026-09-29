import 'package:flutter/material.dart';

// Extension única para todo el proyecto
extension GlobalThemeContextExt on BuildContext {
  AppThemeExtensionWrapper get themeColors {
    final theme = Theme.of(this).extension<AppThemeExtension>();
    if (theme == null) return AppThemeExtensionWrapper(AppThemeExtension.dark);
    return AppThemeExtensionWrapper(theme);
  }
}

class AppThemeExtensionWrapper {
  final AppThemeExtension theme;
  AppThemeExtensionWrapper(this.theme);

  Color get bg => theme.bg;
  Color get card => theme.card;
  Color get cardDark => theme.cardDark;
  Color get primary => theme.primary;
  Color get successBg => theme.greenBg;
  Color get successBorder => theme.greenMid;
  Color get successText => theme.greenText;
  Color get errorText => theme.redText;
  Color get redMid => theme.redMid;
  Color get greenText => theme.greenText;
  Color get greenBg => theme.greenBg;
  Color get redText => theme.redText;
  Color get text => theme.white;
  Color get textMuted => theme.grey;
  Color get textSecondary => theme.greyLight;
  Color get disabledBg => theme.border;
  Color get border => theme.border;
  Color get orange => theme.primary;
  Color get white => theme.white;
  Color get grey => theme.grey;
  Color get greyLight => theme.greyLight;
}

@immutable
class SeccionColors {
  final Color bg;
  final Color border;
  final Color primary;
  const SeccionColors({required this.bg, required this.border, required this.primary});
}

@immutable
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  final Color bg;
  final Color card;
  final Color cardDark;
  final Color primary;
  final Color border;
  final Color white;
  final Color grey;
  final Color greyLight;
  final Color greenMid;
  final Color greenText;
  final Color greenBg;
  final Color redMid;
  final Color redText;
  
  final SeccionColors objetivo;
  final SeccionColors calentamiento;
  final SeccionColors principal;
  final SeccionColors vuelta;
  final SeccionColors nutricion;
  final SeccionColors notas;

  const AppThemeExtension({
    required this.bg,
    required this.card,
    required this.cardDark,
    required this.primary,
    required this.border,
    required this.white,
    required this.grey,
    required this.greyLight,
    required this.greenMid,
    required this.greenText,
    required this.greenBg,
    required this.redMid,
    required this.redText,
    required this.objetivo,
    required this.calentamiento,
    required this.principal,
    required this.vuelta,
    required this.nutricion,
    required this.notas,
  });

  @override
  AppThemeExtension copyWith({
    Color? bg, Color? card, Color? cardDark, Color? primary, Color? border,
    Color? white, Color? grey, Color? greyLight, Color? greenMid,
    Color? greenText, Color? greenBg, Color? redMid, Color? redText,
    SeccionColors? objetivo, SeccionColors? calentamiento, SeccionColors? principal,
    SeccionColors? vuelta, SeccionColors? nutricion, SeccionColors? notas,
  }) {
    return AppThemeExtension(
      bg: bg ?? this.bg, card: card ?? this.card, cardDark: cardDark ?? this.cardDark,
      primary: primary ?? this.primary, border: border ?? this.border, white: white ?? this.white,
      grey: grey ?? this.grey, greyLight: greyLight ?? this.greyLight, greenMid: greenMid ?? this.greenMid,
      greenText: greenText ?? this.greenText, greenBg: greenBg ?? this.greenBg, redMid: redMid ?? this.redMid,
      redText: redText ?? this.redText, objetivo: objetivo ?? this.objetivo,
      calentamiento: calentamiento ?? this.calentamiento, principal: principal ?? this.principal,
      vuelta: vuelta ?? this.vuelta, nutricion: nutricion ?? this.nutricion, notas: notas ?? this.notas,
    );
  }

  @override
  AppThemeExtension lerp(ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) return this;
    return this; // Simplificado para estructura estable
  }

  static const dark = AppThemeExtension(
    bg: Color(0xFF151515), card: Color(0xFF242424), cardDark: Color(0xFF1E1E1E),
    primary: Color(0xFFE8622A), border: Color(0xFF3A3A3A), white: Color(0xFFFFFFFF),
    grey: Color(0xFF9E9E9E), greyLight: Color(0xFFBDBDBD), greenMid: Color(0xFF2E6B4F),
    greenText: Color(0xFF4DC48A), greenBg: Color(0xFF1A3A2A), redMid: Color(0xFFB03A2E),
    redText: Color(0xFFE05050),
    objetivo: SeccionColors(bg: Color(0xFF1E1208), border: Color(0xFF6B3010), primary: Color(0xFFE8700A)),
    calentamiento: SeccionColors(bg: Color(0xFF1A1408), border: Color(0xFF5A3C0A), primary: Color(0xFFEF9F27)),
    principal: SeccionColors(bg: Color(0xFF0A1520), border: Color(0xFF1A4060), primary: Color(0xFF4A90D9)),
    vuelta: SeccionColors(bg: Color(0xFF081820), border: Color(0xFF0A4A56), primary: Color(0xFF00BCD4)),
    nutricion: SeccionColors(bg: Color(0xFF120D1E), border: Color(0xFF3D2870), primary: Color(0xFFB39DDB)),
    notas: SeccionColors(bg: Color(0xFF14101A), border: Color(0xFF3A2E45), primary: Color(0xFF9B8EA8)),
  );

  static const light = AppThemeExtension(
    bg: Color(0xFFF5F5F5), card: Color(0xFFFFFFFF), cardDark: Color(0xFFE0E0E0),
    primary: Color(0xFFE8622A), border: Color(0xFFBDBDBD), white: Color(0xFF151515),
    grey: Color(0xFF757575), greyLight: Color(0xFF616161), greenMid: Color(0xFF2E6B4F),
    greenText: Color(0xFF2E6B4F), greenBg: Color(0xFFC8E6C9), redMid: Color(0xFFB03A2E),
    redText: Color(0xFFB03A2E),
    objetivo: SeccionColors(bg: Color(0xFFFFF3E0), border: Color(0xFFFFCC80), primary: Color(0xFFE8700A)),
    calentamiento: SeccionColors(bg: Color(0xFFFFF8E1), border: Color(0xFFFFE082), primary: Color(0xFFEF9F27)),
    principal: SeccionColors(bg: Color(0xFFE3F2FD), border: Color(0xFF90CAF9), primary: Color(0xFF4A90D9)),
    vuelta: SeccionColors(bg: Color(0xFFE0F7FA), border: Color(0xFF80DEEA), primary: Color(0xFF00BCD4)),
    nutricion: SeccionColors(bg: Color(0xFFEDE7F6), border: Color(0xFFCE93D8), primary: Color(0xFF7E57C2)),
    notas: SeccionColors(bg: Color(0xFFF3E5F5), border: Color(0xFFE1BEE7), primary: Color(0xFF8E24AA)),
  );

  Color? get textSecondary => null;

  Color? get text => null;
}
