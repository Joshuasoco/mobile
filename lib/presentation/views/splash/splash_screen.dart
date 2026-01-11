/// MSME Pathways - Splash Screen View
///
/// A professional splash screen with animated logo, branding text,
/// and seamless navigation to onboarding or home screens.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/splash_viewmodel.dart';
import '../../widgets/splash/animated_logo.dart';
import '../../widgets/splash/branding_text.dart';
import '../../widgets/splash/gradient_background.dart';
import '../../widgets/splash/loading_indicator.dart';

/// Splash screen for MSME Pathways application.
///
/// Features:
/// - Animated dark gradient background
/// - Logo with scale and glow effects
/// - Staggered branding text animations
/// - Automatic navigation after initialization
/// - Skip option for long loads
/// - Proper lifecycle management
class SplashScreen extends StatefulWidget {
  /// Creates the splash screen.
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with WidgetsBindingObserver {
  late SplashViewModel _viewModel;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    // Set system UI for dark splash screen
    _setDarkSystemUI();
    
    // Initialize view model
    _viewModel = SplashViewModel();
    
    // Start initialization after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeSplash();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _viewModel.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Handle app backgrounding gracefully
    if (state == AppLifecycleState.resumed) {
      _setDarkSystemUI();
    }
  }

  /// Sets dark system UI overlay style for splash screen.
  void _setDarkSystemUI() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Color(0xFF1A1A1A),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  }

  /// Initialize splash and set up navigation listener.
  Future<void> _initializeSplash() async {
    _viewModel.addListener(_onViewModelChanged);
    await _viewModel.initialize();
  }

  /// Handle view model state changes.
  void _onViewModelChanged() {
    if (_viewModel.shouldNavigate && !_hasNavigated && mounted) {
      _navigateToNextScreen();
    }
  }

  /// Navigate to the appropriate next screen.
  void _navigateToNextScreen() {
    if (_hasNavigated) return;
    
    setState(() {
      _hasNavigated = true;
    });

    // Reset system UI to light for next screens
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    // Navigate using GoRouter
    final targetPath = _viewModel.getTargetRoutePath();
    context.go(targetPath);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SplashViewModel>.value(
      value: _viewModel,
      child: Scaffold(
        body: GradientBackground(
          child: SafeArea(
            child: _buildContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Main centered content
        _buildCenteredContent(),
        
        // Skip button (appears after 3 seconds)
        _buildSkipButton(),
      ],
    );
  }

  Widget _buildCenteredContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Spacer for top balance
        const Spacer(flex: 2),
        
        // Animated logo
        const AnimatedLogo(
          delayStart: Duration(milliseconds: 300),
          entranceDuration: Duration(milliseconds: 500),
          logoSizePercent: 0.40,
          maxLogoSize: 200.0,
          showGlowEffect: true,
        ),
        
        // Spacing between logo and text
        const SizedBox(height: 40),
        
        // Branding text
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: BrandingText(
            appNameDelay: Duration(milliseconds: 800),
            taglineDelay: Duration(milliseconds: 1000),
            animationDuration: Duration(milliseconds: 400),
          ),
        ),
        
        // Spacing before loading indicator
        const SizedBox(height: 32),
        
        // Loading indicator
        const SplashLoadingIndicator(
          delay: Duration(milliseconds: 1400),
        ),
        
        // Spacer for bottom balance
        const Spacer(flex: 3),
      ],
    );
  }

  Widget _buildSkipButton() {
    return Positioned(
      right: 16,
      top: 16,
      child: Consumer<SplashViewModel>(
        builder: (context, viewModel, child) {
          // Only show skip if taking too long (after 3 seconds)
          return FutureBuilder(
            future: Future.delayed(const Duration(seconds: 3)),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const SizedBox.shrink();
              }
              
              // Don't show if already navigating
              if (viewModel.shouldNavigate) {
                return const SizedBox.shrink();
              }
              
              return _SkipButton(
                onPressed: () {
                  viewModel.skipSplash();
                },
              );
            },
          );
        },
      ),
    );
  }
}

/// Skip button for splash screen.
class _SkipButton extends StatelessWidget {
  const _SkipButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Skip splash screen',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Text(
              'Skip',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
