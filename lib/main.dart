/// MSME Pathways - Main Application Entry Point
/// 
/// An AI-powered financial inclusion platform helping Filipino
/// microentrepreneurs access formal loans and financial education.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

/// Application entry point.
/// 
/// Sets up system UI overlays and launches the MSME Pathways app.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configure system UI for splash screen (dark background)
  // This will be updated when navigating to onboarding
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light, // Light icons for dark splash
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Color(0xFF1A1A1A), // Match splash dark gradient
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  
  // Set preferred orientations (portrait only for onboarding)
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const MSMEPathwaysApp());
  });
}

/// Root widget for the MSME Pathways application.
/// 
/// Configures:
/// - Material 3 theming
/// - GoRouter navigation
/// - App-wide error handling
class MSMEPathwaysApp extends StatelessWidget {
  /// Creates the root application widget.
  const MSMEPathwaysApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = AppRouter().router;
    
    return MaterialApp.router(
      // App identification
      title: 'MSME Pathways',
      debugShowCheckedModeBanner: false,
      
      // Theme configuration
      theme: AppTheme.lightTheme,
      
      // Router configuration
      routerConfig: router,
      
      // Error handling
      builder: (context, child) {
        // Wrap with error boundary for graceful error handling
        ErrorWidget.builder = (FlutterErrorDetails details) {
          return _ErrorScreen(error: details);
        };
        
        // Apply text scaling limits for accessibility while maintaining layout
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(
              MediaQuery.of(context).textScaler.scale(1.0).clamp(0.8, 1.3),
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}

/// Error screen for unhandled Flutter errors.
class _ErrorScreen extends StatelessWidget {
  const _ErrorScreen({required this.error});

  final FlutterErrorDetails error;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 64,
                color: Colors.red[400],
              ),
              const SizedBox(height: 16),
              const Text(
                'Something went wrong',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3748),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Please restart the app',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
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
