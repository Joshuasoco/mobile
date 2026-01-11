/// MSME Pathways - Custom Page Indicator
/// 
/// A custom page indicator widget using smooth_page_indicator.
library;

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../core/theme/app_colors.dart';

/// Custom page indicator with MSME Pathways styling.
/// 
/// Wraps [SmoothPageIndicator] with brand colors and
/// accessibility support.
class CustomPageIndicator extends StatelessWidget {
  /// Creates a custom page indicator.
  const CustomPageIndicator({
    super.key,
    required this.controller,
    required this.count,
    this.onDotClicked,
  });

  /// PageController to track current page
  final PageController controller;

  /// Total number of pages
  final int count;

  /// Optional callback when a dot is tapped
  final void Function(int)? onDotClicked;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Page indicator, $count pages',
      child: SmoothPageIndicator(
        controller: controller,
        count: count,
        effect: ExpandingDotsEffect(
          dotHeight: 8,
          dotWidth: 8,
          expansionFactor: 3,
          spacing: 8,
          activeDotColor: AppColors.primary,
          dotColor: AppColors.textTertiary.withAlpha(76), // 0.3 opacity
        ),
        onDotClicked: onDotClicked,
      ),
    );
  }
}
