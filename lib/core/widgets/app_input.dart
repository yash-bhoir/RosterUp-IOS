import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

class AppInput extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final bool obscureText;
  final bool readOnly;
  final int? maxLength;
  final int maxLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final VoidCallback? onTap;

  const AppInput({
    super.key,
    this.hintText,
    this.labelText,
    this.controller,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.obscureText = false,
    this.readOnly = false,
    this.maxLength,
    this.maxLines = 1,
    this.prefixIcon,
    this.suffixIcon,
    this.focusNode,
    this.textInputAction,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      onChanged: onChanged,
      obscureText: obscureText,
      readOnly: readOnly,
      maxLength: maxLength,
      maxLines: maxLines,
      focusNode: focusNode,
      textInputAction: textInputAction,
      onTap: onTap,
      style: AppTypography.bodyMedium,
      cursorColor: AppColors.primaryDark,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        counterText: '',
      ),
    );
  }
}

class PhoneInput extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;

  const PhoneInput({
    super.key,
    this.controller,
    this.validator,
    this.onChanged,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return AppInput(
      controller: controller,
      hintText: 'Enter mobile number',
      keyboardType: TextInputType.phone,
      maxLength: 10,
      focusNode: focusNode,
      textInputAction: TextInputAction.done,
      onChanged: onChanged,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      validator: validator ?? _defaultPhoneValidator,
      prefixIcon: Container(
        width: 55,
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppSpacing.gapHSm,
            const Text('🇮🇳', style: TextStyle(fontSize: 20)),
            AppSpacing.gapHSm,
            Text(
              '+91',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.themeText,
              ),
            ),
            AppSpacing.gapHSm,
            Container(
              width: 1,
              height: 25,
              color: AppColors.tabGrey,
            ),
          ],
        ),
      ),
    );
  }

  static String? _defaultPhoneValidator(String? value) {
    if (value == null || value.isEmpty) return 'Enter phone number';
    if (value.length != 10) return 'Phone number must be 10 digits';
    if (!RegExp(r'^[6-9]').hasMatch(value)) return 'Must start with 6-9';
    return null;
  }
}
