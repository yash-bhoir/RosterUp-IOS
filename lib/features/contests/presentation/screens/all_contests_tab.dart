import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/empty_widget.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../domain/entities/contest.dart';
import '../providers/contest_provider.dart';

class AllContestsTab extends ConsumerStatefulWidget {
  final int matchId;

  const AllContestsTab({super.key, required this.matchId});

  @override
  ConsumerState<AllContestsTab> createState() => _AllContestsTabState();
}

class _AllContestsTabState extends ConsumerState<AllContestsTab> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref
          .read(allContestsProvider(widget.matchId.toString()).notifier)
          .loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state =
        ref.watch(allContestsProvider(widget.matchId.toString()));

    return state.when(
      loading: () => const LoadingIndicator(),
      error: (e, _) => AppErrorWidget(
        message: e.toString(),
        onRetry: () => ref
            .read(allContestsProvider(widget.matchId.toString()).notifier)
            .refresh(),
      ),
      data: (data) {
        if (data.contests.isEmpty) {
          return const EmptyWidget(
            message: 'No contests available',
            icon: Icons.emoji_events_outlined,
          );
        }
        return RefreshIndicator(
          color: AppColors.primaryDark,
          onRefresh: () => ref
              .read(allContestsProvider(widget.matchId.toString()).notifier)
              .refresh(),
          child: ListView.separated(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            itemCount: data.contests.length + (data.isLoadingMore ? 1 : 0),
            separatorBuilder: (_, __) => AppSpacing.gapVXs,
            itemBuilder: (context, index) {
              if (index >= data.contests.length) {
                return const Padding(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  child: LoadingIndicator(),
                );
              }
              return _ContestListCard(
                contest: data.contests[index],
                onTap: () => _onContestTap(data.contests[index]),
                onJoin: () => _onJoinTap(data.contests[index]),
              );
            },
          ),
        );
      },
    );
  }

  void _onContestTap(Contest contest) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => _placeholder('Contest Detail — ${contest.leagueName}'),
    ));
  }

  void _onJoinTap(Contest contest) {
    // TODO: Navigate to team selection / join flow
  }

  Widget _placeholder(String title) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(title)),
    );
  }
}

class _ContestListCard extends StatelessWidget {
  final Contest contest;
  final VoidCallback? onTap;
  final VoidCallback? onJoin;

  const _ContestListCard({
    required this.contest,
    this.onTap,
    this.onJoin,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardBackground,
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppSpacing.borderRadiusSm,
        child: Padding(
          padding: AppSpacing.paddingMd,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // League name
              if (contest.leagueName.isNotEmpty) ...[
                Text(
                  contest.leagueName,
                  style: AppTypography.captionSmall.copyWith(
                    color: AppColors.themeText,
                  ),
                ),
                AppSpacing.gapVSm,
              ],
              // Prize pool & join button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Prize Pool', style: AppTypography.captionSmall),
                      AppSpacing.gapVXs,
                      Text(
                        '₹${contest.winningAmount}',
                        style: AppTypography.heading3.copyWith(
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 32,
                    child: ElevatedButton(
                      onPressed: contest.isFull ? null : onJoin,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        minimumSize: Size.zero,
                        disabledBackgroundColor: AppColors.tabGrey,
                      ),
                      child: Text(
                        contest.isFull
                            ? 'FULL'
                            : contest.isFree
                                ? 'FREE'
                                : '₹${contest.entryFees}',
                        style: AppTypography.labelMedium.copyWith(
                          color: contest.isFull
                              ? AppColors.themeText
                              : AppColors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              AppSpacing.gapVMd,
              // Spots progress bar
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
                    contest.isFull
                        ? 'Contest Full'
                        : '${contest.remainingSpots} spots left',
                    style: AppTypography.captionSmall.copyWith(
                      color: contest.spotsProgress > 0.8
                          ? AppColors.red
                          : AppColors.highlighter,
                    ),
                  ),
                  Text(
                    '${contest.numberOfSpots} spots',
                    style: AppTypography.captionSmall,
                  ),
                ],
              ),
              AppSpacing.gapVSm,
              // Footer: first prize, max teams, guaranteed
              Row(
                children: [
                  Icon(Icons.emoji_events, size: 12, color: AppColors.themeText),
                  AppSpacing.gapHXs,
                  Text(
                    '₹${contest.firstPrize}',
                    style: AppTypography.captionSmall,
                  ),
                  AppSpacing.gapHMd,
                  if (contest.allowTeams > 0) ...[
                    Icon(Icons.groups, size: 12, color: AppColors.themeText),
                    AppSpacing.gapHXs,
                    Text(
                      'Upto ${contest.allowTeams}',
                      style: AppTypography.captionSmall,
                    ),
                    AppSpacing.gapHMd,
                  ],
                  if (contest.isGuaranteed)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.highlighter,
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Text(
                        'GUARANTEED',
                        style: AppTypography.captionSmall.copyWith(
                          color: AppColors.highlighter,
                          fontSize: 8,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
