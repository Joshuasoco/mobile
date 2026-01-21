/// MSME Pathways - Home App Bar Widget
///
/// Custom sliver app bar with gradient background, user greeting,
/// notification badge, and profile avatar.
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Primary accent color for the app bar.
const Color _kPrimaryColor = Color(0xFF00897B);

/// Custom sliver app bar for the home screen.
///
/// Displays:
/// - Gradient background
/// - User greeting with name
/// - Welcome message
/// - Notification icon with badge
/// - Profile avatar
class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    super.key,
    required this.greeting,
    required this.userName,
    required this.onNotificationsTap,
    required this.onProfileTap,
    this.hasUnreadNotifications = false,
  });

  /// Time-based greeting (e.g., "Good morning").
  final String greeting;

  /// User's display name.
  final String userName;

  /// Callback when notifications icon is tapped.
  final VoidCallback onNotificationsTap;

  /// Callback when profile avatar is tapped.
  final VoidCallback onProfileTap;

  /// Whether there are unread notifications.
  final bool hasUnreadNotifications;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 160,
      floating: false,
      pinned: true,
      automaticallyImplyLeading: false,
      backgroundColor: _kPrimaryColor,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF00897B),
                Color(0xFF00695C),
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User greeting
                  _buildGreetingSection(),
                  // Profile avatar and notification
                  _buildActionsSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGreetingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$greeting, $userName! 👋',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Welcome to MSME Pathways',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildActionsSection() {
    return Row(
      children: [
        // Notification icon
        InkWell(
          onTap: onNotificationsTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                const Icon(
                  Icons.notifications_outlined,
                  color: Colors.white,
                  size: 24,
                ),
                if (hasUnreadNotifications)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Profile avatar
        InkWell(
          onTap: onProfileTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.person_rounded,
              color: _kPrimaryColor,
              size: 26,
            ),
          ),
        ),
      ],
    );
  }
}
