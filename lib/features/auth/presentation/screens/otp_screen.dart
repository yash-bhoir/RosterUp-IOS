import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../core/config/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../providers/auth_provider.dart';

class OtpScreen extends ConsumerStatefulWidget {
  final String mobile;
  final String otp;
  final String screenType;

  const OtpScreen({
    super.key,
    required this.mobile,
    required this.otp,
    required this.screenType,
  });

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final _otpController = TextEditingController();
  Timer? _timer;
  int _secondsRemaining = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _secondsRemaining = 60;
    _canResend = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();
        setState(() => _canResend = true);
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  void _handleVerify() {
    if (_otpController.text.length != AppConstants.otpLength) return;

    final notifier = ref.read(otpStateProvider.notifier);
    if (widget.screenType == 'REGISTER') {
      notifier.verifyMobile(
        widget.mobile,
        _otpController.text,
        '', // deviceId — will be set from platform
        '', // fcmToken — will be set from Firebase
      );
    } else {
      notifier.verifyOtp(
        widget.mobile,
        _otpController.text,
        '',
        '',
      );
    }
  }

  void _handleResend() {
    if (!_canResend) return;
    ref.read(otpStateProvider.notifier).resendOtp(widget.mobile);
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final otpState = ref.watch(otpStateProvider);

    ref.listen(otpStateProvider, (prev, next) {
      next.whenOrNull(
        data: (verified) {
          if (verified) {
            if (widget.screenType == 'REGISTER') {
              context.go('/auth/username');
            } else {
              context.go('/home');
            }
            ref.read(otpStateProvider.notifier).reset();
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
        title: const Text('OTP Verification'),
      ),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.paddingXl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppSpacing.gapVXl,

              Text(
                'Verification Code',
                style: AppTypography.heading2,
              ),
              AppSpacing.gapVSm,
              Text(
                'We have sent the OTP to +91 ${widget.mobile}',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.themeText,
                ),
              ),
              AppSpacing.gapVXl,
              AppSpacing.gapVXl,

              // OTP Input
              PinCodeTextField(
                appContext: context,
                length: AppConstants.otpLength,
                controller: _otpController,
                keyboardType: TextInputType.number,
                animationType: AnimationType.fade,
                animationDuration: const Duration(milliseconds: 200),
                enableActiveFill: true,
                cursorColor: AppColors.primaryDark,
                textStyle: AppTypography.heading2,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: AppSpacing.borderRadiusSm,
                  fieldHeight: 50,
                  fieldWidth: 45,
                  activeFillColor: AppColors.tabNewGrey,
                  inactiveFillColor: AppColors.darkText,
                  selectedFillColor: AppColors.tabNewGrey,
                  activeColor: AppColors.primaryDark,
                  inactiveColor: AppColors.tabGrey,
                  selectedColor: AppColors.primaryDark,
                ),
                onCompleted: (_) => _handleVerify(),
                onChanged: (_) {},
              ),

              AppSpacing.gapVXl,

              // Verify Button
              AppButton(
                text: 'Verify',
                onPressed: _handleVerify,
                isLoading: otpState.isLoading,
              ),

              AppSpacing.gapVXl,

              // Resend
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!_canResend) ...[
                    Text(
                      'Resend OTP in ',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.themeText,
                      ),
                    ),
                    Text(
                      '00:${_secondsRemaining.toString().padLeft(2, '0')}',
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ] else
                    AppTextButton(
                      text: 'Resend OTP',
                      onPressed: _handleResend,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
