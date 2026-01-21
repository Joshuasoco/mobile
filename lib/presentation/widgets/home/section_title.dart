/// MSME Pathways - Section Title Widget
///
/// Reusable section title with optional "See All" button.
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Primary accent color.
const Color _kPrimaryColor = Color(0xFF00897B);

/// Section title widget with optional action.
///
/// Displays a title with an optional "See All" button
/// aligned to the right.
class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.title,
    this.onSeeAll,
    this.actionText = 'See All',
  });

  /// Section title text.
  final String title;

  /// Optional callback when action is tapped.
  final VoidCallback? onSeeAll;

  /// Action button text.
  final String actionText;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1A202C),
          ),
        ),
        if (onSeeAll != null)
          InkWell(
            onTap: onSeeAll,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _kPrimaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    actionText,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: _kPrimaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 12,
                    color: _kPrimaryColor,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
