import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../history/history_screen.dart';
import '../settings/settings_screen.dart';
import '../track/track_screen.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
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
        ],
      ),
    );
  }
}
