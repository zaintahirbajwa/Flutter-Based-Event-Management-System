import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:event_management_system/models/event_model.dart';
import 'package:event_management_system/services/firebase_storage_service.dart';
import 'package:event_management_system/utils/constants.dart';
import 'package:event_management_system/utils/theme.dart';

class EventScheduleScreen extends StatefulWidget {
  const EventScheduleScreen({super.key});

  @override
  _EventScheduleScreenState createState() => _EventScheduleScreenState();
}

class _EventScheduleScreenState extends State<EventScheduleScreen> {
  List<EventModel> _events = [];
  bool _isLoading = true;
  String? _errorMessage;

  // FirebaseStorageService instance for fetching events from Firestore
  final FirestoreService _firebaseStorageService = FirestoreService();

  // Load events method
  Future<void> _loadEvents() async {
    try {
      // Fetch events from Firestore using FirestoreService
      final events = await _firebaseStorageService
          .getAvailableEvents(); // Fetch from 'availableEvents' collection
      setState(() {
        _events = events;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _errorMessage = 'Failed to load events. Please try again later.';
        _isLoading = false;
      });
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
        title: const Text(AppConstants.eventScheduleTitle),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : _events.isEmpty
                  ? const Center(
                      child: Text(
                        AppConstants.noEventsScheduled,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
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
                            trailing: const Icon(Icons.arrow_forward),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/eventDetails',
                                arguments: event,
                              );
                            },
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
        title: const Text(AppConstants.eventDetailsTitle),
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
              '${AppConstants.eventDescriptionLabel}: ${event.description.isEmpty ? 'No description available' : event.description}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Text(
              '${AppConstants.eventDateLabel}: ${DateFormat('MMM dd, yyyy').format(event.date)}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Text(
              '${AppConstants.ticketQuantityLabel}: ${event.totalTickets}',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
