import 'package:bebe/src/shared/drawer.dart';
import 'package:bebe/src/track/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../shared/error_screen.dart';
import '../shared/loading_screen.dart';
import '../track/event.dart';

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
      body: SafeArea(
        child: ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];

            return ListTile(
              title: Text(event.runtimeType.toString()),
              subtitle: Text(event.createdAt.toString()),
            );
          },
        ),
      ),
    );
  }
}
