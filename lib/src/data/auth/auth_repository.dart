import 'package:bebe/src/data/api_result.dart';
import 'package:bebe/src/data/auth/session.dart';
import 'package:bebe/src/data/auth/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final authRepositoryProvider =
    ChangeNotifierProvider((ref) => AuthRepository());

Dio buildDioClient() {
  return Dio()..options.baseUrl = 'http://localhost:3000';
}

class AuthRepository with ChangeNotifier {
  static const _authHeaderStorageKey = 'auth_header';

  final Dio _dio;
  final FlutterSecureStorage _storage;

  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  AuthRepository({
    Dio? dio,
    FlutterSecureStorage storage = const FlutterSecureStorage(),
  })  : _dio = dio ?? buildDioClient(),
        _storage = storage;

  Future<void> initialize() async {
    final authHeader = await _storage.read(key: _authHeaderStorageKey);
    if (authHeader != null) {
      _isLoggedIn = true;
      notifyListeners();
    }
  }

  Future<String?> getAuthHeader() async {
    final header = await _storage.read(key: _authHeaderStorageKey);
    return header;
  }

  Future<void> logout() async {
    await _storage.delete(key: _authHeaderStorageKey);
    _isLoggedIn = false;
    notifyListeners();
  }

  Future<User> getUser() async {
    final header = await getAuthHeader();
    final response = await _dio.get<Object?>(
      '/api/mobile/v1/current_user',
      options: Options(
        headers: <String, Object?>{
          'Authorization': header,
        },
      ),
    );
    return User.fromJson(response.data as Map<String, Object?>);
  }

  Future<ApiResult<User>> createUser(UserInput input) async {
    return ApiResult.from(() async {
      final response = await _dio.post<Object?>(
        '/api/mobile/v1/users',
        data: {'user': input.toJson()},
      );
      final authHeader = response.headers.value('authorization');
      await _saveAuthHeader(authHeader);
      return User.fromJson(response.data as Map<String, Object?>);
    });
  }

  Future<ApiResult<void>> createSession(SessionInput input) async {
    return ApiResult.from(() async {
      final response = await _dio.post<Object?>(
        '/api/mobile/v1/sessions',
        data: {'user': input.toJson()},
      );
      final authHeader = response.headers.value('authorization');
      await _saveAuthHeader(authHeader);
    });
  }

  Future<void> _saveAuthHeader(String? authHeader) async {
    await _storage.write(key: _authHeaderStorageKey, value: authHeader);
    _isLoggedIn = true;
    notifyListeners();
  }
}
