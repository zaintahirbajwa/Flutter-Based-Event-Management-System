import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:event_management_system/utils/theme.dart';
import 'package:event_management_system/views/auth/login_screen.dart';
import 'package:event_management_system/utils/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Method to change language (Placeholder for future implementation)
    void changeLanguage(String? newLanguage) {
      if (newLanguage != null) {
        // Implement your language change logic here
        print('Language changed to $newLanguage');
      }
    }

    // Confirm logout dialog
    Future<void> confirmLogout() async {
      final bool? confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Logout Confirmation'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Logout'),
            ),
          ],
        ),
      );

      if (confirm == true) {
        try {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const LoginScreen(),
            ),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Logout failed. Please try again."),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Language selection button
            ElevatedButton(
              onPressed: () async {
                final String? selectedLanguage = await showDialog<String>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Select Language'),
                    content: SingleChildScrollView(
                      child: Column(
                        children: <String>['English', 'Spanish', 'French', 'German']
                            .map((language) {
                          return ListTile(
                            title: Text(language),
                            onTap: () {
                              Navigator.of(context).pop(language);
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                );
                if (selectedLanguage != null) {
                  changeLanguage(selectedLanguage);  // Use the changeLanguage method
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: themeProvider.isDarkMode
                    ? Colors.grey[900] // Match dark mode background
                    : Colors.white, // Match light mode background
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: AppTheme.primaryColor), // Blue border
                ),
                elevation: 0, // No shadow
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Language',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.primaryColor, // Blue text color
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: AppTheme.primaryColor, // Blue icon color
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // App Appearance button
            ElevatedButton(
              onPressed: () async {
                // Show theme selection dialog
                final String? selectedTheme = await showDialog<String>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Select Appearance'),
                    content: SingleChildScrollView(
                      child: Column(
                        children: <String>['Light Mode', 'Dark Mode', 'System Default Mode']
                            .map((theme) {
                          return ListTile(
                            title: Text(theme),
                            onTap: () {
                              Navigator.of(context).pop(theme);
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                );
                if (selectedTheme != null) {
                  switch (selectedTheme) {
                    case 'Light Mode':
                      themeProvider.setLightMode();
                      break;
                    case 'Dark Mode':
                      themeProvider.setDarkMode();
                      break;
                    case 'System Default Mode':
                      themeProvider.setSystemMode();
                      break;
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: themeProvider.isDarkMode
                    ? Colors.grey[900] // Match dark mode background
                    : Colors.white, // Match light mode background
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: AppTheme.primaryColor), // Blue border
                ),
                elevation: 0, // No shadow
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'App Appearance',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.primaryColor, // Blue text color
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: AppTheme.primaryColor, // Blue icon color
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Logout Button
            ElevatedButton(
              onPressed: confirmLogout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
              ),
              child: const Text(
                'Logout',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
