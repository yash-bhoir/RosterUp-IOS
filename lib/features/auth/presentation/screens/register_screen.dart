import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_input.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _referralController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _referralController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (!_formKey.currentState!.validate()) return;
    ref.read(registerStateProvider.notifier).register(
          _phoneController.text.trim(),
          _referralController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final registerState = ref.watch(registerStateProvider);

    ref.listen(registerStateProvider, (prev, next) {
      next.whenOrNull(
        data: (otp) {
          if (otp != null) {
            context.push('/auth/otp', extra: {
              'mobile': _phoneController.text.trim(),
              'otp': otp,
              'screenType': 'REGISTER',
            });
            ref.read(registerStateProvider.notifier).reset();
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
      appBar: AppBar(
        backgroundColor: AppColors.statusBar,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Register'),
      ),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.paddingXl,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppSpacing.gapVXl,

                Text(
                  'Create Account',
                  style: AppTypography.heading2,
                ),
                AppSpacing.gapVSm,
                Text(
                  'Enter your details to get started',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.themeText,
                  ),
                ),
                AppSpacing.gapVXl,

                // Phone Input
                PhoneInput(controller: _phoneController),
                AppSpacing.gapVLg,

                // Referral Code
                AppInput(
                  controller: _referralController,
                  hintText: 'Referral Code (optional)',
                  textInputAction: TextInputAction.done,
                ),
                AppSpacing.gapVXl,

                // Register Button
                AppButton(
                  text: 'Register',
                  onPressed: _handleRegister,
                  isLoading: registerState.isLoading,
                ),

                AppSpacing.gapVLg,

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.themeText,
                      ),
                    ),
                    AppTextButton(
                      text: 'Login',
                      onPressed: () => context.pop(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
