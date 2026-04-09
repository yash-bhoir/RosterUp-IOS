import 'package:cached_network_image/cached_network_image.dart';
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

class CouponsScreen extends ConsumerWidget {
  final RewardCategory category;

  const CouponsScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final couponsAsync =
        ref.watch(couponsByCategoryProvider(category.categoryId.toString()));

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title: Text(category.name, style: AppTypography.labelLarge),
        backgroundColor: AppColors.darkText,
        centerTitle: true,
      ),
      body: couponsAsync.when(
        loading: () => const LoadingIndicator(),
        error: (e, _) => AppErrorWidget(
          message: e.toString(),
          onRetry: () => ref.invalidate(
              couponsByCategoryProvider(category.categoryId.toString())),
        ),
        data: (coupons) {
          if (coupons.isEmpty) {
            return const EmptyWidget(
              message: 'No coupons available',
              icon: Icons.local_offer_outlined,
            );
          }
          return ListView.separated(
            padding: AppSpacing.paddingMd,
            itemCount: coupons.length,
            separatorBuilder: (_, __) => AppSpacing.gapVSm,
            itemBuilder: (context, index) {
              return _CouponCard(
                coupon: coupons[index],
                onBuy: () => _buyCoupon(context, ref, coupons[index]),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _buyCoupon(
    BuildContext context,
    WidgetRef ref,
    Coupon coupon,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceVariant,
        title: const Text('Buy Coupon', style: AppTypography.heading3),
        content: Text(
          'Buy "${coupon.name}" for ₹${coupon.price}?',
          style: AppTypography.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Buy'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final success =
        await ref.read(buyCouponProvider.notifier).buy(coupon.couponId);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(success ? 'Coupon purchased!' : 'Purchase failed'),
      backgroundColor: success ? AppColors.green : AppColors.red,
    ));
  }
}

class _CouponCard extends StatelessWidget {
  final Coupon coupon;
  final VoidCallback onBuy;

  const _CouponCard({required this.coupon, required this.onBuy});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardBackground,
      child: Padding(
        padding: AppSpacing.paddingMd,
        child: Row(
          children: [
            // Coupon image
            ClipRRect(
              borderRadius: AppSpacing.borderRadiusSm,
              child: coupon.image.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: coupon.image,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => _placeholderIcon(),
                    )
                  : _placeholderIcon(),
            ),
            AppSpacing.gapHMd,
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    coupon.name,
                    style: AppTypography.labelSmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (coupon.description.isNotEmpty) ...[
                    AppSpacing.gapVXs,
                    Text(
                      coupon.description,
                      style: AppTypography.captionSmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  AppSpacing.gapVSm,
                  Text(
                    '₹${coupon.price}',
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.primaryDark,
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.gapHSm,
            // Buy button
            SizedBox(
              height: 30,
              child: ElevatedButton(
                onPressed: onBuy,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  minimumSize: Size.zero,
                ),
                child: Text(
                  'BUY',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholderIcon() {
    return Container(
      width: 60,
      height: 60,
      color: AppColors.surfaceVariant,
      child: const Icon(
        Icons.local_offer,
        color: AppColors.primaryDark,
        size: 28,
      ),
    );
  }
}
