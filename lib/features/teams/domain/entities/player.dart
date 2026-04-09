class Player {
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

  // Local UI state
  final bool isSelected;
  final bool isCaptain;
  final bool isViceCaptain;

  const Player({
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
    this.isSelected = false,
    this.isCaptain = false,
    this.isViceCaptain = false,
  });

  Player copyWith({
    bool? isSelected,
    bool? isCaptain,
    bool? isViceCaptain,
  }) {
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
      isSelected: isSelected ?? this.isSelected,
      isCaptain: isCaptain ?? this.isCaptain,
      isViceCaptain: isViceCaptain ?? this.isViceCaptain,
    );
  }
}

class TeamComposition {
  final List<Player> players;
  final double totalCredits;
  final int maxCredits;
  final int teamSize;

  const TeamComposition({
    required this.players,
    this.totalCredits = 0,
    this.maxCredits = 100,
    this.teamSize = 5,
  });

  List<Player> get selectedPlayers =>
      players.where((p) => p.isSelected).toList();

  int get selectedCount => selectedPlayers.length;
  double get creditsUsed =>
      selectedPlayers.fold(0, (sum, p) => sum + p.credits);
  double get creditsRemaining => maxCredits - creditsUsed;
  bool get isTeamFull => selectedCount >= teamSize;
  Player? get captain => selectedPlayers.cast<Player?>().firstWhere(
        (p) => p!.isCaptain,
        orElse: () => null,
      );
  Player? get viceCaptain => selectedPlayers.cast<Player?>().firstWhere(
        (p) => p!.isViceCaptain,
        orElse: () => null,
      );
  bool get isValid =>
      isTeamFull && captain != null && viceCaptain != null;
}
