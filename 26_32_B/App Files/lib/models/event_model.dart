import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  final String id; // Unique ID for the event
  final String name; // Name of the event
  final String description; // Description of the event
  final DateTime date; // Date and time of the event
  final String location; // Location of the event
  final int totalTickets; // Total number of tickets available
  final int ticketsSold; // Number of tickets sold
  final String organizerName; // Name of the event organizer
  final String organizerContact; // Contact information of the event organizer

  // Constructor to initialize all parameters
  EventModel({
    required this.id,
    required this.name,
    required this.description,
    required this.date,
    required this.location,
    required this.totalTickets,
    required this.ticketsSold,
    required this.organizerName,
    required this.organizerContact,
  });

  // Converts EventModel to a Map for Firestore storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'date': Timestamp.fromDate(date), // Store as Firebase Timestamp
      'location': location,
      'totalTickets': totalTickets,
      'ticketsSold': ticketsSold,
      'organizerName': organizerName,
      'organizerContact': organizerContact,
    };
  }

  // Creates an EventModel from a Firestore document map
  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      date:
          (json['date'] as Timestamp).toDate(), // Convert Timestamp to DateTime
      location: json['location'],
      totalTickets: json['totalTickets'],
      ticketsSold: json['ticketsSold'],
      organizerName: json['organizerName'],
      organizerContact: json['organizerContact'],
    );
  }

  // Optional: Method to update ticketsSold when a ticket is purchased
  EventModel withUpdatedTicketsSold(int newTicketsSold) {
    return EventModel(
      id: id,
      name: name,
      description: description,
      date: date,
      location: location,
      totalTickets: totalTickets,
      ticketsSold: newTicketsSold,
      organizerName: organizerName,
      organizerContact: organizerContact,
    );
  }

  // Getter for sold tickets
  int get soldTickets => ticketsSold;

  // Getter for ticket quantity (remaining tickets)
  int get ticketQuantity => totalTickets - ticketsSold;
}
