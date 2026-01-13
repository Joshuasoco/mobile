/// MSME Pathways - Onboarding ViewModel
/// 
/// ViewModel for managing onboarding state and navigation logic.
library;

import 'package:flutter/material.dart';

import '../../data/models/onboarding_model.dart';
import '../../data/repositories/onboarding_repository.dart';

/// ViewModel for the onboarding flow implementing the MVVM pattern.
/// 
/// Manages:
/// - Current page state (3 pages)
/// - Navigation between pages (next, previous, skip)
/// - Completion status
/// - PageController for smooth transitions
class OnboardingViewModel extends ChangeNotifier {
  /// Creates an OnboardingViewModel with the given repository.
  OnboardingViewModel({
    IOnboardingRepository? repository,
  }) : _repository = repository ?? OnboardingRepository() {
    _loadPages();
  }

  // ============================================================
  // Dependencies
  // ============================================================
  
  final IOnboardingRepository _repository;

  // ============================================================
  // State
  // ============================================================
  
  /// List of onboarding pages (3 pages)
  List<OnboardingModel> _pages = [];
  
  /// Current page index (0-based)
  int _currentPage = 0;
  
  /// Whether the onboarding is complete
  bool _isComplete = false;
  
  /// Loading state
  bool _isLoading = true;
  
  /// Error message if any
  String? _error;

  /// PageController for the PageView widget
  late final PageController pageController = PageController();

  // ============================================================
  // Getters
  // ============================================================
  
  /// All onboarding pages
  List<OnboardingModel> get pages => List.unmodifiable(_pages);
  
  /// Current page index (0-based)
  int get currentPage => _currentPage;
  
  /// Current page model
  OnboardingModel? get currentPageModel => 
      _pages.isNotEmpty ? _pages[_currentPage] : null;
  
  /// Whether onboarding is complete
  bool get isComplete => _isComplete;
  
  /// Whether data is loading
  bool get isLoading => _isLoading;
  
  /// Error message if any
  String? get error => _error;
  
  /// Total number of pages (3)
  int get totalPages => _pages.length;
  
  /// Whether currently on the first page
  bool get isFirstPage => _currentPage == 0;
  
  /// Whether currently on the last page
  bool get isLastPage => _currentPage == _pages.length - 1;
  
  /// Progress percentage (0.0 to 1.0)
  double get progress => 
      _pages.isEmpty ? 0.0 : (_currentPage + 1) / _pages.length;

  // ============================================================
  // Initialization
  // ============================================================
  
  /// Loads onboarding pages from the repository.
  void _loadPages() {
    try {
      _pages = _repository.getOnboardingPages();
      _isLoading = false;
      _error = null;
    } catch (e) {
      _error = 'Failed to load onboarding content: $e';
      _isLoading = false;
    }
    notifyListeners();
  }

  // ============================================================
  // Navigation Actions
  // ============================================================
  
  /// Navigates to the next page.
  /// 
  /// If on the last page, marks onboarding as complete.
  void nextPage() {
    if (isLastPage) {
      completeOnboarding();
    } else {
      _animateToPage(_currentPage + 1);
    }
  }
  
  /// Navigates to the previous page.
  void previousPage() {
    if (!isFirstPage) {
      _animateToPage(_currentPage - 1);
    }
  }
  
  /// Skips to the last page.
  void skip() {
    _animateToPage(_pages.length - 1);
  }
  
  /// Navigates to a specific page by index.
  void goToPage(int index) {
    if (index >= 0 && index < _pages.length) {
      _animateToPage(index);
    }
  }
  
  /// Updates the current page index when user swipes.
  void onPageChanged(int index) {
    if (_currentPage != index) {
      _currentPage = index;
      notifyListeners();
    }
  }
  
  /// Marks onboarding as complete.
  void completeOnboarding() {
    _isComplete = true;
    notifyListeners();
  }
  
  /// Animates to the specified page.
  void _animateToPage(int page) {
    _currentPage = page;
    pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
    );
    notifyListeners();
  }

  // ============================================================
  // Cleanup
  // ============================================================
  
  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
