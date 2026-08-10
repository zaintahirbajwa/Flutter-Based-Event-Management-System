import 'package:flutter/material.dart';
import 'package:event_management_system/models/event_model.dart';
import 'package:event_management_system/utils/constants.dart';
import 'package:event_management_system/utils/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserTicketingScreen extends StatefulWidget {
  const UserTicketingScreen({super.key});

  @override
  _UserTicketingScreenState createState() => _UserTicketingScreenState();
}

class _UserTicketingScreenState extends State<UserTicketingScreen> {
  List<EventModel> _availableEvents = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Load events registered by the admin
  Future<void> _loadAvailableEvents() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('events').get();

      // Map the Firestore documents to EventModel instances
      List<EventModel> events = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return EventModel(
          id: doc.id, // Firestore document ID as the event ID
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
      print("Error loading available events: $error");
    }
  }

  @override
  void initState() {
    super.initState();
    _loadAvailableEvents();
  }

  // Function to handle ticket purchase
  Future<void> _buyTicket(EventModel event) async {
    if (event.ticketQuantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppConstants.ticketPurchaseError)),
      );
      return;
    }

    // Update the ticketsSold field in Firestore
    try {
      await _firestore.collection('events').doc(event.id).update({
        'ticketsSold': event.soldTickets + 1, // Increment the ticketsSold field
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppConstants.ticketPurchaseSuccess)),
      );
      _loadAvailableEvents(); // Refresh the event list after purchase
    } catch (error) {
      print("Error purchasing ticket: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppConstants.ticketPurchaseError)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.ticketingTitle),
        backgroundColor:
            AppTheme.primaryColor, // Apply the primary color from theme
      ),
      body: _availableEvents.isEmpty
          ? Center(
              child: Text(
                AppConstants.noEventsAvailable,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.color, // Use theme-based text color
                ),
              ),
            )
          : ListView.builder(
              itemCount: _availableEvents.length,
              itemBuilder: (context, index) {
                final event = _availableEvents[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  color: Theme.of(context)
                      .cardColor, // Use theme for card background
                  child: ListTile(
                    title: Text(
                      event.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.color, // Apply theme for text color
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
                                ?.color, // Use theme for text color
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
                                ?.color, // Use theme for text color
                          ),
                        ),
                        Text(
                          'Contact: ${event.organizerContact}',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.color, // Use theme for text color
                          ),
                        ),
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        _buyTicket(event);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme
                            .primaryColor, // Apply the primary color from theme
                      ),
                      child: Text(
                        AppConstants.buyTicketButton,
                        style: TextStyle(
                          color: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.color, // Button text color based on theme
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
