import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'kid.freezed.dart';
part 'kid.g.dart';

@freezed
class Kid with _$Kid {
  const Kid._();

  const factory Kid({
    required String id,
    required String name,
    required DateTime birthDate,
    @Default(false) bool isCurrent,
  }) = _Kid;

  String toPrettyAge() {
    final now = DateTime.now();
    final age = now.difference(birthDate);
    final months = (age.inDays ~/ 30) % 12;
    final days = age.inDays % 30;

    if (months >= 12) {
      return '${months ~/ 12} years';
    }

    return '$months months, $days days';
  }

  factory Kid.fromJson(Map<String, Object?> json) => _$KidFromJson(json);
}

class KidInput extends Equatable {
  final String name;
  final DateTime birthDate;

  const KidInput({
    required this.name,
    required this.birthDate,
  });

  @override
  List<Object?> get props => [name, birthDate];
}
