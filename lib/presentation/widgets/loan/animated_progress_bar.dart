/// Animated Progress Bar Widget
///
/// Displays an animated progress bar with smooth ease-in-out transition,
/// progress percentage, amount paid, and next payment due date.
library;

import 'package:flutter/material.dart';

/// Animated progress bar showing payment progress.
///
/// Features:
/// - Smooth animation from 0% to target progress (600-800ms)
/// - Ease-in-out curve for natural motion
/// - Green progress fill on light gray background
/// - Progress percentage display
/// - Amount paid label on the right
/// - Calendar icon with next payment due date
class AnimatedProgressBar extends StatefulWidget {
  /// Progress value between 0.0 and 1.0 (e.g., 0.33 for 33%).
  final double progress;

  /// Label to display on the right side (e.g., "₱8,333 Paid").
  final String label;

  /// Next payment due date text.
  final String nextPaymentDue;

  /// Creates an animated progress bar.
  const AnimatedProgressBar({
    required this.progress,
    required this.label,
    required this.nextPaymentDue,
    super.key,
  });

  @override
  State<AnimatedProgressBar> createState() => _AnimatedProgressBarState();
}

class _AnimatedProgressBarState extends State<AnimatedProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Create animation controller
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    // Create animation with ease-in-out curve
    _animation = Tween<double>(begin: 0.0, end: widget.progress).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Start animation after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
  }

  @override
  void didUpdateWidget(AnimatedProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _animation = Tween<double>(begin: _animation.value, end: widget.progress)
          .animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOut,
        ),
      );
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress bar with percentage label
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress bar container
                  Container(
                    height: 12,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E7EB),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                        return Stack(
                          children: [
                            // Background bar
                            Container(
                              width: double.infinity,
                              height: double.infinity,
                              color: const Color(0xFFE5E7EB),
                            ),
                            // Animated progress fill
                            Container(
                              width: double.infinity * _animation.value,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Color(0xFF16A34A),
                                    Color(0xFF22C55E),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            // Subtle shimmer effect at the end
                            if (_animation.value > 0)
                              Positioned(
                                left: (MediaQuery.of(context).size.width - 40) *
                                    _animation.value,
                                top: 0,
                                bottom: 0,
                                child: Container(
                                  width: 8,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF22C55E)
                                            .withOpacity(0.3),
                                        blurRadius: 6,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Percentage text
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      final percentage =
                          (_animation.value * 100).toStringAsFixed(0);
                      return Text(
                        '$percentage% Complete',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF374151),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Amount paid label
            Text(
              widget.label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF22C55E),
              ),
              textAlign: TextAlign.right,
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Next payment due date with calendar icon
        Row(
          children: [
            Icon(
              Icons.calendar_today,
              size: 16,
              color: const Color(0xFF22C55E),
            ),
            const SizedBox(width: 8),
            Text(
              'Next payment due: ${widget.nextPaymentDue}',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
