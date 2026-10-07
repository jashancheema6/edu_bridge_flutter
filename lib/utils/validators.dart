// lib/helpers/validators.dart

class Validators {
  Validators._(); // Private constructor to prevent instantiation

  /// Validate email format
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required';
    }
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regex.hasMatch(email)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  /// Validate password (min 6 characters)
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }
    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  /// Validate name (not empty)
  static String? validateName(String? name) {
    if (name == null || name.trim().isEmpty) {
      return 'Name is required';
    }
    if (name.trim().length < 2) {
      return 'Name is too short';
    }
    return null;
  }

  /// Validate class or subject (not empty)
  static String? validateClassOrSubject(String? input) {
    if (input == null || input.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  /// Validate confirm password (matches original)
  static String? validateConfirmPassword(String? password, String? confirm) {
    if (confirm == null || confirm.isEmpty) {
      return 'Confirm your password';
    }
    if (password != confirm) {
      return 'Passwords do not match';
    }
    return null;
  }

  /// Optional: validate phone number
  static String? validatePhone(String? phone) {
    if (phone == null || phone.isEmpty) return 'Phone number required';
    final regex = RegExp(r'^\d{10}$');
    if (!regex.hasMatch(phone)) return 'Enter a valid 10-digit phone number';
    return null;
  }
}
