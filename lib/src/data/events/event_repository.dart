import 'package:bebe/src/data/events/event.dart';
import 'package:bebe/src/data/storage/storage.dart';
import 'package:bebe/src/utilities/jitter.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class EventRepository with ChangeNotifier {
  final String _storageKey = 'events';

  final Ref ref;

  EventRepository(this.ref);

  LocalStorage get _storage => ref.read(storageProvider);

  void onChange() => notifyListeners();

  Future<List<Event>> fetchAll() async {
    await jitter();

    final data = await _storage.load(_storageKey);

    if (data == null) {
      return [];
    }

    final list = data as List<Object?>;
    return list
        .map((k) => Event.fromJson(k as Map<String, Object?>))
        .sortedBy((e) => e.createdAt)
        .reversed
        .toList();
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

  Future<DiaperEvent> updateDiaperEvent(DiaperEventUpdate update) async {
    final events = await fetchAll();

    final existingEvent =
        events.firstWhere((e) => e.id == update.id) as DiaperEvent;

    final updatedEvent = existingEvent.copyWith(
      createdAt: update.createdAt,
      diaperType: update.diaperType,
    );

    final newEvents = [
      ...events.where((e) => e.id != update.id),
      updatedEvent,
    ];

    await _saveChanges(newEvents);
    return updatedEvent;
  }

  Future<void> delete(final String id) async {
    final events = await fetchAll();

    final newEvents = events.where((k) => k.id != id).toList();

    await _saveChanges(newEvents);
  }

  Future<void> _saveChanges(List<Event> newEvents) async {
    await _storage.save(_storageKey, newEvents);
    onChange();
  }
}
