/// MSME Pathways - Tooltip Definitions
///
/// Centralized definitions for all tooltips and tutorials
/// used throughout the application.
library;

import 'package:flutter/material.dart';

import '../../data/models/tooltip_model.dart';

/// GlobalKeys for tooltip targets on the home screen.
class HomeTooltipKeys {
  HomeTooltipKeys._();

  static final calculatorAction = GlobalKey(debugLabel: 'calculatorAction');
  static final dashboardCard = GlobalKey(debugLabel: 'dashboardCard');
  static final educationSection = GlobalKey(debugLabel: 'educationSection');
  static final loanEligibility = GlobalKey(debugLabel: 'loanEligibility');
  static final quickActionsRow = GlobalKey(debugLabel: 'quickActionsRow');
}

/// GlobalKeys for tooltip targets on the calculator screen.
class CalculatorTooltipKeys {
  CalculatorTooltipKeys._();

  static final loanAmountInput = GlobalKey(debugLabel: 'loanAmountInput');
  static final termSelector = GlobalKey(debugLabel: 'termSelector');
  static final calculateButton = GlobalKey(debugLabel: 'calculateButton');
  static final resultCard = GlobalKey(debugLabel: 'resultCard');
}

/// Feature IDs for tracking and persistence.
abstract final class TooltipFeatureIds {
  static const String home = 'home';
  static const String calculator = 'calculator';
  static const String loanApplication = 'loan_application';
  static const String education = 'education';
  static const String profile = 'profile';
}

/// Tooltip IDs for individual tooltips.
abstract final class TooltipIds {
  // Home screen tooltips
  static const String homeCalculatorButton = 'home_calculator_button';
  static const String homeDashboardCard = 'home_dashboard_card';
  static const String homeEducationSection = 'home_education_section';
  static const String homeLoanEligibility = 'home_loan_eligibility';

  // Calculator tooltips
  static const String calculatorLoanAmount = 'calculator_loan_amount';
  static const String calculatorTerms = 'calculator_terms';
  static const String calculatorResult = 'calculator_result';
}

/// Tutorial IDs for contextual tutorials.
abstract final class TutorialIds {
  static const String loanApplication = 'loan_application_tutorial';
  static const String calculator = 'calculator_tutorial';
  static const String education = 'education_tutorial';
}

/// Home screen tooltip configurations.
class HomeTooltipConfigs {
  HomeTooltipConfigs._();

  static List<TooltipConfig> getTooltips() {
    return [
      TooltipConfig(
        id: TooltipIds.homeDashboardCard,
        targetKey: HomeTooltipKeys.dashboardCard,
        title: 'Business Readiness',
        message: 'Complete your profile to unlock up to ₱50,000 in loans',
        position: TooltipPosition.bottom,
        feature: TooltipFeatureIds.home,
        delayMs: 300,
      ),
      TooltipConfig(
        id: TooltipIds.homeLoanEligibility,
        targetKey: HomeTooltipKeys.loanEligibility,
        title: 'Loan Eligibility',
        message: 'See your current maximum loan amount here',
        position: TooltipPosition.bottom,
        feature: TooltipFeatureIds.home,
        delayMs: 0,
      ),
      TooltipConfig(
        id: TooltipIds.homeCalculatorButton,
        targetKey: HomeTooltipKeys.quickActionsRow,
        title: 'Quick Actions',
        message: 'Tap here to calculate loans or check eligibility',
        position: TooltipPosition.bottom,
        feature: TooltipFeatureIds.home,
        delayMs: 0,
      ),
    ];
  }
}

/// Loan application tutorial configuration.
class LoanApplicationTutorialConfig {
  LoanApplicationTutorialConfig._();

  static TutorialConfig get tutorial => TutorialConfig(
        id: TutorialIds.loanApplication,
        featureId: TooltipFeatureIds.loanApplication,
        title: 'How to Apply for a Loan',
        completionMessage: 'You\'re ready to apply!',
        steps: const [
          TutorialStep(
            stepNumber: 1,
            title: 'Review Your Eligibility',
            description:
                'Check your current eligibility status. Based on your profile, you can borrow up to ₱50,000. Complete more activities to increase this amount.',
            iconData: Icons.check_circle_outline,
          ),
          TutorialStep(
            stepNumber: 2,
            title: 'Fill Out Application',
            description:
                'Provide your business details, income information, and loan purpose. Make sure all information is accurate to avoid delays.',
            iconData: Icons.edit_document,
          ),
          TutorialStep(
            stepNumber: 3,
            title: 'Submit Documents',
            description:
                'Upload required documents: valid ID, proof of income, and business registration. Clear photos help speed up verification.',
            iconData: Icons.upload_file,
          ),
          TutorialStep(
            stepNumber: 4,
            title: 'Track Your Status',
            description:
                'Monitor your application progress in real-time. You\'ll receive notifications at each stage. Approval typically takes 3-5 business days.',
            iconData: Icons.track_changes,
          ),
        ],
      );
}

/// Calculator tutorial configuration.
class CalculatorTutorialConfig {
  CalculatorTutorialConfig._();

  static TutorialConfig get tutorial => TutorialConfig(
        id: TutorialIds.calculator,
        featureId: TooltipFeatureIds.calculator,
        title: 'Loan Calculator Guide',
        completionMessage: 'Now calculate your ideal loan!',
        steps: const [
          TutorialStep(
            stepNumber: 1,
            title: 'Enter Loan Amount',
            description:
                'Choose how much you want to borrow. Use the preset amounts for quick selection, or enter a custom amount up to your eligibility limit.',
            iconData: Icons.payments_outlined,
          ),
          TutorialStep(
            stepNumber: 2,
            title: 'Select Payment Terms',
            description:
                'Pick your preferred repayment period. Longer terms mean smaller monthly payments, but you\'ll pay more interest overall.',
            iconData: Icons.calendar_month,
          ),
          TutorialStep(
            stepNumber: 3,
            title: 'View Monthly Breakdown',
            description:
                'See your monthly payment amount, total interest, and complete amortization schedule. This helps you plan your budget.',
            iconData: Icons.bar_chart,
          ),
          TutorialStep(
            stepNumber: 4,
            title: 'Save or Apply',
            description:
                'Happy with the numbers? Save the calculation for later, or proceed directly to your loan application with these terms.',
            iconData: Icons.savings,
          ),
        ],
      );
}

/// Education tutorial configuration.
class EducationTutorialConfig {
  EducationTutorialConfig._();

  static TutorialConfig get tutorial => TutorialConfig(
        id: TutorialIds.education,
        featureId: TooltipFeatureIds.education,
        title: 'Learning Center Guide',
        completionMessage: 'Start learning and earning!',
        steps: const [
          TutorialStep(
            stepNumber: 1,
            title: 'Browse Courses',
            description:
                'Explore courses on financial literacy, business management, and digital skills. Each course is designed for busy entrepreneurs.',
            iconData: Icons.school_outlined,
          ),
          TutorialStep(
            stepNumber: 2,
            title: 'Track Progress',
            description:
                'See your completion status and earn badges for finishing courses. Your progress directly impacts your loan eligibility.',
            iconData: Icons.emoji_events_outlined,
          ),
          TutorialStep(
            stepNumber: 3,
            title: 'Increase Eligibility',
            description:
                'Complete courses to unlock higher loan amounts. Each completed course can increase your eligibility by ₱5,000 - ₱10,000.',
            iconData: Icons.trending_up,
          ),
        ],
      );
}
