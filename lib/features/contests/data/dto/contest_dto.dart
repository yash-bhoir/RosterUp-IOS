import '../../domain/entities/contest.dart';
import '../../../matches/data/dto/match_dto.dart';
import '../../domain/entities/match_detail.dart';

class ContestDto {
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

  ContestDto({
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

  factory ContestDto.fromJson(Map<String, dynamic> json) {
    return ContestDto(
      leagueId: json['league_id'] ?? 0,
      leagueName: json['league_name'] ?? '',
      matchId: json['match_id'] ?? 0,
      matchStatus: json['match_status'] ?? '',
      entryFees: json['entry_fees'] ?? 0,
      winningAmount: json['winning_amount'] ?? 0,
      firstPrize: json['first_prize'] ?? 0,
      numberOfSpots: json['number_of_spots'] ?? 0,
      remainingSpots: json['remaining_spots'] ?? 0,
      allowTeams: json['allow_teams'] ?? 1,
      userJoinedTeams: json['user_joined_teams'] ?? 0,
      isCurrentTeamJoined: json['is_current_team_joined'] ?? false,
      isActive: json['is_active'] ?? true,
      isFree: json['is_free'] ?? false,
      isGuaranteed: json['is_guaranted'] ?? false,
      isMegaLeague: json['is_mega_league'] ?? false,
    );
  }

  Contest toEntity() {
    return Contest(
      leagueId: leagueId,
      leagueName: leagueName,
      matchId: matchId,
      matchStatus: matchStatus,
      entryFees: entryFees,
      winningAmount: winningAmount,
      firstPrize: firstPrize,
      numberOfSpots: numberOfSpots,
      remainingSpots: remainingSpots,
      allowTeams: allowTeams,
      userJoinedTeams: userJoinedTeams,
      isCurrentTeamJoined: isCurrentTeamJoined,
      isActive: isActive,
      isFree: isFree,
      isGuaranteed: isGuaranteed,
      isMegaLeague: isMegaLeague,
    );
  }
}

class UserTeamDto {
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

  UserTeamDto({
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

  factory UserTeamDto.fromJson(Map<String, dynamic> json) {
    return UserTeamDto(
      userTeamId: json['user_team_id'] ?? 0,
      teamName: json['team_name'] ?? '',
      uniqueTeamName: json['unique_team_name'] ?? '',
      userId: json['user_id'] ?? 0,
      userName: json['user_name'] ?? '',
      rank: json['rank'] ?? 0,
      wonAmount: (json['won_amount'] ?? 0).toDouble(),
      totalPoints: (json['total_points'] ?? 0).toDouble(),
      profilePic: json['profile_pic'] ?? '',
      captain: json['captain'] ?? '',
      viceCaptain: json['voice_captain'] ?? '',
    );
  }

  UserTeam toEntity() {
    return UserTeam(
      userTeamId: userTeamId,
      teamName: teamName,
      uniqueTeamName: uniqueTeamName,
      userId: userId,
      userName: userName,
      rank: rank,
      wonAmount: wonAmount,
      totalPoints: totalPoints,
      profilePic: profilePic,
      captain: captain,
      viceCaptain: viceCaptain,
    );
  }
}

class MatchDetailDto {
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
  final List<MatchTeamDto> teams;

  MatchDetailDto({
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

  factory MatchDetailDto.fromJson(Map<String, dynamic> json) {
    final sport = json['tournament']?['sport'];
    return MatchDetailDto(
      matchId: json['match_id'] ?? 0,
      name: json['name'] ?? '',
      shortName: json['short_name'] ?? '',
      subTitle: json['sub_title'] ?? '',
      location: json['location'] ?? '',
      dayName: json['day_name'] ?? '',
      startAt: json['start_at'] ?? '',
      format: json['format'] ?? '',
      status: json['status'] ?? '',
      playStatus: json['play_status'] ?? '',
      totalTeams: json['total_teams'] ?? 0,
      totalJoinedContests: json['total_joined_contests'] ?? 0,
      totalAmountWon: (json['total_amount_won'] ?? 0).toDouble(),
      highestPoints: (json['highest_points'] ?? 0).toDouble(),
      highestPointTeam: json['highest_point_team'] ?? '',
      isLineupOut: json['is_lineup_out'] ?? false,
      messages: json['messages']?.toString(),
      winner: json['winner']?.toString(),
      sportsKey: sport?['sports_key'] ?? json['sports_key'] ?? '',
      sportsName: sport?['sports_name'] ?? json['sports_name'] ?? '',
      teams: (json['teams'] as List<dynamic>?)
              ?.map((e) => MatchTeamDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  MatchDetail toEntity() {
    return MatchDetail(
      matchId: matchId,
      name: name,
      shortName: shortName,
      subTitle: subTitle,
      location: location,
      dayName: dayName,
      startAt: startAt,
      format: format,
      status: status,
      playStatus: playStatus,
      totalTeams: totalTeams,
      totalJoinedContests: totalJoinedContests,
      totalAmountWon: totalAmountWon,
      highestPoints: highestPoints,
      highestPointTeam: highestPointTeam,
      isLineupOut: isLineupOut,
      messages: messages,
      winner: winner,
      sportsKey: sportsKey,
      sportsName: sportsName,
      teams: teams.map((t) => t.toEntity()).toList(),
    );
  }
}

class LeaderboardEntryDto {
  final int userTeamId;
  final String teamName;
  final String userName;
  final String profilePic;
  final int rank;
  final double totalPoints;
  final double wonAmount;

  LeaderboardEntryDto({
    required this.userTeamId,
    required this.teamName,
    required this.userName,
    required this.profilePic,
    required this.rank,
    required this.totalPoints,
    required this.wonAmount,
  });

  factory LeaderboardEntryDto.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntryDto(
      userTeamId: json['user_team_id'] ?? 0,
      teamName: json['team_name'] ?? '',
      userName: json['user_name'] ?? '',
      profilePic: json['profile_pic'] ?? '',
      rank: json['rank'] ?? 0,
      totalPoints: (json['total_points'] ?? 0).toDouble(),
      wonAmount: (json['won_amount'] ?? 0).toDouble(),
    );
  }

  LeaderboardEntry toEntity() {
    return LeaderboardEntry(
      userTeamId: userTeamId,
      teamName: teamName,
      userName: userName,
      profilePic: profilePic,
      rank: rank,
      totalPoints: totalPoints,
      wonAmount: wonAmount,
    );
  }
}

class WinningSlotDto {
  final int rankFrom;
  final int rankTo;
  final double prize;

  WinningSlotDto({
    required this.rankFrom,
    required this.rankTo,
    required this.prize,
  });

  factory WinningSlotDto.fromJson(Map<String, dynamic> json) {
    return WinningSlotDto(
      rankFrom: json['rank_from'] ?? json['from'] ?? 0,
      rankTo: json['rank_to'] ?? json['to'] ?? 0,
      prize: (json['prize'] ?? json['amount'] ?? 0).toDouble(),
    );
  }

  WinningSlot toEntity() {
    return WinningSlot(rankFrom: rankFrom, rankTo: rankTo, prize: prize);
  }
}
