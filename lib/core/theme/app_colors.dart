/// MSME Pathways - App Color Palette
/// 
/// A modern fintech color scheme designed to convey trust, growth, and
/// accessibility for Filipino microentrepreneurs.
library;

import 'package:flutter/material.dart';

/// Application color constants following the MSME Pathways brand guidelines.
/// 
/// The palette balances professional fintech aesthetics with warmth and
/// approachability, avoiding intimidating corporate tones.
abstract final class AppColors {
  // ============================================================
  // PRIMARY COLORS - Deep teal/emerald for growth & stability
  // ============================================================
  
  /// Primary brand color - deep teal representing financial growth
  static const Color primary = Color(0xFF0D7377);
  
  /// Lighter primary variant for gradients and hover states
  static const Color primaryLight = Color(0xFF14919B);
  
  /// Darker primary variant for pressed states and emphasis
  static const Color primaryDark = Color(0xFF065A5C);

  // ============================================================
  // SECONDARY COLORS - Warm coral for community & warmth
  // ============================================================
  
  /// Secondary accent - warm coral representing community connection
  static const Color secondary = Color(0xFFFF6B6B);
  
  /// Lighter secondary for gradients
  static const Color secondaryLight = Color(0xFFFF8E8E);
  
  /// Darker secondary for emphasis
  static const Color secondaryDark = Color(0xFFE85555);

  // ============================================================
  // ACCENT COLORS - Soft gold for opportunity
  // ============================================================
  
  /// Accent color - soft gold representing opportunity and success
  static const Color accent = Color(0xFFFFD93D);
  
  /// Lighter accent for subtle highlights
  static const Color accentLight = Color(0xFFFFE566);
  
  /// Darker accent for emphasis
  static const Color accentDark = Color(0xFFE6C235);

  // ============================================================
  // BACKGROUND COLORS
  // ============================================================
  
  /// Primary background - clean white
  static const Color background = Color(0xFFFAFAFA);
  
  /// Surface color for cards and elevated elements
  static const Color surface = Color(0xFFFFFFFF);
  
  /// Subtle background for sections
  static const Color backgroundSubtle = Color(0xFFF5F7FA);

  // ============================================================
  // TEXT COLORS - Professional grays, avoiding pure black
  // ============================================================
  
  /// Primary text color - dark gray for readability
  static const Color textPrimary = Color(0xFF2D3748);
  
  /// Secondary text for subtitles and less emphasis
  static const Color textSecondary = Color(0xFF718096);
  
  /// Tertiary text for hints and placeholders
  static const Color textTertiary = Color(0xFFA0AEC0);
  
  /// Light text for use on dark backgrounds
  static const Color textLight = Color(0xFFFFFFFF);

  // ============================================================
  // GRADIENT DEFINITIONS
  // ============================================================
  
  /// Primary gradient for backgrounds and buttons
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryLight, primary],
  );
  
  /// Secondary gradient for accents
  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondaryLight, secondary],
  );
  
  /// Background gradient for onboarding pages
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFFFFFF),
      Color(0xFFF0F7F7),
    ],
  );

  // ============================================================
  // UTILITY COLORS
  // ============================================================
  
  /// Success state color
  static const Color success = Color(0xFF48BB78);
  
  /// Warning state color
  static const Color warning = Color(0xFFED8936);
  
  /// Error state color
  static const Color error = Color(0xFFE53E3E);
  
  /// Info state color
  static const Color info = Color(0xFF4299E1);

  // ============================================================
  // SHADOW COLORS
  // ============================================================
  
  /// Subtle shadow for cards
  static const Color shadowLight = Color(0x0A000000);
  
  /// Medium shadow for elevated elements
  static const Color shadowMedium = Color(0x1A000000);

  // ============================================================
  // SPLASH SCREEN COLORS - Based on geometric logo
  // ============================================================
  
  /// Splash background dark gradient start
  static const Color splashDarkStart = Color(0xFF1A1A1A);
  
  /// Splash background dark gradient end
  static const Color splashDarkEnd = Color(0xFF2C2C2C);
  
  /// Logo blue (top section of geometric M)
  static const Color logoBlue = Color(0xFF1565C0);
  
  /// Logo yellow/gold (middle section of geometric M)
  static const Color logoYellow = Color(0xFFFFC107);
  
  /// Logo red (bottom section of geometric M)
  static const Color logoRed = Color(0xFFE53935);
  
  /// Splash text primary - bright white
  static const Color splashTextPrimary = Color(0xFFFFFFFF);
  
  /// Splash text secondary - slightly dimmed white
  static const Color splashTextSecondary = Color(0xB3FFFFFF); // 70% opacity
  
  /// Splash loading indicator color
  static const Color splashLoadingIndicator = Color(0x80FFFFFF); // 50% opacity
  
  /// Splash dark gradient for background
  static const LinearGradient splashDarkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [splashDarkStart, splashDarkEnd],
    stops: [0.0, 1.0],
  );
  
  /// Logo glow effect color
  static const Color logoGlow = Color(0x401565C0); // 25% opacity blue
}
