/// MSME Pathways - Home Dashboard Models
///
/// Data models for home screen dashboard components.
/// Pure Dart classes with no business logic.
library;

import 'package:flutter/material.dart';

/// Dashboard statistics model.
///
/// Contains all metrics displayed on the home dashboard.
class DashboardStats {
  const DashboardStats({
    required this.businessReadiness,
    required this.monthlyImprovement,
    required this.maxLoanEligible,
    required this.completedCourses,
    required this.totalCourses,
    this.pendingApplications = 0,
    this.unreadNotifications = 0,
  });

  /// Business readiness percentage (0.0 - 1.0).
  final double businessReadiness;

  /// Monthly improvement percentage (0.0 - 1.0).
  final double monthlyImprovement;

  /// Maximum loan amount user is eligible for.
  final double maxLoanEligible;

  /// Number of completed courses.
  final int completedCourses;

  /// Total number of available courses.
  final int totalCourses;

  /// Number of pending loan applications.
  final int pendingApplications;

  /// Number of unread notifications.
  final int unreadNotifications;

  /// Formatted business readiness percentage.
  String get businessReadinessFormatted =>
      '${(businessReadiness * 100).toInt()}%';

  /// Formatted monthly improvement.
  String get monthlyImprovementFormatted =>
      '+${(monthlyImprovement * 100).toInt()}%';

  /// Formatted loan amount with currency.
  String get maxLoanEligibleFormatted => '₱${maxLoanEligible.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
      )}';

  /// Creates a copy with updated values.
  DashboardStats copyWith({
    double? businessReadiness,
    double? monthlyImprovement,
    double? maxLoanEligible,
    int? completedCourses,
    int? totalCourses,
    int? pendingApplications,
    int? unreadNotifications,
  }) {
    return DashboardStats(
      businessReadiness: businessReadiness ?? this.businessReadiness,
      monthlyImprovement: monthlyImprovement ?? this.monthlyImprovement,
      maxLoanEligible: maxLoanEligible ?? this.maxLoanEligible,
      completedCourses: completedCourses ?? this.completedCourses,
      totalCourses: totalCourses ?? this.totalCourses,
      pendingApplications: pendingApplications ?? this.pendingApplications,
      unreadNotifications: unreadNotifications ?? this.unreadNotifications,
    );
  }

  /// Default/empty dashboard stats.
  static const DashboardStats empty = DashboardStats(
    businessReadiness: 0.0,
    monthlyImprovement: 0.0,
    maxLoanEligible: 0,
    completedCourses: 0,
    totalCourses: 0,
  );

  /// Mock data for development.
  static const DashboardStats mock = DashboardStats(
    businessReadiness: 0.68,
    monthlyImprovement: 0.12,
    maxLoanEligible: 50000,
    completedCourses: 3,
    totalCourses: 10,
    pendingApplications: 1,
    unreadNotifications: 5,
  );

  /// Creates from JSON map.
  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      businessReadiness: (json['businessReadiness'] as num?)?.toDouble() ?? 0.0,
      monthlyImprovement: (json['monthlyImprovement'] as num?)?.toDouble() ?? 0.0,
      maxLoanEligible: (json['maxLoanEligible'] as num?)?.toDouble() ?? 0.0,
      completedCourses: json['completedCourses'] as int? ?? 0,
      totalCourses: json['totalCourses'] as int? ?? 0,
      pendingApplications: json['pendingApplications'] as int? ?? 0,
      unreadNotifications: json['unreadNotifications'] as int? ?? 0,
    );
  }

  /// Converts to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'businessReadiness': businessReadiness,
      'monthlyImprovement': monthlyImprovement,
      'maxLoanEligible': maxLoanEligible,
      'completedCourses': completedCourses,
      'totalCourses': totalCourses,
      'pendingApplications': pendingApplications,
      'unreadNotifications': unreadNotifications,
    };
  }
}

/// Quick action item model.
///
/// Represents a quick action button on the home screen.
class QuickActionItem {
  const QuickActionItem({
    required this.id,
    required this.icon,
    required this.label,
    required this.route,
    required this.color,
    this.badge,
  });

  /// Unique identifier.
  final String id;

  /// Icon to display.
  final IconData icon;

  /// Action label.
  final String label;

  /// Navigation route.
  final String route;

  /// Accent color.
  final Color color;

  /// Optional badge count.
  final int? badge;

  /// Creates a copy with updated values.
  QuickActionItem copyWith({
    String? id,
    IconData? icon,
    String? label,
    String? route,
    Color? color,
    int? badge,
  }) {
    return QuickActionItem(
      id: id ?? this.id,
      icon: icon ?? this.icon,
      label: label ?? this.label,
      route: route ?? this.route,
      color: color ?? this.color,
      badge: badge ?? this.badge,
    );
  }
}

/// Feature card item model.
///
/// Represents a feature navigation card on the home screen.
class FeatureCardItem {
  const FeatureCardItem({
    required this.id,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
    required this.color,
    this.badge,
    this.isNew = false,
  });

  /// Unique identifier.
  final String id;

  /// Icon to display.
  final IconData icon;

  /// Feature title.
  final String title;

  /// Feature subtitle/description.
  final String subtitle;

  /// Navigation route.
  final String route;

  /// Card accent color.
  final Color color;

  /// Optional badge count.
  final int? badge;

  /// Whether this is a new feature.
  final bool isNew;

  /// Creates a copy with updated values.
  FeatureCardItem copyWith({
    String? id,
    IconData? icon,
    String? title,
    String? subtitle,
    String? route,
    Color? color,
    int? badge,
    bool? isNew,
  }) {
    return FeatureCardItem(
      id: id ?? this.id,
      icon: icon ?? this.icon,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      route: route ?? this.route,
      color: color ?? this.color,
      badge: badge ?? this.badge,
      isNew: isNew ?? this.isNew,
    );
  }
}

/// Learning resource item model.
///
/// Represents a learning resource card.
class LearningResourceItem {
  const LearningResourceItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.color,
    required this.route,
    this.lessonCount = 0,
    this.durationMinutes = 0,
  });

  /// Unique identifier.
  final String id;

  /// Resource title.
  final String title;

  /// Resource subtitle.
  final String subtitle;

  /// Completion progress (0.0 - 1.0).
  final double progress;

  /// Card accent color.
  final Color color;

  /// Navigation route.
  final String route;

  /// Number of lessons.
  final int lessonCount;

  /// Duration in minutes.
  final int durationMinutes;

  /// Whether this resource has been started.
  bool get isStarted => progress > 0;

  /// Whether this resource is completed.
  bool get isCompleted => progress >= 1.0;

  /// Creates a copy with updated values.
  LearningResourceItem copyWith({
    String? id,
    String? title,
    String? subtitle,
    double? progress,
    Color? color,
    String? route,
    int? lessonCount,
    int? durationMinutes,
  }) {
    return LearningResourceItem(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      progress: progress ?? this.progress,
      color: color ?? this.color,
      route: route ?? this.route,
      lessonCount: lessonCount ?? this.lessonCount,
      durationMinutes: durationMinutes ?? this.durationMinutes,
    );
  }
}

/// Recent activity item model.
///
/// Represents a recent activity entry.
class ActivityItem {
  const ActivityItem({
    required this.id,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.timestamp,
    this.route,
  });

  /// Unique identifier.
  final String id;

  /// Activity icon.
  final IconData icon;

  /// Icon accent color.
  final Color iconColor;

  /// Activity title.
  final String title;

  /// Activity subtitle/timestamp.
  final String subtitle;

  /// Activity timestamp.
  final DateTime timestamp;

  /// Optional navigation route.
  final String? route;

  /// Creates a copy with updated values.
  ActivityItem copyWith({
    String? id,
    IconData? icon,
    Color? iconColor,
    String? title,
    String? subtitle,
    DateTime? timestamp,
    String? route,
  }) {
    return ActivityItem(
      id: id ?? this.id,
      icon: icon ?? this.icon,
      iconColor: iconColor ?? this.iconColor,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      timestamp: timestamp ?? this.timestamp,
      route: route ?? this.route,
    );
  }
}
