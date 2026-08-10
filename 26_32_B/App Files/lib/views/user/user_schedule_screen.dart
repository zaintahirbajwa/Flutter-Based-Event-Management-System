import 'package:flutter/material.dart';
import 'package:event_management_system/models/event_model.dart';
import 'package:event_management_system/utils/constants.dart';
import 'package:event_management_system/utils/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_management_system/services/auth_service.dart';

class UserScheduleScreen extends StatefulWidget {
  const UserScheduleScreen({super.key});

  @override
  _UserScheduleScreenState createState() => _UserScheduleScreenState();
}

class _UserScheduleScreenState extends State<UserScheduleScreen> {
  List<EventModel> _userEvents = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();

  // Fetch events that the user has tickets for from Firestore
  Future<void> _loadUserEvents() async {
    // Get the current user's ID
    String? userId = await _authService.getCurrentUserId();

    if (userId!.isEmpty) {
      // Handle case when user is not logged in or no user ID is available
      return;
    }

    try {
      // Fetch user events from Firestore
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('events') // Assuming events are stored here
          .get();

      // Map Firestore data to EventModel
      List<EventModel> events = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return EventModel(
          id: doc.id, // Use the Firestore document ID as the event ID
          name: data['name'] ?? '',
          description: data['description'] ?? '',
          date: (data['date'] as Timestamp).toDate(),
          location: data['location'] ?? '',
          totalTickets: data['totalTickets'] ?? 0,
          ticketsSold: data['ticketsSold'] ?? 0,
          organizerName: data['organizerName'] ?? '', // Fetch organizer name
          organizerContact:
              data['organizerContact'] ?? '', // Fetch organizer contact
        );
      }).toList();

      setState(() {
        _userEvents = events;
      });
    } catch (error) {
      print("Error loading user events: $error");
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.userScheduleTitle),
        backgroundColor: AppTheme.primaryColor, // Apply theme primary color
      ),
      body: _userEvents.isEmpty
          ? Center(
              child: Text(
                AppConstants.noTicketsBooked,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.color, // Use theme text color
                ),
              ),
            )
          : ListView.builder(
              itemCount: _userEvents.length,
              itemBuilder: (context, index) {
                final event = _userEvents[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  color: Theme.of(context).cardColor, // Use theme card color
                  child: ListTile(
                    title: Text(
                      event.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.color, // Use theme for text color
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${AppConstants.eventDateLabel}: ${event.date.toLocal()}'
                              .split(' ')[0],
                          style: TextStyle(
                            color: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.color, // Theme-based text color
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Organizer: ${event.organizerName}',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.color, // Theme-based text color
                          ),
                        ),
                        Text(
                          'Contact: ${event.organizerContact}',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.color, // Theme-based text color
                          ),
                        ),
                      ],
                    ),
                    trailing: Text(
                      '${event.soldTickets} ${AppConstants.ticketBookedLabel}',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      // You can add functionality to view details about the event or manage ticket details here
                    },
                  ),
                );
              },
            ),
    );
  }
}
