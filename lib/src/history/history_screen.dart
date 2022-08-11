import 'package:bebe/src/events/event.dart';
import 'package:bebe/src/events/providers.dart';
import 'package:bebe/src/shared/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../shared/error_screen.dart';
import '../shared/loading_screen.dart';

final _historyProvider = FutureProvider.autoDispose(
  (ref) async {
    final repo = ref.read(eventRepositoryProvider);

    return repo.fetchAll();
  },
);

class HistoryScreen extends ConsumerWidget {
  static const route = '/history';

  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(_historyProvider);

    return events.when(
      loading: () => const LoadingScreen(),
      error: (error, stackTrace) =>
          ErrorScreen(error: error, stackTrace: stackTrace),
      data: (events) {
        if (events.isEmpty) {
          return _EmptyScreen();
        }
        return _HistoryScreen(events: events);
      },
    );
  }
}

class _EmptyScreen extends StatelessWidget {
  const _EmptyScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      drawer: const NavDrawer(),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('No events yet!'),
            ],
          ),
        ),
      ),
    );
  }
}

class _HistoryScreen extends StatelessWidget {
  final List<Event> events;

  const _HistoryScreen({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      drawer: NavDrawer(),
      body: SafeArea(
        child: ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];

            return event.map(
              bottle: (event) => _BottleEvent(event: event),
              diaper: (event) => _DiaperEvent(event: event),
              sleep: (event) => _SleepEvent(event: event),
            );
          },
        ),
      ),
    );
  }
}

class _BottleEvent extends StatelessWidget {
  final BottleEvent event;

  const _BottleEvent({required this.event});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Bottle'),
    );
  }
}

class _DiaperEvent extends StatelessWidget {
  final DiaperEvent event;

  const _DiaperEvent({required this.event});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${event.diaperType} diaper'),
      subtitle: Text(event.createdAt.toIso8601String()),
    );
  }
}

class _SleepEvent extends StatelessWidget {
  final SleepEvent event;

  const _SleepEvent({required this.event});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Sleep'),
    );
  }
}
