import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/empty_widget.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../domain/entities/contest.dart';
import '../providers/contest_provider.dart';

class ContestDetailScreen extends ConsumerWidget {
  final Contest contest;
  final int matchId;

  const ContestDetailScreen({
    super.key,
    required this.contest,
    required this.matchId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title: Text(contest.leagueName, style: AppTypography.labelLarge),
        backgroundColor: AppColors.darkText,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Contest header
          _ContestHeader(contest: contest),
          // Tabs: Leaderboard & Winnings
          Expanded(
            child: DefaultTabController(
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
                        Tab(text: 'Leaderboard'),
                        Tab(text: 'Winnings'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _LeaderboardTab(
                          leagueId: contest.leagueId.toString(),
                        ),
                        _WinningsTab(
                          leagueId: contest.leagueId.toString(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: contest.isFull
          ? null
          : SafeArea(
              child: Padding(
                padding: AppSpacing.paddingMd,
                child: SizedBox(
                  height: AppSpacing.buttonHeight,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.push('/create-team/$matchId'),
                    child: Text(
                      contest.isFree
                          ? 'JOIN FREE'
                          : 'JOIN ₹${contest.entryFees}',
                      style: AppTypography.button.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

class _ContestHeader extends StatelessWidget {
  final Contest contest;

  const _ContestHeader({required this.contest});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.paddingMd,
      color: AppColors.surfaceVariant,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Prize Pool', style: AppTypography.captionSmall),
                  Text(
                    '₹${contest.winningAmount}',
                    style: AppTypography.heading2.copyWith(
                      color: AppColors.primaryDark,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Entry', style: AppTypography.captionSmall),
                  Text(
                    contest.isFree ? 'FREE' : '₹${contest.entryFees}',
                    style: AppTypography.heading3,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('1st Prize', style: AppTypography.captionSmall),
                  Text(
                    '₹${contest.firstPrize}',
                    style: AppTypography.heading3,
                  ),
                ],
              ),
            ],
          ),
          AppSpacing.gapVMd,
          ClipRRect(
            borderRadius: AppSpacing.borderRadiusSm,
            child: LinearProgressIndicator(
              value: contest.spotsProgress,
              minHeight: 6,
              backgroundColor: AppColors.tabGrey,
              valueColor: AlwaysStoppedAnimation<Color>(
                contest.spotsProgress > 0.8
                    ? AppColors.red
                    : AppColors.highlighter,
              ),
            ),
          ),
          AppSpacing.gapVSm,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${contest.remainingSpots} spots left',
                style: AppTypography.captionSmall.copyWith(
                  color: contest.spotsProgress > 0.8
                      ? AppColors.red
                      : AppColors.highlighter,
                ),
              ),
              Text('${contest.numberOfSpots} spots',
                  style: AppTypography.captionSmall),
            ],
          ),
          if (contest.isGuaranteed) ...[
            AppSpacing.gapVSm,
            Row(
              children: [
                Icon(Icons.verified, size: 12, color: AppColors.highlighter),
                AppSpacing.gapHXs,
                Text(
                  'Guaranteed',
                  style: AppTypography.captionSmall.copyWith(
                    color: AppColors.highlighter,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _LeaderboardTab extends ConsumerWidget {
  final String leagueId;

  const _LeaderboardTab({required this.leagueId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(leaderboardProvider(leagueId));

    return state.when(
      loading: () => const LoadingIndicator(),
      error: (e, _) => AppErrorWidget(
        message: e.toString(),
        onRetry: () => ref.invalidate(leaderboardProvider(leagueId)),
      ),
      data: (entries) {
        if (entries.isEmpty) {
          return const EmptyWidget(
            message: 'No entries yet',
            icon: Icons.leaderboard_outlined,
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          itemCount: entries.length + 1, // +1 for header
          separatorBuilder: (_, __) => const Divider(
            height: 1,
            color: AppColors.matchBar,
          ),
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 40,
                      child: Text('#', style: AppTypography.captionSmall),
                    ),
                    Expanded(
                      child: Text('Team', style: AppTypography.captionSmall),
                    ),
                    SizedBox(
                      width: 60,
                      child: Text('Points',
                          style: AppTypography.captionSmall,
                          textAlign: TextAlign.right),
                    ),
                    SizedBox(
                      width: 60,
                      child: Text('Won',
                          style: AppTypography.captionSmall,
                          textAlign: TextAlign.right),
                    ),
                  ],
                ),
              );
            }
            final entry = entries[index - 1];
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 40,
                    child: Text(
                      '${entry.rank}',
                      style: AppTypography.labelSmall,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(entry.teamName, style: AppTypography.labelSmall),
                        Text(entry.userName, style: AppTypography.captionSmall),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 60,
                    child: Text(
                      '${entry.totalPoints}',
                      style: AppTypography.labelSmall,
                      textAlign: TextAlign.right,
                    ),
                  ),
                  SizedBox(
                    width: 60,
                    child: Text(
                      entry.wonAmount > 0
                          ? '₹${entry.wonAmount.toStringAsFixed(0)}'
                          : '-',
                      style: AppTypography.labelSmall.copyWith(
                        color: entry.wonAmount > 0
                            ? AppColors.highlighter
                            : AppColors.themeText,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _WinningsTab extends ConsumerWidget {
  final String leagueId;

  const _WinningsTab({required this.leagueId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(winningsProvider(leagueId));

    return state.when(
      loading: () => const LoadingIndicator(),
      error: (e, _) => AppErrorWidget(
        message: e.toString(),
        onRetry: () => ref.invalidate(winningsProvider(leagueId)),
      ),
      data: (slots) {
        if (slots.isEmpty) {
          return const EmptyWidget(
            message: 'No winnings info',
            icon: Icons.monetization_on_outlined,
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          itemCount: slots.length + 1,
          separatorBuilder: (_, __) => const Divider(
            height: 1,
            color: AppColors.matchBar,
          ),
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Rank', style: AppTypography.captionSmall),
                    Text('Prize', style: AppTypography.captionSmall),
                  ],
                ),
              );
            }
            final slot = slots[index - 1];
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(slot.rankLabel, style: AppTypography.labelSmall),
                  Text(
                    '₹${slot.prize.toStringAsFixed(0)}',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.primaryDark,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
