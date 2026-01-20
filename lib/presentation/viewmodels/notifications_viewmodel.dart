/// MSME Pathways - Notifications ViewModel
/// 
/// Business logic for notification management.
library;

import 'package:flutter/material.dart';

import '../../data/models/notification_model.dart';

/// ViewModel for notifications.
class NotificationsViewModel extends ChangeNotifier {
  /// All notifications.
  List<NotificationItem> _notifications = [];

  /// User preferences.
  NotificationPreferences _preferences = NotificationPreferences.defaults();

  /// Whether loading.
  bool _isLoading = false;

  /// Gets all notifications.
  List<NotificationItem> get notifications => _notifications;

  /// Gets unread notifications.
  List<NotificationItem> get unreadNotifications =>
      _notifications.where((n) => !n.isRead).toList();

  /// Gets unread count.
  int get unreadCount => unreadNotifications.length;

  /// Gets preferences.
  NotificationPreferences get preferences => _preferences;

  /// Whether loading.
  bool get isLoading => _isLoading;

  /// Creates the viewmodel.
  NotificationsViewModel() {
    _loadNotifications();
    _loadPreferences();
  }

  /// Loads notifications.
  Future<void> _loadNotifications() async {
    _isLoading = true;
    notifyListeners();

    // TODO: Backend - Fetch notifications from server
    // Example:
    // _notifications = await notificationService.getNotifications(userId);

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 300));
    _notifications = MockNotifications.getSample();

    _isLoading = false;
    notifyListeners();
  }

  /// Loads preferences.
  Future<void> _loadPreferences() async {
    // TODO: Backend - Load preferences from storage/server
    _preferences = NotificationPreferences.defaults();
    notifyListeners();
  }

  /// Refresh notifications.
  Future<void> refresh() async {
    await _loadNotifications();
  }

  /// Mark notification as read.
  void markAsRead(String notificationId) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      
      // TODO: Backend - Update read status on server
      
      notifyListeners();
    }
  }

  /// Mark all as read.
  void markAllAsRead() {
    _notifications = _notifications.map((n) => n.copyWith(isRead: true)).toList();
    
    // TODO: Backend - Update all read status on server
    
    notifyListeners();
  }

  /// Delete notification.
  void deleteNotification(String notificationId) {
    _notifications.removeWhere((n) => n.id == notificationId);
    
    // TODO: Backend - Delete notification on server
    
    notifyListeners();
  }

  /// Update preference.
  void updatePreference({
    bool? loanUpdates,
    bool? paymentReminders,
    bool? educationalContent,
    bool? promotionalOffers,
    bool? systemNotifications,
    int? quietHoursStart,
    int? quietHoursEnd,
  }) {
    _preferences = _preferences.copyWith(
      loanUpdates: loanUpdates,
      paymentReminders: paymentReminders,
      educationalContent: educationalContent,
      promotionalOffers: promotionalOffers,
      systemNotifications: systemNotifications,
      quietHoursStart: quietHoursStart,
      quietHoursEnd: quietHoursEnd,
    );

    // TODO: Backend - Save preferences to storage/server
    // TODO: Backend - Update FCM topic subscriptions
    
    notifyListeners();
  }

  /// Group notifications by date.
  Map<String, List<NotificationItem>> get groupedNotifications {
    final grouped = <String, List<NotificationItem>>{};
    final now = DateTime.now();

    for (final notification in _notifications) {
      String key;
      final diff = now.difference(notification.timestamp);

      if (diff.inDays == 0) {
        key = 'Today';
      } else if (diff.inDays == 1) {
        key = 'Yesterday';
      } else if (diff.inDays < 7) {
        key = 'This Week';
      } else {
        key = 'Earlier';
      }

      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(notification);
    }

    return grouped;
  }
}
