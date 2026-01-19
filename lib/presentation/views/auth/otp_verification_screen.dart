// MSME Pathways - OTP Verification Screen
//
// Allows users to enter the 6-digit OTP sent to their email.
//
// Refactored to follow MVVM architecture with OTPVerificationViewModel.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../viewmodels/otp_verification_viewmodel.dart';

/// Primary accent color - green theme
const Color _kPrimaryColor = Color(0xFF3DBA6F);

/// OTP verification screen with 6-digit input.
///
/// Uses [OTPVerificationViewModel] for state management following MVVM pattern.
class OTPVerificationScreen extends StatelessWidget {
  const OTPVerificationScreen({
    super.key,
    this.email,
  });

  final String? email;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => OTPVerificationViewModel(
        authRepository: context.read<IAuthRepository>(),
        email: email ?? '',
      ),
      child: const _OTPVerificationContent(),
    );
  }
}

/// Internal content widget that consumes the ViewModel.
class _OTPVerificationContent extends StatefulWidget {
  const _OTPVerificationContent();

  @override
  State<_OTPVerificationContent> createState() => _OTPVerificationContentState();
}

class _OTPVerificationContentState extends State<_OTPVerificationContent> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String get _otp => _controllers.map((c) => c.text).join();

  void _handleVerifyOTP() {
    if (_otp.length != 6) {
      _showError('Please enter the complete 6-digit code');
      return;
    }
    context.read<OTPVerificationViewModel>().verifyOTP(_otp);
  }

  void _handleResendOTP() {
    final viewModel = context.read<OTPVerificationViewModel>();
    viewModel.resendOTP();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'OTP sent to ${viewModel.maskedEmail}',
          style: GoogleFonts.inter(),
        ),
        backgroundColor: _kPrimaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.inter(),
        ),
        backgroundColor: Colors.red[400],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: _kPrimaryColor,
          onPressed: () => context.pop(),
        ),
      ),
      body: Consumer<OTPVerificationViewModel>(
        builder: (context, viewModel, child) {
          // Handle navigation on success
          if (viewModel.isSuccess) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.push('/reset-password', extra: viewModel.email);
            });
          }

          // Show error snackbar
          if (viewModel.hasError) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showError(viewModel.errorMessage ?? 'Verification failed');
              viewModel.clearError();
            });
          }

          return SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: screenHeight * 0.05),

                  // Icon
                  Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: _kPrimaryColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.mark_email_read_outlined,
                        size: 50,
                        color: _kPrimaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Title
                  Text(
                    'Enter OTP',
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2D3748),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),

                  // Subtitle
                  Text(
                    'We\'ve sent a 6-digit code to\n${viewModel.maskedEmail}',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  // OTP input boxes
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(6, (index) {
                      return SizedBox(
                        width: 48,
                        child: TextFormField(
                          controller: _controllers[index],
                          focusNode: _focusNodes[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            counterText: '',
                            filled: true,
                            fillColor: const Color(0xFFF5F7FA),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: _kPrimaryColor,
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 16,
                            ),
                          ),
                          onChanged: (value) => _onChanged(value, index),
                          onTap: () {
                            _controllers[index].clear();
                          },
                          onEditingComplete: () {
                            if (index < 5) {
                              _focusNodes[index + 1].requestFocus();
                            } else {
                              _handleVerifyOTP();
                            }
                          },
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 32),

                  // Verify button
                  ElevatedButton(
                    onPressed: viewModel.isLoading ? null : _handleVerifyOTP,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _kPrimaryColor,
                      foregroundColor: Colors.white,
                      elevation: 4,
                      shadowColor: _kPrimaryColor.withValues(alpha: 0.4),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      disabledBackgroundColor: Colors.grey[300],
                    ),
                    child: viewModel.isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Text(
                            'Verify OTP',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                  const SizedBox(height: 32),

                  // Resend OTP
                  Center(
                    child: viewModel.canResend
                        ? TextButton(
                            onPressed: _handleResendOTP,
                            child: Text(
                              'Resend OTP',
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                color: _kPrimaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        : Text(
                            'Resend OTP in ${viewModel.resendCountdown} seconds',
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              color: Colors.grey[600],
                            ),
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
