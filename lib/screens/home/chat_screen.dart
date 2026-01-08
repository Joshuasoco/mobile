import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  // Theme colors
  static const Color bgColor = Colors.white;
  static const Color primaryBlue = Color(0xFF1565C0);
  static const Color lightBlue = Color(0xFFE3F2FD);
  static const Color textDark = Colors.black;
  static const Color textMuted = Colors.black54;
  static const Color greenDot = Color(0xFF4CAF50);

  @override
  Widget build(BuildContext context) {
    final padding = EdgeInsets.symmetric(horizontal: 20);
    final media = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            ListView(
              padding: const EdgeInsets.only(bottom: 100),
              children: [
                const SizedBox(height: 16),

                // Header Section
                Padding(
                  padding: padding,
                  child: Row(
                    children: [
                      const Icon(Icons.headset_mic_outlined, color: primaryBlue),
                      const SizedBox(width: 8),
                      const Text(
                        'Support Assistant',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: textDark,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: greenDot,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Online 24/7',
                        style: TextStyle(color: textMuted, fontSize: 12),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Assistant Intro Card
                Padding(
                  padding: padding,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: lightBlue,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.auto_awesome, color: primaryBlue),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'AI-powered support available instantly.',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: textDark,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Ask anything!',
                                style: TextStyle(color: textMuted),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Quick Help Topics
                Padding(
                  padding: padding,
                  child: const Text(
                    'Quick Help Topics',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: textDark,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: padding,
                  child: Column(
                    children: const [
                      _HelpTopicCard(
                        icon: Icons.description_outlined,
                        title: 'How do I apply for a loan?',
                        subtitle: 'Learn about the application process',
                      ),
                      SizedBox(height: 10),
                      _HelpTopicCard(
                        icon: Icons.assignment_turned_in_outlined,
                        title: 'What are the requirements?',
                        subtitle: 'View eligibility and documents needed',
                      ),
                      SizedBox(height: 10),
                      _HelpTopicCard(
                        icon: Icons.percent_outlined,
                        title: 'How is interest calculated?',
                        subtitle: 'Understand loan terms and rates',
                      ),
                      SizedBox(height: 10),
                      _HelpTopicCard(
                        icon: Icons.lock_outline,
                        title: 'Is my data safe?',
                        subtitle: 'Learn about our security measures',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Contact Support Card
                Padding(
                  padding: padding,
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 1.5,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Icon(Icons.phone_in_talk, color: primaryBlue),
                          const SizedBox(height: 12),
                          const Text(
                            'Need to speak with someone?',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: textDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Our support team is available Mon–Sat, 8AM–6PM',
                            style: TextStyle(color: textMuted),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: primaryBlue),
                              foregroundColor: primaryBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {},
                            child: const Text('Contact Support'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Chat Input Area
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: bgColor,
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: const TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Type your message…',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      decoration: const BoxDecoration(
                        color: primaryBlue,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.send, color: Colors.white),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------- Reusable Help Topic Card --------------------

class _HelpTopicCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _HelpTopicCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: ChatScreen.lightBlue,
          child: Icon(icon, color: ChatScreen.primaryBlue),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(subtitle, style: const TextStyle(color: ChatScreen.textMuted)),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }
}
