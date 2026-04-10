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
import 'contest_detail_screen.dart';

class MyContestsTab extends ConsumerWidget {
  final int matchId;

  const MyContestsTab({super.key, required this.matchId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(myContestsProvider(matchId.toString()));

    return state.when(
      loading: () => const LoadingIndicator(),
      error: (e, _) => AppErrorWidget(
        message: e.toString(),
        onRetry: () =>
            ref.invalidate(myContestsProvider(matchId.toString())),
      ),
      data: (contests) {
        if (contests.isEmpty) {
          return const EmptyWidget(
            message: 'You haven\'t joined any contest yet',
            icon: Icons.sports_esports_outlined,
          );
        }
        return RefreshIndicator(
          color: AppColors.primaryDark,
          onRefresh: () async =>
              ref.invalidate(myContestsProvider(matchId.toString())),
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            itemCount: contests.length,
            separatorBuilder: (_, __) => AppSpacing.gapVXs,
            itemBuilder: (context, index) {
              return _MyContestCard(
                myContest: contests[index],
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => ContestDetailScreen(
                      contest: contests[index].league,
                      matchId: matchId,
                    ),
                  ));
                },
              );
            },
          ),
        );
      },
    );
  }
}

class _MyContestCard extends StatefulWidget {
  final MyContest myContest;
  final VoidCallback? onTap;

  const _MyContestCard({required this.myContest, this.onTap});

  @override
  State<_MyContestCard> createState() => _MyContestCardState();
}

class _MyContestCardState extends State<_MyContestCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final league = widget.myContest.league;
    final teams = widget.myContest.teams;

    return Card(
      color: AppColors.cardBackground,
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: AppSpacing.borderRadiusSm,
        child: Column(
          children: [
            Padding(
              padding: AppSpacing.paddingMd,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // League name & prize
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          league.leagueName,
                          style: AppTypography.labelSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '₹${league.winningAmount}',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.gapVSm,
                  // Spots progress
                  ClipRRect(
                    borderRadius: AppSpacing.borderRadiusSm,
                    child: LinearProgressIndicator(
                      value: league.spotsProgress,
                      minHeight: 4,
                      backgroundColor: AppColors.tabGrey,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        league.spotsProgress > 0.8
                            ? AppColors.red
                            : AppColors.highlighter,
                      ),
                    ),
                  ),
                  AppSpacing.gapVSm,
                  // Joined teams count
                  GestureDetector(
                    onTap: () => setState(() => _expanded = !_expanded),
                    child: Row(
                      children: [
                        Text(
                          'Joined with ${teams.length} team${teams.length != 1 ? 's' : ''}',
                          style: AppTypography.captionSmall.copyWith(
                            color: AppColors.primaryDark,
                          ),
                        ),
                        Icon(
                          _expanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          size: 16,
                          color: AppColors.primaryDark,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Expandable team list
            if (_expanded)
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: AppColors.matchBar, width: 0.5),
                  ),
                ),
                child: Column(
                  children: teams.map((team) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(team.teamName, style: AppTypography.labelSmall),
                              if (team.totalPoints > 0)
                                Text(
                                  '${team.totalPoints} pts',
                                  style: AppTypography.captionSmall,
                                ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (team.rank > 0)
                                Text(
                                  '#${team.rank}',
                                  style: AppTypography.labelSmall,
                                ),
                              if (team.wonAmount > 0)
                                Text(
                                  '₹${team.wonAmount.toStringAsFixed(0)}',
                                  style: AppTypography.captionSmall.copyWith(
                                    color: AppColors.highlighter,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
