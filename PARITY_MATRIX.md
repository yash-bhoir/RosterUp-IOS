# Parity Matrix - RosterUp Flutter Clone

## Implementation Order & Risk Assessment

| # | Screen | Android Behavior | Design | Flutter Plan | Risks |
|---|--------|-----------------|--------|--------------|-------|
| **AUTH FLOW** |
| 1 | Splash | Checks login state, referral, permissions. Routes to Intro/Login/Home. 1.5s scale+fade animation | Black bg, centered logo, scale animation | `SplashScreen` with `go_router` redirect logic. Replicate animation with `AnimationController` | Timer-based routing must match exactly |
| 2 | Intro Slider | ViewPager with 3 slides. Shows only once (IS_SLIDER_SHOWN flag) | Image slides with dot indicators | `PageView` with `SmoothPageIndicator`. Store flag in `shared_preferences` | Asset parity - need exact slide images |
| 3 | Login | Phone input (10 digits, starts 6-9). Country flag. POST /auth/login | Dark bg, orange button, phone input with flag | `TextFormField` with validator. Dio POST. Same validation rules | Phone validation regex must match |
| 4 | Register | Name + phone + referral code. POST /auth/register | Same dark theme, 3 input fields | Same pattern as Login screen | Referral code flow |
| 5 | OTP Verify | 6-digit OTP input. SMS auto-retrieval. 60s resend timer. Stores tokens | OTP boxes, countdown timer | `pin_code_fields` package. `sms_autofill` for auto-read. Timer with `CountdownTimer` | SMS Retriever API parity on Android, iOS fallback |
| 6 | Username | Text input for unique team name. POST /save-name | Single input + submit button | Simple form screen | None |
| 7 | Update Phone | Change phone number. Sends OTP to new number | Same as login input style | Reuse login input component | None |
| **MAIN HUB** |
| 8 | Home (Shell) | DrawerLayout + BottomNav + NavHost. 5 tabs. Drawer with profile/settings/links | Dark shell, orange bottom nav, drawer | `Scaffold` with `NavigationBar` + `Drawer`. `go_router` with `StatefulShellRoute` | Bottom nav state preservation across tabs |
| 9 | Home Tab | Banner carousel, upcoming match cards, "View All" links | Auto-sliding banners, match cards below | `CarouselSlider` + match card `ListView` | Banner auto-scroll timing |
| 10 | Matches Tab | TabBar: Live/Upcoming/Completed. Each has paginated match list | 3 sub-tabs with match card lists | `TabBar` + `TabBarView`. Each tab uses `Paginator` | Pagination + pull-to-refresh parity |
| 11 | Live Matches | Real-time match cards. 25s polling. CountDownTimer | Match cards with live indicator | `Timer.periodic(25s)` for API polling. Animated countdown | Polling interval must match |
| 12 | Upcoming Matches | Paginated list. Countdown to match start | Match cards with countdown timer | Paging with `infinite_scroll_pagination`. `CountdownTimer` widget | Timer accuracy |
| 13 | Completed Matches | Paginated list of finished matches. Shows points/winners | Match cards with results | Same pagination pattern | None |
| 14 | Rewards Tab | Category tabs + reward grid. 3 sub-fragments | Tab bar + grid layout | `TabBar` with All/My Rewards. Grid of reward cards | None |
| 15 | Chat Tab | Chat/community feature | Chat interface | Depends on backend (Firebase Realtime DB) | Firebase Realtime DB integration |
| 16 | Winners Tab | Paginated winner cards with filters | Winner cards + filter bottom sheet | `infinite_scroll_pagination` + filter `BottomSheet` | None |
| **CONTEST FLOW** |
| 17 | Join Contest | 3 tabs: All Contests / My Contests / My Teams. Match header | Tab layout with contest cards | `TabBar` + 3 tab views. Match info header widget | Tab state preservation |
| 18 | All Contests | Paginated contest/league list. Filter bottom sheet. Join button | Contest cards with entry fee, spots, prize | `infinite_scroll_pagination`. Filter `BottomSheet` | Contest filter logic must match exactly |
| 19 | Contest Filter | Bottom sheet with checkboxes. Entry fee ranges, contest types | Dark bottom sheet, checkbox list | `showModalBottomSheet` with filter state | Filter param mapping to API |
| 20 | My Contests | User's joined contests with team info | Contest cards with team names | Filtered list from API | None |
| 21 | My Teams | User's created teams for a match | Team cards with edit/preview | Team card list with actions | None |
| 22 | Contest Detail | Leaderboard + Winnings tabs. Shows ranks, points, prizes | 2 tabs: leaderboard table + prize table | `TabBar` with `LeaderboardTab` + `WinningsTab` | Real-time leaderboard updates |
| 23 | Leaderboard | Paginated user rankings. Highlights current user | Table with rank, name, points, won | `ListView` with highlighted current user row | Pagination + highlight logic |
| 24 | Winnings | Prize distribution table (rank ranges → amounts) | Simple table layout | `DataTable` or custom `ListView` | None |
| **TEAM CREATION** |
| 25 | Create Team | Select 5 teams. Credit system (max 100). Sort/filter | Team cards with checkboxes, credit counter top | `ListView` with selection state. Credit counter widget | Credit calculation must match. Max 5 teams |
| 26 | Create Players | Select players from teams. Credit allocation | Player cards with team grouping | Grouped `ListView` with player selection | Player credit system |
| 27 | Choose Captain | Pick Captain (2x) and Vice-Captain (1.5x) from selected | Player cards with C/VC badges | `GridView` with captain selection logic | Must enforce exactly 1 C + 1 VC |
| 28 | Team Preview | Review full team before submitting. Background image | Dark bg with team layout, player cards | Custom team display widget | Visual parity with bg_team.png |
| **PLAYER & SCORES** |
| 29 | Player Info | Player stats, points breakdown, team info | Player card + stats table | Detail screen with score API | None |
| 30 | Fantasy Points | Point rules per sport. Table of metrics | Rules table with point values | `ListView` of point rules from API | None |
| 31 | All Teams | View all teams in a contest | Team card list | Simple `ListView` | None |
| 32 | Team Score | Team score breakdown (kills, position, bonus) | Score card with metric breakdown | Detail screen with team score API | kill/position point display must match |
| **PROFILE & ACCOUNT** |
| 33 | Profile Menu | Settings list: Edit Profile, Transactions, Support, etc. | List with icons and labels | `ListView` with navigation items | None |
| 34 | User Profile | Edit name, email, DOB, address, city, state, pin, gender | Form with multiple inputs | `Form` with validators matching Android rules | Validation rules must match exactly |
| 35 | Profile Pic | Bottom sheet: Camera or Gallery option | Dark bottom sheet, 2 options | `showModalBottomSheet` + `image_picker` | iOS camera permission handling |
| 36 | Other Profile | View another user's profile and stats | Profile card + stats | Read-only profile display | None |
| 37 | Recent Matches | User's recently played matches | Match card list | `ListView` with match cards | None |
| **WALLET** |
| 38 | Balance | Wallet balance: total, winnings, cash bonus. Add Cash button | Balance card + breakdown | Balance display widget | None |
| 39 | Add Cash | Add money to wallet | Input + payment flow | Amount input + action | No payment SDK currently |
| 40 | Transactions | Paginated transaction history. Contest/Other tabs | Transaction cards with tabs | `TabBar` + `infinite_scroll_pagination` | None |
| **REWARDS** |
| 41 | Reward Categories | Grid of reward categories | Category cards with icons | `GridView` of categories | None |
| 42 | All Rewards | Paginated coupons by category | Coupon cards | `infinite_scroll_pagination` | None |
| 43 | My Rewards | User's purchased coupons | Coupon cards with status | Filtered coupon list | None |
| 44 | Purchase Reward | Coupon detail + buy with Roster Coins | Detail card + buy button | Detail screen + buy API call | Coin balance check |
| **OTHER** |
| 45 | Refer & Earn | Referral code, share links (WhatsApp) | Code display + share buttons | `Share.share()` + clipboard copy | WhatsApp deep link |
| 46 | Support | Contact info, FAQ, call support | List with phone/email | `ListView` + `url_launcher` for calls | None |
| 47 | WebView | Load external URLs | Full screen webview | `webview_flutter` | None |
| 48 | Winner Details | Detailed winner info for a match | Winner card + contest breakdown | Detail screen | None |
| 49 | Delete Account | Reason input → confirmation → delete | Multi-step form | Navigation flow with 3 steps | Must match API exactly |
| 50 | Suspend Account | Temporary suspension with duration | Reason + days input | Form with POST /timeout-account | None |

---

## Implementation Priority

### Phase 1: Shell & Auth (Screens 1-8)
Critical path. Must work before anything else.

### Phase 2: Home & Matches (Screens 9-13)
Core user experience. Banner carousel + match listing.

### Phase 3: Contest & Team (Screens 17-28)
Primary feature. Most complex flows.

### Phase 4: Leaderboard & Scores (Screens 22-24, 29-32)
Live data display. Real-time updates.

### Phase 5: Profile & Wallet (Screens 33-40)
Account management.

### Phase 6: Rewards & Misc (Screens 41-50)
Secondary features.

---

## Key Risks Summary

| Risk | Severity | Mitigation |
|------|----------|------------|
| SMS auto-retrieval iOS parity | Medium | Use `sms_autofill` + manual fallback on iOS |
| VPN detection in Flutter | Medium | Use `connectivity_plus` + platform channel |
| Real-time match polling (25s) | Low | `Timer.periodic` with lifecycle management |
| Pagination parity | Low | Use `infinite_scroll_pagination` matching Paging 3 behavior |
| Firebase Realtime DB for Chat | Medium | Use `firebase_database` package |
| AdMob integration | Low | Use `google_mobile_ads` package |
| Bottom nav state preservation | Low | `StatefulShellRoute` in go_router |
| Credit system calculation | Medium | Unit test all credit/team validation rules |
| Captain/VC multiplier logic | Medium | Unit test point calculation (2x/1.5x) |
| Image assets extraction | Low | Export from Android drawable/mipmap |
