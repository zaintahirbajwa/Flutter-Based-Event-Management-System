import 'package:flutter/material.dart';
import 'package:event_management_system/models/event_model.dart';
import 'package:event_management_system/utils/constants.dart';
import 'package:event_management_system/utils/theme.dart';
import 'package:event_management_system/utils/helpers.dart'; // Import Helpers class
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewEventsScreen extends StatefulWidget {
  const ViewEventsScreen({super.key});

  @override
  _ViewEventsScreenState createState() => _ViewEventsScreenState();
}

class _ViewEventsScreenState extends State<ViewEventsScreen> {
  List<EventModel> _availableEvents = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Load all available events from Firestore
  Future<void> _loadEvents() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('events').get();

      // Map Firestore documents to EventModel instances
      List<EventModel> events = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return EventModel(
          id: doc.id, // Firestore document ID
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
        _availableEvents = events;
      });
    } catch (error) {
      print("Error loading events: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading events. Please try again.")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.viewEventsTitle),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: _availableEvents.isEmpty
          ? const Center(
              child:
                  CircularProgressIndicator(), // Show loading spinner if no events
            )
          : ListView.builder(
              itemCount: _availableEvents.length,
              itemBuilder: (context, index) {
                final event = _availableEvents[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(
                      event.name,
                      style: AppTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '${AppConstants.eventDateLabel}: ${Helpers.formatDate(event.date)}', // Use Helpers.formatDate
                      style: AppTheme.textTheme.bodyMedium,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.info),
                      onPressed: () {
                        // Show event details on tap
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EventDetailsScreen(event: event),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class EventDetailsScreen extends StatelessWidget {
  final EventModel event;

  const EventDetailsScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event.name),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${AppConstants.eventDescriptionLabel}: ${event.description}',
              style: AppTheme.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              '${AppConstants.eventDateLabel}: ${Helpers.formatDate(event.date)}', // Use Helpers.formatDate
              style: AppTheme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Organizer: ${event.organizerName}',
              style: AppTheme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Contact: ${event.organizerContact}',
              style: AppTheme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
