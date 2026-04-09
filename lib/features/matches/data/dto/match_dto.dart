import '../../domain/entities/match.dart';

class MatchTeamDto {
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

  MatchTeamDto({
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

  factory MatchTeamDto.fromJson(Map<String, dynamic> json) {
    return MatchTeamDto(
      matchTeamId: json['match_team_id'] ?? 0,
      teamId: json['team_id'] ?? 0,
      teamName: json['team_name'] ?? '',
      code: json['code'] ?? '',
      icon: json['icon'] ?? '',
      credits: (json['credits'] ?? 0).toDouble(),
      sportsKey: json['sports_key'] ?? '',
      totalPoint: (json['total_point'] ?? 0).toDouble(),
      tournamentPoints: (json['tournament_points'] ?? 0).toDouble(),
      selectedByPercent: (json['selected_by_percent'] ?? 0).toDouble(),
      captainByPercent: (json['captain_by_percent'] ?? 0).toDouble(),
      viceCaptainByPercent: (json['voice_captain_by_percent'] ?? 0).toDouble(),
    );
  }

  MatchTeam toEntity() {
    return MatchTeam(
      matchTeamId: matchTeamId,
      teamId: teamId,
      teamName: teamName,
      code: code,
      icon: icon,
      credits: credits,
      sportsKey: sportsKey,
      totalPoint: totalPoint,
      tournamentPoints: tournamentPoints,
      selectedByPercent: selectedByPercent,
      captainByPercent: captainByPercent,
      viceCaptainByPercent: viceCaptainByPercent,
    );
  }
}

class MatchDto {
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
  final List<MatchTeamDto> teams;

  MatchDto({
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

  factory MatchDto.fromJson(Map<String, dynamic> json) {
    return MatchDto(
      matchId: json['match_id'] ?? 0,
      matchName: json['match_name'] ?? '',
      leagueName: json['league_name'] ?? '',
      sportsName: json['sports_name'] ?? '',
      sportsKey: json['sports_key'] ?? '',
      startAt: json['start_at'] ?? '',
      dayName: json['day_name'] ?? '',
      location: json['location'] ?? '',
      matchStatus: json['match_status'] ?? '',
      totalTeams: json['total_teams'] ?? 0,
      totalJoinedContests: json['total_joined_contests'] ?? 0,
      totalAmountWon: (json['total_amount_won'] ?? 0).toDouble(),
      highestPoints: (json['highest_points'] ?? 0).toDouble(),
      highestPointTeam: json['highest_point_team'] ?? '',
      teams: (json['teams'] as List<dynamic>?)
              ?.map((e) => MatchTeamDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Match toEntity() {
    return Match(
      matchId: matchId,
      matchName: matchName,
      leagueName: leagueName,
      sportsName: sportsName,
      sportsKey: sportsKey,
      startAt: startAt,
      dayName: dayName,
      location: location,
      matchStatus: matchStatus,
      totalTeams: totalTeams,
      totalJoinedContests: totalJoinedContests,
      totalAmountWon: totalAmountWon,
      highestPoints: highestPoints,
      highestPointTeam: highestPointTeam,
      teams: teams.map((t) => t.toEntity()).toList(),
    );
  }
}

class MatchesPagingResponseDto {
  final int perPage;
  final int total;
  final int page;
  final int totalPages;
  final List<MatchDto> matches;

  MatchesPagingResponseDto({
    required this.perPage,
    required this.total,
    required this.page,
    required this.totalPages,
    required this.matches,
  });

  factory MatchesPagingResponseDto.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is Map<String, dynamic>) {
      return MatchesPagingResponseDto(
        perPage: data['per_page'] ?? 20,
        total: data['total'] ?? 0,
        page: data['page'] ?? 1,
        totalPages: data['total_pages'] ?? 1,
        matches: (data['data'] as List<dynamic>?)
                ?.map((e) => MatchDto.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
      );
    }
    return MatchesPagingResponseDto(
      perPage: 20,
      total: 0,
      page: 1,
      totalPages: 1,
      matches: [],
    );
  }

  PaginatedMatches toEntity() {
    return PaginatedMatches(
      matches: matches.map((m) => m.toEntity()).toList(),
      page: page,
      totalPages: totalPages,
      total: total,
      perPage: perPage,
    );
  }
}

class MatchesListResponseDto {
  final List<MatchDto> matches;

  MatchesListResponseDto({required this.matches});

  factory MatchesListResponseDto.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is List) {
      return MatchesListResponseDto(
        matches: data
            .where((e) => e != null)
            .map((e) => MatchDto.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    }
    return MatchesListResponseDto(matches: []);
  }
}
