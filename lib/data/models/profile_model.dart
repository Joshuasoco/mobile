/// MSME Pathways - Profile Data Models
///
/// Data models for the profile screen following clean architecture.
/// Immutable data classes representing user profile and settings.
library;

import 'package:flutter/material.dart';

/// User profile information.
@immutable
class UserProfile {
  const UserProfile({
    required this.id,
    required this.fullName,
    required this.email,
    required this.initials,
    this.avatarUrl,
    this.isVerified = false,
    this.isPremium = false,
    this.memberSince,
  });

  /// Unique user identifier.
  final String id;

  /// User's full name.
  final String fullName;

  /// User's email address.
  final String email;

  /// User's initials for avatar fallback.
  final String initials;

  /// Optional avatar image URL.
  final String? avatarUrl;

  /// Whether user's account is verified.
  final bool isVerified;

  /// Whether user has premium membership.
  final bool isPremium;

  /// Date when user joined.
  final DateTime? memberSince;

  /// Creates a copy with optional field updates.
  UserProfile copyWith({
    String? id,
    String? fullName,
    String? email,
    String? initials,
    String? avatarUrl,
    bool? isVerified,
    bool? isPremium,
    DateTime? memberSince,
  }) {
    return UserProfile(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      initials: initials ?? this.initials,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isVerified: isVerified ?? this.isVerified,
      isPremium: isPremium ?? this.isPremium,
      memberSince: memberSince ?? this.memberSince,
    );
  }
}

/// User statistics for profile display.
@immutable
class ProfileStats {
  const ProfileStats({
    required this.businessReadiness,
    required this.completedCourses,
    required this.loanEligibility,
  });

  /// Business readiness percentage (0.0 - 1.0).
  final double businessReadiness;

  /// Number of completed courses.
  final int completedCourses;

  /// Maximum loan eligibility amount.
  final double loanEligibility;

  /// Formatted readiness percentage.
  String get readinessFormatted => '${(businessReadiness * 100).toInt()}%';

  /// Formatted loan eligibility.
  String get loanFormatted {
    if (loanEligibility >= 1000000) {
      return '₱${(loanEligibility / 1000000).toStringAsFixed(1)}M';
    } else if (loanEligibility >= 1000) {
      return '₱${(loanEligibility / 1000).toStringAsFixed(0)}K';
    }
    return '₱${loanEligibility.toStringAsFixed(0)}';
  }
}

/// Settings section containing related items.
@immutable
class SettingsSection {
  const SettingsSection({
    required this.id,
    required this.title,
    required this.items,
  });

  /// Unique section identifier.
  final String id;

  /// Section header title.
  final String title;

  /// List of settings items in this section.
  final List<SettingsItem> items;
}

/// Individual settings menu item.
@immutable
class SettingsItem {
  const SettingsItem({
    required this.id,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
    this.route,
    this.isNew = false,
    this.trailing,
  });

  /// Unique item identifier.
  final String id;

  /// Icon to display.
  final IconData icon;

  /// Item title.
  final String title;

  /// Item subtitle/description.
  final String subtitle;

  /// Icon background color.
  final Color iconColor;

  /// Optional navigation route.
  final String? route;

  /// Whether to show "NEW" badge.
  final bool isNew;

  /// Optional trailing text (e.g., current value).
  final String? trailing;
}
