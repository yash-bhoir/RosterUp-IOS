class UserProfile {
  final int userId;
  final String userName;
  final String email;
  final String mobile;
  final String profilePic;
  final String referralCode;
  final String state;
  final String dateOfBirth;
  final String gender;

  const UserProfile({
    required this.userId,
    required this.userName,
    this.email = '',
    this.mobile = '',
    this.profilePic = '',
    this.referralCode = '',
    this.state = '',
    this.dateOfBirth = '',
    this.gender = '',
  });
}

class AccountStats {
  final int totalMatches;
  final int totalContests;
  final int totalWins;
  final double totalWinnings;

  const AccountStats({
    this.totalMatches = 0,
    this.totalContests = 0,
    this.totalWins = 0,
    this.totalWinnings = 0,
  });
}
