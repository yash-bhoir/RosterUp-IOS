# Android Audit - RosterUp

## App Identity
- **Package:** `com.aadil.rosterup`
- **Min SDK:** 26 (Android 8.0)
- **Target SDK:** 34
- **Version:** 1.19 (code 19)
- **Architecture:** MVVM + Hilt DI + Navigation Component

---

## Screen Inventory (30 Activities + 28 Fragments)

### Auth Flow
| Screen | Type | File |
|--------|------|------|
| Splash | Activity | `SplashAppActivity.kt` |
| Intro Slider | Activity | `IntroSliderActivity.kt` |
| Login | Activity | `LoginActivity.kt` |
| Register | Activity | `RegisterActivity.kt` |
| OTP Verification | Activity | `OTPVerificationActivity.kt` |
| Username Setup | Activity | `UserNameActivity.kt` |
| Update Phone | Activity | `UpdatePhoneNumberActivity.kt` |

### Main Hub (HomeActivity + Bottom Navigation)
| Tab | Fragment | Description |
|-----|----------|-------------|
| Home | `HomeFragment` | Banners, upcoming matches |
| My Matches | `MatchFragment` | Container with 3 sub-tabs |
| Rewards | `RewardFragment` | Reward categories |
| Chat | `ChatFragment` | Chat/community |
| Winners | `WinnersFragment` | Winner showcase |

### Match Sub-Tabs (inside MatchFragment)
| Tab | Fragment |
|-----|----------|
| Live | `LiveMatchesFragment` |
| Upcoming | `UpcomingMatchesFragment` |
| Completed | `CompletedMatchesFragment` |

### Contest Flow
| Screen | Type | Description |
|--------|------|-------------|
| Join Contest | Activity | `JoinContestActivity` - tabs: All/My Contest/My Team |
| All Contests | Fragment | `AllContestFragment` - browse contests |
| Contest Filter | Fragment | `ContestFilterFragment` - bottom sheet filter |
| My Contests | Fragment | `MyContestFragment` - joined contests |
| My Teams | Fragment | `MyTeamFragment` - user's teams |
| Contest Detail | Activity | `ContestDetailActivity` - leaderboard + winnings |
| Leaderboard | Fragment | `LeaderBoardFragment` |
| Winnings | Fragment | `WinningsFragment` |

### Team Creation Flow
| Step | Screen | Description |
|------|--------|-------------|
| 1 | `CreateTeamActivity` | Select teams (BGMI/PUBG) or players (CSGO) |
| 2 | `CreatePlayersActivity` | Select individual players |
| 3 | `ChooseCaptainActivity` | Pick captain & vice-captain |
| 4 | `TeamPreviewActivity` | Review team before submit |

### Player & Scores
| Screen | Type |
|--------|------|
| Player Info | `PlayerInfoActivity` |
| Fantasy Points | `FantasyPointsActivity` |
| All Teams View | `AllTeamActivity` |
| My Teams | `MyTeamsActivity` |

### Profile & Account
| Screen | Type |
|--------|------|
| Profile Menu | `ProfileActivity` |
| User Profile Edit | `UserProfileActivity` |
| Profile Pic | `ProfilePicFragment` (bottom sheet) |
| Other User Profile | `OtherProfileActivity` |
| Recent Matches | `RecentMatchesActivity` |
| Delete Account | `DeleteActivity` → 3 fragments |

### Wallet & Transactions
| Screen | Type |
|--------|------|
| Balance | `BalanceActivity` |
| Add Cash | `AddCashActivity` |
| Transactions | `TransactionActivity` |

### Rewards
| Screen | Type |
|--------|------|
| Reward Categories | `RewardCategoryFragment` |
| All Rewards | `AllRewardsFragment` |
| My Rewards | `MyRewardsFragment` |
| Purchase Reward | `PurchaseRewardsFragment` |

### Other
| Screen | Type |
|--------|------|
| Refer & Earn | `ReferEarnFragment` |
| Support | `SupportFragment` |
| WebView | `WebViewActivity` |
| Winner Details | `WinnerDetailsActivity` |
| Winner Filter | `WinnersFilterFragment` |

---

## Navigation Graph

```
SplashApp
  ├─ (not logged in) → IntroSlider → Login
  │                                     ├─ Register → OTP → Username → Home
  │                                     └─ OTP → Home
  └─ (logged in) → Home

Home (Bottom Nav)
  ├─ Tab: Home → JoinContest → ContestDetail
  ├─ Tab: Matches (Live/Upcoming/Completed) → JoinContest
  ├─ Tab: Rewards → AllRewards → PurchaseReward
  ├─ Tab: Chat
  └─ Tab: Winners → WinnerDetails

Home (Drawer)
  ├─ My Balance → AddCash / Transactions
  ├─ My Info → UserProfile
  ├─ Help & Support
  ├─ Refer & Earn
  ├─ Delete Account → DeleteRequest / Suspend
  └─ Web links → WebView

JoinContest
  ├─ All Contests → ContestDetail (Leaderboard + Winnings)
  ├─ My Contests
  └─ My Teams → CreateTeam → CreatePlayers → ChooseCaptain → TeamPreview
```

---

## API Endpoints (37 total)

### Authentication
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `api/v1/auth/register` | Register with mobile |
| POST | `api/v1/auth/verify-mobile` | Verify mobile number |
| POST | `api/v1/auth/verify-otp` | Verify OTP |
| POST | `api/v1/auth/re-send-otp` | Resend OTP |
| POST | `api/v1/auth/login` | Login with mobile |
| POST | `api/v1/auth/update-mobile` | Update phone number |
| POST | `api/v1/auth/remove-fcm-token` | Remove FCM token |
| POST | `api/v1/auth/referesh-token` | Refresh access token |

### Profile
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `api/v1/update-profile-pic` | Upload profile pic (multipart) |
| GET | `api/v1/fetch-profile_pic` | Get profile pic |
| POST | `api/v1/update-profile` | Update profile details |
| POST | `api/v1/save-name` | Save username |
| GET | `api/v1/get-profile` | Get profile |
| GET | `api/v1/account/stats` | User stats |
| POST | `api/v1/delete-account-v1` | Delete account |
| POST | `api/v1/timeout-account` | Suspend account |

### Config & Home
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `api/v1/get-basic-settings` | App settings |
| GET | `api/v1/matches/sports` | Available sports |
| GET | `api/v1/banners` | Home banners |

### Matches
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `api/v1/match/upcoming` | Upcoming matches (paginated) |
| GET | `api/v1/match/my-upcoming` | User's upcoming matches |
| GET | `api/v1/match/completed` | Completed matches (paginated) |
| GET | `api/v1/match/live` | Live matches |
| GET | `api/v1/match/recently-played` | Recent matches |
| GET | `api/v1/match/match-detail/{id}` | Match detail |
| GET | `api/v1/match/teams?match_id=` | Match teams |

### Contests
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `api/v1/contests/by-match-id/{id}` | Leagues by match |
| GET | `api/v1/contests/filters` | Contest filters |
| POST | `api/v1/contests/join` | Join contest |
| POST | `api/v1/contests/create-team` | Create team |
| POST | `api/v1/contests/update-team` | Update team |
| GET | `api/v1/contests/user-teams/{id}` | User teams by match |
| GET | `api/v1/contests/user-teams-detail` | Team details |
| GET | `api/v1/contests/my-contests/{id}` | User's contests |

### Leaderboard & Points
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `api/v1/contests/users-leaderboard/{id}` | Contest leaderboard |
| GET | `api/v1/contests/my-leaderboard/{id}` | My leaderboard |
| GET | `api/v1/fantacy-points` | Fantasy point rules |
| GET | `api/v1/player/score` | Player score |
| GET | `api/v1/team/score` | Team score |

### Winners
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `api/v1/winners/contest-winners` | Contest winners (paginated) |
| GET | `api/v1/winners/mega-contest-winners-by-match` | Winners by match |
| GET | `api/v1/winners/filters` | Winner filters |

### Transactions
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `api/v1/transaction/get-balance` | Wallet balance |
| GET | `api/v1/transaction/contests` | Contest transactions |
| GET | `api/v1/transaction/others` | Other transactions |

### Rewards
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `api/v1/rewards/categories` | Reward categories |
| GET | `api/v1/rewards/coupons-by-category-id/{id}` | Coupons by category |
| GET | `api/v1/reward/coupon-detail/{id}` | Coupon detail |
| GET | `api/v1/user/coupons` | My coupons |
| POST | `api/v1/reward/buy-coupon` | Buy coupon |

---

## Auth Flow

1. **Login**: Phone number → POST `/auth/login` → OTP returned
2. **OTP Verify**: Enter OTP → POST `/auth/verify-otp` → access_token + refresh_token
3. **Token Storage**: SharedPreferences (`ACCESS_TOKEN`, `REFRESH_TOKEN`)
4. **Header Injection**: `Authorization: Bearer {token}` via OkHttp interceptor
5. **Auto-Refresh**: On 401 → POST `/auth/referesh-token` → retry original request
6. **Logout**: Clear SharedPreferences (preserve `REFERRED_CODE`), set `IS_LOGIN=false`
7. **VPN Block**: Interceptor blocks all requests when VPN detected

---

## Local Storage (SharedPreferences only)

| Key | Type | Description |
|-----|------|-------------|
| `IS_LOGIN` | Boolean | Login state |
| `IS_SLIDER_SHOWN` | Boolean | Intro shown flag |
| `ACCESS_TOKEN` | String | JWT access token |
| `REFRESH_TOKEN` | String | Refresh token |
| `FCM_TOKEN` | String | Firebase messaging token |
| `UNIQUE_DEVICE_ID` | String | Android device ID |
| `REFERRED_CODE` | String | Referral code (preserved on logout) |

No Room database, SQLite, or DataStore.

---

## Third-Party SDKs

| SDK | Version | Purpose |
|-----|---------|---------|
| Dagger Hilt | 2.51.1 | Dependency injection |
| Retrofit | 2.9.0 | REST API client |
| OkHttp | 4.11.0 | HTTP + interceptors |
| Gson | 2.10.1 | JSON parsing |
| Glide | 4.16.0 | Image loading |
| Firebase Messaging | 24.0.0 | Push notifications |
| Firebase Database | 21.0.0 | Realtime DB |
| Play Services Auth | 18.1.0 | SMS auto-retrieval |
| Play Services Ads | 23.2.0 | AdMob |
| Play App Update | 2.1.0 | In-app updates |
| Navigation | 2.7.7 | Fragment navigation |
| Paging 3 | 3.3.0 | Infinite scroll |
| SDP/SSP | 1.1.1 | Scalable dimensions |
| FlexBox | 3.0.0 | Flexible layouts |
| Balloon | 1.4.7 | Tooltips |
| OTP View | 1.0 | OTP input |
| EasyPermissions | 2.1.0 | Runtime permissions |
| Install Referrer | 2.2 | Attribution tracking |

**No payment gateway** (Roster Coins only, no real money).

---

## Permissions

| Permission | Purpose |
|------------|---------|
| INTERNET | API calls |
| ACCESS_NETWORK_STATE | Connectivity check |
| CALL_PHONE | Support call |
| POST_NOTIFICATIONS | Push notifications (API 33+) |
| READ_MEDIA_IMAGES | Profile pic (API 33+) |
| CAMERA | Profile pic capture |
| AD_ID | Google Ads |

---

## Background Work

- **Firebase Messaging Service**: Push notifications
- **Handler-based polling**: Match updates every 25 seconds (not WorkManager)
- **CountDownTimer**: Match countdown display
- No WorkManager, no background Services, no AlarmManager

---

## Business Rules

### Team Creation (BGMI/PUBG)
- Select exactly 5 teams
- Max 100 credits total
- Must pick 1 Captain (2x points) and 1 Vice-Captain (1.5x points)

### Team Creation (CSGO)
- Select players instead of teams
- Same captain/VC multiplier rules

### Phone Validation
- Must start with 6-9
- Exactly 10 digits

### Profile Validation
- Name, Email (format check), DOB, Address, City, Pin Code, State, Gender
- States: All 28 Indian states + 8 UTs
- Gender: Male, Female, Others

### Multi-Sport
- Sports keys: bgmi, pubg, csgo, valo
- Point metrics fetched per sport from API
