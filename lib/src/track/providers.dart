import 'package:bebe/src/track/event_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final eventRepositoryProvider = Provider<EventRepository>((_) {
  return EventRepository();
});
