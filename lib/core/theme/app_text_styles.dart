/// MSME Pathways - Typography System
/// 
/// Uses Google Fonts for modern, accessible typography.
/// Poppins for headers and Inter for body text.
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Application text styles following MSME Pathways design guidelines.
/// 
/// Typography hierarchy designed for readability across varying
/// digital literacy levels among Filipino microentrepreneurs.
abstract final class AppTextStyles {
  // ============================================================
  // DISPLAY STYLES - Large headlines
  // ============================================================
  
  /// Large display text for splash screens
  static TextStyle displayLarge = GoogleFonts.poppins(
    fontSize: 48,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -1.5,
    height: 1.2,
  );
  
  /// Medium display for section headers
  static TextStyle displayMedium = GoogleFonts.poppins(
    fontSize: 36,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
    height: 1.25,
  );

  // ============================================================
  // HEADLINE STYLES - Page titles and important headers
  // ============================================================
  
  /// Primary headline for onboarding titles
  static TextStyle headlineLarge = GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
    height: 1.3,
  );
  
  /// Secondary headline for section titles
  static TextStyle headlineMedium = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.35,
  );
  
  /// Smaller headline for card titles
  static TextStyle headlineSmall = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  // ============================================================
  // TITLE STYLES - Prominent text elements
  // ============================================================
  
  /// Large title for feature names
  static TextStyle titleLarge = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );
  
  /// Medium title for list items
  static TextStyle titleMedium = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.45,
  );
  
  /// Small title for labels
  static TextStyle titleSmall = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  // ============================================================
  // BODY STYLES - Main content text
  // ============================================================
  
  /// Large body text for important paragraphs
  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.6,
  );
  
  /// Medium body text for general content
  static TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.55,
  );
  
  /// Small body text for captions and footnotes
  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textTertiary,
    height: 1.5,
  );

  // ============================================================
  // LABEL STYLES - UI elements like buttons
  // ============================================================
  
  /// Large label for primary buttons
  static TextStyle labelLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textLight,
    letterSpacing: 0.5,
    height: 1.4,
  );
  
  /// Medium label for secondary buttons
  static TextStyle labelMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0.25,
    height: 1.4,
  );
  
  /// Small label for chips and tags
  static TextStyle labelSmall = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    letterSpacing: 0.5,
    height: 1.35,
  );

  // ============================================================
  // SPECIAL STYLES
  // ============================================================
  
  /// Onboarding subtitle - slightly larger for readability
  static TextStyle onboardingSubtitle = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.7,
  );
  
  /// Button text style
  static TextStyle button = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.4,
  );
  
  /// Skip button text
  static TextStyle skipButton = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.4,
  );
}
