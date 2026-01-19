// MSME Pathways - Eligibility Checker Models
// 
// Data models for the guest eligibility checker flow.
// Includes business types, scoring logic, and qualification results.


/// Business type options for eligibility checking.
enum BusinessType {
  sariSariStore('Sari-sari Store', 'sari_sari'),
  marketVendorFood('Market Vendor (Food)', 'vendor_food'),
  marketVendorNonFood('Market Vendor (Non-food)', 'vendor_non_food'),
  onlineSeller('Online Seller', 'online'),
  homeBasedBusiness('Home-based Business', 'home_based'),
  other('Iba pa / Other', 'other');

  const BusinessType(this.label, this.key);
  
  /// Display label in Tagalog/English
  final String label;
  
  /// Key for storage/API
  final String key;
}

/// Business age/longevity options.
enum BusinessAge {
  lessThan6Months('Less than 6 months', 0),
  sixMonthsTo1Year('6 months - 1 year', 10),
  oneToTwoYears('1-2 years', 20),
  twoToFiveYears('2-5 years', 30),
  fiveYearsPlus('5+ years', 40);

  const BusinessAge(this.label, this.score);
  
  /// Display label
  final String label;
  
  /// Score points for this option (max 40)
  final int score;
}

/// Loan amount range options.
enum LoanAmountRange {
  fiveToTenK('₱5,000 - ₱10,000', 5000, 10000),
  tenToTwentyFiveK('₱10,000 - ₱25,000', 10000, 25000),
  twentyFiveToFiftyK('₱25,000 - ₱50,000', 25000, 50000),
  fiftyKPlus('₱50,000+', 50000, 100000);

  const LoanAmountRange(this.label, this.min, this.max);
  
  /// Display label
  final String label;
  
  /// Minimum amount
  final int min;
  
  /// Maximum amount
  final int max;
}

/// Available documents for verification.
enum AvailableDocument {
  barangayBusinessPermit('Barangay Business Permit', 'barangay_permit'),
  validId('Valid ID (any government ID)', 'valid_id'),
  utilityBills('Utility bills (Meralco, water)', 'utility_bills'),
  businessReceipts('Business receipts/records', 'receipts'),
  bankAccount('Bank account', 'bank_account');

  const AvailableDocument(this.label, this.key);
  
  /// Display label
  final String label;
  
  /// Key for storage/API
  final String key;
  
  /// Points per document (6 points each, max 30)
  static const int pointsPerDocument = 6;
}

/// Confidence level for loan qualification.
enum QualificationConfidence {
  high('High', 'Mataas'),
  medium('Medium', 'Katamtaman'),
  low('Low', 'Mababa'),
  notQualified('Not Qualified', 'Hindi pa Qualified');

  const QualificationConfidence(this.labelEn, this.labelTl);
  
  /// English label
  final String labelEn;
  
  /// Tagalog label
  final String labelTl;
}

/// User's eligibility check answers.
class EligibilityAnswers {
  /// Creates eligibility answers.
  const EligibilityAnswers({
    this.businessType,
    this.businessAge,
    this.monthlyIncome = 0,
    this.loanAmountNeeded,
    this.availableDocuments = const [],
    this.otherBusinessType,
  });

  /// Selected business type
  final BusinessType? businessType;
  
  /// Custom business type if "other" selected
  final String? otherBusinessType;
  
  /// How long business has been operating
  final BusinessAge? businessAge;
  
  /// Monthly income in PHP
  final double monthlyIncome;
  
  /// Desired loan amount range
  final LoanAmountRange? loanAmountNeeded;
  
  /// Documents the user has available
  final List<AvailableDocument> availableDocuments;

  /// Creates a copy with updated values.
  EligibilityAnswers copyWith({
    BusinessType? businessType,
    String? otherBusinessType,
    BusinessAge? businessAge,
    double? monthlyIncome,
    LoanAmountRange? loanAmountNeeded,
    List<AvailableDocument>? availableDocuments,
  }) {
    return EligibilityAnswers(
      businessType: businessType ?? this.businessType,
      otherBusinessType: otherBusinessType ?? this.otherBusinessType,
      businessAge: businessAge ?? this.businessAge,
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
      loanAmountNeeded: loanAmountNeeded ?? this.loanAmountNeeded,
      availableDocuments: availableDocuments ?? this.availableDocuments,
    );
  }

  /// Checks if all required fields are filled.
  bool get isComplete =>
      businessType != null &&
      businessAge != null &&
      monthlyIncome > 0 &&
      loanAmountNeeded != null;

  /// Converts the model to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'businessType': businessType?.index,
      'otherBusinessType': otherBusinessType,
      'businessAge': businessAge?.index,
      'monthlyIncome': monthlyIncome,
      'loanAmountNeeded': loanAmountNeeded?.index,
      'availableDocuments': availableDocuments.map((e) => e.index).toList(),
    };
  }

  /// Creates a model from a JSON map.
  factory EligibilityAnswers.fromJson(Map<String, dynamic> json) {
    return EligibilityAnswers(
      businessType: json['businessType'] != null
          ? BusinessType.values[json['businessType'] as int]
          : null,
      otherBusinessType: json['otherBusinessType'] as String?,
      businessAge: json['businessAge'] != null
          ? BusinessAge.values[json['businessAge'] as int]
          : null,
      monthlyIncome: (json['monthlyIncome'] as num?)?.toDouble() ?? 0.0,
      loanAmountNeeded: json['loanAmountNeeded'] != null
          ? LoanAmountRange.values[json['loanAmountNeeded'] as int]
          : null,
      availableDocuments: (json['availableDocuments'] as List<dynamic>?)
              ?.map((e) => AvailableDocument.values[e as int])
              .toList() ??
          [],
    );
  }
}

/// Result of eligibility calculation.
class EligibilityResult {
  /// Creates an eligibility result.
  const EligibilityResult({
    required this.isQualified,
    required this.score,
    required this.maxLoanAmount,
    required this.confidence,
    required this.messageTl,
    required this.messageEn,
    required this.recommendations,
  });

  /// Whether user qualifies for any loan
  final bool isQualified;
  
  /// Total score (0-100)
  final int score;
  
  /// Maximum loan amount they may qualify for
  final int maxLoanAmount;
  
  /// Confidence level of qualification
  final QualificationConfidence confidence;
  
  /// Tagalog message for user
  final String messageTl;
  
  /// English message for user
  final String messageEn;
  
  /// List of recommendations to improve eligibility
  final List<String> recommendations;

  /// Formats max loan amount with peso sign.
  String get maxLoanFormatted => '₱${_formatNumber(maxLoanAmount)}';
  
  static String _formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(0)}K';
    }
    return number.toString();
  }
}

/// Calculator for eligibility scoring.
class EligibilityCalculator {
  /// Calculates eligibility based on user answers.
  static EligibilityResult calculate(EligibilityAnswers answers) {
    int score = 0;
    final recommendations = <String>[];
    
    // Business longevity (40 points max)
    if (answers.businessAge != null) {
      score += answers.businessAge!.score;
      
      if (answers.businessAge!.score < 20) {
        recommendations.add('Mas matagal ang negosyo, mas mataas ang chance');
      }
    }
    
    // Monthly income (30 points max)
    final income = answers.monthlyIncome;
    if (income >= 50000) {
      score += 30;
    } else if (income >= 20000) {
      score += 25;
    } else if (income >= 10000) {
      score += 20;
    } else if (income >= 5000) {
      score += 15;
    } else {
      score += 5;
      recommendations.add('Itaas ang benta para sa mas malaking loan');
    }
    
    // Documents available (30 points max, 6 per document)
    final docCount = answers.availableDocuments.length;
    score += docCount * AvailableDocument.pointsPerDocument;
    
    if (docCount < 3) {
      recommendations.add('Maghanda ng Valid ID at Business Permit');
    }
    if (!answers.availableDocuments.contains(AvailableDocument.validId)) {
      recommendations.add('Kumuha ng valid government ID');
    }
    if (!answers.availableDocuments.contains(AvailableDocument.bankAccount)) {
      recommendations.add('Magbukas ng bank account para mas mabilis ang release');
    }
    
    // Determine max loan amount
    int maxLoan;
    if (score >= 70) {
      maxLoan = 50000;
    } else if (score >= 50) {
      maxLoan = 25000;
    } else if (score >= 30) {
      maxLoan = 10000;
    } else {
      maxLoan = 5000;
    }
    
    // Determine confidence and qualification
    final QualificationConfidence confidence;
    final bool isQualified;
    final String messageTl;
    final String messageEn;
    
    if (score >= 70) {
      confidence = QualificationConfidence.high;
      isQualified = true;
      messageTl = 'Magandang balita! Mataas ang chance mo ma-approve!';
      messageEn = 'Excellent! You have a strong chance of approval.';
    } else if (score >= 50) {
      confidence = QualificationConfidence.medium;
      isQualified = true;
      messageTl = 'May pag-asa! Kumpletuhin lang ang profile mo.';
      messageEn = 'Good news! You may qualify. Complete your profile to proceed.';
    } else if (score >= 30) {
      confidence = QualificationConfidence.low;
      isQualified = true;
      messageTl = 'Pwede kang mag-apply para sa starter loan!';
      messageEn = 'You may qualify for a starter loan. Apply to find out!';
    } else {
      confidence = QualificationConfidence.notQualified;
      isQualified = false;
      messageTl = 'Hindi pa ngayon, pero may paraan para mag-qualify ka!';
      messageEn = 'Not yet qualified, but here\'s how to improve your chances.';
    }
    
    return EligibilityResult(
      isQualified: isQualified,
      score: score,
      maxLoanAmount: maxLoan,
      confidence: confidence,
      messageTl: messageTl,
      messageEn: messageEn,
      recommendations: recommendations,
    );
  }
}
