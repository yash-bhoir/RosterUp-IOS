import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/contest_repository_impl.dart';
import '../../domain/entities/contest.dart';
import '../../domain/entities/match_detail.dart';

// Match detail for the contest screen
final matchDetailProvider =
    AsyncNotifierFamilyProvider<MatchDetailNotifier, MatchDetail, String>(
  MatchDetailNotifier.new,
);

class MatchDetailNotifier extends FamilyAsyncNotifier<MatchDetail, String> {
  @override
  Future<MatchDetail> build(String arg) async {
    final repo = ref.read(contestRepositoryProvider);
    final result = await repo.getMatchDetail(arg);
    return result.when(
      success: (data) => data,
      failure: (e) => throw e,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build(arg));
  }
}

// All contests for a match — paginated
final allContestsProvider = AsyncNotifierFamilyProvider<AllContestsNotifier,
    PaginatedContestsState, String>(
  AllContestsNotifier.new,
);

class AllContestsNotifier
    extends FamilyAsyncNotifier<PaginatedContestsState, String> {
  @override
  Future<PaginatedContestsState> build(String arg) => _fetch(arg, 1);

  Future<PaginatedContestsState> _fetch(String matchId, int page) async {
    final repo = ref.read(contestRepositoryProvider);
    final result = await repo.getContestsByMatch(matchId, page: page);
    return result.when(
      success: (data) => PaginatedContestsState(
        contests: page == 1
            ? data.contests
            : [...(state.valueOrNull?.contests ?? []), ...data.contests],
        page: data.page,
        totalPages: data.totalPages,
        isLoadingMore: false,
      ),
      failure: (e) => throw e,
    );
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasMore || current.isLoadingMore) return;
    state = AsyncData(current.copyWith(isLoadingMore: true));
    try {
      final newState = await _fetch(arg, current.page + 1);
      state = AsyncData(newState);
    } catch (e) {
      state = AsyncData(current.copyWith(isLoadingMore: false));
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetch(arg, 1));
  }
}

// My contests for a match
final myContestsProvider =
    AsyncNotifierFamilyProvider<MyContestsNotifier, List<MyContest>, String>(
  MyContestsNotifier.new,
);

class MyContestsNotifier extends FamilyAsyncNotifier<List<MyContest>, String> {
  @override
  Future<List<MyContest>> build(String arg) async {
    final repo = ref.read(contestRepositoryProvider);
    final result = await repo.getMyContests(arg);
    return result.when(
      success: (data) => data,
      failure: (e) => throw e,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build(arg));
  }
}

// Leaderboard for a contest
final leaderboardProvider = AsyncNotifierFamilyProvider<LeaderboardNotifier,
    List<LeaderboardEntry>, String>(
  LeaderboardNotifier.new,
);

class LeaderboardNotifier
    extends FamilyAsyncNotifier<List<LeaderboardEntry>, String> {
  @override
  Future<List<LeaderboardEntry>> build(String arg) async {
    final repo = ref.read(contestRepositoryProvider);
    final result = await repo.getLeaderboard(arg);
    return result.when(
      success: (data) => data,
      failure: (e) => throw e,
    );
  }
}

// Winnings for a contest
final winningsProvider =
    AsyncNotifierFamilyProvider<WinningsNotifier, List<WinningSlot>, String>(
  WinningsNotifier.new,
);

class WinningsNotifier extends FamilyAsyncNotifier<List<WinningSlot>, String> {
  @override
  Future<List<WinningSlot>> build(String arg) async {
    final repo = ref.read(contestRepositoryProvider);
    final result = await repo.getWinnings(arg);
    return result.when(
      success: (data) => data,
      failure: (e) => throw e,
    );
  }
}

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
