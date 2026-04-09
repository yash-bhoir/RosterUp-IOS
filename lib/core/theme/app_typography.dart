import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract final class AppTypography {
  static const _fontFamily = 'Inter';

  // Headings
  static const heading1 = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 20,
    color: AppColors.white,
  );

  static const heading2 = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 18,
    color: AppColors.white,
  );

  static const heading3 = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 16,
    color: AppColors.white,
  );

  // Body
  static const bodyLarge = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w300,
    fontSize: 16,
    color: AppColors.white,
  );

  static const bodyMedium = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w300,
    fontSize: 14,
    color: AppColors.white,
  );

  static const bodySmall = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w300,
    fontSize: 12,
    color: AppColors.white,
  );

  // Labels (Bold variants)
  static const labelLarge = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 14,
    color: AppColors.white,
  );

  static const labelMedium = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 12,
    color: AppColors.white,
  );

  static const labelSmall = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 10,
    color: AppColors.white,
  );

  // Captions
  static const caption = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w300,
    fontSize: 11,
    color: AppColors.themeText,
  );

  static const captionSmall = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w300,
    fontSize: 9,
    color: AppColors.themeText,
  );

  // Button
  static const button = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 14,
    color: AppColors.themeText,
  );

  // Tab
  static const tab = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 12,
    color: AppColors.white,
  );
}
