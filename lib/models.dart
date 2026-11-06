import 'package:cloud_firestore/cloud_firestore.dart';

class EventItem {
  const EventItem({
    required this.id,
    required this.name,
    required this.venue,
    required this.date,
    required this.price,
    required this.available,
  });

  final String id;
  final String name;
  final String venue;
  final DateTime date;
  final double price;
  final int available;

  factory EventItem.fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final m = doc.data();
    return EventItem(
      id: doc.id,
      name: m['name'] as String? ?? '',
      venue: m['venue'] as String? ?? '',
      date: (m['date'] as Timestamp).toDate(),
      price: (m['price'] as num).toDouble(),
      available: (m['available'] as num).toInt(),
    );
  }
}

class TicketItem {
  const TicketItem({
    required this.id,
    required this.eventName,
    required this.buyerName,
    required this.email,
    required this.quantity,
    required this.total,
    required this.createdAt,
  });

  final String id;
  final String eventName;
  final String buyerName;
  final String email;
  final int quantity;
  final double total;
  final DateTime createdAt;

  String get folio => id.substring(0, 6).toUpperCase();

  factory TicketItem.fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final m = doc.data();
    return TicketItem(
      id: doc.id,
      eventName: m['eventName'] as String? ?? '',
      buyerName: m['buyerName'] as String? ?? '',
      email: m['email'] as String? ?? '',
      quantity: (m['quantity'] as num).toInt(),
      total: (m['total'] as num).toDouble(),
      createdAt: (m['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
