class Contest {
  final int leagueId;
  final String leagueName;
  final int matchId;
  final String matchStatus;
  final int entryFees;
  final int winningAmount;
  final int firstPrize;
  final int numberOfSpots;
  final int remainingSpots;
  final int allowTeams;
  final int userJoinedTeams;
  final bool isCurrentTeamJoined;
  final bool isActive;
  final bool isFree;
  final bool isGuaranteed;
  final bool isMegaLeague;

  const Contest({
    required this.leagueId,
    required this.leagueName,
    required this.matchId,
    required this.matchStatus,
    this.entryFees = 0,
    this.winningAmount = 0,
    this.firstPrize = 0,
    this.numberOfSpots = 0,
    this.remainingSpots = 0,
    this.allowTeams = 1,
    this.userJoinedTeams = 0,
    this.isCurrentTeamJoined = false,
    this.isActive = true,
    this.isFree = false,
    this.isGuaranteed = false,
    this.isMegaLeague = false,
  });

  int get filledSpots => numberOfSpots - remainingSpots;
  double get spotsProgress =>
      numberOfSpots > 0 ? filledSpots / numberOfSpots : 0;
  bool get isFull => remainingSpots <= 0;
}

class PaginatedContests {
  final List<Contest> contests;
  final int page;
  final int totalPages;

  const PaginatedContests({
    required this.contests,
    required this.page,
    required this.totalPages,
  });

  bool get hasMore => page < totalPages;
}

class UserTeam {
  final int userTeamId;
  final String teamName;
  final String uniqueTeamName;
  final int userId;
  final String userName;
  final int rank;
  final double wonAmount;
  final double totalPoints;
  final String profilePic;
  final String captain;
  final String viceCaptain;

  const UserTeam({
    required this.userTeamId,
    required this.teamName,
    required this.uniqueTeamName,
    required this.userId,
    required this.userName,
    this.rank = 0,
    this.wonAmount = 0,
    this.totalPoints = 0,
    this.profilePic = '',
    this.captain = '',
    this.viceCaptain = '',
  });
}

class MyContest {
  final Contest league;
  final List<UserTeam> teams;

  const MyContest({required this.league, required this.teams});
}

class LeaderboardEntry {
  final int userTeamId;
  final String teamName;
  final String userName;
  final String profilePic;
  final int rank;
  final double totalPoints;
  final double wonAmount;

  const LeaderboardEntry({
    required this.userTeamId,
    required this.teamName,
    required this.userName,
    required this.profilePic,
    required this.rank,
    required this.totalPoints,
    required this.wonAmount,
  });
}

class WinningSlot {
  final int rankFrom;
  final int rankTo;
  final double prize;

  const WinningSlot({
    required this.rankFrom,
    required this.rankTo,
    required this.prize,
  });

  String get rankLabel =>
      rankFrom == rankTo ? '#$rankFrom' : '#$rankFrom - #$rankTo';
}

class ContestFilter {
  final List<int> teamCounts;
  final List<int> prizePools;

  const ContestFilter({
    this.teamCounts = const [],
    this.prizePools = const [],
  });
}
