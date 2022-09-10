import 'package:bebe/src/events/event.dart';
import 'package:bebe/src/events/providers.dart';
import 'package:bebe/src/shared/jitter.dart';
import 'package:bebe/src/storage/storage.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class EventRepository {
  final String _storageKey = 'events';

  final Ref ref;

  EventRepository(this.ref);

  LocalStorage get _storage => ref.read(storageProvider);

  Future<List<Event>> fetchAll() async {
    await jitter();

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

  Future<List<Event>> fetchAllForKid(final String kidId) async {
    final events = await fetchAll();
    return events.where((e) => e.kidId == kidId).toList();
  }

  Future<Map<EventType, Event?>> getLatestByTypes(
    final String kidId,
    List<EventType> eventTypes,
  ) async {
    final all = await fetchAllForKid(kidId);
    final grouped = all.groupListsBy((e) => e.eventType);
    final sorted = grouped.map((key, value) => MapEntry(
          key,
          value..sortBy((e) => e.createdAt),
        ));

    return Map.fromEntries(
      eventTypes.map(
        (eventType) => MapEntry(eventType, sorted[eventType]?.last),
      ),
    );
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

    await _saveChanges(newEvents);
    return newDiaperEvent;
  }

  Future<void> delete(final String id) async {
    final events = await fetchAll();

    final newEvents = events.where((k) => k.id != id).toList();

    await _saveChanges(newEvents);
  }

  Future<void> _saveChanges(List<Event> newEvents) async {
    await _storage.save(_storageKey, newEvents);
    _onChange();
  }

  void _onChange() {
    ref.read(eventChangeProvider.notifier).state++;
  }
}
