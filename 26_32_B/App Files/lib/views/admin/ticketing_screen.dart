import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:event_management_system/models/event_model.dart';
import 'package:event_management_system/services/firebase_storage_service.dart';
import 'package:event_management_system/utils/constants.dart';
import 'package:event_management_system/utils/theme.dart';

class AdminTicketingScreen extends StatefulWidget {
  const AdminTicketingScreen({super.key});

  @override
  _AdminTicketingScreenState createState() => _AdminTicketingScreenState();
}

class _AdminTicketingScreenState extends State<AdminTicketingScreen> {
  List<EventModel> _events = [];

  // FirebaseStorageService instance for fetching events from Firestore
  final FirestoreService _firebaseStorageService = FirestoreService();

  // Fetch events from Firebase Firestore to show ticketing details
  Future<void> _loadEvents() async {
    try {
      // Fetch events from Firestore using FirebaseStorageService
      final events = await _firebaseStorageService.getEvents(
          'events'); // Replace 'events' with your Firestore collection name
      setState(() {
        _events = events;
      });
    } catch (error) {
      // Handle any potential errors here
      print("Error loading events: $error");
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
        title: const Text(AppConstants.adminTicketingTitle),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: _events.isEmpty
          ? const Center(
              child: Text(
                AppConstants.noEventsAvailable,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : ListView.builder(
              itemCount: _events.length,
              itemBuilder: (context, index) {
                final event = _events[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(
                      event.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '${AppConstants.eventDateLabel}: ${DateFormat('MMM dd, yyyy').format(event.date)}',
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${event.ticketQuantity} ${AppConstants.ticketAvailableLabel}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${event.soldTickets} ${AppConstants.ticketSoldLabel}',
                          style: const TextStyle(color: Colors.green),
                        ),
                      ],
                    ),
                    onTap: () {
                      // On tap, navigate to ticket management or details
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TicketManagementScreen(event: event),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

class TicketManagementScreen extends StatelessWidget {
  final EventModel event;

  const TicketManagementScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.ticketManagementTitle),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              '${AppConstants.eventDateLabel}: ${DateFormat('MMM dd, yyyy').format(event.date)}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              '${AppConstants.ticketQuantityLabel}: ${event.ticketQuantity}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              '${AppConstants.soldTicketsLabel}: ${event.soldTickets}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement ticket selling or updating functionality here
              },
              child: const Text(AppConstants.updateTicketButton),
            ),
          ],
        ),
      ),
    );
  }
}
