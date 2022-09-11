import 'package:bebe/src/data/kids/kid.dart';
import 'package:bebe/src/ui/kids/edit_kid_screen.dart';
import 'package:bebe/src/ui/kids/new_kid_screen.dart';
import 'package:bebe/src/ui/kids/providers.dart';
import 'package:bebe/src/ui/shared/error.dart';
import 'package:bebe/src/ui/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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

  const _KidsScreen({required this.kids});

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
                leading: const Icon(Icons.child_care),
                title: Row(
                  children: [
                    Text(kid.name),
                  ],
                ),
                subtitle: Text(kid.toString()),
                onTap: () {
                  context.push(EditKidScreen.route, extra: kid);
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
