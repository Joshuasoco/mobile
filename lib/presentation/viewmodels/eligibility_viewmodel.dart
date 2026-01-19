// MSME Pathways - Eligibility Checker ViewModel
// 
// Manages state for the 5-screen eligibility checker flow.
// Handles navigation, validation, and result calculation.


import 'package:flutter/material.dart';

import '../../core/services/form_draft_service.dart';
import '../../data/models/eligibility_model.dart';

/// ViewModel for the eligibility checker flow.
/// 
/// Manages:
/// - 5-step wizard navigation
/// - User answer collection
/// - Eligibility calculation
/// - Form validation
class EligibilityViewModel extends ChangeNotifier {
  final FormDraftService formDraftService;

  /// Creates the eligibility viewmodel.
  EligibilityViewModel({
    required this.formDraftService,
  }) {
    _pageController = PageController();
    _loadDraft();
  }

  /// Loads saved draft if available.
  Future<void> _loadDraft() async {
    final draft = await formDraftService.getEligibilityDraft();
    if (draft != null) {
      _answers = draft;
      notifyListeners();
    }
  }

  /// Saves current progress.
  void _saveDraft() {
    formDraftService.saveEligibilityDraft(_answers);
  }

  // ============================================================
  // PAGE NAVIGATION
  // ============================================================

  late final PageController _pageController;
  
  /// Page controller for the wizard steps.
  PageController get pageController => _pageController;
  
  int _currentStep = 0;
  
  /// Current step index (0-4 for 5 screens).
  int get currentStep => _currentStep;
  
  /// Total number of steps.
  static const int totalSteps = 5;
  
  /// Whether user is on the first step.
  bool get isFirstStep => _currentStep == 0;
  
  /// Whether user is on the last step (documents).
  bool get isLastStep => _currentStep == totalSteps - 1;
  
  /// Progress value for the progress indicator (0.0 - 1.0).
  double get progress => (_currentStep + 1) / totalSteps;
  
  /// Title for the current step.
  String get currentStepTitle {
    switch (_currentStep) {
      case 0:
        return 'Ano ang iyong negosyo?';
      case 1:
        return 'Gaano katagal na ang negosyo mo?';
      case 2:
        return 'Magkano ang kita mo monthly?';
      case 3:
        return 'Magkano ang loan na kailangan mo?';
      case 4:
        return 'May mga ito ka ba?';
      default:
        return '';
    }
  }

  /// Subtitle/helper text for current step.
  String get currentStepSubtitle {
    switch (_currentStep) {
      case 0:
        return 'Piliin ang uri ng iyong negosyo';
      case 1:
        return 'Mas matagal, mas mataas ang chance';
      case 2:
        return 'Average monthly income ng negosyo';
      case 3:
        return 'Piliin ang amount na kailangan mo';
      case 4:
        return 'Check lahat ng meron ka';
      default:
        return '';
    }
  }

  // ============================================================
  // USER ANSWERS
  // ============================================================

  EligibilityAnswers _answers = const EligibilityAnswers();
  
  /// Current eligibility answers.
  EligibilityAnswers get answers => _answers;
  
  // Business Type (Step 1)
  BusinessType? get selectedBusinessType => _answers.businessType;
  String? get otherBusinessType => _answers.otherBusinessType;
  
  /// Selects a business type.
  void selectBusinessType(BusinessType type) {
    _answers = _answers.copyWith(businessType: type);
    _saveDraft();
    notifyListeners();
  }
  
  /// Sets custom business type text.
  void setOtherBusinessType(String value) {
    _answers = _answers.copyWith(otherBusinessType: value);
    _saveDraft();
    notifyListeners();
  }
  
  // Business Age (Step 2)
  BusinessAge? get selectedBusinessAge => _answers.businessAge;
  
  /// Selects business age.
  void selectBusinessAge(BusinessAge age) {
    _answers = _answers.copyWith(businessAge: age);
    _saveDraft();
    notifyListeners();
  }
  
  // Monthly Income (Step 3)
  double get monthlyIncome => _answers.monthlyIncome;
  
  /// Minimum income on slider.
  static const double minIncome = 0;
  
  /// Maximum income on slider.
  static const double maxIncome = 100000;
  
  /// Income slider divisions.
  static const int incomeDivisions = 20;
  
  /// Sets monthly income value.
  void setMonthlyIncome(double value) {
    _answers = _answers.copyWith(monthlyIncome: value);
    _saveDraft();
    notifyListeners();
  }
  
  /// Formats income for display.
  String formatIncome(double value) {
    if (value >= 100000) return '₱100K+';
    if (value >= 1000) return '₱${(value / 1000).toStringAsFixed(0)}K';
    return '₱${value.toStringAsFixed(0)}';
  }
  
  // Loan Amount (Step 4)
  LoanAmountRange? get selectedLoanAmount => _answers.loanAmountNeeded;
  
  /// Selects desired loan amount range.
  void selectLoanAmount(LoanAmountRange range) {
    _answers = _answers.copyWith(loanAmountNeeded: range);
    _saveDraft();
    notifyListeners();
  }
  
  // Documents (Step 5)
  List<AvailableDocument> get selectedDocuments => _answers.availableDocuments;
  
  /// Toggles a document selection.
  void toggleDocument(AvailableDocument doc) {
    final currentDocs = List<AvailableDocument>.from(_answers.availableDocuments);
    if (currentDocs.contains(doc)) {
      currentDocs.remove(doc);
    } else {
      currentDocs.add(doc);
    }
    _answers = _answers.copyWith(availableDocuments: currentDocs);
    _saveDraft();
    notifyListeners();
  }
  
  /// Checks if a document is selected.
  bool isDocumentSelected(AvailableDocument doc) {
    return _answers.availableDocuments.contains(doc);
  }

  // ============================================================
  // VALIDATION
  // ============================================================

  /// Whether current step can proceed.
  bool get canProceed {
    switch (_currentStep) {
      case 0:
        return selectedBusinessType != null;
      case 1:
        return selectedBusinessAge != null;
      case 2:
        return monthlyIncome > 0;
      case 3:
        return selectedLoanAmount != null;
      case 4:
        return true; // Documents are optional for results
      default:
        return false;
    }
  }
  
  /// Whether all required fields are complete.
  bool get isComplete => _answers.isComplete;

  // ============================================================
  // NAVIGATION
  // ============================================================

  /// Goes to the next step.
  void nextStep() {
    if (_currentStep < totalSteps - 1 && canProceed) {
      _currentStep++;
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      notifyListeners();
    }
  }
  
  /// Goes to the previous step.
  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      notifyListeners();
    }
  }
  
  /// Handles page change from swipe.
  void onPageChanged(int index) {
    // Only allow going back via swipe, not forward without validation
    if (index < _currentStep) {
      _currentStep = index;
      notifyListeners();
    } else if (index > _currentStep && canProceed) {
      _currentStep = index;
      notifyListeners();
    } else {
      // Reset to current step if validation fails
      _pageController.jumpToPage(_currentStep);
    }
  }

  // ============================================================
  // RESULTS
  // ============================================================

  EligibilityResult? _result;
  
  /// Calculated eligibility result.
  EligibilityResult? get result => _result;
  
  bool _showingResults = false;
  
  /// Whether we're showing results screen.
  bool get showingResults => _showingResults;
  
  /// Calculates and shows results.
  void calculateResults() {
    _result = EligibilityCalculator.calculate(_answers);
    _showingResults = true;
    // Clear draft upon completion? Or keep it? 
    // Usually better to keep until they explicitly "finish" or start over.
    // We'll clear when they Reset.
    notifyListeners();
  }
  
  /// Resets to start over.
  void reset() {
    formDraftService.clearEligibilityDraft();
    _currentStep = 0;
    _answers = const EligibilityAnswers();
    _result = null;
    _showingResults = false;
    _pageController.jumpToPage(0);
    notifyListeners();
  }

  // ============================================================
  // CLEANUP
  // ============================================================

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
