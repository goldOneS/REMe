import 'package:flutter/material.dart';

import '../models.dart';
import '../services/firestore_service.dart';
import '../utils.dart';
import 'purchase_screen.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  late final Stream<List<EventItem>> _stream =
      FirestoreService.instance.events();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<EventItem>>(
      stream: _stream,
      builder: (context, snap) {
        if (snap.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text('No se pudieron cargar los eventos.\n${snap.error}'),
            ),
          );
        }
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final events = snap.data!;
        if (events.isEmpty) {
          return const Center(
            child: Text('Aún no hay eventos. Crea el primero.'),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 88),
          itemCount: events.length,
          itemBuilder: (_, i) => _EventCard(event: events[i]),
        );
      },
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({required this.event});
  final EventItem event;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final soldOut = event.available == 0;
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 76,
              color: theme.colorScheme.primary,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${event.date.day}',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    monthShort(event.date),
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(event.name, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text('${event.venue} · ${fmtDate.format(event.date)}'),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          fmtMoney.format(event.price),
                          style: theme.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const Spacer(),
                        Text(
                          soldOut ? 'Agotado' : '${event.available} disp.',
                          style: theme.textTheme.bodySmall,
                        ),
                        const SizedBox(width: 10),
                        FilledButton(
                          onPressed: soldOut
                              ? null
                              : () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          PurchaseScreen(event: event),
                                    ),
                                  ),
                          child: const Text('Comprar'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
