import 'package:bebe/src/events/event.dart';
import 'package:bebe/src/events/providers.dart';
import 'package:bebe/src/kids/kid.dart';
import 'package:bebe/src/kids/providers.dart';
import 'package:bebe/src/shared/drawer.dart';
import 'package:bebe/src/shared/empty_screen.dart';
import 'package:bebe/src/shared/error_screen.dart';
import 'package:bebe/src/shared/extensions.dart';
import 'package:bebe/src/shared/kid_switcher.dart';
import 'package:bebe/src/shared/loading_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HistoryNotifier extends StateNotifier<AsyncValue<List<Event>>> {
  final Ref ref;
  final String kidId;

  HistoryNotifier(this.ref, this.kidId) : super(const AsyncValue.loading()) {
    fetch();
  }

  Future<void> fetch() async {
    final repo = ref.read(eventRepositoryProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => repo.fetchAllForKid(kidId));
  }

  Future<void> delete(String id) async {
    final repo = ref.read(eventRepositoryProvider);
    await repo.delete(id);
    state = state.whenData((value) => value.where((e) => e.id != id).toList());
  }
}

final historyProvider = StateNotifierProvider.family<HistoryNotifier,
    AsyncValue<List<Event>>, String>(
  (ref, kidId) {
    return HistoryNotifier(ref, kidId);
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
          const KidSwitcherSliverAppBar(),
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              final selectedKid = ref.read(selectedKidProvider);
              return ref
                  .read(historyProvider(selectedKid!.id).notifier)
                  .fetch();
            },
          ),
          const _EventList(),
        ],
      ),
    );
  }
}

class _EventList extends ConsumerWidget {
  const _EventList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedKid = ref.watch(selectedKidProvider);
    final events = ref.watch(historyProvider(selectedKid!.id));

    return events.when(
      loading: () => const SliverLoadingIndicator(),
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

class _DiaperEvent extends ConsumerWidget {
  final DiaperEvent event;

  const _DiaperEvent({required this.event});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: ValueKey(event.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        child: const Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ),
      ),
      confirmDismiss: (direction) {
        return showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Delete event?'),
            content: const Text('This action cannot be undone.'),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => dialogContext.closeDialog(false),
              ),
              TextButton(
                child: const Text('Delete'),
                onPressed: () => dialogContext.closeDialog(true),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        final repo = ref.read(eventRepositoryProvider);
        repo.delete(event.id);
      },
      child: ListTile(
        title: Text('${event.diaperType} diaper'),
        subtitle: Text(event.createdAt.toIso8601String()),
      ),
    );
  }
}

class _BottleEvent extends ConsumerWidget {
  final BottleEvent event;

  const _BottleEvent({required this.event});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text('Bottle'),
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
