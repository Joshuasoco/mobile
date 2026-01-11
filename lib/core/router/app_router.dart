/// MSME Pathways - Application Router
/// 
/// GoRouter configuration for navigation management.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/views/onboarding_view.dart';
import '../../presentation/views/splash/splash_screen.dart';

/// Application route paths.
abstract final class AppRoutes {
  /// Splash route (initial)
  static const String splash = '/';
  
  /// Onboarding route
  static const String onboarding = '/onboarding';
  
  /// Home route (placeholder)
  static const String home = '/home';
}

/// Application router configuration.
/// 
/// Uses GoRouter for declarative routing with type-safe paths.
class AppRouter {
  /// Private constructor
  AppRouter._();
  
  /// Singleton instance
  static final AppRouter _instance = AppRouter._();
  
  /// Factory constructor returns singleton
  factory AppRouter() => _instance;

  /// The GoRouter configuration.
  final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    routes: [
      // Splash screen (initial route)
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SplashScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      ),
      
      // Onboarding flow
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const OnboardingView(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      ),
      
      // Home screen (placeholder)
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const _PlaceholderHome(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: child,
            );
          },
        ),
      ),
    ],
  );
}

/// Placeholder home screen for demonstration.
class _PlaceholderHome extends StatelessWidget {
  const _PlaceholderHome();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MSME Pathways'),
      ),
      body: const Center(
        child: Text('Main App Content'),
      ),
    );
  }
}
