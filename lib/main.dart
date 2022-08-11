import 'package:bebe/src/storage/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/app.dart';

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
