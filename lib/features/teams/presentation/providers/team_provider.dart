import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/app_constants.dart';
import '../../data/repositories/team_repository.dart';
import '../../domain/entities/player.dart';

// Fetch match players
final matchPlayersProvider =
    FutureProvider.family<List<Player>, String>((ref, matchId) async {
  final repo = ref.read(teamRepositoryProvider);
  final result = await repo.getMatchPlayers(matchId);
  return result.when(
    success: (data) => data,
    failure: (e) => throw e,
  );
});

// Team creation state
final teamBuilderProvider =
    StateNotifierProvider<TeamBuilderNotifier, TeamComposition>((ref) {
  return TeamBuilderNotifier();
});

class TeamBuilderNotifier extends StateNotifier<TeamComposition> {
  TeamBuilderNotifier()
      : super(const TeamComposition(
          players: [],
          maxCredits: AppConstants.maxTeamCredits,
          teamSize: AppConstants.teamSize,
        ));

  void setPlayers(List<Player> players) {
    state = TeamComposition(
      players: players,
      maxCredits: AppConstants.maxTeamCredits,
      teamSize: AppConstants.teamSize,
    );
  }

  void togglePlayer(int playerId) {
    final players = state.players.map((p) {
      if (p.matchTeamPlayerId == playerId) {
        final newSelected = !p.isSelected;
        if (newSelected && state.isTeamFull) return p;
        if (newSelected && state.creditsRemaining < p.credits) return p;
        return p.copyWith(
          isSelected: newSelected,
          isCaptain: newSelected ? p.isCaptain : false,
          isViceCaptain: newSelected ? p.isViceCaptain : false,
        );
      }
      return p;
    }).toList();
    state = TeamComposition(
      players: players,
      maxCredits: state.maxCredits,
      teamSize: state.teamSize,
    );
  }

  void setCaptain(int playerId) {
    final players = state.players.map((p) {
      if (p.matchTeamPlayerId == playerId) {
        return p.copyWith(
          isCaptain: true,
          isViceCaptain: false,
        );
      }
      return p.copyWith(isCaptain: false);
    }).toList();
    state = TeamComposition(
      players: players,
      maxCredits: state.maxCredits,
      teamSize: state.teamSize,
    );
  }

  void setViceCaptain(int playerId) {
    final players = state.players.map((p) {
      if (p.matchTeamPlayerId == playerId) {
        return p.copyWith(
          isViceCaptain: true,
          isCaptain: false,
        );
      }
      return p.copyWith(isViceCaptain: false);
    }).toList();
    state = TeamComposition(
      players: players,
      maxCredits: state.maxCredits,
      teamSize: state.teamSize,
    );
  }

  void reset() {
    state = const TeamComposition(
      players: [],
      maxCredits: AppConstants.maxTeamCredits,
      teamSize: AppConstants.teamSize,
    );
  }
}

// Create team action
final createTeamProvider =
    StateNotifierProvider<CreateTeamNotifier, AsyncValue<int?>>((ref) {
  return CreateTeamNotifier(ref);
});

class CreateTeamNotifier extends StateNotifier<AsyncValue<int?>> {
  final Ref _ref;

  CreateTeamNotifier(this._ref) : super(const AsyncData(null));

  Future<bool> create({required int matchId}) async {
    final team = _ref.read(teamBuilderProvider);
    if (!team.isValid) return false;

    state = const AsyncLoading();
    final repo = _ref.read(teamRepositoryProvider);
    final result = await repo.createTeam(
      matchId: matchId,
      playerIds:
          team.selectedPlayers.map((p) => p.matchTeamPlayerId).toList(),
      captainId: team.captain!.matchTeamPlayerId,
      viceCaptainId: team.viceCaptain!.matchTeamPlayerId,
    );
    return result.when(
      success: (teamId) {
        state = AsyncData(teamId);
        return true;
      },
      failure: (e) {
        state = AsyncError(e, StackTrace.current);
        return false;
      },
    );
  }
}
