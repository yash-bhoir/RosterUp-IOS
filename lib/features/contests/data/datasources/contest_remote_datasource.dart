import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
final contestRemoteDatasourceProvider =
    Provider<ContestRemoteDatasource>((ref) {
  return ContestRemoteDatasource(ref.watch(dioProvider));
});

class ContestRemoteDatasource {
  final Dio _dio;

  ContestRemoteDatasource(this._dio);

  Future<Map<String, dynamic>> getMatchDetail(String matchId) async {
    final response = await _dio.get(ApiEndpoints.matchDetail(matchId));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getContestsByMatch(
    String matchId, {
    int page = 1,
    int perPage = 20,
    int? numberOfTeams,
    int? prizePool,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.contestsByMatch(matchId),
      queryParameters: {
        'page': page,
        'per_page': perPage,
        if (numberOfTeams != null) 'number_of_teams': numberOfTeams,
        if (prizePool != null) 'prize_pool': prizePool,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getMyContests(String matchId) async {
    final response = await _dio.get(ApiEndpoints.myContests(matchId));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getContestFilters() async {
    final response = await _dio.get(ApiEndpoints.contestFilters);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> joinContest({
    required int leagueId,
    required int matchId,
    required int userTeamId,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.joinContest,
      data: {
        'league_id': leagueId,
        'match_id': matchId,
        'user_team_id': userTeamId,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getLeaderboard(
    String leagueId, {
    int page = 1,
    int perPage = 20,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.usersLeaderboard(leagueId),
      queryParameters: {'page': page, 'per_page': perPage},
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getWinnings(String leagueId) async {
    final response = await _dio.get(
      ApiEndpoints.contestWinningsById(leagueId),
    );
    return response.data as Map<String, dynamic>;
  }
}
