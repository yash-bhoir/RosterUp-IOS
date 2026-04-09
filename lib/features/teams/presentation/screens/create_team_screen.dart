import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../domain/entities/player.dart';
import '../providers/team_provider.dart';
import 'choose_captain_screen.dart';

class CreateTeamScreen extends ConsumerStatefulWidget {
  final int matchId;

  const CreateTeamScreen({super.key, required this.matchId});

  @override
  ConsumerState<CreateTeamScreen> createState() => _CreateTeamScreenState();
}

class _CreateTeamScreenState extends ConsumerState<CreateTeamScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final playersAsync =
          ref.read(matchPlayersProvider(widget.matchId.toString()));
      playersAsync.whenData((players) {
        ref.read(teamBuilderProvider.notifier).setPlayers(players);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final playersAsync =
        ref.watch(matchPlayersProvider(widget.matchId.toString()));
    final team = ref.watch(teamBuilderProvider);

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title: const Text('Create Team', style: AppTypography.labelLarge),
        backgroundColor: AppColors.darkText,
        centerTitle: true,
      ),
      body: playersAsync.when(
        loading: () => const LoadingIndicator(),
        error: (e, _) => AppErrorWidget(
          message: e.toString(),
          onRetry: () => ref.invalidate(
              matchPlayersProvider(widget.matchId.toString())),
        ),
        data: (_) => Column(
          children: [
            // Credits & player count bar
            _TeamStatusBar(team: team),
            // Player list
            Expanded(
              child: ListView.separated(
                padding:
                    const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                itemCount: team.players.length,
                separatorBuilder: (_, __) => const Divider(
                  height: 1,
                  color: AppColors.matchBar,
                ),
                itemBuilder: (context, index) {
                  final player = team.players[index];
                  return _PlayerListTile(
                    player: player,
                    canSelect:
                        !team.isTeamFull || player.isSelected,
                    onTap: () => ref
                        .read(teamBuilderProvider.notifier)
                        .togglePlayer(player.matchTeamPlayerId),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: AppSpacing.paddingMd,
          child: SizedBox(
            height: AppSpacing.buttonHeight,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: team.isTeamFull
                  ? () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => ChooseCaptainScreen(
                          matchId: widget.matchId,
                        ),
                      ));
                    }
                  : null,
              child: Text(
                'NEXT (${team.selectedCount}/${team.teamSize})',
                style: AppTypography.button.copyWith(
                  color: team.isTeamFull
                      ? AppColors.black
                      : AppColors.themeText,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TeamStatusBar extends StatelessWidget {
  final TeamComposition team;

  const _TeamStatusBar({required this.team});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      color: AppColors.surfaceVariant,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text('Players', style: AppTypography.captionSmall),
              AppSpacing.gapVXs,
              Text(
                '${team.selectedCount}/${team.teamSize}',
                style: AppTypography.labelLarge.copyWith(
                  color: team.isTeamFull
                      ? AppColors.highlighter
                      : AppColors.white,
                ),
              ),
            ],
          ),
          // Credits indicator
          Column(
            children: [
              Text('Credits Left', style: AppTypography.captionSmall),
              AppSpacing.gapVXs,
              Text(
                team.creditsRemaining.toStringAsFixed(1),
                style: AppTypography.labelLarge.copyWith(
                  color: team.creditsRemaining < 0
                      ? AppColors.red
                      : AppColors.primaryDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlayerListTile extends StatelessWidget {
  final Player player;
  final bool canSelect;
  final VoidCallback onTap;

  const _PlayerListTile({
    required this.player,
    required this.canSelect,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = !canSelect && !player.isSelected;

    return ListTile(
      onTap: isDisabled ? null : onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      leading: CircleAvatar(
        radius: 18,
        backgroundColor: AppColors.surfaceVariant,
        child: player.icon.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: player.icon,
                width: 36,
                height: 36,
                errorWidget: (_, __, ___) =>
                    const Icon(Icons.person, size: 20, color: AppColors.themeText),
              )
            : const Icon(Icons.person, size: 20, color: AppColors.themeText),
      ),
      title: Text(
        player.name,
        style: AppTypography.labelSmall.copyWith(
          color: isDisabled ? AppColors.tabGrey : AppColors.white,
        ),
      ),
      subtitle: Row(
        children: [
          Text(
            player.teamName,
            style: AppTypography.captionSmall,
          ),
          AppSpacing.gapHSm,
          Text(
            '${player.credits} CR',
            style: AppTypography.captionSmall.copyWith(
              color: AppColors.primaryDark,
            ),
          ),
          AppSpacing.gapHSm,
          Text(
            '${player.selectedByPercent.toStringAsFixed(1)}%',
            style: AppTypography.captionSmall,
          ),
        ],
      ),
      trailing: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color:
              player.isSelected ? AppColors.primaryDark : Colors.transparent,
          border: Border.all(
            color: player.isSelected
                ? AppColors.primaryDark
                : AppColors.tabGrey,
            width: 2,
          ),
        ),
        child: player.isSelected
            ? const Icon(Icons.check, size: 16, color: AppColors.black)
            : null,
      ),
    );
  }
}
