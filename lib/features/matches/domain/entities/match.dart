class MatchTeam {
  final int matchTeamId;
  final int teamId;
  final String teamName;
  final String code;
  final String icon;
  final double credits;
  final String sportsKey;
  final double totalPoint;
  final double tournamentPoints;
  final double selectedByPercent;
  final double captainByPercent;
  final double viceCaptainByPercent;

  const MatchTeam({
    required this.matchTeamId,
    required this.teamId,
    required this.teamName,
    required this.code,
    required this.icon,
    required this.credits,
    required this.sportsKey,
    this.totalPoint = 0,
    this.tournamentPoints = 0,
    this.selectedByPercent = 0,
    this.captainByPercent = 0,
    this.viceCaptainByPercent = 0,
  });
}

class Match {
  final int matchId;
  final String matchName;
  final String leagueName;
  final String sportsName;
  final String sportsKey;
  final String startAt;
  final String dayName;
  final String location;
  final String matchStatus;
  final int totalTeams;
  final int totalJoinedContests;
  final double totalAmountWon;
  final double highestPoints;
  final String highestPointTeam;
  final List<MatchTeam> teams;

  const Match({
    required this.matchId,
    required this.matchName,
    required this.leagueName,
    required this.sportsName,
    required this.sportsKey,
    required this.startAt,
    required this.dayName,
    required this.location,
    required this.matchStatus,
    this.totalTeams = 0,
    this.totalJoinedContests = 0,
    this.totalAmountWon = 0,
    this.highestPoints = 0,
    this.highestPointTeam = '',
    this.teams = const [],
  });

  bool get isTeamBattle =>
      sportsKey == 'bgmi' || sportsKey == 'pubg';
}

class PaginatedMatches {
  final List<Match> matches;
  final int page;
  final int totalPages;
  final int total;
  final int perPage;

  const PaginatedMatches({
    required this.matches,
    required this.page,
    required this.totalPages,
    required this.total,
    required this.perPage,
  });

  bool get hasMore => page < totalPages;
}
