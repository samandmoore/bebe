import 'package:bebe/src/data/events/event_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  return EventRepository(ref);
});

/// A provider that changes when events change. Useful for triggering a refresh
/// when an event is added, deleted, or updated.
final eventChangeProvider = StateProvider((_) => 0);
