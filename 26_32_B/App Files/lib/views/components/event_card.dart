import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // To format date and time

// Event class to hold event data (now includes id and toJson method)
class Event {
  final String id; // Unique ID for the event
  final String name;
  final String description;
  final DateTime date;
  final String location;
  final String imageUrl;

  Event({
    required this.id, // Add required id
    required this.name,
    required this.description,
    required this.date,
    required this.location,
    required this.imageUrl,
  });

  // Converts Event to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'date': date.toIso8601String(),
      'location': location,
      'imageUrl': imageUrl,
    };
  }

  // Factory method to create an Event from JSON
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      location: json['location'],
      imageUrl: json['imageUrl'],
    );
  }
}

class EventCard extends StatelessWidget {
  final Event event; // Event data to display
  final VoidCallback
      onTap; // Callback when card is tapped (e.g., navigate to event details page)

  const EventCard({
    super.key,
    required this.event,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Format the event date and time
    String formattedDate = DateFormat('yMMMMd').format(event.date);
    String formattedTime = DateFormat('jm').format(event.date);

    return GestureDetector(
      onTap: onTap, // Trigger the onTap callback when the card is tapped
      child: Card(
        elevation: 5, // Gives the card a shadow
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Rounded corners
        ),
        margin: const EdgeInsets.all(10), // Margin around the card
        child: Padding(
          padding: const EdgeInsets.all(15), // Padding inside the card
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Image (could be a network image or local asset)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  event.imageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover, // Image scaling to fit within the bounds
                  errorBuilder: (context, error, stackTrace) {
                    // Show a placeholder in case of image load error
                    return const Icon(Icons.error, size: 50);
                  },
                ),
              ),
              const SizedBox(width: 15), // Space between image and text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Event Name
                    Text(
                      event.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(
                        height: 5), // Space between title and description
                    // Event Description (brief)
                    Text(
                      event.description,
                      maxLines: 2, // Limit description to 2 lines
                      overflow: TextOverflow
                          .ellipsis, // Show ellipsis if text overflows
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 10), // Space before the footer
                    // Footer with Date, Time, and Location
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          formattedDate,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          formattedTime,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5), // Space before location
                    Text(
                      event.location,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
