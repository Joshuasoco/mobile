// MSME Pathways - Learn to Qualify ViewModel
//
// Manages state and business logic for the Learn to Qualify screen.
// Provides educational content to help users improve their eligibility score.

import 'package:flutter/material.dart';

import '../../data/models/eligibility_model.dart';

/// Data class for quick win items.
class QuickWinItem {
  /// Creates a quick win item.
  const QuickWinItem({
    required this.icon,
    required this.title,
    required this.points,
    required this.description,
    required this.color,
  });

  /// Icon to display.
  final IconData icon;

  /// Title of the quick win.
  final String title;

  /// Points gained from this action.
  final String points;

  /// Description of how to achieve this.
  final String description;

  /// Accent color for this item.
  final Color color;
}

/// Data class for step guide items.
class StepGuideItem {
  /// Creates a step guide item.
  const StepGuideItem({
    required this.number,
    required this.title,
    required this.description,
    required this.tip,
    required this.scoreImpact,
  });

  /// Step number (1, 2, 3...).
  final String number;

  /// Step title.
  final String title;

  /// Detailed description.
  final String description;

  /// Helpful tip for this step.
  final String tip;

  /// Score impact text.
  final String scoreImpact;
}

/// Data class for document checklist items.
class DocumentItem {
  /// Creates a document item.
  const DocumentItem({
    required this.name,
    required this.description,
    required this.isPriority,
  });

  /// Document name.
  final String name;

  /// Brief description or examples.
  final String description;

  /// Whether this is a priority document.
  final bool isPriority;
}

/// Data class for FAQ items.
class FaqItem {
  /// Creates a FAQ item.
  const FaqItem({
    required this.question,
    required this.answer,
  });

  /// The question.
  final String question;

  /// The answer.
  final String answer;
}

/// ViewModel for the Learn to Qualify screen.
///
/// Manages:
/// - User's current score and progress
/// - Educational content (quick wins, steps, documents, FAQs)
/// - FAQ expansion states
/// - Navigation actions
class LearnToQualifyViewModel extends ChangeNotifier {
  /// Creates the Learn to Qualify ViewModel.
  LearnToQualifyViewModel({
    int? initialScore,
    EligibilityAnswers? answers,
  })  : _currentScore = initialScore,
        _answers = answers {
    _initializeFaqStates();
  }

  // ============================================================
  // SCORE & PROGRESS
  // ============================================================

  final int? _currentScore;
  final EligibilityAnswers? _answers;

  /// User's current eligibility score (0-100).
  int? get currentScore => _currentScore;

  /// User's eligibility answers for personalized recommendations.
  EligibilityAnswers? get answers => _answers;

  /// Whether we have a score to display.
  bool get hasScore => _currentScore != null;

  /// Minimum score required to qualify.
  static const int minimumQualifyingScore = 30;

  /// Points needed to reach minimum qualification.
  int get pointsNeededToQualify {
    if (_currentScore == null) return minimumQualifyingScore;
    final needed = minimumQualifyingScore - _currentScore;
    return needed > 0 ? needed : 0;
  }

  /// Whether user is already qualified.
  bool get isAlreadyQualified => (_currentScore ?? 0) >= minimumQualifyingScore;

  /// Progress value for score display (0.0 - 1.0).
  double get scoreProgress => (_currentScore ?? 0) / 100;

  // ============================================================
  // QUICK WINS CONTENT
  // ============================================================

  /// List of quick win items that give instant points.
  List<QuickWinItem> get quickWins => const [
        QuickWinItem(
          icon: Icons.badge_outlined,
          title: 'Get a Valid ID',
          points: '+6 points',
          description: 'Kahit anong government ID - UMID, PhilHealth, Postal ID',
          color: Color(0xFF10B981),
        ),
        QuickWinItem(
          icon: Icons.account_balance_outlined,
          title: 'Open a Bank Account',
          points: '+6 points',
          description: 'Mas mabilis ang release kung may bank account ka',
          color: Color(0xFF3B82F6),
        ),
        QuickWinItem(
          icon: Icons.store_outlined,
          title: 'Get Barangay Permit',
          points: '+6 points',
          description: 'Pumunta sa Barangay Hall, ₱200-500 lang',
          color: Color(0xFF8B5CF6),
        ),
      ];

  // ============================================================
  // STEP-BY-STEP GUIDE CONTENT
  // ============================================================

  /// List of step guide items for improving eligibility.
  List<StepGuideItem> get stepGuides => const [
        StepGuideItem(
          number: '1',
          title: 'Magpatakbo ng negosyo ng mas matagal',
          description:
              'Mas matagal ang business mo, mas mataas ang trust ng lenders. Kung bagong negosyo, patuloy lang at mag-apply ulit after 6 months.',
          tip: '💡 Tip: Even 6 months of operation adds +10 points!',
          scoreImpact: 'Up to +40 points',
        ),
        StepGuideItem(
          number: '2',
          title: 'Itaas ang monthly income',
          description:
              'Record mo ang lahat ng benta. Kahit hindi masyadong malaki, ang consistent na income ay malaking factor.',
          tip: '💡 Tip: ₱5,000/month = +15 pts, ₱20,000/month = +25 pts',
          scoreImpact: 'Up to +30 points',
        ),
        StepGuideItem(
          number: '3',
          title: 'Kumpletuhin ang documents',
          description:
              'Mas maraming valid documents, mas mataas ang score mo. Focus ka muna sa pinakamadaling makuha.',
          tip: '💡 Tip: Each document adds +6 points to your score',
          scoreImpact: 'Up to +30 points',
        ),
      ];

  // ============================================================
  // DOCUMENTS CHECKLIST CONTENT
  // ============================================================

  /// List of required documents with priority indicators.
  List<DocumentItem> get documents => const [
        DocumentItem(
          name: 'Valid Government ID',
          description: 'UMID, PhilHealth, Postal, Driver\'s License',
          isPriority: true,
        ),
        DocumentItem(
          name: 'Barangay Business Permit',
          description: 'Available sa Barangay Hall',
          isPriority: true,
        ),
        DocumentItem(
          name: 'Utility Bills',
          description: 'Meralco, Water bill sa pangalan mo',
          isPriority: false,
        ),
        DocumentItem(
          name: 'Business Records/Receipts',
          description: 'Listahan ng benta, resibo',
          isPriority: false,
        ),
        DocumentItem(
          name: 'Bank Account',
          description: 'Savings o checking account',
          isPriority: false,
        ),
      ];

  /// Priority documents that users should get first.
  List<DocumentItem> get priorityDocuments =>
      documents.where((d) => d.isPriority).toList();

  /// Points per document.
  static const int pointsPerDocument = 6;

  // ============================================================
  // FAQ CONTENT & STATE
  // ============================================================

  /// List of frequently asked questions.
  List<FaqItem> get faqs => const [
        FaqItem(
          question: 'Gaano katagal bago ako mag-qualify?',
          answer:
              'Depende sa sitwasyon mo. Kung meron ka nang Valid ID at Business Permit, pwede ka na agad! Kung wala pa, usually 1-2 weeks para makumpleto ang documents.',
        ),
        FaqItem(
          question: 'Ano ang pinakamabilis na paraan para mag-qualify?',
          answer:
              'Kumuha ka ng Valid ID at Barangay Business Permit. Instant +12 points yan. Kung may bank account ka pa, +18 points agad!',
        ),
        FaqItem(
          question: 'Magkano ba ang maximum loan na pwede ko makuha?',
          answer:
              'Score 30-49: Up to ₱10K\nScore 50-69: Up to ₱25K\nScore 70+: Up to ₱50K\n\nMas mataas ang score, mas malaki ang loan!',
        ),
      ];

  /// Expansion state for each FAQ item.
  late final List<bool> _faqExpansionStates;

  /// Initialize FAQ expansion states.
  void _initializeFaqStates() {
    _faqExpansionStates = List.filled(faqs.length, false);
  }

  /// Whether a specific FAQ is expanded.
  bool isFaqExpanded(int index) {
    if (index < 0 || index >= _faqExpansionStates.length) return false;
    return _faqExpansionStates[index];
  }

  /// Toggle FAQ expansion state.
  void toggleFaq(int index) {
    if (index < 0 || index >= _faqExpansionStates.length) return;
    _faqExpansionStates[index] = !_faqExpansionStates[index];
    notifyListeners();
  }

  // ============================================================
  // PERSONALIZED RECOMMENDATIONS
  // ============================================================

  /// Get personalized recommendations based on user's answers.
  List<String> get personalizedTips {
    final tips = <String>[];
    final answers = _answers;

    if (answers == null) return tips;

    // Check business age
    if (answers.businessAge == BusinessAge.lessThan6Months) {
      tips.add('Focus on building your business for at least 6 months');
    }

    // Check documents
    if (!answers.availableDocuments.contains(AvailableDocument.validId)) {
      tips.add('Get a valid government ID - this is essential');
    }
    if (!answers.availableDocuments
        .contains(AvailableDocument.barangayBusinessPermit)) {
      tips.add('Register for a Barangay Business Permit');
    }
    if (!answers.availableDocuments.contains(AvailableDocument.bankAccount)) {
      tips.add('Open a bank account for faster loan disbursement');
    }

    // Check income
    if (answers.monthlyIncome < 5000) {
      tips.add('Work on increasing your monthly sales above ₱5,000');
    }

    return tips;
  }

  /// Whether we have personalized tips to show.
  bool get hasPersonalizedTips => personalizedTips.isNotEmpty;

  // ============================================================
  // LOAN AMOUNT TIERS
  // ============================================================

  /// Get loan tier based on score.
  String getLoanTierForScore(int score) {
    if (score >= 70) return '₱50K';
    if (score >= 50) return '₱25K';
    if (score >= 30) return '₱10K';
    return '₱5K';
  }

  /// Get next loan tier and points needed.
  ({String tier, int pointsNeeded})? get nextLoanTier {
    final score = _currentScore ?? 0;
    if (score >= 70) return null; // Already at max tier
    if (score >= 50) return (tier: '₱50K', pointsNeeded: 70 - score);
    if (score >= 30) return (tier: '₱25K', pointsNeeded: 50 - score);
    return (tier: '₱10K', pointsNeeded: 30 - score);
  }

}
