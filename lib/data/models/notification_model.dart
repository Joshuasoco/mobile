/// MSME Pathways - Notification Models
/// 
/// Data models for push notification UI.
library;

/// Type of notification.
enum NotificationType {
  /// Loan updates
  loan('Loan Updates', 'wallet'),
  /// Payment reminders
  payment('Payments', 'payment'),
  /// Educational content
  education('Learning', 'school'),
  /// Promotional offers
  promo('Offers', 'offer'),
  /// System notifications
  system('System', 'settings');

  final String label;
  final String iconName;
  const NotificationType(this.label, this.iconName);
}

/// Represents a notification item.
class NotificationItem {
  /// Unique ID.
  final String id;

  /// Notification title.
  final String title;

  /// Notification body.
  final String body;

  /// Type of notification.
  final NotificationType type;

  /// When received.
  final DateTime timestamp;

  /// Whether read.
  final bool isRead;

  /// Action to take when tapped.
  final String? actionRoute;

  /// Additional data.
  final Map<String, dynamic>? data;

  /// Creates a notification item.
  const NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.actionRoute,
    this.data,
  });

  /// Creates a copy with updated fields.
  NotificationItem copyWith({
    bool? isRead,
  }) {
    return NotificationItem(
      id: id,
      title: title,
      body: body,
      type: type,
      timestamp: timestamp,
      isRead: isRead ?? this.isRead,
      actionRoute: actionRoute,
      data: data,
    );
  }

  /// Relative time string.
  String get timeAgo {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${diff.inDays ~/ 7}w ago';
  }
}

/// Notification preferences.
class NotificationPreferences {
  /// Enable loan updates.
  final bool loanUpdates;

  /// Enable payment reminders.
  final bool paymentReminders;

  /// Enable educational content.
  final bool educationalContent;

  /// Enable promotional offers.
  final bool promotionalOffers;

  /// Enable system notifications.
  final bool systemNotifications;

  /// Quiet hours start (hour of day, 0-23).
  final int? quietHoursStart;

  /// Quiet hours end (hour of day, 0-23).
  final int? quietHoursEnd;

  /// Creates notification preferences.
  const NotificationPreferences({
    this.loanUpdates = true,
    this.paymentReminders = true,
    this.educationalContent = true,
    this.promotionalOffers = false,
    this.systemNotifications = true,
    this.quietHoursStart,
    this.quietHoursEnd,
  });

  /// Creates a copy with updated fields.
  NotificationPreferences copyWith({
    bool? loanUpdates,
    bool? paymentReminders,
    bool? educationalContent,
    bool? promotionalOffers,
    bool? systemNotifications,
    int? quietHoursStart,
    int? quietHoursEnd,
  }) {
    return NotificationPreferences(
      loanUpdates: loanUpdates ?? this.loanUpdates,
      paymentReminders: paymentReminders ?? this.paymentReminders,
      educationalContent: educationalContent ?? this.educationalContent,
      promotionalOffers: promotionalOffers ?? this.promotionalOffers,
      systemNotifications: systemNotifications ?? this.systemNotifications,
      quietHoursStart: quietHoursStart ?? this.quietHoursStart,
      quietHoursEnd: quietHoursEnd ?? this.quietHoursEnd,
    );
  }

  /// Default preferences.
  factory NotificationPreferences.defaults() {
    return const NotificationPreferences();
  }
}

/// Mock notification data.
class MockNotifications {
  MockNotifications._();

  /// Get sample notifications.
  static List<NotificationItem> getSample() => [
    NotificationItem(
      id: 'notif-001',
      title: 'Payment reminder',
      body: 'Your weekly payment of ₱2,500 is due tomorrow. Tap to pay now!',
      type: NotificationType.payment,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      actionRoute: '/transactions',
    ),
    NotificationItem(
      id: 'notif-002',
      title: 'Loan approved! 🎉',
      body: 'Congratulations! Your ₱25,000 loan has been approved. Check your account for disbursement details.',
      type: NotificationType.loan,
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
      actionRoute: '/loan-details',
    ),
    NotificationItem(
      id: 'notif-003',
      title: 'New course available',
      body: 'Learn "Smart Repayment Strategies" - 10 mins to complete!',
      type: NotificationType.education,
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      actionRoute: '/education',
    ),
    NotificationItem(
      id: 'notif-004',
      title: 'Payment received ✓',
      body: 'Your payment of ₱2,500 has been confirmed and recorded on blockchain.',
      type: NotificationType.payment,
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
      isRead: true,
    ),
    NotificationItem(
      id: 'notif-005',
      title: 'Limited time offer!',
      body: 'Get 0.5% lower interest rate when you refer a friend. Valid until Dec 31.',
      type: NotificationType.promo,
      timestamp: DateTime.now().subtract(const Duration(days: 5)),
    ),
    NotificationItem(
      id: 'notif-006',
      title: 'Profile update needed',
      body: 'Complete your business profile to unlock higher loan amounts.',
      type: NotificationType.system,
      timestamp: DateTime.now().subtract(const Duration(days: 7)),
      isRead: true,
      actionRoute: '/forms/business-info',
    ),
  ];
}
