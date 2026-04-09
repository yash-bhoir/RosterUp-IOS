import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import 'live_matches_view.dart';
import 'upcoming_matches_view.dart';
import 'completed_matches_view.dart';

class MatchesTab extends StatelessWidget {
  const MatchesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Container(
            color: AppColors.darkText,
            child: TabBar(
              labelStyle: AppTypography.tab,
              indicatorColor: AppColors.primaryDark,
              labelColor: AppColors.primaryDark,
              unselectedLabelColor: AppColors.themeText,
              tabs: const [
                Tab(text: 'Live'),
                Tab(text: 'Upcoming'),
                Tab(text: 'Completed'),
              ],
            ),
          ),
          const Expanded(
            child: TabBarView(
              children: [
                LiveMatchesView(),
                UpcomingMatchesView(),
                CompletedMatchesView(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
