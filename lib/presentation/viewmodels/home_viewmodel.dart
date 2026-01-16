/// MSME Pathways - Home ViewModel
///
/// Business logic and state management for the home screen.
/// Manages tab navigation, dashboard data, and user state.
library;

import 'package:flutter/foundation.dart';

import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';

/// Home screen tab indices.
enum HomeTab {
  home,
  loan,
  chat,
  profile;
}

/// ViewModel for home screen.
///
/// Manages:
/// - Tab navigation state
/// - User data
/// - Dashboard metrics
/// - Logout functionality
class HomeViewModel extends ChangeNotifier {
  /// Creates a HomeViewModel.
  HomeViewModel({
    required IAuthRepository authRepository,
  }) : _authRepository = authRepository {
    _loadUserData();
    _loadDashboardData();
  }

  final IAuthRepository _authRepository;

  // ============================================================
  // STATE
  // ============================================================

  /// Currently selected tab index.
  int _selectedTabIndex = 0;
  int get selectedTabIndex => _selectedTabIndex;

  /// Currently selected tab.
  HomeTab get selectedTab => HomeTab.values[_selectedTabIndex];

  /// Current user data.
  UserModel? _user;
  UserModel? get user => _user;

  /// User display name.
  String get userName => _user?.name ?? 'Entrepreneur';

  /// User greeting based on time of day.
  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Magandang umaga';
    if (hour < 18) return 'Magandang hapon';
    return 'Magandang gabi';
  }

  /// Business readiness percentage (0.0 - 1.0).
  double _businessReadiness = 0.68;
  double get businessReadiness => _businessReadiness;

  /// Formatted readiness percentage.
  String get businessReadinessFormatted =>
      '${(_businessReadiness * 100).toInt()}%';

  /// Monthly improvement percentage.
  double _monthlyImprovement = 0.12;
  double get monthlyImprovement => _monthlyImprovement;

  /// Formatted monthly improvement.
  String get monthlyImprovementFormatted =>
      '+${(_monthlyImprovement * 100).toInt()}%';

  /// Maximum loan amount eligible.
  double _maxLoanEligible = 50000;
  double get maxLoanEligible => _maxLoanEligible;

  /// Formatted loan amount.
  String get maxLoanEligibleFormatted => '₱${_maxLoanEligible.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
      )}';

  /// Completed courses count.
  int _completedCourses = 3;
  int get completedCourses => _completedCourses;

  /// Whether data is loading.
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Whether user is logging out.
  bool _isLoggingOut = false;
  bool get isLoggingOut => _isLoggingOut;

  // ============================================================
  // TAB NAVIGATION
  // ============================================================

  /// Selects a tab by index.
  void selectTab(int index) {
    if (index >= 0 && index < HomeTab.values.length && index != _selectedTabIndex) {
      _selectedTabIndex = index;
      notifyListeners();
      debugPrint('HomeViewModel: Tab changed to ${HomeTab.values[index].name}');
    }
  }

  /// Selects a tab by enum value.
  void selectTabEnum(HomeTab tab) {
    selectTab(tab.index);
  }

  // ============================================================
  // ACTIONS
  // ============================================================

  /// Refreshes dashboard data.
  Future<void> refreshDashboard() async {
    await _loadDashboardData();
  }

  /// Logs out the user.
  Future<void> logout() async {
    _isLoggingOut = true;
    notifyListeners();

    try {
      await _authRepository.logout();
      debugPrint('HomeViewModel: Logged out successfully');
    } catch (e) {
      debugPrint('HomeViewModel: Logout error - $e');
    } finally {
      _isLoggingOut = false;
      notifyListeners();
    }
  }

  // ============================================================
  // PRIVATE DATA LOADING
  // ============================================================

  /// Loads user data from repository.
  Future<void> _loadUserData() async {
    try {
      _user = await _authRepository.getCurrentUser();
      // If no user found, use mock data for development
      _user ??= UserModel.mock();
      notifyListeners();
    } catch (e) {
      debugPrint('HomeViewModel: Error loading user - $e');
      _user = UserModel.mock();
      notifyListeners();
    }
  }

  /// Loads dashboard metrics.
  ///
  /// TODO: Replace with actual API calls when backend is ready.
  Future<void> _loadDashboardData() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Mock data - replace with actual API calls
      _businessReadiness = 0.68;
      _monthlyImprovement = 0.12;
      _maxLoanEligible = 50000;
      _completedCourses = 3;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('HomeViewModel: Error loading dashboard - $e');
      _isLoading = false;
      notifyListeners();
    }
  }
}
