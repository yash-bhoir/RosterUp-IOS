# Architecture - RosterUp Flutter

## Tech Stack

| Layer | Choice | Why |
|-------|--------|-----|
| State Management | Riverpod 2.x + code-gen | Compile-safe, testable, no context dependency |
| Routing | go_router + typed routes | Declarative, deep link support, redirect guards |
| Networking | Dio + Retrofit | Interceptors for auth/logging/error, code-gen for API |
| Local Storage | flutter_secure_storage | Tokens (encrypted), shared_preferences for flags |
| DI | Riverpod providers | No separate DI container needed |
| Error Handling | sealed Result<T, Failure> | No raw exceptions in UI layer |
| Logging | talker_flutter | Dev overlay, Dio interceptor included |
| Image Loading | cached_network_image | Equivalent to Glide |
| Env Config | --dart-define | dev/staging/prod flavors |

## Folder Structure

```
lib/
  core/
    config/           # Environment, app constants
      env.dart
      app_constants.dart
    errors/           # Failure types, result type
      failures.dart
      result.dart
    network/          # Dio setup, interceptors, API client
      api_client.dart
      auth_interceptor.dart
      vpn_interceptor.dart
      api_endpoints.dart
    storage/          # Secure storage, preferences
      secure_storage.dart
      preferences.dart
    router/           # go_router config, guards
      app_router.dart
      auth_guard.dart
    theme/            # Design system
      app_colors.dart
      app_typography.dart
      app_spacing.dart
      app_theme.dart
    widgets/          # Shared reusable widgets
      app_button.dart
      app_input.dart
      app_card.dart
      app_bar.dart
      loading_indicator.dart
      error_widget.dart
      empty_widget.dart

  features/
    auth/
      data/
        dto/          # LoginRequest, OtpResponse, etc.
        datasources/  # AuthRemoteDataSource
        repositories/ # AuthRepositoryImpl
      domain/
        entities/     # User, AuthToken
        repositories/ # AuthRepository (abstract)
        usecases/     # Login, VerifyOtp, RefreshToken
      presentation/
        screens/      # SplashScreen, LoginScreen, OtpScreen, etc.
        widgets/      # OtpInput, PhoneInput
        providers/    # authProvider, loginProvider

    home/
      data/
      domain/
      presentation/
        screens/      # HomeShell (with bottom nav)
        widgets/      # BannerCarousel, MatchCard

    matches/
      data/
      domain/
      presentation/
        screens/      # LiveMatches, UpcomingMatches, CompletedMatches
        widgets/      # MatchCard, CountdownTimer
        providers/

    contests/
      data/
      domain/
      presentation/
        screens/      # JoinContest, ContestDetail, AllContests
        widgets/      # ContestCard, LeaderboardRow
        providers/

    teams/
      data/
      domain/
      presentation/
        screens/      # CreateTeam, ChooseCaptain, TeamPreview
        widgets/      # TeamCard, CreditCounter, PlayerCard
        providers/

    profile/
      data/
      domain/
      presentation/
        screens/      # ProfileMenu, EditProfile, OtherProfile
        widgets/
        providers/

    wallet/
      data/
      domain/
      presentation/
        screens/      # Balance, Transactions
        widgets/      # BalanceCard, TransactionItem
        providers/

    rewards/
      data/
      domain/
      presentation/
        screens/      # RewardCategories, CouponDetail, MyRewards
        widgets/      # CouponCard, CategoryCard
        providers/

    winners/
      data/
      domain/
      presentation/
        screens/      # Winners, WinnerDetails
        widgets/
        providers/

    support/
      presentation/
        screens/      # Support, ReferEarn
        widgets/

    settings/
      presentation/
        screens/      # DeleteAccount, SuspendAccount

  app.dart            # MaterialApp.router setup
  main_dev.dart       # Dev entry (staging API)
  main_staging.dart   # Staging entry
  main_prod.dart      # Production entry
```

## Sample Feature End-to-End: Auth

### 1. Domain Layer

```dart
// lib/features/auth/domain/entities/auth_token.dart
class AuthToken {
  final String accessToken;
  final String refreshToken;
  const AuthToken({required this.accessToken, required this.refreshToken});
}

// lib/features/auth/domain/repositories/auth_repository.dart
abstract class AuthRepository {
  Future<Result<String, Failure>> login(String mobile);
  Future<Result<AuthToken, Failure>> verifyOtp(String mobile, String otp, String deviceId, String fcmToken);
  Future<Result<AuthToken, Failure>> refreshToken(String accessToken, String refreshToken);
  Future<Result<void, Failure>> logout();
}
```

### 2. Data Layer

```dart
// lib/features/auth/data/dto/login_request.dart
class LoginRequest {
  final String mobile;
  LoginRequest({required this.mobile});
  Map<String, dynamic> toJson() => {'mobile': mobile};
}

// lib/features/auth/data/dto/login_response.dart
class LoginResponse {
  final bool status;
  final int statusCode;
  final String message;
  final LoginData? data;
  // fromJson...
}

// lib/features/auth/data/datasources/auth_remote_datasource.dart
class AuthRemoteDataSource {
  final Dio _dio;
  AuthRemoteDataSource(this._dio);

  Future<LoginResponse> login(LoginRequest request) async {
    final response = await _dio.post(ApiEndpoints.login, data: request.toJson());
    return LoginResponse.fromJson(response.data);
  }
}

// lib/features/auth/data/repositories/auth_repository_impl.dart
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remote;
  final SecureStorageService _storage;

  @override
  Future<Result<String, Failure>> login(String mobile) async {
    try {
      final response = await _remote.login(LoginRequest(mobile: mobile));
      if (response.status) return Result.success(response.data!.otp);
      return Result.failure(ServerFailure(response.message));
    } catch (e) {
      return Result.failure(NetworkFailure.fromException(e));
    }
  }
}
```

### 3. Presentation Layer

```dart
// lib/features/auth/presentation/providers/auth_provider.dart
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<void> login(String mobile) async {
    state = const AsyncLoading();
    final repo = ref.read(authRepositoryProvider);
    final result = await repo.login(mobile);
    state = result.when(
      success: (_) => const AsyncData(null),
      failure: (f) => AsyncError(f, StackTrace.current),
    );
  }
}

// lib/features/auth/presentation/screens/login_screen.dart
class LoginScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    // Build UI, listen for state changes, navigate on success
  }
}
```

### 4. Routing

```dart
// lib/core/router/app_router.dart
GoRouter appRouter(Ref ref) => GoRouter(
  initialLocation: '/splash',
  redirect: (context, state) {
    final isLoggedIn = ref.read(isLoggedInProvider);
    if (state.matchedLocation == '/splash') return null;
    if (!isLoggedIn && !state.matchedLocation.startsWith('/auth')) return '/auth/login';
    return null;
  },
  routes: [
    GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
    GoRoute(path: '/auth/login', builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/auth/otp', builder: (_, __) => const OtpScreen()),
    StatefulShellRoute.indexedStack(
      builder: (_, __, shell) => HomeShell(navigationShell: shell),
      branches: [
        StatefulShellBranch(routes: [GoRoute(path: '/home', ...)]),
        StatefulShellBranch(routes: [GoRoute(path: '/matches', ...)]),
        StatefulShellBranch(routes: [GoRoute(path: '/rewards', ...)]),
        StatefulShellBranch(routes: [GoRoute(path: '/chat', ...)]),
        StatefulShellBranch(routes: [GoRoute(path: '/winners', ...)]),
      ],
    ),
  ],
);
```

## Network Architecture

### Dio Setup
```dart
Dio createDio(Env env, SecureStorageService storage) {
  final dio = Dio(BaseOptions(
    baseUrl: env.baseUrl,
    connectTimeout: Duration(seconds: 120),
    receiveTimeout: Duration(seconds: 120),
    sendTimeout: Duration(seconds: 120),
  ));

  dio.interceptors.addAll([
    AuthInterceptor(storage, dio),  // Injects Bearer token, handles 401 refresh
    VpnInterceptor(),               // Blocks VPN connections
    TalkerDioLogger(talker),        // Request/response logging
  ]);

  return dio;
}
```

### Auth Interceptor (matches Android NetworkConnectionInterceptor)
```dart
class AuthInterceptor extends QueuedInterceptor {
  // onRequest: Adds Authorization header
  // onError: On 401, calls /auth/referesh-token, retries request
  // Throws RefreshFailure if refresh fails
}
```

## Environment Config

```dart
// lib/core/config/env.dart
class Env {
  final String baseUrl;
  final String name;

  static Env fromDefines() {
    const env = String.fromEnvironment('ENV', defaultValue: 'staging');
    switch (env) {
      case 'prod': return Env._(baseUrl: 'https://rosterup.in/', name: 'prod');
      case 'staging':
      default: return Env._(baseUrl: 'http://staging.rosterup.in/', name: 'staging');
    }
  }
}
```

Run commands:
```bash
# Staging
flutter run --dart-define=ENV=staging

# Production
flutter run --dart-define=ENV=prod
```

## Error Handling

```dart
// Sealed result type — no raw exceptions reach UI
sealed class Result<T, E> {
  const Result();
  factory Result.success(T data) = Success<T, E>;
  factory Result.failure(E error) = Failure<T, E>;

  R when<R>({
    required R Function(T data) success,
    required R Function(E error) failure,
  });
}

// Failure types
sealed class AppFailure {
  final String message;
  const AppFailure(this.message);
}
class ServerFailure extends AppFailure { ... }
class NetworkFailure extends AppFailure { ... }
class CacheFailure extends AppFailure { ... }
class ValidationFailure extends AppFailure { ... }
```

## Key Packages

```yaml
dependencies:
  flutter:
    sdk: flutter

  # State Management
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5

  # Routing
  go_router: ^14.2.0

  # Networking
  dio: ^5.4.3
  retrofit: ^4.1.0
  json_annotation: ^4.9.0

  # Storage
  flutter_secure_storage: ^9.2.2
  shared_preferences: ^2.2.3

  # UI
  cached_network_image: ^3.3.1
  smooth_page_indicator: ^1.1.0
  pin_code_fields: ^8.0.1
  shimmer: ^3.0.0
  flutter_svg: ^2.0.10

  # Firebase
  firebase_core: ^3.1.0
  firebase_messaging: ^15.0.0
  firebase_database: ^11.0.0

  # Utils
  url_launcher: ^6.2.6
  share_plus: ^9.0.0
  image_picker: ^1.1.2
  connectivity_plus: ^6.0.3
  talker_flutter: ^4.1.4
  google_mobile_ads: ^5.1.0
  infinite_scroll_pagination: ^4.0.0
  intl: ^0.19.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  riverpod_generator: ^2.4.0
  build_runner: ^2.4.9
  json_serializable: ^6.8.0
  retrofit_generator: ^8.1.0
  flutter_lints: ^4.0.0
  golden_toolkit: ^0.15.0
  mocktail: ^1.0.3
```

## Testing Strategy

| Layer | Tool | What |
|-------|------|------|
| Domain (Use Cases) | `flutter_test` + `mocktail` | Business logic, validation rules |
| Data (Repositories) | `flutter_test` + `mocktail` | API contract, error mapping |
| Presentation (Providers) | `flutter_test` + `mocktail` | State transitions |
| Widgets (Screens) | `flutter_test` | Render, interaction, navigation |
| Visual (Pixel Parity) | `golden_toolkit` | Screenshot comparison |

## Decisions Log

| Decision | Rationale |
|----------|-----------|
| Riverpod over Bloc | Less boilerplate, code-gen support, matches MVVM pattern from Android |
| go_router over auto_route | Official Flutter team package, simpler setup for this app's nav depth |
| Dio over http | Need interceptors for auth refresh, VPN block, logging |
| flutter_secure_storage over hive | Tokens need encryption. No relational data to store |
| No get_it | Riverpod handles DI. One less dependency |
| Feature-first folders | Matches Android's package structure. Easier to navigate |
| SDP/SSP → responsive_sizer | Flutter equivalent for scalable dimensions |
