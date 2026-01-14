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
  // ONBOARDING PAGES - Tagalog titles (minimal design, no subtitles)
  // ============================================================
  
  /// Page 1 headline - "Start Your Business's New Chapter"
  static const String onboarding1Title = 
      'Nahihirapan Makakuha ng Pautang sa Bangko?';
  
  /// Page 2 headline - "Easy to Understand, No Complications"
  static const String onboarding2Title = 
      'May AI na Tutulong sa Iyo Makakuha ng Bank Loan';
  
  /// Page 3 headline - "You Control Your Future"
  static const String onboarding3Title = 
      'Walang Credit History? Kaya Mo Pa Rin!';

  // ============================================================
  // BUTTON LABELS (English)
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
