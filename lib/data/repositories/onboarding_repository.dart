/// MSME Pathways - Onboarding Repository
/// 
/// Repository for providing onboarding data with 3 pages.
library;

import '../../core/constants/app_assets.dart';
import '../../core/constants/app_strings.dart';
import '../models/onboarding_model.dart';

/// Abstract interface for onboarding data operations.
abstract class IOnboardingRepository {
  /// Retrieves all onboarding pages.
  List<OnboardingModel> getOnboardingPages();
}

/// Concrete implementation of [IOnboardingRepository].
/// 
/// Provides 3 onboarding pages with local assets and Tagalog titles
/// for Filipino microentrepreneurs.
class OnboardingRepository implements IOnboardingRepository {
  /// Singleton instance
  static final OnboardingRepository _instance = OnboardingRepository._();
  
  /// Factory constructor returns the singleton instance.
  factory OnboardingRepository() => _instance;
  
  /// Private constructor for singleton pattern.
  OnboardingRepository._();

  @override
  List<OnboardingModel> getOnboardingPages() {
    return const [
      // Page 1: Welcome & Trust Building
      // "Start Your Business's New Chapter"
      OnboardingModel(
        id: 1,
        title: AppStrings.onboarding1Title,
        imagePath: AppAssets.onboarding1,
      ),
      
      // Page 2: Solution & Empowerment
      // "Easy to Understand, No Complications"
      OnboardingModel(
        id: 2,
        title: AppStrings.onboarding2Title,
        imagePath: AppAssets.onboarding2,
      ),
      
      // Page 3: Action & Call-to-Action
      // "You Control Your Future"
      OnboardingModel(
        id: 3,
        title: AppStrings.onboarding3Title,
        imagePath: AppAssets.onboarding3,
      ),
    ];
  }
}
