import 'package:bebe/src/data/events/event_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  final repo = EventRepository(ref);
  ref.onDispose(() {
    repo.dispose();
  });
  return repo;
});
