import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class ChatTab extends StatelessWidget {
  const ChatTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.paddingXl,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.support_agent,
              size: 64,
              color: AppColors.primaryDark.withOpacity(0.5),
            ),
            AppSpacing.gapVLg,
            Text(
              'Need Help?',
              style: AppTypography.heading2,
            ),
            AppSpacing.gapVMd,
            Text(
              'Our support team is available to help you with any questions or issues.',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.themeText,
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.gapVXl,
            SizedBox(
              width: double.infinity,
              height: AppSpacing.buttonHeight,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Integrate with support chat SDK (e.g. Freshchat/Tawk)
                },
                icon: const Icon(Icons.chat, color: AppColors.black),
                label: Text(
                  'START CHAT',
                  style: AppTypography.button.copyWith(
                    color: AppColors.black,
                  ),
                ),
              ),
            ),
            AppSpacing.gapVMd,
            SizedBox(
              width: double.infinity,
              height: AppSpacing.buttonHeight,
              child: OutlinedButton.icon(
                onPressed: () {
                  // TODO: Open email support
                },
                icon: const Icon(Icons.email_outlined,
                    color: AppColors.primaryDark),
                label: Text(
                  'EMAIL SUPPORT',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.primaryDark,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primaryDark),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
