import 'package:flutter/material.dart';

import 'event_form_screen.dart';
import 'events_screen.dart';
import 'tickets_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;
  static const _titles = ['Eventos', 'Mis boletos'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_index])),
      body: IndexedStack(
        index: _index,
        children: const [EventsScreen(), TicketsScreen()],
      ),
      floatingActionButton: _index == 0
          ? FloatingActionButton.extended(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EventFormScreen()),
              ),
              icon: const Icon(Icons.add),
              label: const Text('Crear evento'),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.event), label: 'Eventos'),
          NavigationDestination(
            icon: Icon(Icons.confirmation_number_outlined),
            label: 'Mis boletos',
          ),
        ],
      ),
    );
  }
}
