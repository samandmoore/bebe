import 'package:flutter/material.dart';

const unit = 16.0;

class VSpace extends StatelessWidget {
  const VSpace({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: unit);
  }
}

class HSpace extends StatelessWidget {
  const HSpace({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(width: unit);
  }
}
