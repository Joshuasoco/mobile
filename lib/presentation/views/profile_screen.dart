/// MSME Pathways - Profile Screen
///
/// Profile screen View layer following clean MVVM architecture.
/// - View layer (this file) < 200 lines
/// - ViewModel handles all business logic and state
/// - Extracted reusable widget components
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/services/tooltip_service.dart';
import '../../data/models/profile_model.dart';
import '../../data/repositories/auth_repository.dart';
import '../viewmodels/profile_viewmodel.dart';
import '../widgets/profile/profile_card.dart';
import '../widgets/profile/settings_section_widget.dart';
import '../widgets/profile/logout_button.dart';
import '../widgets/profile/profile_footer.dart';

const Color _kBackgroundColor = Color(0xFFF5F7FA);

/// Profile screen with MVVM architecture.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileViewModel(
        authRepository: context.read<IAuthRepository>(),
        tooltipService: context.read<ITooltipService>(),
      ),
      child: const _ProfileScreenContent(),
    );
  }
}

class _ProfileScreenContent extends StatefulWidget {
  const _ProfileScreenContent();

  @override
  State<_ProfileScreenContent> createState() => _ProfileScreenContentState();
}

class _ProfileScreenContentState extends State<_ProfileScreenContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(
      builder: (context, viewModel, child) => Scaffold(
        backgroundColor: _kBackgroundColor,
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: _buildContent(viewModel),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(ProfileViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.hasError) {
      return _buildErrorState(viewModel);
    }

    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: viewModel.refreshProfile,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Add top padding where header used to be
              SliverToBoxAdapter(
                child: SizedBox(height: MediaQuery.of(context).padding.top + 60),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    if (viewModel.userProfile != null && viewModel.stats != null)
                      ProfileCard(
                        userProfile: viewModel.userProfile!,
                        stats: viewModel.stats!,
                        onEditTap: viewModel.editProfile,
                      ),
                    const SizedBox(height: 24),
                    ...viewModel.sections.map((section) => Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: SettingsSectionWidget(
                        section: section,
                        onItemTap: _onSettingsTap,
                      ),
                    )),
                    LogoutButton(onLogout: viewModel.logout),
                    const SizedBox(height: 24),
                    const ProfileFooter(),
                  ]),
                ),
              ),
            ],
          ),
        ),
        // Floating settings button
        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          right: 16,
          child: IconButton(
            onPressed: () {
              // Settings action
              debugPrint('Settings tapped');
            },
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.settings_outlined,
                color: Color(0xFF00897B),
                size: 22,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _onSettingsTap(SettingsItem item) {
    final viewModel = context.read<ProfileViewModel>();
    viewModel.onSettingsTap(item);
    
    // Navigate if route is provided
    if (item.route != null) {
      // context.push(item.route!);
      debugPrint('Navigate to: ${item.route}');
    }
  }

  Widget _buildErrorState(ProfileViewModel viewModel) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              viewModel.errorMessage ?? 'Something went wrong',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: viewModel.refreshProfile,
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
