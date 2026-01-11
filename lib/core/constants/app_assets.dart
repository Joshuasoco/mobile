/// MSME Pathways - Asset Constants
/// 
/// Centralized asset paths and URLs for the application.
/// Uses free illustrations from Undraw.co (no attribution required).
library;

/// Application asset constants for images, icons, and illustrations.
/// 
/// Network images use Undraw.co illustrations which are free to use
/// without attribution for both personal and commercial projects.
abstract final class AppAssets {
  // ============================================================
  // ONBOARDING ILLUSTRATIONS
  // Using Undraw.co SVG illustrations (financial/business themed)
  // ============================================================
  
  /// Welcome page illustration - financial growth theme
  /// Shows a person with financial charts/growth indicators
  static const String onboardingWelcome = 
      'https://illustrations.popsy.co/amber/investing.svg';
  
  /// AI Assistant illustration - smart guidance theme
  /// Shows AI/chat assistance concept
  static const String onboardingAI = 
      'https://illustrations.popsy.co/amber/remote-work.svg';
  
  /// Empowerment illustration - building confidence theme
  /// Shows success/achievement concept
  static const String onboardingConfidence = 
      'https://illustrations.popsy.co/amber/success.svg';
  
  /// Features illustration - business growth theme
  /// Shows business tools/features concept
  static const String onboardingFeatures = 
      'https://illustrations.popsy.co/amber/woman-with-a-laptop.svg';

  // ============================================================
  // LOCAL ASSETS
  // ============================================================
  
  /// App logo
  static const String logo = 'assets/images/logo.png';
  
  /// MSME logo (primary branding)
  static const String msmeLogo = 'assets/images/msmeLogo.png';
  
  /// Splash screen logo (geometric M design)
  static const String splashLogo = 'assets/images/splashlogo.png';
  
  /// Placeholder image for loading states
  static const String placeholder = 'assets/placeholder.png';

  // ============================================================
  // ICONS (using Material Icons, no custom assets needed)
  // ============================================================
  
  // All icons use Flutter's built-in Icons class
}
