/// MSME Pathways - Onboarding View
/// 
/// Main onboarding screen with contained images and minimal design.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/constants/app_strings.dart';
import '../../viewmodels/onboarding_viewmodel.dart';
import '../../widgets/onboarding/fullscreen_onboarding_page.dart';

/// Main onboarding view with 3 image pages.
/// 
/// Features:
/// - Contained images with titles below
/// - Smooth dot indicator
/// - "Get Started" button on final page
/// - Skip button (optional)
class OnboardingView extends StatefulWidget {
  /// Creates the onboarding view.
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  @override
  void initState() {
    super.initState();
    // Set light status bar
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OnboardingViewModel(),
      child: const _OnboardingContent(),
    );
  }
}

/// Internal widget containing the onboarding content.
class _OnboardingContent extends StatelessWidget {
  const _OnboardingContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<OnboardingViewModel>(
        builder: (context, viewModel, _) {
          // Handle loading state
          if (viewModel.isLoading) {
            return const _LoadingState();
          }

          // Handle error state
          if (viewModel.error != null) {
            return _ErrorState(error: viewModel.error!);
          }

          // Handle completion - navigate to terms
          if (viewModel.isComplete) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.go('/terms-privacy');
            });
            return const SizedBox.shrink();
          }

          // Main onboarding content
          return Stack(
            fit: StackFit.expand,
            children: [
              // Page view with images
              PageView.builder(
                controller: viewModel.pageController,
                onPageChanged: viewModel.onPageChanged,
                physics: const BouncingScrollPhysics(),
                itemCount: viewModel.totalPages,
                itemBuilder: (context, index) {
                  return FullscreenOnboardingPage(
                    model: viewModel.pages[index],
                    isActive: index == viewModel.currentPage,
                  );
                },
              ),
              
              // Skip button (top right)
              _SkipButton(
                isVisible: !viewModel.isLastPage,
                onTap: viewModel.skip,
              ),
              
              // Bottom navigation (dots + button)
              _BottomNavigation(viewModel: viewModel),
            ],
          );
        },
      ),
    );
  }
}

/// Skip button positioned at the top right.
class _SkipButton extends StatelessWidget {
  const _SkipButton({
    required this.isVisible,
    required this.onTap,
  });

  final bool isVisible;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      right: 16,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: isVisible ? 1.0 : 0.0,
        child: Semantics(
          button: true,
          label: AppStrings.skipButtonSemantics,
          child: TextButton(
            onPressed: isVisible ? onTap : null,
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFFF5F7FA),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              AppStrings.skip,
              style: TextStyle(
                color: const Color(0xFF718096),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: 600.ms, curve: Curves.easeOut);
  }
}

/// Bottom navigation section with page indicator and Get Started button.
class _BottomNavigation extends StatelessWidget {
  const _BottomNavigation({required this.viewModel});

  final OnboardingViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 24,
      right: 24,
      bottom: MediaQuery.of(context).padding.bottom + 16,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Page indicator (dots)
          SmoothPageIndicator(
            controller: viewModel.pageController,
            count: viewModel.totalPages,
            effect: ExpandingDotsEffect(
              dotHeight: 8,
              dotWidth: 8,
              expansionFactor: 3,
              spacing: 8,
              activeDotColor: const Color(0xFF1565C0),
              dotColor: const Color(0xFFCBD5E0),
            ),
            onDotClicked: viewModel.goToPage,
          )
              .animate()
              .fadeIn(duration: 400.ms, delay: 500.ms, curve: Curves.easeOut),
          
          const SizedBox(height: 24),
          
          // Get Started button (only on last page)
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: viewModel.isLastPage
                ? _GetStartedButton(onPressed: viewModel.completeOnboarding)
                : const SizedBox(height: 56), // Placeholder for layout
          ),
        ],
      ),
    );
  }
}

/// Get Started button for the final page.
class _GetStartedButton extends StatelessWidget {
  const _GetStartedButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1565C0), // Primary blue
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: const Color(0x401565C0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Text(
          AppStrings.getStarted,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms, curve: Curves.easeOut)
        .slideY(begin: 0.2, end: 0, duration: 300.ms, curve: Curves.easeOut);
  }
}

/// Loading state widget.
class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Image.asset(
          'assets/images/msmeLogo.png',
          width: 120,
          height: 120,
          fit: BoxFit.contain,
        )
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .fadeIn(duration: 800.ms)
            .then()
            .scale(
              begin: const Offset(1.0, 1.0),
              end: const Offset(1.1, 1.1),
              duration: 1200.ms,
              curve: Curves.easeInOut,
            ),
      ),
    );
  }
}

/// Error state widget.
class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Color(0xFFE53E3E),
              ),
              const SizedBox(height: 16),
              const Text(
                'Oops! Something went wrong',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3748),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                error,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF718096),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
