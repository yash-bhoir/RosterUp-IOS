import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_bar.dart';

class HomeShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const HomeShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RosterAppBar(
        showProfile: true,
        showWallet: true,
        walletBalance: '0',
        onMenuTap: () => Scaffold.of(context).openDrawer(),
        onWalletTap: () => context.push('/wallet'),
      ),
      drawer: const _AppDrawer(),
      body: navigationShell,
      bottomNavigationBar: _BottomNav(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _BottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.darkText,
        border: Border(
          top: BorderSide(color: AppColors.matchBar, width: 0.5),
        ),
      ),
      child: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onTap,
        height: 65,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: AppColors.primaryDark),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.sports_esports_outlined),
            selectedIcon: Icon(Icons.sports_esports, color: AppColors.primaryDark),
            label: 'Matches',
          ),
          NavigationDestination(
            icon: Icon(Icons.card_giftcard_outlined),
            selectedIcon: Icon(Icons.card_giftcard, color: AppColors.primaryDark),
            label: 'Rewards',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_outlined),
            selectedIcon: Icon(Icons.chat, color: AppColors.primaryDark),
            label: 'Chat',
          ),
          NavigationDestination(
            icon: Icon(Icons.emoji_events_outlined),
            selectedIcon: Icon(Icons.emoji_events, color: AppColors.primaryDark),
            label: 'Winners',
          ),
        ],
      ),
    );
  }
}

class _AppDrawer extends StatelessWidget {
  const _AppDrawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.black,
      child: SafeArea(
        child: Column(
          children: [
            // Drawer Header
            Container(
              width: double.infinity,
              padding: AppSpacing.paddingXl,
              color: AppColors.statusBar,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ProfileCircle(size: 60),
                  AppSpacing.gapVMd,
                  Text('Player', style: AppTypography.heading3),
                  AppSpacing.gapVXs,
                  Text(
                    'View Profile',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.primaryDark,
                    ),
                  ),
                ],
              ),
            ),

            // Menu Items
            _DrawerItem(
              icon: Icons.account_balance_wallet_outlined,
              title: 'My Balance',
              onTap: () {
                Navigator.pop(context);
                context.push('/wallet');
              },
            ),
            _DrawerItem(
              icon: Icons.person_outline,
              title: 'My Info & Settings',
              onTap: () {
                Navigator.pop(context);
                context.push('/profile');
              },
            ),
            _DrawerItem(
              icon: Icons.support_agent_outlined,
              title: 'Help & Support',
              onTap: () {
                Navigator.pop(context);
                context.push('/support');
              },
            ),
            _DrawerItem(
              icon: Icons.share_outlined,
              title: 'Refer & Earn',
              onTap: () {
                Navigator.pop(context);
                context.push('/refer');
              },
            ),
            const Divider(),
            _DrawerItem(
              icon: Icons.logout,
              title: 'Logout',
              color: AppColors.red,
              onTap: () {
                Navigator.pop(context);
                context.go('/auth/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final Color? color;

  const _DrawerItem({
    required this.icon,
    required this.title,
    this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppColors.themeText, size: 22),
      title: Text(
        title,
        style: AppTypography.bodyMedium.copyWith(color: color),
      ),
      onTap: onTap,
      dense: true,
    );
  }
}
