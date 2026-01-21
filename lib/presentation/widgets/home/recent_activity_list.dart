/// MSME Pathways - Recent Activity List Widget
///
/// Displays a list of recent user activity items.
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/models/home_dashboard_model.dart';

/// Recent activity list section.
///
/// Displays a vertical list of recent activities with
/// icons, titles, and timestamps.
class RecentActivityList extends StatelessWidget {
  const RecentActivityList({
    super.key,
    required this.activities,
    this.onActivityTap,
    this.maxItems = 3,
  });

  /// List of activity items.
  final List<ActivityItem> activities;

  /// Optional callback when an activity is tapped.
  final void Function(ActivityItem activity)? onActivityTap;

  /// Maximum number of items to display.
  final int maxItems;

  @override
  Widget build(BuildContext context) {
    if (activities.isEmpty) {
      return _buildEmptyState();
    }

    final displayedActivities = activities.take(maxItems).toList();

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
      child: Column(
        children: [
          for (int i = 0; i < displayedActivities.length; i++) ...[
            _ActivityListItem(
              activity: displayedActivities[i],
              onTap: onActivityTap != null
                  ? () => onActivityTap!(displayedActivities[i])
                  : null,
            ),
            if (i < displayedActivities.length - 1)
              const Divider(height: 24),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(24),
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
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.history_outlined,
              size: 40,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 8),
            Text(
              'No recent activity',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Individual activity list item.
class _ActivityListItem extends StatelessWidget {
  const _ActivityListItem({
    required this.activity,
    this.onTap,
  });

  final ActivityItem activity;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: activity.iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              activity.icon,
              color: activity.iconColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  activity.subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          if (onTap != null || activity.route != null)
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey[400],
            ),
        ],
      ),
    );
  }
}
