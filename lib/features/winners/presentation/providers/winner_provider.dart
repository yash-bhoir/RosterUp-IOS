import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/winner_remote_datasource.dart';
import '../../domain/entities/winner.dart';

final contestWinnersProvider =
    AsyncNotifierProvider<ContestWinnersNotifier, List<Winner>>(
  ContestWinnersNotifier.new,
);

class ContestWinnersNotifier extends AsyncNotifier<List<Winner>> {
  @override
  Future<List<Winner>> build() async {
    final ds = ref.read(winnerRemoteDatasourceProvider);
    final json = await ds.getContestWinners();
    return _parseWinners(json);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(build);
  }
}

final megaWinnersProvider =
    AsyncNotifierProvider<MegaWinnersNotifier, List<Winner>>(
  MegaWinnersNotifier.new,
);

class MegaWinnersNotifier extends AsyncNotifier<List<Winner>> {
  @override
  Future<List<Winner>> build() async {
    final ds = ref.read(winnerRemoteDatasourceProvider);
    final json = await ds.getMegaContestWinners();
    return _parseWinners(json);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(build);
  }
}

List<Winner> _parseWinners(Map<String, dynamic> json) {
  final data = json['data'];
  List<dynamic> items = [];
  if (data is Map<String, dynamic>) {
    items = data['data'] as List<dynamic>? ?? [];
  } else if (data is List) {
    items = data;
  }
  return items.map((e) {
    final m = e as Map<String, dynamic>;
    return Winner(
      userId: m['user_id'] ?? 0,
      userName: m['user_name'] ?? '',
      profilePic: m['profile_pic'] ?? '',
      matchName: m['match_name'] ?? '',
      leagueName: m['league_name'] ?? '',
      wonAmount: (m['won_amount'] ?? m['amount_won'] ?? 0).toDouble(),
      rank: m['rank'] ?? 0,
      sportsKey: m['sports_key'] ?? '',
      date: m['date'] ?? m['created_at'] ?? '',
    );
  }).toList();
}
