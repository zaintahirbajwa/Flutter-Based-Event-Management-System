import 'package:flutter/material.dart';

class AppTheme {
  // Define primary colors for the app
  static const Color primaryColor = Color(0xFF007BFF); // Light Mode Primary Blue
  static const Color secondaryColor = Color(0xFF0056b3); // Light Mode Secondary Blue
  static const Color backgroundColor = Colors.white; // Light background (Pure white)
  static const Color darkBackgroundColor = Color(0xFF121212); // Dark background for dark mode

  // Text themes with normal font weight
  static TextTheme textTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 30.0,
      fontWeight: FontWeight.normal, // Changed to normal
      color: Colors.black,
    ),
    displayMedium: TextStyle(
      fontSize: 28.0,
      fontWeight: FontWeight.normal, // Changed to normal
      color: Colors.black87,
    ),
    bodyLarge: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.normal, // Changed to normal
      color: Colors.black87,
    ),
    bodyMedium: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.normal, // Changed to normal
      color: Colors.black45,
    ),
    labelLarge: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.normal, // Changed to normal
      color: Colors.white,
    ),
    titleMedium: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.normal, // Changed to normal
      color: Colors.white,
    ),
    titleLarge: TextStyle(
      fontSize: 22.0,
      fontWeight: FontWeight.normal, // Changed to normal
      color: Colors.white,
    ),
  );

  // Define dark mode theme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.black,
    scaffoldBackgroundColor: darkBackgroundColor,
    textTheme: textTheme.copyWith(
      displayLarge: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.normal, // Changed to normal
      ),
      displayMedium: const TextStyle(
        color: Colors.white70,
        fontWeight: FontWeight.normal, // Changed to normal
      ),
      bodyLarge: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.normal, // Changed to normal
      ),
      bodyMedium: const TextStyle(
        color: Colors.white60,
        fontWeight: FontWeight.normal, // Changed to normal
      ),
      labelLarge: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.normal, // Changed to normal
      ),
      titleMedium: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.normal, // Changed to normal
      ),
      titleLarge: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.normal, // Changed to normal
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontWeight: FontWeight.normal, // Changed to normal
      ),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: Colors.white,
      textTheme: ButtonTextTheme.primary,
    ),
    cardColor: Color(0xFF2C2C2C),
    colorScheme: const ColorScheme.dark(
      surface: darkBackgroundColor,
      onSurface: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.white.withOpacity(0.5),
        ),
      ),
    ),
  );

  // Define light mode theme
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor, // Pure white background
    textTheme: textTheme.copyWith(
      displayLarge: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.normal, // Changed to normal
      ),
      displayMedium: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.normal, // Changed to normal
      ),
      bodyLarge: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.normal, // Changed to normal
      ),
      bodyMedium: const TextStyle(
        color: Colors.black45,
        fontWeight: FontWeight.normal, // Changed to normal
      ),
      labelLarge: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.normal, // Changed to normal
      ),
      titleMedium: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.normal, // Changed to normal
      ),
      titleLarge: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.normal, // Changed to normal
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontWeight: FontWeight.normal, // Changed to normal
      ),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: primaryColor,
      textTheme: ButtonTextTheme.primary,
    ),
    cardColor: Colors.white,
    colorScheme: const ColorScheme.light(
      surface: backgroundColor,
    ),
  );

  // Method to get the current theme based on dark mode preference
  static ThemeData getAppTheme(bool isDarkMode) {
    return isDarkMode ? darkTheme : lightTheme;
  }

  // Custom font theme (Poppins)
  static const TextStyle customFontStyle = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.normal, // Changed to normal
  );
}
