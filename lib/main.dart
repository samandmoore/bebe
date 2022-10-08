import 'package:bebe/src/ui/app.dart';
import 'package:bebe/src/ui/providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();

  final authRepo = container.read(authRepositoryProvider);
  await authRepo.initialize();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: App(authRepository: authRepo),
    ),
  );
}
