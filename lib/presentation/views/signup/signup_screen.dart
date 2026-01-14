/// MSME Pathways - Sign Up Screen
///
/// A premium sign up screen with full-screen background, gradient overlay,
/// registration form fields, and social sign up options.

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/models/policy_section_model.dart';

/// Primary accent color - teal/green theme
const Color _kPrimaryColor = Color(0xFF00897B);

/// Sign up screen with full-screen background and modern UI elements.
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  void _handleSignUp() {
    if (_formKey.currentState?.validate() ?? false) {
      if (!_agreeToTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please agree to the Terms and Privacy Policy'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      // Navigate to home on successful signup
      context.go('/home');
    }
  }

  void _handleLogin() {
    context.go('/login');
  }

  void _handleSocialSignUp(String provider) {
    // TODO: Implement social sign up
    debugPrint('$provider sign up pressed');
  }

  void _handleTerms() {
    // Navigate to read-only legal document screen (Terms tab)
    context.push('/legal', extra: PolicyType.termsOfService);
  }

  void _handlePrivacyPolicy() {
    // Navigate to read-only legal document screen (Privacy tab)
    context.push('/legal', extra: PolicyType.privacyPolicy);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      body: Stack(
        children: [
          // Full-screen background image
          _buildBackgroundImage(),
          
          // Dark gradient overlay
          _buildGradientOverlay(),
          
          // Main content
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: screenHeight - 
                      MediaQuery.of(context).padding.top - 
                      bottomPadding,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Logo section at top
                    _buildLogoSection(screenHeight),
                    
                    // Sign up card at bottom
                    _buildSignUpCard(bottomPadding),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the full-screen background image.
  Widget _buildBackgroundImage() {
    return Positioned.fill(
      child: Image.asset(
        'assets/images/login_background.png',
        fit: BoxFit.cover,
      ),
    );
  }

  /// Builds the dark gradient overlay for readability.
  Widget _buildGradientOverlay() {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 0.3),
              Colors.black.withValues(alpha: 0.5),
              Colors.black.withValues(alpha: 0.7),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
      ),
    );
  }

  /// Builds the logo section at the top.
  Widget _buildLogoSection(double screenHeight) {
    return Padding(
      padding: EdgeInsets.only(top: screenHeight * 0.05),
      child: Column(
        children: [
          // Logo icon container
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: _kPrimaryColor,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: _kPrimaryColor.withValues(alpha: 0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(
              Icons.storefront_rounded,
              size: 38,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          // App title
          Text(
            'Create Account',
            style: GoogleFonts.poppins(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 1,
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the sign up card container with form elements.
  Widget _buildSignUpCard(double bottomPadding) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(
        top: 16,
      ),
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Form fields
            _buildFullNameField(),
            const SizedBox(height: 14),
            _buildEmailField(),
            const SizedBox(height: 14),
            _buildPasswordField(),
            const SizedBox(height: 14),
            _buildConfirmPasswordField(),
            const SizedBox(height: 14),
            
            // Terms checkbox
            _buildTermsCheckbox(),
            const SizedBox(height: 20),
            
            // Sign Up button
            _buildSignUpButton(),
            const SizedBox(height: 20),
            
            // Divider with "or Sign up with"
            _buildDivider(),
            const SizedBox(height: 16),
            
            // Social sign up icons
            _buildSocialSignUpRow(),
            const SizedBox(height: 20),
            
            // Login link
            _buildLoginLink(),
          ],
        ),
      ),
    );
  }

  /// Builds the full name input field.
  Widget _buildFullNameField() {
    return TextFormField(
      controller: _fullNameController,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      style: GoogleFonts.inter(fontSize: 15),
      decoration: _buildInputDecoration(
        hintText: 'Full Name',
        prefixIcon: Icons.person_outline_rounded,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Full name is required';
        }
        return null;
      },
    );
  }

  /// Builds the email input field.
  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      style: GoogleFonts.inter(fontSize: 15),
      decoration: _buildInputDecoration(
        hintText: 'Email Address',
        prefixIcon: Icons.email_outlined,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email is required';
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }

  /// Builds the password input field with show/hide toggle.
  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      textInputAction: TextInputAction.next,
      style: GoogleFonts.inter(fontSize: 15),
      decoration: _buildInputDecoration(
        hintText: 'Password',
        prefixIcon: Icons.lock_outline_rounded,
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: Colors.grey[600],
            size: 22,
          ),
          onPressed: _togglePasswordVisibility,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password is required';
        }
        if (value.length < 8) {
          return 'Password must be at least 8 characters';
        }
        return null;
      },
    );
  }

  /// Builds the confirm password input field.
  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: _obscureConfirmPassword,
      textInputAction: TextInputAction.done,
      style: GoogleFonts.inter(fontSize: 15),
      onFieldSubmitted: (_) => _handleSignUp(),
      decoration: _buildInputDecoration(
        hintText: 'Confirm Password',
        prefixIcon: Icons.lock_outline_rounded,
        suffixIcon: IconButton(
          icon: Icon(
            _obscureConfirmPassword
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: Colors.grey[600],
            size: 22,
          ),
          onPressed: _toggleConfirmPasswordVisibility,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please confirm your password';
        }
        if (value != _passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }

  /// Builds consistent input decoration.
  InputDecoration _buildInputDecoration({
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: GoogleFonts.inter(
        color: Colors.grey[500],
        fontSize: 15,
      ),
      prefixIcon: Icon(
        prefixIcon,
        color: Colors.grey[600],
        size: 22,
      ),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: const Color(0xFFF5F7FA),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: _kPrimaryColor,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 2,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
    );
  }

  /// Builds the terms and conditions checkbox.
  Widget _buildTermsCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: _agreeToTerms,
            onChanged: (value) {
              setState(() {
                _agreeToTerms = value ?? false;
              });
            },
            activeColor: _kPrimaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            side: BorderSide(
              color: Colors.grey[400]!,
              width: 1.5,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.inter(
                fontSize: 13,
                color: Colors.grey[700],
                height: 1.4,
              ),
              children: [
                const TextSpan(text: 'I agree to the '),
                TextSpan(
                  text: 'Terms of Service',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: _kPrimaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = _handleTerms,
                ),
                const TextSpan(text: ' and '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: _kPrimaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = _handlePrivacyPolicy,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the main sign up button.
  Widget _buildSignUpButton() {
    return ElevatedButton(
      onPressed: _handleSignUp,
      style: ElevatedButton.styleFrom(
        backgroundColor: _kPrimaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        shadowColor: _kPrimaryColor.withValues(alpha: 0.4),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: Text(
        'Sign Up',
        style: GoogleFonts.poppins(
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Builds the divider with "or Sign up with" text.
  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: Colors.grey[300],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            'or Sign up with',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Colors.grey[500],
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: Colors.grey[300],
          ),
        ),
      ],
    );
  }

  /// Builds the social sign up icons row.
  Widget _buildSocialSignUpRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialButton(
          icon: Icons.apple,
          onTap: () => _handleSocialSignUp('Apple'),
          color: Colors.black,
        ),
        const SizedBox(width: 18),
        _buildSocialButton(
          icon: Icons.g_mobiledata_rounded,
          onTap: () => _handleSocialSignUp('Google'),
          color: const Color(0xFFDB4437),
          iconSize: 30,
        ),
        const SizedBox(width: 18),
        _buildSocialButton(
          icon: Icons.facebook_rounded,
          onTap: () => _handleSocialSignUp('Facebook'),
          color: const Color(0xFF1877F2),
        ),
      ],
    );
  }

  /// Builds a single social sign up button.
  Widget _buildSocialButton({
    required IconData icon,
    required VoidCallback onTap,
    required Color color,
    double iconSize = 26,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.grey[300]!,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            icon,
            size: iconSize,
            color: color,
          ),
        ),
      ),
    );
  }

  /// Builds the login link at the bottom.
  Widget _buildLoginLink() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: GoogleFonts.inter(
          fontSize: 14,
          color: Colors.grey[700],
        ),
        children: [
          const TextSpan(
            text: 'Already have an account? ',
          ),
          TextSpan(
            text: 'Log In',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF2196F3),
              fontWeight: FontWeight.w600,
            ),
            recognizer: TapGestureRecognizer()..onTap = _handleLogin,
          ),
        ],
      ),
    );
  }
}
