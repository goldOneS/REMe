import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

  final _db = FirebaseFirestore.instance;

  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  Stream<List<EventItem>> events() => _db
      .collection('events')
      .orderBy('date')
      .snapshots()
      .map((s) => s.docs.map(EventItem.fromDoc).toList());

  Stream<List<TicketItem>> myTickets() => _db
      .collection('tickets')
      .where('uid', isEqualTo: _uid)
      .snapshots()
      .map((s) {
    final list = s.docs.map(TicketItem.fromDoc).toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  });

  Future<void> addEvent({
    required String name,
    required String venue,
    required DateTime date,
    required double price,
    required int capacity,
  }) {
    return _db.collection('events').add({
      'name': name,
      'venue': venue,
      'date': Timestamp.fromDate(date),
      'price': price,
      'capacity': capacity,
      'available': capacity,
      'createdBy': _uid,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Descuenta disponibilidad y registra el boleto en una sola transacción.
  Future<void> buyTickets({
    required EventItem event,
    required String buyerName,
    required String email,
    required int quantity,
  }) {
    final eventRef = _db.collection('events').doc(event.id);
    final ticketRef = _db.collection('tickets').doc();
    return _db.runTransaction((tx) async {
      final snap = await tx.get(eventRef);
      final data = snap.data();
      if (data == null) throw StateError('El evento ya no existe');
      final available = (data['available'] as num).toInt();
      final price = (data['price'] as num).toDouble();
      if (quantity > available) {
        throw StateError('Solo quedan $available boletos disponibles');
      }
      tx.update(eventRef, {
        'available': available - quantity,
        'lastPurchaseId': ticketRef.id,
      });
      tx.set(ticketRef, {
        'eventId': event.id,
        'eventName': data['name'],
        'buyerName': buyerName,
        'email': email,
        'quantity': quantity,
        'unitPrice': price,
        'total': price * quantity,
        'uid': _uid,
        'createdAt': FieldValue.serverTimestamp(),
      });
    });
  }
}

