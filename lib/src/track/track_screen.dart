import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../kids/kid.dart';
import '../kids/providers.dart';
import '../shared/error_screen.dart';
import '../shared/loading_screen.dart';

class TrackScreen extends ConsumerWidget {
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
      body: Center(
        child: TextButton(
          onPressed: () => GoRouter.of(context).push('/children/new'),
          child: const Text('Add kid'),
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
      body: SafeArea(
        child: Column(
          children: [
            Text('${kid.name} (${kid.toPrettyAge()})'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: const Icon(Icons.baby_changing_station, size: 72),
                onPressed: () {},
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: const Icon(Icons.baby_changing_station, size: 72),
                onPressed: () {},
              ),
            )
          ],
        ),
      ),
    );
  }
}
