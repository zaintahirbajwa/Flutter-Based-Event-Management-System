import 'package:flutter/material.dart';
import 'package:event_management_system/views/auth/login_screen.dart';
import 'package:event_management_system/views/admin/event_registration_screen.dart';
import 'package:event_management_system/views/admin/event_schedule_screen.dart'; // Corrected admin schedule path
import 'package:event_management_system/views/user/user_schedule_screen.dart';
import 'package:event_management_system/views/admin/ticketing_screen.dart'; // Corrected ticketing screen import
import 'package:event_management_system/views/user/user_ticketing_screen.dart';
import 'package:event_management_system/views/common/chat_screen.dart';
import 'package:event_management_system/views/common/settings_screen.dart';

class Routes {
  // Define route names for easy navigation throughout the app
  static const String login = '/login';
  static const String eventRegistration = '/eventRegistration';
  static const String adminSchedule = '/adminSchedule';
  static const String userSchedule = '/userSchedule';
  static const String adminTicketing = '/adminTicketing';
  static const String userTicketing = '/userTicketing';
  static const String chat = '/chat';
  static const String settings = '/settings';

  // Generates route based on the route name
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Correctly use settings.name in the switch statement
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/eventRegistration':
        return MaterialPageRoute(
            builder: (_) => const EventRegistrationScreen());
      case '/adminSchedule':
        return MaterialPageRoute(
            builder: (_) =>
                const EventScheduleScreen()); // Corrected route for admin schedule
      case '/userSchedule':
        return MaterialPageRoute(builder: (_) => const UserScheduleScreen());
      case '/adminTicketing':
        return MaterialPageRoute(builder: (_) => const AdminTicketingScreen());
      case '/userTicketing':
        return MaterialPageRoute(builder: (_) => const UserTicketingScreen());
      case '/chat':
        return MaterialPageRoute(builder: (_) => const ChatScreen());
      case '/settings':
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      default:
        return MaterialPageRoute(
            builder: (_) => const LoginScreen()); // Default route if no match
    }
  }
}
