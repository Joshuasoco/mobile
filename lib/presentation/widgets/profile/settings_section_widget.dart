/// MSME Pathways - Settings Section Widget
///
/// Grouped settings section with header and items.
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/models/profile_model.dart';
import 'settings_item_tile.dart';

/// Settings section container with title and grouped items.
class SettingsSectionWidget extends StatelessWidget {
  const SettingsSectionWidget({
    super.key,
    required this.section,
    required this.onItemTap,
    this.offsetY = -40,
  });

  /// Section data with items.
  final SettingsSection section;

  /// Callback when an item is tapped.
  final void Function(SettingsItem item) onItemTap;

  /// Vertical offset for floating effect.
  final double offsetY;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, offsetY),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              section.title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[500],
                letterSpacing: 0.5,
              ),
            ),
          ),
          // Items container
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: section.items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isLast = index == section.items.length - 1;
                return SettingsItemTile(
                  item: item,
                  onTap: () => onItemTap(item),
                  showDivider: !isLast,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
