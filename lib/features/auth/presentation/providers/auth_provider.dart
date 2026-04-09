import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/app_constants.dart';
import '../../../../core/storage/preferences.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';

// Auth state
final isLoggedInProvider = FutureProvider<bool>((ref) async {
  final repo = ref.watch(authRepositoryProvider);
  return repo.isLoggedIn();
});

final isSliderShownProvider = Provider<bool>((ref) {
  final prefs = ref.watch(sharedPrefsProvider);
  return prefs.getBool(AppConstants.keyIsSliderShown);
});

// Login
final loginStateProvider =
    StateNotifierProvider<LoginNotifier, AsyncValue<String?>>((ref) {
  return LoginNotifier(ref.watch(authRepositoryProvider));
});

class LoginNotifier extends StateNotifier<AsyncValue<String?>> {
  final AuthRepository _repo;
  LoginNotifier(this._repo) : super(const AsyncData(null));

  Future<void> login(String mobile) async {
    state = const AsyncLoading();
    final result = await _repo.login(mobile);
    state = result.when(
      success: (otp) => AsyncData(otp),
      failure: (e) => AsyncError(e, StackTrace.current),
    );
  }

  void reset() => state = const AsyncData(null);
}

// Register
final registerStateProvider =
    StateNotifierProvider<RegisterNotifier, AsyncValue<String?>>((ref) {
  return RegisterNotifier(ref.watch(authRepositoryProvider));
});

class RegisterNotifier extends StateNotifier<AsyncValue<String?>> {
  final AuthRepository _repo;
  RegisterNotifier(this._repo) : super(const AsyncData(null));

  Future<void> register(String mobile, String referredCode) async {
    state = const AsyncLoading();
    final result = await _repo.register(mobile, referredCode);
    state = result.when(
      success: (otp) => AsyncData(otp),
      failure: (e) => AsyncError(e, StackTrace.current),
    );
  }

  void reset() => state = const AsyncData(null);
}

// OTP Verification
final otpStateProvider =
    StateNotifierProvider<OtpNotifier, AsyncValue<bool>>((ref) {
  return OtpNotifier(ref.watch(authRepositoryProvider));
});

class OtpNotifier extends StateNotifier<AsyncValue<bool>> {
  final AuthRepository _repo;
  OtpNotifier(this._repo) : super(const AsyncData(false));

  Future<void> verifyOtp(
    String mobile,
    String otp,
    String deviceId,
    String fcmToken,
  ) async {
    state = const AsyncLoading();
    final result = await _repo.verifyOtp(
      mobile, otp, deviceId, fcmToken, 'ANDROID',
    );
    state = result.when(
      success: (_) => const AsyncData(true),
      failure: (e) => AsyncError(e, StackTrace.current),
    );
  }

  Future<void> verifyMobile(
    String mobile,
    String otp,
    String deviceId,
    String fcmToken,
  ) async {
    state = const AsyncLoading();
    final result = await _repo.verifyMobile(
      mobile, otp, deviceId, fcmToken, 'ANDROID',
    );
    state = result.when(
      success: (_) => const AsyncData(true),
      failure: (e) => AsyncError(e, StackTrace.current),
    );
  }

  Future<void> resendOtp(String mobile) async {
    await _repo.resendOtp(mobile);
  }

  void reset() => state = const AsyncData(false);
}

// Save Name
final saveNameStateProvider =
    StateNotifierProvider<SaveNameNotifier, AsyncValue<bool>>((ref) {
  return SaveNameNotifier(ref.watch(authRepositoryProvider));
});

class SaveNameNotifier extends StateNotifier<AsyncValue<bool>> {
  final AuthRepository _repo;
  SaveNameNotifier(this._repo) : super(const AsyncData(false));

  Future<void> saveName(String name) async {
    state = const AsyncLoading();
    final result = await _repo.saveName(name);
    state = result.when(
      success: (_) => const AsyncData(true),
      failure: (e) => AsyncError(e, StackTrace.current),
    );
  }
}
