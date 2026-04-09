import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/player.dart';
import '../providers/team_provider.dart';
import 'team_preview_screen.dart';

class ChooseCaptainScreen extends ConsumerWidget {
  final int matchId;

  const ChooseCaptainScreen({super.key, required this.matchId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final team = ref.watch(teamBuilderProvider);
    final selectedPlayers = team.selectedPlayers;

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title:
            const Text('Choose Captain', style: AppTypography.labelLarge),
        backgroundColor: AppColors.darkText,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Instructions
          Container(
            width: double.infinity,
            padding: AppSpacing.paddingMd,
            color: AppColors.surfaceVariant,
            child: Column(
              children: [
                Text(
                  'Choose your Captain and Vice Captain',
                  style: AppTypography.labelMedium,
                ),
                AppSpacing.gapVXs,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _multiplierBadge('C', '2x', AppColors.primaryDark),
                    AppSpacing.gapHLg,
                    _multiplierBadge('VC', '1.5x', AppColors.highlighter),
                  ],
                ),
              ],
            ),
          ),
          // Player list
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              itemCount: selectedPlayers.length,
              separatorBuilder: (_, __) => const Divider(
                height: 1,
                color: AppColors.matchBar,
              ),
              itemBuilder: (context, index) {
                final player = selectedPlayers[index];
                return _CaptainPlayerTile(
                  player: player,
                  onCaptainTap: () => ref
                      .read(teamBuilderProvider.notifier)
                      .setCaptain(player.matchTeamPlayerId),
                  onViceCaptainTap: () => ref
                      .read(teamBuilderProvider.notifier)
                      .setViceCaptain(player.matchTeamPlayerId),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: AppSpacing.paddingMd,
          child: SizedBox(
            height: AppSpacing.buttonHeight,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: team.isValid
                  ? () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) =>
                            TeamPreviewScreen(matchId: matchId),
                      ));
                    }
                  : null,
              child: Text(
                'PREVIEW TEAM',
                style: AppTypography.button.copyWith(
                  color:
                      team.isValid ? AppColors.black : AppColors.themeText,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _multiplierBadge(String label, String multiplier, Color color) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
          child: Center(
            child: Text(
              label,
              style: AppTypography.captionSmall.copyWith(
                color: AppColors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        AppSpacing.gapHSm,
        Text(
          '$multiplier points',
          style: AppTypography.captionSmall,
        ),
      ],
    );
  }
}

class _CaptainPlayerTile extends StatelessWidget {
  final Player player;
  final VoidCallback onCaptainTap;
  final VoidCallback onViceCaptainTap;

  const _CaptainPlayerTile({
    required this.player,
    required this.onCaptainTap,
    required this.onViceCaptainTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          // Player avatar
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.surfaceVariant,
            child: player.icon.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: player.icon,
                    width: 36,
                    height: 36,
                    errorWidget: (_, __, ___) => const Icon(Icons.person,
                        size: 20, color: AppColors.themeText),
                  )
                : const Icon(Icons.person,
                    size: 20, color: AppColors.themeText),
          ),
          AppSpacing.gapHMd,
          // Player info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(player.name, style: AppTypography.labelSmall),
                Text(
                  '${player.credits} CR • ${player.tournamentPoints} pts',
                  style: AppTypography.captionSmall,
                ),
              ],
            ),
          ),
          // Captain button
          GestureDetector(
            onTap: onCaptainTap,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: player.isCaptain
                    ? AppColors.primaryDark
                    : Colors.transparent,
                border: Border.all(
                  color: player.isCaptain
                      ? AppColors.primaryDark
                      : AppColors.tabGrey,
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  'C',
                  style: AppTypography.labelSmall.copyWith(
                    color: player.isCaptain
                        ? AppColors.black
                        : AppColors.themeText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          AppSpacing.gapHMd,
          // Vice captain button
          GestureDetector(
            onTap: onViceCaptainTap,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: player.isViceCaptain
                    ? AppColors.highlighter
                    : Colors.transparent,
                border: Border.all(
                  color: player.isViceCaptain
                      ? AppColors.highlighter
                      : AppColors.tabGrey,
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  'VC',
                  style: AppTypography.captionSmall.copyWith(
                    color: player.isViceCaptain
                        ? AppColors.black
                        : AppColors.themeText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
