import 'package:dio/dio.dart';
import '../../../../core/network/api_endpoints.dart';
import '../dto/auth_dto.dart';

class AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSource(this._dio);

  Future<ApiResponse<LoginResponseData>> login(String mobile) async {
    final response = await _dio.post(
      ApiEndpoints.login,
      data: {'mobile': mobile},
    );
    return ApiResponse.fromJson(
      response.data,
      (data) => LoginResponseData.fromJson(data),
    );
  }

  Future<ApiResponse<LoginResponseData>> register(
    String mobile,
    String referredCode,
  ) async {
    final response = await _dio.post(
      ApiEndpoints.register,
      data: {'mobile': mobile, 'referred_code': referredCode},
    );
    return ApiResponse.fromJson(
      response.data,
      (data) => LoginResponseData.fromJson(data),
    );
  }

  Future<ApiResponse<SignInResponseData>> verifyOtp(
    String mobile,
    String otp,
    String deviceId,
    String fcmToken,
    String deviceType,
  ) async {
    final response = await _dio.post(
      ApiEndpoints.verifyOtp,
      data: {
        'mobile': mobile,
        'otp': otp,
        'device_id': deviceId,
        'fcm_token': fcmToken,
        'device_type': deviceType,
      },
    );
    return ApiResponse.fromJson(
      response.data,
      (data) => SignInResponseData.fromJson(data),
    );
  }

  Future<ApiResponse<SignInResponseData>> verifyMobile(
    String mobile,
    String otp,
    String deviceId,
    String fcmToken,
    String deviceType,
  ) async {
    final response = await _dio.post(
      ApiEndpoints.verifyMobile,
      data: {
        'mobile': mobile,
        'otp': otp,
        'device_id': deviceId,
        'fcm_token': fcmToken,
        'device_type': deviceType,
      },
    );
    return ApiResponse.fromJson(
      response.data,
      (data) => SignInResponseData.fromJson(data),
    );
  }

  Future<ApiResponse> resendOtp(String mobile) async {
    final response = await _dio.post(
      ApiEndpoints.resendOtp,
      data: {'mobile': mobile},
    );
    return ApiResponse.fromJson(response.data, null);
  }

  Future<ApiResponse> saveName(String name) async {
    final response = await _dio.post(
      ApiEndpoints.saveName,
      data: {'name': name},
    );
    return ApiResponse.fromJson(response.data, null);
  }

  Future<ApiResponse> removeFcmToken(String fcmToken) async {
    final response = await _dio.post(
      ApiEndpoints.removeFcmToken,
      data: {'fcm_token': fcmToken},
    );
    return ApiResponse.fromJson(response.data, null);
  }
}
