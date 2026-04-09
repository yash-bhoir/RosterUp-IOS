import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

class RosterAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showBackButton;
  final bool showProfile;
  final bool showWallet;
  final String? profileImageUrl;
  final String? walletBalance;
  final VoidCallback? onProfileTap;
  final VoidCallback? onWalletTap;
  final VoidCallback? onMenuTap;
  final List<Widget>? actions;

  const RosterAppBar({
    super.key,
    this.title,
    this.showBackButton = false,
    this.showProfile = false,
    this.showWallet = false,
    this.profileImageUrl,
    this.walletBalance,
    this.onProfileTap,
    this.onWalletTap,
    this.onMenuTap,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(AppSpacing.toolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: _buildLeading(context),
      title: title != null
          ? Text(title!, style: AppTypography.heading2)
          : const _AppLogo(),
      centerTitle: true,
      actions: [
        if (showWallet) _WalletButton(
          balance: walletBalance ?? '0',
          onTap: onWalletTap,
        ),
        if (actions != null) ...actions!,
        AppSpacing.gapHSm,
      ],
    );
  }

  Widget? _buildLeading(BuildContext context) {
    if (showBackButton) {
      return IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_back, color: AppColors.white),
      );
    }
    if (showProfile) {
      return Padding(
        padding: const EdgeInsets.only(left: AppSpacing.md),
        child: GestureDetector(
          onTap: onMenuTap,
          child: ProfileCircle(
            imageUrl: profileImageUrl,
            size: AppSpacing.profileCircle,
          ),
        ),
      );
    }
    return null;
  }
}

class _AppLogo extends StatelessWidget {
  const _AppLogo();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: AppSpacing.logoWidth,
      height: AppSpacing.logoHeight,
      child: Center(
        child: Text(
          'ROSTERUP',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w900,
            fontSize: 16,
            color: AppColors.primaryDark,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}

class _WalletButton extends StatelessWidget {
  final String balance;
  final VoidCallback? onTap;

  const _WalletButton({required this.balance, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primaryDark, width: 1),
          borderRadius: AppSpacing.borderRadiusSm,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.account_balance_wallet_outlined,
              color: AppColors.primaryDark,
              size: 18,
            ),
            AppSpacing.gapHXs,
            Text(
              balance,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.primaryDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileCircle extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final double strokeWidth;

  const ProfileCircle({
    super.key,
    this.imageUrl,
    this.size = AppSpacing.profileCircle,
    this.strokeWidth = AppSpacing.strokeDefault,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.white,
          width: strokeWidth,
        ),
      ),
      child: ClipOval(
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _defaultAvatar(),
              )
            : _defaultAvatar(),
      ),
    );
  }

  Widget _defaultAvatar() {
    return Container(
      color: AppColors.tabGrey,
      child: Icon(
        Icons.person,
        color: AppColors.themeText,
        size: size * 0.6,
      ),
    );
  }
}
