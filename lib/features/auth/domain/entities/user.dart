class User {
  final String userId;
  final String name;
  final String email;
  final String phoneNumber;
  final String? profilePhoto;
  final String? dob;
  final String? gender;
  final String? city;
  final String? state;
  final String? pinCode;
  final String? address;
  final String? referralCode;
  final String? uniqueTeamName;
  final bool isActive;
  final bool allowNotifications;

  const User({
    required this.userId,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.profilePhoto,
    this.dob,
    this.gender,
    this.city,
    this.state,
    this.pinCode,
    this.address,
    this.referralCode,
    this.uniqueTeamName,
    this.isActive = true,
    this.allowNotifications = true,
  });
}
