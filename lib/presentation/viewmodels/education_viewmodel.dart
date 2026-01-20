/// MSME Pathways - Education ViewModel
/// 
/// Business logic for loan education modules.
library;

import 'package:flutter/material.dart';

import '../../data/models/education_model.dart';

/// ViewModel for loan education feature.
class EducationViewModel extends ChangeNotifier {
  /// All available modules.
  List<LoanEducationModule> _modules = [];

  /// Currently selected category filter.
  EducationCategory? _selectedCategory;

  /// Progress tracking per lesson.
  final Map<String, LessonProgress> _progressMap = {};

  /// Currently viewing module.
  LoanEducationModule? _currentModule;

  /// Currently viewing lesson.
  LessonContent? _currentLesson;

  /// Current lesson index within module.
  int _currentLessonIndex = 0;

  /// Quiz state.
  int _currentQuizQuestion = 0;
  final List<int?> _quizAnswers = [];
  bool _quizSubmitted = false;

  /// Gets all modules.
  List<LoanEducationModule> get modules => _modules;

  /// Gets filtered modules by category.
  List<LoanEducationModule> get filteredModules {
    if (_selectedCategory == null) return _modules;
    return _modules.where((m) => m.category == _selectedCategory).toList();
  }

  /// Gets featured modules.
  List<LoanEducationModule> get featuredModules =>
      _modules.where((m) => m.isFeatured).toList();

  /// Gets in-progress modules.
  List<LoanEducationModule> get inProgressModules {
    return _modules.where((module) {
      final progress = getModuleProgress(module.id);
      return progress > 0 && progress < 1.0;
    }).toList();
  }

  /// Gets selected category.
  EducationCategory? get selectedCategory => _selectedCategory;

  /// Gets current module.
  LoanEducationModule? get currentModule => _currentModule;

  /// Gets current lesson.
  LessonContent? get currentLesson => _currentLesson;

  /// Gets current lesson index.
  int get currentLessonIndex => _currentLessonIndex;

  /// Quiz getters.
  int get currentQuizQuestion => _currentQuizQuestion;
  List<int?> get quizAnswers => _quizAnswers;
  bool get quizSubmitted => _quizSubmitted;

  /// Creates the education viewmodel.
  EducationViewModel() {
    _loadModules();
  }

  /// Loads available modules.
  void _loadModules() {
    // TODO: Backend - Fetch modules from API
    _modules = EducationModules.getAll();
    notifyListeners();
  }

  /// Sets category filter.
  void setCategory(EducationCategory? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  /// Gets progress for a module (0.0 to 1.0).
  double getModuleProgress(String moduleId) {
    final module = _modules.firstWhere(
      (m) => m.id == moduleId,
      orElse: () => throw Exception('Module not found'),
    );

    if (module.lessons.isEmpty) return 0.0;

    int completed = 0;
    for (final lesson in module.lessons) {
      final progress = _progressMap[lesson.id];
      if (progress?.completed == true) completed++;
    }

    return completed / module.lessons.length;
  }

  /// Gets completed lessons count for a module.
  int getCompletedLessons(String moduleId) {
    final module = _modules.firstWhere(
      (m) => m.id == moduleId,
      orElse: () => throw Exception('Module not found'),
    );

    int completed = 0;
    for (final lesson in module.lessons) {
      if (_progressMap[lesson.id]?.completed == true) completed++;
    }
    return completed;
  }

  /// Opens a module for viewing.
  void openModule(LoanEducationModule module) {
    _currentModule = module;
    _currentLessonIndex = 0;
    if (module.lessons.isNotEmpty) {
      _currentLesson = module.lessons[0];
    }
    _resetQuizState();
    notifyListeners();
  }

  /// Opens a specific lesson.
  void openLesson(LessonContent lesson) {
    _currentLesson = lesson;
    if (_currentModule != null) {
      _currentLessonIndex = _currentModule!.lessons.indexOf(lesson);
    }
    _resetQuizState();
    notifyListeners();
  }

  /// Navigates to next lesson.
  void nextLesson() {
    if (_currentModule == null) return;
    if (_currentLessonIndex < _currentModule!.lessons.length - 1) {
      _currentLessonIndex++;
      _currentLesson = _currentModule!.lessons[_currentLessonIndex];
      _resetQuizState();
      notifyListeners();
    }
  }

  /// Navigates to previous lesson.
  void previousLesson() {
    if (_currentLessonIndex > 0) {
      _currentLessonIndex--;
      _currentLesson = _currentModule!.lessons[_currentLessonIndex];
      _resetQuizState();
      notifyListeners();
    }
  }

  /// Checks if there's a next lesson.
  bool get hasNextLesson {
    if (_currentModule == null) return false;
    return _currentLessonIndex < _currentModule!.lessons.length - 1;
  }

  /// Checks if there's a previous lesson.
  bool get hasPreviousLesson => _currentLessonIndex > 0;

  /// Marks current lesson as completed.
  void markLessonCompleted() {
    if (_currentLesson == null) return;

    // TODO: Backend - Sync progress with server
    _progressMap[_currentLesson!.id] = LessonProgress(
      lessonId: _currentLesson!.id,
      completed: true,
      lastAccessedAt: DateTime.now(),
    );
    notifyListeners();
  }

  /// Checks if a lesson is completed.
  bool isLessonCompleted(String lessonId) {
    return _progressMap[lessonId]?.completed ?? false;
  }

  // Quiz methods

  void _resetQuizState() {
    _currentQuizQuestion = 0;
    _quizAnswers.clear();
    _quizSubmitted = false;
    
    if (_currentLesson?.quizQuestions != null) {
      _quizAnswers.addAll(
        List.filled(_currentLesson!.quizQuestions!.length, null),
      );
    }
  }

  /// Selects an answer for current quiz question.
  void selectQuizAnswer(int answerIndex) {
    if (_currentQuizQuestion < _quizAnswers.length) {
      _quizAnswers[_currentQuizQuestion] = answerIndex;
      notifyListeners();
    }
  }

  /// Goes to next quiz question.
  void nextQuizQuestion() {
    if (_currentLesson?.quizQuestions == null) return;
    if (_currentQuizQuestion < _currentLesson!.quizQuestions!.length - 1) {
      _currentQuizQuestion++;
      notifyListeners();
    }
  }

  /// Goes to previous quiz question.
  void previousQuizQuestion() {
    if (_currentQuizQuestion > 0) {
      _currentQuizQuestion--;
      notifyListeners();
    }
  }

  /// Submits the quiz.
  void submitQuiz() {
    _quizSubmitted = true;
    
    // Calculate score
    if (_currentLesson?.quizQuestions != null) {
      int correct = 0;
      final questions = _currentLesson!.quizQuestions!;
      
      for (int i = 0; i < questions.length; i++) {
        if (_quizAnswers[i] == questions[i].correctIndex) {
          correct++;
        }
      }
      
      final score = (correct / questions.length * 100).round();
      
      // Save progress with score
      _progressMap[_currentLesson!.id] = LessonProgress(
        lessonId: _currentLesson!.id,
        completed: true,
        quizScore: score,
        lastAccessedAt: DateTime.now(),
      );
    }
    
    notifyListeners();
  }

  /// Gets quiz score (0-100).
  int get quizScore {
    if (_currentLesson?.quizQuestions == null || !_quizSubmitted) return 0;
    
    int correct = 0;
    final questions = _currentLesson!.quizQuestions!;
    
    for (int i = 0; i < questions.length; i++) {
      if (_quizAnswers[i] == questions[i].correctIndex) {
        correct++;
      }
    }
    
    return (correct / questions.length * 100).round();
  }

  /// Whether all questions are answered.
  bool get canSubmitQuiz {
    return !_quizAnswers.contains(null);
  }

  /// Closes current module/lesson view.
  void closeModule() {
    _currentModule = null;
    _currentLesson = null;
    _currentLessonIndex = 0;
    _resetQuizState();
    notifyListeners();
  }
}
