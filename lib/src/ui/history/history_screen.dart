import 'package:bebe/src/data/events/event.dart';
import 'package:bebe/src/data/user/kid.dart';
import 'package:bebe/src/ui/diapers/diaper_event_screen.dart';
import 'package:bebe/src/ui/providers.dart';
import 'package:bebe/src/ui/shared/error.dart';
import 'package:bebe/src/ui/shared/kid_switcher.dart';
import 'package:bebe/src/ui/shared/loading.dart';
import 'package:bebe/src/ui/shared/nav_drawer.dart';
import 'package:bebe/src/ui/shared/no_kids_screen.dart';
import 'package:bebe/src/utilities/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';

final historyPagingControllerProvider =
    Provider.family.autoDispose<PagingController<String, Event>, String>(
  (ref, kidId) {
    final controller = PagingController<String, Event>(firstPageKey: '');

    controller.addPageRequestListener((pageKey) async {
      final repo = ref.read(eventRepositoryProvider);
      final result = await repo.fetchAllForKid(kidId, cursor: pageKey);
      final page = result.unwrapOrThrow();
      if (page.hasMore) {
        controller.appendPage(page.events, page.nextCursor);
      } else {
        controller.appendLastPage(page.events);
      }
    });

    ref.onDispose(() {
      controller.dispose();
    });

    return controller;
  },
  dependencies: [
    eventRepositoryProvider,
  ],
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
              final currentKid = await ref.watch(currentKidProvider.future);
              ref
                  .read(historyPagingControllerProvider(currentKid.id))
                  .refresh();
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

    final controller =
        ref.watch(historyPagingControllerProvider(currentKidAsync.value!.id));

    return PagedSliverList(
      pagingController: controller,
      builderDelegate: PagedChildBuilderDelegate<Event>(
        newPageProgressIndicatorBuilder: (context) => const LoadingIndicator(),
        itemBuilder: (context, event, index) {
          return event.map(
            bottle: (event) => _BottleEvent(event: event),
            diaper: (event) => _DiaperEvent(event: event),
            sleep: (event) => _SleepEvent(event: event),
          );
        },
      ),
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
      onDismissed: (direction) async {
        final repo = ref.read(eventRepositoryProvider);
        await repo.delete(event.id);
      },
      child: ListTile(
        onTap: () => context.push(DiaperEventScreen.route, extra: event),
        title: Text('${event.diaperType.name} diaper'),
        subtitle:
            Text(DateFormat.yMd().add_jm().format(event.startedAt.toLocal())),
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
