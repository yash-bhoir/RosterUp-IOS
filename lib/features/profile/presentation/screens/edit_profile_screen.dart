import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_input.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/error_widget.dart';
import '../providers/profile_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _emailController = TextEditingController();
  final _stateController = TextEditingController();
  final _dobController = TextEditingController();
  String _gender = '';

  @override
  void initState() {
    super.initState();
    final profile = ref.read(profileProvider).valueOrNull;
    if (profile != null) {
      _emailController.text = profile.email;
      _stateController.text = profile.state;
      _dobController.text = profile.dateOfBirth;
      _gender = profile.gender;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _stateController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final updateState = ref.watch(updateProfileProvider);
    final isLoading = updateState is AsyncLoading;

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title: const Text('Edit Profile', style: AppTypography.labelLarge),
        backgroundColor: AppColors.darkText,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.paddingLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppSpacing.gapVMd,
            AppInput(
              controller: _emailController,
              labelText: 'Email',
              hintText: 'Enter email',
              keyboardType: TextInputType.emailAddress,
            ),
            AppSpacing.gapVLg,
            AppInput(
              controller: _stateController,
              labelText: 'State',
              hintText: 'Enter state',
            ),
            AppSpacing.gapVLg,
            AppInput(
              controller: _dobController,
              labelText: 'Date of Birth',
              hintText: 'YYYY-MM-DD',
              readOnly: true,
              onTap: _pickDate,
            ),
            AppSpacing.gapVLg,
            Text('Gender', style: AppTypography.labelSmall),
            AppSpacing.gapVSm,
            Row(
              children: ['Male', 'Female', 'Other'].map((g) {
                final selected = _gender.toLowerCase() == g.toLowerCase();
                return Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.md),
                  child: ChoiceChip(
                    label: Text(g, style: AppTypography.captionSmall),
                    selected: selected,
                    selectedColor: AppColors.primaryDark,
                    backgroundColor: AppColors.surfaceVariant,
                    onSelected: (_) => setState(() => _gender = g),
                  ),
                );
              }).toList(),
            ),
            AppSpacing.gapVXl,
            AppButton(
              text: 'SAVE',
              isLoading: isLoading,
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      _dobController.text =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
  }

  Future<void> _save() async {
    final success = await ref.read(updateProfileProvider.notifier).update(
      email: _emailController.text.trim(),
      userState: _stateController.text.trim(),
      dateOfBirth: _dobController.text.trim(),
      gender: _gender,
    );
    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated'),
          backgroundColor: AppColors.green,
        ),
      );
      Navigator.of(context).pop();
    }
  }
}
