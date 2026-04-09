import '../../../matches/domain/entities/match.dart';

class MatchDetail {
  final int matchId;
  final String name;
  final String shortName;
  final String subTitle;
  final String location;
  final String dayName;
  final String startAt;
  final String format;
  final String status;
  final String playStatus;
  final int totalTeams;
  final int totalJoinedContests;
  final double totalAmountWon;
  final double highestPoints;
  final String highestPointTeam;
  final bool isLineupOut;
  final String? messages;
  final String? winner;
  final String sportsKey;
  final String sportsName;
  final List<MatchTeam> teams;

  const MatchDetail({
    required this.matchId,
    required this.name,
    this.shortName = '',
    this.subTitle = '',
    required this.location,
    required this.dayName,
    required this.startAt,
    this.format = '',
    required this.status,
    this.playStatus = '',
    this.totalTeams = 0,
    this.totalJoinedContests = 0,
    this.totalAmountWon = 0,
    this.highestPoints = 0,
    this.highestPointTeam = '',
    this.isLineupOut = false,
    this.messages,
    this.winner,
    required this.sportsKey,
    required this.sportsName,
    this.teams = const [],
  });

  bool get isTeamBattle =>
      sportsKey == 'bgmi' || sportsKey == 'pubg';

  bool get isStarted =>
      status == 'started' || status == 'live';
}
