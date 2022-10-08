import 'package:bebe/src/ui/history/history_screen.dart';
import 'package:bebe/src/ui/providers.dart';
import 'package:bebe/src/ui/settings/settings_screen.dart';
import 'package:bebe/src/ui/track/track_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NavDrawer extends ConsumerWidget {
  const NavDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Bebe'),
          ),
          ListTile(
            title: const Text('Track'),
            onTap: () {
              context.go(TrackScreen.route);
            },
          ),
          ListTile(
            title: const Text('History'),
            onTap: () {
              context.go(HistoryScreen.route);
            },
          ),
          ListTile(
            title: const Text('Settings'),
            onTap: () {
              context.go(SettingsScreen.route);
            },
          ),
          TextButton(
            onPressed: () async =>
                await ref.read(authRepositoryProvider).clearAuthHeader(),
            child: const Text('Log out'),
          )
        ],
      ),
    );
  }
}
