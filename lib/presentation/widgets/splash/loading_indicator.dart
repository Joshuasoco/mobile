/// MSME Pathways - Loading Indicator Widget
///
/// A subtle animated loading indicator for the splash screen
/// using logo brand colors.
library;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/theme/app_colors.dart';

/// Animated loading indicator for splash screen.
///
/// Features:
/// - Three dots with staggered animations
/// - Uses logo brand colors (blue, yellow, red)
/// - Subtle scale/opacity animation
/// - Appears after branding text
class SplashLoadingIndicator extends StatelessWidget {
  /// Creates a splash loading indicator.
  const SplashLoadingIndicator({
    super.key,
    this.delay = const Duration(milliseconds: 1400),
    this.animationDuration = const Duration(milliseconds: 400),
    this.dotSize = 8.0,
    this.dotSpacing = 8.0,
  });

  /// Delay before the indicator appears.
  final Duration delay;

  /// Duration of the entrance animation.
  final Duration animationDuration;

  /// Size of each dot.
  final double dotSize;

  /// Spacing between dots.
  final double dotSpacing;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Loading',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDot(AppColors.logoBlue, 0),
          SizedBox(width: dotSpacing),
          _buildDot(AppColors.logoYellow, 100),
          SizedBox(width: dotSpacing),
          _buildDot(AppColors.logoRed, 200),
        ],
      )
          .animate()
          .fadeIn(
            duration: animationDuration,
            delay: delay,
            curve: Curves.easeOut,
          ),
    );
  }

  Widget _buildDot(Color color, int delayOffset) {
    return Container(
      width: dotSize,
      height: dotSize,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
    )
        .animate(
          onPlay: (controller) => controller.repeat(reverse: true),
          delay: delay + Duration(milliseconds: delayOffset),
        )
        .scaleXY(
          begin: 1.0,
          end: 0.6,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        )
        .then()
        .scaleXY(
          begin: 0.6,
          end: 1.0,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
  }
}
