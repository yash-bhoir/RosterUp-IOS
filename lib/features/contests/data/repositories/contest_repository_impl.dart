import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/result.dart';
import '../../domain/entities/contest.dart';
import '../../domain/entities/match_detail.dart';
import '../../domain/repositories/contest_repository.dart';
import '../datasources/contest_remote_datasource.dart';
import '../dto/contest_dto.dart';

final contestRepositoryProvider = Provider<ContestRepository>((ref) {
  return ContestRepositoryImpl(ref.watch(contestRemoteDatasourceProvider));
});

class ContestRepositoryImpl implements ContestRepository {
  final ContestRemoteDatasource _remote;

  ContestRepositoryImpl(this._remote);

  @override
  Future<Result<MatchDetail>> getMatchDetail(String matchId) async {
    try {
      final json = await _remote.getMatchDetail(matchId);
      final data = json['data'] as Map<String, dynamic>? ?? {};
      return Result.success(MatchDetailDto.fromJson(data).toEntity());
    } on DioException catch (e) {
      return Result.failure(_mapDioError(e));
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<PaginatedContests>> getContestsByMatch(
    String matchId, {
    int page = 1,
    int perPage = 20,
    int? numberOfTeams,
    int? prizePool,
  }) async {
    try {
      final json = await _remote.getContestsByMatch(
        matchId,
        page: page,
        perPage: perPage,
        numberOfTeams: numberOfTeams,
        prizePool: prizePool,
      );
      final data = json['data'] as Map<String, dynamic>? ?? {};
      final items = (data['data'] as List<dynamic>?)
              ?.map((e) => ContestDto.fromJson(e as Map<String, dynamic>)
                  .toEntity())
              .toList() ??
          [];
      return Result.success(PaginatedContests(
        contests: items,
        page: data['page'] ?? 1,
        totalPages: data['total_pages'] ?? 1,
      ));
    } on DioException catch (e) {
      return Result.failure(_mapDioError(e));
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<MyContest>>> getMyContests(String matchId) async {
    try {
      final json = await _remote.getMyContests(matchId);
      final data = json['data'] as List<dynamic>? ?? [];
      final items = data.where((e) => e != null).map((e) {
        final map = e as Map<String, dynamic>;
        final leagueJson = map['league'] as Map<String, dynamic>? ?? {};
        final teamsJson = map['teams'] as List<dynamic>? ?? [];
        return MyContest(
          league: ContestDto.fromJson(leagueJson).toEntity(),
          teams: teamsJson
              .map((t) =>
                  UserTeamDto.fromJson(t as Map<String, dynamic>).toEntity())
              .toList(),
        );
      }).toList();
      return Result.success(items);
    } on DioException catch (e) {
      return Result.failure(_mapDioError(e));
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<ContestFilter>> getContestFilters() async {
    try {
      final json = await _remote.getContestFilters();
      final data = json['data'] as Map<String, dynamic>? ?? {};
      return Result.success(ContestFilter(
        teamCounts: (data['number_of_teams'] as List<dynamic>?)
                ?.map((e) => (e as num).toInt())
                .toList() ??
            [],
        prizePools: (data['prize_pool'] as List<dynamic>?)
                ?.map((e) => (e as num).toInt())
                .toList() ??
            [],
      ));
    } on DioException catch (e) {
      return Result.failure(_mapDioError(e));
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> joinContest({
    required int leagueId,
    required int matchId,
    required int userTeamId,
  }) async {
    try {
      final json = await _remote.joinContest(
        leagueId: leagueId,
        matchId: matchId,
        userTeamId: userTeamId,
      );
      if (json['status'] == true) {
        return Result.success(null);
      }
      return Result.failure(
          ServerFailure(json['message']?.toString() ?? 'Failed to join'));
    } on DioException catch (e) {
      return Result.failure(_mapDioError(e));
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<LeaderboardEntry>>> getLeaderboard(
    String leagueId, {
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final json =
          await _remote.getLeaderboard(leagueId, page: page, perPage: perPage);
      final data = json['data'];
      List<dynamic> items = [];
      if (data is Map<String, dynamic>) {
        items = data['data'] as List<dynamic>? ?? [];
      } else if (data is List) {
        items = data;
      }
      return Result.success(items
          .map((e) =>
              LeaderboardEntryDto.fromJson(e as Map<String, dynamic>)
                  .toEntity())
          .toList());
    } on DioException catch (e) {
      return Result.failure(_mapDioError(e));
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<WinningSlot>>> getWinnings(String leagueId) async {
    try {
      final json = await _remote.getWinnings(leagueId);
      final data = json['data'] as List<dynamic>? ?? [];
      return Result.success(data
          .map((e) =>
              WinningSlotDto.fromJson(e as Map<String, dynamic>).toEntity())
          .toList());
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
