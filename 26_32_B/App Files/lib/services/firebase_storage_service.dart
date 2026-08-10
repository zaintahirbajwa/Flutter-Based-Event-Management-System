import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_management_system/models/event_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Singleton pattern to ensure one instance of this service is used
  static final FirestoreService _instance = FirestoreService._internal();

  factory FirestoreService() {
    return _instance;
  }

  FirestoreService._internal();

  // Collection reference for events in Firestore
  CollectionReference get _eventsCollection => _firestore.collection('events');
  CollectionReference get _userEventsCollection =>
      _firestore.collection('userEvents');
  CollectionReference get _availableEventsCollection =>
      _firestore.collection('availableEvents');

  // Method to get all events from a collection (user or available)
  Future<List<EventModel>> getEvents(String collection) async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection(collection).get();
      return querySnapshot.docs.map((doc) {
        return EventModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Method to get user events
  Future<List<EventModel>> getUserEvents() async {
    return await getEvents('userEvents');
  }

  // Method to save user events (adding multiple events)
  Future<void> saveUserEvents(List<EventModel> events) async {
    try {
      for (var event in events) {
        await _userEventsCollection.add(event.toJson());
      }
    } catch (e) {
      rethrow;
    }
  }

  // Method to save a single event (available event)
  Future<void> saveEvent(EventModel event) async {
    try {
      await _availableEventsCollection
          .add(event.toJson()); // Save event to availableEvents collection
    } catch (e) {
      rethrow;
    }
  }

  // Method to get available events
  Future<List<EventModel>> getAvailableEvents() async {
    return await getEvents('availableEvents');
  }

  // Method to save available events (adding multiple events)
  Future<void> saveAvailableEvents(List<EventModel> events) async {
    try {
      // Clear existing available events and add new ones
      await _availableEventsCollection.get().then((snapshot) {
        for (var doc in snapshot.docs) {
          doc.reference.delete(); // Delete old events
        }
      });

      for (var event in events) {
        await _availableEventsCollection.add(event.toJson());
      }
    } catch (e) {
      rethrow;
    }
  }

  // Method to buy a ticket for an event
  Future<bool> buyTicket(EventModel event) async {
    try {
      // Fetch the event from Firestore
      var eventDoc = await _availableEventsCollection
          .where('id', isEqualTo: event.id)
          .get();

      if (eventDoc.docs.isEmpty) {
        return false; // Event not found
      }

      // Explicitly cast to Map<String, dynamic> to resolve the type issue
      var existingEvent = EventModel.fromJson(
          eventDoc.docs.first.data() as Map<String, dynamic>);

      // Check if tickets are available
      if (existingEvent.ticketsSold < existingEvent.totalTickets) {
        var updatedEvent =
            existingEvent.withUpdatedTicketsSold(existingEvent.ticketsSold + 1);

        // Update the event in Firestore
        await eventDoc.docs.first.reference.update(updatedEvent.toJson());
        return true;
      }
      return false; // Event is sold out
    } catch (e) {
      rethrow;
    }
  }

  // Method to get the list of events for a user
  Future<List<EventModel>> getUserEventList(String userId) async {
    try {
      QuerySnapshot querySnapshot =
          await _userEventsCollection.where('userId', isEqualTo: userId).get();

      return querySnapshot.docs.map((doc) {
        return EventModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Method to cancel a ticket purchase
  Future<bool> cancelTicket(EventModel event) async {
    try {
      // Fetch the event from Firestore
      var eventDoc = await _availableEventsCollection
          .where('id', isEqualTo: event.id)
          .get();

      if (eventDoc.docs.isEmpty) {
        return false; // Event not found
      }

      // Explicitly cast to Map<String, dynamic> to resolve the type issue
      var existingEvent = EventModel.fromJson(
          eventDoc.docs.first.data() as Map<String, dynamic>);

      // Ensure ticketsSold is greater than 0 before decreasing
      if (existingEvent.ticketsSold > 0) {
        var updatedEvent =
            existingEvent.withUpdatedTicketsSold(existingEvent.ticketsSold - 1);

        // Update the event in Firestore
        await eventDoc.docs.first.reference.update(updatedEvent.toJson());
        return true;
      }
      return false; // No tickets to cancel
    } catch (e) {
      rethrow;
    }
  }
}
