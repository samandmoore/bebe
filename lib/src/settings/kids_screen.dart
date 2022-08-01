import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../kids/kid.dart';
import '../kids/providers.dart';
import '../shared/error_screen.dart';
import '../shared/loading_screen.dart';

class KidsScreen extends ConsumerWidget {
  static const route = '/settings/kids';

  const KidsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kids = ref.watch(kidsProvider);

    return kids.when(
      loading: () => const LoadingScreen(),
      error: (error, stackTrace) =>
          ErrorScreen(error: error, stackTrace: stackTrace),
      data: (kids) {
        return _KidsScreen(kids: kids);
      },
    );
  }
}

class _KidsScreen extends StatelessWidget {
  final List<Kid> kids;

  const _KidsScreen({super.key, required this.kids});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kids'),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            for (final kid in kids)
              ListTile(
                leading: Icon(Icons.child_care),
                title: Row(
                  children: [
                    Text(kid.name),
                  ],
                ),
              ),
            if (kids.isEmpty)
              TextButton(
                onPressed: () => GoRouter.of(context).push(NewKidScreen.route),
                child: const Text('Add kid'),
              ),
          ],
        ),
      ),
    );
  }
}
