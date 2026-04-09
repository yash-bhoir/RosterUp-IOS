import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/empty_widget.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../domain/entities/reward.dart';
import '../providers/reward_provider.dart';
import 'coupons_screen.dart';
import 'my_rewards_screen.dart';

class RewardsTab extends ConsumerWidget {
  const RewardsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(rewardCategoriesProvider);

    return Column(
      children: [
        // My Rewards button
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const MyRewardsScreen(),
                ));
              },
              icon: const Icon(Icons.card_giftcard,
                  color: AppColors.primaryDark, size: 18),
              label: Text(
                'My Rewards',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.primaryDark,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primaryDark),
              ),
            ),
          ),
        ),
        // Categories
        Expanded(
          child: categoriesAsync.when(
            loading: () => const LoadingIndicator(),
            error: (e, _) => AppErrorWidget(
              message: e.toString(),
              onRetry: () => ref.invalidate(rewardCategoriesProvider),
            ),
            data: (categories) {
              if (categories.isEmpty) {
                return const EmptyWidget(
                  message: 'No reward categories',
                  icon: Icons.card_giftcard_outlined,
                );
              }
              return GridView.builder(
                padding: AppSpacing.paddingMd,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.4,
                  crossAxisSpacing: AppSpacing.md,
                  mainAxisSpacing: AppSpacing.md,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return _CategoryCard(
                    category: categories[index],
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => CouponsScreen(
                          category: categories[index],
                        ),
                      ));
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final RewardCategory category;
  final VoidCallback onTap;

  const _CategoryCard({required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardBackground,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppSpacing.borderRadiusSm,
        child: Padding(
          padding: AppSpacing.paddingMd,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.card_giftcard,
                  size: 32, color: AppColors.primaryDark),
              AppSpacing.gapVMd,
              Text(
                category.name,
                style: AppTypography.labelSmall,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
