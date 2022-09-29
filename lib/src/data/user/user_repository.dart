import 'package:bebe/src/data/api_result.dart';
import 'package:bebe/src/data/user/kid.dart';
import 'package:bebe/src/data/user/session.dart';
import 'package:bebe/src/data/user/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final userRepositoryProvider =
    ChangeNotifierProvider((ref) => UserRepository());

Dio buildDioClient() {
  return Dio()..options.baseUrl = 'http://localhost:3000';
}

class UserRepository with ChangeNotifier {
  static const _authHeaderStorageKey = 'auth_header';

  final Dio _dio;
  final FlutterSecureStorage _storage;

  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  UserRepository({
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

  Future<ApiResult<User>> getUser() async {
    return ApiResult.from(() async {
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
    });
  }

  Future<ApiResult<void>> updateCurrentKid(String kidId) async {
    return ApiResult.from(() async {
      final header = await getAuthHeader();
      await _dio.put<Object?>(
        '/api/mobile/v1/current_kid',
        data: {'current_kid_id': kidId},
        options: Options(
          headers: <String, Object?>{
            'Authorization': header,
          },
        ),
      );

      return;
    });
  }

  Future<ApiResult<void>> createKid(KidInput input) async {
    return ApiResult.from(() async {
      final header = await getAuthHeader();
      await _dio.post<Object?>(
        '/api/mobile/v1/kids',
        data: {'kid': input.toJson()},
        options: Options(
          headers: <String, Object?>{
            'Authorization': header,
          },
        ),
      );

      return;
    });
  }

  Future<ApiResult<void>> deleteKid(String kidId) async {
    return ApiResult.from(() async {
      final header = await getAuthHeader();
      await _dio.delete<Object?>(
        '/api/mobile/v1/kids/$kidId',
        options: Options(
          headers: <String, Object?>{
            'Authorization': header,
          },
        ),
      );

      return;
    });
  }

  Future<ApiResult<void>> updateKid(String kidId, KidInput input) async {
    return ApiResult.from(() async {
      final header = await getAuthHeader();
      await _dio.put<Object?>(
        '/api/mobile/v1/kids/$kidId',
        data: {'kid': input.toJson()},
        options: Options(
          headers: <String, Object?>{
            'Authorization': header,
          },
        ),
      );

      return;
    });
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
