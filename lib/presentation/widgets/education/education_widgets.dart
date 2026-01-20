/// MSME Pathways - Education Widgets
/// 
/// Reusable UI components for loan education modules.
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/education_model.dart';

/// Card widget for displaying a module.
class ModuleCard extends StatelessWidget {
  /// The module to display.
  final LoanEducationModule module;

  /// Progress value (0.0 to 1.0).
  final double progress;

  /// Callback when tapped.
  final VoidCallback onTap;

  /// Creates a module card.
  const ModuleCard({
    super.key,
    required this.module,
    required this.progress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = Color(module.colorValue);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color, color.withValues(alpha: 0.85)],
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.35),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon and progress
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getIcon(module.iconName),
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                if (progress > 0)
                  ProgressRing(progress: progress, size: 38),
              ],
            ),
            
            const SizedBox(height: 14),
            
            // Title
            Text(
              module.title,
              style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            
            const SizedBox(height: 4),
            
            // Category badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                module.category.label,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
            
            const Spacer(),
            
            // Stats
            Row(
              children: [
                Icon(
                  Icons.menu_book_outlined,
                  color: Colors.white.withValues(alpha: 0.8),
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  '${module.totalLessons} lessons',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(width: 14),
                Icon(
                  Icons.timer_outlined,
                  color: Colors.white.withValues(alpha: 0.8),
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  module.durationFormatted,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon(String name) {
    switch (name) {
      case 'school':
        return Icons.school_rounded;
      case 'description':
        return Icons.description_rounded;
      case 'trending_up':
        return Icons.trending_up_rounded;
      case 'payments':
        return Icons.payments_rounded;
      default:
        return Icons.book_rounded;
    }
  }
}

/// Circular progress ring indicator.
class ProgressRing extends StatelessWidget {
  /// Progress value (0.0 to 1.0).
  final double progress;
  
  /// Size of the ring.
  final double size;
  
  /// Stroke width.
  final double strokeWidth;

  /// Creates a progress ring.
  const ProgressRing({
    super.key,
    required this.progress,
    this.size = 48,
    this.strokeWidth = 3,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: progress,
            strokeWidth: strokeWidth,
            backgroundColor: Colors.white.withValues(alpha: 0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          Center(
            child: Text(
              '${(progress * 100).round()}%',
              style: GoogleFonts.inter(
                fontSize: size * 0.26,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// List tile for a lesson.
class LessonListTile extends StatelessWidget {
  /// The lesson to display.
  final LessonContent lesson;
  
  /// Whether this lesson is completed.
  final bool isCompleted;
  
  /// Whether this lesson is the current one.
  final bool isCurrent;
  
  /// Callback when tapped.
  final VoidCallback onTap;

  /// Creates a lesson list tile.
  const LessonListTile({
    super.key,
    required this.lesson,
    required this.isCompleted,
    this.isCurrent = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isCurrent
            ? AppColors.primary.withValues(alpha: 0.1)
            : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isCurrent
              ? AppColors.primary.withValues(alpha: 0.3)
              : Colors.transparent,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // Status icon
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? AppColors.success.withValues(alpha: 0.1)
                        : const Color(0xFFF5F7FA),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isCompleted
                        ? Icons.check_circle_rounded
                        : _getTypeIcon(lesson.type),
                    color: isCompleted ? AppColors.success : AppColors.primary,
                    size: 24,
                  ),
                ),
                
                const SizedBox(width: 14),
                
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lesson.title,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2D3748),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          _TypeBadge(type: lesson.type),
                          const SizedBox(width: 10),
                          Icon(
                            Icons.timer_outlined,
                            size: 14,
                            color: const Color(0xFF718096),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${lesson.durationMinutes} min',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: const Color(0xFF718096),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Arrow
                Icon(
                  Icons.chevron_right_rounded,
                  color: const Color(0xFFA0AEC0),
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getTypeIcon(ContentType type) {
    switch (type) {
      case ContentType.article:
        return Icons.article_outlined;
      case ContentType.video:
        return Icons.play_circle_outline;
      case ContentType.quiz:
        return Icons.quiz_outlined;
      case ContentType.infographic:
        return Icons.image_outlined;
    }
  }
}

class _TypeBadge extends StatelessWidget {
  final ContentType type;

  const _TypeBadge({required this.type});

  @override
  Widget build(BuildContext context) {
    String label;
    Color color;
    
    switch (type) {
      case ContentType.article:
        label = 'Article';
        color = const Color(0xFF5C6BC0);
        break;
      case ContentType.video:
        label = 'Video';
        color = const Color(0xFFEC407A);
        break;
      case ContentType.quiz:
        label = 'Quiz';
        color = const Color(0xFFFF7043);
        break;
      case ContentType.infographic:
        label = 'Visual';
        color = AppColors.primary;
        break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

/// Quiz question widget.
class QuizQuestionWidget extends StatelessWidget {
  /// The question to display.
  final QuizQuestion question;
  
  /// Current question number (1-indexed).
  final int questionNumber;
  
  /// Total number of questions.
  final int totalQuestions;
  
  /// Currently selected answer index.
  final int? selectedAnswer;
  
  /// Whether the quiz has been submitted.
  final bool isSubmitted;
  
  /// Callback when an answer is selected.
  final void Function(int) onAnswerSelected;

  /// Creates a quiz question widget.
  const QuizQuestionWidget({
    super.key,
    required this.question,
    required this.questionNumber,
    required this.totalQuestions,
    this.selectedAnswer,
    required this.isSubmitted,
    required this.onAnswerSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress
        Row(
          children: [
            Text(
              'Question $questionNumber of $totalQuestions',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
            const Spacer(),
            LinearProgressIndicator(
              value: questionNumber / totalQuestions,
              backgroundColor: const Color(0xFFE2E8F0),
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              minHeight: 4,
            ).expanded(),
          ],
        ),
        
        const SizedBox(height: 24),
        
        // Question
        Text(
          question.question,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2D3748),
            height: 1.4,
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Options
        ...question.options.asMap().entries.map((entry) {
          final index = entry.key;
          final option = entry.value;
          final isSelected = selectedAnswer == index;
          final isCorrect = question.correctIndex == index;
          
          Color backgroundColor;
          Color borderColor;
          Color textColor;
          IconData? trailingIcon;
          
          if (isSubmitted) {
            if (isCorrect) {
              backgroundColor = AppColors.success.withValues(alpha: 0.1);
              borderColor = AppColors.success;
              textColor = AppColors.success;
              trailingIcon = Icons.check_circle_rounded;
            } else if (isSelected && !isCorrect) {
              backgroundColor = AppColors.error.withValues(alpha: 0.1);
              borderColor = AppColors.error;
              textColor = AppColors.error;
              trailingIcon = Icons.cancel_rounded;
            } else {
              backgroundColor = Colors.white;
              borderColor = const Color(0xFFE2E8F0);
              textColor = const Color(0xFF718096);
            }
          } else {
            if (isSelected) {
              backgroundColor = AppColors.primary.withValues(alpha: 0.1);
              borderColor = AppColors.primary;
              textColor = AppColors.primary;
            } else {
              backgroundColor = Colors.white;
              borderColor = const Color(0xFFE2E8F0);
              textColor = const Color(0xFF2D3748);
            }
          }
          
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: isSubmitted ? null : () => onAnswerSelected(index),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: borderColor,
                    width: isSelected || (isSubmitted && isCorrect) ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    // Option letter
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: isSelected || (isSubmitted && isCorrect)
                            ? (isSubmitted
                                ? (isCorrect
                                    ? AppColors.success
                                    : (isSelected ? AppColors.error : const Color(0xFFF5F7FA)))
                                : AppColors.primary)
                            : const Color(0xFFF5F7FA),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          String.fromCharCode(65 + index), // A, B, C, D
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isSelected || (isSubmitted && isCorrect)
                                ? Colors.white
                                : const Color(0xFF718096),
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(width: 14),
                    
                    // Option text
                    Expanded(
                      child: Text(
                        option,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: textColor,
                        ),
                      ),
                    ),
                    
                    // Result icon
                    if (trailingIcon != null)
                      Icon(
                        trailingIcon,
                        color: isCorrect ? AppColors.success : AppColors.error,
                        size: 22,
                      ),
                  ],
                ),
              ),
            ),
          );
        }),
        
        // Explanation (shown after submit)
        if (isSubmitted) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.lightbulb_outline_rounded,
                  color: Color(0xFF1565C0),
                  size: 22,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    question.explanation,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: const Color(0xFF1565C0),
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

/// Extension for easier widget wrapping.
extension WidgetExtensions on Widget {
  Widget expanded() => Expanded(child: this);
}

/// Category filter chip.
class CategoryChip extends StatelessWidget {
  /// The category.
  final EducationCategory category;
  
  /// Whether this is selected.
  final bool isSelected;
  
  /// Callback when tapped.
  final VoidCallback onTap;

  /// Creates a category chip.
  const CategoryChip({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFFE2E8F0),
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          category.label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF718096),
          ),
        ),
      ),
    );
  }
}
