/// MSME Pathways - Onboarding Model
/// 
/// Data model for onboarding page content.
library;

import 'package:flutter/material.dart';

/// Represents a single onboarding page's content and configuration.
/// 
/// This model encapsulates all data needed to render an onboarding page,
/// following the separation of concerns principle in MVVM architecture.
@immutable
class OnboardingModel {
  /// Creates an onboarding page model.
  /// 
  /// All parameters are required to ensure complete page data.
  const OnboardingModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.backgroundColor,
    this.features,
  });

  /// Unique identifier for the page
  final int id;

  /// Headline text displayed prominently on the page
  final String title;

  /// Descriptive text explaining the concept
  final String subtitle;

  /// URL or asset path for the illustration
  final String imageUrl;

  /// Accent background color for visual variety
  final Color backgroundColor;

  /// Optional list of features for the features overview page
  final List<OnboardingFeature>? features;

  /// Creates a copy of this model with modified fields.
  OnboardingModel copyWith({
    int? id,
    String? title,
    String? subtitle,
    String? imageUrl,
    Color? backgroundColor,
    List<OnboardingFeature>? features,
  }) {
    return OnboardingModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      imageUrl: imageUrl ?? this.imageUrl,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      features: features ?? this.features,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OnboardingModel &&
        other.id == id &&
        other.title == title &&
        other.subtitle == subtitle &&
        other.imageUrl == imageUrl &&
        other.backgroundColor == backgroundColor;
  }

  @override
  int get hashCode {
    return Object.hash(id, title, subtitle, imageUrl, backgroundColor);
  }

  @override
  String toString() {
    return 'OnboardingModel(id: $id, title: $title)';
  }
}

/// Represents a feature item for the features overview page.
@immutable
class OnboardingFeature {
  /// Creates a feature item.
  const OnboardingFeature({
    required this.icon,
    required this.title,
    required this.description,
  });

  /// Icon to display for the feature
  final IconData icon;

  /// Feature title
  final String title;

  /// Feature description
  final String description;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OnboardingFeature &&
        other.icon == icon &&
        other.title == title &&
        other.description == description;
  }

  @override
  int get hashCode => Object.hash(icon, title, description);
}
