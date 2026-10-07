// lib/helpers/helpers.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Helpers {
  Helpers._(); // private constructor to prevent instantiation

  /// Show a SnackBar message
  static void showSnackBar(BuildContext context, String message,
      {Color backgroundColor = Colors.indigo}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Format DateTime to readable string (e.g., "3 Dec 2025, 10:45 AM")
  static String formatDateTime(DateTime? dt, {String format = 'd MMM yyyy, h:mm a'}) {
    if (dt == null) return '';
    return DateFormat(format).format(dt);
  }

  /// Simple email validation
  static bool isValidEmail(String email) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  /// Simple password validation (min 6 chars)
  static bool isValidPassword(String password) {
    return password.length >= 6;
  }

  /// Convert Firestore timestamp to DateTime safely
  static DateTime? timestampToDateTime(dynamic timestamp) {
    if (timestamp == null) return null;
    if (timestamp is DateTime) return timestamp;
    if (timestamp is int) return DateTime.fromMillisecondsSinceEpoch(timestamp);
    if (timestamp is String) return DateTime.tryParse(timestamp);
    if (timestamp is Map && timestamp['_seconds'] != null) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp['_seconds'] * 1000);
    }
    return null;
  }

  /// Capitalize first letter
  static String capitalize(String s) {
    if (s.isEmpty) return '';
    return s[0].toUpperCase() + s.substring(1);
  }
}
