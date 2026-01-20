/// MSME Pathways - AI Chatbot Screen
/// 
/// Full-featured AI chatbot interface for financial guidance in Tagalog.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/chat_message_model.dart';
import '../../viewmodels/chatbot_viewmodel.dart';
import '../../widgets/chat/chat_widgets.dart';

/// AI Chatbot screen with Tagalog financial guidance.
class AIChatbotScreen extends StatelessWidget {
  /// Creates the AI chatbot screen.
  const AIChatbotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatbotViewModel(),
      child: const _AIChatbotContent(),
    );
  }
}

class _AIChatbotContent extends StatefulWidget {
  const _AIChatbotContent();

  @override
  State<_AIChatbotContent> createState() => _AIChatbotContentState();
}

class _AIChatbotContentState extends State<_AIChatbotContent> {
  @override
  void initState() {
    super.initState();
    // Set light status bar for this screen
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
    return Consumer<ChatbotViewModel>(
      builder: (context, viewModel, _) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          appBar: _buildAppBar(context, viewModel),
          body: Column(
            children: [
              // Chat messages
              Expanded(
                child: _buildChatList(viewModel),
              ),
              
              // Quick suggestions (show when messages are few)
              if (viewModel.messages.length <= 2 && !viewModel.isTyping)
                _buildQuickSuggestions(viewModel),
              
              // Input bar
              ChatInputBar(
                controller: viewModel.messageController,
                canSend: viewModel.canSend,
                isTyping: viewModel.isTyping,
                onSend: viewModel.sendMessage,
              ),
            ],
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, ChatbotViewModel viewModel) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF2D3748)),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Row(
        children: [
          const AIAssistantAvatar(size: 36),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'MSME Assistant',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2D3748),
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF4CAF50),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    viewModel.isTyping ? 'Typing...' : 'Online 24/7',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: viewModel.isTyping 
                          ? AppColors.primary 
                          : const Color(0xFF718096),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      actions: [
        LanguageToggle(
          isTagalog: viewModel.isTagalog,
          onToggle: viewModel.toggleLanguage,
        ),
        const SizedBox(width: 8),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Color(0xFF2D3748)),
          onSelected: (value) {
            if (value == 'clear') {
              _showClearConfirmation(context, viewModel);
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'clear',
              child: Row(
                children: [
                  const Icon(Icons.delete_outline, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Clear conversation',
                    style: GoogleFonts.inter(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChatList(ChatbotViewModel viewModel) {
    return ListView.builder(
      controller: viewModel.scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: viewModel.messages.length,
      itemBuilder: (context, index) {
        final message = viewModel.messages[index];
        return ChatBubble(message: message);
      },
    );
  }

  Widget _buildQuickSuggestions(ChatbotViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 10),
            child: Text(
              viewModel.isTagalog 
                  ? 'Mga madalas itanong:' 
                  : 'Frequently asked:',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: const Color(0xFF718096),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SuggestionChips(
            suggestions: ChatSuggestions.welcome,
            onSuggestionTap: viewModel.sendSuggestion,
          ),
        ],
      ),
    );
  }

  void _showClearConfirmation(BuildContext context, ChatbotViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          viewModel.isTagalog 
              ? 'I-clear ang conversation?' 
              : 'Clear conversation?',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          viewModel.isTagalog
              ? 'Mawawala ang lahat ng messages. Hindi ito pwedeng i-undo.'
              : 'All messages will be deleted. This cannot be undone.',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: const Color(0xFF718096),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              viewModel.isTagalog ? 'Kanselahin' : 'Cancel',
              style: GoogleFonts.inter(
                color: const Color(0xFF718096),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              viewModel.clearConversation();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              viewModel.isTagalog ? 'I-clear' : 'Clear',
              style: GoogleFonts.inter(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
