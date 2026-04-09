import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';

final teamRemoteDatasourceProvider = Provider<TeamRemoteDatasource>((ref) {
  return TeamRemoteDatasource(ref.watch(dioProvider));
});

class TeamRemoteDatasource {
  final Dio _dio;

  TeamRemoteDatasource(this._dio);

  Future<Map<String, dynamic>> getMatchPlayers(String matchId) async {
    final response = await _dio.get(ApiEndpoints.matchPlayers(matchId));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createTeam({
    required int matchId,
    required List<int> playerIds,
    required int captainId,
    required int viceCaptainId,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.createTeam,
      data: {
        'match_id': matchId,
        'players': playerIds,
        'captain': captainId,
        'voice_captain': viceCaptainId,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateTeam({
    required int userTeamId,
    required int matchId,
    required List<int> playerIds,
    required int captainId,
    required int viceCaptainId,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.updateTeam,
      data: {
        'user_team_id': userTeamId,
        'match_id': matchId,
        'players': playerIds,
        'captain': captainId,
        'voice_captain': viceCaptainId,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getUserTeams(String matchId) async {
    final response = await _dio.get(ApiEndpoints.userTeams(matchId));
    return response.data as Map<String, dynamic>;
  }
}
