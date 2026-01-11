/// MSME Pathways - Branding Text Widget
///
/// A reusable animated branding text widget with staggered entrance
/// animations for the splash screen app name and tagline.
library;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';

/// Animated branding text for splash screen.
///
/// Features:
/// - App name with bold Poppins typography
/// - Tagline with elegant Inter typography
/// - Staggered fade-in animations from bottom
/// - Optional gradient text effect
/// - Responsive sizing based on screen width
class BrandingText extends StatelessWidget {
  /// Creates an animated branding text widget.
  const BrandingText({
    super.key,
    this.appNameDelay = const Duration(milliseconds: 800),
    this.taglineDelay = const Duration(milliseconds: 1000),
    this.animationDuration = const Duration(milliseconds: 400),
    this.useGradientText = false,
    this.appName = AppStrings.appName,
    this.tagline = AppStrings.splashTagline,
  });

  /// Delay before app name animation starts.
  final Duration appNameDelay;

  /// Delay before tagline animation starts.
  final Duration taglineDelay;

  /// Duration of each text animation.
  final Duration animationDuration;

  /// Whether to apply gradient effect to app name.
  final bool useGradientText;

  /// App name text (defaults to MSME Pathways).
  final String appName;

  /// Tagline text.
  final String tagline;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // App name
        _buildAppName(context),
        
        const SizedBox(height: 12),
        
        // Tagline
        _buildTagline(context),
      ],
    );
  }

  Widget _buildAppName(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = (screenWidth * 0.08).clamp(24.0, 36.0);

    final textWidget = Text(
      appName,
      textAlign: TextAlign.center,
      style: GoogleFonts.poppins(
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
        color: AppColors.splashTextPrimary,
        letterSpacing: 0.5,
        height: 1.2,
      ),
    );

    // Apply gradient if enabled
    final displayWidget = useGradientText
        ? ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [
                AppColors.splashTextPrimary,
                AppColors.logoBlue.withValues(alpha: 0.9),
                AppColors.splashTextPrimary,
              ],
              stops: const [0.0, 0.5, 1.0],
            ).createShader(bounds),
            child: textWidget,
          )
        : textWidget;

    return Semantics(
      header: true,
      child: displayWidget
          .animate()
          .fadeIn(
            duration: animationDuration,
            delay: appNameDelay,
            curve: Curves.easeOut,
          )
          .slideY(
            begin: 0.3,
            end: 0,
            duration: animationDuration,
            delay: appNameDelay,
            curve: Curves.easeOutCubic,
          ),
    );
  }

  Widget _buildTagline(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = (screenWidth * 0.04).clamp(12.0, 16.0);

    return Semantics(
      label: 'App tagline: $tagline',
      child: Text(
        tagline,
        textAlign: TextAlign.center,
        style: GoogleFonts.inter(
          fontSize: fontSize,
          fontWeight: FontWeight.w400,
          color: AppColors.splashTextSecondary,
          letterSpacing: 0.3,
          height: 1.4,
        ),
      )
          .animate()
          .fadeIn(
            duration: animationDuration,
            delay: taglineDelay,
            curve: Curves.easeOut,
          )
          .slideY(
            begin: 0.3,
            end: 0,
            duration: animationDuration,
            delay: taglineDelay,
            curve: Curves.easeOutCubic,
          ),
    );
  }
}
