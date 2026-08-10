import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_management_system/models/event_model.dart';

class EventService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection reference for events in Firebase Firestore
  CollectionReference get _eventsCollection => _firestore.collection('events');

  // Function to retrieve the list of events from Firestore
  Future<List<EventModel>> getEvents() async {
    try {
      QuerySnapshot querySnapshot = await _eventsCollection.get();
      return querySnapshot.docs.map((doc) {
        // Include Firestore document ID in the event data
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return EventModel.fromJson(data);
      }).toList();
    } catch (e) {
      print("Error retrieving events: $e");
      rethrow;
    }
  }

  // Function to save the list of events to Firestore
  Future<void> saveEvents(List<EventModel> events) async {
    try {
      // Clear the existing events in Firestore
      QuerySnapshot snapshot = await _eventsCollection.get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete(); // Delete old events
      }

      // Save the new events to Firestore
      for (var event in events) {
        await addEvent(event); // Use addEvent to ensure ID is set
      }
    } catch (e) {
      print("Error saving events: $e");
      rethrow;
    }
  }

  // Function to add a new event and save the updated event list to Firestore
  Future<void> addEvent(EventModel event) async {
    try {
      // Add the event and update its ID in Firestore
      DocumentReference docRef = await _eventsCollection.add(event.toJson());
      await docRef.update({'id': docRef.id}); // Set the document ID as a field
    } catch (e) {
      print("Error adding event: $e");
      rethrow;
    }
  }

  // Function to update an event in Firestore
  Future<void> updateEvent(EventModel updatedEvent) async {
    try {
      QuerySnapshot eventDoc =
          await _eventsCollection.where('id', isEqualTo: updatedEvent.id).get();

      if (eventDoc.docs.isNotEmpty) {
        await eventDoc.docs.first.reference.update(updatedEvent.toJson());
      } else {
        print("No event found with ID: ${updatedEvent.id}");
      }
    } catch (e) {
      print("Error updating event: $e");
      rethrow;
    }
  }

  // Function to delete an event from Firestore
  Future<void> deleteEvent(String eventId) async {
    try {
      QuerySnapshot eventDoc =
          await _eventsCollection.where('id', isEqualTo: eventId).get();

      if (eventDoc.docs.isNotEmpty) {
        await eventDoc.docs.first.reference.delete();
      } else {
        print("No event found with ID: $eventId");
      }
    } catch (e) {
      print("Error deleting event: $e");
      rethrow;
    }
  }
}
