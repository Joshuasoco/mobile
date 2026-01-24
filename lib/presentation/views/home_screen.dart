/// MSME Pathways - Home Screen
///
/// Premium home screen with dashboard layout following clean MVVM architecture.
/// - View layer (this file) < 250 lines
/// - ViewModel handles all business logic
/// - Extracted reusable widget components
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/tooltip_definitions.dart';
import '../../core/router/app_router.dart';
import '../../data/repositories/auth_repository.dart';
import '../widgets/home/home_app_bar.dart';
import '../widgets/home/home_bottom_nav_bar.dart';
import '../widgets/home/home_loading_skeleton.dart';
import '../widgets/home/dashboard_stats_card.dart';
import '../widgets/home/financial_stats_cards.dart';
import '../widgets/home/quick_actions_row.dart';
import '../widgets/home/feature_navigation_section.dart';
import '../widgets/home/learning_resources_section.dart';
import '../widgets/home/recent_activity_list.dart';
import '../widgets/home/section_title.dart';
import '../widgets/home/partner_section.dart';
import '../viewmodels/home_viewmodel.dart';
import '../viewmodels/tooltip_viewmodel.dart';
import 'loan_details_screen.dart';
import 'support_chat_screen.dart';
import 'profile_screen.dart';

const Color _kBackgroundColor = Color(0xFFF5F7FA);

/// Home screen with dashboard layout using [HomeViewModel] for state management.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeViewModel(authRepository: context.read<IAuthRepository>()),
      child: const _HomeScreenContent(),
    );
  }
}

class _HomeScreenContent extends StatefulWidget {
  const _HomeScreenContent();
  @override
  State<_HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<_HomeScreenContent> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _tooltipsTriggered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    _fadeAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeOut);
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));
    _animationController.forward();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
    
    // Trigger tooltips after initial build
    WidgetsBinding.instance.addPostFrameCallback((_) => _triggerTooltips());
  }

  Future<void> _triggerTooltips() async {
    if (_tooltipsTriggered) return;
    _tooltipsTriggered = true;
    
    // Wait for animations and layout to complete
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;
    
    final tooltipViewModel = context.read<TooltipViewModel>();
    await tooltipViewModel.startTooltipSequence(HomeTooltipConfigs.getTooltips());
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, viewModel, child) => Scaffold(
        backgroundColor: _kBackgroundColor,
        body: IndexedStack(
          index: viewModel.selectedTabIndex,
          children: [
            _buildHomeTab(viewModel),
            const LoanDetailsScreen(),
            const SupportChatScreen(),
            const ProfileScreen(),
          ],
        ),
        bottomNavigationBar: HomeBottomNavBar(
          selectedIndex: viewModel.selectedTabIndex,
          onTabSelected: viewModel.selectTab,
        ),
      ),
    );
  }

  Widget _buildHomeTab(HomeViewModel viewModel) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: RefreshIndicator(
          onRefresh: viewModel.refreshDashboard,
          child: _buildContent(viewModel),
        ),
      ),
    );
  }

  Widget _buildContent(HomeViewModel viewModel) {
    if (viewModel.isLoading && viewModel.state == HomeState.initial) {
      return const HomeLoadingSkeleton();
    }
    if (viewModel.hasError) {
      return _buildErrorState(viewModel);
    }
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        HomeAppBar(
          greeting: viewModel.greeting,
          userName: viewModel.userName,
          hasUnreadNotifications: viewModel.unreadNotifications > 0,
          onNotificationsTap: () => _navigateTo(AppRoutes.notifications, viewModel),
          onProfileTap: () => viewModel.selectTab(3),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList(delegate: SliverChildListDelegate([
            DashboardStatsCard(
              key: HomeTooltipKeys.dashboardCard,
              businessReadiness: viewModel.businessReadiness,
              businessReadinessFormatted: viewModel.businessReadinessFormatted,
              monthlyImprovementFormatted: viewModel.monthlyImprovementFormatted,
            ),
            const SizedBox(height: 24),
            SectionTitle(title: 'Financial Overview', onSeeAll: () => _navigateTo(AppRoutes.transactions, viewModel)),
            const SizedBox(height: 12),
            FinancialStatsCards(
              key: HomeTooltipKeys.loanEligibility,
              maxLoanEligibleFormatted: viewModel.maxLoanEligibleFormatted,
              completedCourses: viewModel.completedCourses,
              onLoanTap: () => _navigateTo(AppRoutes.prequalification, viewModel),
              onCoursesTap: () => _navigateTo(AppRoutes.education, viewModel),
            ),
            const SizedBox(height: 24),
            const SectionTitle(title: 'Quick Actions'),
            const SizedBox(height: 12),
            QuickActionsRow(
              key: HomeTooltipKeys.quickActionsRow,
              actions: viewModel.quickActions,
              onActionTap: (action) => _navigateTo(action.route, viewModel, featureId: action.id),
            ),
            const SizedBox(height: 24),
            FeatureNavigationSection(
              features: viewModel.featureCards,
              onFeatureTap: (feature) => _navigateTo(feature.route, viewModel, featureId: feature.id),
            ),
            const SizedBox(height: 24),
            SectionTitle(title: 'Learning Resources', onSeeAll: () => _navigateTo(AppRoutes.education, viewModel)),
            const SizedBox(height: 12),
            LearningResourcesSection(
              key: HomeTooltipKeys.educationSection,
              resources: viewModel.learningResources,
              onResourceTap: (resource) => _navigateTo(resource.route, viewModel, featureId: resource.id),
            ),
            const SizedBox(height: 24),
            const PartnerSection(),
            const SizedBox(height: 24),
            SectionTitle(title: 'Recent Activity', onSeeAll: () => _navigateTo(AppRoutes.transactions, viewModel)),
            const SizedBox(height: 12),
            RecentActivityList(
              activities: viewModel.recentActivity,
              onActivityTap: (activity) {
                if (activity.route != null) _navigateTo(activity.route!, viewModel, featureId: activity.id);
              },
            ),
            const SizedBox(height: 32),
          ])),
        ),
      ],
    );
  }

  Widget _buildErrorState(HomeViewModel viewModel) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(viewModel.errorMessage ?? 'Something went wrong',
                textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.grey[600])),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: viewModel.refreshDashboard, child: const Text('Try Again')),
          ],
        ),
      ),
    );
  }

  void _navigateTo(String route, HomeViewModel viewModel, {String? featureId}) {
    viewModel.trackNavigation(route, featureId: featureId);
    context.push(route);
  }
}

