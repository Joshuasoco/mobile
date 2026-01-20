/// MSME Pathways - Pre-qualification ViewModel
/// 
/// Business logic for loan pre-qualification assessment.
library;

import 'package:flutter/material.dart';

import '../../data/models/prequalification_model.dart';

/// ViewModel for pre-qualification assessment.
class PrequalificationViewModel extends ChangeNotifier {
  /// All assessment questions.
  final List<AssessmentQuestion> _questions = AssessmentQuestions.getAll();

  /// Current question index.
  int _currentIndex = 0;

  /// User's answers (question id -> score).
  final Map<String, int> _answers = {};

  /// Whether assessment is complete.
  bool _isComplete = false;

  /// Whether calculating result.
  bool _isCalculating = false;

  /// Result after assessment.
  PrequalificationResult? _result;

  /// Page controller.
  final PageController pageController = PageController();

  // Getters
  List<AssessmentQuestion> get questions => _questions;
  int get currentIndex => _currentIndex;
  int get totalQuestions => _questions.length;
  bool get isComplete => _isComplete;
  bool get isCalculating => _isCalculating;
  PrequalificationResult? get result => _result;

  /// Current question.
  AssessmentQuestion get currentQuestion => _questions[_currentIndex];

  /// Progress (0.0 to 1.0).
  double get progress => (_currentIndex + 1) / _questions.length;

  /// Whether on first question.
  bool get isFirst => _currentIndex == 0;

  /// Whether on last question.
  bool get isLast => _currentIndex == _questions.length - 1;

  /// Whether current question is answered.
  bool get isCurrentAnswered => _answers.containsKey(currentQuestion.id);

  /// Get selected score for current question.
  int? get currentAnswer => _answers[currentQuestion.id];

  /// Select an answer for current question.
  void selectAnswer(int scoreValue) {
    _answers[currentQuestion.id] = scoreValue;
    notifyListeners();
  }

  /// Move to next question.
  void nextQuestion() {
    if (!isCurrentAnswered) return;

    if (isLast) {
      _calculateResult();
    } else {
      _currentIndex++;
      pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      notifyListeners();
    }
  }

  /// Move to previous question.
  void previousQuestion() {
    if (_currentIndex > 0) {
      _currentIndex--;
      pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      notifyListeners();
    }
  }

  /// Calculate pre-qualification result.
  Future<void> _calculateResult() async {
    _isCalculating = true;
    notifyListeners();

    // TODO: Backend - Send answers to ML scoring API
    // Example:
    // _result = await prequalificationService.calculateScore(_answers);

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 1500));

    // Calculate scores by category
    final categoryScores = <CriteriaCategory, List<int>>{};
    for (final question in _questions) {
      final score = _answers[question.id] ?? 0;
      categoryScores.putIfAbsent(question.category, () => []);
      categoryScores[question.category]!.add(score);
    }

    // Average by category
    final avgScores = <CriteriaCategory, int>{};
    for (final entry in categoryScores.entries) {
      final avg = entry.value.reduce((a, b) => a + b) / entry.value.length;
      avgScores[entry.key] = avg.round();
    }

    // Calculate overall score
    final overallScore = avgScores.values.reduce((a, b) => a + b) ~/ avgScores.length;

    // Determine risk level
    RiskLevel riskLevel;
    if (overallScore >= 70) {
      riskLevel = RiskLevel.low;
    } else if (overallScore >= 45) {
      riskLevel = RiskLevel.moderate;
    } else {
      riskLevel = RiskLevel.high;
    }

    // Generate criteria breakdown
    final criteria = <QualificationCriteria>[];
    for (final question in _questions) {
      final score = _answers[question.id] ?? 0;
      criteria.add(QualificationCriteria(
        name: question.question,
        description: '',
        category: question.category,
        weight: 1.0 / _questions.length,
        score: score,
        isMet: score >= 60,
        improvementTip: score < 60 ? _getImprovementTip(question.id) : null,
      ));
    }

    // Generate suggestions for improvement
    final suggestions = _generateSuggestions(avgScores, overallScore);

    // Calculate eligible amounts based on score
    final minAmount = (overallScore * 300).toDouble();
    final maxAmount = (overallScore * 1500).toDouble();

    // Interest rate (inverse of score)
    final maxInterest = 3.5 - (overallScore * 0.015);
    final minInterest = 1.5 - (overallScore * 0.008);

    _result = PrequalificationResult(
      overallScore: overallScore,
      riskLevel: riskLevel,
      minEligibleAmount: minAmount.clamp(5000, 50000),
      maxEligibleAmount: maxAmount.clamp(10000, 150000),
      minInterestRate: minInterest.clamp(1.0, 2.5),
      maxInterestRate: maxInterest.clamp(1.5, 3.5),
      criteria: criteria,
      suggestions: suggestions,
      assessedAt: DateTime.now(),
    );

    _isComplete = true;
    _isCalculating = false;
    notifyListeners();
  }

  String _getImprovementTip(String questionId) {
    switch (questionId) {
      case 'biz-age':
        return 'Continue operating your business to build history';
      case 'biz-reg':
        return 'Consider getting DTI registration for better rates';
      case 'income-freq':
        return 'More consistent income improves your score';
      case 'income-avg':
        return 'Growing your income increases loan eligibility';
      case 'docs-id':
        return 'Get a valid government ID if you don\'t have one';
      case 'docs-records':
        return 'Start keeping records of sales and expenses';
      case 'digital-wallet':
        return 'Use GCash/Maya for transactions to build digital history';
      case 'digital-online':
        return 'Create a Facebook page for your business';
      default:
        return 'Complete this requirement to improve your score';
    }
  }

  List<ImprovementSuggestion> _generateSuggestions(
    Map<CriteriaCategory, int> categoryScores,
    int overallScore,
  ) {
    final suggestions = <ImprovementSuggestion>[];

    // Business suggestions
    if ((categoryScores[CriteriaCategory.business] ?? 0) < 70) {
      suggestions.add(const ImprovementSuggestion(
        title: 'Get DTI Registration',
        description: 'Register your business with DTI for better loan terms and credibility.',
        potentialScoreBoost: 15,
        difficulty: 2,
        actionLabel: 'Learn How',
        actionRoute: '/education',
      ));
    }

    // Income suggestions
    if ((categoryScores[CriteriaCategory.income] ?? 0) < 60) {
      suggestions.add(const ImprovementSuggestion(
        title: 'Track Your Income',
        description: 'Keep daily records of sales para madaling ma-verify ang income mo.',
        potentialScoreBoost: 10,
        difficulty: 1,
        actionLabel: 'Start Now',
        actionRoute: '/forms/income-pattern',
      ));
    }

    // Document suggestions
    if ((categoryScores[CriteriaCategory.documents] ?? 0) < 70) {
      suggestions.add(const ImprovementSuggestion(
        title: 'Complete Your Profile',
        description: 'Update your business profile with complete information.',
        potentialScoreBoost: 12,
        difficulty: 1,
        actionLabel: 'Update Profile',
        actionRoute: '/forms/business-info',
      ));
    }

    // Digital suggestions
    if ((categoryScores[CriteriaCategory.digital] ?? 0) < 60) {
      suggestions.add(const ImprovementSuggestion(
        title: 'Use Digital Payments',
        description: 'Receive payments through GCash/Maya to build transaction history.',
        potentialScoreBoost: 15,
        difficulty: 1,
        actionLabel: 'Learn More',
        actionRoute: '/education',
      ));
    }

    // Education suggestion always
    if (overallScore < 80) {
      suggestions.add(const ImprovementSuggestion(
        title: 'Complete Financial Literacy Course',
        description: 'Learn the basics of managing business finances para mas prepared ka.',
        potentialScoreBoost: 5,
        difficulty: 1,
        actionLabel: 'Start Learning',
        actionRoute: '/education',
      ));
    }

    return suggestions;
  }

  /// Reset assessment to start over.
  void reset() {
    _currentIndex = 0;
    _answers.clear();
    _isComplete = false;
    _isCalculating = false;
    _result = null;
    pageController.jumpToPage(0);
    notifyListeners();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
