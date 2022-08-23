import 'package:bebe/src/events/event.dart';
import 'package:bebe/src/events/providers.dart';
import 'package:bebe/src/kids/kid.dart';
import 'package:bebe/src/kids/providers.dart';
import 'package:bebe/src/shared/drawer.dart';
import 'package:bebe/src/shared/empty_screen.dart';
import 'package:bebe/src/shared/kid_switcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../shared/error_screen.dart';
import '../shared/loading_screen.dart';

// TODO: figure out how to make this dispos without breaking pull to refresh
final _historyProvider = FutureProvider.family<List<Event>, String>(
  (ref, kidId) async {
    final repo = ref.read(eventRepositoryProvider);
    await Future<void>.delayed(const Duration(seconds: 1));
    return repo.fetchAllForKid(kidId);
  },
);

class HistoryScreen extends ConsumerWidget {
  static const route = '/history';

  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kids = ref.watch(kidsProvider);

    return kids.when(
      loading: () => const LoadingScreen(),
      error: (error, stackTrace) =>
          ErrorScreen(error: error, stackTrace: stackTrace),
      data: (kids) {
        if (kids.isEmpty) {
          return const EmptyScreen();
        }
        return _HistoryScreen(kids: kids);
      },
    );
  }
}

class _EmptyList extends StatelessWidget {
  const _EmptyList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No events yet!'),
          ],
        ),
      ),
    );
  }
}

class _HistoryScreen extends ConsumerWidget {
  final List<Kid> kids;

  const _HistoryScreen({
    super.key,
    required this.kids,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      drawer: const NavDrawer(),
      body: CustomScrollView(
        slivers: [
          KidSwitcherSliverAppBar(kids: kids),
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              final selectedKid = ref.read(selectedKidProvider);
              return ref.refresh(_historyProvider(selectedKid!.id).future);
            },
          ),
          _EventList(kids: kids),
        ],
      ),
    );
  }
}

class _EventList extends ConsumerWidget {
  final List<Kid> kids;

  const _EventList({super.key, required this.kids});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedKid = ref.watch(selectedKidProvider);
    final events = ref.watch(_historyProvider(selectedKid!.id));

    return events.when(
      loading: () => const SliverToBoxAdapter(
        child: LoadingIndicator(),
      ),
      error: (error, stackTrace) => SliverToBoxAdapter(
        child: ErrorView(error: error, stackTrace: stackTrace),
      ),
      data: (events) {
        if (events.isEmpty) {
          return const SliverToBoxAdapter(
            child: _EmptyList(),
          );
        }
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            childCount: events.length,
            (context, index) {
              final event = events[index];

              return event.map(
                bottle: (event) => _BottleEvent(event: event),
                diaper: (event) => _DiaperEvent(event: event),
                sleep: (event) => _SleepEvent(event: event),
              );
            },
          ),
        );
      },
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
