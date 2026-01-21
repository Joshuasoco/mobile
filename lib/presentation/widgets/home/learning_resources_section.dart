/// MSME Pathways - Learning Resources Section Widget
///
/// Horizontal scrolling list of learning resource cards.
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/models/home_dashboard_model.dart';

/// Learning resources horizontal scroll section.
///
/// Displays a horizontally scrollable list of learning
/// resource cards with progress indicators.
class LearningResourcesSection extends StatelessWidget {
  const LearningResourcesSection({
    super.key,
    required this.resources,
    required this.onResourceTap,
  });

  /// List of learning resources.
  final List<LearningResourceItem> resources;

  /// Callback when a resource is tapped.
  final void Function(LearningResourceItem resource) onResourceTap;

  @override
  Widget build(BuildContext context) {
    if (resources.isEmpty) {
      return _buildEmptyState();
    }

    return SizedBox(
      height: 160,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: resources.length,
        separatorBuilder: (context, index) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final resource = resources[index];
          return _LearningResourceCard(
            resource: resource,
            onTap: () => onResourceTap(resource),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 160,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.school_outlined,
              size: 40,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 8),
            Text(
              'No courses available',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Individual learning resource card.
class _LearningResourceCard extends StatelessWidget {
  const _LearningResourceCard({
    required this.resource,
    required this.onTap,
  });

  final LearningResourceItem resource;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              resource.color,
              resource.color.withValues(alpha: 0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: resource.color.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildHeader(),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.play_circle_filled_rounded,
            color: Colors.white,
            size: 22,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          resource.title,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          resource.subtitle,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.85),
          ),
        ),
        const SizedBox(height: 8),
        if (resource.isStarted) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: resource.progress,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 4,
            ),
          ),
        ] else
          Text(
            'Start Learning →',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }
}
