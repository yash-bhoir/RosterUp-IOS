import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/match_repository_impl.dart';
import '../../domain/entities/match.dart';

// Live matches — flat list, auto-refreshes
final liveMatchesProvider =
    AsyncNotifierProvider<LiveMatchesNotifier, List<Match>>(
  LiveMatchesNotifier.new,
);

class LiveMatchesNotifier extends AsyncNotifier<List<Match>> {
  @override
  Future<List<Match>> build() => _fetch();

  Future<List<Match>> _fetch() async {
    final repo = ref.read(matchRepositoryProvider);
    final result = await repo.getLiveMatches();
    return result.when(
      success: (data) => data,
      failure: (e) => throw e,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }
}

// Upcoming matches — paginated
final upcomingMatchesProvider =
    AsyncNotifierProvider<UpcomingMatchesNotifier, PaginatedMatchesState>(
  UpcomingMatchesNotifier.new,
);

class UpcomingMatchesNotifier extends AsyncNotifier<PaginatedMatchesState> {
  @override
  Future<PaginatedMatchesState> build() => _fetch(1);

  Future<PaginatedMatchesState> _fetch(int page) async {
    final repo = ref.read(matchRepositoryProvider);
    final result = await repo.getUpcomingMatches(page: page);
    return result.when(
      success: (data) => PaginatedMatchesState(
        matches: page == 1
            ? data.matches
            : [...(state.valueOrNull?.matches ?? []), ...data.matches],
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
      final newState = await _fetch(current.page + 1);
      state = AsyncData(newState);
    } catch (e) {
      state = AsyncData(current.copyWith(isLoadingMore: false));
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetch(1));
  }
}

// Completed matches — paginated
final completedMatchesProvider =
    AsyncNotifierProvider<CompletedMatchesNotifier, PaginatedMatchesState>(
  CompletedMatchesNotifier.new,
);

class CompletedMatchesNotifier extends AsyncNotifier<PaginatedMatchesState> {
  @override
  Future<PaginatedMatchesState> build() => _fetch(1);

  Future<PaginatedMatchesState> _fetch(int page) async {
    final repo = ref.read(matchRepositoryProvider);
    final result = await repo.getCompletedMatches(page: page);
    return result.when(
      success: (data) => PaginatedMatchesState(
        matches: page == 1
            ? data.matches
            : [...(state.valueOrNull?.matches ?? []), ...data.matches],
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
      final newState = await _fetch(current.page + 1);
      state = AsyncData(newState);
    } catch (e) {
      state = AsyncData(current.copyWith(isLoadingMore: false));
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetch(1));
  }
}

// State for paginated lists
class PaginatedMatchesState {
  final List<Match> matches;
  final int page;
  final int totalPages;
  final bool isLoadingMore;

  const PaginatedMatchesState({
    required this.matches,
    required this.page,
    required this.totalPages,
    this.isLoadingMore = false,
  });

  bool get hasMore => page < totalPages;

  PaginatedMatchesState copyWith({
    List<Match>? matches,
    int? page,
    int? totalPages,
    bool? isLoadingMore,
  }) {
    return PaginatedMatchesState(
      matches: matches ?? this.matches,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}
