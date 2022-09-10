import 'package:bebe/src/diapers/new_diaper_event_screen.dart';
import 'package:bebe/src/events/event.dart';
import 'package:bebe/src/events/providers.dart';
import 'package:bebe/src/kids/kid.dart';
import 'package:bebe/src/kids/providers.dart';
import 'package:bebe/src/shared/drawer.dart';
import 'package:bebe/src/shared/empty_screen.dart';
import 'package:bebe/src/shared/error_screen.dart';
import 'package:bebe/src/shared/kid_switcher.dart';
import 'package:bebe/src/shared/loading_screen.dart';
import 'package:bebe/src/shared/time_ago.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class Action {
  final EventType type;
  final Event? latestEvent;

  const Action({
    required this.type,
    required this.latestEvent,
  });
}

final actionProvider = FutureProvider.family<List<Action>, String>(
  (ref, kidId) async {
    final repo = ref.read(eventRepositoryProvider);
    final events = await repo.getLatestByTypes(kidId, EventType.values);
    return events.entries
        .map((entry) => Action(type: entry.key, latestEvent: entry.value))
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
          return const EmptyScreen();
        }
        return _TrackScreen(kids: kids);
      },
    );
  }
}

class _TrackScreen extends ConsumerWidget {
  final List<Kid> kids;

  const _TrackScreen({super.key, required this.kids});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      drawer: NavDrawer(),
      body: CustomScrollView(
        slivers: [
          KidSwitcherSliverAppBar(),
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              final currentKid = await ref.read(currentKidProvider.future);
              return ref.refresh(actionProvider(currentKid.id).future);
            },
          ),
          ActionsList(),
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
  final Action action;

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
  final Action action;

  const DiaperActionTile({super.key, required this.action});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(16),
      leading: Icon(Icons.baby_changing_station, size: 32),
      title: Row(
        children: [
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
  final Action action;

  const BottleActionTile({super.key, required this.action});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(16),
      leading: Icon(Icons.local_drink, size: 32),
      title: Row(
        children: [
          Text('Bottle', textScaleFactor: 1.3),
        ],
      ),
      subtitle: TimeAgo(action.latestEvent?.createdAt),
      onTap: () {},
    );
  }
}

class SleepActionTile extends StatelessWidget {
  final Action action;

  const SleepActionTile({super.key, required this.action});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(16),
      leading: Icon(Icons.bedtime, size: 32),
      title: Row(
        children: [
          Text('Sleep', textScaleFactor: 1.3),
        ],
      ),
      subtitle: TimeAgo(action.latestEvent?.createdAt),
      onTap: () {},
    );
  }
}
