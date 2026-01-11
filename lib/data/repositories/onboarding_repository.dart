/// MSME Pathways - Onboarding Repository
/// 
/// Repository for providing onboarding data with proper abstraction.
library;

import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../models/onboarding_model.dart';

/// Abstract interface for onboarding data operations.
/// 
/// This abstraction allows for easy testing and future data source changes
/// (e.g., fetching onboarding content from a remote server).
abstract class IOnboardingRepository {
  /// Retrieves all onboarding pages.
  List<OnboardingModel> getOnboardingPages();
}

/// Concrete implementation of [IOnboardingRepository].
/// 
/// Currently provides static onboarding data optimized for Filipino
/// microentrepreneurs entering the formal financial system.
class OnboardingRepository implements IOnboardingRepository {
  /// Singleton instance for simple dependency injection.
  static final OnboardingRepository _instance = OnboardingRepository._();
  
  /// Factory constructor returns the singleton instance.
  factory OnboardingRepository() => _instance;
  
  /// Private constructor for singleton pattern.
  OnboardingRepository._();

  @override
  List<OnboardingModel> getOnboardingPages() {
    return [
      // Page 1: Welcome & Problem Statement
      // Addresses the challenge of financial exclusion faced by MSMEs
      OnboardingModel(
        id: 1,
        title: AppStrings.onboarding1Title,
        subtitle: AppStrings.onboarding1Subtitle,
        imageUrl: AppAssets.onboardingWelcome,
        backgroundColor: AppColors.primary,
      ),
      
      // Page 2: Solution Introduction
      // Introduces AI-powered guidance and simplified lending process
      OnboardingModel(
        id: 2,
        title: AppStrings.onboarding2Title,
        subtitle: AppStrings.onboarding2Subtitle,
        imageUrl: AppAssets.onboardingAI,
        backgroundColor: AppColors.secondary,
      ),
      
      // Page 3: Empowerment & Trust
      // Addresses the "no credit history" concern with alternative data
      OnboardingModel(
        id: 3,
        title: AppStrings.onboarding3Title,
        subtitle: AppStrings.onboarding3Subtitle,
        imageUrl: AppAssets.onboardingConfidence,
        backgroundColor: AppColors.accent,
      ),
      
      // Page 4: Features Overview
      // Summarizes key features with quick-scan format
      OnboardingModel(
        id: 4,
        title: AppStrings.onboarding4Title,
        subtitle: AppStrings.onboarding4Subtitle,
        imageUrl: AppAssets.onboardingFeatures,
        backgroundColor: AppColors.primaryLight,
        features: [
          const OnboardingFeature(
            icon: Icons.auto_awesome,
            title: AppStrings.feature1Title,
            description: AppStrings.feature1Description,
          ),
          const OnboardingFeature(
            icon: Icons.school_outlined,
            title: AppStrings.feature2Title,
            description: AppStrings.feature2Description,
          ),
          const OnboardingFeature(
            icon: Icons.trending_up_rounded,
            title: AppStrings.feature3Title,
            description: AppStrings.feature3Description,
          ),
        ],
      ),
    ];
  }
}
