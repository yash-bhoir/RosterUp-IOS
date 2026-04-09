import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/result.dart';
import '../../domain/entities/match.dart';
import '../../domain/repositories/match_repository.dart';
import '../datasources/match_remote_datasource.dart';

final matchRepositoryProvider = Provider<MatchRepository>((ref) {
  return MatchRepositoryImpl(ref.watch(matchRemoteDatasourceProvider));
});

class MatchRepositoryImpl implements MatchRepository {
  final MatchRemoteDatasource _remote;

  MatchRepositoryImpl(this._remote);

  @override
  Future<Result<List<Match>>> getLiveMatches({String? sportKey}) async {
    try {
      final dto = await _remote.getLiveMatches(sportKey: sportKey);
      return Result.success(dto.matches.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      return Result.failure(_mapDioError(e));
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<Match>>> getMyUpcomingMatches({String? sportKey}) async {
    try {
      final dto = await _remote.getMyUpcomingMatches(sportKey: sportKey);
      return Result.success(dto.matches.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      return Result.failure(_mapDioError(e));
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<PaginatedMatches>> getUpcomingMatches({
    int page = 1,
    int perPage = 20,
    String? sportKey,
  }) async {
    try {
      final dto = await _remote.getUpcomingMatches(
        page: page,
        perPage: perPage,
        sportKey: sportKey,
      );
      return Result.success(dto.toEntity());
    } on DioException catch (e) {
      return Result.failure(_mapDioError(e));
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<PaginatedMatches>> getCompletedMatches({
    int page = 1,
    int perPage = 20,
    String? sportKey,
  }) async {
    try {
      final dto = await _remote.getCompletedMatches(
        page: page,
        perPage: perPage,
        sportKey: sportKey,
      );
      return Result.success(dto.toEntity());
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
