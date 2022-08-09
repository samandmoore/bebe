import 'package:collection/collection.dart';
import 'package:uuid/uuid.dart';

import 'event.dart';

class EventRepository {
  List<Event> _events = <Event>[];

  Future<List<Event>> fetchAll() async => _events.toList();

  Future<Event?> fetchById(final String id) async {
    return _events.firstWhereOrNull((k) => k.id == id);
  }

  Future<DiaperEvent> createDiaperEvent(final DiaperEventInput input) async {
    final newDiaperEvent = DiaperEvent(
      id: const Uuid().v4(),
      kidId: input.kidId,
      createdAt: input.createdAt,
      diaperType: input.diaperType,
    );

    _events = [
      ..._events,
      newDiaperEvent,
    ];

    return newDiaperEvent;
  }

  Future<void> delete(final String id) async {
    _events = _events.where((k) => k.id != id).toList();
  }
}
