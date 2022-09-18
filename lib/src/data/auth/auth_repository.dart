import 'package:bebe/src/data/auth/session.dart';
import 'package:bebe/src/data/auth/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepository {
  static const _authHeaderStorageKey = 'auth_header';

  final Dio _dio;
  final FlutterSecureStorage _storage;

  AuthRepository({
    Dio? dio,
    FlutterSecureStorage storage = const FlutterSecureStorage(),
  })  : _dio = dio ?? Dio()
          ..options.baseUrl = 'http://localhost:3000',
        _storage = storage;

  Future<String?> getAuthHeader() async {
    final header = await _storage.read(key: _authHeaderStorageKey);
    return header;
  }

  Future<User> getUser() async {
    final header = await getAuthHeader();
    final response = await _dio.get<Object?>(
      '/api/mobile/v1/current_user',
      options: Options(
        headers: <String, Object?>{
          'Authorization': header?.trim(),
        },
      ),
    );
    return User.fromJson(response.data as Map<String, Object?>);
  }

  Future<User> createUser(UserInput input) async {
    final response = await _dio.post<Object?>(
      '/api/mobile/v1/users',
      data: {'user': input.toJson()},
    );
    final authHeader = response.headers.value('authorization');
    await _storage.write(key: _authHeaderStorageKey, value: authHeader);
    return User.fromJson(response.data as Map<String, Object?>);
  }

  Future<void> createSession(SessionInput input) async {
    final response = await _dio.post<Object?>(
      '/api/mobile/v1/sessions',
      data: {'user': input.toJson()},
    );
    final authHeader = response.headers.value('authorization');
    await _storage.write(key: _authHeaderStorageKey, value: authHeader);
  }
}
