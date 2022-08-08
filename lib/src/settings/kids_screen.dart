import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../kids/edit_kid_screen.dart';
import '../kids/kid.dart';
import '../kids/new_kid_screen.dart';
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

class _KidsScreen extends ConsumerWidget {
  final List<Kid> kids;

  const _KidsScreen({super.key, required this.kids});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                onTap: () {
                  ref.read(editingKidProvider.notifier).state = kid;
                  context.push(EditKidScreen.route);
                },
              ),
            TextButton(
              onPressed: () => context.push(NewKidScreen.route),
              child: const Text('Add kid'),
            ),
          ],
        ),
      ),
    );
  }
}
