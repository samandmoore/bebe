import 'package:bebe/src/settings/providers.dart';
import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'event.freezed.dart';

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
