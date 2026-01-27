/// MSME Pathways - Tooltip Bubble Widget
///
/// A styled tooltip bubble component with arrow pointer,
/// following the MSME Pathways design system.
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/tooltip_model.dart';

/// A styled tooltip bubble with arrow pointer.
class TooltipBubble extends StatelessWidget {
  const TooltipBubble({
    super.key,
    required this.config,
    required this.onDismiss,
    this.onDontShowAgain,
    this.onSkipAll,
    this.showProgress = false,
    this.currentIndex = 0,
    this.totalCount = 1,
    this.position,
    this.maxWidth = 280,
    this.backgroundColor,
    this.textColor,
    this.arrowOffset,
  });

  /// Tooltip configuration.
  final TooltipConfig config;

  /// Callback when tooltip is dismissed.
  final VoidCallback onDismiss;

  /// Callback for "Don't show again" action.
  final VoidCallback? onDontShowAgain;

  /// Callback to skip all remaining tooltips.
  final VoidCallback? onSkipAll;

  /// Whether to show progress indicator.
  final bool showProgress;

  /// Current tooltip index (0-based).
  final int currentIndex;

  /// Total number of tooltips.
  final int totalCount;

  /// Override position (uses config.position if null).
  final TooltipPosition? position;

  /// Maximum width of the tooltip.
  final double maxWidth;

  /// Background color override.
  final Color? backgroundColor;

  /// Text color override.
  final Color? textColor;

  /// Custom arrow horizontal offset from left edge (for dynamic positioning).
  /// If null, arrow will be positioned based on CrossAxisAlignment.
  final double? arrowOffset;

  @override
  Widget build(BuildContext context) {
    final tooltipPosition = position ?? config.position;
    final bgColor = backgroundColor ?? AppColors.primary;
    final txtColor = textColor ?? Colors.white;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: arrowOffset != null 
            ? CrossAxisAlignment.start 
            : _getCrossAxisAlignment(tooltipPosition),
        children: [
          // Arrow at top for bottom-positioned tooltips
          if (_shouldShowArrowOnTop(tooltipPosition) && config.showArrow)
            _buildArrowWithOffset(tooltipPosition, bgColor),

          // Main bubble content
          Container(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Material(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header row with close button
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title and message
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (config.title != null) ...[
                                  Text(
                                    config.title!,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: txtColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                ],
                                Text(
                                  config.message,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: txtColor.withValues(alpha: 0.9),
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Close button
                          if (config.dismissible)
                            GestureDetector(
                              onTap: onDismiss,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.close,
                                  size: 16,
                                  color: txtColor.withValues(alpha: 0.8),
                                ),
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Progress and actions row
                      Row(
                        children: [
                          // Progress indicator
                          if (showProgress && totalCount > 1) ...[
                            _buildProgressIndicator(txtColor),
                            const Spacer(),
                          ] else
                            const Spacer(),

                          // Action buttons
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Skip all button
                              if (onSkipAll != null && totalCount > 1)
                                TextButton(
                                  onPressed: onSkipAll,
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(
                                    'Skip all',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: txtColor.withValues(alpha: 0.7),
                                    ),
                                  ),
                                ),

                              const SizedBox(width: 8),

                              // Got it button
                              ElevatedButton(
                                onPressed: onDismiss,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: bgColor,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  minimumSize: Size.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  'Got it',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Don't show again checkbox
                      if (config.showDontShowAgain && onDontShowAgain != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: GestureDetector(
                            onTap: onDontShowAgain,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.visibility_off_outlined,
                                  size: 14,
                                  color: txtColor.withValues(alpha: 0.6),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "Don't show again",
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: txtColor.withValues(alpha: 0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Arrow at bottom for top-positioned tooltips
          if (_shouldShowArrowOnBottom(tooltipPosition) && config.showArrow)
            _buildArrowWithOffset(tooltipPosition, bgColor),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms, curve: Curves.easeOut)
        .scale(
          begin: const Offset(0.95, 0.95),
          end: const Offset(1, 1),
          duration: 300.ms,
          curve: Curves.easeOut,
        );
  }

  Widget _buildProgressIndicator(Color txtColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < totalCount; i++) ...[
          Container(
            width: i == currentIndex ? 16 : 6,
            height: 6,
            decoration: BoxDecoration(
              color: i == currentIndex
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          if (i < totalCount - 1) const SizedBox(width: 4),
        ],
      ],
    );
  }

  Widget _buildArrow(TooltipPosition position, Color bgColor) {
    return CustomPaint(
      painter: _ArrowPainter(
        color: bgColor,
        position: position,
      ),
      size: const Size(20, 10),
    );
  }

  /// Builds the arrow with optional custom horizontal offset for precise targeting.
  Widget _buildArrowWithOffset(TooltipPosition position, Color bgColor) {
    if (arrowOffset != null) {
      // Use custom offset - position arrow at specific horizontal location
      return Padding(
        padding: EdgeInsets.only(left: arrowOffset!),
        child: CustomPaint(
          painter: _ArrowPainter(
            color: bgColor,
            position: position,
          ),
          size: const Size(20, 10),
        ),
      );
    }
    // Fall back to default arrow positioning
    return _buildArrow(position, bgColor);
  }

  CrossAxisAlignment _getCrossAxisAlignment(TooltipPosition position) {
    switch (position) {
      case TooltipPosition.topLeft:
      case TooltipPosition.bottomLeft:
        return CrossAxisAlignment.start;
      case TooltipPosition.topRight:
      case TooltipPosition.bottomRight:
        return CrossAxisAlignment.end;
      default:
        return CrossAxisAlignment.center;
    }
  }

  bool _shouldShowArrowOnTop(TooltipPosition position) {
    return position == TooltipPosition.bottom ||
        position == TooltipPosition.bottomLeft ||
        position == TooltipPosition.bottomRight;
  }

  bool _shouldShowArrowOnBottom(TooltipPosition position) {
    return position == TooltipPosition.top ||
        position == TooltipPosition.topLeft ||
        position == TooltipPosition.topRight;
  }
}

/// Custom painter for the tooltip arrow.
class _ArrowPainter extends CustomPainter {
  _ArrowPainter({
    required this.color,
    required this.position,
  });

  final Color color;
  final TooltipPosition position;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    switch (position) {
      case TooltipPosition.top:
      case TooltipPosition.topLeft:
      case TooltipPosition.topRight:
        // Arrow pointing down
        path.moveTo(0, 0);
        path.lineTo(size.width / 2, size.height);
        path.lineTo(size.width, 0);
        path.close();
        break;
      case TooltipPosition.bottom:
      case TooltipPosition.bottomLeft:
      case TooltipPosition.bottomRight:
        // Arrow pointing up
        path.moveTo(0, size.height);
        path.lineTo(size.width / 2, 0);
        path.lineTo(size.width, size.height);
        path.close();
        break;
      case TooltipPosition.left:
        // Arrow pointing right
        path.moveTo(0, 0);
        path.lineTo(size.width, size.height / 2);
        path.lineTo(0, size.height);
        path.close();
        break;
      case TooltipPosition.right:
        // Arrow pointing left
        path.moveTo(size.width, 0);
        path.lineTo(0, size.height / 2);
        path.lineTo(size.width, size.height);
        path.close();
        break;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ArrowPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.position != position;
  }
}

/// Helper to calculate tooltip bubble position relative to target.
class TooltipPositionCalculator {
  const TooltipPositionCalculator._();

  /// Calculate the optimal offset for the tooltip relative to target.
  static Offset calculateOffset({
    required Rect targetRect,
    required Size tooltipSize,
    required Size screenSize,
    required TooltipPosition position,
    double arrowHeight = 10,
    double padding = 16,
    double bottomInset = 0,
    double topInset = 0,
  }) {
    double dx;
    double dy;

    switch (position) {
      case TooltipPosition.top:
        dx = targetRect.center.dx - tooltipSize.width / 2;
        dy = targetRect.top - tooltipSize.height - arrowHeight - 8;
        break;
      case TooltipPosition.topLeft:
        dx = targetRect.left;
        dy = targetRect.top - tooltipSize.height - arrowHeight - 8;
        break;
      case TooltipPosition.topRight:
        dx = targetRect.right - tooltipSize.width;
        dy = targetRect.top - tooltipSize.height - arrowHeight - 8;
        break;
      case TooltipPosition.bottom:
        dx = targetRect.center.dx - tooltipSize.width / 2;
        dy = targetRect.bottom + arrowHeight + 8;
        break;
      case TooltipPosition.bottomLeft:
        dx = targetRect.left;
        dy = targetRect.bottom + arrowHeight + 8;
        break;
      case TooltipPosition.bottomRight:
        dx = targetRect.right - tooltipSize.width;
        dy = targetRect.bottom + arrowHeight + 8;
        break;
      case TooltipPosition.left:
        dx = targetRect.left - tooltipSize.width - arrowHeight - 8;
        dy = targetRect.center.dy - tooltipSize.height / 2;
        break;
      case TooltipPosition.right:
        dx = targetRect.right + arrowHeight + 8;
        dy = targetRect.center.dy - tooltipSize.height / 2;
        break;
    }

    // Clamp to screen bounds (accounting for bottom nav and safe areas)
    final maxX = screenSize.width - tooltipSize.width - padding;
    final maxY = screenSize.height - tooltipSize.height - padding - bottomInset;
    final minY = padding + topInset;
    
    dx = dx.clamp(padding, maxX);
    dy = dy.clamp(minY, maxY);

    return Offset(dx, dy);
  }

  /// Determine the best position for a tooltip given screen constraints.
  static TooltipPosition calculateBestPosition({
    required Rect targetRect,
    required Size screenSize,
    double tooltipHeight = 180,
    double tooltipWidth = 280,
    double padding = 16,
    double bottomInset = 0,
    double topInset = 0,
  }) {
    final spaceAbove = targetRect.top - padding - topInset;
    final spaceBelow = screenSize.height - targetRect.bottom - padding - bottomInset;
    final spaceLeft = targetRect.left - padding;
    final spaceRight = screenSize.width - targetRect.right - padding;

    // Prefer top position if near bottom of screen (near nav bar)
    // This ensures tooltips don't overlap with bottom navigation
    // Use a more aggressive threshold to catch elements near the bottom
    final isNearBottom = targetRect.bottom > (screenSize.height - bottomInset - tooltipHeight - 80);
    
    if (isNearBottom && spaceAbove >= tooltipHeight) {
      return TooltipPosition.top;
    }

    // Calculate scores for each position
    final scores = <TooltipPosition, double>{
      TooltipPosition.top: spaceAbove >= tooltipHeight ? spaceAbove : 0,
      TooltipPosition.bottom: spaceBelow >= tooltipHeight ? spaceBelow : 0,
      TooltipPosition.right:
          spaceRight >= tooltipWidth ? math.min(spaceRight, 200) : 0,
      TooltipPosition.left:
          spaceLeft >= tooltipWidth ? math.min(spaceLeft, 200) : 0,
    };

    // Return position with highest score
    final sortedEntries = scores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedEntries.first.key;
  }
  
  /// Calculate the horizontal offset for the arrow to point at the target center.
  /// Returns the offset from the left edge of the tooltip where the arrow should be.
  static double calculateArrowOffset({
    required Rect targetRect,
    required double tooltipLeft,
    required double tooltipWidth,
    double arrowWidth = 20,
    double minPadding = 24,
  }) {
    // Calculate where the target center is relative to the tooltip
    final targetCenterX = targetRect.center.dx;
    final arrowCenterX = targetCenterX - tooltipLeft;
    
    // Clamp to keep arrow within tooltip bounds with padding
    final minOffset = minPadding;
    final maxOffset = tooltipWidth - arrowWidth - minPadding;
    
    return arrowCenterX.clamp(minOffset, maxOffset);
  }
}
