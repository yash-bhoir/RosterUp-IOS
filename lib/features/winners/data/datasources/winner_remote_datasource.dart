import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';

final winnerRemoteDatasourceProvider =
    Provider<WinnerRemoteDatasource>((ref) {
  return WinnerRemoteDatasource(ref.watch(dioProvider));
});

class WinnerRemoteDatasource {
  final Dio _dio;

  WinnerRemoteDatasource(this._dio);

  Future<Map<String, dynamic>> getContestWinners({
    int page = 1,
    int perPage = 20,
    String? sportKey,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.contestWinners,
      queryParameters: {
        'page': page,
        'per_page': perPage,
        if (sportKey != null) 'sport_key': sportKey,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getMegaContestWinners({
    int page = 1,
    int perPage = 20,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.megaContestWinners,
      queryParameters: {'page': page, 'per_page': perPage},
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getWinnerFilters() async {
    final response = await _dio.get(ApiEndpoints.winnerFilters);
    return response.data as Map<String, dynamic>;
  }
}
