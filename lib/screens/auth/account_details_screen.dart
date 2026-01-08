import 'package:flutter/material.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/terms_text.dart';
import 'login_screen.dart';
import '../home/home_screen.dart'; // 👈 import HomeScreen

class AccountDetailsScreen extends StatefulWidget {
  const AccountDetailsScreen({super.key});

  @override
  State<AccountDetailsScreen> createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  final locationController = TextEditingController();
  final businessTypeController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          SizedBox.expand(
            child: Image.asset(
              'assets/images/BG_image.png',
              fit: BoxFit.cover,
            ),
          ),

          // Dark overlay
          Container(color: Colors.black.withOpacity(0.5)),

          // Foreground content
          Positioned.fill(
            child: Column(
              children: [
                const SizedBox(height: 80),

                // Logo
                Image.asset(
                  'assets/images/logo.png',
                  height: 160,
                ),

                const Spacer(),

                // Account details card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 10),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Complete Details',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'to personalize support',
                        style: TextStyle(color: Colors.black54),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),

                      // Form fields
                      CustomTextField(
                        hintText: 'Location',
                        icon: Icons.location_on,
                        controller: locationController,
                      ),
                      CustomTextField(
                        hintText: 'Business Type',
                        icon: Icons.storefront,
                        controller: businessTypeController,
                      ),
                      CustomTextField(
                        hintText: 'Phone Number',
                        icon: Icons.phone,
                        controller: phoneController,
                      ),
                      const SizedBox(height: 10),

                      // Create Account button
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Create Account',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Progress indicator (all steps completed)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.check_circle, color: Colors.blue),
                          SizedBox(width: 8),
                          Icon(Icons.check_circle, color: Colors.blue),
                          SizedBox(width: 8),
                          Icon(Icons.check_circle, color: Colors.blue),
                        ],
                      ),

                      const SizedBox(height: 20),
                      const TermsText(),
                      const SizedBox(height: 20),

                      // Responsive Log In link
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          child: RichText(
                            text: const TextSpan(
                              text: "Already have an account? ",
                              style: TextStyle(color: Colors.black),
                              children: [
                                TextSpan(
                                  text: 'Log In',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
