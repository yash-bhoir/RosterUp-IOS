import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/empty_widget.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../providers/match_provider.dart';
import '../widgets/match_list_card.dart';

class LiveMatchesView extends ConsumerWidget {
  const LiveMatchesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(liveMatchesProvider);

    return state.when(
      loading: () => const LoadingIndicator(),
      error: (e, _) => AppErrorWidget(
        message: e.toString(),
        onRetry: () => ref.read(liveMatchesProvider.notifier).refresh(),
      ),
      data: (matches) {
        if (matches.isEmpty) {
          return const EmptyWidget(
            message: 'No live matches right now',
            icon: Icons.sports_esports_outlined,
          );
        }
        return RefreshIndicator(
          color: AppColors.primaryDark,
          onRefresh: () => ref.read(liveMatchesProvider.notifier).refresh(),
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            itemCount: matches.length,
            separatorBuilder: (_, __) => AppSpacing.gapVXs,
            itemBuilder: (context, index) {
              final match = matches[index];
              return MatchListCard(
                match: match,
                showLiveBadge: true,
                showWonAmount: false,
                onTap: () => _onMatchTap(context, match.matchId),
              );
            },
          ),
        );
      },
    );
  }

  void _onMatchTap(BuildContext context, int matchId) {
    context.push('/contest/$matchId');
  }
}
