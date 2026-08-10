import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Helper function for form validation
class Helpers {
  // Function to validate email format
  static String? validateEmail(String value) {
    String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  // Function to validate password
  static String? validatePassword(String value) {
    if (value.isEmpty) {
      return 'Password cannot be empty.';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters long.';
    }
    return null;
  }

  // Function to validate a non-empty field
  static String? validateField(String value) {
    if (value.isEmpty) {
      return 'This field cannot be empty.';
    }
    return null;
  }

  // Function to format a date into a specific format
  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  // Function to display a custom snackbar message
  static void showCustomSnackbar(BuildContext context, String message,
      {Color backgroundColor = Colors.black}) {
    final snackBar = SnackBar(
      content: Text(message, style: const TextStyle(color: Colors.white)),
      backgroundColor: backgroundColor,
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Function to check if a string is a valid number
  static bool isValidNumber(String value) {
    return double.tryParse(value) != null;
  }

  // Function to get the current date
  static String getCurrentDate() {
    DateTime now = DateTime.now();
    return DateFormat('yyyy-MM-dd').format(now);
  }

  // Function to convert a string to a title-case
  static String toTitleCase(String value) {
    return value
        .split(' ')
        .map((str) => str.isNotEmpty
            ? str[0].toUpperCase() + str.substring(1).toLowerCase()
            : '')
        .join(' ');
  }

  // Function to show a simple dialog with a message
  static Future<void> showDialogWithMessage(
      BuildContext context, String title, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Function to format a number into currency format
  static String formatCurrency(double value) {
    final formatter = NumberFormat.simpleCurrency(locale: 'en_US');
    return formatter.format(value);
  }
}
