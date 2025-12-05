import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'onboarding_viewmodel.dart';
import 'widgets/slide_widget.dart';
import 'widgets/dots_indicator.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OnboardingViewModel(),
      child: const _OnboardingContent(),
    );
  }
}

class _OnboardingContent extends StatelessWidget {
  const _OnboardingContent();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<OnboardingViewModel>();
    final state = vm.state;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0B0B0B), Color(0xFF3A3A3A)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              if (!state.isLastPage)
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: vm.skipToEnd,
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ),
                )
              else
                const SizedBox(height: 48),

              // PageView
              Expanded(
                child: PageView.builder(
                  controller: vm.pageController,
                  onPageChanged: vm.onPageChanged,
                  itemCount: vm.slides.length,
                  itemBuilder: (context, index) {
                    return SlideWidget(slide: vm.slides[index]);
                  },
                ),
              ),

              // Dots indicator
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: DotsIndicator(
                  currentPage: state.currentPage,
                  totalPages: state.totalPages,
                ),
              ),

              // Navigation buttons
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back button
                    if (!state.isFirstPage)
                      TextButton(
                        onPressed: vm.previousPage,
                        child: Row(
                          children: const [
                            Icon(Icons.arrow_back, color: Colors.white70),
                            SizedBox(width: 8),
                            Text(
                              'Back',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      const SizedBox(width: 80),

                    // Next or Start button
                    ElevatedButton(
                      onPressed: () {
                        if (state.isLastPage) {
                          Navigator.pushReplacementNamed(context, '/home');
                        } else {
                          vm.nextPage();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            state.isLastPage ? 'Start' : 'Next',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            state.isLastPage
                                ? Icons.check
                                : Icons.arrow_forward,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
