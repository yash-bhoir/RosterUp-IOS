import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';

final walletRemoteDatasourceProvider =
    Provider<WalletRemoteDatasource>((ref) {
  return WalletRemoteDatasource(ref.watch(dioProvider));
});

class WalletRemoteDatasource {
  final Dio _dio;

  WalletRemoteDatasource(this._dio);

  Future<Map<String, dynamic>> getBalance() async {
    final response = await _dio.get(ApiEndpoints.getBalance);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getContestTransactions({
    int page = 1,
    int perPage = 20,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.contestTransactions,
      queryParameters: {'page': page, 'per_page': perPage},
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getOtherTransactions({
    int page = 1,
    int perPage = 20,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.otherTransactions,
      queryParameters: {'page': page, 'per_page': perPage},
    );
    return response.data as Map<String, dynamic>;
  }
}
