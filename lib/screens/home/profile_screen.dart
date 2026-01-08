import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // Theme colors
  static const Color bgColor = Color(0xFFF6F7F8);
  static const Color primaryGreen = Color(0xFF2E7D32);
  static const Color textDark = Colors.black;
  static const Color textMuted = Colors.black54;

  @override
  Widget build(BuildContext context) {
    const edge = EdgeInsets.symmetric(horizontal: 20);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: textDark),
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(color: textDark, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            children: [
              // Profile Header Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: const BoxDecoration(
                  color: primaryGreen,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
                ),
                child: Column(
                  children: [
                    const Text(
                      'MSME PATHWAYS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const CircleAvatar(
                      radius: 36,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 36, color: primaryGreen),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Joshua Co',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Text(
                      '@joshua_co',
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text('Edit'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Settings Card – Main Options
              Padding(
                padding: edge,
                child: _SettingsCard(
                  items: const [
                    _SettingsItem(icon: Icons.person, label: 'Personal Info'),
                    _SettingsItem(icon: Icons.shield_outlined, label: 'Login and Security'),
                    _SettingsItem(icon: Icons.remove_red_eye_outlined, label: 'Data and Privacy'),
                    _SettingsItem(icon: Icons.notifications_none, label: 'Notification Preferences'),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Secondary Options Card
              Padding(
                padding: edge,
                child: _SettingsCard(
                  items: const [
                    _SettingsItem(icon: Icons.smart_toy_outlined, label: 'AI Assistant'),
                    _SettingsItem(icon: Icons.help_outline, label: 'Help'),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Logout Section
              Padding(
                padding: edge,
                child: Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    leading: const Icon(Icons.logout, color: Colors.redAccent),
                    title: const Text(
                      'Log out',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Footer
              const Text(
                'Legal Agreements',
                style: TextStyle(color: textMuted, fontSize: 12),
              ),
              const SizedBox(height: 4),
              const Text(
                'Version 1.0',
                style: TextStyle(color: textMuted, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -------------------- Reusable Widgets --------------------

class _SettingsCard extends StatelessWidget {
  final List<_SettingsItem> items;
  const _SettingsCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: items,
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const _SettingsItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: ProfileScreen.textDark),
      title: Text(label),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {},
    );
  }
}
