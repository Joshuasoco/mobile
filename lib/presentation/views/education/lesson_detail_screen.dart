/// MSME Pathways - Lesson Detail Screen
/// 
/// Display lesson content with article, video, or quiz.
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/education_model.dart';
import '../../viewmodels/education_viewmodel.dart';
import '../../widgets/education/education_widgets.dart';

/// Lesson detail screen with content display.
class LessonDetailScreen extends StatelessWidget {
  /// Creates the lesson detail screen.
  const LessonDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EducationViewModel>(
      builder: (context, viewModel, _) {
        final lesson = viewModel.currentLesson;
        if (lesson == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF2D3748)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Column(
              children: [
                Text(
                  lesson.title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2D3748),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Lesson ${viewModel.currentLessonIndex + 1} of ${viewModel.currentModule?.lessons.length ?? 0}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF718096),
                  ),
                ),
              ],
            ),
            centerTitle: true,
          ),
          body: lesson.isQuiz
              ? _buildQuizContent(context, viewModel, lesson)
              : _buildArticleContent(context, viewModel, lesson),
        );
      },
    );
  }

  Widget _buildArticleContent(
    BuildContext context,
    EducationViewModel viewModel,
    LessonContent lesson,
  ) {
    return Column(
      children: [
        // Content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Video placeholder if applicable
                if (lesson.hasVideo) ...[
                  _buildVideoPlaceholder(),
                  const SizedBox(height: 24),
                ],
                
                // Render markdown-like content
                _renderContent(lesson.content),
              ],
            ),
          ),
        ),
        
        // Bottom navigation
        _buildBottomNav(context, viewModel),
      ],
    );
  }

  Widget _buildVideoPlaceholder() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: const Color(0xFF2D3748),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Video content',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 4),
              // TODO: Backend - Video streaming integration
              Text(
                'Coming soon',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _renderContent(String content) {
    // Simple markdown-like rendering
    final lines = content.split('\n');
    final widgets = <Widget>[];
    
    for (final line in lines) {
      final trimmed = line.trim();
      
      if (trimmed.isEmpty) {
        widgets.add(const SizedBox(height: 12));
        continue;
      }
      
      // Headers
      if (trimmed.startsWith('# ')) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Text(
            trimmed.substring(2),
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2D3748),
            ),
          ),
        ));
      } else if (trimmed.startsWith('## ')) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(top: 18, bottom: 8),
          child: Text(
            trimmed.substring(3),
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2D3748),
            ),
          ),
        ));
      } else if (trimmed.startsWith('### ')) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(top: 14, bottom: 6),
          child: Text(
            trimmed.substring(4),
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2D3748),
            ),
          ),
        ));
      }
      // Blockquotes
      else if (trimmed.startsWith('> ')) {
        widgets.add(Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(12),
            border: Border(
              left: BorderSide(
                color: AppColors.primary,
                width: 4,
              ),
            ),
          ),
          child: Text(
            trimmed.substring(2),
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF2D3748),
              fontStyle: FontStyle.italic,
            ),
          ),
        ));
      }
      // List items
      else if (trimmed.startsWith('- ') || trimmed.startsWith('• ')) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '• ',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Expanded(
                child: _renderInlineText(trimmed.substring(2)),
              ),
            ],
          ),
        ));
      }
      // Ordered list
      else if (RegExp(r'^\d+\.').hasMatch(trimmed)) {
        final match = RegExp(r'^(\d+)\.\s*(.*)').firstMatch(trimmed);
        if (match != null) {
          widgets.add(Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 24,
                  child: Text(
                    '${match.group(1)}.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  child: _renderInlineText(match.group(2) ?? ''),
                ),
              ],
            ),
          ));
        }
      }
      // Emoji list items
      else if (RegExp(r'^[✅📋💰🏠🏪📱🛒👥📅🗓️]').hasMatch(trimmed)) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8),
          child: _renderInlineText(trimmed),
        ));
      }
      // Table header/divider (skip)
      else if (trimmed.startsWith('|') && trimmed.contains('-')) {
        continue;
      }
      // Table rows
      else if (trimmed.startsWith('|')) {
        final cells = trimmed
            .split('|')
            .where((c) => c.trim().isNotEmpty)
            .map((c) => c.trim())
            .toList();
        widgets.add(Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: cells.asMap().entries.map((e) {
              return Expanded(
                child: Text(
                  e.value,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: e.key == 0 ? FontWeight.w500 : FontWeight.w400,
                    color: const Color(0xFF2D3748),
                  ),
                ),
              );
            }).toList(),
          ),
        ));
      }
      // Normal text
      else {
        widgets.add(Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _renderInlineText(trimmed),
        ));
      }
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  Widget _renderInlineText(String text) {
    // Handle bold text marked with **
    final spans = <TextSpan>[];
    final boldPattern = RegExp(r'\*\*(.+?)\*\*');
    var currentIndex = 0;
    
    for (final match in boldPattern.allMatches(text)) {
      // Add text before match
      if (match.start > currentIndex) {
        spans.add(TextSpan(
          text: text.substring(currentIndex, match.start),
        ));
      }
      // Add bold text
      spans.add(TextSpan(
        text: match.group(1),
        style: const TextStyle(fontWeight: FontWeight.w700),
      ));
      currentIndex = match.end;
    }
    // Add remaining text
    if (currentIndex < text.length) {
      spans.add(TextSpan(text: text.substring(currentIndex)));
    }
    
    return RichText(
      text: TextSpan(
        style: GoogleFonts.inter(
          fontSize: 14,
          color: const Color(0xFF4A5568),
          height: 1.6,
        ),
        children: spans.isEmpty ? [TextSpan(text: text)] : spans,
      ),
    );
  }

  Widget _buildQuizContent(
    BuildContext context,
    EducationViewModel viewModel,
    LessonContent lesson,
  ) {
    final questions = lesson.quizQuestions ?? [];
    if (questions.isEmpty) {
      return const Center(child: Text('No quiz questions available'));
    }

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: viewModel.quizSubmitted
                ? _buildQuizResults(viewModel, questions)
                : QuizQuestionWidget(
                    question: questions[viewModel.currentQuizQuestion],
                    questionNumber: viewModel.currentQuizQuestion + 1,
                    totalQuestions: questions.length,
                    selectedAnswer: viewModel.quizAnswers[viewModel.currentQuizQuestion],
                    isSubmitted: viewModel.quizSubmitted,
                    onAnswerSelected: viewModel.selectQuizAnswer,
                  ),
          ),
        ),
        _buildQuizBottomNav(context, viewModel, questions.length),
      ],
    );
  }

  Widget _buildQuizResults(
    EducationViewModel viewModel,
    List<QuizQuestion> questions,
  ) {
    final score = viewModel.quizScore;
    final passed = score >= 70;
    
    return Column(
      children: [
        // Score card
        Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: passed
                ? AppColors.success.withValues(alpha: 0.1)
                : AppColors.warning.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Icon(
                passed ? Icons.emoji_events_rounded : Icons.refresh_rounded,
                color: passed ? AppColors.success : AppColors.warning,
                size: 56,
              ),
              const SizedBox(height: 16),
              Text(
                passed ? 'Congratulations! 🎉' : 'Good try! 💪',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2D3748),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your score: $score%',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: passed ? AppColors.success : AppColors.warning,
                ),
              ),
              if (!passed) ...[
                const SizedBox(height: 12),
                Text(
                  'Need 70% to pass. Review the lessons and try again!',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: const Color(0xFF718096),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
        
        const SizedBox(height: 28),
        
        // Questions review
        Text(
          'Question Review',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 16),
        
        ...questions.asMap().entries.map((entry) {
          final index = entry.key;
          final question = entry.value;
          final userAnswer = viewModel.quizAnswers[index];
          final isCorrect = userAnswer == question.correctIndex;
          
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isCorrect
                  ? AppColors.success.withValues(alpha: 0.05)
                  : AppColors.error.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isCorrect
                    ? AppColors.success.withValues(alpha: 0.2)
                    : AppColors.error.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isCorrect ? AppColors.success : AppColors.error,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isCorrect ? Icons.check : Icons.close,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Q${index + 1}: ${question.question}',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF2D3748),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Correct: ${question.options[question.correctIndex]}',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildBottomNav(BuildContext context, EducationViewModel viewModel) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Previous button
          if (viewModel.hasPreviousLesson)
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  viewModel.previousLesson();
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Previous'),
              ),
            )
          else
            const Spacer(),
          
          const SizedBox(width: 12),
          
          // Next/Complete button
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () {
                viewModel.markLessonCompleted();
                if (viewModel.hasNextLesson) {
                  viewModel.nextLesson();
                } else {
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                viewModel.hasNextLesson ? 'Next Lesson' : 'Complete Module',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizBottomNav(
    BuildContext context,
    EducationViewModel viewModel,
    int totalQuestions,
  ) {
    if (viewModel.quizSubmitted) {
      return Container(
        padding: EdgeInsets.fromLTRB(
          20,
          16,
          20,
          MediaQuery.of(context).padding.bottom + 16,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            if (viewModel.hasNextLesson) {
              viewModel.nextLesson();
            } else {
              Navigator.of(context).pop();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            minimumSize: const Size(double.infinity, 52),
          ),
          child: Text(
            viewModel.hasNextLesson ? 'Next Lesson' : 'Complete Module',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Previous question
          if (viewModel.currentQuizQuestion > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: viewModel.previousQuizQuestion,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Previous'),
              ),
            )
          else
            const Spacer(),
          
          const SizedBox(width: 12),
          
          // Next question or Submit
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: viewModel.currentQuizQuestion < totalQuestions - 1
                  ? viewModel.nextQuizQuestion
                  : (viewModel.canSubmitQuiz ? viewModel.submitQuiz : null),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                disabledBackgroundColor: const Color(0xFFE2E8F0),
              ),
              child: Text(
                viewModel.currentQuizQuestion < totalQuestions - 1
                    ? 'Next Question'
                    : 'Submit Quiz',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
