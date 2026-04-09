import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/otp_screen.dart';
import '../../features/auth/presentation/screens/username_screen.dart';
import '../../features/home/presentation/screens/home_shell.dart';
import '../../features/home/presentation/screens/home_tab.dart';
import '../../features/matches/presentation/screens/matches_tab.dart';
import '../../features/rewards/presentation/screens/rewards_tab.dart';
import '../../features/support/presentation/screens/chat_tab.dart';
import '../../features/winners/presentation/screens/winners_tab.dart';
import '../../features/contests/presentation/screens/join_contest_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/wallet/presentation/screens/wallet_screen.dart';
import '../../features/settings/presentation/screens/refer_earn_screen.dart';
import '../../features/settings/presentation/screens/webview_screen.dart';
import '../../features/settings/presentation/screens/delete_account_screen.dart';
import '../../features/teams/presentation/screens/create_team_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    routes: [
      // Splash
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Auth routes
      GoRoute(
        path: '/auth/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/auth/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/auth/otp',
        builder: (context, state) {
          final extra = state.extra as Map<String, String>? ?? {};
          return OtpScreen(
            mobile: extra['mobile'] ?? '',
            otp: extra['otp'] ?? '',
            screenType: extra['screenType'] ?? 'LOGIN',
          );
        },
      ),
      GoRoute(
        path: '/auth/username',
        builder: (context, state) => const UsernameScreen(),
      ),

      // Contest / Match detail
      GoRoute(
        path: '/contest/:matchId',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final matchId =
              int.tryParse(state.pathParameters['matchId'] ?? '') ?? 0;
          return JoinContestScreen(matchId: matchId);
        },
      ),

      // Create team
      GoRoute(
        path: '/create-team/:matchId',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final matchId =
              int.tryParse(state.pathParameters['matchId'] ?? '') ?? 0;
          return CreateTeamScreen(matchId: matchId);
        },
      ),

      // Profile
      GoRoute(
        path: '/profile',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/profile/edit',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const EditProfileScreen(),
      ),

      // Wallet
      GoRoute(
        path: '/wallet',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const WalletScreen(),
      ),

      // Refer & Earn
      GoRoute(
        path: '/refer',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ReferEarnScreen(),
      ),

      // WebView (generic)
      GoRoute(
        path: '/webview',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final extra = state.extra as Map<String, String>? ?? {};
          return WebViewScreen(
            title: extra['title'] ?? '',
            url: extra['url'] ?? '',
          );
        },
      ),

      // Delete Account
      GoRoute(
        path: '/delete-account',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const DeleteAccountScreen(),
      ),

      // Main app with bottom navigation
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return HomeShell(navigationShell: navigationShell);
        },
        branches: [
          // Home tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeTab(),
              ),
            ],
          ),
          // Matches tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/matches',
                builder: (context, state) => const MatchesTab(),
              ),
            ],
          ),
          // Rewards tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/rewards',
                builder: (context, state) => const RewardsTab(),
              ),
            ],
          ),
          // Chat tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/chat',
                builder: (context, state) => const ChatTab(),
              ),
            ],
          ),
          // Winners tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/winners',
                builder: (context, state) => const WinnersTab(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
