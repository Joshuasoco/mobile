/// MSME Pathways - Onboarding Model
/// 
/// Simplified data model for minimal onboarding design.
library;

import 'package:flutter/material.dart';

/// Represents a single onboarding page's content.
/// 
/// Minimal design - only contains image and title (no subtitle/features).
@immutable
class OnboardingModel {
  /// Creates an onboarding page model.
  const OnboardingModel({
    required this.id,
    required this.title,
    required this.imagePath,
  });

  /// Unique identifier for the page
  final int id;

  /// Headline text displayed at the bottom of the image
  final String title;

  /// Local asset path for the full-screen image
  final String imagePath;

  /// Creates a copy of this model with modified fields.
  OnboardingModel copyWith({
    int? id,
    String? title,
    String? imagePath,
  }) {
    return OnboardingModel(
      id: id ?? this.id,
      title: title ?? this.title,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OnboardingModel &&
        other.id == id &&
        other.title == title &&
        other.imagePath == imagePath;
  }

  @override
  int get hashCode => Object.hash(id, title, imagePath);

  @override
  String toString() => 'OnboardingModel(id: $id, title: $title)';
}
