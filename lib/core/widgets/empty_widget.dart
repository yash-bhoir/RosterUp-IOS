import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

class EmptyWidget extends StatelessWidget {
  final String message;
  final IconData icon;
  final Widget? action;

  const EmptyWidget({
    super.key,
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.paddingXl,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.tabGrey, size: 56),
            AppSpacing.gapVLg,
            Text(
              message,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.themeText,
              ),
              textAlign: TextAlign.center,
            ),
            if (action != null) ...[
              AppSpacing.gapVXl,
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
