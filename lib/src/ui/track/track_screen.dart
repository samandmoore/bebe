import 'package:bebe/src/data/events/event.dart';
import 'package:bebe/src/data/kids/kid.dart';
import 'package:bebe/src/ui/diapers/new_diaper_event_screen.dart';
import 'package:bebe/src/ui/history/providers.dart';
import 'package:bebe/src/ui/kids/providers.dart';
import 'package:bebe/src/ui/shared/error.dart';
import 'package:bebe/src/ui/shared/kid_switcher.dart';
import 'package:bebe/src/ui/shared/loading.dart';
import 'package:bebe/src/ui/shared/nav_drawer.dart';
import 'package:bebe/src/ui/shared/no_kids_screen.dart';
import 'package:bebe/src/ui/shared/time_ago.dart';
import 'package:bebe/src/ui/track/track_action.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final actionProvider = FutureProvider.family<List<TrackAction>, String>(
  (ref, kidId) async {
    final repo = ref.read(eventRepositoryProvider);
    repo.addListener(() => ref.invalidateSelf());

    final events = await repo.getLatestByTypes(kidId, EventType.values);
    return events.entries
        .map((entry) => TrackAction(type: entry.key, latestEvent: entry.value))
        .toList();
  },
);

class TrackScreen extends ConsumerWidget {
  static const route = '/';

  const TrackScreen({super.key});

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
        return _TrackScreen(kids: kids);
      },
    );
  }
}

class _TrackScreen extends ConsumerWidget {
  final List<Kid> kids;

  const _TrackScreen({required this.kids});

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
              return ref.refresh(actionProvider(currentKid.id).future);
            },
          ),
          const ActionsList(),
        ],
      ),
    );
  }
}

class ActionsList extends ConsumerWidget {
  const ActionsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentKidAsync = ref.watch(currentKidProvider);

    if (currentKidAsync.isLoading) {
      return const SliverLoadingIndicator();
    }

    final actionsAsync = ref.watch(actionProvider(currentKidAsync.value!.id));
    if (actionsAsync.isLoading && !actionsAsync.isRefreshing) {
      return const SliverLoadingIndicator();
    }

    final actions = actionsAsync.value!;

    return SliverList(
      delegate: SliverChildListDelegate.fixed([
        for (final action in actions) ActionTile(action: action),
      ]),
    );
  }
}

class ActionTile extends StatelessWidget {
  final TrackAction action;

  const ActionTile({super.key, required this.action});

  @override
  Widget build(BuildContext context) {
    switch (action.type) {
      case EventType.diaper:
        return DiaperActionTile(action: action);
      case EventType.bottle:
        return BottleActionTile(action: action);
      case EventType.sleep:
        return SleepActionTile(action: action);
    }
  }
}

class DiaperActionTile extends StatelessWidget {
  final TrackAction action;

  const DiaperActionTile({super.key, required this.action});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(16),
      leading: const Icon(Icons.baby_changing_station, size: 32),
      title: Row(
        children: const [
          Text('Diaper', textScaleFactor: 1.3),
        ],
      ),
      subtitle: TimeAgo(action.latestEvent?.createdAt),
      onTap: () {
        context.push(NewDiaperEventScreen.route);
      },
    );
  }
}

class BottleActionTile extends StatelessWidget {
  final TrackAction action;

  const BottleActionTile({super.key, required this.action});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(16),
      leading: const Icon(Icons.local_drink, size: 32),
      title: Row(
        children: const [
          Text('Bottle', textScaleFactor: 1.3),
        ],
      ),
      subtitle: TimeAgo(action.latestEvent?.createdAt),
      onTap: () {},
    );
  }
}

class SleepActionTile extends StatelessWidget {
  final TrackAction action;

  const SleepActionTile({super.key, required this.action});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(16),
      leading: const Icon(Icons.bedtime, size: 32),
      title: Row(
        children: const [
          Text('Sleep', textScaleFactor: 1.3),
        ],
      ),
      subtitle: TimeAgo(action.latestEvent?.createdAt),
      onTap: () {},
    );
  }
}
