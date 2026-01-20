/// MSME Pathways - Alternative Data Models
/// 
/// Data models for capturing non-traditional creditworthiness data.
library;

/// Business registration type.
enum RegistrationType {
  /// DTI registered
  dti('DTI Registered', 'May DTI registration'),
  /// Barangay permit only
  barangay('Barangay Permit Only', 'May barangay business permit'),
  /// Unregistered
  unregistered('Not Registered', 'Wala pang registration');

  final String label;
  final String description;
  const RegistrationType(this.label, this.description);
}

/// Business location type.
enum LocationType {
  /// Home-based
  homeBased('Home-based', 'Sa bahay ang negosyo', 'home'),
  /// Market stall
  marketStall('Market Stall', 'May pwesto sa palengke', 'storefront'),
  /// Commercial space
  commercial('Commercial Space', 'May rented o owned na space', 'store'),
  /// Mobile/roving
  mobile('Mobile/Roving', 'Nagro-roving o online', 'directions_walk');

  final String label;
  final String description;
  final String iconName;
  const LocationType(this.label, this.description, this.iconName);
}

/// Income pattern frequency.
enum IncomeFrequency {
  /// Daily income
  daily('Daily', 'Araw-araw may benta'),
  /// Weekly income
  weekly('Weekly', 'Linggo-linggo ang main income'),
  /// Monthly income
  monthly('Monthly', 'Buwan-buwan ang payment'),
  /// Seasonal/irregular
  seasonal('Seasonal', 'Depende sa season o occasion');

  final String label;
  final String description;
  const IncomeFrequency(this.label, this.description);
}

/// Digital payment usage level.
enum DigitalPaymentUsage {
  /// Heavy user
  heavy('Heavy User', 'Laging gamit GCash/Maya', 0.9),
  /// Moderate user
  moderate('Moderate', 'Minsan lang gamit', 0.6),
  /// Rare user
  rare('Occasionally', 'Bihira lang', 0.3),
  /// No usage
  none('Cash Only', 'Hindi gumagamit', 0.0);

  final String label;
  final String description;
  final double score;
  const DigitalPaymentUsage(this.label, this.description, this.score);
}

/// Represents a business profile with alternative data.
class BusinessProfile {
  /// Business name.
  final String businessName;

  /// Type of business (matches existing BusinessType enum).
  final String businessType;

  /// Registration status.
  final RegistrationType? registrationType;

  /// Location type.
  final LocationType? locationType;

  /// Province/City.
  final String? province;

  /// Barangay.
  final String? barangay;

  /// Years in operation.
  final int? yearsInOperation;

  /// Months in operation (for businesses < 1 year).
  final int? monthsInOperation;

  /// Number of employees.
  final int? employeeCount;

  /// Average customers per day.
  final int? dailyCustomers;

  /// Regular/repeat customers percentage.
  final double? repeatCustomerRate;

  /// Creates a business profile.
  const BusinessProfile({
    required this.businessName,
    required this.businessType,
    this.registrationType,
    this.locationType,
    this.province,
    this.barangay,
    this.yearsInOperation,
    this.monthsInOperation,
    this.employeeCount,
    this.dailyCustomers,
    this.repeatCustomerRate,
  });

  /// Creates a copy with updated fields.
  BusinessProfile copyWith({
    String? businessName,
    String? businessType,
    RegistrationType? registrationType,
    LocationType? locationType,
    String? province,
    String? barangay,
    int? yearsInOperation,
    int? monthsInOperation,
    int? employeeCount,
    int? dailyCustomers,
    double? repeatCustomerRate,
  }) {
    return BusinessProfile(
      businessName: businessName ?? this.businessName,
      businessType: businessType ?? this.businessType,
      registrationType: registrationType ?? this.registrationType,
      locationType: locationType ?? this.locationType,
      province: province ?? this.province,
      barangay: barangay ?? this.barangay,
      yearsInOperation: yearsInOperation ?? this.yearsInOperation,
      monthsInOperation: monthsInOperation ?? this.monthsInOperation,
      employeeCount: employeeCount ?? this.employeeCount,
      dailyCustomers: dailyCustomers ?? this.dailyCustomers,
      repeatCustomerRate: repeatCustomerRate ?? this.repeatCustomerRate,
    );
  }

  /// Creates an empty business profile.
  factory BusinessProfile.empty() {
    return const BusinessProfile(
      businessName: '',
      businessType: '',
    );
  }

  /// Business age in months.
  int get businessAgeMonths {
    return (yearsInOperation ?? 0) * 12 + (monthsInOperation ?? 0);
  }
}

/// Represents income patterns for alternative data scoring.
class IncomePattern {
  /// How often income is received.
  final IncomeFrequency? frequency;

  /// Average daily income (in PHP).
  final double? averageDailyIncome;

  /// Average monthly income (in PHP).
  final double? averageMonthlyIncome;

  /// Peak months (1-12).
  final List<int> peakMonths;

  /// Low months (1-12).
  final List<int> lowMonths;

  /// Monthly expenses estimate (in PHP).
  final double? monthlyExpenses;

  /// Digital payment usage.
  final DigitalPaymentUsage? digitalPaymentUsage;

  /// Has regular suppliers.
  final bool hasRegularSuppliers;

  /// Supplier names (for verification).
  final List<String> supplierNames;

  /// GCash/Maya transaction volume (estimated monthly).
  final double? digitalTransactionVolume;

  /// Creates income pattern.
  const IncomePattern({
    this.frequency,
    this.averageDailyIncome,
    this.averageMonthlyIncome,
    this.peakMonths = const [],
    this.lowMonths = const [],
    this.monthlyExpenses,
    this.digitalPaymentUsage,
    this.hasRegularSuppliers = false,
    this.supplierNames = const [],
    this.digitalTransactionVolume,
  });

  /// Creates a copy with updated fields.
  IncomePattern copyWith({
    IncomeFrequency? frequency,
    double? averageDailyIncome,
    double? averageMonthlyIncome,
    List<int>? peakMonths,
    List<int>? lowMonths,
    double? monthlyExpenses,
    DigitalPaymentUsage? digitalPaymentUsage,
    bool? hasRegularSuppliers,
    List<String>? supplierNames,
    double? digitalTransactionVolume,
  }) {
    return IncomePattern(
      frequency: frequency ?? this.frequency,
      averageDailyIncome: averageDailyIncome ?? this.averageDailyIncome,
      averageMonthlyIncome: averageMonthlyIncome ?? this.averageMonthlyIncome,
      peakMonths: peakMonths ?? this.peakMonths,
      lowMonths: lowMonths ?? this.lowMonths,
      monthlyExpenses: monthlyExpenses ?? this.monthlyExpenses,
      digitalPaymentUsage: digitalPaymentUsage ?? this.digitalPaymentUsage,
      hasRegularSuppliers: hasRegularSuppliers ?? this.hasRegularSuppliers,
      supplierNames: supplierNames ?? this.supplierNames,
      digitalTransactionVolume: digitalTransactionVolume ?? this.digitalTransactionVolume,
    );
  }

  /// Creates empty income pattern.
  factory IncomePattern.empty() {
    return const IncomePattern();
  }

  /// Net monthly income estimate.
  double get netMonthlyIncome {
    return (averageMonthlyIncome ?? 0) - (monthlyExpenses ?? 0);
  }
}

/// Alternative data score result.
class AlternativeDataScore {
  /// Overall score (0-100).
  final int overallScore;

  /// Business stability score.
  final int businessStabilityScore;

  /// Income consistency score.
  final int incomeConsistencyScore;

  /// Digital footprint score.
  final int digitalFootprintScore;

  /// Recommendations for improvement.
  final List<String> recommendations;

  /// Estimated loan eligibility range.
  final double minEligibleAmount;
  final double maxEligibleAmount;

  /// Creates an alternative data score.
  const AlternativeDataScore({
    required this.overallScore,
    required this.businessStabilityScore,
    required this.incomeConsistencyScore,
    required this.digitalFootprintScore,
    required this.recommendations,
    required this.minEligibleAmount,
    required this.maxEligibleAmount,
  });

  /// Score level description.
  String get scoreLevel {
    if (overallScore >= 80) return 'Excellent';
    if (overallScore >= 60) return 'Good';
    if (overallScore >= 40) return 'Fair';
    return 'Needs Improvement';
  }

  /// Format eligible amount range.
  String get eligibleRangeFormatted {
    final minK = (minEligibleAmount / 1000).toStringAsFixed(0);
    final maxK = (maxEligibleAmount / 1000).toStringAsFixed(0);
    return '₱${minK}K - ₱${maxK}K';
  }
}

/// Monthly names for display.
class MonthNames {
  MonthNames._();

  static const List<String> short = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  static const List<String> full = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];
}
