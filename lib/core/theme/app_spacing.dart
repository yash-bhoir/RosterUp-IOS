import 'package:flutter/material.dart';

abstract final class AppSpacing {
  // Base spacing values (matching Android SDP)
  static const double xxs = 1;
  static const double xs = 2;
  static const double sm = 5;
  static const double md = 10;
  static const double lg = 15;
  static const double xl = 20;
  static const double xxl = 25;
  static const double xxxl = 30;

  // Component-specific sizes
  static const double toolbarHeight = 45;
  static const double buttonHeight = 40;
  static const double iconButton = 25;
  static const double iconButtonLarge = 30;
  static const double profileCircle = 26;
  static const double profileCircleRadius = 13;
  static const double inputHeight = 48;
  static const double logoWidth = 80;
  static const double logoHeight = 50;

  // Corner radii
  static const double radiusSm = 5;
  static const double radiusMd = 10;
  static const double radiusCircle = 13;
  static const double radiusBottomSheet = 35;

  // Stroke widths
  static const double strokeThin = 0.5;
  static const double strokeDefault = 1;
  static const double strokeMedium = 1.5;
  static const double strokeThick = 2;

  // Border radius presets
  static final borderRadiusSm = BorderRadius.circular(radiusSm);
  static final borderRadiusMd = BorderRadius.circular(radiusMd);
  static final borderRadiusCircle = BorderRadius.circular(radiusCircle);
  static final borderRadiusBottomSheet = const BorderRadius.only(
    topLeft: Radius.circular(radiusBottomSheet),
    topRight: Radius.circular(radiusBottomSheet),
  );

  // Edge insets presets
  static const paddingSm = EdgeInsets.all(sm);
  static const paddingMd = EdgeInsets.all(md);
  static const paddingLg = EdgeInsets.all(lg);
  static const paddingXl = EdgeInsets.all(xl);

  static const paddingHorizontalSm = EdgeInsets.symmetric(horizontal: sm);
  static const paddingHorizontalMd = EdgeInsets.symmetric(horizontal: md);
  static const paddingHorizontalLg = EdgeInsets.symmetric(horizontal: lg);
  static const paddingHorizontalXl = EdgeInsets.symmetric(horizontal: xl);

  static const paddingVerticalSm = EdgeInsets.symmetric(vertical: sm);
  static const paddingVerticalMd = EdgeInsets.symmetric(vertical: md);

  // Gap widgets (for use in Row/Column instead of SizedBox)
  static const gapXs = SizedBox(width: xs, height: xs);
  static const gapSm = SizedBox(width: sm, height: sm);
  static const gapMd = SizedBox(width: md, height: md);
  static const gapLg = SizedBox(width: lg, height: lg);
  static const gapXl = SizedBox(width: xl, height: xl);

  // Horizontal gaps
  static const gapHXs = SizedBox(width: xs);
  static const gapHSm = SizedBox(width: sm);
  static const gapHMd = SizedBox(width: md);
  static const gapHLg = SizedBox(width: lg);
  static const gapHXl = SizedBox(width: xl);

  // Vertical gaps
  static const gapVXs = SizedBox(height: xs);
  static const gapVSm = SizedBox(height: sm);
  static const gapVMd = SizedBox(height: md);
  static const gapVLg = SizedBox(height: lg);
  static const gapVXl = SizedBox(height: xl);
}
