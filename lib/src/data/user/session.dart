class SessionInput {
  final String email;
  final String password;

  SessionInput({
    required this.email,
    required this.password,
  });

  Map<String, Object?> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}
