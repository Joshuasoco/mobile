/// MSME Pathways - Legal Document Screen (Read-Only)
///
/// A minimal, read-only viewer for Terms of Service and Privacy Policy.
/// Triggered from login/signup flows for informational viewing only.
/// Designed for compliance-first, offline-friendly display.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/policy_content.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/policy_section_model.dart';
import '../../../data/repositories/policy_repository.dart';

/// Read-only legal document viewer screen.
///
/// Displays Terms of Service or Privacy Policy in a minimal card-based layout.
/// Supports offline viewing with bundled content fallback.
class LegalDocumentScreen extends StatefulWidget {
  /// Creates the legal document screen.
  ///
  /// [initialDocumentType] determines which document to show first.
  /// Defaults to Terms of Service if not specified.
  const LegalDocumentScreen({
    super.key,
    this.initialDocumentType,
  });

  /// The initial document type to display (terms or privacy).
  final PolicyType? initialDocumentType;

  @override
  State<LegalDocumentScreen> createState() => _LegalDocumentScreenState();
}

class _LegalDocumentScreenState extends State<LegalDocumentScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  final PolicyRepository _repository = PolicyRepository();

  // State
  late List<PolicySectionModel> _termsSections;
  late List<PolicySectionModel> _privacySections;
  late String _policyVersion;
  final Set<String> _expandedSectionIds = {};

  @override
  void initState() {
    super.initState();

    // Initialize tab controller with correct initial index
    final initialIndex =
        widget.initialDocumentType == PolicyType.privacyPolicy ? 1 : 0;
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: initialIndex,
    );

    // Load offline-bundled policy content
    _loadPolicyContent();

    // Log compliance event (anonymized)
    _logDocumentViewed();

    // Set system UI for light background
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
  }

  void _loadPolicyContent() {
    // Load from bundled constants (offline-friendly)
    _termsSections = _repository.getTermsOfService();
    _privacySections = _repository.getPrivacyPolicy();
    _policyVersion = _repository.getCurrentPolicyVersion();
  }

  /// Logs an anonymized compliance event for document viewing.
  void _logDocumentViewed() {
    // Anonymous compliance logging - no user identifiers
    final documentType = widget.initialDocumentType == PolicyType.privacyPolicy
        ? 'privacy_policy'
        : 'terms_of_service';

    debugPrint(
      '[Compliance] legal_document_viewed: '
      'type=$documentType, '
      'version=$_policyVersion, '
      'timestamp=${DateTime.now().toIso8601String()}',
    );

    // TODO: Send to analytics service when available
    // AnalyticsService.logEvent('legal_document_viewed', {
    //   'document_type': documentType,
    //   'version': _policyVersion,
    //   'source': 'signup_flow',
    // });
  }

  void _toggleSection(String sectionId) {
    setState(() {
      if (_expandedSectionIds.contains(sectionId)) {
        _expandedSectionIds.remove(sectionId);
      } else {
        _expandedSectionIds.add(sectionId);
      }
    });

    // Log section expansion for compliance (anonymized)
    debugPrint(
      '[Compliance] legal_section_expanded: '
      'section_id=$sectionId, '
      'version=$_policyVersion',
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header with close button
            _buildHeader(),

            const SizedBox(height: 16),

            // Tab selector
            _buildTabSelector(),

            const SizedBox(height: 16),

            // Content area
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildDocumentContent(_termsSections),
                  _buildDocumentContent(_privacySections),
                ],
              ),
            ),

            // Bottom info bar
            _buildBottomInfoBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 16, 0),
      child: Row(
        children: [
          // App logo
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowLight,
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/images/msmeLogo.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback icon if image fails
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.storefront_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(width: 14),

          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Legal Documents',
                  style: AppTextStyles.titleLarge.copyWith(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Version $_policyVersion',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textTertiary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Close button with generous touch target (48x48)
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => context.pop(),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                child: Icon(
                  Icons.close_rounded,
                  color: AppColors.textSecondary,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.backgroundSubtle,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorPadding: const EdgeInsets.all(4),
          dividerColor: Colors.transparent,
          labelColor: Colors.white,
          unselectedLabelColor: AppColors.textSecondary,
          labelStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          tabs: const [
            Tab(text: 'Terms of Service'),
            Tab(text: 'Privacy Policy'),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentContent(List<PolicySectionModel> sections) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      itemCount: sections.length,
      itemBuilder: (context, index) {
        final section = sections[index];
        final isExpanded = _expandedSectionIds.contains(section.id);

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildSectionCard(section, isExpanded),
        );
      },
    );
  }

  Widget _buildSectionCard(PolicySectionModel section, bool isExpanded) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _toggleSection(section.id),
          borderRadius: BorderRadius.circular(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Section header (48pt minimum touch target)
              Container(
                constraints: const BoxConstraints(minHeight: 56),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        section.title,
                        style: AppTextStyles.titleMedium.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    AnimatedRotation(
                      duration: const Duration(milliseconds: 200),
                      turns: isExpanded ? 0.5 : 0,
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.textTertiary,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),

              // Expandable content
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 250),
                crossFadeState: isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                firstChild: const SizedBox.shrink(),
                secondChild: Container(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Divider
                      Container(
                        height: 1,
                        margin: const EdgeInsets.only(bottom: 14),
                        color: AppColors.backgroundSubtle,
                      ),

                      // Content text
                      SelectableText(
                        section.content,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.6,
                          fontSize: 14,
                        ),
                      ),

                      // Subsections if any
                      if (section.subsections.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        ...section.subsections.map(
                          (sub) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  sub.title,
                                  style: AppTextStyles.labelMedium.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                SelectableText(
                                  sub.content,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.textSecondary,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomInfoBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 18,
            color: AppColors.textTertiary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Last updated: ${PolicyContent.effectiveDate}',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textTertiary,
                fontSize: 12,
              ),
            ),
          ),
          // Contact support link
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _handleContactSupport,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Text(
                  'Contact Support',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleContactSupport() {
    // Log support contact attempt (anonymized)
    debugPrint(
      '[Compliance] legal_support_contact_tapped: '
      'version=$_policyVersion, '
      'timestamp=${DateTime.now().toIso8601String()}',
    );

    // Show support dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Contact Support',
          style: AppTextStyles.headlineSmall,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'For questions about our Terms of Service or Privacy Policy, please contact:',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            _buildContactRow(
              Icons.email_outlined,
              PolicyContent.supportEmail,
            ),
            const SizedBox(height: 8),
            _buildContactRow(
              Icons.security_outlined,
              PolicyContent.dpoEmail,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Close',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textTertiary),
        const SizedBox(width: 10),
        Expanded(
          child: SelectableText(
            text,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
