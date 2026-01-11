/// MSME Pathways - Animated Logo Widget
///
/// A reusable animated logo widget with scale, fade, and glow effects
/// for the splash screen, creating a professional entrance animation.
library;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';

/// Animated logo widget for splash screen.
///
/// Features:
/// - Smooth scale animation (0.8 → 1.0) with elastic curve
/// - Fade-in animation synchronized with scale
/// - Subtle glow/pulse effect after entrance
/// - Optional 3D tilt effect on entrance
/// - Responsive sizing based on screen width
class AnimatedLogo extends StatefulWidget {
  /// Creates an animated logo widget.
  const AnimatedLogo({
    super.key,
    this.delayStart = const Duration(milliseconds: 300),
    this.entranceDuration = const Duration(milliseconds: 500),
    this.logoSizePercent = 0.40,
    this.maxLogoSize = 200.0,
    this.showGlowEffect = true,
    this.onAnimationComplete,
  });

  /// Delay before starting the animation.
  final Duration delayStart;

  /// Duration of the entrance animation.
  final Duration entranceDuration;

  /// Logo size as percentage of screen width (0.0 - 1.0).
  final double logoSizePercent;

  /// Maximum logo size in logical pixels.
  final double maxLogoSize;

  /// Whether to show the pulsing glow effect.
  final bool showGlowEffect;

  /// Callback when entrance animation completes.
  final VoidCallback? onAnimationComplete;

  @override
  State<AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<AnimatedLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _initGlowAnimation();
  }

  void _initGlowAnimation() {
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    // Start glow animation after entrance completes
    Future.delayed(
      widget.delayStart + widget.entranceDuration,
      () {
        if (mounted) {
          _glowController.repeat(reverse: true);
        }
      },
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final logoSize = (screenWidth * widget.logoSizePercent)
        .clamp(100.0, widget.maxLogoSize);

    return Semantics(
      label: AppStrings.splashLogoSemantics,
      image: true,
      child: _buildLogoWithEffects(logoSize),
    );
  }

  Widget _buildLogoWithEffects(double size) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          width: size,
          height: size,
          decoration: widget.showGlowEffect
              ? BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.logoBlue
                          .withValues(alpha: 0.3 * _glowAnimation.value),
                      blurRadius: 30 + (20 * _glowAnimation.value),
                      spreadRadius: 5 + (10 * _glowAnimation.value),
                    ),
                    BoxShadow(
                      color: AppColors.logoYellow
                          .withValues(alpha: 0.15 * _glowAnimation.value),
                      blurRadius: 40 + (15 * _glowAnimation.value),
                      spreadRadius: 2 + (5 * _glowAnimation.value),
                    ),
                  ],
                )
              : null,
          child: child,
        );
      },
      child: _buildLogoImage(size),
    );
  }

  Widget _buildLogoImage(double size) {
    return Image.asset(
      AppAssets.splashLogo,
      width: size,
      height: size,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      errorBuilder: (context, error, stackTrace) {
        // Fallback if logo fails to load
        return _buildFallbackLogo(size);
      },
    )
        .animate(
          onComplete: (controller) {
            widget.onAnimationComplete?.call();
          },
        )
        // Scale animation with elastic curve
        .scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1.0, 1.0),
          duration: widget.entranceDuration,
          delay: widget.delayStart,
          curve: Curves.elasticOut,
        )
        // Fade in
        .fadeIn(
          duration: Duration(
            milliseconds: (widget.entranceDuration.inMilliseconds * 0.6).round(),
          ),
          delay: widget.delayStart,
          curve: Curves.easeOut,
        )
        // Subtle rotation for 3D effect
        .rotate(
          begin: -0.02,
          end: 0.0,
          duration: widget.entranceDuration,
          delay: widget.delayStart,
          curve: Curves.easeOutBack,
        );
  }

  /// Builds a fallback logo if the asset fails to load.
  Widget _buildFallbackLogo(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.logoBlue,
            AppColors.logoYellow,
            AppColors.logoRed,
          ],
        ),
        borderRadius: BorderRadius.circular(size * 0.15),
      ),
      child: Center(
        child: Text(
          'M',
          style: TextStyle(
            fontSize: size * 0.5,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
