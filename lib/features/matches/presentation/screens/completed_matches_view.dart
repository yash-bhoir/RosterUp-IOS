import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/empty_widget.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../providers/match_provider.dart';
import '../widgets/match_list_card.dart';

class CompletedMatchesView extends ConsumerStatefulWidget {
  const CompletedMatchesView({super.key});

  @override
  ConsumerState<CompletedMatchesView> createState() =>
      _CompletedMatchesViewState();
}

class _CompletedMatchesViewState extends ConsumerState<CompletedMatchesView> {
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
      ref.read(completedMatchesProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(completedMatchesProvider);

    return state.when(
      loading: () => const LoadingIndicator(),
      error: (e, _) => AppErrorWidget(
        message: e.toString(),
        onRetry: () => ref.read(completedMatchesProvider.notifier).refresh(),
      ),
      data: (data) {
        if (data.matches.isEmpty) {
          return const EmptyWidget(
            message: 'No completed matches',
            icon: Icons.check_circle_outline,
          );
        }
        return RefreshIndicator(
          color: AppColors.primaryDark,
          onRefresh: () =>
              ref.read(completedMatchesProvider.notifier).refresh(),
          child: ListView.separated(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            itemCount: data.matches.length + (data.isLoadingMore ? 1 : 0),
            separatorBuilder: (_, __) => AppSpacing.gapVXs,
            itemBuilder: (context, index) {
              if (index >= data.matches.length) {
                return const Padding(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  child: LoadingIndicator(),
                );
              }
              final match = data.matches[index];
              return MatchListCard(
                match: match,
                showWonAmount: true,
                onTap: () => _onMatchTap(match.matchId),
              );
            },
          ),
        );
      },
    );
  }

  void _onMatchTap(int matchId) {
    context.push('/contest/$matchId');
  }
}
