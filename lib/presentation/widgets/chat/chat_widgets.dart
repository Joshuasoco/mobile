/// MSME Pathways - Chat Widgets
/// 
/// Reusable UI components for the AI chatbot feature.
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/chat_message_model.dart';

/// Chat bubble widget for displaying messages.
class ChatBubble extends StatelessWidget {
  /// The message to display.
  final ChatMessage message;

  /// Creates a chat bubble.
  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    if (message.isLoading) {
      return _buildLoadingBubble();
    }

    final isUser = message.isFromUser;
    final isSystem = message.sender == SenderType.system;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        margin: EdgeInsets.only(
          left: isUser ? 48 : 0,
          right: isUser ? 0 : 48,
          bottom: 8,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isUser
              ? AppColors.primary
              : isSystem
                  ? const Color(0xFFE8F5E9)
                  : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isUser ? 18 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 18),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.content,
              style: GoogleFonts.inter(
                fontSize: 15,
                color: isUser ? Colors.white : const Color(0xFF2D3748),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(message.timestamp),
              style: GoogleFonts.inter(
                fontSize: 11,
                color: isUser
                    ? Colors.white.withValues(alpha: 0.7)
                    : const Color(0xFFA0AEC0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingBubble() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(right: 48, bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const TypingIndicator(),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : time.hour;
    final period = time.hour >= 12 ? 'PM' : 'AM';
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }
}

/// Animated typing indicator (three dots).
class TypingIndicator extends StatefulWidget {
  /// Creates a typing indicator.
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      3,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
      ),
    );

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0, end: 6).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();

    // Start animations with staggered delay
    for (var i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 150), () {
        if (mounted) {
          _controllers[i].repeat(reverse: true);
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              child: Transform.translate(
                offset: Offset(0, -_animations[index].value),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.6),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

/// Quick suggestion chips for common queries.
class SuggestionChips extends StatelessWidget {
  /// List of suggestions to display.
  final List<ChatSuggestion> suggestions;

  /// Callback when a suggestion is tapped.
  final void Function(ChatSuggestion) onSuggestionTap;

  /// Creates suggestion chips.
  const SuggestionChips({
    super.key,
    required this.suggestions,
    required this.onSuggestionTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: suggestions.map((suggestion) {
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: _SuggestionChip(
              suggestion: suggestion,
              onTap: () => onSuggestionTap(suggestion),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  final ChatSuggestion suggestion;
  final VoidCallback onTap;

  const _SuggestionChip({
    required this.suggestion,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (suggestion.iconName != null) ...[
                Icon(
                  _getIcon(suggestion.iconName!),
                  size: 18,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
              ],
              Text(
                suggestion.label,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'description':
        return Icons.description_outlined;
      case 'checklist':
        return Icons.checklist_outlined;
      case 'calculate':
        return Icons.calculate_outlined;
      case 'percent':
        return Icons.percent_outlined;
      case 'calendar_today':
        return Icons.calendar_today_outlined;
      case 'payment':
        return Icons.payment_outlined;
      default:
        return Icons.chat_bubble_outline;
    }
  }
}

/// Chat input bar with text field and send button.
class ChatInputBar extends StatelessWidget {
  /// Text controller for the input.
  final TextEditingController controller;

  /// Whether the send button should be enabled.
  final bool canSend;

  /// Whether the AI is currently typing.
  final bool isTyping;

  /// Callback when send is pressed.
  final VoidCallback onSend;

  /// Creates a chat input bar.
  const ChatInputBar({
    super.key,
    required this.controller,
    required this.canSend,
    required this.isTyping,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              enabled: !isTyping,
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                hintStyle: GoogleFonts.inter(
                  color: const Color(0xFFA0AEC0),
                  fontSize: 15,
                ),
                filled: true,
                fillColor: const Color(0xFFF5F7FA),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              onSubmitted: (_) {
                if (canSend && !isTyping) onSend();
              },
            ),
          ),
          const SizedBox(width: 12),
          _SendButton(
            canSend: canSend && !isTyping,
            onPressed: onSend,
          ),
        ],
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  final bool canSend;
  final VoidCallback onPressed;

  const _SendButton({
    required this.canSend,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: canSend ? AppColors.primary : const Color(0xFFE2E8F0),
        shape: BoxShape.circle,
        boxShadow: canSend
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: canSend ? onPressed : null,
          borderRadius: BorderRadius.circular(24),
          child: Icon(
            Icons.send_rounded,
            color: canSend ? Colors.white : const Color(0xFFA0AEC0),
            size: 22,
          ),
        ),
      ),
    );
  }
}

/// AI assistant avatar with online indicator.
class AIAssistantAvatar extends StatelessWidget {
  /// Size of the avatar.
  final double size;

  /// Creates an AI assistant avatar.
  const AIAssistantAvatar({super.key, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Icon(
              Icons.smart_toy_outlined,
              color: AppColors.primary,
              size: size * 0.55,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: size * 0.3,
              height: size * 0.3,
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Language toggle button.
class LanguageToggle extends StatelessWidget {
  /// Whether Tagalog is currently selected.
  final bool isTagalog;

  /// Callback when toggled.
  final VoidCallback onToggle;

  /// Creates a language toggle.
  const LanguageToggle({
    super.key,
    required this.isTagalog,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F7FA),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '🇵🇭',
              style: GoogleFonts.inter(fontSize: 14),
            ),
            const SizedBox(width: 6),
            Text(
              isTagalog ? 'TL' : 'EN',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2D3748),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
