/// MSME Pathways - Loan Application Models
///
/// Data models for loan application feature.
/// Pure Dart classes with no business logic.
library;

/// Loan application step.
enum LoanApplicationStep {
  /// Personal information.
  personalInfo(0, 'Personal Info', 'Basic details'),
  
  /// Loan details.
  loanDetails(1, 'Loan Details', 'Amount & purpose'),
  
  /// Business information.
  businessInfo(2, 'Business Info', 'Your business'),
  
  /// Documents.
  documents(3, 'Documents', 'Upload requirements');

  final int stepIndex;
  final String title;
  final String subtitle;
  const LoanApplicationStep(this.stepIndex, this.title, this.subtitle);
}

/// Loan application status.
enum LoanApplicationStatus {
  /// Draft - not submitted.
  draft('Draft', 'Not submitted yet'),
  
  /// Submitted - under review.
  submitted('Submitted', 'Under review'),
  
  /// Approved.
  approved('Approved', 'Loan approved'),
  
  /// Rejected.
  rejected('Rejected', 'Application rejected'),
  
  /// Cancelled.
  cancelled('Cancelled', 'Cancelled by user');

  final String label;
  final String description;
  const LoanApplicationStatus(this.label, this.description);
}

/// Loan purpose options.
enum LoanPurpose {
  workingCapital('Working Capital', 'Daily operations'),
  inventory('Inventory Purchase', 'Stock supplies'),
  equipment('Equipment Purchase', 'Tools & machines'),
  expansion('Business Expansion', 'Grow your business'),
  emergency('Emergency Needs', 'Urgent requirements'),
  other('Other', 'Specify below');

  final String label;
  final String description;
  const LoanPurpose(this.label, this.description);
}

/// Loan application data.
class LoanApplicationData {
  const LoanApplicationData({
    this.fullName = '',
    this.email = '',
    this.phone = '',
    this.address = '',
    this.loanAmount = 50000,
    this.loanPurpose,
    this.loanPurposeOther = '',
    this.businessName = '',
    this.businessType = '',
    this.businessAge = '',
    this.monthlyIncome = 0,
    this.hasValidId = false,
    this.hasSalesRecords = false,
    this.status = LoanApplicationStatus.draft,
    this.submittedAt,
  });

  // Personal Info
  final String fullName;
  final String email;
  final String phone;
  final String address;

  // Loan Details
  final double loanAmount;
  final LoanPurpose? loanPurpose;
  final String loanPurposeOther;

  // Business Info
  final String businessName;
  final String businessType;
  final String businessAge;
  final double monthlyIncome;

  // Documents
  final bool hasValidId;
  final bool hasSalesRecords;

  // Status
  final LoanApplicationStatus status;
  final DateTime? submittedAt;

  /// Creates a copy with updated values.
  LoanApplicationData copyWith({
    String? fullName,
    String? email,
    String? phone,
    String? address,
    double? loanAmount,
    LoanPurpose? loanPurpose,
    String? loanPurposeOther,
    String? businessName,
    String? businessType,
    String? businessAge,
    double? monthlyIncome,
    bool? hasValidId,
    bool? hasSalesRecords,
    LoanApplicationStatus? status,
    DateTime? submittedAt,
  }) {
    return LoanApplicationData(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      loanAmount: loanAmount ?? this.loanAmount,
      loanPurpose: loanPurpose ?? this.loanPurpose,
      loanPurposeOther: loanPurposeOther ?? this.loanPurposeOther,
      businessName: businessName ?? this.businessName,
      businessType: businessType ?? this.businessType,
      businessAge: businessAge ?? this.businessAge,
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
      hasValidId: hasValidId ?? this.hasValidId,
      hasSalesRecords: hasSalesRecords ?? this.hasSalesRecords,
      status: status ?? this.status,
      submittedAt: submittedAt ?? this.submittedAt,
    );
  }

  /// Validates step data.
  bool isStepValid(LoanApplicationStep step) {
    switch (step) {
      case LoanApplicationStep.personalInfo:
        return fullName.trim().isNotEmpty &&
               email.trim().isNotEmpty &&
               _isValidEmail(email) &&
               phone.trim().isNotEmpty &&
               address.trim().isNotEmpty;

      case LoanApplicationStep.loanDetails:
        return loanAmount > 0 &&
               loanPurpose != null &&
               (loanPurpose != LoanPurpose.other || loanPurposeOther.trim().isNotEmpty);

      case LoanApplicationStep.businessInfo:
        return businessName.trim().isNotEmpty &&
               businessType.trim().isNotEmpty &&
               businessAge.trim().isNotEmpty &&
               monthlyIncome > 0;

      case LoanApplicationStep.documents:
        return hasValidId; // At minimum need valid ID
    }
  }

  /// Validates email format.
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  /// Gets validation error for step.
  String? getStepError(LoanApplicationStep step) {
    if (isStepValid(step)) return null;

    switch (step) {
      case LoanApplicationStep.personalInfo:
        if (fullName.trim().isEmpty) return 'Full name is required';
        if (email.trim().isEmpty) return 'Email is required';
        if (!_isValidEmail(email)) return 'Invalid email format';
        if (phone.trim().isEmpty) return 'Phone number is required';
        if (address.trim().isEmpty) return 'Address is required';
        break;

      case LoanApplicationStep.loanDetails:
        if (loanAmount <= 0) return 'Loan amount must be greater than 0';
        if (loanPurpose == null) return 'Please select loan purpose';
        if (loanPurpose == LoanPurpose.other && loanPurposeOther.trim().isEmpty) {
          return 'Please specify loan purpose';
        }
        break;

      case LoanApplicationStep.businessInfo:
        if (businessName.trim().isEmpty) return 'Business name is required';
        if (businessType.trim().isEmpty) return 'Business type is required';
        if (businessAge.trim().isEmpty) return 'Business age is required';
        if (monthlyIncome <= 0) return 'Monthly income is required';
        break;

      case LoanApplicationStep.documents:
        if (!hasValidId) return 'Valid ID is required';
        break;
    }

    return 'Please complete all required fields';
  }

  /// Checks if all steps are valid.
  bool get isComplete {
    return LoanApplicationStep.values.every((step) => isStepValid(step));
  }

  /// Converts to JSON for storage.
  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'address': address,
      'loanAmount': loanAmount,
      'loanPurpose': loanPurpose?.name,
      'loanPurposeOther': loanPurposeOther,
      'businessName': businessName,
      'businessType': businessType,
      'businessAge': businessAge,
      'monthlyIncome': monthlyIncome,
      'hasValidId': hasValidId,
      'hasSalesRecords': hasSalesRecords,
      'status': status.name,
      'submittedAt': submittedAt?.toIso8601String(),
    };
  }

  /// Creates from JSON.
  factory LoanApplicationData.fromJson(Map<String, dynamic> json) {
    return LoanApplicationData(
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      address: json['address'] as String? ?? '',
      loanAmount: (json['loanAmount'] as num?)?.toDouble() ?? 50000,
      loanPurpose: json['loanPurpose'] != null
          ? LoanPurpose.values.firstWhere(
              (e) => e.name == json['loanPurpose'],
              orElse: () => LoanPurpose.workingCapital,
            )
          : null,
      loanPurposeOther: json['loanPurposeOther'] as String? ?? '',
      businessName: json['businessName'] as String? ?? '',
      businessType: json['businessType'] as String? ?? '',
      businessAge: json['businessAge'] as String? ?? '',
      monthlyIncome: (json['monthlyIncome'] as num?)?.toDouble() ?? 0,
      hasValidId: json['hasValidId'] as bool? ?? false,
      hasSalesRecords: json['hasSalesRecords'] as bool? ?? false,
      status: json['status'] != null
          ? LoanApplicationStatus.values.firstWhere(
              (e) => e.name == json['status'],
              orElse: () => LoanApplicationStatus.draft,
            )
          : LoanApplicationStatus.draft,
      submittedAt: json['submittedAt'] != null
          ? DateTime.parse(json['submittedAt'] as String)
          : null,
    );
  }
}
