// MSME Pathways - Eligibility Checker Screen
// 
// Main screen for the 5-step guest eligibility checker flow.
// Allows users to check loan eligibility without creating an account.


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/services/form_draft_service.dart';
import '../../../data/models/eligibility_model.dart';
import '../../viewmodels/eligibility_viewmodel.dart';
import '../../widgets/eligibility/eligibility_widgets.dart';
import '../../widgets/eligibility/eligibility_results_screen.dart';

/// Main eligibility checker screen with 5-step wizard.
class EligibilityCheckerScreen extends StatefulWidget {
  /// Creates the eligibility checker screen.
  const EligibilityCheckerScreen({super.key});

  @override
  State<EligibilityCheckerScreen> createState() => _EligibilityCheckerScreenState();
}

class _EligibilityCheckerScreenState extends State<EligibilityCheckerScreen> {
  @override
  void initState() {
    super.initState();
    // Set light status bar for this screen
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EligibilityViewModel(
        formDraftService: context.read<FormDraftService>(),
      ),
      child: const _EligibilityContent(),
    );
  }
}

/// Internal content widget that consumes the ViewModel.
class _EligibilityContent extends StatelessWidget {
  const _EligibilityContent();

  @override
  Widget build(BuildContext context) {
    return Consumer<EligibilityViewModel>(
      builder: (context, viewModel, _) {
        // Show results screen when calculation is complete
        if (viewModel.showingResults && viewModel.result != null) {
          return EligibilityResultsScreen(
            result: viewModel.result!,
            onCreateAccount: () => context.go('/signup'),
            onTryAgain: viewModel.reset,
          );
        }

        // Main wizard flow
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: _buildAppBar(context, viewModel),
          body: Column(
            children: [
              // Progress indicator
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                child: StepProgressIndicator(
                  currentStep: viewModel.currentStep,
                  totalSteps: EligibilityViewModel.totalSteps,
                ),
              ),
              
              // Step content
              Expanded(
                child: PageView(
                  controller: viewModel.pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: viewModel.onPageChanged,
                  children: [
                    _BusinessTypeStep(viewModel: viewModel),
                    _BusinessAgeStep(viewModel: viewModel),
                    _MonthlyIncomeStep(viewModel: viewModel),
                    _LoanAmountStep(viewModel: viewModel),
                    _DocumentsStep(viewModel: viewModel),
                  ],
                ),
              ),
              
              // Bottom navigation
              _buildBottomNav(context, viewModel),
            ],
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, EligibilityViewModel viewModel) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF2D3748)),
        onPressed: () {
          if (viewModel.isFirstStep) {
            context.pop();
          } else {
            viewModel.previousStep();
          }
        },
      ),
      title: Column(
        children: [
          Text(
            'Eligibility Check',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2D3748),
            ),
          ),
          Text(
            'Step ${viewModel.currentStep + 1} of ${EligibilityViewModel.totalSteps}',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: const Color(0xFF718096),
            ),
          ),
        ],
      ),
      centerTitle: true,
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: Text(
            'Exit',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF718096),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNav(BuildContext context, EligibilityViewModel viewModel) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        24,
        16,
        24,
        MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: EligibilityActionButton(
        label: viewModel.isLastStep ? 'Check My Eligibility' : 'Continue',
        isEnabled: viewModel.canProceed,
        onPressed: () {
          if (viewModel.isLastStep) {
            viewModel.calculateResults();
          } else {
            viewModel.nextStep();
          }
        },
      ),
    );
  }
}

/// Step 1: Business Type Selection
class _BusinessTypeStep extends StatelessWidget {
  const _BusinessTypeStep({required this.viewModel});

  final EligibilityViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return _StepContainer(
      title: viewModel.currentStepTitle,
      subtitle: viewModel.currentStepSubtitle,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: BusinessType.values.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final type = BusinessType.values[index];
          return SelectionOptionCard(
            label: type.label,
            isSelected: viewModel.selectedBusinessType == type,
            onTap: () => viewModel.selectBusinessType(type),
            icon: _getBusinessIcon(type),
          ).animate().fadeIn(delay: (100 * index).ms).slideX(begin: 0.1, end: 0);
        },
      ),
    );
  }

  IconData _getBusinessIcon(BusinessType type) {
    switch (type) {
      case BusinessType.sariSariStore:
        return Icons.store;
      case BusinessType.marketVendorFood:
        return Icons.restaurant;
      case BusinessType.marketVendorNonFood:
        return Icons.shopping_bag;
      case BusinessType.onlineSeller:
        return Icons.shopping_cart;
      case BusinessType.homeBasedBusiness:
        return Icons.home_work;
      case BusinessType.other:
        return Icons.more_horiz;
    }
  }
}

/// Step 2: Business Age Selection
class _BusinessAgeStep extends StatelessWidget {
  const _BusinessAgeStep({required this.viewModel});

  final EligibilityViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return _StepContainer(
      title: viewModel.currentStepTitle,
      subtitle: viewModel.currentStepSubtitle,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: BusinessAge.values.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final age = BusinessAge.values.reversed.toList()[index];
          return SelectionOptionCard(
            label: age.label,
            isSelected: viewModel.selectedBusinessAge == age,
            onTap: () => viewModel.selectBusinessAge(age),
            icon: _getAgeIcon(age),
            subtitle: _getAgeSubtitle(age),
          ).animate().fadeIn(delay: (100 * index).ms).slideX(begin: 0.1, end: 0);
        },
      ),
    );
  }

  IconData _getAgeIcon(BusinessAge age) {
    switch (age) {
      case BusinessAge.fiveYearsPlus:
        return Icons.emoji_events;
      case BusinessAge.twoToFiveYears:
        return Icons.star;
      case BusinessAge.oneToTwoYears:
        return Icons.trending_up;
      case BusinessAge.sixMonthsTo1Year:
        return Icons.rocket_launch;
      case BusinessAge.lessThan6Months:
        return Icons.schedule;
    }
  }

  String? _getAgeSubtitle(BusinessAge age) {
    switch (age) {
      case BusinessAge.fiveYearsPlus:
        return 'Highest eligibility';
      case BusinessAge.twoToFiveYears:
        return 'Good eligibility';
      case BusinessAge.oneToTwoYears:
        return 'Moderate eligibility';
      case BusinessAge.sixMonthsTo1Year:
        return 'Building history';
      case BusinessAge.lessThan6Months:
        return 'Just starting';
    }
  }
}

/// Step 3: Monthly Income Slider
class _MonthlyIncomeStep extends StatelessWidget {
  const _MonthlyIncomeStep({required this.viewModel});

  final EligibilityViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return _StepContainer(
      title: viewModel.currentStepTitle,
      subtitle: viewModel.currentStepSubtitle,
      child: Center(
        child: IncomeSlider(
          value: viewModel.monthlyIncome,
          onChanged: viewModel.setMonthlyIncome,
          min: EligibilityViewModel.minIncome,
          max: EligibilityViewModel.maxIncome,
          formatLabel: viewModel.formatIncome,
        ).animate().fadeIn().scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1)),
      ),
    );
  }
}

/// Step 4: Loan Amount Selection
class _LoanAmountStep extends StatelessWidget {
  const _LoanAmountStep({required this.viewModel});

  final EligibilityViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return _StepContainer(
      title: viewModel.currentStepTitle,
      subtitle: viewModel.currentStepSubtitle,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: LoanAmountRange.values.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final range = LoanAmountRange.values[index];
          return SelectionOptionCard(
            label: range.label,
            isSelected: viewModel.selectedLoanAmount == range,
            onTap: () => viewModel.selectLoanAmount(range),
            icon: Icons.attach_money,
          ).animate().fadeIn(delay: (100 * index).ms).slideX(begin: 0.1, end: 0);
        },
      ),
    );
  }
}

/// Step 5: Documents Checklist
class _DocumentsStep extends StatelessWidget {
  const _DocumentsStep({required this.viewModel});

  final EligibilityViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return _StepContainer(
      title: viewModel.currentStepTitle,
      subtitle: viewModel.currentStepSubtitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tip banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: Color(0xFF1565C0),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Mas maraming documents, mas mataas ang chance!',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: const Color(0xFF1565C0),
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn().slideY(begin: -0.1, end: 0),
          
          const SizedBox(height: 20),
          
          // Documents list
          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: AvailableDocument.values.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final doc = AvailableDocument.values[index];
                return DocumentCheckbox(
                  document: doc,
                  isChecked: viewModel.isDocumentSelected(doc),
                  onChanged: () => viewModel.toggleDocument(doc),
                ).animate().fadeIn(delay: (100 * index).ms);
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Container for step content with title and subtitle.
class _StepContainer extends StatelessWidget {
  const _StepContainer({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 4),
          
          // Subtitle
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF718096),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Content
          Expanded(child: child),
        ],
      ),
    );
  }
}
