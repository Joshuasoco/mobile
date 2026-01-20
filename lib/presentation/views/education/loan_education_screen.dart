/// MSME Pathways - Loan Education Screen
/// 
/// Display list of loan education modules with progress tracking.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/education_model.dart';
import '../../viewmodels/education_viewmodel.dart';
import '../../widgets/education/education_widgets.dart';
import 'lesson_detail_screen.dart';

/// Loan education screen with module list.
class LoanEducationScreen extends StatelessWidget {
  /// Creates the loan education screen.
  const LoanEducationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EducationViewModel(),
      child: const _LoanEducationContent(),
    );
  }
}

class _LoanEducationContent extends StatefulWidget {
  const _LoanEducationContent();

  @override
  State<_LoanEducationContent> createState() => _LoanEducationContentState();
}

class _LoanEducationContentState extends State<_LoanEducationContent> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EducationViewModel>(
      builder: (context, viewModel, _) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                // App bar
                SliverAppBar(
                  backgroundColor: const Color(0xFFF5F7FA),
                  elevation: 0,
                  floating: true,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Color(0xFF2D3748)),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  title: Text(
                    'Learning Center',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2D3748),
                    ),
                  ),
                  centerTitle: true,
                ),
                
                // Header section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Welcome banner
                        _buildWelcomeBanner(),
                        const SizedBox(height: 24),
                        
                        // Category filters
                        _buildCategoryFilters(viewModel),
                      ],
                    ),
                  ),
                ),
                
                // Continue learning section
                if (viewModel.inProgressModules.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: _buildSectionHeader('Continue Learning'),
                  ),
                  SliverToBoxAdapter(
                    child: _buildContinueLearning(viewModel),
                  ),
                ],
                
                // All modules
                SliverToBoxAdapter(
                  child: _buildSectionHeader('All Courses'),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.82,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final module = viewModel.filteredModules[index];
                        return ModuleCard(
                          module: module,
                          progress: viewModel.getModuleProgress(module.id),
                          onTap: () => _openModule(context, viewModel, module),
                        );
                      },
                      childCount: viewModel.filteredModules.length,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWelcomeBanner() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF26A69A), Color(0xFF00897B)],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF26A69A).withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Matuto at Kumita! 📚',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Free courses para sa financial literacy at business growth mo',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.9),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.school_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilters(EducationViewModel viewModel) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // All category
          GestureDetector(
            onTap: () => viewModel.setCategory(null),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: viewModel.selectedCategory == null
                    ? AppColors.primary
                    : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: viewModel.selectedCategory == null
                      ? AppColors.primary
                      : const Color(0xFFE2E8F0),
                  width: 1,
                ),
              ),
              child: Text(
                'All',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: viewModel.selectedCategory == null
                      ? Colors.white
                      : const Color(0xFF718096),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          ...EducationCategory.values.map((category) {
            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: CategoryChip(
                category: category,
                isSelected: viewModel.selectedCategory == category,
                onTap: () => viewModel.setCategory(category),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 14),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF2D3748),
        ),
      ),
    );
  }

  Widget _buildContinueLearning(EducationViewModel viewModel) {
    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: viewModel.inProgressModules.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final module = viewModel.inProgressModules[index];
          return SizedBox(
            width: 240,
            child: ModuleCard(
              module: module,
              progress: viewModel.getModuleProgress(module.id),
              onTap: () => _openModule(context, viewModel, module),
            ),
          );
        },
      ),
    );
  }

  void _openModule(
    BuildContext context,
    EducationViewModel viewModel,
    LoanEducationModule module,
  ) {
    viewModel.openModule(module);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
          value: viewModel,
          child: const ModuleDetailScreen(),
        ),
      ),
    );
  }
}

/// Module detail screen showing lessons.
class ModuleDetailScreen extends StatelessWidget {
  /// Creates the module detail screen.
  const ModuleDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EducationViewModel>(
      builder: (context, viewModel, _) {
        final module = viewModel.currentModule;
        if (module == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final color = Color(module.colorValue);
        
        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          body: CustomScrollView(
            slivers: [
              // Hero header
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                backgroundColor: color,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    viewModel.closeModule();
                    Navigator.of(context).pop();
                  },
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [color, color.withValues(alpha: 0.8)],
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              module.title,
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              module.description,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                _buildStat(Icons.menu_book_outlined, '${module.totalLessons} lessons'),
                                const SizedBox(width: 20),
                                _buildStat(Icons.timer_outlined, module.durationFormatted),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              // Progress card
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: _buildProgressCard(viewModel, module),
                ),
              ),
              
              // Lessons list header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                  child: Text(
                    'Mga Lessons',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2D3748),
                    ),
                  ),
                ),
              ),
              
              // Lessons list
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final lesson = module.lessons[index];
                      return LessonListTile(
                        lesson: lesson,
                        isCompleted: viewModel.isLessonCompleted(lesson.id),
                        isCurrent: viewModel.currentLesson?.id == lesson.id,
                        onTap: () {
                          viewModel.openLesson(lesson);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ChangeNotifierProvider.value(
                                value: viewModel,
                                child: const LessonDetailScreen(),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    childCount: module.lessons.length,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStat(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white.withValues(alpha: 0.8), size: 16),
        const SizedBox(width: 6),
        Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressCard(EducationViewModel viewModel, LoanEducationModule module) {
    final progress = viewModel.getModuleProgress(module.id);
    final completed = viewModel.getCompletedLessons(module.id);
    
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Progress',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2D3748),
                ),
              ),
              Text(
                '$completed / ${module.totalLessons} completed',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: const Color(0xFF718096),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: const Color(0xFFE2E8F0),
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}
