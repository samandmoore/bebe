import 'package:bebe/src/diapers/new_diaper_event_screen.dart';
import 'package:bebe/src/kids/kid.dart';
import 'package:bebe/src/kids/providers.dart';
import 'package:bebe/src/shared/drawer.dart';
import 'package:bebe/src/shared/empty_screen.dart';
import 'package:bebe/src/shared/error_screen.dart';
import 'package:bebe/src/shared/kid_switcher.dart';
import 'package:bebe/src/shared/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
      drawer: const NavDrawer(),
      body: CustomScrollView(
        slivers: [
          KidSwitcherSliverAppBar(kids: kids),
          SliverList(
            delegate: SliverChildListDelegate.fixed([
              Consumer(builder: (_, ref, __) {
                final selectedKid = ref.watch(selectedKidProvider);
                return ListTile(
                  title:
                      Text(selectedKid?.name ?? 'None', textScaleFactor: 1.3),
                );
              }),
              ListTile(
                contentPadding: EdgeInsets.all(16),
                leading: Icon(Icons.local_drink, size: 32),
                title: Row(
                  children: [
                    Text('Bottle', textScaleFactor: 1.3),
                  ],
                ),
                onTap: () {},
              ),
              ListTile(
                contentPadding: EdgeInsets.all(16),
                leading: Icon(Icons.baby_changing_station, size: 32),
                title: Row(
                  children: [
                    Text('Diaper', textScaleFactor: 1.3),
                  ],
                ),
                onTap: () {
                  context.push(NewDiaperEventScreen.route);
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.all(16),
                leading: Icon(Icons.bedtime, size: 32),
                title: Row(
                  children: [
                    Text('Sleep', textScaleFactor: 1.3),
                  ],
                ),
                onTap: () {},
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
