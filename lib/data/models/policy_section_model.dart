/// MSME Pathways - Policy Section Model
/// 
/// Data model for Terms of Service and Privacy Policy sections.
library;

/// Enum to differentiate between policy types.
enum PolicyType {
  /// Terms of Service content
  termsOfService,
  
  /// Privacy Policy content
  privacyPolicy,
}

/// Model representing a section within Terms of Service or Privacy Policy.
/// 
/// Each section contains a title and content that can be displayed
/// in an expandable format for easy navigation.
class PolicySectionModel {
  /// Creates a policy section model.
  const PolicySectionModel({
    required this.id,
    required this.title,
    required this.content,
    this.subsections = const [],
    this.isExpanded = false,
  });

  /// Unique identifier for the section.
  final String id;

  /// Section title displayed in the header.
  final String title;

  /// Main content of the section (supports basic formatting).
  final String content;

  /// Optional subsections for nested content.
  final List<PolicySubsection> subsections;

  /// Whether the section is currently expanded (for UI state).
  final bool isExpanded;

  /// Creates a copy with optional property overrides.
  PolicySectionModel copyWith({
    String? id,
    String? title,
    String? content,
    List<PolicySubsection>? subsections,
    bool? isExpanded,
  }) {
    return PolicySectionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      subsections: subsections ?? this.subsections,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}

/// Model for subsections within a policy section.
class PolicySubsection {
  /// Creates a policy subsection.
  const PolicySubsection({
    required this.title,
    required this.content,
  });

  /// Subsection title.
  final String title;

  /// Subsection content.
  final String content;
}

/// Model for tracking policy acceptance.
class PolicyAcceptance {
  /// Creates a policy acceptance record.
  const PolicyAcceptance({
    required this.version,
    required this.acceptedAt,
    required this.termsAccepted,
    required this.privacyAccepted,
  });

  /// Version of the policy that was accepted.
  final String version;

  /// Timestamp when the policy was accepted.
  final DateTime acceptedAt;

  /// Whether Terms of Service was accepted.
  final bool termsAccepted;

  /// Whether Privacy Policy was accepted.
  final bool privacyAccepted;

  /// Whether both policies have been accepted.
  bool get isFullyAccepted => termsAccepted && privacyAccepted;

  /// Converts to JSON for storage.
  Map<String, dynamic> toJson() => {
    'version': version,
    'acceptedAt': acceptedAt.toIso8601String(),
    'termsAccepted': termsAccepted,
    'privacyAccepted': privacyAccepted,
  };

  /// Creates from JSON storage.
  factory PolicyAcceptance.fromJson(Map<String, dynamic> json) {
    return PolicyAcceptance(
      version: json['version'] as String,
      acceptedAt: DateTime.parse(json['acceptedAt'] as String),
      termsAccepted: json['termsAccepted'] as bool,
      privacyAccepted: json['privacyAccepted'] as bool,
    );
  }
}
