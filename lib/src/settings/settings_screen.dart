import 'package:flutter/material.dart';

import '../shared/drawer.dart';

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
        child: Center(
          child: const Text('Settings'),
        ),
      ),
    );
  }
}
