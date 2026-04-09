import '../../domain/entities/player.dart';

class PlayerDto {
  final int matchTeamPlayerId;
  final int matchTeamId;
  final String playerKey;
  final String name;
  final String icon;
  final double credits;
  final double tournamentPoints;
  final double selectedByPercent;
  final double captainByPercent;
  final double viceCaptainByPercent;
  final bool isPlayingXi;
  final String teamName;

  PlayerDto({
    required this.matchTeamPlayerId,
    required this.matchTeamId,
    required this.playerKey,
    required this.name,
    this.icon = '',
    this.credits = 0,
    this.tournamentPoints = 0,
    this.selectedByPercent = 0,
    this.captainByPercent = 0,
    this.viceCaptainByPercent = 0,
    this.isPlayingXi = false,
    this.teamName = '',
  });

  factory PlayerDto.fromJson(Map<String, dynamic> json) {
    return PlayerDto(
      matchTeamPlayerId: json['match_team_player_id'] ?? 0,
      matchTeamId: json['match_team_id'] ?? 0,
      playerKey: json['player_key'] ?? '',
      name: json['name'] ?? '',
      icon: json['icon'] ?? '',
      credits: (json['credits'] ?? 0).toDouble(),
      tournamentPoints: (json['tournament_points'] ?? 0).toDouble(),
      selectedByPercent: (json['selected_by_percent'] ?? 0).toDouble(),
      captainByPercent: (json['captain_by_percent'] ?? 0).toDouble(),
      viceCaptainByPercent: (json['voice_captain_by_percent'] ?? 0).toDouble(),
      isPlayingXi: json['is_playing_xi'] ?? false,
      teamName: json['team_name'] ?? '',
    );
  }

  Player toEntity() {
    return Player(
      matchTeamPlayerId: matchTeamPlayerId,
      matchTeamId: matchTeamId,
      playerKey: playerKey,
      name: name,
      icon: icon,
      credits: credits,
      tournamentPoints: tournamentPoints,
      selectedByPercent: selectedByPercent,
      captainByPercent: captainByPercent,
      viceCaptainByPercent: viceCaptainByPercent,
      isPlayingXi: isPlayingXi,
      teamName: teamName,
    );
  }
}

class MatchTeamPlayersDto {
  final int matchTeamId;
  final int teamId;
  final String teamName;
  final String code;
  final String icon;
  final String sportsKey;
  final List<PlayerDto> players;

  MatchTeamPlayersDto({
    required this.matchTeamId,
    required this.teamId,
    required this.teamName,
    required this.code,
    required this.icon,
    required this.sportsKey,
    required this.players,
  });

  factory MatchTeamPlayersDto.fromJson(Map<String, dynamic> json) {
    return MatchTeamPlayersDto(
      matchTeamId: json['match_team_id'] ?? 0,
      teamId: json['team_id'] ?? 0,
      teamName: json['team_name'] ?? '',
      code: json['code'] ?? '',
      icon: json['icon'] ?? '',
      sportsKey: json['sports_key'] ?? '',
      players: (json['players'] as List<dynamic>?)
              ?.map((e) => PlayerDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
