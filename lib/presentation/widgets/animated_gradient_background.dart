/// MSME Pathways - Animated Gradient Background
/// 
/// A widget that displays a subtle animated gradient background
/// for visual interest and modern aesthetic.
library;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// An animated gradient background with subtle motion.
/// 
/// Uses an [AnimationController] to create a slowly shifting gradient
/// that adds visual depth without being distracting.
class AnimatedGradientBackground extends StatefulWidget {
  /// Creates an animated gradient background.
  const AnimatedGradientBackground({
    super.key,
    this.child,
    this.colors,
    this.duration = const Duration(seconds: 8),
  });

  /// Optional child widget to display on top of the gradient
  final Widget? child;

  /// Optional custom colors for the gradient
  final List<Color>? colors;

  /// Duration of one complete animation cycle
  final Duration duration;

  @override
  State<AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  // Default gradient colors
  List<Color> get _colors => widget.colors ?? [
    AppColors.surface,
    const Color(0xFFF0F7F7),
    const Color(0xFFF5F0F5),
    AppColors.surface,
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);
    
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      listenable: _animation,
      builder: (context, child) {
        // Calculate dynamic alignment based on animation value
        final value = _animation.value;
        
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(
                -1.0 + (value * 0.5),
                -1.0 + (value * 0.3),
              ),
              end: Alignment(
                1.0 - (value * 0.3),
                1.0 - (value * 0.5),
              ),
              colors: _colors,
              stops: [
                0.0,
                0.3 + (value * 0.1),
                0.7 - (value * 0.1),
                1.0,
              ],
            ),
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// A simplified animated builder for gradient animations.
class AnimatedBuilder extends AnimatedWidget {
  const AnimatedBuilder({
    super.key,
    required super.listenable,
    required this.builder,
    this.child,
  });

  final Widget Function(BuildContext context, Widget? child) builder;
  final Widget? child;

  Animation<double> get animation => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    return builder(context, child);
  }
}
