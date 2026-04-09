import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/player.dart';
import '../providers/team_provider.dart';

class TeamPreviewScreen extends ConsumerWidget {
  final int matchId;

  const TeamPreviewScreen({super.key, required this.matchId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final team = ref.watch(teamBuilderProvider);
    final selected = team.selectedPlayers;

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title: const Text('Team Preview', style: AppTypography.labelLarge),
        backgroundColor: AppColors.darkText,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Team stats header
          Container(
            width: double.infinity,
            padding: AppSpacing.paddingMd,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.statusBar, Color(0xFF1A1A1A)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _statColumn('Players', '${selected.length}'),
                    _statColumn(
                        'Credits', team.creditsUsed.toStringAsFixed(1)),
                    _statColumn(
                        'Captain', team.captain?.name ?? '-'),
                    _statColumn(
                        'Vice Captain', team.viceCaptain?.name ?? '-'),
                  ],
                ),
              ],
            ),
          ),
          // Player grid
          Expanded(
            child: GridView.builder(
              padding: AppSpacing.paddingMd,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.85,
                crossAxisSpacing: AppSpacing.sm,
                mainAxisSpacing: AppSpacing.md,
              ),
              itemCount: selected.length,
              itemBuilder: (context, index) {
                return _PlayerPreviewCard(player: selected[index]);
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
              onPressed: () => _saveTeam(context, ref),
              child: Text(
                'SAVE TEAM',
                style: AppTypography.button.copyWith(color: AppColors.black),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _statColumn(String label, String value) {
    return Column(
      children: [
        Text(label, style: AppTypography.captionSmall),
        AppSpacing.gapVXs,
        Text(
          value,
          style: AppTypography.labelSmall,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Future<void> _saveTeam(BuildContext context, WidgetRef ref) async {
    final success =
        await ref.read(createTeamProvider.notifier).create(matchId: matchId);
    if (!context.mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Team created successfully!'),
          backgroundColor: AppColors.green,
        ),
      );
      // Pop back to contest screen
      Navigator.of(context)
        ..pop() // preview
        ..pop() // captain
        ..pop(); // create team
    } else {
      final error = ref.read(createTeamProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.error?.toString() ?? 'Failed to create team'),
          backgroundColor: AppColors.red,
        ),
      );
    }
  }
}

class _PlayerPreviewCard extends StatelessWidget {
  final Player player;

  const _PlayerPreviewCard({required this.player});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.surfaceVariant,
              child: const Icon(Icons.person, size: 28, color: AppColors.themeText),
            ),
            if (player.isCaptain)
              _badge('C', AppColors.primaryDark)
            else if (player.isViceCaptain)
              _badge('VC', AppColors.highlighter),
          ],
        ),
        AppSpacing.gapVXs,
        Text(
          player.name,
          style: AppTypography.captionSmall.copyWith(
            fontWeight: FontWeight.w700,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
        Text(
          '${player.credits} CR',
          style: AppTypography.captionSmall.copyWith(
            color: AppColors.primaryDark,
            fontSize: 8,
          ),
        ),
      ],
    );
  }

  Widget _badge(String label, Color color) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
      ),
    );
  }
}
