import 'package:flutter/material.dart';
import 'package:event_management_system/views/user/user_schedule_screen.dart';
import 'package:event_management_system/views/user/view_events_screen.dart';
import 'package:event_management_system/views/user/user_ticketing_screen.dart'; // Import the ticketing screen
import 'package:event_management_system/views/common/chat_screen.dart';
import 'package:event_management_system/views/common/settings_screen.dart';
import 'package:event_management_system/utils/theme.dart';
import 'package:provider/provider.dart';
import 'package:event_management_system/utils/theme_provider.dart';

class UserDashboardScreen extends StatelessWidget {
  const UserDashboardScreen({super.key});

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
        title: const Text('User Dashboard'),
        backgroundColor: AppTheme.primaryColor, // Use primary color from theme
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Time-based greeting message
            Center(
              child: Text(
                '${_getGreeting()}!',
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

            // Subtitle for the dashboard
            Text(
              'What would you like to do?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: themeProvider.isDarkMode
                    ? Colors.grey // Gray in dark mode
                    : Colors.black54, // Gray in light mode
              ),
            ),
            const SizedBox(height: 20),

            // User actions buttons with icons
            _buildDashboardButton(
              context,
              'Scheduled Events',
              const UserScheduleScreen(),
              Icons.calendar_today_outlined, // Icon for scheduled events
            ),
            const SizedBox(height: 20),

            _buildDashboardButton(
              context,
              'Available Events',
              const ViewEventsScreen(),
              Icons.event_note_outlined, // Icon for available events
            ),
            const SizedBox(height: 20),

            // Added Ticketing Screen button
            _buildDashboardButton(
              context,
              'My Tickets',
              const UserTicketingScreen(),
              Icons.confirmation_number_outlined, // Icon for ticketing
            ),
            const SizedBox(height: 20),

            // Common actions buttons with icons
            _buildDashboardButton(
              context,
              'Chat Bot',
              const ChatScreen(),
              Icons.chat_bubble_outline, // Icon for chat bot
            ),
            const SizedBox(height: 20),

            _buildDashboardButton(
              context,
              'Settings',
              const SettingsScreen(),
              Icons.settings, // Icon for settings
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
