/// MSME Pathways - User Model
///
/// Immutable data model representing a user in the system.
library;

import 'package:flutter/foundation.dart';

/// Represents a user account in MSME Pathways.
///
/// Immutable data class with JSON serialization and copyWith support.
@immutable
class UserModel {
  /// Creates a user model.
  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.phoneNumber,
    this.profileImageUrl,
    this.isEmailVerified = false,
    this.createdAt,
  });

  /// Unique user identifier.
  final String id;

  /// User's email address.
  final String email;

  /// User's full name.
  final String name;

  /// User's phone number (optional).
  final String? phoneNumber;

  /// URL to user's profile image (optional).
  final String? profileImageUrl;

  /// Whether the user's email has been verified.
  final bool isEmailVerified;

  /// Account creation timestamp.
  final DateTime? createdAt;

  // ============================================================
  // JSON SERIALIZATION
  // ============================================================

  /// Creates a UserModel from JSON map.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      name: json['name'] as String? ?? '',
      phoneNumber: json['phone_number'] as String?,
      profileImageUrl: json['profile_image_url'] as String?,
      isEmailVerified: json['is_email_verified'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }

  /// Converts the model to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone_number': phoneNumber,
      'profile_image_url': profileImageUrl,
      'is_email_verified': isEmailVerified,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  // ============================================================
  // COPY WITH
  // ============================================================

  /// Creates a copy with modified fields.
  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? phoneNumber,
    String? profileImageUrl,
    bool? isEmailVerified,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // ============================================================
  // EQUALITY
  // ============================================================

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel &&
        other.id == id &&
        other.email == email &&
        other.name == name &&
        other.phoneNumber == phoneNumber &&
        other.profileImageUrl == profileImageUrl &&
        other.isEmailVerified == isEmailVerified &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode => Object.hash(
        id,
        email,
        name,
        phoneNumber,
        profileImageUrl,
        isEmailVerified,
        createdAt,
      );

  @override
  String toString() => 'UserModel(id: $id, email: $email, name: $name)';

  // ============================================================
  // FACTORY CONSTRUCTORS
  // ============================================================

  /// Creates an empty user (for initial/loading states).
  factory UserModel.empty() => const UserModel(
        id: '',
        email: '',
        name: '',
      );

  /// Creates a mock user for testing/development.
  factory UserModel.mock() => UserModel(
        id: 'mock-user-001',
        email: 'entrepreneur@example.com',
        name: 'Juan Dela Cruz',
        phoneNumber: '09171234567',
        isEmailVerified: true,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      );
}
