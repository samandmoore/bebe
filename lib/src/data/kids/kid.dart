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
    required DateTime dateOfBirth,
    @Default(false) bool isCurrent,
  }) = _Kid;

  String toPrettyAge() {
    final now = DateTime.now();
    final age = now.difference(dateOfBirth);
    final months = (age.inDays ~/ 30) % 12;
    final years = (age.inDays ~/ 30) ~/ 12;
    final days = age.inDays % 30;

    if (years >= 1) {
      final builder = StringBuffer();
      builder.write(formatYears(years));
      if (months > 0) {
        builder.write(', ');
        builder.write(formatMonths(months));
      }
      return builder.toString();
    }

    if (months >= 1) {
      final builder = StringBuffer();
      builder.write(formatMonths(months));
      if (days > 0) {
        builder.write(', ');
        builder.write(formatDays(days));
      }
      return builder.toString();
    }

    return formatDays(days);
  }

  factory Kid.fromJson(Map<String, Object?> json) => _$KidFromJson(json);
}

String formatYears(int amount) {
  return formatForPlural(amount, 'year', 'years');
}

String formatMonths(int amount) {
  return formatForPlural(amount, 'month', 'months');
}

String formatDays(int amount) {
  return formatForPlural(amount, 'day', 'days');
}

String formatForPlural(int amount, String singular, String plural) {
  return '$amount ${amount > 1 ? plural : singular}';
}

class KidInput extends Equatable {
  final String name;
  final DateTime dateOfBirth;

  const KidInput({
    required this.name,
    required this.dateOfBirth,
  });

  @override
  List<Object?> get props => [name, dateOfBirth];
}
