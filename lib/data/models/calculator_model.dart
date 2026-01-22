/// MSME Pathways - Calculator Models
///
/// Data models for financial calculator features.
/// Pure Dart classes with no business logic.
library;

/// Type of financial calculation.
enum CalculationType {
  /// Loan payment calculation.
  loanPayment('Loan Payment', 'Calculate monthly payments'),
  
  /// Interest calculation.
  interest('Interest Calculator', 'Calculate total interest'),
  
  /// Loan amount calculation.
  loanAmount('Loan Amount', 'How much can I borrow?'),
  
  /// Amortization schedule.
  amortization('Amortization', 'Payment schedule breakdown');

  final String label;
  final String description;
  const CalculationType(this.label, this.description);
}

/// Input data for calculator.
class CalculationInput {
  const CalculationInput({
    required this.loanAmount,
    required this.interestRate,
    required this.termMonths,
    this.calculationType = CalculationType.loanPayment,
  });

  /// Loan principal amount.
  final double loanAmount;

  /// Annual interest rate (percentage).
  final double interestRate;

  /// Loan term in months.
  final int termMonths;

  /// Type of calculation to perform.
  final CalculationType calculationType;

  /// Monthly interest rate (decimal).
  double get monthlyInterestRate => interestRate / 100 / 12;

  /// Creates a copy with updated values.
  CalculationInput copyWith({
    double? loanAmount,
    double? interestRate,
    int? termMonths,
    CalculationType? calculationType,
  }) {
    return CalculationInput(
      loanAmount: loanAmount ?? this.loanAmount,
      interestRate: interestRate ?? this.interestRate,
      termMonths: termMonths ?? this.termMonths,
      calculationType: calculationType ?? this.calculationType,
    );
  }

  /// Validates input data.
  bool get isValid {
    return loanAmount > 0 && 
           interestRate > 0 && 
           interestRate <= 100 &&
           termMonths > 0 && 
           termMonths <= 360; // Max 30 years
  }

  /// Validation error message.
  String? get validationError {
    if (loanAmount <= 0) return 'Loan amount must be greater than 0';
    if (interestRate <= 0) return 'Interest rate must be greater than 0';
    if (interestRate > 100) return 'Interest rate cannot exceed 100%';
    if (termMonths <= 0) return 'Term must be greater than 0';
    if (termMonths > 360) return 'Term cannot exceed 30 years';
    return null;
  }
}

/// Result of financial calculation.
class CalculationResult {
  const CalculationResult({
    required this.monthlyPayment,
    required this.totalPayment,
    required this.totalInterest,
    required this.amortizationSchedule,
    required this.input,
  });

  /// Monthly payment amount.
  final double monthlyPayment;

  /// Total amount to be paid over loan term.
  final double totalPayment;

  /// Total interest to be paid.
  final double totalInterest;

  /// Amortization schedule entries.
  final List<AmortizationScheduleEntry> amortizationSchedule;

  /// Original input data.
  final CalculationInput input;

  /// Formatted monthly payment with currency.
  String get monthlyPaymentFormatted => _formatCurrency(monthlyPayment);

  /// Formatted total payment with currency.
  String get totalPaymentFormatted => _formatCurrency(totalPayment);

  /// Formatted total interest with currency.
  String get totalInterestFormatted => _formatCurrency(totalInterest);

  /// Formatted principal with currency.
  String get principalFormatted => _formatCurrency(input.loanAmount);

  /// Helper to format currency in Philippine Pesos.
  String _formatCurrency(double amount) {
    return '₱${amount.toStringAsFixed(2).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    )}';
  }

  /// Calculate from input.
  factory CalculationResult.fromInput(CalculationInput input) {
    if (!input.isValid) {
      throw ArgumentError('Invalid input data: ${input.validationError}');
    }

    // Calculate monthly payment using amortization formula
    final r = input.monthlyInterestRate;
    final n = input.termMonths;
    final p = input.loanAmount;

    final monthlyPayment = (p * r * Math.pow(1 + r, n)) / (Math.pow(1 + r, n) - 1);
    final totalPayment = monthlyPayment * n;
    final totalInterest = totalPayment - p;

    // Generate amortization schedule
    final schedule = _generateAmortizationSchedule(
      principal: p,
      monthlyPayment: monthlyPayment,
      monthlyRate: r,
      termMonths: n,
    );

    return CalculationResult(
      monthlyPayment: monthlyPayment,
      totalPayment: totalPayment,
      totalInterest: totalInterest,
      amortizationSchedule: schedule,
      input: input,
    );
  }

  /// Generate amortization schedule.
  static List<AmortizationScheduleEntry> _generateAmortizationSchedule({
    required double principal,
    required double monthlyPayment,
    required double monthlyRate,
    required int termMonths,
  }) {
    final schedule = <AmortizationScheduleEntry>[];
    double remainingBalance = principal;

    for (int month = 1; month <= termMonths; month++) {
      final interestPayment = remainingBalance * monthlyRate;
      final principalPayment = monthlyPayment - interestPayment;
      remainingBalance -= principalPayment;

      // Prevent negative balance due to floating point errors
      if (remainingBalance < 0.01) remainingBalance = 0;

      schedule.add(AmortizationScheduleEntry(
        month: month,
        payment: monthlyPayment,
        principalPayment: principalPayment,
        interestPayment: interestPayment,
        remainingBalance: remainingBalance,
      ));
    }

    return schedule;
  }
}

/// Single entry in an amortization schedule.
class AmortizationScheduleEntry {
  const AmortizationScheduleEntry({
    required this.month,
    required this.payment,
    required this.principalPayment,
    required this.interestPayment,
    required this.remainingBalance,
  });

  /// Month number (1-indexed).
  final int month;

  /// Total payment for this month.
  final double payment;

  /// Principal portion of payment.
  final double principalPayment;

  /// Interest portion of payment.
  final double interestPayment;

  /// Remaining balance after payment.
  final double remainingBalance;

  /// Formatted payment.
  String get paymentFormatted => _formatCurrency(payment);

  /// Formatted principal payment.
  String get principalPaymentFormatted => _formatCurrency(principalPayment);

  /// Formatted interest payment.
  String get interestPaymentFormatted => _formatCurrency(interestPayment);

  /// Formatted remaining balance.
  String get remainingBalanceFormatted => _formatCurrency(remainingBalance);

  /// Helper to format currency in Philippine Pesos.
  String _formatCurrency(double amount) {
    return '₱${amount.toStringAsFixed(2).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    )}';
  }
}

/// Utility class for math operations.
class Math {
  Math._();

  /// Power function.
  static double pow(double base, int exponent) {
    if (exponent == 0) return 1.0;
    if (exponent < 0) return 1.0 / pow(base, -exponent);
    
    double result = 1.0;
    for (int i = 0; i < exponent; i++) {
      result *= base;
    }
    return result;
  }
}
