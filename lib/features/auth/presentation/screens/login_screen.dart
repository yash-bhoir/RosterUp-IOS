import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_input.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (!_formKey.currentState!.validate()) return;
    ref.read(loginStateProvider.notifier).login(_phoneController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginStateProvider);

    ref.listen(loginStateProvider, (prev, next) {
      next.whenOrNull(
        data: (otp) {
          if (otp != null) {
            context.push('/auth/otp', extra: {
              'mobile': _phoneController.text.trim(),
              'otp': otp,
              'screenType': 'LOGIN',
            });
            ref.read(loginStateProvider.notifier).reset();
          }
        },
        error: (error, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.toString()),
              backgroundColor: AppColors.red,
            ),
          );
        },
      );
    });

    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.paddingXl,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(flex: 2),

                // Logo
                Text(
                  'ROSTERUP',
                  textAlign: TextAlign.center,
                  style: AppTypography.heading1.copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primaryDark,
                    letterSpacing: 4,
                  ),
                ),
                AppSpacing.gapVSm,
                Text(
                  'Fantasy Esports',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.themeText,
                    letterSpacing: 2,
                  ),
                ),

                const Spacer(flex: 2),

                // Title
                Text(
                  'Login',
                  style: AppTypography.heading2,
                ),
                AppSpacing.gapVSm,
                Text(
                  'Enter your mobile number to continue',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.themeText,
                  ),
                ),
                AppSpacing.gapVXl,

                // Phone Input
                PhoneInput(
                  controller: _phoneController,
                ),
                AppSpacing.gapVXl,

                // Login Button
                AppButton(
                  text: 'Continue',
                  onPressed: _handleLogin,
                  isLoading: loginState.isLoading,
                ),

                AppSpacing.gapVLg,

                // Register Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.themeText,
                      ),
                    ),
                    AppTextButton(
                      text: 'Register',
                      onPressed: () => context.push('/auth/register'),
                    ),
                  ],
                ),

                const Spacer(flex: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
