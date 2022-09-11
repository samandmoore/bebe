// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BottleEvent _$$BottleEventFromJson(Map<String, dynamic> json) =>
    _$BottleEvent(
      id: json['id'] as String,
      kidId: json['kidId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      amount: Decimal.fromJson(json['amount'] as String),
      unit: $enumDecode(_$LiquidUnitEnumMap, json['unit']),
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$BottleEventToJson(_$BottleEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'kidId': instance.kidId,
      'createdAt': instance.createdAt.toIso8601String(),
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
      kidId: json['kidId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      diaperType: $enumDecode(_$DiaperTypeEnumMap, json['diaperType']),
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$DiaperEventToJson(_$DiaperEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'kidId': instance.kidId,
      'createdAt': instance.createdAt.toIso8601String(),
      'diaperType': _$DiaperTypeEnumMap[instance.diaperType]!,
      'type': instance.$type,
    };

const _$DiaperTypeEnumMap = {
  DiaperType.wet: 'wet',
  DiaperType.dirty: 'dirty',
  DiaperType.both: 'both',
};

_$SleepEvent _$$SleepEventFromJson(Map<String, dynamic> json) => _$SleepEvent(
      id: json['id'] as String,
      kidId: json['kidId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      startedAt: DateTime.parse(json['startedAt'] as String),
      endedAt: json['endedAt'] == null
          ? null
          : DateTime.parse(json['endedAt'] as String),
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$SleepEventToJson(_$SleepEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'kidId': instance.kidId,
      'createdAt': instance.createdAt.toIso8601String(),
      'startedAt': instance.startedAt.toIso8601String(),
      'endedAt': instance.endedAt?.toIso8601String(),
      'type': instance.$type,
    };
