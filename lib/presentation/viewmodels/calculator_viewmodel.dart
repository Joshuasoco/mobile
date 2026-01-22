/// MSME Pathways - Calculator ViewModel
///
/// Business logic and state management for the financial calculator.
/// Handles calculation logic, input validation, and result generation.
library;

import 'package:flutter/foundation.dart';

import '../../data/models/calculator_model.dart';

/// ViewModel for calculator screen.
///
/// Manages:
/// - Calculator input state
/// - Real-time calculation updates
/// - Input validation
/// - Amortization schedule generation
class CalculatorViewModel extends ChangeNotifier {
  /// Creates a CalculatorViewModel.
  CalculatorViewModel({
    double initialLoanAmount = 50000,
    double initialInterestRate = 12.0,
    int initialTermMonths = 12,
  })  : _loanAmount = initialLoanAmount,
        _interestRate = initialInterestRate,
        _termMonths = initialTermMonths {
    _calculateResults();
  }

  // ============================================================
  // STATE
  // ============================================================

  /// Loan amount.
  double _loanAmount;
  double get loanAmount => _loanAmount;

  /// Annual interest rate (percentage).
  double _interestRate;
  double get interestRate => _interestRate;

  /// Loan term in months.
  int _termMonths;
  int get termMonths => _termMonths;

  /// Calculation result.
  CalculationResult? _result;
  CalculationResult? get result => _result;

  /// Validation error message.
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Selected calculation type.
  CalculationType _calculationType = CalculationType.loanPayment;
  CalculationType get calculationType => _calculationType;

  // ============================================================
  // COMPUTED PROPERTIES
  // ============================================================

  /// Whether current input is valid.
  bool get isValid => currentInput.isValid;

  /// Current input data.
  CalculationInput get currentInput => CalculationInput(
        loanAmount: _loanAmount,
        interestRate: _interestRate,
        termMonths: _termMonths,
        calculationType: _calculationType,
      );

  /// Formatted loan amount for display.
  String get loanAmountFormatted => '₱${_loanAmount.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
      )}';

  /// Formatted interest rate for display.
  String get interestRateFormatted => '${_interestRate.toStringAsFixed(1)}%';

  /// Formatted term for display.
  String get termFormatted {
    if (_termMonths < 12) {
      return '$_termMonths ${_termMonths == 1 ? 'month' : 'months'}';
    }
    final years = _termMonths ~/ 12;
    final remainingMonths = _termMonths % 12;
    if (remainingMonths == 0) {
      return '$years ${years == 1 ? 'year' : 'years'}';
    }
    return '$years ${years == 1 ? 'year' : 'years'} $remainingMonths ${remainingMonths == 1 ? 'month' : 'months'}';
  }

  // ============================================================
  // ACTIONS
  // ============================================================

  /// Sets loan amount.
  void setLoanAmount(double amount) {
    if (_loanAmount != amount) {
      _loanAmount = amount;
      _calculateResults();
      notifyListeners();
    }
  }

  /// Sets interest rate.
  void setInterestRate(double rate) {
    if (_interestRate != rate) {
      _interestRate = rate;
      _calculateResults();
      notifyListeners();
    }
  }

  /// Sets loan term.
  void setTermMonths(int months) {
    if (_termMonths != months) {
      _termMonths = months;
      _calculateResults();
      notifyListeners();
    }
  }

  /// Sets calculation type.
  void setCalculationType(CalculationType type) {
    if (_calculationType != type) {
      _calculationType = type;
      _calculateResults();
      notifyListeners();
    }
  }

  /// Resets calculator to default values.
  void reset() {
    _loanAmount = 50000;
    _interestRate = 12.0;
    _termMonths = 12;
    _calculationType = CalculationType.loanPayment;
    _calculateResults();
    notifyListeners();
  }

  /// Preset for quick calculations.
  void applyPreset({
    required double loanAmount,
    required double interestRate,
    required int termMonths,
  }) {
    _loanAmount = loanAmount;
    _interestRate = interestRate;
    _termMonths = termMonths;
    _calculateResults();
    notifyListeners();
  }

  // ============================================================
  // PRIVATE METHODS
  // ============================================================

  /// Calculates results based on current input.
  void _calculateResults() {
    _errorMessage = null;

    if (!currentInput.isValid) {
      _errorMessage = currentInput.validationError;
      _result = null;
      return;
    }

    try {
      _result = CalculationResult.fromInput(currentInput);
    } catch (e) {
      _errorMessage = 'Calculation error: ${e.toString()}';
      _result = null;
      debugPrint('CalculatorViewModel: Calculation error - $e');
    }
  }

  // ============================================================
  // COMMON PRESETS
  // ============================================================

  /// Common loan presets for quick access.
  static const List<LoanPreset> presets = [
    LoanPreset(
      name: 'Small Loan',
      description: '₱10K for 6 months',
      loanAmount: 10000,
      interestRate: 12.0,
      termMonths: 6,
    ),
    LoanPreset(
      name: 'Medium Loan',
      description: '₱50K for 1 year',
      loanAmount: 50000,
      interestRate: 12.0,
      termMonths: 12,
    ),
    LoanPreset(
      name: 'Large Loan',
      description: '₱100K for 2 years',
      loanAmount: 100000,
      interestRate: 12.0,
      termMonths: 24,
    ),
  ];
}

/// Loan calculation preset.
class LoanPreset {
  const LoanPreset({
    required this.name,
    required this.description,
    required this.loanAmount,
    required this.interestRate,
    required this.termMonths,
  });

  final String name;
  final String description;
  final double loanAmount;
  final double interestRate;
  final int termMonths;
}
