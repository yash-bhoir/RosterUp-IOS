abstract final class ApiEndpoints {
  // Auth
  static const register = 'api/v1/auth/register';
  static const verifyMobile = 'api/v1/auth/verify-mobile';
  static const verifyOtp = 'api/v1/auth/verify-otp';
  static const resendOtp = 'api/v1/auth/re-send-otp';
  static const login = 'api/v1/auth/login';
  static const updateMobile = 'api/v1/auth/update-mobile';
  static const removeFcmToken = 'api/v1/auth/remove-fcm-token';
  static const refreshToken = 'api/v1/auth/referesh-token';

  // Profile
  static const updateProfilePic = 'api/v1/update-profile-pic';
  static const fetchProfilePic = 'api/v1/fetch-profile_pic';
  static const updateProfile = 'api/v1/update-profile';
  static const saveName = 'api/v1/save-name';
  static const getProfile = 'api/v1/get-profile';
  static const accountStats = 'api/v1/account/stats';
  static const deleteAccount = 'api/v1/delete-account-v1';
  static const timeoutAccount = 'api/v1/timeout-account';

  // Config
  static const basicSettings = 'api/v1/get-basic-settings';
  static const sports = 'api/v1/matches/sports';
  static const banners = 'api/v1/banners';

  // Matches
  static const upcomingMatches = 'api/v1/match/upcoming';
  static const myUpcomingMatches = 'api/v1/match/my-upcoming';
  static const completedMatches = 'api/v1/match/completed';
  static const liveMatches = 'api/v1/match/live';
  static const recentlyPlayed = 'api/v1/match/recently-played';
  static String matchDetail(String id) => 'api/v1/match/match-detail/$id';
  static const matchTeams = 'api/v1/match/teams';

  // Contests
  static String contestsByMatch(String id) => 'api/v1/contests/by-match-id/$id';
  static const contestFilters = 'api/v1/contests/filters';
  static const joinContest = 'api/v1/contests/join';
  static const createTeam = 'api/v1/contests/create-team';
  static const updateTeam = 'api/v1/contests/update-team';
  static String userTeams(String id) => 'api/v1/contests/user-teams/$id';
  static const userTeamsDetail = 'api/v1/contests/user-teams-detail';
  static String myContests(String id) => 'api/v1/contests/my-contests/$id';

  // Leaderboard
  static String usersLeaderboard(String id) => 'api/v1/contests/users-leaderboard/$id';
  static String myLeaderboard(String id) => 'api/v1/contests/my-leaderboard/$id';

  // Points & Scores
  static const fantasyPoints = 'api/v1/fantacy-points';
  static const playerScore = 'api/v1/player/score';
  static const teamScore = 'api/v1/team/score';

  // Winners
  static const contestWinners = 'api/v1/winners/contest-winners';
  static const megaContestWinners = 'api/v1/winners/mega-contest-winners-by-match';
  static const winnerFilters = 'api/v1/winners/filters';

  // Transactions
  static const getBalance = 'api/v1/transaction/get-balance';
  static const contestTransactions = 'api/v1/transaction/contests';
  static const otherTransactions = 'api/v1/transaction/others';

  // Rewards
  static const rewardCategories = 'api/v1/rewards/categories';
  static String couponsByCategory(String id) => 'api/v1/rewards/coupons-by-category-id/$id';
  static String couponDetail(String id) => 'api/v1/reward/coupon-detail/$id';
  static const userCoupons = 'api/v1/user/coupons';
  static const buyCoupon = 'api/v1/reward/buy-coupon';

  // Match Players
  static String matchPlayers(String id) => 'api/v1/match-players/get-match-players/$id';
}
