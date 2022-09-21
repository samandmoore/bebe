// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'kid.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Kid _$KidFromJson(Map<String, dynamic> json) {
  return _Kid.fromJson(json);
}

/// @nodoc
mixin _$Kid {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  DateTime get dateOfBirth => throw _privateConstructorUsedError;
  bool get isCurrent => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $KidCopyWith<Kid> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KidCopyWith<$Res> {
  factory $KidCopyWith(Kid value, $Res Function(Kid) then) =
      _$KidCopyWithImpl<$Res>;
  $Res call({String id, String name, DateTime dateOfBirth, bool isCurrent});
}

/// @nodoc
class _$KidCopyWithImpl<$Res> implements $KidCopyWith<$Res> {
  _$KidCopyWithImpl(this._value, this._then);

  final Kid _value;
  // ignore: unused_field
  final $Res Function(Kid) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? dateOfBirth = freezed,
    Object? isCurrent = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      dateOfBirth: dateOfBirth == freezed
          ? _value.dateOfBirth
          : dateOfBirth // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isCurrent: isCurrent == freezed
          ? _value.isCurrent
          : isCurrent // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
abstract class _$$_KidCopyWith<$Res> implements $KidCopyWith<$Res> {
  factory _$$_KidCopyWith(_$_Kid value, $Res Function(_$_Kid) then) =
      __$$_KidCopyWithImpl<$Res>;
  @override
  $Res call({String id, String name, DateTime dateOfBirth, bool isCurrent});
}

/// @nodoc
class __$$_KidCopyWithImpl<$Res> extends _$KidCopyWithImpl<$Res>
    implements _$$_KidCopyWith<$Res> {
  __$$_KidCopyWithImpl(_$_Kid _value, $Res Function(_$_Kid) _then)
      : super(_value, (v) => _then(v as _$_Kid));

  @override
  _$_Kid get _value => super._value as _$_Kid;

  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? dateOfBirth = freezed,
    Object? isCurrent = freezed,
  }) {
    return _then(_$_Kid(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      dateOfBirth: dateOfBirth == freezed
          ? _value.dateOfBirth
          : dateOfBirth // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isCurrent: isCurrent == freezed
          ? _value.isCurrent
          : isCurrent // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Kid extends _Kid {
  const _$_Kid(
      {required this.id,
      required this.name,
      required this.dateOfBirth,
      this.isCurrent = false})
      : super._();

  factory _$_Kid.fromJson(Map<String, dynamic> json) => _$$_KidFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final DateTime dateOfBirth;
  @override
  @JsonKey()
  final bool isCurrent;

  @override
  String toString() {
    return 'Kid(id: $id, name: $name, dateOfBirth: $dateOfBirth, isCurrent: $isCurrent)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Kid &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.name, name) &&
            const DeepCollectionEquality()
                .equals(other.dateOfBirth, dateOfBirth) &&
            const DeepCollectionEquality().equals(other.isCurrent, isCurrent));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(name),
      const DeepCollectionEquality().hash(dateOfBirth),
      const DeepCollectionEquality().hash(isCurrent));

  @JsonKey(ignore: true)
  @override
  _$$_KidCopyWith<_$_Kid> get copyWith =>
      __$$_KidCopyWithImpl<_$_Kid>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_KidToJson(
      this,
    );
  }
}

abstract class _Kid extends Kid {
  const factory _Kid(
      {required final String id,
      required final String name,
      required final DateTime dateOfBirth,
      final bool isCurrent}) = _$_Kid;
  const _Kid._() : super._();

  factory _Kid.fromJson(Map<String, dynamic> json) = _$_Kid.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  DateTime get dateOfBirth;
  @override
  bool get isCurrent;
  @override
  @JsonKey(ignore: true)
  _$$_KidCopyWith<_$_Kid> get copyWith => throw _privateConstructorUsedError;
}
