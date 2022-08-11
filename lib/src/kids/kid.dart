import 'package:equatable/equatable.dart';

class Kid extends Equatable {
  final String id;
  final String name;
  final DateTime birthDate;

  const Kid({
    required this.id,
    required this.name,
    required this.birthDate,
  });

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

  @override
  List<Object?> get props => [id, name, birthDate];

  factory Kid.fromJson(Map<String, Object?> json) {
    return Kid(
      id: json['id'] as String,
      name: json['name'] as String,
      birthDate: DateTime.parse(json['birthDate'] as String),
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': name,
      'birthDate': birthDate.toIso8601String(),
    };
  }
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
