import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/match.dart';

class MatchListCard extends StatelessWidget {
  final Match match;
  final VoidCallback? onTap;
  final bool showWonAmount;
  final bool showLiveBadge;
  final String? trailingText;

  const MatchListCard({
    super.key,
    required this.match,
    this.onTap,
    this.showWonAmount = false,
    this.showLiveBadge = false,
    this.trailingText,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardBackground,
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppSpacing.borderRadiusSm,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            _buildBody(),
            if (showWonAmount || match.totalJoinedContests > 0)
              _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm + 2,
      ),
      decoration: const BoxDecoration(
        color: AppColors.sectionHeader,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSpacing.radiusSm),
          topRight: Radius.circular(AppSpacing.radiusSm),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              match.leagueName.toUpperCase(),
              style: AppTypography.captionSmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (showLiveBadge) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.red,
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(
                'LIVE',
                style: AppTypography.captionSmall.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            AppSpacing.gapHSm,
          ],
          Text(
            trailingText ?? match.dayName,
            style: AppTypography.captionSmall,
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      child: match.isTeamBattle ? _buildTeamBattleBody() : _buildTeamBattleBody(),
    );
  }

  Widget _buildTeamBattleBody() {
    return Column(
      children: [
        // Match name
        Text(
          match.matchName.toUpperCase(),
          style: AppTypography.labelMedium,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        AppSpacing.gapVSm,
        // Team icons row (if teams exist)
        if (match.teams.length >= 2)
          _buildTwoTeamRow()
        else if (match.teams.isNotEmpty)
          _buildMultiTeamRow(),
        AppSpacing.gapVSm,
        // Location & time
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                match.location.toUpperCase(),
                style: AppTypography.captionSmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              _formatTime(match.startAt),
              style: AppTypography.captionSmall.copyWith(
                color: AppColors.primaryDark,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTwoTeamRow() {
    final teamA = match.teams[0];
    final teamB = match.teams[1];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Team A
        Row(
          children: [
            _teamIcon(teamA.icon),
            AppSpacing.gapHSm,
            Text(teamA.teamName, style: AppTypography.labelSmall),
          ],
        ),
        Text(
          'VS',
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.primaryDark,
          ),
        ),
        // Team B
        Row(
          children: [
            Text(teamB.teamName, style: AppTypography.labelSmall),
            AppSpacing.gapHSm,
            _teamIcon(teamB.icon),
          ],
        ),
      ],
    );
  }

  Widget _buildMultiTeamRow() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: match.teams.length,
        separatorBuilder: (_, __) => AppSpacing.gapHSm,
        itemBuilder: (context, index) {
          final team = match.teams[index];
          return Chip(
            avatar: _teamIcon(team.icon, size: 18),
            label: Text(team.code, style: AppTypography.captionSmall),
            backgroundColor: AppColors.surfaceVariant,
            padding: EdgeInsets.zero,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          );
        },
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.matchBar, width: 0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${match.totalTeams} Team  ${match.totalJoinedContests} Contest',
            style: AppTypography.captionSmall,
          ),
          if (showWonAmount && match.totalAmountWon > 0)
            Text(
              'You Won ₹${match.totalAmountWon.toStringAsFixed(0)}',
              style: AppTypography.captionSmall.copyWith(
                color: AppColors.highlighter,
              ),
            ),
        ],
      ),
    );
  }

  Widget _teamIcon(String url, {double size = 24}) {
    if (url.isEmpty) {
      return Icon(Icons.shield_outlined, size: size, color: AppColors.themeText);
    }
    return CachedNetworkImage(
      imageUrl: url,
      width: size,
      height: size,
      placeholder: (_, __) => Icon(
        Icons.shield_outlined,
        size: size,
        color: AppColors.themeText,
      ),
      errorWidget: (_, __, ___) => Icon(
        Icons.shield_outlined,
        size: size,
        color: AppColors.themeText,
      ),
    );
  }

  String _formatTime(String startAt) {
    try {
      final dt = DateTime.parse(startAt);
      final now = DateTime.now().toUtc();
      final diff = dt.difference(now);
      if (diff.isNegative) return 'Started';
      if (diff.inDays > 0) return '${diff.inDays}d ${diff.inHours % 24}h';
      if (diff.inHours > 0) return '${diff.inHours}h ${diff.inMinutes % 60}m';
      return '${diff.inMinutes}m';
    } catch (_) {
      return startAt;
    }
  }
}
