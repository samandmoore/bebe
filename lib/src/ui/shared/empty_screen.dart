import 'package:bebe/src/ui/kids/new_kid_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EmptyScreen extends StatelessWidget {
  const EmptyScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('No kids yet, add one!'),
              AddKidButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class AddKidButton extends StatelessWidget {
  const AddKidButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => GoRouter.of(context).push(NewKidScreen.route),
      child: const Text('Add kid'),
    );
  }
}
