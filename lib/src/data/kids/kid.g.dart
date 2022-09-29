// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kid.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Kid _$$_KidFromJson(Map<String, dynamic> json) => _$_Kid(
      id: json['id'] as String,
      name: json['name'] as String,
      dateOfBirth: DateTime.parse(json['date_of_birth'] as String),
      isCurrent: json['current'] as bool? ?? false,
    );

Map<String, dynamic> _$$_KidToJson(_$_Kid instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'date_of_birth': instance.dateOfBirth.toIso8601String(),
      'current': instance.isCurrent,
    };
