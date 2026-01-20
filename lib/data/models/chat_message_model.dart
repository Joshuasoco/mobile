/// MSME Pathways - Chat Message Models
/// 
/// Data models for AI chatbot conversations.
library;

/// Type of message sender.
enum SenderType {
  /// Message from the user
  user,
  /// Message from the AI assistant
  ai,
  /// System message (welcome, error, etc.)
  system,
}

/// Type of message content.
enum MessageType {
  /// Regular text message
  text,
  /// Quick suggestion/action button
  suggestion,
  /// Loading/typing indicator placeholder
  loading,
  /// Error message
  error,
}

/// Represents a single chat message.
class ChatMessage {
  /// Unique identifier for the message.
  final String id;

  /// The message content.
  final String content;

  /// Who sent the message.
  final SenderType sender;

  /// Type of message for rendering.
  final MessageType type;

  /// When the message was sent.
  final DateTime timestamp;

  /// Optional action data for suggestion messages.
  final Map<String, dynamic>? actionData;

  /// Creates a chat message.
  const ChatMessage({
    required this.id,
    required this.content,
    required this.sender,
    this.type = MessageType.text,
    required this.timestamp,
    this.actionData,
  });

  /// Creates a user message.
  factory ChatMessage.user(String content) {
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      sender: SenderType.user,
      type: MessageType.text,
      timestamp: DateTime.now(),
    );
  }

  /// Creates an AI response message.
  factory ChatMessage.ai(String content) {
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      sender: SenderType.ai,
      type: MessageType.text,
      timestamp: DateTime.now(),
    );
  }

  /// Creates a loading placeholder message.
  factory ChatMessage.loading() {
    return ChatMessage(
      id: 'loading_${DateTime.now().millisecondsSinceEpoch}',
      content: '',
      sender: SenderType.ai,
      type: MessageType.loading,
      timestamp: DateTime.now(),
    );
  }

  /// Creates a system message.
  factory ChatMessage.system(String content) {
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      sender: SenderType.system,
      type: MessageType.text,
      timestamp: DateTime.now(),
    );
  }

  /// Creates a suggestion message.
  factory ChatMessage.suggestion(String label, {Map<String, dynamic>? actionData}) {
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: label,
      sender: SenderType.ai,
      type: MessageType.suggestion,
      timestamp: DateTime.now(),
      actionData: actionData,
    );
  }

  /// Whether this is a loading placeholder.
  bool get isLoading => type == MessageType.loading;

  /// Whether this message is from the user.
  bool get isFromUser => sender == SenderType.user;

  /// Whether this message is from the AI.
  bool get isFromAI => sender == SenderType.ai;

  /// Creates a copy with updated fields.
  ChatMessage copyWith({
    String? id,
    String? content,
    SenderType? sender,
    MessageType? type,
    DateTime? timestamp,
    Map<String, dynamic>? actionData,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      sender: sender ?? this.sender,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      actionData: actionData ?? this.actionData,
    );
  }
}

/// Represents a chat conversation.
class ChatConversation {
  /// Unique conversation identifier.
  final String id;

  /// List of messages in the conversation.
  final List<ChatMessage> messages;

  /// When the conversation was created.
  final DateTime createdAt;

  /// When the conversation was last updated.
  final DateTime updatedAt;

  /// Creates a chat conversation.
  const ChatConversation({
    required this.id,
    required this.messages,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Creates a new empty conversation.
  factory ChatConversation.empty() {
    final now = DateTime.now();
    return ChatConversation(
      id: now.millisecondsSinceEpoch.toString(),
      messages: [],
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Creates a copy with updated messages.
  ChatConversation copyWith({
    String? id,
    List<ChatMessage>? messages,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChatConversation(
      id: id ?? this.id,
      messages: messages ?? this.messages,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}

/// Quick suggestion options for chat.
class ChatSuggestion {
  /// Display label for the suggestion.
  final String label;

  /// Icon to display.
  final String? iconName;

  /// Query to send when tapped.
  final String query;

  /// Creates a chat suggestion.
  const ChatSuggestion({
    required this.label,
    this.iconName,
    required this.query,
  });
}

/// Predefined quick suggestions for the chatbot.
class ChatSuggestions {
  ChatSuggestions._();

  /// Welcome suggestions shown at start.
  static const List<ChatSuggestion> welcome = [
    ChatSuggestion(
      label: 'Paano mag-apply ng loan?',
      iconName: 'description',
      query: 'Paano mag-apply ng loan?',
    ),
    ChatSuggestion(
      label: 'Ano ang requirements?',
      iconName: 'checklist',
      query: 'Ano ang requirements para sa loan?',
    ),
    ChatSuggestion(
      label: 'Magkano pwede kong hiramin?',
      iconName: 'calculate',
      query: 'Magkano ang maximum loan amount?',
    ),
    ChatSuggestion(
      label: 'Interest rates',
      iconName: 'percent',
      query: 'Ano ang interest rates ng loans?',
    ),
  ];

  /// Loan-related suggestions.
  static const List<ChatSuggestion> loanTopics = [
    ChatSuggestion(
      label: 'Loan calculator',
      iconName: 'calculate',
      query: 'Tulungan mo akong mag-compute ng loan',
    ),
    ChatSuggestion(
      label: 'Repayment schedule',
      iconName: 'calendar_today',
      query: 'Paano ang repayment schedule?',
    ),
    ChatSuggestion(
      label: 'Early payment',
      iconName: 'payment',
      query: 'May penalty ba kung early payment?',
    ),
  ];
}
