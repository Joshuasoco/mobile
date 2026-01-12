/// MSME Pathways - Onboarding View
/// 
/// Main onboarding screen with page navigation and animations.
library;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../viewmodels/onboarding_viewmodel.dart';
import '../widgets/animated_button.dart';
import '../widgets/animated_gradient_background.dart';
import '../widgets/custom_page_indicator.dart';
import '../widgets/onboarding_page_content.dart';

/// Main onboarding view that displays the 4-page onboarding flow.
/// 
/// Features:
/// - Smooth page transitions with gesture support
/// - Skip, Next, and Get Started buttons
/// - Animated gradient background
/// - Page indicator with progress tracking
/// - Accessibility support
class OnboardingView extends StatelessWidget {
  /// Creates the onboarding view.
  const OnboardingView({super.key});

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
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: Consumer<OnboardingViewModel>(
            builder: (context, viewModel, _) {
              // Handle loading state
              if (viewModel.isLoading) {
                return const _LoadingState();
              }

              // Handle error state
              if (viewModel.error != null) {
                return _ErrorState(error: viewModel.error!);
              }

              // Handle onboarding complete state
              if (viewModel.isComplete) {
                // In production, this would navigate to the main app
                // For now, we'll show a completion message
                return const _CompletedState();
              }

              // Main onboarding content
              return Column(
                children: [
                  // Skip button
                  _SkipButton(
                    isVisible: !viewModel.isLastPage,
                    onTap: viewModel.skip,
                  ),
                  
                  // Page content
                  Expanded(
                    child: PageView.builder(
                      controller: viewModel.pageController,
                      onPageChanged: viewModel.onPageChanged,
                      physics: const BouncingScrollPhysics(),
                      itemCount: viewModel.totalPages,
                      itemBuilder: (context, index) {
                        return OnboardingPageContent(
                          model: viewModel.pages[index],
                          isActive: index == viewModel.currentPage,
                        );
                      },
                    ),
                  ),
                  
                  // Bottom navigation section
                  _BottomNavigation(viewModel: viewModel),
                ],
              );
            },
          ),
        ),
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
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: isVisible ? 1.0 : 0.0,
          child: Semantics(
            button: true,
            label: AppStrings.skipButtonSemantics,
            child: TextButton(
              onPressed: isVisible ? onTap : null,
              child: Text(
                AppStrings.skip,
                style: AppTextStyles.skipButton,
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

/// Bottom navigation section with page indicator and navigation buttons.
class _BottomNavigation extends StatelessWidget {
  const _BottomNavigation({required this.viewModel});

  final OnboardingViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Page indicator
          CustomPageIndicator(
            controller: viewModel.pageController,
            count: viewModel.totalPages,
            onDotClicked: viewModel.goToPage,
          )
              .animate()
              .fadeIn(duration: 400.ms, delay: 500.ms, curve: Curves.easeOut),
          
          const SizedBox(height: 32),
          
          // Navigation buttons
          _buildNavigationButtons(context),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons(BuildContext context) {
    // On last page, show "Get Started" button
    if (viewModel.isLastPage) {
      return AnimatedButton(
        text: AppStrings.getStarted,
        onPressed: viewModel.completeOnboarding,
        semanticLabel: AppStrings.getStartedSemantics,
        width: double.infinity,
      )
          .animate()
          .fadeIn(duration: 300.ms, curve: Curves.easeOut)
          .slideY(begin: 0.2, end: 0, duration: 300.ms, curve: Curves.easeOut);
    }
    
    // Otherwise show Next button (and optionally Previous)
    return Row(
      children: [
        // Previous button (only show if not on first page)
        if (!viewModel.isFirstPage) ...[
          Expanded(
            child: AnimatedButton(
              text: AppStrings.back,
              onPressed: viewModel.previousPage,
              isOutlined: true,
              useGradient: false,
              semanticLabel: AppStrings.previousButtonSemantics,
            ),
          ),
          const SizedBox(width: 16),
        ],
        
        // Next button
        Expanded(
          flex: viewModel.isFirstPage ? 1 : 1,
          child: AnimatedButton(
            text: AppStrings.next,
            onPressed: viewModel.nextPage,
            semanticLabel: AppStrings.nextButtonSemantics,
          ),
        ),
      ],
    )
        .animate()
        .fadeIn(duration: 300.ms, delay: 400.ms, curve: Curves.easeOut);
  }
}

/// Loading state widget.
class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // MSME logo with pulse animation
          Image.asset(
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
          const SizedBox(height: 24),
          const Text('Loading...'),
        ],
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Oops! Something went wrong',
              style: AppTextStyles.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Completed state widget (placeholder for navigation to main app).
class _CompletedState extends StatelessWidget {
  const _CompletedState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                size: 48,
                color: AppColors.textLight,
              ),
            )
                .animate()
                .scale(
                  begin: const Offset(0, 0),
                  end: const Offset(1, 1),
                  duration: 500.ms,
                  curve: Curves.elasticOut,
                ),
            const SizedBox(height: 32),
            Text(
              'Welcome to MSME Pathways!',
              style: AppTextStyles.headlineMedium,
              textAlign: TextAlign.center,
            )
                .animate()
                .fadeIn(duration: 400.ms, delay: 300.ms)
                .slideY(begin: 0.3, end: 0, duration: 400.ms, delay: 300.ms),
            const SizedBox(height: 12),
            Text(
              'Your journey to financial growth starts now.',
              style: AppTextStyles.bodyLarge,
              textAlign: TextAlign.center,
            )
                .animate()
                .fadeIn(duration: 400.ms, delay: 400.ms)
                .slideY(begin: 0.3, end: 0, duration: 400.ms, delay: 400.ms),
            const SizedBox(height: 40),
            // Log In button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.go('/terms-privacy'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00897B),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
                .animate()
                .fadeIn(duration: 400.ms, delay: 500.ms)
                .slideY(begin: 0.3, end: 0, duration: 400.ms, delay: 500.ms),
          ],
        ),
      ),
    );
  }
}
