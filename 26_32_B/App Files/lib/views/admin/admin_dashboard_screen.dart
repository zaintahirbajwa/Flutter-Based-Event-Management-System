import 'package:flutter/material.dart';
import 'package:event_management_system/views/admin/event_registration_screen.dart';
import 'package:event_management_system/views/admin/event_schedule_screen.dart';
import 'package:event_management_system/views/admin/ticketing_screen.dart'; // Correct import for Admin Ticketing Screen
import 'package:event_management_system/views/common/chat_screen.dart';
import 'package:event_management_system/views/common/settings_screen.dart';
import 'package:event_management_system/utils/theme.dart';
import 'package:provider/provider.dart';
import 'package:event_management_system/utils/theme_provider.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  // Function to determine the greeting based on the time of the day
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'Good Morning';
    } else if (hour >= 12 && hour < 17) {
      return 'Good Afternoon';
    } else if (hour >= 17 && hour < 20) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(
        context); // Access theme provider to get current theme

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: AppTheme.primaryColor, // Use primary color from theme
      ),
      body: SingleChildScrollView(
        // Make the body scrollable
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Time-based greeting message
            Center(
              child: Text(
                '${_getGreeting()} Dr. Hashmi!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: themeProvider.isDarkMode
                      ? Colors.white // White in dark mode
                      : Colors.black, // Black in light mode
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Subtitle
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'What would you like to do?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: themeProvider.isDarkMode
                      ? Colors.grey[400] // Light grey in dark mode
                      : Colors.grey[700], // Dark grey in light mode
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Event Registration Button
            _buildDashboardButton(
              context,
              'Events Registration',
              const EventRegistrationScreen(),
              Icons.add_circle_outline, // Example icon
            ),
            const SizedBox(height: 20),

            // Event Schedule Button
            _buildDashboardButton(
              context,
              'Events Schedule',
              const EventScheduleScreen(),
              Icons.calendar_today_outlined, // Example icon
            ),
            const SizedBox(height: 20),

            // Ticketing Button
            _buildDashboardButton(
              context,
              'Events Ticketing',
              const AdminTicketingScreen(),
              Icons.confirmation_number_outlined, // Example icon
            ),
            const SizedBox(height: 20),

            // Chat Button
            _buildDashboardButton(
              context,
              'Chat Bot',
              const ChatScreen(),
              Icons.chat_bubble_outline, // Example icon
            ),
            const SizedBox(height: 20),

            // Settings Button
            _buildDashboardButton(
              context,
              'Settings',
              const SettingsScreen(),
              Icons.settings, // Example icon
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build buttons with icons
  Widget _buildDashboardButton(
      BuildContext context, String text, Widget destination, IconData icon) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => destination),
        );
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: AppTheme.primaryColor, // Use primary color from theme
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(12), // Rounded corners for buttons
        ),
        elevation: 5, // Add elevation for button shadow effect
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white), // Add icon to button
          const SizedBox(width: 10), // Space between icon and text
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
