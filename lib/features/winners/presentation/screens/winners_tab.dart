import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/empty_widget.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../domain/entities/winner.dart';
import '../providers/winner_provider.dart';

class WinnersTab extends ConsumerWidget {
  const WinnersTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            color: AppColors.darkText,
            child: TabBar(
              labelStyle: AppTypography.tab,
              indicatorColor: AppColors.primaryDark,
              labelColor: AppColors.primaryDark,
              unselectedLabelColor: AppColors.themeText,
              tabs: const [
                Tab(text: 'Contest Winners'),
                Tab(text: 'Mega Winners'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _WinnersList(provider: contestWinnersProvider),
                _WinnersList(provider: megaWinnersProvider),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WinnersList extends ConsumerWidget {
  final AsyncNotifierProvider<AsyncNotifier<List<Winner>>, List<Winner>>
      provider;

  const _WinnersList({required this.provider});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(provider);

    return state.when(
      loading: () => const LoadingIndicator(),
      error: (e, _) => AppErrorWidget(
        message: e.toString(),
        onRetry: () => ref.invalidate(provider),
      ),
      data: (winners) {
        if (winners.isEmpty) {
          return const EmptyWidget(
            message: 'No winners yet',
            icon: Icons.emoji_events_outlined,
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          itemCount: winners.length,
          separatorBuilder: (_, __) => const Divider(
            height: 1,
            color: AppColors.matchBar,
          ),
          itemBuilder: (context, index) {
            return _WinnerCard(winner: winners[index]);
          },
        );
      },
    );
  }
}

class _WinnerCard extends StatelessWidget {
  final Winner winner;

  const _WinnerCard({required this.winner});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardBackground,
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      child: Padding(
        padding: AppSpacing.paddingMd,
        child: Row(
          children: [
            // Rank badge
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: winner.rank <= 3
                    ? AppColors.primaryDark
                    : AppColors.surfaceVariant,
              ),
              child: Center(
                child: Text(
                  '#${winner.rank}',
                  style: AppTypography.captionSmall.copyWith(
                    color: winner.rank <= 3
                        ? AppColors.black
                        : AppColors.themeText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            AppSpacing.gapHMd,
            // User & match info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(winner.userName, style: AppTypography.labelSmall),
                  AppSpacing.gapVXs,
                  Text(
                    '${winner.matchName} • ${winner.leagueName}',
                    style: AppTypography.captionSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (winner.date.isNotEmpty)
                    Text(winner.date, style: AppTypography.captionSmall),
                ],
              ),
            ),
            // Won amount
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹${winner.wonAmount.toStringAsFixed(0)}',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.primaryDark,
                  ),
                ),
                if (winner.sportsKey.isNotEmpty)
                  Text(
                    winner.sportsKey.toUpperCase(),
                    style: AppTypography.captionSmall,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
