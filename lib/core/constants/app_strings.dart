/// MSME Pathways - UI String Constants
/// 
/// Centralized text strings for the application.
/// Culturally relevant messaging for Filipino microentrepreneurs.
library;

/// Application string constants for the MSME Pathways app.
/// 
/// Organized by feature/screen for maintainability.
abstract final class AppStrings {
  // ============================================================
  // APP-WIDE STRINGS
  // ============================================================
  
  /// Application name
  static const String appName = 'MSME Pathways';
  
  /// Application tagline
  static const String tagline = 'Your path to financial growth';

  // ============================================================
  // ONBOARDING PAGE 1 - Welcome & Problem Statement
  // ============================================================
  
  /// Page 1 headline
  static const String onboarding1Title = 
      'Your Path to Financial\nGrowth Starts Here';
  
  /// Page 1 description - addresses financial exclusion challenge
  static const String onboarding1Subtitle = 
      'Many hardworking Filipinos like you find it difficult to '
      'access formal loans. We\'re here to change that.';

  // ============================================================
  // ONBOARDING PAGE 2 - Solution Introduction
  // ============================================================
  
  /// Page 2 headline
  static const String onboarding2Title = 
      'Smart Guidance,\nSimplified Lending';
  
  /// Page 2 description - explains AI-powered features
  static const String onboarding2Subtitle = 
      'Our AI assistant guides you through the lending process, '
      'helping you understand your options and prepare for success.';

  // ============================================================
  // ONBOARDING PAGE 3 - Empowerment & Trust
  // ============================================================
  
  /// Page 3 headline
  static const String onboarding3Title = 
      'Build Your Business\nwith Confidence';
  
  /// Page 3 description - addresses no credit history concern
  static const String onboarding3Subtitle = 
      'No credit history? No problem. We use alternative data '
      'to help you demonstrate your business potential.';

  // ============================================================
  // ONBOARDING PAGE 4 - Features Overview
  // ============================================================
  
  /// Page 4 headline
  static const String onboarding4Title = 
      'Everything You Need\nto Succeed';
  
  /// Page 4 description - summarizes key features
  static const String onboarding4Subtitle = 
      'Financial education, loan pre-qualification, and personalized '
      'guidance — all in one place.';
  
  /// Feature 1 title
  static const String feature1Title = 'Smart Loan Matching';
  
  /// Feature 1 description
  static const String feature1Description = 
      'Get matched with lenders suited to your needs';
  
  /// Feature 2 title
  static const String feature2Title = 'Financial Education';
  
  /// Feature 2 description
  static const String feature2Description = 
      'Learn essential skills for business success';
  
  /// Feature 3 title
  static const String feature3Title = 'Progress Tracking';
  
  /// Feature 3 description
  static const String feature3Description = 
      'Monitor your readiness for formal lending';

  // ============================================================
  // BUTTON LABELS
  // ============================================================
  
  /// Skip button text
  static const String skip = 'Skip';
  
  /// Next button text
  static const String next = 'Next';
  
  /// Get Started button text
  static const String getStarted = 'Get Started';
  
  /// Back button text
  static const String back = 'Back';
  
  /// Continue button text
  static const String continueText = 'Continue';

  // ============================================================
  // ACCESSIBILITY LABELS
  // ============================================================
  
  /// Skip button semantic label
  static const String skipButtonSemantics = 'Skip onboarding';
  
  /// Next button semantic label
  static const String nextButtonSemantics = 'Go to next page';
  
  /// Previous button semantic label
  static const String previousButtonSemantics = 'Go to previous page';
  
  /// Get Started button semantic label
  static const String getStartedSemantics = 'Start using the app';
  
  /// Page indicator semantic label
  static String pageIndicatorSemantics(int current, int total) =>
      'Page $current of $total';

  // ============================================================
  // SPLASH SCREEN STRINGS
  // ============================================================
  
  /// Splash screen tagline
  static const String splashTagline = 'Smart Loan Support for Growth';
  
  /// Alternative splash tagline
  static const String splashTaglineAlt = 'Empowering Your Business Journey';
  
  /// Splash screen loading text (optional)
  static const String splashLoading = 'Loading...';
  
  /// Splash logo semantic label
  static const String splashLogoSemantics = 'MSME Pathways logo';

  // ============================================================
  // TERMS & PRIVACY POLICY STRINGS
  // ============================================================
  
  /// Terms & Privacy screen title
  static const String termsPrivacyTitle = 'Terms & Privacy Policy';
  
  /// Terms & Privacy screen subtitle
  static const String termsPrivacySubtitle = 'Please review before continuing';
  
  /// Terms of Service tab label
  static const String termsOfService = 'Terms of Service';
  
  /// Privacy Policy tab label
  static const String privacyPolicy = 'Privacy Policy';
  
  /// Accept checkbox label
  static const String acceptTermsLabel = 
      'I have read and agree to the Terms of Service and Privacy Policy';
  
  /// Accept button text
  static const String acceptAndContinue = 'Accept & Continue';
  
  /// Decline button text
  static const String decline = 'Decline';
  
  /// Decline dialog title
  static const String declineDialogTitle = 'Decline Terms?';
  
  /// Decline dialog message
  static const String declineDialogMessage = 
      'You must accept the Terms of Service and Privacy Policy to use '
      'MSME Pathways. Would you like to go back?';
  
  /// Stay button text (decline dialog)
  static const String stay = 'Stay';
  
  /// Go Back button text (decline dialog)
  static const String goBack = 'Go Back';
  
  /// Terms & Privacy semantics
  static const String termsPrivacySemantics = 
      'Terms of Service and Privacy Policy acceptance screen';
}

