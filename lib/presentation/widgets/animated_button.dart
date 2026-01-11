/// MSME Pathways - Animated Button
/// 
/// A button with micro-interactions and loading state support.
library;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// An animated button with scale animation on press and loading state.
/// 
/// Features:
/// - Scale down on tap for tactile feedback
/// - Optional loading state with spinner
/// - Gradient background option
/// - Proper accessibility support
class AnimatedButton extends StatefulWidget {
  /// Creates an animated button.
  const AnimatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.useGradient = true,
    this.semanticLabel,
    this.width,
    this.height = 56,
  });

  /// Button text label
  final String text;

  /// Callback when button is pressed
  final VoidCallback? onPressed;

  /// Whether to show loading spinner
  final bool isLoading;

  /// Whether to use outlined style
  final bool isOutlined;

  /// Whether to use gradient background
  final bool useGradient;

  /// Accessibility label
  final String? semanticLabel;

  /// Optional fixed width
  final double? width;

  /// Button height
  final double height;

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      setState(() => _isPressed = true);
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    _resetPress();
  }

  void _handleTapCancel() {
    _resetPress();
  }

  void _resetPress() {
    if (_isPressed) {
      setState(() => _isPressed = false);
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.onPressed != null && !widget.isLoading;
    
    return Semantics(
      button: true,
      enabled: isEnabled,
      label: widget.semanticLabel ?? widget.text,
      child: AnimatedBuilder(
        listenable: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: GestureDetector(
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          onTap: isEnabled ? widget.onPressed : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              gradient: !widget.isOutlined && widget.useGradient
                  ? LinearGradient(
                      colors: isEnabled
                          ? [AppColors.primaryLight, AppColors.primary]
                          : [AppColors.textTertiary, AppColors.textTertiary],
                    )
                  : null,
              color: !widget.isOutlined && !widget.useGradient
                  ? (isEnabled ? AppColors.primary : AppColors.textTertiary)
                  : null,
              borderRadius: BorderRadius.circular(16),
              border: widget.isOutlined
                  ? Border.all(
                      color: isEnabled 
                          ? AppColors.primary 
                          : AppColors.textTertiary,
                      width: 2,
                    )
                  : null,
              boxShadow: !widget.isOutlined && isEnabled
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withAlpha(76), // 0.3 opacity
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: widget.isLoading
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          widget.isOutlined 
                              ? AppColors.primary 
                              : AppColors.textLight,
                        ),
                      ),
                    )
                  : Text(
                      widget.text,
                      style: AppTextStyles.button.copyWith(
                        color: widget.isOutlined
                            ? AppColors.primary
                            : AppColors.textLight,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A simplified animated builder for transform animations.
class AnimatedBuilder extends AnimatedWidget {
  const AnimatedBuilder({
    super.key,
    required super.listenable,
    required this.builder,
    this.child,
  });

  final Widget Function(BuildContext context, Widget? child) builder;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return builder(context, child);
  }
}
