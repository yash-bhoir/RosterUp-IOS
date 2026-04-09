class Winner {
  final int userId;
  final String userName;
  final String profilePic;
  final String matchName;
  final String leagueName;
  final double wonAmount;
  final int rank;
  final String sportsKey;
  final String date;

  const Winner({
    required this.userId,
    required this.userName,
    this.profilePic = '',
    required this.matchName,
    required this.leagueName,
    required this.wonAmount,
    this.rank = 0,
    this.sportsKey = '',
    this.date = '',
  });
}
