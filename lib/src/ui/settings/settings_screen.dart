import 'package:bebe/src/data/storage/storage.dart';
import 'package:bebe/src/ui/history/providers.dart';
import 'package:bebe/src/ui/kids/providers.dart';
import 'package:bebe/src/ui/settings/kids_screen.dart';
import 'package:bebe/src/ui/settings/units_screen.dart';
import 'package:bebe/src/ui/shared/nav_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends ConsumerWidget {
  static const route = '/settings';

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      drawer: const NavDrawer(),
      body: SafeArea(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.child_care),
              title: Row(
                children: const [
                  Text('Kids'),
                ],
              ),
              onTap: () {
                context.push(KidsScreen.route);
              },
            ),
            ListTile(
              leading: const Icon(Icons.science),
              title: Row(
                children: const [
                  Text('Units'),
                ],
              ),
              onTap: () => context.push(UnitsScreen.route),
            ),
            ListTile(
              leading: const Icon(Icons.clear),
              title: Row(
                children: const [
                  Text('Clear storage'),
                ],
              ),
              onTap: () {
                ref.read(storageProvider).clear();
                ref.read(kidRepositoryProvider).onChange();
                ref.read(eventRepositoryProvider).onChange();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Storage cleared'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
