import 'package:bebe/src/data/events/event.dart';
import 'package:bebe/src/ui/diapers/diaper_event_screen.dart';
import 'package:bebe/src/ui/providers.dart';
import 'package:bebe/src/ui/shared/kid_switcher.dart';
import 'package:bebe/src/ui/shared/loading.dart';
import 'package:bebe/src/ui/shared/nav_drawer.dart';
import 'package:bebe/src/ui/shared/time_ago.dart';
import 'package:bebe/src/ui/track/track_action.dart';
import 'package:bebe/src/utilities/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final actionProvider =
    FutureProvider.autoDispose.family<List<TrackAction>, String>(
  (ref, kidId) async {
    ref.refreshEvery(const Duration(seconds: 5));

    final repo = ref.read(eventRepositoryProvider);
    repo.addListener(() => ref.invalidateSelf());

    final events = await repo.getLatestByTypes(kidId, EventType.values);
    return events.entries
        .map((entry) => TrackAction(type: entry.key, latestEvent: entry.value))
        .toList();
  },
);

class TrackScreen extends ConsumerWidget {
  static const route = '/track';

  const TrackScreen({super.key});

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

    if (currentKidAsync.isLoading && !currentKidAsync.isRefreshing) {
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
      subtitle: TimeAgo(action.latestEvent?.startedAt),
      trailing: action.latestEvent != null
          ? IconButton(
              onPressed: () {
                context.push(DiaperEventScreen.route,
                    extra: action.latestEvent);
              },
              icon: const Icon(Icons.edit),
            )
          : null,
      onTap: () {
        context.push(DiaperEventScreen.route);
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
      subtitle: TimeAgo(action.latestEvent?.startedAt),
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
      subtitle: TimeAgo(action.latestEvent?.startedAt),
      onTap: () {},
    );
  }
}
