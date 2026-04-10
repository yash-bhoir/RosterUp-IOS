import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/contest_repository_impl.dart';
import '../../domain/entities/contest.dart';
import '../../domain/entities/match_detail.dart';

// Match detail for the contest screen
final matchDetailProvider =
    FutureProvider.family<MatchDetail, String>((ref, matchId) async {
  final repo = ref.read(contestRepositoryProvider);
  final result = await repo.getMatchDetail(matchId);
  return result.when(
    success: (data) => data,
    failure: (e) => throw e,
  );
});

// All contests for a match — paginated
final allContestsProvider =
    StateNotifierProvider.family<AllContestsNotifier, AsyncValue<PaginatedContestsState>, String>(
  (ref, matchId) => AllContestsNotifier(ref, matchId),
);

class AllContestsNotifier extends StateNotifier<AsyncValue<PaginatedContestsState>> {
  final Ref _ref;
  final String _matchId;

  AllContestsNotifier(this._ref, this._matchId)
      : super(const AsyncLoading()) {
    _fetch(1);
  }

  Future<void> _fetch(int page) async {
    if (page == 1) state = const AsyncLoading();
    final repo = _ref.read(contestRepositoryProvider);
    final result = await repo.getContestsByMatch(_matchId, page: page);
    result.when(
      success: (data) {
        state = AsyncData(PaginatedContestsState(
          contests: page == 1
              ? data.contests
              : [...(state.valueOrNull?.contests ?? []), ...data.contests],
          page: data.page,
          totalPages: data.totalPages,
          isLoadingMore: false,
        ));
      },
      failure: (e) {
        if (page == 1) {
          state = AsyncError(e, StackTrace.current);
        } else {
          state = AsyncData(state.valueOrNull!.copyWith(isLoadingMore: false));
        }
      },
    );
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasMore || current.isLoadingMore) return;
    state = AsyncData(current.copyWith(isLoadingMore: true));
    await _fetch(current.page + 1);
  }

  Future<void> refresh() async {
    await _fetch(1);
  }
}

// My contests for a match
final myContestsProvider =
    FutureProvider.family<List<MyContest>, String>((ref, matchId) async {
  final repo = ref.read(contestRepositoryProvider);
  final result = await repo.getMyContests(matchId);
  return result.when(
    success: (data) => data,
    failure: (e) => throw e,
  );
});

// Leaderboard for a contest
final leaderboardProvider =
    FutureProvider.family<List<LeaderboardEntry>, String>((ref, leagueId) async {
  final repo = ref.read(contestRepositoryProvider);
  final result = await repo.getLeaderboard(leagueId);
  return result.when(
    success: (data) => data,
    failure: (e) => throw e,
  );
});

// Winnings for a contest
final winningsProvider =
    FutureProvider.family<List<WinningSlot>, String>((ref, leagueId) async {
  final repo = ref.read(contestRepositoryProvider);
  final result = await repo.getWinnings(leagueId);
  return result.when(
    success: (data) => data,
    failure: (e) => throw e,
  );
});

// Join contest action
final joinContestProvider =
    StateNotifierProvider<JoinContestNotifier, AsyncValue<void>>((ref) {
  return JoinContestNotifier(ref);
});

class JoinContestNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  JoinContestNotifier(this._ref) : super(const AsyncData(null));

  Future<bool> join({
    required int leagueId,
    required int matchId,
    required int userTeamId,
  }) async {
    state = const AsyncLoading();
    final repo = _ref.read(contestRepositoryProvider);
    final result = await repo.joinContest(
      leagueId: leagueId,
      matchId: matchId,
      userTeamId: userTeamId,
    );
    return result.when(
      success: (_) {
        state = const AsyncData(null);
        return true;
      },
      failure: (e) {
        state = AsyncError(e, StackTrace.current);
        return false;
      },
    );
  }
}

class PaginatedContestsState {
  final List<Contest> contests;
  final int page;
  final int totalPages;
  final bool isLoadingMore;

  const PaginatedContestsState({
    required this.contests,
    required this.page,
    required this.totalPages,
    this.isLoadingMore = false,
  });

  bool get hasMore => page < totalPages;

  PaginatedContestsState copyWith({
    List<Contest>? contests,
    int? page,
    int? totalPages,
    bool? isLoadingMore,
  }) {
    return PaginatedContestsState(
      contests: contests ?? this.contests,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}
