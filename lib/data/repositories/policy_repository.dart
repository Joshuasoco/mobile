/// MSME Pathways - Policy Repository
/// 
/// Repository for managing policy content and acceptance status.
library;

import '../models/policy_section_model.dart';
import '../../core/constants/policy_content.dart';

/// Interface for policy repository operations.
/// 
/// Allows for dependency injection and testing.
abstract interface class IPolicyRepository {
  /// Gets all Terms of Service sections.
  List<PolicySectionModel> getTermsOfService();

  /// Gets all Privacy Policy sections.
  List<PolicySectionModel> getPrivacyPolicy();

  /// Gets the current policy version.
  String getCurrentPolicyVersion();

  /// Gets the last updated date for policies.
  DateTime getLastUpdatedDate();
}

/// Implementation of the policy repository.
/// 
/// Provides access to policy content from the constants file.
/// Uses singleton pattern for consistent access across the app.
class PolicyRepository implements IPolicyRepository {
  /// Private constructor for singleton.
  PolicyRepository._();

  /// Singleton instance.
  static final PolicyRepository _instance = PolicyRepository._();

  /// Factory constructor returns singleton.
  factory PolicyRepository() => _instance;

  @override
  List<PolicySectionModel> getTermsOfService() {
    return PolicyContent.termsOfServiceSections;
  }

  @override
  List<PolicySectionModel> getPrivacyPolicy() {
    return PolicyContent.privacyPolicySections;
  }

  @override
  String getCurrentPolicyVersion() {
    return PolicyContent.policyVersion;
  }

  @override
  DateTime getLastUpdatedDate() {
    return PolicyContent.lastUpdated;
  }
}
