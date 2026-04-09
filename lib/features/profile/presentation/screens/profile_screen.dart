import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../providers/profile_provider.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);
    final statsAsync = ref.watch(accountStatsProvider);

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title: const Text('Profile', style: AppTypography.labelLarge),
        backgroundColor: AppColors.darkText,
        centerTitle: true,
      ),
      body: profileAsync.when(
        loading: () => const LoadingIndicator(),
        error: (e, _) => AppErrorWidget(
          message: e.toString(),
          onRetry: () => ref.read(profileProvider.notifier).refresh(),
        ),
        data: (profile) => SingleChildScrollView(
          child: Column(
            children: [
              // Profile header
              Container(
                width: double.infinity,
                padding: AppSpacing.paddingXl,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.statusBar, AppColors.black],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors.surfaceVariant,
                      backgroundImage: profile.profilePic.isNotEmpty
                          ? CachedNetworkImageProvider(profile.profilePic)
                          : null,
                      child: profile.profilePic.isEmpty
                          ? const Icon(Icons.person,
                              size: 40, color: AppColors.themeText)
                          : null,
                    ),
                    AppSpacing.gapVMd,
                    Text(profile.userName, style: AppTypography.heading2),
                    AppSpacing.gapVXs,
                    Text(profile.mobile, style: AppTypography.caption),
                    if (profile.email.isNotEmpty) ...[
                      AppSpacing.gapVXs,
                      Text(profile.email, style: AppTypography.caption),
                    ],
                    AppSpacing.gapVMd,
                    OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const EditProfileScreen(),
                        ));
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primaryDark),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 8,
                        ),
                      ),
                      child: Text(
                        'Edit Profile',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Stats
              statsAsync.when(
                loading: () => const Padding(
                  padding: AppSpacing.paddingMd,
                  child: LoadingIndicator(),
                ),
                error: (_, __) => const SizedBox.shrink(),
                data: (stats) => Padding(
                  padding: AppSpacing.paddingMd,
                  child: Row(
                    children: [
                      _StatCard(
                        label: 'Matches',
                        value: '${stats.totalMatches}',
                      ),
                      _StatCard(
                        label: 'Contests',
                        value: '${stats.totalContests}',
                      ),
                      _StatCard(
                        label: 'Wins',
                        value: '${stats.totalWins}',
                      ),
                      _StatCard(
                        label: 'Winnings',
                        value: '₹${stats.totalWinnings.toStringAsFixed(0)}',
                        highlight: true,
                      ),
                    ],
                  ),
                ),
              ),
              // Referral code
              if (profile.referralCode.isNotEmpty)
                Card(
                  color: AppColors.cardBackground,
                  margin: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.share,
                        color: AppColors.primaryDark),
                    title: const Text('Referral Code',
                        style: AppTypography.labelSmall),
                    subtitle: Text(profile.referralCode,
                        style: AppTypography.caption),
                    trailing: const Icon(Icons.copy,
                        size: 18, color: AppColors.themeText),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _StatCard({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        color: AppColors.cardBackground,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.md,
            horizontal: AppSpacing.sm,
          ),
          child: Column(
            children: [
              Text(
                value,
                style: AppTypography.heading3.copyWith(
                  color:
                      highlight ? AppColors.primaryDark : AppColors.white,
                ),
              ),
              AppSpacing.gapVXs,
              Text(
                label,
                style: AppTypography.captionSmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
