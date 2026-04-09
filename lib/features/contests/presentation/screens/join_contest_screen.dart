import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../providers/contest_provider.dart';
import 'all_contests_tab.dart';
import 'my_contests_tab.dart';

class JoinContestScreen extends ConsumerWidget {
  final int matchId;

  const JoinContestScreen({super.key, required this.matchId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchDetail = ref.watch(matchDetailProvider(matchId.toString()));

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title: matchDetail.when(
          data: (d) => Text(d.name, style: AppTypography.labelLarge),
          loading: () => const Text('Loading...'),
          error: (_, __) => const Text('Match'),
        ),
        backgroundColor: AppColors.darkText,
        centerTitle: true,
      ),
      body: matchDetail.when(
        loading: () => const LoadingIndicator(),
        error: (e, _) => AppErrorWidget(
          message: e.toString(),
          onRetry: () =>
              ref.read(matchDetailProvider(matchId.toString()).notifier).refresh(),
        ),
        data: (detail) => Column(
          children: [
            // Match header
            _MatchHeader(
              matchName: detail.name,
              location: detail.location,
              dayName: detail.dayName,
              startAt: detail.startAt,
              status: detail.status,
            ),
            // Tabs
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
                          Tab(text: 'All Contests'),
                          Tab(text: 'My Contests'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          AllContestsTab(matchId: matchId),
                          MyContestsTab(matchId: matchId),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Navigate to Create Team screen
        },
        backgroundColor: AppColors.primaryDark,
        icon: const Icon(Icons.add, color: AppColors.black),
        label: Text(
          'CREATE TEAM',
          style: AppTypography.labelMedium.copyWith(color: AppColors.black),
        ),
      ),
    );
  }
}

class _MatchHeader extends StatelessWidget {
  final String matchName;
  final String location;
  final String dayName;
  final String startAt;
  final String status;

  const _MatchHeader({
    required this.matchName,
    required this.location,
    required this.dayName,
    required this.startAt,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final isLive = status == 'started' || status == 'live';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      color: AppColors.surfaceVariant,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  matchName.toUpperCase(),
                  style: AppTypography.labelMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                AppSpacing.gapVXs,
                Text(
                  '${location.toUpperCase()} • $dayName',
                  style: AppTypography.captionSmall,
                ),
              ],
            ),
          ),
          if (isLive)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.red,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'LIVE',
                style: AppTypography.captionSmall.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          else
            Text(
              _formatCountdown(startAt),
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.primaryDark,
              ),
            ),
        ],
      ),
    );
  }

  String _formatCountdown(String startAt) {
    try {
      final dt = DateTime.parse(startAt);
      final diff = dt.difference(DateTime.now().toUtc());
      if (diff.isNegative) return 'Started';
      if (diff.inDays > 0) return '${diff.inDays}d ${diff.inHours % 24}h';
      if (diff.inHours > 0) return '${diff.inHours}h ${diff.inMinutes % 60}m';
      return '${diff.inMinutes}m';
    } catch (_) {
      return '';
    }
  }
}
