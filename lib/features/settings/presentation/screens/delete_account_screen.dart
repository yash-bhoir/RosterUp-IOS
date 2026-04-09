import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../profile/data/repositories/profile_repository.dart';
import '../../../auth/data/repositories/auth_repository_impl.dart';

class DeleteAccountScreen extends ConsumerStatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  ConsumerState<DeleteAccountScreen> createState() =>
      _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends ConsumerState<DeleteAccountScreen> {
  bool _confirmed = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title:
            const Text('Delete Account', style: AppTypography.labelLarge),
        backgroundColor: AppColors.darkText,
        centerTitle: true,
      ),
      body: Padding(
        padding: AppSpacing.paddingXl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSpacing.gapVXl,
            Icon(
              Icons.warning_amber_rounded,
              size: 64,
              color: AppColors.red.withOpacity(0.7),
            ),
            AppSpacing.gapVLg,
            Text(
              'Delete Your Account',
              style: AppTypography.heading2.copyWith(color: AppColors.red),
            ),
            AppSpacing.gapVMd,
            Text(
              'This action is permanent and cannot be undone. All your data, including:',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.themeText,
              ),
            ),
            AppSpacing.gapVMd,
            _bulletPoint('Your profile and personal information'),
            _bulletPoint('Contest history and winnings'),
            _bulletPoint('Wallet balance (non-refundable)'),
            _bulletPoint('All teams and contest entries'),
            AppSpacing.gapVXl,
            Row(
              children: [
                Checkbox(
                  value: _confirmed,
                  onChanged: (v) => setState(() => _confirmed = v ?? false),
                  activeColor: AppColors.red,
                ),
                Expanded(
                  child: Text(
                    'I understand this action is permanent',
                    style: AppTypography.bodySmall,
                  ),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: AppSpacing.buttonHeight,
              child: ElevatedButton(
                onPressed: _confirmed && !_isLoading ? _deleteAccount : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.red,
                  disabledBackgroundColor: AppColors.tabGrey,
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.white,
                        ),
                      )
                    : Text(
                        'DELETE MY ACCOUNT',
                        style: AppTypography.button.copyWith(
                          color: AppColors.white,
                        ),
                      ),
              ),
            ),
            AppSpacing.gapVLg,
          ],
        ),
      ),
    );
  }

  Widget _bulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('  •  ', style: AppTypography.bodyMedium.copyWith(
            color: AppColors.red,
          )),
          Expanded(
            child: Text(text, style: AppTypography.bodySmall.copyWith(
              color: AppColors.themeText,
            )),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAccount() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceVariant,
        title: Text('Are you sure?',
            style: AppTypography.heading3.copyWith(color: AppColors.red)),
        content: const Text(
          'This will permanently delete your account.',
          style: AppTypography.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.red),
            child: Text('Delete',
                style: AppTypography.labelSmall.copyWith(
                    color: AppColors.white)),
          ),
        ],
      ),
    );

    if (confirm != true || !mounted) return;

    setState(() => _isLoading = true);
    final repo = ref.read(profileRepositoryProvider);
    final result = await repo.deleteAccount();

    if (!mounted) return;
    result.when(
      success: (_) async {
        await ref.read(authRepositoryProvider).logout();
        if (mounted) context.go('/auth/login');
      },
      failure: (e) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppColors.red,
          ),
        );
      },
    );
  }
}
