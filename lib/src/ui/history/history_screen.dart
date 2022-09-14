import 'package:bebe/src/data/events/event.dart';
import 'package:bebe/src/data/kids/kid.dart';
import 'package:bebe/src/ui/diapers/diaper_event_screen.dart';
import 'package:bebe/src/ui/history/history_notifier.dart';
import 'package:bebe/src/ui/history/providers.dart';
import 'package:bebe/src/ui/kids/providers.dart';
import 'package:bebe/src/ui/shared/error.dart';
import 'package:bebe/src/ui/shared/kid_switcher.dart';
import 'package:bebe/src/ui/shared/loading.dart';
import 'package:bebe/src/ui/shared/nav_drawer.dart';
import 'package:bebe/src/ui/shared/no_kids_screen.dart';
import 'package:bebe/src/utilities/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

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
          return const NoKidsScreen();
        }
        return _HistoryScreen(kids: kids);
      },
    );
  }
}

class _EmptyList extends StatelessWidget {
  const _EmptyList();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('No events yet!'),
          ],
        ),
      ),
    );
  }
}

class _HistoryScreen extends ConsumerWidget {
  final List<Kid> kids;

  const _HistoryScreen({
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
              final currentKid = await ref.read(currentKidProvider.future);
              return ref.read(historyProvider(currentKid.id).notifier).fetch();
            },
          ),
          const _EventList(),
        ],
      ),
    );
  }
}

class _EventList extends ConsumerWidget {
  const _EventList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentKidAsync = ref.watch(currentKidProvider);

    if (currentKidAsync.isLoading) {
      return const SliverLoadingIndicator();
    }

    final events = ref.watch(historyProvider(currentKidAsync.value!.id));

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
        onTap: () => context.push(DiaperEventScreen.route, extra: event),
        title: Text('${event.diaperType.name} diaper'),
        subtitle: Text(DateFormat('M/dd/yyyy HH:MM').format(event.createdAt)),
      ),
    );
  }
}

class _BottleEvent extends ConsumerWidget {
  final BottleEvent event;

  const _BottleEvent({required this.event});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const ListTile(
      title: Text('Bottle'),
    );
  }
}

class _SleepEvent extends StatelessWidget {
  final SleepEvent event;

  const _SleepEvent({required this.event});

  @override
  Widget build(BuildContext context) {
    return const ListTile(
      title: Text('Sleep'),
    );
  }
}
