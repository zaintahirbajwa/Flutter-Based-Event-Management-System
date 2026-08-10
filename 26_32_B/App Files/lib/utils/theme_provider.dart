import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _currentTheme;

  // Constructor to initialize _currentTheme
  ThemeProvider({required ThemeMode currentTheme}) : _currentTheme = currentTheme;

  ThemeMode get currentTheme => _currentTheme;

  bool get isDarkMode => _currentTheme == ThemeMode.dark;

  // Toggle between light and dark modes
  void toggleTheme() {
    if (_currentTheme == ThemeMode.dark) {
      _currentTheme = ThemeMode.light;
    } else {
      _currentTheme = ThemeMode.dark;
    }
    notifyListeners(); // Notify listeners to update the theme
  }

  // Set dark mode
  void setDarkMode() {
    _currentTheme = ThemeMode.dark;
    notifyListeners(); // Notify listeners to update the theme
  }

  // Set light mode
  void setLightMode() {
    _currentTheme = ThemeMode.light;
    notifyListeners(); // Notify listeners to update the theme
  }

  // Set system default mode
  void setSystemMode() {
    _currentTheme = ThemeMode.system;
    notifyListeners(); // Notify listeners to update the theme
  }
}
