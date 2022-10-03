import 'package:bebe/src/data/liquid_unit.dart';
import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'event.freezed.dart';
part 'event.g.dart';

@freezed
class EventPage with _$EventPage {
  factory EventPage({
    required List<Event> events,
    String? nextCursor,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'more') required bool hasMore,
  }) = _EventPage;

  factory EventPage.fromJson(Map<String, Object?> json) =>
      _$EventPageFromJson(json);
}

enum EventType {
  bottle,
  diaper,
  sleep,
}

extension EventExtensions on Event {
  EventType get eventType => map(
        bottle: (_) => EventType.bottle,
        diaper: (_) => EventType.diaper,
        sleep: (_) => EventType.sleep,
      );
}

@freezed
class Event with _$Event {
  const factory Event.bottle({
    required String id,
    required String kidId,
    required DateTime startedAt,
    required Decimal amount,
    required LiquidUnit unit,
  }) = BottleEvent;

  const factory Event.diaper({
    required String id,
    required String kidId,
    required DateTime startedAt,
    required DiaperType diaperType,
  }) = DiaperEvent;

  const factory Event.sleep({
    required String id,
    required String kidId,
    required DateTime startedAt,
    DateTime? endedAt,
  }) = SleepEvent;

  factory Event.fromJson(Map<String, Object?> json) => _$EventFromJson(json);
}

enum DiaperType {
  wet,
  dirty,
  mixed,
}

class DiaperEventInput {
  final String kidId;
  final DateTime startedAt;
  final DiaperType diaperType;

  const DiaperEventInput({
    required this.kidId,
    required this.startedAt,
    required this.diaperType,
  });

  Map<String, Object?> toJson() {
    return {
      'started_at': startedAt.toIso8601String(),
      'diaper_type': diaperType.toString().split('.').last,
    };
  }
}

class DiaperEventUpdate {
  final String id;
  final String kidId;
  final DateTime startedAt;
  final DiaperType diaperType;

  const DiaperEventUpdate({
    required this.id,
    required this.kidId,
    required this.startedAt,
    required this.diaperType,
  });

  Map<String, Object?> toJson() {
    return {
      'started_at': startedAt.toIso8601String(),
      'diaper_type': diaperType.toString().split('.').last,
    };
  }
}
