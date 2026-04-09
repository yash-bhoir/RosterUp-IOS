import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/app_constants.dart';
import '../config/env.dart';
import 'auth_interceptor.dart';
import '../storage/secure_storage.dart';

final envProvider = Provider<Env>((ref) => Env.fromDefines());

final dioProvider = Provider<Dio>((ref) {
  final env = ref.watch(envProvider);
  final storage = ref.watch(secureStorageProvider);

  final dio = Dio(BaseOptions(
    baseUrl: env.baseUrl,
    connectTimeout: AppConstants.apiTimeout,
    receiveTimeout: AppConstants.apiTimeout,
    sendTimeout: AppConstants.apiTimeout,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  dio.interceptors.addAll([
    AuthInterceptor(storage: storage, dio: dio),
    LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
    ),
  ]);

  return dio;
});
