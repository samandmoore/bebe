import 'package:bebe/src/kids/providers.dart';
import 'package:bebe/src/settings/kids_screen.dart';
import 'package:bebe/src/settings/units_screen.dart';
import 'package:bebe/src/shared/drawer.dart';
import 'package:bebe/src/storage/storage.dart';
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
              leading: Icon(Icons.child_care),
              title: Row(
                children: [
                  Text('Kids'),
                ],
              ),
              onTap: () {
                context.push(KidsScreen.route);
              },
            ),
            ListTile(
              leading: Icon(Icons.science),
              title: Row(
                children: [
                  Text('Units'),
                ],
              ),
              onTap: () => context.push(UnitsScreen.route),
            ),
            ListTile(
              leading: Icon(Icons.clear),
              title: Row(
                children: [
                  Text('Clear storage'),
                ],
              ),
              onTap: () {
                ref.read(storageProvider).clear();
                ref.invalidate(kidsProvider);
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
