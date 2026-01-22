/// MSME Pathways - Home ViewModel
///
/// Business logic and state management for the home screen.
/// Manages tab navigation, dashboard data, feature cards, and user state.
///
/// Follows MVVM pattern:
/// - NO BuildContext usage
/// - Clean separation of concerns
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Icons, Color;

import '../../core/router/app_router.dart';
import '../../data/models/home_dashboard_model.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';

/// Home screen tab indices.
enum HomeTab {
  home,
  loan,
  chat,
  profile;
}

/// Home screen loading state.
enum HomeState {
  initial,
  loading,
  loaded,
  error;
}

/// ViewModel for home screen.
///
/// Manages:
/// - Tab navigation state
/// - User data & dashboard stats
/// - Feature cards & quick actions
/// - Learning resources & recent activity
/// - Logout functionality
class HomeViewModel extends ChangeNotifier {
  /// Creates a HomeViewModel.
  HomeViewModel({
    required IAuthRepository authRepository,
  }) : _authRepository = authRepository {
    _initialize();
  }

  final IAuthRepository _authRepository;

  // ============================================================
  // STATE
  // ============================================================

  /// Current loading state.
  HomeState _state = HomeState.initial;
  HomeState get state => _state;

  /// Error message if state is error.
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Currently selected tab index.
  int _selectedTabIndex = 0;
  int get selectedTabIndex => _selectedTabIndex;

  /// Currently selected tab.
  HomeTab get selectedTab => HomeTab.values[_selectedTabIndex];

  /// Current user data.
  UserModel? _user;
  UserModel? get user => _user;

  /// Dashboard statistics.
  DashboardStats _dashboardStats = DashboardStats.empty;
  DashboardStats get dashboardStats => _dashboardStats;

  /// Whether user is logging out.
  bool _isLoggingOut = false;
  bool get isLoggingOut => _isLoggingOut;

  // ============================================================
  // COMPUTED PROPERTIES
  // ============================================================

  /// User display name.
  String get userName => _user?.name ?? 'Entrepreneur';

  /// User greeting based on time of day (in Filipino).
  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Magandang umaga';
    if (hour < 18) return 'Magandang hapon';
    return 'Magandang gabi';
  }

  /// Business readiness percentage (0.0 - 1.0).
  double get businessReadiness => _dashboardStats.businessReadiness;

  /// Formatted readiness percentage.
  String get businessReadinessFormatted => _dashboardStats.businessReadinessFormatted;

  /// Formatted monthly improvement.
  String get monthlyImprovementFormatted => _dashboardStats.monthlyImprovementFormatted;

  /// Formatted loan amount.
  String get maxLoanEligibleFormatted => _dashboardStats.maxLoanEligibleFormatted;

  /// Completed courses count.
  int get completedCourses => _dashboardStats.completedCourses;

  /// Unread notifications count.
  int get unreadNotifications => _dashboardStats.unreadNotifications;

  /// Whether data is loading.
  bool get isLoading => _state == HomeState.loading;

  /// Whether there's an error.
  bool get hasError => _state == HomeState.error;

  // ============================================================
  // FEATURE CARDS - 5 Main Navigation Features
  // ============================================================

  /// Feature navigation cards for main app features.
  List<FeatureCardItem> get featureCards => [
    FeatureCardItem(
      id: 'education',
      icon: Icons.school_outlined,
      title: 'Learning Center',
      subtitle: 'Financial literacy courses',
      route: AppRoutes.education,
      color: const Color(0xFF1565C0), // Blue from logo
      badge: _dashboardStats.completedCourses > 0 ? _dashboardStats.completedCourses : null,
    ),
    FeatureCardItem(
      id: 'chatbot',
      icon: Icons.smart_toy_outlined,
      title: 'AI Assistant',
      subtitle: 'Get instant help 24/7',
      route: AppRoutes.chatbot,
      color: const Color(0xFF7E57C2), // Purple
      isNew: true, // Mark as new feature
    ),
    FeatureCardItem(
      id: 'prequalification',
      icon: Icons.assessment_outlined,
      title: 'Loan Assessment',
      subtitle: 'Check your eligibility',
      route: AppRoutes.prequalification,
      color: const Color(0xFF4CAF50), // Green
      badge: _dashboardStats.pendingApplications > 0 ? _dashboardStats.pendingApplications : null,
    ),
    FeatureCardItem(
      id: 'transactions',
      icon: Icons.receipt_long_outlined,
      title: 'Transactions',
      subtitle: 'View blockchain records',
      route: AppRoutes.transactions,
      color: const Color(0xFFFF9800), // Orange
    ),
    FeatureCardItem(
      id: 'notifications',
      icon: Icons.notifications_outlined,
      title: 'Notifications',
      subtitle: 'Stay updated',
      route: AppRoutes.notifications,
      color: const Color(0xFFE53935), // Red from logo
      badge: _dashboardStats.unreadNotifications > 0 ? _dashboardStats.unreadNotifications : null,
    ),
  ];

  // ============================================================
  // QUICK ACTIONS
  // ============================================================

  /// Quick action items.
  List<QuickActionItem> get quickActions => [
    QuickActionItem(
      id: 'apply_loan',
      icon: Icons.description_rounded,
      label: 'Apply Loan',
      route: AppRoutes.loanApplication,
      color: const Color(0xFF00897B),
    ),
    QuickActionItem(
      id: 'calculator',
      icon: Icons.calculate_rounded,
      label: 'Calculator',
      route: AppRoutes.calculator,
      color: const Color(0xFFFF7043),
    ),
    QuickActionItem(
      id: 'reports',
      icon: Icons.analytics_rounded,
      label: 'Reports',
      route: AppRoutes.transactions,
      color: const Color(0xFF7E57C2),
    ),
    QuickActionItem(
      id: 'support',
      icon: Icons.support_agent_rounded,
      label: 'Support',
      route: AppRoutes.chatbot,
      color: const Color(0xFF42A5F5),
    ),
  ];

  // ============================================================
  // LEARNING RESOURCES
  // ============================================================

  /// Learning resource items.
  List<LearningResourceItem> _learningResources = [];
  List<LearningResourceItem> get learningResources => _learningResources;

  // ============================================================
  // RECENT ACTIVITY
  // ============================================================

  /// Recent activity items.
  List<ActivityItem> _recentActivity = [];
  List<ActivityItem> get recentActivity => _recentActivity;

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
  // ANALYTICS TRACKING
  // ============================================================

  /// Tracks navigation to a feature.
  /// 
  /// Use this for analytics tracking when user navigates to a feature.
  /// The actual navigation is handled by the View using GoRouter.
  void trackNavigation(String route, {String? featureId}) {
    debugPrint('HomeViewModel: Navigation tracked - route: $route, feature: $featureId');
    // TODO: Implement analytics tracking
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
  // INITIALIZATION & DATA LOADING
  // ============================================================

  /// Initializes the ViewModel.
  Future<void> _initialize() async {
    _state = HomeState.loading;
    notifyListeners();

    try {
      await Future.wait([
        _loadUserData(),
        _loadDashboardData(),
        _loadLearningResources(),
        _loadRecentActivity(),
      ]);
      _state = HomeState.loaded;
      _errorMessage = null;
    } catch (e) {
      _state = HomeState.error;
      _errorMessage = 'Failed to load dashboard data. Please try again.';
      debugPrint('HomeViewModel: Initialization error - $e');
    }
    notifyListeners();
  }

  /// Loads user data from repository.
  Future<void> _loadUserData() async {
    try {
      _user = await _authRepository.getCurrentUser();
      _user ??= UserModel.mock();
    } catch (e) {
      debugPrint('HomeViewModel: Error loading user - $e');
      _user = UserModel.mock();
    }
  }

  /// Loads dashboard metrics.
  Future<void> _loadDashboardData() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      _dashboardStats = DashboardStats.mock;
    } catch (e) {
      debugPrint('HomeViewModel: Error loading dashboard - $e');
      _dashboardStats = DashboardStats.empty;
    }
  }

  /// Loads learning resources.
  Future<void> _loadLearningResources() async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      _learningResources = [
        LearningResourceItem(
          id: 'financial_literacy',
          title: 'Financial Literacy 101',
          subtitle: '5 lessons • 45 min',
          progress: 0.6,
          color: const Color(0xFF26A69A),
          route: AppRoutes.education,
          lessonCount: 5,
          durationMinutes: 45,
        ),
        LearningResourceItem(
          id: 'business_planning',
          title: 'Business Planning',
          subtitle: '8 lessons • 1h 20min',
          progress: 0.3,
          color: const Color(0xFF5C6BC0),
          route: AppRoutes.education,
          lessonCount: 8,
          durationMinutes: 80,
        ),
        LearningResourceItem(
          id: 'loan_guide',
          title: 'Loan Application Guide',
          subtitle: '4 lessons • 30 min',
          progress: 0.0,
          color: const Color(0xFFEC407A),
          route: AppRoutes.education,
          lessonCount: 4,
          durationMinutes: 30,
        ),
      ];
    } catch (e) {
      debugPrint('HomeViewModel: Error loading learning resources - $e');
      _learningResources = [];
    }
  }

  /// Loads recent activity.
  Future<void> _loadRecentActivity() async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      _recentActivity = [
        ActivityItem(
          id: 'activity_1',
          icon: Icons.check_circle_rounded,
          iconColor: const Color(0xFF4CAF50),
          title: 'Profile completed',
          subtitle: 'Yesterday, 3:45 PM',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
        ),
        ActivityItem(
          id: 'activity_2',
          icon: Icons.school_rounded,
          iconColor: const Color(0xFF2196F3),
          title: 'Completed Financial Basics',
          subtitle: 'Jan 9, 2026',
          timestamp: DateTime(2026, 1, 9),
          route: AppRoutes.education,
        ),
        ActivityItem(
          id: 'activity_3',
          icon: Icons.account_balance_rounded,
          iconColor: const Color(0xFFFF9800),
          title: 'Loan application started',
          subtitle: 'Jan 8, 2026',
          timestamp: DateTime(2026, 1, 8),
          route: AppRoutes.prequalification,
        ),
      ];
    } catch (e) {
      debugPrint('HomeViewModel: Error loading recent activity - $e');
      _recentActivity = [];
    }
  }
}
