import 'package:bebe/src/kids/new_kid_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../kids/edit_kid_screen.dart';
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
    final kids = ref.watch(kidsProvider);

    return kids.when(
      loading: () => const LoadingScreen(),
      error: (error, stackTrace) =>
          ErrorScreen(error: error, stackTrace: stackTrace),
      data: (kids) {
        if (kids.isEmpty) {
          return const _EmptyScreen();
        }
        return _TrackScreen(kids: kids);
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

class _TrackScreen extends ConsumerWidget {
  final List<Kid> kids;

  const _TrackScreen({super.key, required this.kids});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      drawer: const NavDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            flexibleSpace: FlexibleSpaceBar(
              title: SizedBox(
                height: 80,
                child: PageView.builder(
                  onPageChanged: (value) {
                    final currentKidSetter =
                        ref.read(currentKidProvider.notifier);
                    currentKidSetter.state = value;
                  },
                  itemCount: kids.length,
                  itemBuilder: (context, index) {
                    final kid = kids[index];
                    return Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (index > 0)
                            Icon(
                              Icons.chevron_left,
                              color: Colors.white,
                            ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextButton(
                                onPressed: () {
                                  ref.read(editingKidProvider.notifier).state =
                                      kid;
                                  context.push(EditKidScreen.route);
                                },
                                style: TextButton.styleFrom(
                                  primary: Colors.white,
                                ),
                                child: Text(kid.name, textScaleFactor: 1.3),
                              ),
                              Text(
                                kid.toPrettyAge(),
                              ),
                            ],
                          ),
                          if (index < kids.length - 1)
                            Icon(
                              Icons.chevron_right,
                              color: Colors.white,
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate.fixed([
              Consumer(builder: (_, ref, __) {
                final currentKid = ref.watch(currentKidProvider);
                final kid = kids[currentKid];
                return ListTile(
                  title: Text(kid.name, textScaleFactor: 1.3),
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
            ]),
          ),
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
