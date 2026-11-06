import 'package:flutter/material.dart';

import '../models.dart';
import '../services/firestore_service.dart';
import '../utils.dart';

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({super.key});

  @override
  State<TicketsScreen> createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen> {
  late final Stream<List<TicketItem>> _stream =
      FirestoreService.instance.myTickets();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return StreamBuilder<List<TicketItem>>(
      stream: _stream,
      builder: (context, snap) {
        if (snap.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text('No se pudieron cargar tus boletos.\n${snap.error}'),
            ),
          );
        }
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final tickets = snap.data!;
        if (tickets.isEmpty) {
          return const Center(
            child: Text('Todavía no has comprado boletos.'),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: tickets.length,
          itemBuilder: (_, i) {
            final t = tickets[i];
            return Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 12),
              clipBehavior: Clip.antiAlias,
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                title: Text(t.eventName, style: theme.textTheme.titleMedium),
                subtitle: Text(
                  '${t.buyerName} · ${t.email}\n'
                  '${t.quantity} boleto(s) · ${fmtMoney.format(t.total)}\n'
                  'Folio ${t.folio} · ${fmtDate.format(t.createdAt)}',
                ),
                isThreeLine: true,
              ),
            );
          },
        );
      },
    );
  }
}
