import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Ticket Model to hold ticket data (simplified)
class Ticket {
  final String eventName;
  final String ticketType;
  final String ticketID;
  final DateTime eventDate;
  final double price;
  final String status; // "Booked", "Available", etc.

  Ticket({
    required this.eventName,
    required this.ticketType,
    required this.ticketID,
    required this.eventDate,
    required this.price,
    required this.status,
  });
}

class TicketCard extends StatelessWidget {
  final Ticket ticket; // Ticket data to display
  final VoidCallback
      onTap; // Callback when card is tapped (e.g., navigate to ticket details page)

  const TicketCard({
    super.key,
    required this.ticket,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Format the event date
    String formattedDate = DateFormat('yMMMMd').format(ticket.eventDate);

    // Check for ticket price validity
    String formattedPrice = '\$${ticket.price.toStringAsFixed(2)}';

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ticket Info: Event Name and Ticket Type
              Text(
                ticket.eventName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(
                  height: 5), // Space between event name and ticket type
              Text(
                'Ticket Type: ${ticket.ticketType}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 10), // Space between ticket type and ID
              // Ticket ID
              Text(
                'Ticket ID: ${ticket.ticketID}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 10), // Space before the footer
              // Footer with Date, Price, and Status
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
                    formattedPrice,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5), // Space before status
              // Ticket Status
              Text(
                'Status: ${ticket.status}',
                style: TextStyle(
                  fontSize: 12,
                  color: ticket.status == 'Booked' ? Colors.red : Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
