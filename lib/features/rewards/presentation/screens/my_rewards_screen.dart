import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/empty_widget.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../providers/reward_provider.dart';

class MyRewardsScreen extends ConsumerWidget {
  const MyRewardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final couponsAsync = ref.watch(userCouponsProvider);

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title: const Text('My Rewards', style: AppTypography.labelLarge),
        backgroundColor: AppColors.darkText,
        centerTitle: true,
      ),
      body: couponsAsync.when(
        loading: () => const LoadingIndicator(),
        error: (e, _) => AppErrorWidget(
          message: e.toString(),
          onRetry: () => ref.read(userCouponsProvider.notifier).refresh(),
        ),
        data: (coupons) {
          if (coupons.isEmpty) {
            return const EmptyWidget(
              message: 'No rewards yet',
              icon: Icons.card_giftcard_outlined,
            );
          }
          return ListView.separated(
            padding: AppSpacing.paddingMd,
            itemCount: coupons.length,
            separatorBuilder: (_, __) => AppSpacing.gapVSm,
            itemBuilder: (context, index) {
              final coupon = coupons[index];
              return Card(
                color: AppColors.cardBackground,
                child: ListTile(
                  leading: const Icon(Icons.card_giftcard,
                      color: AppColors.primaryDark),
                  title: Text(coupon.name, style: AppTypography.labelSmall),
                  subtitle: coupon.expiryDate.isNotEmpty
                      ? Text('Expires: ${coupon.expiryDate}',
                          style: AppTypography.captionSmall)
                      : null,
                  trailing: Text(
                    '₹${coupon.price}',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.primaryDark,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
