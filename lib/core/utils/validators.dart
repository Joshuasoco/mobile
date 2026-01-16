/// MSME Pathways - Validators
///
/// Centralized validation logic for form fields.
/// Extracted from UI components for reuse and testing.
library;

/// Validation utility class with static methods.
///
/// Provides validation for:
/// - Email addresses
/// - Passwords (with strength requirements)
/// - Phone numbers (Philippine format)
/// - Names
/// - OTP codes
abstract final class Validators {
  // ============================================================
  // EMAIL VALIDATION
  // ============================================================

  /// Regular expression for email validation.
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  /// Checks if the email format is valid.
  static bool isValidEmail(String email) {
    if (email.isEmpty) return false;
    return _emailRegex.hasMatch(email.trim());
  }

  /// Returns error message if email is invalid, null if valid.
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required';
    }
    if (!isValidEmail(email)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  // ============================================================
  // PASSWORD VALIDATION
  // ============================================================

  /// Minimum password length.
  static const int minPasswordLength = 6;

  /// Checks if password meets minimum requirements.
  static bool isValidPassword(String password) {
    return password.length >= minPasswordLength;
  }

  /// Checks password strength (returns 0-4 score).
  ///
  /// - 0: Very weak (too short)
  /// - 1: Weak (meets minimum length)
  /// - 2: Fair (has letters and numbers)
  /// - 3: Good (has mixed case)
  /// - 4: Strong (has special characters)
  static int getPasswordStrength(String password) {
    if (password.length < minPasswordLength) return 0;

    int score = 1;

    // Has both letters and numbers
    if (RegExp(r'[a-zA-Z]').hasMatch(password) &&
        RegExp(r'[0-9]').hasMatch(password)) {
      score++;
    }

    // Has mixed case
    if (RegExp(r'[a-z]').hasMatch(password) &&
        RegExp(r'[A-Z]').hasMatch(password)) {
      score++;
    }

    // Has special characters
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      score++;
    }

    return score;
  }

  /// Returns error message if password is invalid, null if valid.
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }
    if (password.length < minPasswordLength) {
      return 'Password must be at least $minPasswordLength characters';
    }
    return null;
  }

  /// Validates password confirmation matches.
  static String? validateConfirmPassword(String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Please confirm your password';
    }
    if (password != confirmPassword) {
      return 'Passwords do not match';
    }
    return null;
  }

  // ============================================================
  // PHONE NUMBER VALIDATION
  // ============================================================

  /// Philippine mobile number regex (09XX or +639XX format).
  static final RegExp _phoneRegex = RegExp(
    r'^(\+63|0)9[0-9]{9}$',
  );

  /// Checks if phone number is valid (Philippine format).
  static bool isValidPhoneNumber(String phone) {
    if (phone.isEmpty) return false;
    // Remove spaces and dashes
    final cleanPhone = phone.replaceAll(RegExp(r'[\s-]'), '');
    return _phoneRegex.hasMatch(cleanPhone);
  }

  /// Returns error message if phone is invalid, null if valid.
  static String? validatePhoneNumber(String? phone) {
    if (phone == null || phone.isEmpty) {
      return 'Phone number is required';
    }
    if (!isValidPhoneNumber(phone)) {
      return 'Please enter a valid Philippine mobile number';
    }
    return null;
  }

  // ============================================================
  // NAME VALIDATION
  // ============================================================

  /// Minimum name length.
  static const int minNameLength = 2;

  /// Maximum name length.
  static const int maxNameLength = 100;

  /// Checks if name is valid.
  static bool isValidName(String name) {
    final trimmed = name.trim();
    return trimmed.length >= minNameLength && trimmed.length <= maxNameLength;
  }

  /// Returns error message if name is invalid, null if valid.
  static String? validateName(String? name) {
    if (name == null || name.trim().isEmpty) {
      return 'Name is required';
    }
    if (name.trim().length < minNameLength) {
      return 'Name must be at least $minNameLength characters';
    }
    if (name.trim().length > maxNameLength) {
      return 'Name must be less than $maxNameLength characters';
    }
    return null;
  }

  // ============================================================
  // OTP VALIDATION
  // ============================================================

  /// Standard OTP length.
  static const int otpLength = 6;

  /// Checks if OTP format is valid.
  static bool isValidOTP(String otp) {
    if (otp.length != otpLength) return false;
    return RegExp(r'^[0-9]+$').hasMatch(otp);
  }

  /// Returns error message if OTP is invalid, null if valid.
  static String? validateOTP(String? otp) {
    if (otp == null || otp.isEmpty) {
      return 'OTP is required';
    }
    if (otp.length != otpLength) {
      return 'OTP must be $otpLength digits';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(otp)) {
      return 'OTP must contain only numbers';
    }
    return null;
  }

  // ============================================================
  // GENERAL UTILITIES
  // ============================================================

  /// Checks if a string is not null and not empty.
  static bool isNotEmpty(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  /// Returns error message if required field is empty.
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }
}
