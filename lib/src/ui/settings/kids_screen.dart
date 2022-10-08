import 'package:bebe/src/data/user/kid.dart';
import 'package:bebe/src/ui/kids/manage_kid_screen.dart';
import 'package:bebe/src/ui/providers.dart';
import 'package:bebe/src/ui/shared/error.dart';
import 'package:bebe/src/ui/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
                title: Text(kid.name),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(kid.toPrettyAge()),
                    if (kid.isCurrent) const Text('(current)')
                  ],
                ),
                onTap: () {
                  context.push(ManageKidScreen.route, extra: kid);
                },
              ),
            TextButton(
              onPressed: () => context.push(ManageKidScreen.route),
              child: const Text('Add kid'),
            ),
          ],
        ),
      ),
    );
  }
}
