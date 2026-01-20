/// MSME Pathways - Pre-qualification Models
/// 
/// Data models for loan pre-qualification assessment.
library;

/// Risk level for qualification.
enum RiskLevel {
  /// Low risk - highly qualified
  low('Low Risk', 'Mataas ang tsansa ng approval'),
  /// Moderate risk
  moderate('Moderate', 'May tsansa ng approval'),
  /// High risk - needs improvement
  high('High Risk', 'Kailangan ng improvement');

  final String label;
  final String description;
  const RiskLevel(this.label, this.description);
}

/// Qualification criteria category.
enum CriteriaCategory {
  /// Business stability
  business('Business Stability', 'business'),
  /// Income & cash flow
  income('Income & Cash Flow', 'income'),
  /// Document readiness
  documents('Document Readiness', 'documents'),
  /// Digital footprint
  digital('Digital Footprint', 'digital');

  final String label;
  final String iconName;
  const CriteriaCategory(this.label, this.iconName);
}

/// Represents a qualification criterion.
class QualificationCriteria {
  /// Criterion name.
  final String name;

  /// Criterion description.
  final String description;

  /// Category.
  final CriteriaCategory category;

  /// Weight in overall score (0.0 to 1.0).
  final double weight;

  /// User's score for this criterion (0-100).
  final int score;

  /// Whether this criterion is met.
  final bool isMet;

  /// Improvement suggestion if not fully met.
  final String? improvementTip;

  /// Creates a qualification criteria.
  const QualificationCriteria({
    required this.name,
    required this.description,
    required this.category,
    required this.weight,
    required this.score,
    required this.isMet,
    this.improvementTip,
  });
}

/// Represents an improvement suggestion.
class ImprovementSuggestion {
  /// Suggestion title.
  final String title;

  /// Detailed description.
  final String description;

  /// Estimated score improvement.
  final int potentialScoreBoost;

  /// Difficulty level (1-3).
  final int difficulty;

  /// Action to take.
  final String actionLabel;

  /// Route to navigate for action.
  final String? actionRoute;

  /// Creates an improvement suggestion.
  const ImprovementSuggestion({
    required this.title,
    required this.description,
    required this.potentialScoreBoost,
    required this.difficulty,
    required this.actionLabel,
    this.actionRoute,
  });

  /// Difficulty label.
  String get difficultyLabel {
    switch (difficulty) {
      case 1:
        return 'Easy';
      case 2:
        return 'Medium';
      case 3:
        return 'Hard';
      default:
        return 'Unknown';
    }
  }
}

/// Represents a pre-qualification result.
class PrequalificationResult {
  /// Overall score (0-100).
  final int overallScore;

  /// Risk level.
  final RiskLevel riskLevel;

  /// Estimated eligible loan amount range.
  final double minEligibleAmount;
  final double maxEligibleAmount;

  /// Estimated interest rate range.
  final double minInterestRate;
  final double maxInterestRate;

  /// Criteria breakdown.
  final List<QualificationCriteria> criteria;

  /// Improvement suggestions.
  final List<ImprovementSuggestion> suggestions;

  /// Assessment date.
  final DateTime assessedAt;

  /// Creates a pre-qualification result.
  const PrequalificationResult({
    required this.overallScore,
    required this.riskLevel,
    required this.minEligibleAmount,
    required this.maxEligibleAmount,
    required this.minInterestRate,
    required this.maxInterestRate,
    required this.criteria,
    required this.suggestions,
    required this.assessedAt,
  });

  /// Formatted eligible amount range.
  String get amountRangeFormatted {
    final minK = (minEligibleAmount / 1000).toStringAsFixed(0);
    final maxK = (maxEligibleAmount / 1000).toStringAsFixed(0);
    return '₱${minK}K - ₱${maxK}K';
  }

  /// Formatted interest rate range.
  String get interestRateFormatted {
    return '${minInterestRate.toStringAsFixed(1)}% - ${maxInterestRate.toStringAsFixed(1)}%';
  }

  /// Criteria by category.
  Map<CriteriaCategory, List<QualificationCriteria>> get criteriaByCategory {
    final map = <CriteriaCategory, List<QualificationCriteria>>{};
    for (final criterion in criteria) {
      map.putIfAbsent(criterion.category, () => []);
      map[criterion.category]!.add(criterion);
    }
    return map;
  }

  /// Number of criteria met.
  int get criteriaMet => criteria.where((c) => c.isMet).length;

  /// Category score.
  int getCategoryScore(CriteriaCategory category) {
    final categoryCriteria = criteria.where((c) => c.category == category).toList();
    if (categoryCriteria.isEmpty) return 0;
    final total = categoryCriteria.fold<int>(0, (sum, c) => sum + c.score);
    return (total / categoryCriteria.length).round();
  }
}

/// Assessment questions for gathering pre-qualification data.
class AssessmentQuestion {
  /// Question ID.
  final String id;

  /// Question text.
  final String question;

  /// Category this affects.
  final CriteriaCategory category;

  /// Answer options.
  final List<AssessmentOption> options;

  /// Creates an assessment question.
  const AssessmentQuestion({
    required this.id,
    required this.question,
    required this.category,
    required this.options,
  });
}

/// Answer option for assessment.
class AssessmentOption {
  /// Option label.
  final String label;

  /// Description.
  final String? description;

  /// Score value (0-100).
  final int scoreValue;

  /// Creates an assessment option.
  const AssessmentOption({
    required this.label,
    this.description,
    required this.scoreValue,
  });
}

/// Mock assessment questions.
class AssessmentQuestions {
  AssessmentQuestions._();

  /// Get all assessment questions.
  static List<AssessmentQuestion> getAll() => [
    // Business stability questions
    const AssessmentQuestion(
      id: 'biz-age',
      question: 'Gaano na katagal ang iyong negosyo?',
      category: CriteriaCategory.business,
      options: [
        AssessmentOption(label: 'Less than 6 months', scoreValue: 20),
        AssessmentOption(label: '6 months - 1 year', scoreValue: 40),
        AssessmentOption(label: '1-2 years', scoreValue: 70),
        AssessmentOption(label: 'More than 2 years', scoreValue: 100),
      ],
    ),
    const AssessmentQuestion(
      id: 'biz-reg',
      question: 'Registered ba ang negosyo mo?',
      category: CriteriaCategory.business,
      options: [
        AssessmentOption(label: 'DTI Registered', scoreValue: 100),
        AssessmentOption(label: 'Barangay Permit Only', scoreValue: 60),
        AssessmentOption(label: 'Not Yet Registered', scoreValue: 30),
      ],
    ),
    // Income questions
    const AssessmentQuestion(
      id: 'income-freq',
      question: 'Gaano kadalas ang kita ng negosyo?',
      category: CriteriaCategory.income,
      options: [
        AssessmentOption(label: 'Daily', description: 'Araw-araw may benta', scoreValue: 100),
        AssessmentOption(label: 'Weekly', description: 'Lingguhan', scoreValue: 80),
        AssessmentOption(label: 'Monthly', description: 'Buwanan', scoreValue: 60),
        AssessmentOption(label: 'Seasonal', description: 'Depende sa season', scoreValue: 40),
      ],
    ),
    const AssessmentQuestion(
      id: 'income-avg',
      question: 'Ano ang average monthly income ng negosyo?',
      category: CriteriaCategory.income,
      options: [
        AssessmentOption(label: 'Below ₱10,000', scoreValue: 30),
        AssessmentOption(label: '₱10,000 - ₱30,000', scoreValue: 60),
        AssessmentOption(label: '₱30,000 - ₱50,000', scoreValue: 80),
        AssessmentOption(label: 'Above ₱50,000', scoreValue: 100),
      ],
    ),
    // Document readiness
    const AssessmentQuestion(
      id: 'docs-id',
      question: 'May valid government ID ka ba?',
      category: CriteriaCategory.documents,
      options: [
        AssessmentOption(label: 'Yes, multiple IDs', scoreValue: 100),
        AssessmentOption(label: 'Yes, one ID', scoreValue: 80),
        AssessmentOption(label: 'Expired ID', scoreValue: 40),
        AssessmentOption(label: 'No valid ID', scoreValue: 0),
      ],
    ),
    const AssessmentQuestion(
      id: 'docs-records',
      question: 'May records ba ng sales/income mo?',
      category: CriteriaCategory.documents,
      options: [
        AssessmentOption(label: 'Complete records (digital/notebook)', scoreValue: 100),
        AssessmentOption(label: 'Partial records', scoreValue: 60),
        AssessmentOption(label: 'Receipts only', scoreValue: 40),
        AssessmentOption(label: 'No records', scoreValue: 20),
      ],
    ),
    // Digital footprint
    const AssessmentQuestion(
      id: 'digital-wallet',
      question: 'Gumagamit ka ba ng GCash/Maya?',
      category: CriteriaCategory.digital,
      options: [
        AssessmentOption(label: 'Regular user (daily/weekly)', scoreValue: 100),
        AssessmentOption(label: 'Occasional use', scoreValue: 60),
        AssessmentOption(label: 'Rarely', scoreValue: 30),
        AssessmentOption(label: 'Never', scoreValue: 0),
      ],
    ),
    const AssessmentQuestion(
      id: 'digital-online',
      question: 'May online presence ba ang negosyo mo?',
      category: CriteriaCategory.digital,
      options: [
        AssessmentOption(label: 'Active FB page / Online store', scoreValue: 100),
        AssessmentOption(label: 'Personal account for business', scoreValue: 60),
        AssessmentOption(label: 'Word of mouth only', scoreValue: 30),
      ],
    ),
  ];
}
