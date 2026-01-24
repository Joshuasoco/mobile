/// MSME Pathways - Profile ViewModel
///
/// State management for the profile screen following MVVM pattern.
/// Handles user data, settings, and profile actions.
library;

import 'package:flutter/material.dart';

import '../../core/services/tooltip_service.dart';
import '../../data/models/profile_model.dart';
import '../../data/repositories/auth_repository.dart';

/// Profile screen states.
enum ProfileState { initial, loading, loaded, error }

/// ViewModel for profile screen state management.
class ProfileViewModel extends ChangeNotifier {
  ProfileViewModel({
    required IAuthRepository authRepository,
    ITooltipService? tooltipService,
  })  : _authRepository = authRepository,
        _tooltipService = tooltipService {
    _initialize();
  }

  final IAuthRepository _authRepository;
  final ITooltipService? _tooltipService;

  // ============================================================
  // STATE
  // ============================================================

  ProfileState _state = ProfileState.initial;
  ProfileState get state => _state;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool get isLoading => _state == ProfileState.loading;
  bool get hasError => _state == ProfileState.error;

  // ============================================================
  // USER PROFILE DATA
  // ============================================================

  UserProfile? _userProfile;
  UserProfile? get userProfile => _userProfile;

  ProfileStats? _stats;
  ProfileStats? get stats => _stats;

  /// User's full name for display.
  String get userName => _userProfile?.fullName ?? 'User';

  /// User's email for display.
  String get userEmail => _userProfile?.email ?? '';

  /// User's initials for avatar.
  String get userInitials => _userProfile?.initials ?? 'U';

  /// Whether user is verified.
  bool get isVerified => _userProfile?.isVerified ?? false;

  /// Whether user is premium.
  bool get isPremium => _userProfile?.isPremium ?? false;

  // ============================================================
  // SETTINGS SECTIONS
  // ============================================================

  List<SettingsSection> _sections = [];
  List<SettingsSection> get sections => _sections;

  // ============================================================
  // INITIALIZATION
  // ============================================================

  Future<void> _initialize() async {
    _state = ProfileState.loading;
    notifyListeners();

    try {
      await _loadUserProfile();
      _buildSettingsSections();
      _state = ProfileState.loaded;
    } catch (e) {
      _state = ProfileState.error;
      _errorMessage = 'Failed to load profile: $e';
    }
    notifyListeners();
  }

  Future<void> _loadUserProfile() async {
    // In production, fetch from repository
    // For now, using mock data
    await Future.delayed(const Duration(milliseconds: 300));

    _userProfile = const UserProfile(
      id: 'user_001',
      fullName: 'Maria Santos',
      email: 'maria.santos@email.com',
      initials: 'MS',
      isVerified: true,
      isPremium: true,
    );

    _stats = const ProfileStats(
      businessReadiness: 0.68,
      completedCourses: 12,
      loanEligibility: 50000,
    );
  }

  void _buildSettingsSections() {
    _sections = [
      // Account section
      SettingsSection(
        id: 'account',
        title: 'Account',
        items: [
          const SettingsItem(
            id: 'personal_info',
            icon: Icons.person_outline_rounded,
            title: 'Personal Information',
            subtitle: 'Name, birthday, address',
            iconColor: Color(0xFF3B82F6),
            route: '/profile/personal',
          ),
          const SettingsItem(
            id: 'security',
            icon: Icons.lock_outline_rounded,
            title: 'Login & Security',
            subtitle: 'Password, 2FA, devices',
            iconColor: Color(0xFF8B5CF6),
            route: '/profile/security',
          ),
          const SettingsItem(
            id: 'privacy',
            icon: Icons.shield_outlined,
            title: 'Data & Privacy',
            subtitle: 'Data sharing, permissions',
            iconColor: Color(0xFF10B981),
            route: '/profile/privacy',
          ),
        ],
      ),

      // Preferences section
      SettingsSection(
        id: 'preferences',
        title: 'Preferences',
        items: [
          const SettingsItem(
            id: 'notifications',
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            subtitle: 'Push, email, SMS alerts',
            iconColor: Color(0xFFF59E0B),
            route: '/profile/notifications',
          ),
          const SettingsItem(
            id: 'language',
            icon: Icons.language_rounded,
            title: 'Language',
            subtitle: 'English (US)',
            iconColor: Color(0xFF6366F1),
            route: '/profile/language',
            trailing: 'English',
          ),
          const SettingsItem(
            id: 'appearance',
            icon: Icons.dark_mode_outlined,
            title: 'Appearance',
            subtitle: 'Light mode',
            iconColor: Color(0xFF64748B),
            route: '/profile/appearance',
            trailing: 'Light',
          ),
        ],
      ),

      // Support section
      SettingsSection(
        id: 'support',
        title: 'Support',
        items: [
          const SettingsItem(
            id: 'ai_assistant',
            icon: Icons.auto_awesome_rounded,
            title: 'AI Assistant',
            subtitle: 'Get instant help',
            iconColor: Color(0xFFEC4899),
            route: '/chatbot',
            isNew: true,
          ),
          const SettingsItem(
            id: 'help_center',
            icon: Icons.help_outline_rounded,
            title: 'Help Center',
            subtitle: 'FAQs, guides, tutorials',
            iconColor: Color(0xFF14B8A6),
            route: '/help',
          ),
          const SettingsItem(
            id: 'contact_support',
            icon: Icons.chat_bubble_outline_rounded,
            title: 'Contact Support',
            subtitle: 'Chat with our team',
            iconColor: Color(0xFF0EA5E9),
            route: '/support',
          ),
          const SettingsItem(
            id: 'reset_tutorials',
            icon: Icons.replay_rounded,
            title: 'Reset Tutorials',
            subtitle: 'Show feature guides again',
            iconColor: Color(0xFF8B5CF6),
          ),
        ],
      ),
    ];
  }

  // ============================================================
  // ACTIONS
  // ============================================================

  /// Refresh profile data.
  Future<void> refreshProfile() async {
    _state = ProfileState.loading;
    notifyListeners();

    try {
      await _loadUserProfile();
      _state = ProfileState.loaded;
    } catch (e) {
      _state = ProfileState.error;
      _errorMessage = 'Failed to refresh profile: $e';
    }
    notifyListeners();
  }

  /// Handle settings item tap.
  void onSettingsTap(SettingsItem item) {
    // Track analytics
    debugPrint('Settings tapped: ${item.id}');
    
    // Handle reset tutorials action
    if (item.id == 'reset_tutorials') {
      resetTutorials();
    }
  }

  /// Reset all tooltips and tutorials.
  Future<void> resetTutorials() async {
    final tooltipService = _tooltipService;
    if (tooltipService == null) {
      debugPrint('ProfileViewModel: TooltipService not available');
      return;
    }
    
    try {
      await tooltipService.resetAll();
      debugPrint('ProfileViewModel: All tutorials reset successfully');
    } catch (e) {
      debugPrint('ProfileViewModel: Failed to reset tutorials - $e');
    }
  }

  /// Handle logout.
  Future<void> logout() async {
    try {
      await _authRepository.logout();
    } catch (e) {
      _errorMessage = 'Failed to logout: $e';
      notifyListeners();
    }
  }

  /// Handle edit profile.
  void editProfile() {
    debugPrint('Edit profile tapped');
  }
}
