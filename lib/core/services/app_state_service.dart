/// MSME Pathways - App State Service
///
/// Central service for managing persistent app state flags including
/// onboarding completion, terms acceptance, user type, and authentication.
/// 
/// This service determines the initial route on app launch and ensures
/// users don't repeat flows they've already completed.
library;

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/user_type_model.dart';

/// Represents the complete app state for routing decisions.
@immutable
class AppLaunchState {
  /// Creates an app launch state.
  const AppLaunchState({
    required this.onboardingComplete,
    required this.termsAccepted,
    required this.termsUpToDate,
    required this.userTypeSelected,
    required this.isLoggedIn,
    this.userType,
  });

  /// Whether onboarding has been completed.
  final bool onboardingComplete;

  /// Whether terms have been accepted (any version).
  final bool termsAccepted;

  /// Whether the accepted terms version matches current version.
  final bool termsUpToDate;

  /// Whether user type has been selected.
  final bool userTypeSelected;

  /// Whether user is currently logged in.
  final bool isLoggedIn;

  /// The selected user type, if any.
  final UserType? userType;

  /// Check if all pre-auth steps are complete.
  bool get preAuthComplete => 
      onboardingComplete && termsAccepted && termsUpToDate && userTypeSelected;

  @override
  String toString() => 'AppLaunchState('
      'onboarding: $onboardingComplete, '
      'terms: $termsAccepted, '
      'termsUpToDate: $termsUpToDate, '
      'userType: $userTypeSelected, '
      'loggedIn: $isLoggedIn)';
}

/// Service for managing persistent app state.
/// 
/// Handles:
/// - Onboarding completion tracking
/// - Terms acceptance with versioning (for compliance)
/// - User type selection persistence
/// - Authentication state
/// - Initial route determination
class AppStateService {
  // ============================================================
  // STORAGE KEYS
  // ============================================================
  
  static const String _keyOnboardingComplete = 'onboarding_complete';
  static const String _keyTermsAccepted = 'terms_accepted';
  static const String _keyTermsVersion = 'terms_version_accepted';
  static const String _keyUserType = 'user_type';
  static const String _keyAuthToken = 'auth_token';
  static const String _keyUserId = 'user_id';

  // ============================================================
  // TERMS VERSION (bump when terms change)
  // ============================================================
  
  /// Current terms and privacy policy version.
  /// Increment this when terms are updated to require re-acceptance.
  static const String currentTermsVersion = '1.0.0';

  // ============================================================
  // ROUTE PATHS
  // ============================================================
  
  static const String routeOnboarding = '/onboarding';
  static const String routeTermsPrivacy = '/terms-privacy';
  static const String routeUserType = '/user-type';
  static const String routeLogin = '/login';
  static const String routeHome = '/home';

  // ============================================================
  // STATE RETRIEVAL
  // ============================================================

  /// Get the complete app launch state.
  Future<AppLaunchState> getAppState() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final onboardingComplete = prefs.getBool(_keyOnboardingComplete) ?? false;
      final termsAccepted = prefs.getBool(_keyTermsAccepted) ?? false;
      final acceptedVersion = prefs.getString(_keyTermsVersion);
      final userTypeString = prefs.getString(_keyUserType);
      final authToken = prefs.getString(_keyAuthToken);

      // Check if accepted terms version matches current
      final termsUpToDate = acceptedVersion == currentTermsVersion;

      // Parse user type if exists
      UserType? userType;
      if (userTypeString != null) {
        try {
          userType = UserType.values.firstWhere(
            (t) => t.name == userTypeString,
          );
        } catch (_) {
          // Invalid user type stored, treat as not selected
        }
      }

      return AppLaunchState(
        onboardingComplete: onboardingComplete,
        termsAccepted: termsAccepted,
        termsUpToDate: termsUpToDate,
        userTypeSelected: userType != null,
        isLoggedIn: authToken != null && authToken.isNotEmpty,
        userType: userType,
      );
    } catch (e) {
      debugPrint('Error getting app state: $e');
      // Return default state on error (start from beginning)
      return const AppLaunchState(
        onboardingComplete: false,
        termsAccepted: false,
        termsUpToDate: false,
        userTypeSelected: false,
        isLoggedIn: false,
      );
    }
  }

  /// Determine the initial route based on app state.
  Future<String> determineInitialRoute() async {
    final state = await getAppState();
    return getRouteForState(state);
  }

  /// Get route for a given state (for testing/reuse).
  String getRouteForState(AppLaunchState state) {
    // Priority order: onboarding → terms → user-type → login/home

    if (!state.onboardingComplete) {
      return routeOnboarding;
    }

    if (!state.termsAccepted || !state.termsUpToDate) {
      return routeTermsPrivacy;
    }

    if (!state.userTypeSelected) {
      return routeUserType;
    }

    if (!state.isLoggedIn) {
      return routeLogin;
    }

    return routeHome;
  }

  // ============================================================
  // STATE SETTERS
  // ============================================================

  /// Mark onboarding as complete.
  Future<bool> setOnboardingComplete() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyOnboardingComplete, true);
      debugPrint('AppStateService: Onboarding marked complete');
      return true;
    } catch (e) {
      debugPrint('Error setting onboarding complete: $e');
      return false;
    }
  }

  /// Mark terms as accepted with current version.
  Future<bool> setTermsAccepted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyTermsAccepted, true);
      await prefs.setString(_keyTermsVersion, currentTermsVersion);
      debugPrint('AppStateService: Terms v$currentTermsVersion accepted');
      return true;
    } catch (e) {
      debugPrint('Error setting terms accepted: $e');
      return false;
    }
  }

  /// Save user type selection.
  Future<bool> setUserType(UserType type) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyUserType, type.name);
      debugPrint('AppStateService: User type set to ${type.name}');
      return true;
    } catch (e) {
      debugPrint('Error setting user type: $e');
      return false;
    }
  }

  /// Save authentication token.
  Future<bool> setAuthToken(String token, {String? userId}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyAuthToken, token);
      if (userId != null) {
        await prefs.setString(_keyUserId, userId);
      }
      debugPrint('AppStateService: Auth token saved');
      return true;
    } catch (e) {
      debugPrint('Error setting auth token: $e');
      return false;
    }
  }

  /// Get stored user type.
  Future<UserType?> getUserType() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userTypeString = prefs.getString(_keyUserType);
      if (userTypeString != null) {
        return UserType.values.firstWhere(
          (t) => t.name == userTypeString,
        );
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Get stored auth token.
  Future<String?> getAuthToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_keyAuthToken);
    } catch (e) {
      return null;
    }
  }

  // ============================================================
  // LOGOUT (preserves pre-auth state)
  // ============================================================

  /// Clear auth state only (keeps onboarding, terms, user type).
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyAuthToken);
      await prefs.remove(_keyUserId);
      debugPrint('AppStateService: Logged out (preserved pre-auth state)');
    } catch (e) {
      debugPrint('Error during logout: $e');
    }
  }

  // ============================================================
  // RESET (for testing/development)
  // ============================================================

  /// Clear all app state (full reset).
  Future<void> resetAllState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyOnboardingComplete);
      await prefs.remove(_keyTermsAccepted);
      await prefs.remove(_keyTermsVersion);
      await prefs.remove(_keyUserType);
      await prefs.remove(_keyAuthToken);
      await prefs.remove(_keyUserId);
      debugPrint('AppStateService: All state reset');
    } catch (e) {
      debugPrint('Error resetting state: $e');
    }
  }

  /// Check if terms need to be re-accepted (version changed).
  Future<bool> needsTermsReacceptance() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final acceptedVersion = prefs.getString(_keyTermsVersion);
      return acceptedVersion != currentTermsVersion;
    } catch (e) {
      return true; // Assume needs re-acceptance on error
    }
  }
}
