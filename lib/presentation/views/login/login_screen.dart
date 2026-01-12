/// MSME Pathways - Modern Login Screen
///
/// A premium login screen with full-screen background, gradient overlay,
/// form fields, and social login options.

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

/// Primary accent color - teal/green theme
const Color _kPrimaryColor = Color(0xFF00897B);

/// Login screen with full-screen background and modern UI elements.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      // Navigate to home on successful login
      context.go('/home');
    }
  }

  void _handleForgotPassword() {
    context.push('/forgot-password');
  }

  void _handleSignUp() {
    context.go('/signup');
  }

  void _handleSocialLogin(String provider) {
    // TODO: Implement social login
    debugPrint('$provider login pressed');
  }

  void _handleTerms() {
    // TODO: Navigate to terms
    debugPrint('Terms pressed');
  }

  void _handlePrivacyPolicy() {
    // TODO: Navigate to privacy policy
    debugPrint('Privacy policy pressed');
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
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
                    
                    // Login card at bottom
                    _buildLoginCard(screenWidth, bottomPadding),
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
      padding: EdgeInsets.only(top: screenHeight * 0.08),
      child: Column(
        children: [
          // Logo icon container
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: _kPrimaryColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: _kPrimaryColor.withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.storefront_rounded,
              size: 44,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          // App title
          Text(
            'MSME PATHWAYS',
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 2,
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

  /// Builds the login card container with form elements.
  Widget _buildLoginCard(double screenWidth, double bottomPadding) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(
        top: 24,
      ),
      padding: EdgeInsets.fromLTRB(24, 32, 24, bottomPadding > 0 ? bottomPadding + 24 : 24),
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
            const SizedBox(height: 16),
            _buildPasswordField(),
            const SizedBox(height: 12),
            
            // Remember me & Forgot password row
            _buildRememberForgotRow(),
            const SizedBox(height: 24),
            
            // Login button
            _buildLoginButton(),
            const SizedBox(height: 16),
            
            // Terms text
            _buildTermsText(),
            const SizedBox(height: 24),
            
            // Divider with "or Log in with"
            _buildDivider(),
            const SizedBox(height: 20),
            
            // Social login icons
            _buildSocialLoginRow(),
            const SizedBox(height: 24),
            
            // Sign up link
            _buildSignUpLink(),
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
      style: GoogleFonts.inter(fontSize: 16),
      decoration: InputDecoration(
        hintText: 'Full Name',
        hintStyle: GoogleFonts.inter(
          color: Colors.grey[500],
          fontSize: 16,
        ),
        prefixIcon: Icon(
          Icons.person_outline_rounded,
          color: Colors.grey[600],
        ),
        filled: true,
        fillColor: const Color(0xFFF5F7FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: _kPrimaryColor,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email is required';
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
      textInputAction: TextInputAction.done,
      style: GoogleFonts.inter(fontSize: 16),
      onFieldSubmitted: (_) => _handleLogin(),
      decoration: InputDecoration(
        hintText: 'Password',
        hintStyle: GoogleFonts.inter(
          color: Colors.grey[500],
          fontSize: 16,
        ),
        prefixIcon: Icon(
          Icons.lock_outline_rounded,
          color: Colors.grey[600],
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: Colors.grey[600],
          ),
          onPressed: _togglePasswordVisibility,
        ),
        filled: true,
        fillColor: const Color(0xFFF5F7FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: _kPrimaryColor,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }

  /// Builds the remember me checkbox and forgot password row.
  Widget _buildRememberForgotRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Remember me checkbox
        Row(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: _rememberMe,
                onChanged: (value) {
                  setState(() {
                    _rememberMe = value ?? false;
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
            const SizedBox(width: 8),
            Text(
              'Remember me',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        
        // Forgot password - improved responsiveness
        InkWell(
          onTap: _handleForgotPassword,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Text(
              'Forget Password?',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: _kPrimaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the main login button.
  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: _handleLogin,
      style: ElevatedButton.styleFrom(
        backgroundColor: _kPrimaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        shadowColor: _kPrimaryColor.withValues(alpha: 0.4),
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Text(
        'Log In',
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Builds the terms and privacy policy text.
  Widget _buildTermsText() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: GoogleFonts.inter(
          fontSize: 12,
          color: Colors.grey[600],
          height: 1.5,
        ),
        children: [
          const TextSpan(
            text: 'By continuing you agree to our ',
          ),
          TextSpan(
            text: 'Terms',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: _kPrimaryColor,
              fontWeight: FontWeight.w600,
            ),
            recognizer: TapGestureRecognizer()..onTap = _handleTerms,
          ),
          const TextSpan(
            text: ' and acknowledge that you have read our ',
          ),
          TextSpan(
            text: 'Privacy Policy',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: _kPrimaryColor,
              fontWeight: FontWeight.w600,
            ),
            recognizer: TapGestureRecognizer()..onTap = _handlePrivacyPolicy,
          ),
        ],
      ),
    );
  }

  /// Builds the divider with "or Log in with" text.
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
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'or Log in with',
            style: GoogleFonts.inter(
              fontSize: 14,
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

  /// Builds the social login icons row.
  Widget _buildSocialLoginRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialButton(
          icon: Icons.apple,
          onTap: () => _handleSocialLogin('Apple'),
          color: Colors.black,
        ),
        const SizedBox(width: 20),
        _buildSocialButton(
          icon: Icons.g_mobiledata_rounded,
          onTap: () => _handleSocialLogin('Google'),
          color: const Color(0xFFDB4437),
          iconSize: 32,
        ),
        const SizedBox(width: 20),
        _buildSocialButton(
          icon: Icons.facebook_rounded,
          onTap: () => _handleSocialLogin('Facebook'),
          color: const Color(0xFF1877F2),
        ),
      ],
    );
  }

  /// Builds a single social login button.
  Widget _buildSocialButton({
    required IconData icon,
    required VoidCallback onTap,
    required Color color,
    double iconSize = 28,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.grey[300]!,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                blurRadius: 8,
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

  /// Builds the sign up link at the bottom.
  Widget _buildSignUpLink() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: GoogleFonts.inter(
          fontSize: 15,
          color: Colors.grey[700],
        ),
        children: [
          const TextSpan(
            text: "Don't have an account? ",
          ),
          TextSpan(
            text: 'Sign up',
            style: GoogleFonts.inter(
              fontSize: 15,
              color: const Color(0xFF2196F3),
              fontWeight: FontWeight.w600,
            ),
            recognizer: TapGestureRecognizer()..onTap = _handleSignUp,
          ),
        ],
      ),
    );
  }
}
