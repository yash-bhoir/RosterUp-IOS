import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../profile/presentation/providers/profile_provider.dart';

class ReferEarnScreen extends ConsumerWidget {
  const ReferEarnScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);
    final referralCode = profileAsync.valueOrNull?.referralCode ?? '';

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title: const Text('Refer & Earn', style: AppTypography.labelLarge),
        backgroundColor: AppColors.darkText,
        centerTitle: true,
      ),
      body: Padding(
        padding: AppSpacing.paddingXl,
        child: Column(
          children: [
            AppSpacing.gapVXl,
            Icon(
              Icons.people_outline,
              size: 80,
              color: AppColors.primaryDark.withOpacity(0.6),
            ),
            AppSpacing.gapVXl,
            Text(
              'Invite Friends & Earn',
              style: AppTypography.heading2,
            ),
            AppSpacing.gapVMd,
            Text(
              'Share your referral code with friends. When they sign up and play, you both earn bonus rewards!',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.themeText,
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.gapVXl,
            // Referral code card
            Container(
              width: double.infinity,
              padding: AppSpacing.paddingLg,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: AppSpacing.borderRadiusMd,
                border: Border.all(
                  color: AppColors.primaryDark,
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Text('Your Referral Code', style: AppTypography.caption),
                  AppSpacing.gapVSm,
                  Text(
                    referralCode.isNotEmpty ? referralCode : '---',
                    style: AppTypography.heading1.copyWith(
                      color: AppColors.primaryDark,
                      letterSpacing: 3,
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.gapVXl,
            // Copy & Share buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: referralCode.isNotEmpty
                        ? () {
                            Clipboard.setData(
                                ClipboardData(text: referralCode));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Code copied!')),
                            );
                          }
                        : null,
                    icon: const Icon(Icons.copy,
                        size: 18, color: AppColors.primaryDark),
                    label: Text(
                      'COPY',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.primaryDark,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primaryDark),
                      minimumSize:
                          const Size(0, AppSpacing.buttonHeight),
                    ),
                  ),
                ),
                AppSpacing.gapHMd,
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: referralCode.isNotEmpty
                        ? () {
                            // TODO: Share via share_plus
                          }
                        : null,
                    icon: const Icon(Icons.share,
                        size: 18, color: AppColors.black),
                    label: Text(
                      'SHARE',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize:
                          const Size(0, AppSpacing.buttonHeight),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
