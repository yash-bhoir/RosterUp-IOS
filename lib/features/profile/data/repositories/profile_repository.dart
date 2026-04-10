import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/result.dart';
import '../../domain/entities/profile.dart';
import '../datasources/profile_remote_datasource.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(ref.watch(profileRemoteDatasourceProvider));
});

class ProfileRepository {
  final ProfileRemoteDatasource _remote;

  ProfileRepository(this._remote);

  Future<Result<UserProfile>> getProfile() async {
    try {
      final json = await _remote.getProfile();
      final data = json['data'] as Map<String, dynamic>? ?? {};
      return Result.success(UserProfile(
        userId: data['user_id'] ?? 0,
        userName: data['user_name'] ?? '',
        email: data['email'] ?? '',
        mobile: data['mobile'] ?? '',
        profilePic: data['profile_pic'] ?? '',
        referralCode: data['referral_code'] ?? '',
        state: data['state'] ?? '',
        dateOfBirth: data['date_of_birth'] ?? '',
        gender: data['gender'] ?? '',
      ));
    } on DioException catch (e) {
      return Result.failure(_mapDioError(e));
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  Future<Result<AccountStats>> getAccountStats() async {
    try {
      final json = await _remote.getAccountStats();
      final data = json['data'] as Map<String, dynamic>? ?? {};
      return Result.success(AccountStats(
        totalMatches: data['total_matches'] ?? 0,
        totalContests: data['total_contests'] ?? 0,
        totalWins: data['total_wins'] ?? 0,
        totalWinnings: (data['total_winnings'] ?? 0).toDouble(),
      ));
    } on DioException catch (e) {
      return Result.failure(_mapDioError(e));
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  Future<Result<void>> updateProfile({
    String? email,
    String? state,
    String? dateOfBirth,
    String? gender,
  }) async {
    try {
      final json = await _remote.updateProfile(
        email: email,
        state: state,
        dateOfBirth: dateOfBirth,
        gender: gender,
      );
      if (json['status'] == true) return Result.success(null);
      return Result.failure(
          ServerFailure(json['message']?.toString() ?? 'Failed'));
    } on DioException catch (e) {
      return Result.failure(_mapDioError(e));
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  Future<Result<void>> deleteAccount() async {
    try {
      final json = await _remote.deleteAccount();
      if (json['status'] == true) return Result.success(null);
      return Result.failure(
          ServerFailure(json['message']?.toString() ?? 'Failed'));
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
