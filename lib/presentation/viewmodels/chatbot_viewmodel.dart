/// MSME Pathways - Chatbot ViewModel
/// 
/// Business logic for AI chatbot feature following MVVM pattern.
library;

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

import '../../data/models/chat_message_model.dart';

/// ViewModel for the AI chatbot feature.
class ChatbotViewModel extends ChangeNotifier {
  /// Current conversation.
  ChatConversation _conversation = ChatConversation.empty();

  /// Text controller for message input.
  final TextEditingController messageController = TextEditingController();

  /// Scroll controller for chat list.
  final ScrollController scrollController = ScrollController();

  /// Whether the AI is currently "typing".
  bool _isTyping = false;

  /// Current language setting.
  bool _isTagalog = true;

  /// Gets the current conversation.
  ChatConversation get conversation => _conversation;

  /// Gets all messages in the conversation.
  List<ChatMessage> get messages => _conversation.messages;

  /// Whether the AI is typing.
  bool get isTyping => _isTyping;

  /// Whether Tagalog mode is enabled.
  bool get isTagalog => _isTagalog;

  /// Whether the input is empty.
  bool get canSend => messageController.text.trim().isNotEmpty;

  /// Creates the chatbot viewmodel.
  ChatbotViewModel() {
    _initializeChat();
    messageController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    notifyListeners();
  }

  /// Initializes the chat with a welcome message.
  void _initializeChat() {
    final welcomeMessage = ChatMessage.system(
      _isTagalog
          ? 'Kumusta! Ako si MSME Assistant. Paano kita matutulungan ngayong araw? 😊'
          : 'Hello! I\'m your MSME Assistant. How can I help you today? 😊',
    );
    _conversation = _conversation.copyWith(
      messages: [welcomeMessage],
    );
    notifyListeners();
  }

  /// Toggles between Tagalog and English.
  void toggleLanguage() {
    _isTagalog = !_isTagalog;
    notifyListeners();
  }

  /// Sends a message from the user.
  Future<void> sendMessage([String? customMessage]) async {
    final text = customMessage ?? messageController.text.trim();
    if (text.isEmpty) return;

    // Add user message
    final userMessage = ChatMessage.user(text);
    _addMessage(userMessage);

    // Clear input
    messageController.clear();

    // Scroll to bottom
    _scrollToBottom();

    // Show typing indicator
    _isTyping = true;
    final loadingMessage = ChatMessage.loading();
    _addMessage(loadingMessage);
    notifyListeners();

    // TODO: Backend - Replace with actual AI API call
    // Example:
    // final response = await aiService.getResponse(text);
    // _replaceLoadingWithResponse(response);

    // Simulate AI response delay
    await Future.delayed(Duration(milliseconds: 800 + Random().nextInt(1200)));

    // Generate mock response
    final response = _generateMockResponse(text);

    // Remove loading and add response
    _removeLoadingMessage();
    _isTyping = false;
    
    final aiMessage = ChatMessage.ai(response);
    _addMessage(aiMessage);
    
    _scrollToBottom();
    notifyListeners();
  }

  /// Sends a suggestion query.
  void sendSuggestion(ChatSuggestion suggestion) {
    sendMessage(suggestion.query);
  }

  /// Adds a message to the conversation.
  void _addMessage(ChatMessage message) {
    final updatedMessages = List<ChatMessage>.from(_conversation.messages)
      ..add(message);
    _conversation = _conversation.copyWith(messages: updatedMessages);
    notifyListeners();
  }

  /// Removes the loading message.
  void _removeLoadingMessage() {
    final updatedMessages = _conversation.messages
        .where((m) => !m.isLoading)
        .toList();
    _conversation = _conversation.copyWith(messages: updatedMessages);
  }

  /// Scrolls to the bottom of the chat.
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// Generates a mock AI response based on user input.
  /// 
  /// TODO: Backend - Replace with actual AI integration
  String _generateMockResponse(String userMessage) {
    final lowerMessage = userMessage.toLowerCase();

    // Loan application questions
    if (lowerMessage.contains('apply') || lowerMessage.contains('mag-apply')) {
      return _isTagalog
          ? 'Para mag-apply ng loan, sundin lang ang mga hakbang na ito:\n\n'
            '1️⃣ I-complete ang Business Profile mo\n'
            '2️⃣ Mag-submit ng alternative data (income patterns, etc.)\n'
            '3️⃣ Kumuha ng pre-qualification assessment\n'
            '4️⃣ Pumili ng lender match at mag-submit ng application\n\n'
            'Gusto mo bang magsimula sa Business Profile?'
          : 'To apply for a loan, follow these steps:\n\n'
            '1️⃣ Complete your Business Profile\n'
            '2️⃣ Submit alternative data (income patterns, etc.)\n'
            '3️⃣ Get your pre-qualification assessment\n'
            '4️⃣ Choose a lender match and submit application\n\n'
            'Would you like to start with your Business Profile?';
    }

    // Requirements questions
    if (lowerMessage.contains('requirement') || lowerMessage.contains('kailangan')) {
      return _isTagalog
          ? 'Narito ang mga basic requirements para sa MSME loan:\n\n'
            '📋 Valid ID (government-issued)\n'
            '🏪 Proof of business (DTI registration, permits, o sales records)\n'
            '💰 Income documents (bank statements, sales records)\n'
            '🏠 Proof of address\n\n'
            'Hindi ka pa registered? Pwede ka pa ring mag-apply gamit ang alternative data tulad ng mobile wallet transactions!'
          : 'Here are the basic requirements for an MSME loan:\n\n'
            '📋 Valid ID (government-issued)\n'
            '🏪 Proof of business (DTI registration, permits, or sales records)\n'
            '💰 Income documents (bank statements, sales records)\n'
            '🏠 Proof of address\n\n'
            'Not registered yet? You can still apply using alternative data like mobile wallet transactions!';
    }

    // Loan amount questions
    if (lowerMessage.contains('magkano') || lowerMessage.contains('amount') || lowerMessage.contains('maximum')) {
      return _isTagalog
          ? 'Ang loan amount ay depende sa iyong business profile at eligibility score:\n\n'
            '🌱 New businesses: ₱5,000 - ₱30,000\n'
            '📈 Established (1-2 years): ₱30,000 - ₱100,000\n'
            '🏆 Mature (2+ years): ₱100,000 - ₱500,000\n\n'
            'Gusto mo bang i-check ang iyong eligibility score?'
          : 'Loan amounts depend on your business profile and eligibility score:\n\n'
            '🌱 New businesses: ₱5,000 - ₱30,000\n'
            '📈 Established (1-2 years): ₱30,000 - ₱100,000\n'
            '🏆 Mature (2+ years): ₱100,000 - ₱500,000\n\n'
            'Would you like to check your eligibility score?';
    }

    // Interest rate questions
    if (lowerMessage.contains('interest') || lowerMessage.contains('rate')) {
      return _isTagalog
          ? 'Ang interest rates ay nag-iiba depende sa lender at sa iyong risk profile:\n\n'
            '💚 Low risk: 1.5% - 2.5% per month\n'
            '💛 Medium risk: 2.5% - 3.5% per month\n'
            '🧡 Higher risk: 3.5% - 5% per month\n\n'
            'Kasama dito ang processing fees. Ang exact rate ay makikita mo after ng pre-qualification.'
          : 'Interest rates vary depending on the lender and your risk profile:\n\n'
            '💚 Low risk: 1.5% - 2.5% per month\n'
            '💛 Medium risk: 2.5% - 3.5% per month\n'
            '🧡 Higher risk: 3.5% - 5% per month\n\n'
            'This includes processing fees. You\'ll see exact rates after pre-qualification.';
    }

    // Calculator/compute questions
    if (lowerMessage.contains('calculator') || lowerMessage.contains('compute') || lowerMessage.contains('calculate')) {
      return _isTagalog
          ? 'Sige, tulungan kita mag-compute! 🧮\n\n'
            'Para sa ₱50,000 loan na 12 months sa 2.5% monthly interest:\n'
            '• Monthly payment: ₱4,861\n'
            '• Total payment: ₱58,333\n'
            '• Total interest: ₱8,333\n\n'
            'Gusto mo ng ibang amount? Sabihin mo lang!'
          : 'Let me help you compute! 🧮\n\n'
            'For a ₱50,000 loan over 12 months at 2.5% monthly interest:\n'
            '• Monthly payment: ₱4,861\n'
            '• Total payment: ₱58,333\n'
            '• Total interest: ₱8,333\n\n'
            'Want to calculate a different amount? Just let me know!';
    }

    // Repayment questions
    if (lowerMessage.contains('repayment') || lowerMessage.contains('bayad') || lowerMessage.contains('payment')) {
      return _isTagalog
          ? 'Narito ang mga repayment options:\n\n'
            '📅 Daily collection - Para sa sari-sari stores at market vendors\n'
            '📆 Weekly payment - Flexible para sa small businesses\n'
            '🗓️ Monthly payment - Standard option\n\n'
            'Pwede ka ring mag-early payment without penalty sa karamihan ng lenders!'
          : 'Here are the repayment options:\n\n'
            '📅 Daily collection - For sari-sari stores and market vendors\n'
            '📆 Weekly payment - Flexible for small businesses\n'
            '🗓️ Monthly payment - Standard option\n\n'
            'You can also make early payments without penalty with most lenders!';
    }

    // Default response
    return _isTagalog
        ? 'Salamat sa tanong mo! 😊\n\n'
          'Pwede kitang tulungan sa mga sumusunod:\n'
          '• Loan application process\n'
          '• Requirements at documents\n'
          '• Eligibility checking\n'
          '• Interest rate computation\n'
          '• Repayment options\n\n'
          'Ano ang gusto mong malaman?'
        : 'Thanks for your question! 😊\n\n'
          'I can help you with:\n'
          '• Loan application process\n'
          '• Requirements and documents\n'
          '• Eligibility checking\n'
          '• Interest rate computation\n'
          '• Repayment options\n\n'
          'What would you like to know?';
  }

  /// Clears the conversation.
  void clearConversation() {
    _conversation = ChatConversation.empty();
    _initializeChat();
    notifyListeners();
  }

  @override
  void dispose() {
    messageController.removeListener(_onTextChanged);
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
