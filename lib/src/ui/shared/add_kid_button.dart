import 'package:bebe/src/ui/kids/manage_kid_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddKidButton extends StatelessWidget {
  const AddKidButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => context.push(ManageKidScreen.route),
      child: const Text('Add kid'),
    );
  }
}
