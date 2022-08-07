import 'package:bebe/src/kids/new_kid_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../kids/kid.dart';
import '../kids/providers.dart';
import '../shared/drawer.dart';
import '../shared/error_screen.dart';
import '../shared/loading_screen.dart';

class TrackScreen extends ConsumerWidget {
  static const route = '/';

  const TrackScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kid = ref.watch(currentKidProvider);

    return kid.when(
      loading: () => const LoadingScreen(),
      error: (error, stackTrace) =>
          ErrorScreen(error: error, stackTrace: stackTrace),
      data: (kid) {
        if (kid == null) {
          return const _EmptyScreen();
        }
        return _TrackScreen(kid: kid);
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
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('No kids yet, add one!'),
              AddKidButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _TrackScreen extends StatelessWidget {
  final Kid kid;

  const _TrackScreen({super.key, required this.kid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 160.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(kid.name),
                  Text(kid.toPrettyAge()),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.all(16),
                  leading: Icon(Icons.baby_changing_station, size: 32),
                  title: Row(
                    children: [
                      Text('Diaper', textScaleFactor: 1.3),
                    ],
                  ),
                  onTap: () {},
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
              ],
            ),
          )
        ],
      ),
    );
  }
}

class AddKidButton extends StatelessWidget {
  const AddKidButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => GoRouter.of(context).push(NewKidScreen.route),
      child: const Text('Add kid'),
    );
  }
}
