import 'package:flutter/material.dart';
import '../../models/slide_model.dart';
import 'onboarding_state.dart';

class OnboardingViewModel extends ChangeNotifier {
  OnboardingState _state = OnboardingState();

  OnboardingState get state => _state;

  final PageController pageController = PageController();

  final List<SlideModel> slides = [
    SlideModel(
      image: '📊',
      title: 'Track Your Business',
      subtitle: 'Monitor your business growth and performance with ease',
    ),
    SlideModel(
      image: '💼',
      title: 'Manage Resources',
      subtitle: 'Efficiently manage your resources and optimize operations',
    ),
    SlideModel(
      image: '🚀',
      title: 'Grow Together',
      subtitle: 'Join a community of MSMEs and accelerate your success',
    ),
  ];

  void onPageChanged(int page) {
    _state = _state.copyWith(currentPage: page);
    notifyListeners();
  }

  void nextPage() {
    if (!_state.isLastPage) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousPage() {
    if (!_state.isFirstPage) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void skipToEnd() {
    pageController.animateToPage(
      _state.totalPages - 1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
