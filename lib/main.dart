import 'package:bebe/src/data/storage/storage.dart';
import 'package:bebe/src/ui/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();
  final storage = container.read(storageProvider);
  await storage.initialize();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: App(),
    ),
  );
}
