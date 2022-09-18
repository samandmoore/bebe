import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String name,
    required String email,
  }) = _User;

  factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);
}

class UserInput {
  final String name;
  final String email;
  final String password;

  UserInput({
    required this.name,
    required this.email,
    required this.password,
  });

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
    };
  }
}
