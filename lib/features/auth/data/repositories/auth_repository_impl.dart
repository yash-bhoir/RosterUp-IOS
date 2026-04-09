import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/app_constants.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../core/storage/preferences.dart';
import '../../domain/entities/auth_token.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

final authDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource(ref.watch(dioProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remote: ref.watch(authDataSourceProvider),
    storage: ref.watch(secureStorageProvider),
    prefs: ref.watch(sharedPrefsProvider),
  );
});

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;
  final SecureStorageService storage;
  final SharedPreferencesService prefs;

  AuthRepositoryImpl({
    required this.remote,
    required this.storage,
    required this.prefs,
  });

  @override
  Future<Result<String>> login(String mobile) async {
    try {
      final response = await remote.login(mobile);
      if (response.status && response.data != null) {
        return Result.success(response.data!.otp);
      }
      return Result.failure(ServerFailure(response.message));
    } catch (e) {
      return Result.failure(NetworkFailure.fromException(e));
    }
  }

  @override
  Future<Result<String>> register(String mobile, String referredCode) async {
    try {
      final response = await remote.register(mobile, referredCode);
      if (response.status && response.data != null) {
        return Result.success(response.data!.otp);
      }
      return Result.failure(ServerFailure(response.message));
    } catch (e) {
      return Result.failure(NetworkFailure.fromException(e));
    }
  }

  @override
  Future<Result<AuthToken>> verifyOtp(
    String mobile,
    String otp,
    String deviceId,
    String fcmToken,
    String deviceType,
  ) async {
    try {
      final response = await remote.verifyOtp(
        mobile, otp, deviceId, fcmToken, deviceType,
      );
      if (response.status && response.data != null) {
        final token = AuthToken(
          accessToken: response.data!.accessToken,
          refreshToken: response.data!.refreshToken,
        );
        await _saveTokens(token);
        return Result.success(token);
      }
      return Result.failure(ServerFailure(response.message));
    } catch (e) {
      return Result.failure(NetworkFailure.fromException(e));
    }
  }

  @override
  Future<Result<AuthToken>> verifyMobile(
    String mobile,
    String otp,
    String deviceId,
    String fcmToken,
    String deviceType,
  ) async {
    try {
      final response = await remote.verifyMobile(
        mobile, otp, deviceId, fcmToken, deviceType,
      );
      if (response.status && response.data != null) {
        final token = AuthToken(
          accessToken: response.data!.accessToken,
          refreshToken: response.data!.refreshToken,
        );
        await _saveTokens(token);
        return Result.success(token);
      }
      return Result.failure(ServerFailure(response.message));
    } catch (e) {
      return Result.failure(NetworkFailure.fromException(e));
    }
  }

  @override
  Future<Result<void>> resendOtp(String mobile) async {
    try {
      final response = await remote.resendOtp(mobile);
      if (response.status) return Result.success(null);
      return Result.failure(ServerFailure(response.message));
    } catch (e) {
      return Result.failure(NetworkFailure.fromException(e));
    }
  }

  @override
  Future<Result<void>> saveName(String name) async {
    try {
      final response = await remote.saveName(name);
      if (response.status) return Result.success(null);
      return Result.failure(ServerFailure(response.message));
    } catch (e) {
      return Result.failure(NetworkFailure.fromException(e));
    }
  }

  @override
  Future<Result<void>> removeFcmToken(String fcmToken) async {
    try {
      final response = await remote.removeFcmToken(fcmToken);
      if (response.status) return Result.success(null);
      return Result.failure(ServerFailure(response.message));
    } catch (e) {
      return Result.failure(NetworkFailure.fromException(e));
    }
  }

  @override
  Future<void> logout() async {
    final referredCode = await storage.read(AppConstants.keyReferredCode);
    await storage.deleteAll();
    await prefs.setBool(AppConstants.keyIsLogin, false);
    await prefs.setBool(AppConstants.keyIsSliderShown, true);
    if (referredCode != null) {
      await storage.write(AppConstants.keyReferredCode, referredCode);
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return prefs.getBool(AppConstants.keyIsLogin);
  }

  Future<void> _saveTokens(AuthToken token) async {
    await storage.write(AppConstants.keyAccessToken, token.accessToken);
    await storage.write(AppConstants.keyRefreshToken, token.refreshToken);
    await prefs.setBool(AppConstants.keyIsLogin, true);
  }
}
