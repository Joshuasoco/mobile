/// MSME Pathways - Terms & Privacy ViewModel
/// 
/// ViewModel for managing Terms & Privacy screen state and logic.
library;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/services/app_state_service.dart';
import '../../data/models/policy_section_model.dart';
import '../../data/repositories/policy_repository.dart';

/// Keys for SharedPreferences storage.
abstract final class _StorageKeys {
  static const String policyAcceptance = 'policy_acceptance';
  static const String acceptedVersion = 'accepted_policy_version';
}

/// ViewModel for Terms & Privacy screen.
/// 
/// Manages:
/// - Tab navigation between Terms and Privacy sections
/// - Section expansion state
/// - Acceptance checkbox state
/// - Persistence of acceptance to SharedPreferences
class TermsPrivacyViewModel extends ChangeNotifier {
  /// Creates the ViewModel with optional repository injection.
  TermsPrivacyViewModel({
    IPolicyRepository? repository,
    AppStateService? appStateService,
  }) : _repository = repository ?? PolicyRepository(),
       _appStateService = appStateService ?? AppStateService() {
    _initialize();
  }

  // ============================================================
  // Dependencies
  // ============================================================
  
  final IPolicyRepository _repository;
  final AppStateService _appStateService;

  // ============================================================
  // State
  // ============================================================
  
  /// Current tab index (0 = Terms, 1 = Privacy).
  int _currentTabIndex = 0;
  
  /// Whether the user has checked the acceptance checkbox.
  bool _hasAccepted = false;
  
  /// Whether loading is in progress.
  bool _isLoading = true;
  
  /// Error message if any.
  String? _error;
  
  /// Terms of Service sections.
  List<PolicySectionModel> _termsSections = [];
  
  /// Privacy Policy sections.
  List<PolicySectionModel> _privacySections = [];
  
  /// Policy version.
  String _policyVersion = '';
  
  /// Last updated date.
  DateTime? _lastUpdated;
  
  /// Whether user has already accepted current version.
  bool _alreadyAccepted = false;

  /// TabController for tab navigation (must be set by View).
  TabController? tabController;

  // ============================================================
  // Getters
  // ============================================================
  
  /// Current tab index.
  int get currentTabIndex => _currentTabIndex;
  
  /// Whether acceptance checkbox is checked.
  bool get hasAccepted => _hasAccepted;
  
  /// Whether loading is in progress.
  bool get isLoading => _isLoading;
  
  /// Error message if any.
  String? get error => _error;
  
  /// Terms of Service sections.
  List<PolicySectionModel> get termsSections => List.unmodifiable(_termsSections);
  
  /// Privacy Policy sections.
  List<PolicySectionModel> get privacySections => List.unmodifiable(_privacySections);
  
  /// Current policy version.
  String get policyVersion => _policyVersion;
  
  /// Last updated date.
  DateTime? get lastUpdated => _lastUpdated;
  
  /// Whether can proceed (checkbox checked).
  bool get canProceed => _hasAccepted;
  
  /// Whether user already accepted current version.
  bool get alreadyAccepted => _alreadyAccepted;
  
  /// Current sections based on tab.
  List<PolicySectionModel> get currentSections =>
      _currentTabIndex == 0 ? _termsSections : _privacySections;

  // ============================================================
  // Initialization
  // ============================================================
  
  /// Initializes the ViewModel by loading policy content.
  Future<void> _initialize() async {
    try {
      _isLoading = true;
      notifyListeners();
      
      // Load policy content
      _termsSections = _repository.getTermsOfService();
      _privacySections = _repository.getPrivacyPolicy();
      _policyVersion = _repository.getCurrentPolicyVersion();
      _lastUpdated = _repository.getLastUpdatedDate();
      
      // Check if user has already accepted current version
      await _checkExistingAcceptance();
      
      _isLoading = false;
      _error = null;
    } catch (e) {
      _error = 'Failed to load policy content: $e';
      _isLoading = false;
    }
    notifyListeners();
  }
  
  /// Checks if user has already accepted the current policy version.
  Future<void> _checkExistingAcceptance() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final acceptedVersion = prefs.getString(_StorageKeys.acceptedVersion);
      
      if (acceptedVersion == _policyVersion) {
        _alreadyAccepted = true;
        _hasAccepted = true;
      }
    } catch (e) {
      // Ignore errors, just don't pre-check
      debugPrint('Error checking policy acceptance: $e');
    }
  }

  // ============================================================
  // Tab Navigation
  // ============================================================
  
  /// Changes the current tab.
  void changeTab(int index) {
    if (index != _currentTabIndex) {
      _currentTabIndex = index;
      notifyListeners();
    }
  }

  // ============================================================
  // Section Expansion
  // ============================================================
  
  /// Toggles the expansion state of a section.
  void toggleSection(String sectionId) {
    if (_currentTabIndex == 0) {
      _termsSections = _termsSections.map((section) {
        if (section.id == sectionId) {
          return section.copyWith(isExpanded: !section.isExpanded);
        }
        return section;
      }).toList();
    } else {
      _privacySections = _privacySections.map((section) {
        if (section.id == sectionId) {
          return section.copyWith(isExpanded: !section.isExpanded);
        }
        return section;
      }).toList();
    }
    notifyListeners();
  }
  
  /// Expands all sections in current tab.
  void expandAll() {
    if (_currentTabIndex == 0) {
      _termsSections = _termsSections.map((s) => s.copyWith(isExpanded: true)).toList();
    } else {
      _privacySections = _privacySections.map((s) => s.copyWith(isExpanded: true)).toList();
    }
    notifyListeners();
  }
  
  /// Collapses all sections in current tab.
  void collapseAll() {
    if (_currentTabIndex == 0) {
      _termsSections = _termsSections.map((s) => s.copyWith(isExpanded: false)).toList();
    } else {
      _privacySections = _privacySections.map((s) => s.copyWith(isExpanded: false)).toList();
    }
    notifyListeners();
  }

  // ============================================================
  // Acceptance Actions
  // ============================================================
  
  /// Toggles the acceptance checkbox.
  void toggleAcceptance() {
    _hasAccepted = !_hasAccepted;
    notifyListeners();
  }
  
  /// Sets the acceptance state.
  void setAcceptance(bool value) {
    if (_hasAccepted != value) {
      _hasAccepted = value;
      notifyListeners();
    }
  }
  
  /// Saves acceptance and returns true if successful.
  Future<bool> acceptAndContinue() async {
    if (!_hasAccepted) return false;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Save acceptance record
      final acceptance = PolicyAcceptance(
        version: _policyVersion,
        acceptedAt: DateTime.now(),
        termsAccepted: true,
        privacyAccepted: true,
      );
      
      await prefs.setString(
        _StorageKeys.policyAcceptance,
        jsonEncode(acceptance.toJson()),
      );
      await prefs.setString(_StorageKeys.acceptedVersion, _policyVersion);
      
      // Also save to AppStateService for unified routing
      await _appStateService.setTermsAccepted();
      
      return true;
    } catch (e) {
      _error = 'Failed to save acceptance: $e';
      notifyListeners();
      return false;
    }
  }

  // ============================================================
  // Static Helpers for Navigation Guards
  // ============================================================
  
  /// Checks if user needs to accept policies (for route guards).
  static Future<bool> needsPolicyAcceptance() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final acceptedVersion = prefs.getString(_StorageKeys.acceptedVersion);
      final currentVersion = PolicyRepository().getCurrentPolicyVersion();
      
      return acceptedVersion != currentVersion;
    } catch (e) {
      // If we can't check, require acceptance
      return true;
    }
  }
  
  /// Clears policy acceptance (for testing or settings).
  static Future<void> clearAcceptance() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_StorageKeys.policyAcceptance);
      await prefs.remove(_StorageKeys.acceptedVersion);
    } catch (e) {
      debugPrint('Error clearing policy acceptance: $e');
    }
  }

  // ============================================================
  // Cleanup
  // ============================================================
  
  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
  }
}
