/// MSME Pathways - Application Router
/// 
/// GoRouter configuration for navigation management.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/views/auth/forgot_password_screen.dart';
import '../../presentation/views/auth/otp_verification_screen.dart';
import '../../presentation/views/auth/reset_password_screen.dart';
import '../../presentation/views/home/home_screen.dart';
import '../../presentation/views/legal/legal_document_screen.dart';
import '../../presentation/views/login/login_screen.dart';
import '../../presentation/views/onboarding_view.dart';
import '../../presentation/views/policy/terms_privacy_screen.dart';
import '../../presentation/views/signup/signup_screen.dart';
import '../../data/models/policy_section_model.dart';
import '../../presentation/views/splash/splash_screen.dart';
import '../../presentation/views/user_type/user_type_selector_screen.dart';

/// Application route paths.
abstract final class AppRoutes {
  /// Splash route (initial)
  static const String splash = '/';
  
  /// Onboarding route
  static const String onboarding = '/onboarding';
  
  /// Terms & Privacy Policy route (onboarding flow with acceptance)
  static const String termsPrivacy = '/terms-privacy';
  
  /// Legal document viewer route (read-only from login/signup)
  static const String legal = '/legal';
  
  /// User type selector route
  static const String userType = '/user-type';
  
  /// Home route (placeholder)
  static const String home = '/home';
  
  /// Login route
  static const String login = '/login';
  
  /// Sign up route
  static const String signup = '/signup';
  
  /// Forgot password route
  static const String forgotPassword = '/forgot-password';
  
  /// OTP verification route
  static const String otpVerification = '/otp-verification';
  
  /// Reset password route
  static const String resetPassword = '/reset-password';
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
      
      // Terms & Privacy screen (onboarding flow with acceptance)
      GoRoute(
        path: AppRoutes.termsPrivacy,
        name: 'termsPrivacy',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const TermsPrivacyScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      ),
      
      // Legal document viewer (read-only from login/signup)
      GoRoute(
        path: AppRoutes.legal,
        name: 'legal',
        pageBuilder: (context, state) {
          // Accept PolicyType as extra for initial tab selection
          final policyType = state.extra as PolicyType?;
          return CustomTransitionPage(
            key: state.pageKey,
            child: LegalDocumentScreen(initialDocumentType: policyType),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              // Slide up transition for modal feel
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 1),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                )),
                child: child,
              );
            },
          );
        },
      ),
      
      // User type selector screen
      GoRoute(
        path: AppRoutes.userType,
        name: 'userType',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const UserTypeSelectorScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      ),
      
      // Home screen
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      ),
      
      // Login screen
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      ),
      
      // Sign up screen
      GoRoute(
        path: AppRoutes.signup,
        name: 'signup',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SignUpScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      ),
      
      // Forgot password screen
      GoRoute(
        path: AppRoutes.forgotPassword,
        name: 'forgotPassword',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const ForgotPasswordScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      ),
      
      // OTP verification screen
      GoRoute(
        path: AppRoutes.otpVerification,
        name: 'otpVerification',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: OTPVerificationScreen(
            email: state.extra as String?,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      ),
      
      // Reset password screen
      GoRoute(
        path: AppRoutes.resetPassword,
        name: 'resetPassword',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const ResetPasswordScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      ),
    ],
  );
}
