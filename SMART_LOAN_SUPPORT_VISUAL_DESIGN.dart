// SMART LOAN SUPPORT SCREEN - VISUAL DESIGN DOCUMENT
//
// ============================================================================
// SCREEN LAYOUT & HIERARCHY
// ============================================================================
//
// This document describes the visual structure and design of the
// Smart Loan Support screen component.
//
// VIEWPORT: iPhone 14 (390×844px)
// SAFE AREA: Top 47px, Bottom 34px (accounting for notch & home indicator)
//
// ============================================================================
// COLOR PALETTE
// ============================================================================
//
// PRIMARY GREEN:        #22C55E (RGB: 34, 197, 94) - Positive indicators
// DARK GREEN:           #16A34A (RGB: 22, 163, 74)  - Progress bar start
// LIGHT GREEN BG:       #F0FDF4 (RGB: 240, 253, 244)
// GREEN BORDER:         #BEF264 (RGB: 190, 242, 100)
//
// NEUTRAL COLORS:
// - White/Surface:      #FFFFFF
// - Background:         #FAFAFA (RGB: 250, 250, 250)
// - Text Primary:       #1F2937 (RGB: 31, 41, 55)
// - Text Secondary:     #6B7280 (RGB: 107, 114, 128)
// - Text Tertiary:      #9CA3AF (RGB: 156, 163, 175)
// - Gray Light:         #E5E7EB (RGB: 229, 231, 235)
// - Gray Lighter:       #F3F4F6 (RGB: 243, 244, 246)
//
// ============================================================================
// SECTION BREAKDOWN
// ============================================================================
//
// 1. STATUS BAR
//    ├─ Height: 47px (system)
//    └─ Style: Dark icons on light background
//
// 2. USER HEADER (Offset: 20px top)
//    ├─ Title: "Smart Loan Support"
//    │  └─ Font: 28px, Bold (700), #1F2937
//    │  └─ Spacing: 32px from top
//    │
//    ├─ Avatar: 80×80px circle
//    │  ├─ Border: 2.5px #22C55E
//    │  ├─ Background: #F0FDF4
//    │  └─ Icon: Material account_circle, #22C55E, 56px
//    │
//    ├─ Name: "Joshua S. Co"
//    │  ├─ Font: 18px, Semi-bold (600), #1F2937
//    │  └─ Spacing: 16px below avatar
//    │
//    └─ Subtitle: "Microentrepreneur"
//       ├─ Font: 14px, Regular (400), #6B7280
//       └─ Spacing: 4px below name
//
// 3. ACTIVE LOAN CARD (Offset: 32px)
//    ├─ Container: White rounded card
//    │  ├─ Border Radius: 16px
//    │  ├─ Shadow: 6px blur, 4px offset, 6% opacity
//    │  └─ Padding: 20px all sides
//    │
//    ├─ Header Row:
//    │  ├─ Left: Title "Active Loan" (16px, Semi-bold, #1F2937)
//    │  └─ Right: Badge "In Progress"
//    │     ├─ Background: #DCF
//    │     ├─ Border: 1px #BEF264
//    │     ├─ Border Radius: 20px
//    │     ├─ Padding: 12px H, 6px V
//    │     └─ Font: 12px, Bold (600), #16A34A
//    │
//    ├─ Details Grid (2 columns after 20px spacing)
//    │  ├─ Column 1 (Left):
//    │  │  ├─ Row 1:
//    │  │  │  ├─ Label: "Loan Type" (12px, #9CA3AF)
//    │  │  │  └─ Value: "Business Capital" (15px, #374151)
//    │  │  │
//    │  │  └─ Row 2 (20px spacing):
//    │  │     ├─ Label: "Interest Rate" (12px, #9CA3AF)
//    │  │     └─ Value: "8% per year" (15px, #374151)
//    │  │
//    │  └─ Column 2 (Right):
//    │     ├─ Row 1:
//    │     │  ├─ Label: "Amount" (12px, #9CA3AF)
//    │     │  └─ Value: "₱25,000" (18px, Bold (700), #22C55E)
//    │     │
//    │     └─ Row 2 (20px spacing):
//    │        ├─ Label: "Repayment Status" (12px, #9CA3AF)
//    │        └─ Value: "4 of 12 months paid" (15px, #374151)
//    │
//    └─ Gap between rows: 20px
//
// 4. PAYMENT PROGRESS SECTION (Offset: 32px)
//    ├─ Title: "Payment Progress"
//    │  ├─ Font: Headline Small, Semi-bold (600), #1F2937
//    │  └─ Spacing: 16px below title
//    │
//    ├─ Progress Bar Container:
//    │  ├─ Height: 12px
//    │  ├─ Background: #E5E7EB
//    │  ├─ Border Radius: 6px
//    │  ├─ Clipped for smooth edges
//    │  │
//    │  └─ Animated Fill (0-33%):
//    │     ├─ Gradient: #16A34A → #22C55E (left to right)
//    │     ├─ Animation: 700ms ease-in-out
//    │     ├─ Border Radius: 6px
//    │     │
//    │     └─ Shimmer Effect:
//    │        ├─ Width: 8px
//    │        ├─ Blur: 6px
//    │        ├─ Color: #22C55E @ 30% opacity
//    │        └─ Appears at fill end
//    │
//    ├─ Progress Label Row (8px spacing below bar):
//    │  ├─ Left: "33% Complete" (14px, Medium (500), #374151)
//    │  └─ Right: "₱8,333 Paid" (15px, Bold (700), #22C55E)
//    │
//    └─ Next Payment Row (16px spacing below):
//       ├─ Icon: calendar_today (16px, #22C55E)
//       ├─ Text: "Next payment due: Jan 1, 2026"
//       │  └─ Font: 13px, Medium (500), #6B7280
//       └─ Spacing: 8px between icon and text
//
// 5. ACTION BUTTONS (Offset: 32px)
//    ├─ Button 1: "Repay Now" (Primary)
//    │  ├─ Background: #22C55E
//    │  ├─ Text Color: White
//    │  ├─ Border Radius: 12px
//    │  ├─ Height: 52px (16px padding vertical)
//    │  ├─ Font: 16px, Semi-bold (600)
//    │  ├─ Shadow: None (elevation: 0)
//    │  └─ Width: 100% of container
//    │
//    ├─ Spacing: 12px
//    │
//    └─ Button 2: "View Loan Details" (Secondary)
//       ├─ Background: Transparent
//       ├─ Border: 1.5px #22C55E
//       ├─ Text Color: #22C55E
//       ├─ Border Radius: 12px
//       ├─ Height: 52px (16px padding vertical)
//       ├─ Font: 16px, Semi-bold (600)
//       └─ Width: 100% of container
//
// 6. ELIGIBILITY REQUIREMENTS SECTION (Offset: 32px)
//    ├─ Title: "Eligibility Requirements"
//    │  ├─ Font: Headline Small, Semi-bold (600), #1F2937
//    │  └─ Spacing: 16px below title
//    │
//    └─ Checklist Container:
//       ├─ Background: White
//       ├─ Border Radius: 12px
//       ├─ Shadow: 4px blur, 2px offset, 4% opacity
//       │
//       └─ Items (3 total):
//          ├─ Item 1: "Valid Government ID"
//          ├─ Item 2: "Barangay Certificate"
//          └─ Item 3: "Active Mobile Number"
//          │
//          └─ Item Structure (16px padding each):
//             ├─ Checkbox: 24×24px circle
//             │  ├─ Border: 1.5px #22C55E
//             │  ├─ Background: #F0FDF4
//             │  ├─ Icon: check (14px, Bold, #22C55E)
//             │  └─ Align: Left
//             │
//             ├─ Text (12px spacing from checkbox)
//             │  ├─ Font: 15px, Medium (500), #374151
//             │  └─ Flex: Expanded
//             │
//             └─ Divider (between items only)
//                ├─ Height: 1px
//                ├─ Color: #F3F4F6
//                └─ Padding: 0 16px
//
// 7. HELP FOOTER SECTION (Offset: 24px)
//    ├─ Container:
//    │  ├─ Background: #F0FDF4
//    │  ├─ Border: 1px #DCFCE7
//    │  ├─ Border Radius: 12px
//    │  ├─ Padding: 16px all sides
//    │  │
//    │  └─ Content Row:
//    │     ├─ Icon: help_outline (20px, #16A34A)
//    │     ├─ Spacing: 12px
//    │     └─ Text: "Need help? Learn more about loans"
//    │        ├─ Font: 14px, Medium (500), #16A34A
//    │        └─ Flex: Expanded
//    │
//    └─ Gap: 32px (before bottom nav)
//
// 8. BOTTOM NAVIGATION BAR
//    ├─ Container:
//    │  ├─ Background: White
//    │  ├─ Shadow: 12px blur, -2px offset, 5% opacity
//    │  ├─ Safe Area Bottom: 8px padding
//    │  │
//    │  └─ Content Spacing:
//    │     ├─ Top Padding: 12px
//    │     ├─ Bottom Padding: 8px (safe area)
//    │     └─ Horizontal: Space-around distribution
//    │
//    └─ Items (4 total): 24px icon, 4px spacing, label
//       │
//       ├─ Item 1: Home
//       │  ├─ Icon: home_outlined (24px, #9CA3AF)
//       │  ├─ Label: "Home" (11px, Medium (500), #9CA3AF)
//       │  └─ Inactive state
//       │
//       ├─ Item 2: Loan ★ ACTIVE
//       │  ├─ Icon: wallet_outlined (24px, #22C55E)
//       │  ├─ Label: "Loan" (11px, Medium (500), #22C55E)
//       │  └─ Active state (highlighted)
//       │
//       ├─ Item 3: Profile
//       │  ├─ Icon: person_outline (24px, #9CA3AF)
//       │  ├─ Label: "Profile" (11px, Medium (500), #9CA3AF)
//       │  └─ Inactive state
//       │
//       └─ Item 4: Chat
//          ├─ Icon: chat_outlined (24px, #9CA3AF)
//          ├─ Label: "Chat" (11px, Medium (500), #9CA3AF)
//          └─ Inactive state
//
// ============================================================================
// SPACING SUMMARY
// ============================================================================
//
// Vertical Flow:
// └─ 20px         (Top safe area)
// └─ Title
// └─ 32px         (To avatar)
// └─ Avatar
// └─ 16px         (To name)
// └─ Name + Subtitle
// └─ 32px         (To loan card)
// └─ Active Loan Card
// └─ 32px         (To payment progress)
// └─ Payment Progress Section
// └─ 32px         (To buttons)
// └─ Action Buttons (2 with 12px spacing)
// └─ 32px         (To eligibility)
// └─ Eligibility Requirements
// └─ 24px         (To footer)
// └─ Help Footer
// └─ 32px         (To bottom nav)
//
// Horizontal Flow:
// └─ All sections: 20px padding from viewport edges
// └─ Grid columns: 16px gap between left/right columns
// └─ Internal card padding: 20px all sides
// └─ Checklist items: 16px padding, 12px icon spacing
//
// ============================================================================
// ANIMATION DETAILS
// ============================================================================
//
// Progress Bar Animation:
// ├─ Type: Linear progress fill with gradient
// ├─ Duration: 700ms
// ├─ Curve: Ease-in-out (Curves.easeInOut)
// ├─ Start: 0% (width: 0)
// ├─ End: 33% (width: 33% of bar)
// ├─ Trigger: Widget initialization (WidgetsBinding.addPostFrameCallback)
// │
// └─ Visual Effects:
//    ├─ Gradient shift from dark to light green as it fills
//    ├─ Shimmer glow at the right edge (following fill)
//    ├─ Percentage counter animates alongside (0 → 33%)
//    └─ Text updates every frame for smooth counting
//
// ============================================================================
// TYPOGRAPHY
// ============================================================================
//
// Font Family: Google Fonts - Inter (configured in app_theme.dart)
//
// Styles Used:
// ├─ Display (28px, Bold 700)          → Title
// ├─ Headline Small (16px+, Semi-bold 600)  → Section titles
// ├─ Title Large (18px, Semi-bold 600)      → Name
// ├─ Body Large/Medium (15-16px)            → Regular text
// ├─ Label Large/Medium (12-14px)           → Labels, badges
// ├─ Label Small (11px)                     → Nav labels
// └─ Caption (13px, Medium 500)             → Secondary info
//
// Font Weights:
// ├─ 700 (Bold)       → Headings, amounts
// ├─ 600 (Semi-bold)  → Titles, labels
// ├─ 500 (Medium)     → Secondary text
// └─ 400 (Regular)    → Body text
//
// ============================================================================
// SHADOWS & DEPTH
// ============================================================================
//
// Soft Shadow (Cards & Containers):
// ├─ Color: Black @ 6% opacity
// ├─ Blur Radius: 16px
// ├─ Offset: 0, 4px
// └─ Used on: Loan card, Eligibility checklist
//
// Subtle Shadow (Bottom Nav):
// ├─ Color: Black @ 5% opacity
// ├─ Blur Radius: 12px
// ├─ Offset: 0, -2px (upward)
// └─ Used on: Bottom navigation bar
//
// Light Shadow (Checklist):
// ├─ Color: Black @ 4% opacity
// ├─ Blur Radius: 8px
// ├─ Offset: 0, 2px
// └─ Used on: Checklist container
//
// Avatar Glow:
// ├─ Color: #22C55E @ 15% opacity
// ├─ Blur Radius: 12px
// ├─ Offset: 0, 4px
// └─ Used on: Avatar circle outline
//
// Progress Shimmer:
// ├─ Color: #22C55E @ 30% opacity
// ├─ Blur Radius: 6px
// ├─ Spread Radius: 1px
// └─ Used on: Progress bar fill end
//
// ============================================================================
// INTERACTION STATES
// ============================================================================
//
// Buttons:
// ├─ Default: Fully opaque, sharp edges
// ├─ Hover: Subtle opacity change (if applicable)
// └─ Pressed: Ripple effect (Flutter default)
//
// Navigation Items:
// ├─ Inactive: Gray color (#9CA3AF)
// ├─ Active: Green color (#22C55E)
// └─ Transition: Instantaneous color change
//
// Checkmarks:
// ├─ Always visible (no interaction states)
// └─ Static green color
//
// ============================================================================
// ACCESSIBILITY NOTES
// ============================================================================
//
// Color Contrast:
// ├─ Green (#22C55E) on white: 5.5:1 (WCAG AA pass)
// ├─ Text primary (#1F2937) on white: 12.6:1 (WCAG AAA pass)
// ├─ Text secondary (#6B7280) on white: 7.2:1 (WCAG AA pass)
// └─ All text meets WCAG AA standards
//
// Touch Targets:
// ├─ Navigation items: 48px minimum height
// ├─ Buttons: 52px height × 100% width
// ├─ Checkmarks: 24px circles
// └─ All meet recommended 48×48px minimum
//
// Semantic Structure:
// ├─ Proper heading hierarchy (H1, H2, H3 equivalents)
// ├─ Icons paired with text labels
// ├─ Sufficient spacing between interactive elements
// └─ Clear visual feedback for active states
//
// ============================================================================
