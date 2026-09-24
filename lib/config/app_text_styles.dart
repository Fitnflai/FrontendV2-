import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Headings
  static const h1 = TextStyle(
      color: AppColors.white, fontSize: 28, fontWeight: FontWeight.w800);
  static const h2 = TextStyle(
      color: AppColors.white, fontSize: 22, fontWeight: FontWeight.w800);
  static const h3 = TextStyle(
      color: AppColors.white, fontSize: 18, fontWeight: FontWeight.w700);
  static const h4 = TextStyle(
      color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w700);
  static const h5 = TextStyle(
      color: AppColors.white, fontSize: 14, fontWeight: FontWeight.w700);

  // Body
  static const bodyLarge = TextStyle(
      color: AppColors.greyLight, fontSize: 14, height: 1.5);
  static const bodyMedium = TextStyle(
      color: AppColors.greyLight, fontSize: 13, height: 1.5);
  static const bodySmall = TextStyle(
      color: AppColors.grey, fontSize: 12, height: 1.4);

  // Labels
  static const labelOrange = TextStyle(
      color: AppColors.orange, fontSize: 13, fontWeight: FontWeight.w700);
  static const labelGreen = TextStyle(
      color: AppColors.greenText, fontSize: 13, fontWeight: FontWeight.w600);
  static const labelGrey = TextStyle(
      color: AppColors.grey, fontSize: 12, fontWeight: FontWeight.w400);
  static const labelSmall = TextStyle(
      color: AppColors.grey, fontSize: 10, fontWeight: FontWeight.w400);

  // Section title (MAYÚSCULAS)
  static const sectionTitle = TextStyle(
      color: AppColors.orange, fontSize: 13,
      fontWeight: FontWeight.w800, letterSpacing: 0.8);

  // Badge
  static const badgeObligatory = TextStyle(
      color: AppColors.redText, fontSize: 11, fontWeight: FontWeight.w600);
  static const badgeOptional = TextStyle(
      color: AppColors.greenText, fontSize: 11, fontWeight: FontWeight.w600);
  static const badgeOrange = TextStyle(
      color: AppColors.orange, fontSize: 11, fontWeight: FontWeight.w600);
}
