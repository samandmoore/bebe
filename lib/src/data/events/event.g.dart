// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_EventPage _$$_EventPageFromJson(Map<String, dynamic> json) => _$_EventPage(
      events: (json['events'] as List<dynamic>)
          .map((e) => Event.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextCursor: json['next_cursor'] as String?,
      hasMore: json['more'] as bool,
    );

Map<String, dynamic> _$$_EventPageToJson(_$_EventPage instance) =>
    <String, dynamic>{
      'events': instance.events,
      'next_cursor': instance.nextCursor,
      'more': instance.hasMore,
    };

_$BottleEvent _$$BottleEventFromJson(Map<String, dynamic> json) =>
    _$BottleEvent(
      id: json['id'] as String,
      kidId: json['kid_id'] as String,
      startedAt: DateTime.parse(json['started_at'] as String),
      amount: Decimal.fromJson(json['amount'] as String),
      unit: $enumDecode(_$LiquidUnitEnumMap, json['unit']),
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$BottleEventToJson(_$BottleEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'kid_id': instance.kidId,
      'started_at': instance.startedAt.toIso8601String(),
      'amount': instance.amount,
      'unit': _$LiquidUnitEnumMap[instance.unit]!,
      'type': instance.$type,
    };

const _$LiquidUnitEnumMap = {
  LiquidUnit.ml: 'ml',
  LiquidUnit.oz: 'oz',
};

_$DiaperEvent _$$DiaperEventFromJson(Map<String, dynamic> json) =>
    _$DiaperEvent(
      id: json['id'] as String,
      kidId: json['kid_id'] as String,
      startedAt: DateTime.parse(json['started_at'] as String),
      diaperType: $enumDecode(_$DiaperTypeEnumMap, json['diaper_type']),
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$DiaperEventToJson(_$DiaperEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'kid_id': instance.kidId,
      'started_at': instance.startedAt.toIso8601String(),
      'diaper_type': _$DiaperTypeEnumMap[instance.diaperType]!,
      'type': instance.$type,
    };

const _$DiaperTypeEnumMap = {
  DiaperType.wet: 'wet',
  DiaperType.dirty: 'dirty',
  DiaperType.mixed: 'mixed',
};

_$SleepEvent _$$SleepEventFromJson(Map<String, dynamic> json) => _$SleepEvent(
      id: json['id'] as String,
      kidId: json['kid_id'] as String,
      startedAt: DateTime.parse(json['started_at'] as String),
      endedAt: json['ended_at'] == null
          ? null
          : DateTime.parse(json['ended_at'] as String),
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$SleepEventToJson(_$SleepEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'kid_id': instance.kidId,
      'started_at': instance.startedAt.toIso8601String(),
      'ended_at': instance.endedAt?.toIso8601String(),
      'type': instance.$type,
    };
