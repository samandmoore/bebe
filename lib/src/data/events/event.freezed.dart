// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

EventPage _$EventPageFromJson(Map<String, dynamic> json) {
  return _EventPage.fromJson(json);
}

/// @nodoc
mixin _$EventPage {
  List<Event> get events => throw _privateConstructorUsedError;
  String? get nextCursor =>
      throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'more')
  bool get hasMore => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventPageCopyWith<EventPage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventPageCopyWith<$Res> {
  factory $EventPageCopyWith(EventPage value, $Res Function(EventPage) then) =
      _$EventPageCopyWithImpl<$Res>;
  $Res call(
      {List<Event> events,
      String? nextCursor,
      @JsonKey(name: 'more') bool hasMore});
}

/// @nodoc
class _$EventPageCopyWithImpl<$Res> implements $EventPageCopyWith<$Res> {
  _$EventPageCopyWithImpl(this._value, this._then);

  final EventPage _value;
  // ignore: unused_field
  final $Res Function(EventPage) _then;

  @override
  $Res call({
    Object? events = freezed,
    Object? nextCursor = freezed,
    Object? hasMore = freezed,
  }) {
    return _then(_value.copyWith(
      events: events == freezed
          ? _value.events
          : events // ignore: cast_nullable_to_non_nullable
              as List<Event>,
      nextCursor: nextCursor == freezed
          ? _value.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as String?,
      hasMore: hasMore == freezed
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
abstract class _$$_EventPageCopyWith<$Res> implements $EventPageCopyWith<$Res> {
  factory _$$_EventPageCopyWith(
          _$_EventPage value, $Res Function(_$_EventPage) then) =
      __$$_EventPageCopyWithImpl<$Res>;
  @override
  $Res call(
      {List<Event> events,
      String? nextCursor,
      @JsonKey(name: 'more') bool hasMore});
}

/// @nodoc
class __$$_EventPageCopyWithImpl<$Res> extends _$EventPageCopyWithImpl<$Res>
    implements _$$_EventPageCopyWith<$Res> {
  __$$_EventPageCopyWithImpl(
      _$_EventPage _value, $Res Function(_$_EventPage) _then)
      : super(_value, (v) => _then(v as _$_EventPage));

  @override
  _$_EventPage get _value => super._value as _$_EventPage;

  @override
  $Res call({
    Object? events = freezed,
    Object? nextCursor = freezed,
    Object? hasMore = freezed,
  }) {
    return _then(_$_EventPage(
      events: events == freezed
          ? _value._events
          : events // ignore: cast_nullable_to_non_nullable
              as List<Event>,
      nextCursor: nextCursor == freezed
          ? _value.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as String?,
      hasMore: hasMore == freezed
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_EventPage implements _EventPage {
  _$_EventPage(
      {required final List<Event> events,
      this.nextCursor,
      @JsonKey(name: 'more') required this.hasMore})
      : _events = events;

  factory _$_EventPage.fromJson(Map<String, dynamic> json) =>
      _$$_EventPageFromJson(json);

  final List<Event> _events;
  @override
  List<Event> get events {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_events);
  }

  @override
  final String? nextCursor;
// ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'more')
  final bool hasMore;

  @override
  String toString() {
    return 'EventPage(events: $events, nextCursor: $nextCursor, hasMore: $hasMore)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_EventPage &&
            const DeepCollectionEquality().equals(other._events, _events) &&
            const DeepCollectionEquality()
                .equals(other.nextCursor, nextCursor) &&
            const DeepCollectionEquality().equals(other.hasMore, hasMore));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_events),
      const DeepCollectionEquality().hash(nextCursor),
      const DeepCollectionEquality().hash(hasMore));

  @JsonKey(ignore: true)
  @override
  _$$_EventPageCopyWith<_$_EventPage> get copyWith =>
      __$$_EventPageCopyWithImpl<_$_EventPage>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_EventPageToJson(
      this,
    );
  }
}

abstract class _EventPage implements EventPage {
  factory _EventPage(
      {required final List<Event> events,
      final String? nextCursor,
      @JsonKey(name: 'more') required final bool hasMore}) = _$_EventPage;

  factory _EventPage.fromJson(Map<String, dynamic> json) =
      _$_EventPage.fromJson;

  @override
  List<Event> get events;
  @override
  String? get nextCursor;
  @override // ignore: invalid_annotation_target
  @JsonKey(name: 'more')
  bool get hasMore;
  @override
  @JsonKey(ignore: true)
  _$$_EventPageCopyWith<_$_EventPage> get copyWith =>
      throw _privateConstructorUsedError;
}

Event _$EventFromJson(Map<String, dynamic> json) {
  switch (json['type']) {
    case 'bottle':
      return BottleEvent.fromJson(json);
    case 'diaper':
      return DiaperEvent.fromJson(json);
    case 'sleep':
      return SleepEvent.fromJson(json);

    default:
      throw CheckedFromJsonException(
          json, 'type', 'Event', 'Invalid union type "${json['type']}"!');
  }
}

/// @nodoc
mixin _$Event {
  String get id => throw _privateConstructorUsedError;
  String get kidId => throw _privateConstructorUsedError;
  DateTime get startedAt => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String id, String kidId, DateTime startedAt,
            Decimal amount, LiquidUnit unit)
        bottle,
    required TResult Function(
            String id, String kidId, DateTime startedAt, DiaperType diaperType)
        diaper,
    required TResult Function(
            String id, String kidId, DateTime startedAt, DateTime? endedAt)
        sleep,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String id, String kidId, DateTime startedAt,
            Decimal amount, LiquidUnit unit)?
        bottle,
    TResult Function(
            String id, String kidId, DateTime startedAt, DiaperType diaperType)?
        diaper,
    TResult Function(
            String id, String kidId, DateTime startedAt, DateTime? endedAt)?
        sleep,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String id, String kidId, DateTime startedAt,
            Decimal amount, LiquidUnit unit)?
        bottle,
    TResult Function(
            String id, String kidId, DateTime startedAt, DiaperType diaperType)?
        diaper,
    TResult Function(
            String id, String kidId, DateTime startedAt, DateTime? endedAt)?
        sleep,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BottleEvent value) bottle,
    required TResult Function(DiaperEvent value) diaper,
    required TResult Function(SleepEvent value) sleep,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(BottleEvent value)? bottle,
    TResult Function(DiaperEvent value)? diaper,
    TResult Function(SleepEvent value)? sleep,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BottleEvent value)? bottle,
    TResult Function(DiaperEvent value)? diaper,
    TResult Function(SleepEvent value)? sleep,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventCopyWith<Event> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventCopyWith<$Res> {
  factory $EventCopyWith(Event value, $Res Function(Event) then) =
      _$EventCopyWithImpl<$Res>;
  $Res call({String id, String kidId, DateTime startedAt});
}

/// @nodoc
class _$EventCopyWithImpl<$Res> implements $EventCopyWith<$Res> {
  _$EventCopyWithImpl(this._value, this._then);

  final Event _value;
  // ignore: unused_field
  final $Res Function(Event) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? kidId = freezed,
    Object? startedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      kidId: kidId == freezed
          ? _value.kidId
          : kidId // ignore: cast_nullable_to_non_nullable
              as String,
      startedAt: startedAt == freezed
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
abstract class _$$BottleEventCopyWith<$Res> implements $EventCopyWith<$Res> {
  factory _$$BottleEventCopyWith(
          _$BottleEvent value, $Res Function(_$BottleEvent) then) =
      __$$BottleEventCopyWithImpl<$Res>;
  @override
  $Res call(
      {String id,
      String kidId,
      DateTime startedAt,
      Decimal amount,
      LiquidUnit unit});
}

/// @nodoc
class __$$BottleEventCopyWithImpl<$Res> extends _$EventCopyWithImpl<$Res>
    implements _$$BottleEventCopyWith<$Res> {
  __$$BottleEventCopyWithImpl(
      _$BottleEvent _value, $Res Function(_$BottleEvent) _then)
      : super(_value, (v) => _then(v as _$BottleEvent));

  @override
  _$BottleEvent get _value => super._value as _$BottleEvent;

  @override
  $Res call({
    Object? id = freezed,
    Object? kidId = freezed,
    Object? startedAt = freezed,
    Object? amount = freezed,
    Object? unit = freezed,
  }) {
    return _then(_$BottleEvent(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      kidId: kidId == freezed
          ? _value.kidId
          : kidId // ignore: cast_nullable_to_non_nullable
              as String,
      startedAt: startedAt == freezed
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      amount: amount == freezed
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as Decimal,
      unit: unit == freezed
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as LiquidUnit,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BottleEvent implements BottleEvent {
  const _$BottleEvent(
      {required this.id,
      required this.kidId,
      required this.startedAt,
      required this.amount,
      required this.unit,
      final String? $type})
      : $type = $type ?? 'bottle';

  factory _$BottleEvent.fromJson(Map<String, dynamic> json) =>
      _$$BottleEventFromJson(json);

  @override
  final String id;
  @override
  final String kidId;
  @override
  final DateTime startedAt;
  @override
  final Decimal amount;
  @override
  final LiquidUnit unit;

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'Event.bottle(id: $id, kidId: $kidId, startedAt: $startedAt, amount: $amount, unit: $unit)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BottleEvent &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.kidId, kidId) &&
            const DeepCollectionEquality().equals(other.startedAt, startedAt) &&
            const DeepCollectionEquality().equals(other.amount, amount) &&
            const DeepCollectionEquality().equals(other.unit, unit));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(kidId),
      const DeepCollectionEquality().hash(startedAt),
      const DeepCollectionEquality().hash(amount),
      const DeepCollectionEquality().hash(unit));

  @JsonKey(ignore: true)
  @override
  _$$BottleEventCopyWith<_$BottleEvent> get copyWith =>
      __$$BottleEventCopyWithImpl<_$BottleEvent>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String id, String kidId, DateTime startedAt,
            Decimal amount, LiquidUnit unit)
        bottle,
    required TResult Function(
            String id, String kidId, DateTime startedAt, DiaperType diaperType)
        diaper,
    required TResult Function(
            String id, String kidId, DateTime startedAt, DateTime? endedAt)
        sleep,
  }) {
    return bottle(id, kidId, startedAt, amount, unit);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String id, String kidId, DateTime startedAt,
            Decimal amount, LiquidUnit unit)?
        bottle,
    TResult Function(
            String id, String kidId, DateTime startedAt, DiaperType diaperType)?
        diaper,
    TResult Function(
            String id, String kidId, DateTime startedAt, DateTime? endedAt)?
        sleep,
  }) {
    return bottle?.call(id, kidId, startedAt, amount, unit);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String id, String kidId, DateTime startedAt,
            Decimal amount, LiquidUnit unit)?
        bottle,
    TResult Function(
            String id, String kidId, DateTime startedAt, DiaperType diaperType)?
        diaper,
    TResult Function(
            String id, String kidId, DateTime startedAt, DateTime? endedAt)?
        sleep,
    required TResult orElse(),
  }) {
    if (bottle != null) {
      return bottle(id, kidId, startedAt, amount, unit);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BottleEvent value) bottle,
    required TResult Function(DiaperEvent value) diaper,
    required TResult Function(SleepEvent value) sleep,
  }) {
    return bottle(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(BottleEvent value)? bottle,
    TResult Function(DiaperEvent value)? diaper,
    TResult Function(SleepEvent value)? sleep,
  }) {
    return bottle?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BottleEvent value)? bottle,
    TResult Function(DiaperEvent value)? diaper,
    TResult Function(SleepEvent value)? sleep,
    required TResult orElse(),
  }) {
    if (bottle != null) {
      return bottle(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$BottleEventToJson(
      this,
    );
  }
}

abstract class BottleEvent implements Event {
  const factory BottleEvent(
      {required final String id,
      required final String kidId,
      required final DateTime startedAt,
      required final Decimal amount,
      required final LiquidUnit unit}) = _$BottleEvent;

  factory BottleEvent.fromJson(Map<String, dynamic> json) =
      _$BottleEvent.fromJson;

  @override
  String get id;
  @override
  String get kidId;
  @override
  DateTime get startedAt;
  Decimal get amount;
  LiquidUnit get unit;
  @override
  @JsonKey(ignore: true)
  _$$BottleEventCopyWith<_$BottleEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DiaperEventCopyWith<$Res> implements $EventCopyWith<$Res> {
  factory _$$DiaperEventCopyWith(
          _$DiaperEvent value, $Res Function(_$DiaperEvent) then) =
      __$$DiaperEventCopyWithImpl<$Res>;
  @override
  $Res call(
      {String id, String kidId, DateTime startedAt, DiaperType diaperType});
}

/// @nodoc
class __$$DiaperEventCopyWithImpl<$Res> extends _$EventCopyWithImpl<$Res>
    implements _$$DiaperEventCopyWith<$Res> {
  __$$DiaperEventCopyWithImpl(
      _$DiaperEvent _value, $Res Function(_$DiaperEvent) _then)
      : super(_value, (v) => _then(v as _$DiaperEvent));

  @override
  _$DiaperEvent get _value => super._value as _$DiaperEvent;

  @override
  $Res call({
    Object? id = freezed,
    Object? kidId = freezed,
    Object? startedAt = freezed,
    Object? diaperType = freezed,
  }) {
    return _then(_$DiaperEvent(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      kidId: kidId == freezed
          ? _value.kidId
          : kidId // ignore: cast_nullable_to_non_nullable
              as String,
      startedAt: startedAt == freezed
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      diaperType: diaperType == freezed
          ? _value.diaperType
          : diaperType // ignore: cast_nullable_to_non_nullable
              as DiaperType,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DiaperEvent implements DiaperEvent {
  const _$DiaperEvent(
      {required this.id,
      required this.kidId,
      required this.startedAt,
      required this.diaperType,
      final String? $type})
      : $type = $type ?? 'diaper';

  factory _$DiaperEvent.fromJson(Map<String, dynamic> json) =>
      _$$DiaperEventFromJson(json);

  @override
  final String id;
  @override
  final String kidId;
  @override
  final DateTime startedAt;
  @override
  final DiaperType diaperType;

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'Event.diaper(id: $id, kidId: $kidId, startedAt: $startedAt, diaperType: $diaperType)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DiaperEvent &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.kidId, kidId) &&
            const DeepCollectionEquality().equals(other.startedAt, startedAt) &&
            const DeepCollectionEquality()
                .equals(other.diaperType, diaperType));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(kidId),
      const DeepCollectionEquality().hash(startedAt),
      const DeepCollectionEquality().hash(diaperType));

  @JsonKey(ignore: true)
  @override
  _$$DiaperEventCopyWith<_$DiaperEvent> get copyWith =>
      __$$DiaperEventCopyWithImpl<_$DiaperEvent>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String id, String kidId, DateTime startedAt,
            Decimal amount, LiquidUnit unit)
        bottle,
    required TResult Function(
            String id, String kidId, DateTime startedAt, DiaperType diaperType)
        diaper,
    required TResult Function(
            String id, String kidId, DateTime startedAt, DateTime? endedAt)
        sleep,
  }) {
    return diaper(id, kidId, startedAt, diaperType);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String id, String kidId, DateTime startedAt,
            Decimal amount, LiquidUnit unit)?
        bottle,
    TResult Function(
            String id, String kidId, DateTime startedAt, DiaperType diaperType)?
        diaper,
    TResult Function(
            String id, String kidId, DateTime startedAt, DateTime? endedAt)?
        sleep,
  }) {
    return diaper?.call(id, kidId, startedAt, diaperType);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String id, String kidId, DateTime startedAt,
            Decimal amount, LiquidUnit unit)?
        bottle,
    TResult Function(
            String id, String kidId, DateTime startedAt, DiaperType diaperType)?
        diaper,
    TResult Function(
            String id, String kidId, DateTime startedAt, DateTime? endedAt)?
        sleep,
    required TResult orElse(),
  }) {
    if (diaper != null) {
      return diaper(id, kidId, startedAt, diaperType);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BottleEvent value) bottle,
    required TResult Function(DiaperEvent value) diaper,
    required TResult Function(SleepEvent value) sleep,
  }) {
    return diaper(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(BottleEvent value)? bottle,
    TResult Function(DiaperEvent value)? diaper,
    TResult Function(SleepEvent value)? sleep,
  }) {
    return diaper?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BottleEvent value)? bottle,
    TResult Function(DiaperEvent value)? diaper,
    TResult Function(SleepEvent value)? sleep,
    required TResult orElse(),
  }) {
    if (diaper != null) {
      return diaper(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$DiaperEventToJson(
      this,
    );
  }
}

abstract class DiaperEvent implements Event {
  const factory DiaperEvent(
      {required final String id,
      required final String kidId,
      required final DateTime startedAt,
      required final DiaperType diaperType}) = _$DiaperEvent;

  factory DiaperEvent.fromJson(Map<String, dynamic> json) =
      _$DiaperEvent.fromJson;

  @override
  String get id;
  @override
  String get kidId;
  @override
  DateTime get startedAt;
  DiaperType get diaperType;
  @override
  @JsonKey(ignore: true)
  _$$DiaperEventCopyWith<_$DiaperEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SleepEventCopyWith<$Res> implements $EventCopyWith<$Res> {
  factory _$$SleepEventCopyWith(
          _$SleepEvent value, $Res Function(_$SleepEvent) then) =
      __$$SleepEventCopyWithImpl<$Res>;
  @override
  $Res call({String id, String kidId, DateTime startedAt, DateTime? endedAt});
}

/// @nodoc
class __$$SleepEventCopyWithImpl<$Res> extends _$EventCopyWithImpl<$Res>
    implements _$$SleepEventCopyWith<$Res> {
  __$$SleepEventCopyWithImpl(
      _$SleepEvent _value, $Res Function(_$SleepEvent) _then)
      : super(_value, (v) => _then(v as _$SleepEvent));

  @override
  _$SleepEvent get _value => super._value as _$SleepEvent;

  @override
  $Res call({
    Object? id = freezed,
    Object? kidId = freezed,
    Object? startedAt = freezed,
    Object? endedAt = freezed,
  }) {
    return _then(_$SleepEvent(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      kidId: kidId == freezed
          ? _value.kidId
          : kidId // ignore: cast_nullable_to_non_nullable
              as String,
      startedAt: startedAt == freezed
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endedAt: endedAt == freezed
          ? _value.endedAt
          : endedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SleepEvent implements SleepEvent {
  const _$SleepEvent(
      {required this.id,
      required this.kidId,
      required this.startedAt,
      this.endedAt,
      final String? $type})
      : $type = $type ?? 'sleep';

  factory _$SleepEvent.fromJson(Map<String, dynamic> json) =>
      _$$SleepEventFromJson(json);

  @override
  final String id;
  @override
  final String kidId;
  @override
  final DateTime startedAt;
  @override
  final DateTime? endedAt;

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'Event.sleep(id: $id, kidId: $kidId, startedAt: $startedAt, endedAt: $endedAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SleepEvent &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.kidId, kidId) &&
            const DeepCollectionEquality().equals(other.startedAt, startedAt) &&
            const DeepCollectionEquality().equals(other.endedAt, endedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(kidId),
      const DeepCollectionEquality().hash(startedAt),
      const DeepCollectionEquality().hash(endedAt));

  @JsonKey(ignore: true)
  @override
  _$$SleepEventCopyWith<_$SleepEvent> get copyWith =>
      __$$SleepEventCopyWithImpl<_$SleepEvent>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String id, String kidId, DateTime startedAt,
            Decimal amount, LiquidUnit unit)
        bottle,
    required TResult Function(
            String id, String kidId, DateTime startedAt, DiaperType diaperType)
        diaper,
    required TResult Function(
            String id, String kidId, DateTime startedAt, DateTime? endedAt)
        sleep,
  }) {
    return sleep(id, kidId, startedAt, endedAt);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String id, String kidId, DateTime startedAt,
            Decimal amount, LiquidUnit unit)?
        bottle,
    TResult Function(
            String id, String kidId, DateTime startedAt, DiaperType diaperType)?
        diaper,
    TResult Function(
            String id, String kidId, DateTime startedAt, DateTime? endedAt)?
        sleep,
  }) {
    return sleep?.call(id, kidId, startedAt, endedAt);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String id, String kidId, DateTime startedAt,
            Decimal amount, LiquidUnit unit)?
        bottle,
    TResult Function(
            String id, String kidId, DateTime startedAt, DiaperType diaperType)?
        diaper,
    TResult Function(
            String id, String kidId, DateTime startedAt, DateTime? endedAt)?
        sleep,
    required TResult orElse(),
  }) {
    if (sleep != null) {
      return sleep(id, kidId, startedAt, endedAt);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BottleEvent value) bottle,
    required TResult Function(DiaperEvent value) diaper,
    required TResult Function(SleepEvent value) sleep,
  }) {
    return sleep(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(BottleEvent value)? bottle,
    TResult Function(DiaperEvent value)? diaper,
    TResult Function(SleepEvent value)? sleep,
  }) {
    return sleep?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BottleEvent value)? bottle,
    TResult Function(DiaperEvent value)? diaper,
    TResult Function(SleepEvent value)? sleep,
    required TResult orElse(),
  }) {
    if (sleep != null) {
      return sleep(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$SleepEventToJson(
      this,
    );
  }
}

abstract class SleepEvent implements Event {
  const factory SleepEvent(
      {required final String id,
      required final String kidId,
      required final DateTime startedAt,
      final DateTime? endedAt}) = _$SleepEvent;

  factory SleepEvent.fromJson(Map<String, dynamic> json) =
      _$SleepEvent.fromJson;

  @override
  String get id;
  @override
  String get kidId;
  @override
  DateTime get startedAt;
  DateTime? get endedAt;
  @override
  @JsonKey(ignore: true)
  _$$SleepEventCopyWith<_$SleepEvent> get copyWith =>
      throw _privateConstructorUsedError;
}
