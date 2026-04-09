import 'package:flutter/material.dart';

abstract final class AppColors {
  // Primary
  static const primaryDark = Color(0xFFFB9402);
  static const accent = Color(0xFFFCE7CA);
  static const statusBar = Color(0xFF4B2C00);
  static const couponBrown = Color(0xFF241502);

  // Neutrals
  static const black = Color(0xFF000000);
  static const white = Color(0xFFFFFFFF);
  static const themeText = Color(0xFFEAEAEA);
  static const darkText = Color(0xFF313131);
  static const matchBar = Color(0xFF4C4C4C);
  static const tabGrey = Color(0xFF575757);
  static const tabNewGrey = Color(0xFF585858);
  static const grey = Color(0xFFEFEFEF);

  // Semantic
  static const red = Color(0xFFFF0000);
  static const green = Color(0xFF228B22);
  static const highlighter = Color(0xFFB7C616);
  static const completed = Color(0xFFEBFF00);

  // Opacity Variants
  static const contestBg = Color(0x68FB9402);
  static const dialogOverlay = Color(0x88000000);

  // Gradients
  static const primaryGradient = LinearGradient(
    colors: [Color(0xFFFB9402), Color(0xFFE88500)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Surface colors for dark theme
  static const surface = Color(0xFF1A1A1A);
  static const surfaceVariant = Color(0xFF2A2A2A);
  static const cardBackground = darkText;
  static const sectionHeader = matchBar;
}
