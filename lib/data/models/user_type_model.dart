/// MSME Pathways - User Type Model
/// 
/// Data model for user type selection (Individual vs Business/MSME).
library;

import 'package:flutter/material.dart';

/// Represents the type of user for personalized loan journeys.
enum UserType {
  /// Individual user - personal loans, freelancers, first-time borrowers
  individual,
  
  /// Business/MSME user - small business owners and enterprises
  business,
}

/// Extension methods for UserType enum.
extension UserTypeExtension on UserType {
  /// Returns the display title for this user type.
  String get title {
    switch (this) {
      case UserType.individual:
        return 'Individual / Indibidwal';
      case UserType.business:
        return 'Business / Negosyo / MSME';
    }
  }
  
  /// Returns the description for this user type.
  String get description {
    switch (this) {
      case UserType.individual:
        return 'Para sa personal loans, freelancers, at first-time borrowers';
      case UserType.business:
        return 'Para sa may-ari ng maliit na negosyo o enterprise';
    }
  }
  
  /// Returns the icon for this user type.
  IconData get icon {
    switch (this) {
      case UserType.individual:
        return Icons.person_rounded;
      case UserType.business:
        return Icons.store_rounded;
    }
  }
}

/// Model representing a user type option for the selector.
@immutable
class UserTypeModel {
  /// Creates a user type model.
  const UserTypeModel({
    required this.type,
    required this.title,
    required this.description,
    required this.icon,
  });
  
  /// Creates a model from a UserType enum.
  factory UserTypeModel.fromType(UserType type) {
    return UserTypeModel(
      type: type,
      title: type.title,
      description: type.description,
      icon: type.icon,
    );
  }

  /// The user type enum value.
  final UserType type;

  /// Display title for this option.
  final String title;

  /// Supporting description text.
  final String description;

  /// Icon to display for this option.
  final IconData icon;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserTypeModel && other.type == type;
  }

  @override
  int get hashCode => type.hashCode;

  @override
  String toString() => 'UserTypeModel(type: $type)';
}
