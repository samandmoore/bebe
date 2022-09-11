import 'package:bebe/src/ui/shared/add_kid_button.dart';
import 'package:flutter/material.dart';

class NoKidsScreen extends StatelessWidget {
  const NoKidsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('No kids yet, add one!'),
              AddKidButton(),
            ],
          ),
        ),
      ),
    );
  }
}
