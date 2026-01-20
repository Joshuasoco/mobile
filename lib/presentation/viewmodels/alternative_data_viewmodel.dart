/// MSME Pathways - Alternative Data ViewModel
/// 
/// Business logic for alternative data input forms.
library;

import 'package:flutter/material.dart';

import '../../data/models/alternative_data_model.dart';

/// ViewModel for alternative data forms.
class AlternativeDataViewModel extends ChangeNotifier {
  /// Current form step (0-3 for business info, 0-2 for income pattern).
  int _currentStep = 0;

  /// Page controller for form steps.
  final PageController pageController = PageController();

  /// Business profile data.
  BusinessProfile _businessProfile = BusinessProfile.empty();

  /// Income pattern data.
  IncomePattern _incomePattern = IncomePattern.empty();

  /// Form keys for validation.
  final List<GlobalKey<FormState>> businessFormKeys = List.generate(
    4,
    (_) => GlobalKey<FormState>(),
  );
  final List<GlobalKey<FormState>> incomeFormKeys = List.generate(
    3,
    (_) => GlobalKey<FormState>(),
  );

  /// Text controllers for business info.
  final businessNameController = TextEditingController();
  final provinceController = TextEditingController();
  final barangayController = TextEditingController();
  final yearsController = TextEditingController();
  final monthsController = TextEditingController();
  final employeeController = TextEditingController();
  final dailyCustomersController = TextEditingController();

  /// Text controllers for income pattern.
  final dailyIncomeController = TextEditingController();
  final monthlyIncomeController = TextEditingController();
  final monthlyExpensesController = TextEditingController();
  final supplierController = TextEditingController();
  final digitalVolumeController = TextEditingController();

  /// Whether form is being submitted.
  bool _isSubmitting = false;

  /// Calculated score result.
  AlternativeDataScore? _scoreResult;

  // Getters
  int get currentStep => _currentStep;
  BusinessProfile get businessProfile => _businessProfile;
  IncomePattern get incomePattern => _incomePattern;
  bool get isSubmitting => _isSubmitting;
  AlternativeDataScore? get scoreResult => _scoreResult;

  /// Total steps for business info form.
  static const int businessInfoTotalSteps = 4;

  /// Total steps for income pattern form.
  static const int incomePatternTotalSteps = 3;

  /// Creates the viewmodel.
  AlternativeDataViewModel() {
    _initControllerListeners();
  }

  void _initControllerListeners() {
    businessNameController.addListener(_updateBusinessProfile);
    provinceController.addListener(_updateBusinessProfile);
    barangayController.addListener(_updateBusinessProfile);
  }

  void _updateBusinessProfile() {
    _businessProfile = _businessProfile.copyWith(
      businessName: businessNameController.text,
      province: provinceController.text,
      barangay: barangayController.text,
    );
  }

  /// Move to next step.
  bool nextStep(int totalSteps, List<GlobalKey<FormState>> formKeys) {
    // Validate current step
    final currentFormKey = formKeys[_currentStep];
    if (currentFormKey.currentState?.validate() != true) {
      return false;
    }
    currentFormKey.currentState?.save();

    if (_currentStep < totalSteps - 1) {
      _currentStep++;
      pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      notifyListeners();
    }
    return true;
  }

  /// Move to previous step.
  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      notifyListeners();
    }
  }

  /// Reset step counter.
  void resetSteps() {
    _currentStep = 0;
    pageController.jumpToPage(0);
    notifyListeners();
  }

  /// Whether on first step.
  bool get isFirstStep => _currentStep == 0;

  /// Whether on last step of business info.
  bool isLastBusinessStep() => _currentStep == businessInfoTotalSteps - 1;

  /// Whether on last step of income pattern.
  bool isLastIncomeStep() => _currentStep == incomePatternTotalSteps - 1;

  // Business Profile Updates

  /// Set business type.
  void setBusinessType(String type) {
    _businessProfile = _businessProfile.copyWith(businessType: type);
    notifyListeners();
  }

  /// Set registration type.
  void setRegistrationType(RegistrationType type) {
    _businessProfile = _businessProfile.copyWith(registrationType: type);
    notifyListeners();
  }

  /// Set location type.
  void setLocationType(LocationType type) {
    _businessProfile = _businessProfile.copyWith(locationType: type);
    notifyListeners();
  }

  /// Set years in operation.
  void setYearsInOperation(int years) {
    _businessProfile = _businessProfile.copyWith(yearsInOperation: years);
    notifyListeners();
  }

  /// Set months in operation.
  void setMonthsInOperation(int months) {
    _businessProfile = _businessProfile.copyWith(monthsInOperation: months);
    notifyListeners();
  }

  /// Set employee count.
  void setEmployeeCount(int count) {
    _businessProfile = _businessProfile.copyWith(employeeCount: count);
    notifyListeners();
  }

  /// Set daily customers.
  void setDailyCustomers(int count) {
    _businessProfile = _businessProfile.copyWith(dailyCustomers: count);
    notifyListeners();
  }

  /// Set repeat customer rate.
  void setRepeatCustomerRate(double rate) {
    _businessProfile = _businessProfile.copyWith(repeatCustomerRate: rate);
    notifyListeners();
  }

  // Income Pattern Updates

  /// Set income frequency.
  void setIncomeFrequency(IncomeFrequency frequency) {
    _incomePattern = _incomePattern.copyWith(frequency: frequency);
    notifyListeners();
  }

  /// Set average daily income.
  void setAverageDailyIncome(double amount) {
    _incomePattern = _incomePattern.copyWith(averageDailyIncome: amount);
    notifyListeners();
  }

  /// Set average monthly income.
  void setAverageMonthlyIncome(double amount) {
    _incomePattern = _incomePattern.copyWith(averageMonthlyIncome: amount);
    notifyListeners();
  }

  /// Set monthly expenses.
  void setMonthlyExpenses(double amount) {
    _incomePattern = _incomePattern.copyWith(monthlyExpenses: amount);
    notifyListeners();
  }

  /// Toggle peak month.
  void togglePeakMonth(int month) {
    final current = List<int>.from(_incomePattern.peakMonths);
    if (current.contains(month)) {
      current.remove(month);
    } else {
      current.add(month);
      // Remove from low months if present
      final lowMonths = List<int>.from(_incomePattern.lowMonths);
      lowMonths.remove(month);
      _incomePattern = _incomePattern.copyWith(lowMonths: lowMonths);
    }
    _incomePattern = _incomePattern.copyWith(peakMonths: current);
    notifyListeners();
  }

  /// Toggle low month.
  void toggleLowMonth(int month) {
    final current = List<int>.from(_incomePattern.lowMonths);
    if (current.contains(month)) {
      current.remove(month);
    } else {
      current.add(month);
      // Remove from peak months if present
      final peakMonths = List<int>.from(_incomePattern.peakMonths);
      peakMonths.remove(month);
      _incomePattern = _incomePattern.copyWith(peakMonths: peakMonths);
    }
    _incomePattern = _incomePattern.copyWith(lowMonths: current);
    notifyListeners();
  }

  /// Set digital payment usage.
  void setDigitalPaymentUsage(DigitalPaymentUsage usage) {
    _incomePattern = _incomePattern.copyWith(digitalPaymentUsage: usage);
    notifyListeners();
  }

  /// Set has regular suppliers.
  void setHasRegularSuppliers(bool value) {
    _incomePattern = _incomePattern.copyWith(hasRegularSuppliers: value);
    notifyListeners();
  }

  /// Add supplier name.
  void addSupplier(String name) {
    if (name.isEmpty) return;
    final suppliers = List<String>.from(_incomePattern.supplierNames)..add(name);
    _incomePattern = _incomePattern.copyWith(supplierNames: suppliers);
    notifyListeners();
  }

  /// Remove supplier name.
  void removeSupplier(String name) {
    final suppliers = List<String>.from(_incomePattern.supplierNames)..remove(name);
    _incomePattern = _incomePattern.copyWith(supplierNames: suppliers);
    notifyListeners();
  }

  /// Set digital transaction volume.
  void setDigitalTransactionVolume(double amount) {
    _incomePattern = _incomePattern.copyWith(digitalTransactionVolume: amount);
    notifyListeners();
  }

  /// Submit business profile.
  Future<bool> submitBusinessProfile() async {
    _isSubmitting = true;
    notifyListeners();

    // TODO: Backend - Submit business profile to API
    // Example:
    // await apiService.submitBusinessProfile(_businessProfile);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    _isSubmitting = false;
    notifyListeners();
    return true;
  }

  /// Submit income pattern and calculate score.
  Future<AlternativeDataScore?> submitIncomePattern() async {
    _isSubmitting = true;
    notifyListeners();

    // TODO: Backend - Submit income pattern and get score from API
    // Example:
    // _scoreResult = await apiService.calculateAlternativeScore(
    //   businessProfile: _businessProfile,
    //   incomePattern: _incomePattern,
    // );

    // Simulate API call and calculate mock score
    await Future.delayed(const Duration(seconds: 1));
    _scoreResult = _calculateMockScore();

    _isSubmitting = false;
    notifyListeners();
    return _scoreResult;
  }

  /// Calculate a mock alternative data score.
  AlternativeDataScore _calculateMockScore() {
    // Simple mock scoring algorithm
    int businessScore = 50;
    int incomeScore = 50;
    int digitalScore = 50;

    // Business factors
    if (_businessProfile.registrationType == RegistrationType.dti) {
      businessScore += 20;
    } else if (_businessProfile.registrationType == RegistrationType.barangay) {
      businessScore += 10;
    }

    if (_businessProfile.businessAgeMonths >= 24) {
      businessScore += 15;
    } else if (_businessProfile.businessAgeMonths >= 12) {
      businessScore += 10;
    }

    if ((_businessProfile.repeatCustomerRate ?? 0) > 0.5) {
      businessScore += 10;
    }

    // Income factors
    if ((_incomePattern.averageMonthlyIncome ?? 0) > 30000) {
      incomeScore += 20;
    } else if ((_incomePattern.averageMonthlyIncome ?? 0) > 15000) {
      incomeScore += 10;
    }

    if (_incomePattern.netMonthlyIncome > 10000) {
      incomeScore += 15;
    }

    // Digital factors
    if (_incomePattern.digitalPaymentUsage != null) {
      digitalScore += (_incomePattern.digitalPaymentUsage!.score * 30).round();
    }

    if ((_incomePattern.digitalTransactionVolume ?? 0) > 20000) {
      digitalScore += 15;
    }

    final overall = ((businessScore + incomeScore + digitalScore) / 3).round().clamp(0, 100);

    // Calculate eligible amounts
    final minAmount = (overall * 500).toDouble();
    final maxAmount = (overall * 2000).toDouble();

    // Generate recommendations
    final recommendations = <String>[];
    if (_businessProfile.registrationType != RegistrationType.dti) {
      recommendations.add('Kumuha ng DTI registration para mas mataas na eligibility');
    }
    if ((_incomePattern.digitalPaymentUsage?.score ?? 0) < 0.5) {
      recommendations.add('Gamitin ang GCash/Maya para sa transactions - mas madaling ma-verify ang income');
    }
    if (_incomePattern.peakMonths.isEmpty) {
      recommendations.add('I-identify ang peak months ng negosyo para sa better cash flow planning');
    }
    if (!_incomePattern.hasRegularSuppliers) {
      recommendations.add('Mag-maintain ng regular suppliers para sa consistent business history');
    }

    return AlternativeDataScore(
      overallScore: overall,
      businessStabilityScore: businessScore.clamp(0, 100),
      incomeConsistencyScore: incomeScore.clamp(0, 100),
      digitalFootprintScore: digitalScore.clamp(0, 100),
      recommendations: recommendations,
      minEligibleAmount: minAmount,
      maxEligibleAmount: maxAmount,
    );
  }

  /// Clear all data.
  void reset() {
    _currentStep = 0;
    _businessProfile = BusinessProfile.empty();
    _incomePattern = IncomePattern.empty();
    _scoreResult = null;
    
    businessNameController.clear();
    provinceController.clear();
    barangayController.clear();
    yearsController.clear();
    monthsController.clear();
    employeeController.clear();
    dailyCustomersController.clear();
    dailyIncomeController.clear();
    monthlyIncomeController.clear();
    monthlyExpensesController.clear();
    supplierController.clear();
    digitalVolumeController.clear();
    
    pageController.jumpToPage(0);
    notifyListeners();
  }

  @override
  void dispose() {
    pageController.dispose();
    businessNameController.dispose();
    provinceController.dispose();
    barangayController.dispose();
    yearsController.dispose();
    monthsController.dispose();
    employeeController.dispose();
    dailyCustomersController.dispose();
    dailyIncomeController.dispose();
    monthlyIncomeController.dispose();
    monthlyExpensesController.dispose();
    supplierController.dispose();
    digitalVolumeController.dispose();
    super.dispose();
  }
}
