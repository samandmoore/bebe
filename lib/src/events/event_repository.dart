import 'package:bebe/src/storage/storage.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'event.dart';

class EventRepository {
  final String _storageKey = 'events';

  final Ref ref;

  EventRepository(this.ref);

  LocalStorage get _storage => ref.read(storageProvider);

  Future<List<Event>> fetchAll() async {
    final data = await _storage.load(_storageKey);

    if (data == null) {
      return [];
    }

    final list = data as List<Object?>;
    return list.map((k) => Event.fromJson(k as Map<String, Object?>)).toList();
  }

  Future<Event?> fetchById(final String id) async {
    final events = await fetchAll();
    return events.firstWhereOrNull((k) => k.id == id);
  }

  Future<DiaperEvent> createDiaperEvent(final DiaperEventInput input) async {
    final events = await fetchAll();

    final newDiaperEvent = DiaperEvent(
      id: const Uuid().v4(),
      kidId: input.kidId,
      createdAt: input.createdAt,
      diaperType: input.diaperType,
    );

    final newEvents = [
      ...events,
      newDiaperEvent,
    ];

    await _storage.save(_storageKey, newEvents);

    return newDiaperEvent;
  }

  Future<void> delete(final String id) async {
    final events = await fetchAll();

    final newEvents = events.where((k) => k.id != id).toList();

    await _storage.save(_storageKey, newEvents);
  }
}
