import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/result.dart';
import '../../domain/entities/player.dart';
import '../datasources/team_remote_datasource.dart';
import '../dto/player_dto.dart';

final teamRepositoryProvider = Provider<TeamRepository>((ref) {
  return TeamRepository(ref.watch(teamRemoteDatasourceProvider));
});

class TeamRepository {
  final TeamRemoteDatasource _remote;

  TeamRepository(this._remote);

  Future<Result<List<Player>>> getMatchPlayers(String matchId) async {
    try {
      final json = await _remote.getMatchPlayers(matchId);
      final data = json['data'] as List<dynamic>? ?? [];
      final allPlayers = <Player>[];
      for (final teamJson in data) {
        final teamDto =
            MatchTeamPlayersDto.fromJson(teamJson as Map<String, dynamic>);
        for (final playerDto in teamDto.players) {
          allPlayers.add(playerDto.toEntity().copyWith());
        }
      }
      return Result.success(allPlayers);
    } on DioException catch (e) {
      return Result.failure(_mapDioError(e));
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  Future<Result<int>> createTeam({
    required int matchId,
    required List<int> playerIds,
    required int captainId,
    required int viceCaptainId,
  }) async {
    try {
      final json = await _remote.createTeam(
        matchId: matchId,
        playerIds: playerIds,
        captainId: captainId,
        viceCaptainId: viceCaptainId,
      );
      if (json['status'] == true) {
        final userTeamId = json['data']?['user_team_id'] ?? 0;
        return Result.success(userTeamId as int);
      }
      return Result.failure(
          ServerFailure(json['message']?.toString() ?? 'Failed'));
    } on DioException catch (e) {
      return Result.failure(_mapDioError(e));
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  Future<Result<void>> updateTeam({
    required int userTeamId,
    required int matchId,
    required List<int> playerIds,
    required int captainId,
    required int viceCaptainId,
  }) async {
    try {
      final json = await _remote.updateTeam(
        userTeamId: userTeamId,
        matchId: matchId,
        playerIds: playerIds,
        captainId: captainId,
        viceCaptainId: viceCaptainId,
      );
      if (json['status'] == true) return Result.success(null);
      return Result.failure(
          ServerFailure(json['message']?.toString() ?? 'Failed'));
    } on DioException catch (e) {
      return Result.failure(_mapDioError(e));
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  AppFailure _mapDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return const NetworkFailure('Connection timed out');
    }
    if (e.type == DioExceptionType.connectionError) {
      return const NetworkFailure();
    }
    final statusCode = e.response?.statusCode;
    if (statusCode == 401) return const AuthFailure();
    final message =
        e.response?.data?['message']?.toString() ?? 'Something went wrong';
    return ServerFailure(message, statusCode: statusCode);
  }
}
