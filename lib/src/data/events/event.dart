import 'package:bebe/src/ui/settings/providers.dart';
import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'event.freezed.dart';
part 'event.g.dart';

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
    required DateTime createdAt,
    required Decimal amount,
    required LiquidUnit unit,
  }) = BottleEvent;

  const factory Event.diaper({
    required String id,
    required String kidId,
    required DateTime createdAt,
    required DiaperType diaperType,
  }) = DiaperEvent;

  const factory Event.sleep({
    required String id,
    required String kidId,
    required DateTime createdAt,
    required DateTime startedAt,
    DateTime? endedAt,
  }) = SleepEvent;

  factory Event.fromJson(Map<String, Object?> json) => _$EventFromJson(json);
}

enum DiaperType {
  wet,
  dirty,
  both,
}

class DiaperEventInput {
  final String kidId;
  final DateTime createdAt;
  final DiaperType diaperType;

  const DiaperEventInput({
    required this.kidId,
    required this.createdAt,
    required this.diaperType,
  });
}
