/// MSME Pathways - Notifications Screen
/// 
/// Display notifications list with grouping and management.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/notification_model.dart';
import '../../viewmodels/notifications_viewmodel.dart';

/// Notifications list screen.
class NotificationsScreen extends StatelessWidget {
  /// Creates the notifications screen.
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NotificationsViewModel(),
      child: const _NotificationsContent(),
    );
  }
}

class _NotificationsContent extends StatefulWidget {
  const _NotificationsContent();

  @override
  State<_NotificationsContent> createState() => _NotificationsContentState();
}

class _NotificationsContentState extends State<_NotificationsContent> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationsViewModel>(
      builder: (context, viewModel, _) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF2D3748)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              'Notifications',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2D3748),
              ),
            ),
            centerTitle: true,
            actions: [
              if (viewModel.unreadCount > 0)
                TextButton(
                  onPressed: viewModel.markAllAsRead,
                  child: Text(
                    'Mark all read',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              IconButton(
                icon: const Icon(Icons.settings_outlined, color: Color(0xFF2D3748)),
                onPressed: () => _openSettings(context, viewModel),
              ),
            ],
          ),
          body: viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : viewModel.notifications.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                      onRefresh: viewModel.refresh,
                      child: _buildNotificationList(viewModel),
                    ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 64,
            color: const Color(0xFFA0AEC0),
          ),
          const SizedBox(height: 16),
          Text(
            'All caught up!',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You have no new notifications',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF718096),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationList(NotificationsViewModel viewModel) {
    final grouped = viewModel.groupedNotifications;
    
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: grouped.length,
      itemBuilder: (context, index) {
        final entry = grouped.entries.elementAt(index);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date header
            Padding(
              padding: EdgeInsets.only(bottom: 12, top: index == 0 ? 0 : 16),
              child: Text(
                entry.key,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF718096),
                ),
              ),
            ),
            
            // Notifications
            ...entry.value.map((notification) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Dismissible(
                  key: Key(notification.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => viewModel.deleteNotification(notification.id),
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.delete_outline,
                      color: Colors.white,
                    ),
                  ),
                  child: _NotificationTile(
                    notification: notification,
                    onTap: () {
                      viewModel.markAsRead(notification.id);
                      // Navigate if action route is present
                      if (notification.actionRoute != null) {
                        // Navigator.of(context).pushNamed(notification.actionRoute!);
                      }
                    },
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }

  void _openSettings(BuildContext context, NotificationsViewModel viewModel) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
          value: viewModel,
          child: const NotificationSettingsScreen(),
        ),
      ),
    );
  }
}

/// Notification tile widget.
class _NotificationTile extends StatelessWidget {
  final NotificationItem notification;
  final VoidCallback onTap;

  const _NotificationTile({
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: notification.isRead
              ? Colors.white
              : AppColors.primary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: notification.isRead
                ? const Color(0xFFE2E8F0)
                : AppColors.primary.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Type icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _getTypeColor(notification.type).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getTypeIcon(notification.type),
                color: _getTypeColor(notification.type),
                size: 22,
              ),
            ),
            
            const SizedBox(width: 14),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: notification.isRead
                                ? FontWeight.w500
                                : FontWeight.w600,
                            color: const Color(0xFF2D3748),
                          ),
                        ),
                      ),
                      if (!notification.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.body,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: const Color(0xFF718096),
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    notification.timeAgo,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: const Color(0xFFA0AEC0),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getTypeColor(NotificationType type) {
    switch (type) {
      case NotificationType.loan:
        return AppColors.primary;
      case NotificationType.payment:
        return AppColors.success;
      case NotificationType.education:
        return const Color(0xFF5C6BC0);
      case NotificationType.promo:
        return const Color(0xFFFF7043);
      case NotificationType.system:
        return const Color(0xFF718096);
    }
  }

  IconData _getTypeIcon(NotificationType type) {
    switch (type) {
      case NotificationType.loan:
        return Icons.account_balance_wallet_outlined;
      case NotificationType.payment:
        return Icons.payment_outlined;
      case NotificationType.education:
        return Icons.school_outlined;
      case NotificationType.promo:
        return Icons.local_offer_outlined;
      case NotificationType.system:
        return Icons.settings_outlined;
    }
  }
}

/// Notification settings screen.
class NotificationSettingsScreen extends StatelessWidget {
  /// Creates the notification settings screen.
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationsViewModel>(
      builder: (context, viewModel, _) {
        final prefs = viewModel.preferences;
        
        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF2D3748)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              'Notification Settings',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2D3748),
              ),
            ),
            centerTitle: true,
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Info banner
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: Color(0xFF1565C0),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Customize which notifications you receive',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: const Color(0xFF1565C0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Notification toggles
              _buildToggle(
                'Loan Updates',
                'Status changes, approvals, disbursements',
                Icons.account_balance_wallet_outlined,
                prefs.loanUpdates,
                (value) => viewModel.updatePreference(loanUpdates: value),
              ),
              _buildToggle(
                'Payment Reminders',
                'Due dates and payment confirmations',
                Icons.payment_outlined,
                prefs.paymentReminders,
                (value) => viewModel.updatePreference(paymentReminders: value),
              ),
              _buildToggle(
                'Learning Content',
                'New courses and educational materials',
                Icons.school_outlined,
                prefs.educationalContent,
                (value) => viewModel.updatePreference(educationalContent: value),
              ),
              _buildToggle(
                'Promotional Offers',
                'Special rates and partner offers',
                Icons.local_offer_outlined,
                prefs.promotionalOffers,
                (value) => viewModel.updatePreference(promotionalOffers: value),
              ),
              _buildToggle(
                'System Notifications',
                'App updates and account security',
                Icons.settings_outlined,
                prefs.systemNotifications,
                (value) => viewModel.updatePreference(systemNotifications: value),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildToggle(
    String title,
    String description,
    IconData icon,
    bool value,
    void Function(bool) onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7FA),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2D3748),
                  ),
                ),
                Text(
                  description,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF718096),
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
