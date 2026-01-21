/// MSME Pathways - Feature Navigation Section Widget
///
/// Grid layout container for the 5 main feature navigation cards.
/// Uses Option A layout: 2x2 grid + 1 full width card.
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/models/home_dashboard_model.dart';
import 'feature_card.dart';

/// Feature navigation section with grid layout.
///
/// Displays feature cards in a 2x2 grid with the last card
/// spanning full width for better visual hierarchy.
class FeatureNavigationSection extends StatelessWidget {
  const FeatureNavigationSection({
    super.key,
    required this.features,
    required this.onFeatureTap,
    this.title = 'Services',
  });

  /// List of feature items to display.
  final List<FeatureCardItem> features;

  /// Callback when a feature card is tapped.
  /// Receives the feature item that was tapped.
  final void Function(FeatureCardItem feature) onFeatureTap;

  /// Section title.
  final String title;

  @override
  Widget build(BuildContext context) {
    if (features.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 16),
        // Feature cards grid
        _buildFeatureGrid(),
      ],
    );
  }

  Widget _buildFeatureGrid() {
    // Using Option A layout: 2x2 grid + 1 full width
    // First 4 cards in 2x2 grid, 5th card full width
    
    final gridItems = features.take(4).toList();
    final fullWidthItem = features.length >= 5 ? features[4] : null;

    return Column(
      children: [
        // 2x2 Grid for first 4 items
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.0,
          ),
          itemCount: gridItems.length,
          itemBuilder: (context, index) {
            final item = gridItems[index];
            return FeatureCard(
              item: item,
              onTap: () => onFeatureTap(item),
            );
          },
        ),
        // Full width card for 5th item (Notifications)
        if (fullWidthItem != null) ...[
          const SizedBox(height: 14),
          SizedBox(
            height: 80,
            child: FeatureCard(
              item: fullWidthItem,
              onTap: () => onFeatureTap(fullWidthItem),
              isFullWidth: true,
            ),
          ),
        ],
      ],
    );
  }
}
