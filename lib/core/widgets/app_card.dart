import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? backgroundColor;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor ?? AppColors.cardBackground,
      margin: margin ?? const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppSpacing.borderRadiusSm,
        child: Padding(
          padding: padding ?? AppSpacing.paddingMd,
          child: child,
        ),
      ),
    );
  }
}

class MatchCard extends StatelessWidget {
  final String headerText;
  final String? headerTrailing;
  final Widget? headerAction;
  final Widget body;
  final VoidCallback? onTap;

  const MatchCard({
    super.key,
    required this.headerText,
    this.headerTrailing,
    this.headerAction,
    required this.body,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header bar
          Container(
            padding: AppSpacing.paddingMd,
            decoration: const BoxDecoration(
              color: AppColors.sectionHeader,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppSpacing.radiusSm),
                topRight: Radius.circular(AppSpacing.radiusSm),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    headerText,
                    style: AppTypography.labelSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (headerTrailing != null)
                  Text(headerTrailing!, style: AppTypography.labelSmall),
                if (headerAction != null) ...[
                  AppSpacing.gapHMd,
                  headerAction!,
                ],
              ],
            ),
          ),
          // Body
          Padding(
            padding: AppSpacing.paddingMd,
            child: body,
          ),
        ],
      ),
    );
  }
}

class ContestCard extends StatelessWidget {
  final String leagueName;
  final int entryFees;
  final int winningAmount;
  final int totalSpots;
  final int filledSpots;
  final bool isFree;
  final VoidCallback? onJoin;
  final VoidCallback? onTap;

  const ContestCard({
    super.key,
    required this.leagueName,
    required this.entryFees,
    required this.winningAmount,
    required this.totalSpots,
    required this.filledSpots,
    this.isFree = false,
    this.onJoin,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final spotsProgress = totalSpots > 0 ? filledSpots / totalSpots : 0.0;
    final remainingSpots = totalSpots - filledSpots;

    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Prize & Entry
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Prize Pool', style: AppTypography.caption),
                  AppSpacing.gapVXs,
                  Text(
                    '${winningAmount} RC',
                    style: AppTypography.heading3.copyWith(
                      color: AppColors.primaryDark,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 32,
                child: ElevatedButton(
                  onPressed: onJoin,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    minimumSize: Size.zero,
                  ),
                  child: Text(
                    isFree ? 'FREE' : '${entryFees} RC',
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.themeText,
                    ),
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.gapVMd,
          // Spots progress
          ClipRRect(
            borderRadius: AppSpacing.borderRadiusSm,
            child: LinearProgressIndicator(
              value: spotsProgress,
              minHeight: 6,
              backgroundColor: AppColors.tabGrey,
              valueColor: AlwaysStoppedAnimation<Color>(
                spotsProgress > 0.8 ? AppColors.red : AppColors.highlighter,
              ),
            ),
          ),
          AppSpacing.gapVSm,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$remainingSpots spots left',
                style: AppTypography.captionSmall.copyWith(
                  color: spotsProgress > 0.8 ? AppColors.red : AppColors.highlighter,
                ),
              ),
              Text(
                '$totalSpots spots',
                style: AppTypography.captionSmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
