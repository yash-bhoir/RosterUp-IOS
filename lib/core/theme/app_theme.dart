import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_spacing.dart';

abstract final class AppTheme {
  static ThemeData get dark => ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    fontFamily: 'Inter',

    // Colors
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryDark,
      onPrimary: AppColors.themeText,
      secondary: AppColors.accent,
      onSecondary: AppColors.black,
      surface: AppColors.black,
      onSurface: AppColors.white,
      error: AppColors.red,
      onError: AppColors.white,
    ),
    scaffoldBackgroundColor: AppColors.black,
    canvasColor: AppColors.black,

    // AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.statusBar,
      foregroundColor: AppColors.white,
      elevation: 0,
      centerTitle: true,
      toolbarHeight: AppSpacing.toolbarHeight,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: AppColors.statusBar,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      titleTextStyle: AppTypography.heading2,
      iconTheme: IconThemeData(
        color: AppColors.white,
        size: 24,
      ),
    ),

    // Bottom Navigation
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkText,
      selectedItemColor: AppColors.primaryDark,
      unselectedItemColor: AppColors.white,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: AppTypography.captionSmall,
      unselectedLabelStyle: AppTypography.captionSmall,
      elevation: 8,
    ),

    // Navigation Bar (Material 3)
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.darkText,
      indicatorColor: AppColors.primaryDark.withValues(alpha: 0.2),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppTypography.captionSmall.copyWith(color: AppColors.primaryDark);
        }
        return AppTypography.captionSmall;
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: AppColors.primaryDark, size: 24);
        }
        return const IconThemeData(color: AppColors.white, size: 24);
      }),
    ),

    // Cards
    cardTheme: CardThemeData(
      color: AppColors.cardBackground,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.borderRadiusSm,
      ),
      margin: EdgeInsets.zero,
    ),

    // Elevated Button (Primary)
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: AppColors.themeText,
        minimumSize: const Size(double.infinity, AppSpacing.buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusSm,
        ),
        textStyle: AppTypography.button,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.sm,
        ),
        elevation: 0,
      ),
    ),

    // Outlined Button
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryDark,
        side: const BorderSide(color: AppColors.primaryDark),
        minimumSize: const Size(double.infinity, AppSpacing.buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusSm,
        ),
        textStyle: AppTypography.button,
      ),
    ),

    // Text Button
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryDark,
        textStyle: AppTypography.labelLarge,
      ),
    ),

    // Input Decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.tabNewGrey,
      contentPadding: AppSpacing.paddingMd,
      hintStyle: AppTypography.bodyMedium.copyWith(
        color: AppColors.themeText.withValues(alpha: 0.5),
      ),
      labelStyle: AppTypography.bodyMedium.copyWith(
        color: AppColors.themeText,
      ),
      border: OutlineInputBorder(
        borderRadius: AppSpacing.borderRadiusMd,
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppSpacing.borderRadiusMd,
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppSpacing.borderRadiusMd,
        borderSide: const BorderSide(color: AppColors.primaryDark),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppSpacing.borderRadiusMd,
        borderSide: const BorderSide(color: AppColors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: AppSpacing.borderRadiusMd,
        borderSide: const BorderSide(color: AppColors.red),
      ),
    ),

    // Tab Bar
    tabBarTheme: TabBarThemeData(
      labelColor: AppColors.primaryDark,
      unselectedLabelColor: AppColors.white,
      labelStyle: AppTypography.tab,
      unselectedLabelStyle: AppTypography.tab,
      indicator: const UnderlineTabIndicator(
        borderSide: BorderSide(color: AppColors.primaryDark, width: 2),
      ),
      indicatorSize: TabBarIndicatorSize.tab,
    ),

    // Bottom Sheet
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSpacing.radiusBottomSheet),
          topRight: Radius.circular(AppSpacing.radiusBottomSheet),
        ),
      ),
      showDragHandle: true,
      dragHandleColor: AppColors.tabGrey,
    ),

    // Dialog
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.darkText,
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.borderRadiusSm,
      ),
      titleTextStyle: AppTypography.heading3,
      contentTextStyle: AppTypography.bodyMedium,
    ),

    // Divider
    dividerTheme: const DividerThemeData(
      color: AppColors.matchBar,
      thickness: 0.5,
      space: 0,
    ),

    // Progress Indicator
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primaryDark,
      linearTrackColor: AppColors.darkText,
    ),

    // Chip
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.darkText,
      selectedColor: AppColors.primaryDark,
      labelStyle: AppTypography.labelSmall,
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.borderRadiusSm,
      ),
      side: const BorderSide(color: AppColors.primaryDark),
    ),

    // Snackbar
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.darkText,
      contentTextStyle: AppTypography.bodyMedium,
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.borderRadiusSm,
      ),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
