import 'package:bebe/src/settings/providers.dart';
import 'package:decimal/decimal.dart';

abstract class Event {
  final String id;
  final String kidId;
  final DateTime createdAt;

  const Event({
    required this.id,
    required this.kidId,
    required this.createdAt,
  });
}

class BottleEvent extends Event {
  final Decimal amount;
  final LiquidUnit unit;

  const BottleEvent({
    required super.id,
    required super.kidId,
    required super.createdAt,
    required this.amount,
    required this.unit,
  });
}

enum DiaperType {
  wet,
  dirty,
  both,
}

class DiaperEvent extends Event {
  final DiaperType diaperType;

  const DiaperEvent({
    required super.id,
    required super.kidId,
    required super.createdAt,
    required this.diaperType,
  });
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

class SleepEvent extends Event {
  final DateTime startedAt;
  final DateTime? endedAt;

  const SleepEvent({
    required super.id,
    required super.kidId,
    required super.createdAt,
    required this.startedAt,
    this.endedAt,
  });
}
