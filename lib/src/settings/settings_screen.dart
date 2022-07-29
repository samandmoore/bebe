import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../shared/drawer.dart';
import 'units_screen.dart';

class SettingsScreen extends StatelessWidget {
  static const route = '/settings';

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              onTap: () => context.push('/'),
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
          ],
        ),
      ),
    );
  }
}
