/// MSME Pathways - Tooltip Highlight Widget
///
/// Creates a spotlight overlay effect that dims the background
/// and highlights a specific target element.
library;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// A widget that creates a spotlight effect highlighting a target area.
class TooltipHighlight extends StatelessWidget {
  const TooltipHighlight({
    super.key,
    required this.targetRect,
    required this.child,
    this.overlayColor = Colors.black,
    this.overlayOpacity = 0.7,
    this.highlightPadding = 8.0,
    this.highlightBorderRadius = 12.0,
    this.onBackdropTap,
    this.animate = true,
  });

  /// The rect of the target element to highlight.
  final Rect targetRect;

  /// The child widget (usually the tooltip bubble).
  final Widget child;

  /// Color of the overlay.
  final Color overlayColor;

  /// Opacity of the overlay (0.0 - 1.0).
  final double overlayOpacity;

  /// Padding around the highlight area.
  final double highlightPadding;

  /// Border radius of the highlight cutout.
  final double highlightBorderRadius;

  /// Callback when the backdrop is tapped.
  final VoidCallback? onBackdropTap;

  /// Whether to animate the highlight.
  final bool animate;

  @override
  Widget build(BuildContext context) {
    Widget content = Stack(
      children: [
        // Backdrop with spotlight cutout
        Positioned.fill(
          child: GestureDetector(
            onTap: onBackdropTap,
            child: CustomPaint(
              painter: _SpotlightPainter(
                targetRect: targetRect,
                overlayColor: overlayColor,
                overlayOpacity: overlayOpacity,
                highlightPadding: highlightPadding,
                highlightBorderRadius: highlightBorderRadius,
              ),
            ),
          ),
        ),

        // Child content (tooltip)
        child,
      ],
    );

    if (animate) {
      content = content.animate().fadeIn(duration: 300.ms, curve: Curves.easeOut);
    }

    return content;
  }
}

/// Custom painter for the spotlight effect.
class _SpotlightPainter extends CustomPainter {
  _SpotlightPainter({
    required this.targetRect,
    required this.overlayColor,
    required this.overlayOpacity,
    required this.highlightPadding,
    required this.highlightBorderRadius,
  });

  final Rect targetRect;
  final Color overlayColor;
  final double overlayOpacity;
  final double highlightPadding;
  final double highlightBorderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = overlayColor.withValues(alpha: overlayOpacity)
      ..style = PaintingStyle.fill;

    // Create the outer rect (full screen)
    final outerRect = Rect.fromLTWH(0, 0, size.width, size.height);

    // Create the inner rect (highlight area with padding)
    final innerRect = RRect.fromRectAndRadius(
      targetRect.inflate(highlightPadding),
      Radius.circular(highlightBorderRadius),
    );

    // Create a path with the outer rect
    final path = Path()
      ..addRect(outerRect)
      // Subtract the inner rect to create the spotlight cutout
      ..addRRect(innerRect)
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(path, paint);

    // Optional: Add a subtle glow around the highlight
    final glowPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawRRect(innerRect, glowPaint);
  }

  @override
  bool shouldRepaint(covariant _SpotlightPainter oldDelegate) {
    return oldDelegate.targetRect != targetRect ||
        oldDelegate.overlayColor != overlayColor ||
        oldDelegate.overlayOpacity != overlayOpacity ||
        oldDelegate.highlightPadding != highlightPadding ||
        oldDelegate.highlightBorderRadius != highlightBorderRadius;
  }
}

/// A simpler dimmed overlay without spotlight (for tutorials).
class DimmedOverlay extends StatelessWidget {
  const DimmedOverlay({
    super.key,
    required this.child,
    this.overlayColor = Colors.black,
    this.overlayOpacity = 0.5,
    this.onTap,
    this.dismissOnTap = false,
  });

  /// The child widget to display over the overlay.
  final Widget child;

  /// Color of the overlay.
  final Color overlayColor;

  /// Opacity of the overlay (0.0 - 1.0).
  final double overlayOpacity;

  /// Callback when overlay is tapped.
  final VoidCallback? onTap;

  /// Whether tapping the overlay should trigger onTap.
  final bool dismissOnTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Dimmed backdrop
        Positioned.fill(
          child: GestureDetector(
            onTap: dismissOnTap ? onTap : null,
            behavior: HitTestBehavior.opaque,
            child: Container(
              color: overlayColor.withValues(alpha: overlayOpacity),
            ),
          ),
        ),

        // Child content
        child,
      ],
    );
  }
}

/// Animated spotlight that can animate between targets.
class AnimatedSpotlight extends StatefulWidget {
  const AnimatedSpotlight({
    super.key,
    required this.targetRect,
    required this.child,
    this.overlayColor = Colors.black,
    this.overlayOpacity = 0.7,
    this.highlightPadding = 8.0,
    this.highlightBorderRadius = 12.0,
    this.animationDuration = const Duration(milliseconds: 300),
    this.onBackdropTap,
  });

  final Rect targetRect;
  final Widget child;
  final Color overlayColor;
  final double overlayOpacity;
  final double highlightPadding;
  final double highlightBorderRadius;
  final Duration animationDuration;
  final VoidCallback? onBackdropTap;

  @override
  State<AnimatedSpotlight> createState() => _AnimatedSpotlightState();
}

class _AnimatedSpotlightState extends State<AnimatedSpotlight>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Rect _previousRect;
  late Rect _currentRect;

  @override
  void initState() {
    super.initState();
    _previousRect = widget.targetRect;
    _currentRect = widget.targetRect;

    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void didUpdateWidget(AnimatedSpotlight oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.targetRect != widget.targetRect) {
      _previousRect = _currentRect;
      _currentRect = widget.targetRect;
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final animatedRect = Rect.lerp(
          _previousRect,
          _currentRect,
          _animation.value,
        )!;

        return TooltipHighlight(
          targetRect: animatedRect,
          overlayColor: widget.overlayColor,
          overlayOpacity: widget.overlayOpacity,
          highlightPadding: widget.highlightPadding,
          highlightBorderRadius: widget.highlightBorderRadius,
          onBackdropTap: widget.onBackdropTap,
          animate: false,
          child: widget.child,
        );
      },
    );
  }
}
