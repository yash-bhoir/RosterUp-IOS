import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';

final profileRemoteDatasourceProvider =
    Provider<ProfileRemoteDatasource>((ref) {
  return ProfileRemoteDatasource(ref.watch(dioProvider));
});

class ProfileRemoteDatasource {
  final Dio _dio;

  ProfileRemoteDatasource(this._dio);

  Future<Map<String, dynamic>> getProfile() async {
    final response = await _dio.get(ApiEndpoints.getProfile);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getAccountStats() async {
    final response = await _dio.get(ApiEndpoints.accountStats);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateProfile({
    String? email,
    String? state,
    String? dateOfBirth,
    String? gender,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.updateProfile,
      data: {
        if (email != null) 'email': email,
        if (state != null) 'state': state,
        if (dateOfBirth != null) 'date_of_birth': dateOfBirth,
        if (gender != null) 'gender': gender,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> deleteAccount() async {
    final response = await _dio.post(ApiEndpoints.deleteAccount);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getRecentlyPlayed({
    required String userId,
    int page = 1,
    int perPage = 10,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.recentlyPlayed,
      queryParameters: {
        'user_id': userId,
        'page': page,
        'per_page': perPage,
      },
    );
    return response.data as Map<String, dynamic>;
  }
}
