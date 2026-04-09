import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../dto/match_dto.dart';

final matchRemoteDatasourceProvider = Provider<MatchRemoteDatasource>((ref) {
  return MatchRemoteDatasource(ref.watch(dioProvider));
});

class MatchRemoteDatasource {
  final Dio _dio;

  MatchRemoteDatasource(this._dio);

  Future<MatchesListResponseDto> getLiveMatches({String? sportKey}) async {
    final response = await _dio.get(
      ApiEndpoints.liveMatches,
      queryParameters: {
        if (sportKey != null) 'sport_key': sportKey,
      },
    );
    return MatchesListResponseDto.fromJson(response.data);
  }

  Future<MatchesListResponseDto> getMyUpcomingMatches({
    String? sportKey,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.myUpcomingMatches,
      queryParameters: {
        if (sportKey != null) 'sport_key': sportKey,
      },
    );
    return MatchesListResponseDto.fromJson(response.data);
  }

  Future<MatchesPagingResponseDto> getUpcomingMatches({
    int page = 1,
    int perPage = 20,
    String? sportKey,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.upcomingMatches,
      queryParameters: {
        'page': page,
        'per_page': perPage,
        if (sportKey != null) 'sport_key': sportKey,
      },
    );
    return MatchesPagingResponseDto.fromJson(response.data);
  }

  Future<MatchesPagingResponseDto> getCompletedMatches({
    int page = 1,
    int perPage = 20,
    String? sportKey,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.completedMatches,
      queryParameters: {
        'page': page,
        'per_page': perPage,
        if (sportKey != null) 'sport_key': sportKey,
      },
    );
    return MatchesPagingResponseDto.fromJson(response.data);
  }
}
