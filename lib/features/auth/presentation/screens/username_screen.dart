import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_input.dart';
import '../providers/auth_provider.dart';

class UsernameScreen extends ConsumerStatefulWidget {
  const UsernameScreen({super.key});

  @override
  ConsumerState<UsernameScreen> createState() => _UsernameScreenState();
}

class _UsernameScreenState extends ConsumerState<UsernameScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (!_formKey.currentState!.validate()) return;
    ref.read(saveNameStateProvider.notifier).saveName(
          _nameController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final saveState = ref.watch(saveNameStateProvider);

    ref.listen(saveNameStateProvider, (prev, next) {
      next.whenOrNull(
        data: (saved) {
          if (saved) context.go('/home');
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
        title: const Text('Set Username'),
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
                  'Choose your team name',
                  style: AppTypography.heading2,
                ),
                AppSpacing.gapVSm,
                Text(
                  'This will be visible to other players',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.themeText,
                  ),
                ),
                AppSpacing.gapVXl,

                AppInput(
                  controller: _nameController,
                  hintText: 'Enter team name',
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a team name';
                    }
                    if (value.trim().length < 3) {
                      return 'Name must be at least 3 characters';
                    }
                    return null;
                  },
                ),
                AppSpacing.gapVXl,

                AppButton(
                  text: 'Continue',
                  onPressed: _handleSave,
                  isLoading: saveState.isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
