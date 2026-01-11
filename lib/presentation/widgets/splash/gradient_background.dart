/// MSME Pathways - Animated Gradient Background
///
/// A reusable gradient background widget with subtle animation
/// for the splash screen, providing a professional dark aesthetic.
library;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/theme/app_colors.dart';

/// Animated gradient background for splash screen.
///
/// Features:
/// - Smooth fade-in animation on load
/// - Subtle noise texture overlay (optional)
/// - Dark gradient matching the logo aesthetic
/// - Responsive to screen size
class GradientBackground extends StatelessWidget {
  /// Creates an animated gradient background.
  const GradientBackground({
    super.key,
    this.fadeInDuration = const Duration(milliseconds: 300),
    this.showNoiseTexture = true,
    this.child,
  });

  /// Duration of the initial fade-in animation.
  final Duration fadeInDuration;

  /// Whether to show subtle noise texture overlay.
  final bool showNoiseTexture;

  /// Optional child widget to display on top of background.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Base gradient background
        _buildGradient(),

        // Subtle grid pattern overlay
        if (showNoiseTexture) _buildGridPattern(),

        // Child content
        if (child != null) child!,
      ],
    );
  }

  /// Builds the main gradient background with animation.
  Widget _buildGradient() {
    return AnimatedContainer(
      duration: fadeInDuration,
      curve: Curves.easeInOut,
      decoration: const BoxDecoration(
        gradient: AppColors.splashDarkGradient,
      ),
    )
        .animate()
        .fadeIn(
          duration: fadeInDuration,
          curve: Curves.easeOut,
        )
        .then() // Chain for subtle shimmer effect
        .shimmer(
          duration: const Duration(milliseconds: 2000),
          delay: const Duration(milliseconds: 1500),
          color: AppColors.logoBlue.withValues(alpha: 0.05),
        );
  }

  /// Builds a subtle geometric grid pattern overlay.
  Widget _buildGridPattern() {
    return Opacity(
      opacity: 0.03,
      child: CustomPaint(
        painter: _GridPatternPainter(),
        size: Size.infinite,
      ),
    )
        .animate()
        .fadeIn(
          duration: const Duration(milliseconds: 500),
          delay: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
  }
}

/// Custom painter for subtle grid pattern.
class _GridPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    const spacing = 40.0;

    // Vertical lines
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Horizontal lines
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
