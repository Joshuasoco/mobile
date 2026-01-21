/// MSME Pathways - Quick Actions Row Widget
///
/// Horizontal row of quick action buttons for the home screen.
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/models/home_dashboard_model.dart';

/// Quick actions row with circular action buttons.
///
/// Displays a horizontal row of quick action items
/// with icons and labels.
class QuickActionsRow extends StatelessWidget {
  const QuickActionsRow({
    super.key,
    required this.actions,
    required this.onActionTap,
  });

  /// List of quick action items.
  final List<QuickActionItem> actions;

  /// Callback when an action is tapped.
  final void Function(QuickActionItem action) onActionTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: actions.map((action) {
          return _QuickActionItem(
            item: action,
            onTap: () => onActionTap(action),
          );
        }).toList(),
      ),
    );
  }
}

/// Individual quick action item button.
class _QuickActionItem extends StatelessWidget {
  const _QuickActionItem({
    required this.item,
    required this.onTap,
  });

  final QuickActionItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  item.color.withValues(alpha: 0.15),
                  item.color.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: item.color.withValues(alpha: 0.2), width: 1),
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    item.icon,
                    color: item.color,
                    size: 26,
                  ),
                ),
                if (item.badge != null)
                  Positioned(
                    right: 4,
                    top: 4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: item.color,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${item.badge}',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.label,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
