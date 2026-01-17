/// MSME Pathways - Notification Screen
///
/// Displays a list of notifications with modern iOS-style design.
/// Features notification grouping, read/unread states, and swipe actions.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

/// Notification screen displaying user notifications.
///
/// Features:
/// - Clean white background
/// - Grouped notifications (Today, Yesterday, Earlier)
/// - Read/unread states
/// - iOS-style design with soft shadows
/// - Empty state for no notifications
class NotificationScreen extends StatefulWidget {
  /// Creates the notification screen.
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    _setLightSystemUI();
  }

  /// Sets light system UI overlay style for this screen.
  void _setLightSystemUI() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Color(0xFFFFFFFF),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: _buildAppBar(context),
      body: _buildBody(),
    );
  }

  /// Builds the app bar.
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      shadowColor: Colors.black.withOpacity(0.05),
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_rounded,
          color: Color(0xFF2D3748),
          size: 20,
        ),
        onPressed: () => context.pop(),
      ),
      title: Text(
        'Notifications',
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF2D3748),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Mark all as read
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('All notifications marked as read'),
                duration: Duration(seconds: 2),
              ),
            );
          },
          child: Text(
            'Mark all read',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF22C55E),
            ),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  /// Builds the body content.
  Widget _buildBody() {
    // Sample notification data
    final notifications = _getSampleNotifications();

    if (notifications.isEmpty) {
      return _buildEmptyState();
    }

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 12),
      children: [
        // Today section
        _buildNotificationSection(
          'Today',
          notifications.where((n) => n.section == 'Today').toList(),
        ),
        
        // Yesterday section
        _buildNotificationSection(
          'Yesterday',
          notifications.where((n) => n.section == 'Yesterday').toList(),
        ),
        
        // Earlier section
        _buildNotificationSection(
          'Earlier',
          notifications.where((n) => n.section == 'Earlier').toList(),
        ),
      ],
    );
  }

  /// Builds a notification section with title and items.
  Widget _buildNotificationSection(String title, List<NotificationItem> items) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF6B7280),
            ),
          ),
        ),
        ...items.map((item) => _buildNotificationItem(item)),
      ],
    );
  }

  /// Builds a single notification item.
  Widget _buildNotificationItem(NotificationItem item) {
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red[400],
        child: const Icon(
          Icons.delete_outline_rounded,
          color: Colors.white,
          size: 24,
        ),
      ),
      onDismissed: (direction) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${item.title} dismissed'),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: item.isRead ? Colors.white : const Color(0xFFF0FDF4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: item.isRead
                ? Colors.transparent
                : const Color(0xFFDCFCE7),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              // Handle notification tap
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Opened: ${item.title}'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: item.iconColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      item.icon,
                      color: item.iconColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                item.title,
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: item.isRead
                                      ? FontWeight.w500
                                      : FontWeight.w600,
                                  color: const Color(0xFF1F2937),
                                ),
                              ),
                            ),
                            if (!item.isRead)
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF22C55E),
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.message,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: const Color(0xFF6B7280),
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item.time,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: const Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the empty state when there are no notifications.
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(60),
              ),
              child: const Icon(
                Icons.notifications_outlined,
                size: 60,
                color: Color(0xFF22C55E),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Notifications',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You\'re all caught up! Check back later for updates.',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: const Color(0xFF6B7280),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Returns sample notification data.
  List<NotificationItem> _getSampleNotifications() {
    return [
      NotificationItem(
        id: '1',
        title: 'Loan Application Approved',
        message: 'Your business loan application for ₱25,000 has been approved! Tap to view details.',
        time: '2 hours ago',
        icon: Icons.check_circle_rounded,
        iconColor: const Color(0xFF22C55E),
        isRead: false,
        section: 'Today',
      ),
      NotificationItem(
        id: '2',
        title: 'Payment Reminder',
        message: 'Your next loan payment of ₱2,083 is due on Jan 1, 2026.',
        time: '5 hours ago',
        icon: Icons.calendar_today_rounded,
        iconColor: const Color(0xFFF59E0B),
        isRead: false,
        section: 'Today',
      ),
      NotificationItem(
        id: '3',
        title: 'New Learning Resource',
        message: 'A new course "Advanced Financial Planning" is now available.',
        time: 'Yesterday, 3:30 PM',
        icon: Icons.school_rounded,
        iconColor: const Color(0xFF3B82F6),
        isRead: true,
        section: 'Yesterday',
      ),
      NotificationItem(
        id: '4',
        title: 'Profile Update Successful',
        message: 'Your business profile has been updated successfully.',
        time: 'Yesterday, 10:15 AM',
        icon: Icons.person_rounded,
        iconColor: const Color(0xFF8B5CF6),
        isRead: true,
        section: 'Yesterday',
      ),
      NotificationItem(
        id: '5',
        title: 'Welcome to MSME Pathways!',
        message: 'Thank you for joining us. Complete your profile to access loan services.',
        time: 'Jan 15, 2026',
        icon: Icons.celebration_rounded,
        iconColor: const Color(0xFFEC4899),
        isRead: true,
        section: 'Earlier',
      ),
    ];
  }
}

/// Model for a notification item.
class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String time;
  final IconData icon;
  final Color iconColor;
  final bool isRead;
  final String section;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.icon,
    required this.iconColor,
    required this.isRead,
    required this.section,
  });
}
