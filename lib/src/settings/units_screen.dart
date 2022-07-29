import 'package:flutter/material.dart';

class UnitsScreen extends StatelessWidget {
  static const route = '/settings/units';

  const UnitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Units'),
      ),
      body: SafeArea(
        child: Center(
          child: const Text('Units'),
        ),
      ),
    );
  }
}
