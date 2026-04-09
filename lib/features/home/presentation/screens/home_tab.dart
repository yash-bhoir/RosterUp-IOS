import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_card.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner placeholder
          Container(
            height: 160,
            margin: AppSpacing.paddingMd,
            decoration: BoxDecoration(
              color: AppColors.darkText,
              borderRadius: AppSpacing.borderRadiusMd,
              gradient: const LinearGradient(
                colors: [AppColors.statusBar, AppColors.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Text(
                'ROSTERUP',
                style: AppTypography.heading1.copyWith(
                  color: AppColors.white,
                  letterSpacing: 4,
                ),
              ),
            ),
          ),

          // Section: Upcoming Matches
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Upcoming Matches', style: AppTypography.heading3),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'View All',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.primaryDark,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Placeholder match cards
          MatchCard(
            headerText: 'BGMI Tournament',
            headerTrailing: '2h 30m',
            body: _MatchCardBody(),
          ),
          AppSpacing.gapVSm,
          MatchCard(
            headerText: 'PUBG Classic',
            headerTrailing: '5h 15m',
            body: _MatchCardBody(),
          ),
          AppSpacing.gapVXl,
        ],
      ),
    );
  }
}

class _MatchCardBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Teams', style: AppTypography.caption),
            AppSpacing.gapVXs,
            Text('16', style: AppTypography.labelLarge),
          ],
        ),
        Column(
          children: [
            Text('VS', style: AppTypography.labelSmall.copyWith(
              color: AppColors.primaryDark,
            )),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('Prize Pool', style: AppTypography.caption),
            AppSpacing.gapVXs,
            Text(
              '500 RC',
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.primaryDark,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
