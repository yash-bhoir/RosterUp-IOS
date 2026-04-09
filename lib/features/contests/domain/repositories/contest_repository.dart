import '../../../../core/errors/result.dart';
import '../entities/contest.dart';
import '../entities/match_detail.dart';

abstract class ContestRepository {
  Future<Result<MatchDetail>> getMatchDetail(String matchId);
  Future<Result<PaginatedContests>> getContestsByMatch(
    String matchId, {
    int page = 1,
    int perPage = 20,
    int? numberOfTeams,
    int? prizePool,
  });
  Future<Result<List<MyContest>>> getMyContests(String matchId);
  Future<Result<ContestFilter>> getContestFilters();
  Future<Result<void>> joinContest({
    required int leagueId,
    required int matchId,
    required int userTeamId,
  });
  Future<Result<List<LeaderboardEntry>>> getLeaderboard(
    String leagueId, {
    int page = 1,
    int perPage = 20,
  });
  Future<Result<List<WinningSlot>>> getWinnings(String leagueId);
}
