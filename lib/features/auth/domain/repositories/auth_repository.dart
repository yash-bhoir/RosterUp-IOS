import '../../../../core/errors/result.dart';
import '../entities/auth_token.dart';

abstract class AuthRepository {
  Future<Result<String>> login(String mobile);
  Future<Result<String>> register(String mobile, String referredCode);
  Future<Result<AuthToken>> verifyOtp(
    String mobile,
    String otp,
    String deviceId,
    String fcmToken,
    String deviceType,
  );
  Future<Result<AuthToken>> verifyMobile(
    String mobile,
    String otp,
    String deviceId,
    String fcmToken,
    String deviceType,
  );
  Future<Result<void>> resendOtp(String mobile);
  Future<Result<void>> saveName(String name);
  Future<Result<void>> removeFcmToken(String fcmToken);
  Future<void> logout();
  Future<bool> isLoggedIn();
}
