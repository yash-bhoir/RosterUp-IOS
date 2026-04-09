abstract final class AppConstants {
  static const appName = 'RosterUp';
  static const packageName = 'com.aadil.rosterup';

  // SharedPreferences keys
  static const keyIsLogin = 'IS_LOGIN';
  static const keyIsSliderShown = 'IS_SLIDER_SHOWN';
  static const keyAccessToken = 'ACCESS_TOKEN';
  static const keyRefreshToken = 'REFRESH_TOKEN';
  static const keyFcmToken = 'FCM_TOKEN';
  static const keyDeviceId = 'UNIQUE_DEVICE_ID';
  static const keyReferredCode = 'REFERRED_CODE';

  // Sports keys
  static const sportsBgmi = 'bgmi';
  static const sportsPubg = 'pubg';
  static const sportsCsgo = 'csgo';
  static const sportsValo = 'valo';

  // Timeouts
  static const apiTimeout = Duration(seconds: 120);
  static const matchPollInterval = Duration(seconds: 25);

  // Team rules
  static const maxTeamCredits = 100;
  static const teamSize = 5;
  static const captainMultiplier = 2.0;
  static const viceCaptainMultiplier = 1.5;

  // Validation
  static const phoneLength = 10;
  static const otpLength = 6;
}
