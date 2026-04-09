# Design Audit - RosterUp (Extracted from Android)

## Design Language
- **Theme**: Dark mode with orange accent
- **Feel**: Gaming/esports aesthetic
- **Font**: Inter (Bold, Light, Black)
- **Scaling**: SDP/SSP for responsive sizing

---

## Color Palette

### Primary
| Token | Hex | Usage |
|-------|-----|-------|
| colorPrimaryDark | `#FB9402` | Buttons, primary accent, selected states |
| colorAccent | `#FCE7CA` | Light orange accent, secondary highlight |
| colorStatusBar | `#4B2C00` | Status bar, app bar background |
| colorCoupon | `#241502` | Deep brown backgrounds |

### Neutrals
| Token | Hex | Usage |
|-------|-----|-------|
| colorBlack | `#000000` | Primary background |
| colorWhite | `#FFFFFF` | Primary text on dark |
| colorThemeText | `#EAEAEA` | Secondary text, button text |
| colorDarkText | `#313131` | Card backgrounds, tab backgrounds |
| colorUpcomingMatchBar | `#4C4C4C` | Section headers |
| colorTabGrey | `#575757` | Tab backgrounds |
| colorTabNewGrey | `#585858` | Updated tab backgrounds |
| colorGrey | `#EFEFEF` | Separators, dividers |

### Semantic
| Token | Hex | Usage |
|-------|-----|-------|
| redColor | `#FF0000` | Errors, warnings |
| colorGreen | `#228B22` | Success states |
| color_highlighter | `#B7C616` | Highlight/active indicator |
| colorCompleted | `#EBFF00` | Completed match status |

### Opacity Variants
| Token | Hex | Usage |
|-------|-----|-------|
| contestBg | `#68FB9402` | Semi-transparent orange (42% opacity) |
| dialogBg | `#88000000` | Dialog overlay (53% opacity) |

---

## Typography

### Font Family
- **Inter Bold** (`inter_bold.otf`) - Headings, labels, buttons
- **Inter Light** (`inter_light.otf`) - Body text, descriptions
- **Inter Black** (`inter_black.otf`) - Heavy emphasis (rare)

### Text Scale (SSP - Scalable SP)
| Size | Usage |
|------|-------|
| 9sp | Small captions, badge text |
| 10sp | Tab labels, secondary info |
| 11sp | Timestamps, tertiary text |
| 12sp | Body text, list items |
| 14sp | Primary body, button text (most common) |
| 16sp | Subheadings |
| 18sp | Section titles |
| 20sp+ | Large headings |

### Text Styles
| Style | Font | Size | Color |
|-------|------|------|-------|
| Heading | Inter Bold | 18sp | White |
| Body | Inter Light | 14sp | White |
| Label | Inter Bold | 14sp | White |
| Caption | Inter Light | 10-12sp | #EAEAEA |
| Button | Inter Bold | 14sp | #EAEAEA |
| Tab | Inter Bold | 12sp | White |

---

## Spacing System (SDP - Scalable DP)

| Token | Value | Usage |
|-------|-------|-------|
| xs | 2dp | Fine borders, tiny gaps |
| sm | 5dp | Inner padding, small gaps |
| md | 10dp | Standard padding/margin |
| lg | 15dp | Section spacing |
| xl | 20dp | Major section padding |
| xxl | 25-30dp | Large component spacing |

### Common Measurements
| Component | Size |
|-----------|------|
| Toolbar height | 45dp |
| Button height | 40dp |
| Icon button | 25-30dp |
| Profile circle | 26dp |
| App logo | 120x40dp |
| Standard padding | 10dp |
| Card inner padding | 10dp |

---

## Corner Radii

| Value | Usage |
|-------|-------|
| 5dp | Buttons, cards, tabs, inputs, most components |
| 10dp | Edit text fields |
| 13dp | Profile circle (26dp/2) |
| 35dp | Bottom sheets (top corners only) |

---

## Elevation & Shadows
| Level | Value | Usage |
|-------|-------|-------|
| None | 0dp | Flat surfaces |
| Low | 2dp | Cards, list items |
| Medium | 5dp | Floating elements |
| High | 99dp | Full-screen dialogs |

---

## Component Inventory

### 1. Buttons
**Primary Button**
- Background: `#FB9402` solid
- Corner radius: 5dp
- Height: 40dp
- Text: Inter Bold, 14sp, `#EAEAEA`
- Padding: 20dp horizontal, 5dp vertical
- Full width (match_parent)

**Outline Button**
- Stroke: 1dp `#FB9402`
- Corner radius: 5dp
- Text: Inter Bold, 14sp, white

**Text Button**
- No background
- Text: Inter Bold, 14sp, `#FB9402`

### 2. Input Fields
- Background: `#585858`
- Height: 48dp
- Corner radius: 10dp (via background_edit_text)
- Text: Inter Light, 14sp, white
- Single line, cursor visible
- Padding: 10dp

### 3. Cards (Contest/Match)
- Background: `#313131`
- Corner radius: 5dp
- Elevation: 2dp
- Header bar: `#4C4C4C` with 10dp padding
- Content area: 5dp padding
- Full width

### 4. App Bar / Toolbar
- Height: 45dp
- Background: `#4B2C00`
- Left: Profile circle (26x26dp, 13dp radius, 1dp white stroke)
- Center: App logo (80x50dp)
- Right: Wallet icon + balance text

### 5. Bottom Navigation
- 5 tabs: Home, Matches, Rewards, Chat, Winners
- Selected: Orange (#FB9402) filled icon
- Unselected: White outline icon
- Background: Dark

### 6. Tab Bar (Match Tabs)
- Background: `#313131`
- Selected tab: `#FB9402` indicator
- Text: Inter Bold, 12sp

### 7. Bottom Sheets
- Background: Black `#000000`
- Top corners: 35dp radius
- Top padding: 8dp
- Drag handle implied

### 8. Dialogs
- Background overlay: `#88000000`
- Content background: Dark
- Buttons: Primary style

### 9. List Items
- Background: `#313131` or transparent
- Padding: 10dp
- Divider: `#EFEFEF` (thin line)
- Image: 30x30dp with 5dp margin

### 10. Profile Circle
- Size: 26x26dp
- Corner radius: 13dp (full circle)
- Stroke: 1dp white
- Image: center crop

### 11. Badge / Count
- Size: 30x30dp
- Background: `#FB9402`
- Text: 10sp, centered, white

### 12. OTP Input
- Custom OTP view component
- 6 digit boxes
- Styled with app theme

### 13. Banner/Carousel
- Full width image slider
- Active dot: Orange `#FB9402` oval 8dp
- Inactive dot: White outline oval

---

## Animations

| Animation | Duration | Type | Usage |
|-----------|----------|------|-------|
| Fade Enter | 750ms | Alpha 0→1 | Screen transitions |
| Fade Exit | 750ms | Alpha 1→0 | Screen transitions |
| Bounce | 1200ms | Scale 0.3→1.0 | Element entrance |
| Splash | 1500ms | Scale 1→1.5 + Fade 1→0 | Splash screen |
| Slide In Top | - | TranslateY | Alert/snackbar |
| Slide Out Top | - | TranslateY | Alert dismiss |
| Vertical Shake | - | TranslateY | Error feedback |

### Interpolators
- Slight Anticipate: Ease-in before animation
- Slight Overshoot: Bounce past target

---

## Icons

### Navigation (Dual State - filled/outline)
- home.xml / home_r.xml
- match.xml / match_r.xml
- notification.xml (selector)
- winner.xml / winner_r.xml
- support.xml / support_r.xml

### Game Elements
- captain.xml, vicecaptain.xml
- roster_c.xml (C badge), roster_n.xml, roster_w.xml
- trophy.xml, winner_trophy.xml

### Actions
- arrow_back.xml, arrow_forward.xml
- edit.xml, delete.xml, copy.xml, trash.xml
- plus.xml, ic_minus.xml
- ic_dropdown.xml

### Status
- completed.xml, tick_mark_winnings.xml
- ic_warning.xml, circle_close.xml

### Misc
- gift.xml, tickets.xml, discount.xml
- clock.xml, calender.xml
- call_icon.xml, camera.xml
- ic_wallet.xml, my_balance.xml

### Raster Assets
- banner1_roster.png, banner_imgg.png
- bg_team.png, background_preview.jpg
- game1.png, soul.png
- roster_logo.png, logo_white.png
- india_flag.png

---

## Screen-Specific Design Notes

### Splash Screen
- Black background
- Logo center with scale 1→1.5 + fade animation (1500ms)
- Auto-routes based on login state

### Home Screen
- Status bar: `#4B2C00`
- Top bar: Profile pic (left), Logo (center), Wallet (right)
- Banner carousel below app bar
- Match cards in scrollable list
- Bottom nav: 5 tabs

### Contest Cards
- Header: `#4C4C4C` with match name, timer, action button
- Body: Team icons in row, entry fee, prize pool, spots
- Progress bar for spots filled

### Team Creation
- Credit counter at top (remaining/100)
- Team list with checkboxes
- Selected count badge
- Bottom action bar with "Next" button

### Leaderboard
- Rank column, team name, points, won amount
- Current user highlighted
- Scrollable with pagination
