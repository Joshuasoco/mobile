/// MSME Pathways - Home Loading Skeleton Widget
///
/// Shimmer loading skeleton for the home screen.
library;

import 'package:flutter/material.dart';

/// Loading skeleton for the home screen.
///
/// Displays animated placeholder widgets while content loads.
class HomeLoadingSkeleton extends StatefulWidget {
  const HomeLoadingSkeleton({super.key});

  @override
  State<HomeLoadingSkeleton> createState() => _HomeLoadingSkeletonState();
}

class _HomeLoadingSkeletonState extends State<HomeLoadingSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.4, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome card skeleton
              _buildSkeleton(height: 180, opacity: _animation.value),
              const SizedBox(height: 24),
              // Section title skeleton
              _buildSkeleton(
                height: 20,
                width: 150,
                opacity: _animation.value,
              ),
              const SizedBox(height: 12),
              // Stats cards skeleton
              Row(
                children: [
                  Expanded(
                    child: _buildSkeleton(height: 140, opacity: _animation.value),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildSkeleton(height: 140, opacity: _animation.value),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Quick actions skeleton
              _buildSkeleton(
                height: 20,
                width: 120,
                opacity: _animation.value,
              ),
              const SizedBox(height: 12),
              _buildSkeleton(height: 100, opacity: _animation.value),
              const SizedBox(height: 24),
              // Feature cards skeleton
              _buildSkeleton(
                height: 20,
                width: 100,
                opacity: _animation.value,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildSkeleton(height: 130, opacity: _animation.value),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildSkeleton(height: 130, opacity: _animation.value),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _buildSkeleton(height: 130, opacity: _animation.value),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildSkeleton(height: 130, opacity: _animation.value),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSkeleton({
    required double height,
    double? width,
    required double opacity,
  }) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey[300]!.withValues(alpha: opacity),
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}
