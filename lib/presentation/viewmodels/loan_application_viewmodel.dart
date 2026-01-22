/// MSME Pathways - Loan Application ViewModel
///
/// Business logic and state management for loan application flow.
/// Handles multi-step form, validation, and draft persistence.
library;

import 'package:flutter/foundation.dart';

import '../../core/services/form_draft_service.dart';
import '../../data/models/loan_application_model.dart';

/// ViewModel for loan application screen.
///
/// Manages:
/// - Multi-step form navigation
/// - Form data collection
/// - Validation
/// - Draft save/restore
class LoanApplicationViewModel extends ChangeNotifier {
  /// Creates a LoanApplicationViewModel.
  LoanApplicationViewModel({
    required FormDraftService formDraftService,
  }) : _formDraftService = formDraftService {
    _initialize();
  }

  final FormDraftService _formDraftService;
  static const _draftKey = 'loan_application_draft';

  // ============================================================
  // STATE
  // ============================================================

  /// Current application data.
  LoanApplicationData _data = const LoanApplicationData();
  LoanApplicationData get data => _data;

  /// Current step.
  LoanApplicationStep _currentStep = LoanApplicationStep.personalInfo;
  LoanApplicationStep get currentStep => _currentStep;

  /// Whether the form is submitting.
  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  /// Whether there's a saved draft.
  bool _hasDraft = false;
  bool get hasDraft => _hasDraft;

  /// Submission error message.
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // ============================================================
  // COMPUTED PROPERTIES
  // ============================================================

  /// Current step index.
  int get currentStepIndex => _currentStep.index;

  /// Total number of steps.
  int get totalSteps => LoanApplicationStep.values.length;

  /// Progress percentage (0.0 - 1.0).
  double get progress => (currentStepIndex + 1) / totalSteps;

  /// Whether current step is valid.
  bool get canProceed => _data.isStepValid(_currentStep);

  /// Whether on first step.
  bool get isFirstStep => _currentStep == LoanApplicationStep.personalInfo;

  /// Whether on last step.
  bool get isLastStep => _currentStep == LoanApplicationStep.documents;

  /// Whether all steps are complete.
  bool get isComplete => _data.isComplete;

  /// Validation error for current step.
  String? get currentStepError => _data.getStepError(_currentStep);

  // ============================================================
  // NAVIGATION
  // ============================================================

  /// Goes to next step.
  void nextStep() {
    if (canProceed && !isLastStep) {
      final nextIndex = _currentStep.index + 1;
      _currentStep = LoanApplicationStep.values[nextIndex];
      _saveDraft();
      notifyListeners();
    }
  }

  /// Goes to previous step.
  void previousStep() {
    if (!isFirstStep) {
      final prevIndex = _currentStep.index - 1;
      _currentStep = LoanApplicationStep.values[prevIndex];
      notifyListeners();
    }
  }

  /// Jumps to specific step.
  void goToStep(LoanApplicationStep step) {
    _currentStep = step;
    notifyListeners();
  }

  // ============================================================
  // DATA UPDATES - Personal Info
  // ============================================================

  void updateFullName(String value) {
    _data = _data.copyWith(fullName: value);
    notifyListeners();
  }

  void updateEmail(String value) {
    _data = _data.copyWith(email: value);
    notifyListeners();
  }

  void updatePhone(String value) {
    _data = _data.copyWith(phone: value);
    notifyListeners();
  }

  void updateAddress(String value) {
    _data = _data.copyWith(address: value);
    notifyListeners();
  }

  // ============================================================
  // DATA UPDATES - Loan Details
  // ============================================================

  void updateLoanAmount(double value) {
    _data = _data.copyWith(loanAmount: value);
    notifyListeners();
  }

  void updateLoanPurpose(LoanPurpose? value) {
    _data = _data.copyWith(loanPurpose: value);
    notifyListeners();
  }

  void updateLoanPurposeOther(String value) {
    _data = _data.copyWith(loanPurposeOther: value);
    notifyListeners();
  }

  // ============================================================
  // DATA UPDATES - Business Info
  // ============================================================

  void updateBusinessName(String value) {
    _data = _data.copyWith(businessName: value);
    notifyListeners();
  }

  void updateBusinessType(String value) {
    _data = _data.copyWith(businessType: value);
    notifyListeners();
  }

  void updateBusinessAge(String value) {
    _data = _data.copyWith(businessAge: value);
    notifyListeners();
  }

  void updateMonthlyIncome(double value) {
    _data = _data.copyWith(monthlyIncome: value);
    notifyListeners();
  }

  // ============================================================
  // DATA UPDATES - Documents
  // ============================================================

  void updateHasValidId(bool value) {
    _data = _data.copyWith(hasValidId: value);
    notifyListeners();
  }

  void updateHasSalesRecords(bool value) {
    _data = _data.copyWith(hasSalesRecords: value);
    notifyListeners();
  }

  // ============================================================
  // ACTIONS
  // ============================================================

  /// Submits the application.
  Future<bool> submit() async {
    if (!isComplete) {
      _errorMessage = 'Please complete all required fields';
      notifyListeners();
      return false;
    }

    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Update status
      _data = _data.copyWith(
        status: LoanApplicationStatus.submitted,
        submittedAt: DateTime.now(),
      );

      // Clear draft
      await _formDraftService.deleteDraft(_draftKey);
      _hasDraft = false;

      _isSubmitting = false;
      notifyListeners();

      debugPrint('LoanApplicationViewModel: Application submitted successfully');
      return true;
    } catch (e) {
      _errorMessage = 'Failed to submit application. Please try again.';
      _isSubmitting = false;
      notifyListeners();
      debugPrint('LoanApplicationViewModel: Submit error - $e');
      return false;
    }
  }

  /// Saves current progress as draft.
  Future<void> saveDraft() async {
    await _saveDraft();
  }

  /// Loads saved draft.
  Future<void> loadDraft() async {
    final json = await _formDraftService.loadDraft(_draftKey);
    if (json != null) {
      _data = LoanApplicationData.fromJson(json);
      _hasDraft = true;
      notifyListeners();
      debugPrint('LoanApplicationViewModel: Draft loaded');
    }
  }

  /// Clears draft and resets form.
  Future<void> clearDraft() async {
    await _formDraftService.deleteDraft(_draftKey);
    _data = const LoanApplicationData();
    _currentStep = LoanApplicationStep.personalInfo;
    _hasDraft = false;
    notifyListeners();
    debugPrint('LoanApplicationViewModel: Draft cleared');
  }

  // ============================================================
  // PRIVATE METHODS
  // ============================================================

  /// Initializes the view model.
  Future<void> _initialize() async {
    // Check for existing draft
    final hasDraft = await _formDraftService.hasDraft(_draftKey);
    _hasDraft = hasDraft;
    notifyListeners();
  }

  /// Saves draft to storage.
  Future<void> _saveDraft() async {
    try {
      await _formDraftService.saveDraft(_draftKey, _data.toJson());
      _hasDraft = true;
      debugPrint('LoanApplicationViewModel: Draft saved');
    } catch (e) {
      debugPrint('LoanApplicationViewModel: Error saving draft - $e');
    }
  }
}
