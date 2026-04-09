import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../providers/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );

    _startSplash();
  }

  Future<void> _startSplash() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _controller.forward();
    await Future.delayed(const Duration(milliseconds: 2000));
    if (!mounted) return;
    _navigate();
  }

  void _navigate() {
    final isLoggedIn = ref.read(isLoggedInProvider);
    isLoggedIn.when(
      data: (loggedIn) {
        if (loggedIn) {
          context.go('/home');
        } else {
          final sliderShown = ref.read(isSliderShownProvider);
          if (!sliderShown) {
            context.go('/auth/intro');
          } else {
            context.go('/auth/login');
          }
        }
      },
      loading: () => Future.delayed(
        const Duration(milliseconds: 500),
        _navigate,
      ),
      error: (_, __) => context.go('/auth/login'),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'ROSTERUP',
                      style: AppTypography.heading1.copyWith(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primaryDark,
                        letterSpacing: 4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Fantasy Esports',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.themeText,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
