import 'package:dio/dio.dart';
import '../config/app_constants.dart';
import '../storage/secure_storage.dart';
import 'api_endpoints.dart';

class AuthInterceptor extends QueuedInterceptor {
  final SecureStorageService storage;
  final Dio dio;

  AuthInterceptor({required this.storage, required this.dio});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await storage.read(AppConstants.keyAccessToken);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        final newToken = await _refreshToken();
        if (newToken != null) {
          // Retry the original request with new token
          final options = err.requestOptions;
          options.headers['Authorization'] = 'Bearer $newToken';

          final retryDio = Dio(BaseOptions(
            baseUrl: options.baseUrl,
            connectTimeout: AppConstants.apiTimeout,
            receiveTimeout: AppConstants.apiTimeout,
          ));

          final response = await retryDio.fetch(options);
          return handler.resolve(response);
        }
      } catch (_) {
        // Refresh failed — logout
        await _clearTokens();
      }
    }
    handler.next(err);
  }

  Future<String?> _refreshToken() async {
    final accessToken = await storage.read(AppConstants.keyAccessToken);
    final refreshToken = await storage.read(AppConstants.keyRefreshToken);

    if (accessToken == null || refreshToken == null) return null;

    final refreshDio = Dio(BaseOptions(
      baseUrl: dio.options.baseUrl,
      connectTimeout: AppConstants.apiTimeout,
      receiveTimeout: AppConstants.apiTimeout,
    ));

    final response = await refreshDio.post(
      ApiEndpoints.refreshToken,
      data: {
        'access_token': accessToken,
        'refresh_token': refreshToken,
      },
    );

    if (response.statusCode == 200 && response.data['status'] == true) {
      final data = response.data['data'];
      final newAccessToken = data['accessToken'] as String;
      final newRefreshToken = data['refreshToken'] as String;

      await storage.write(AppConstants.keyAccessToken, newAccessToken);
      await storage.write(AppConstants.keyRefreshToken, newRefreshToken);

      return newAccessToken;
    }

    return null;
  }

  Future<void> _clearTokens() async {
    await storage.delete(AppConstants.keyAccessToken);
    await storage.delete(AppConstants.keyRefreshToken);
  }
}
