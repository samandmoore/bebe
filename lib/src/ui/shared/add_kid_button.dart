import 'package:bebe/src/ui/kids/new_kid_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddKidButton extends StatelessWidget {
  const AddKidButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => context.push(NewKidScreen.route),
      child: const Text('Add kid'),
    );
  }
}
