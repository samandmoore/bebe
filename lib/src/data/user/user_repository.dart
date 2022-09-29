import 'package:bebe/src/data/api_result.dart';
import 'package:bebe/src/data/user/auth_repository.dart';
import 'package:bebe/src/data/user/kid.dart';
import 'package:bebe/src/data/user/session.dart';
import 'package:bebe/src/data/user/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final userRepositoryProvider = ChangeNotifierProvider((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return UserRepository(authRepository: authRepo);
});

Dio buildDioClient() {
  return Dio()..options.baseUrl = 'http://localhost:3000';
}

class UserRepository with ChangeNotifier {
  final Dio _dio;
  final AuthRepository _authRepository;

  UserRepository({
    Dio? dio,
    FlutterSecureStorage storage = const FlutterSecureStorage(),
    AuthRepository? authRepository,
  })  : _dio = dio ?? buildDioClient(),
        _authRepository = authRepository ?? AuthRepository();

  Future<ApiResult<User>> getUser() async {
    return ApiResult.from(() async {
      final header = await _getAuthHeader();
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
      final header = await _getAuthHeader();
      await _dio.put<Object?>(
        '/api/mobile/v1/current_kid',
        data: {'current_kid_id': kidId},
        options: Options(
          headers: <String, Object?>{
            'Authorization': header,
          },
        ),
      );

      notifyListeners();
      return;
    });
  }

  Future<ApiResult<void>> createKid(KidInput input) async {
    return ApiResult.from(() async {
      final header = await _getAuthHeader();
      await _dio.post<Object?>(
        '/api/mobile/v1/kids',
        data: {'kid': input.toJson()},
        options: Options(
          headers: <String, Object?>{
            'Authorization': header,
          },
        ),
      );

      notifyListeners();
      return;
    });
  }

  Future<ApiResult<void>> deleteKid(String kidId) async {
    return ApiResult.from(() async {
      final header = await _getAuthHeader();
      await _dio.delete<Object?>(
        '/api/mobile/v1/kids/$kidId',
        options: Options(
          headers: <String, Object?>{
            'Authorization': header,
          },
        ),
      );

      notifyListeners();
      return;
    });
  }

  Future<ApiResult<void>> updateKid(String kidId, KidInput input) async {
    return ApiResult.from(() async {
      final header = await _getAuthHeader();
      await _dio.put<Object?>(
        '/api/mobile/v1/kids/$kidId',
        data: {'kid': input.toJson()},
        options: Options(
          headers: <String, Object?>{
            'Authorization': header,
          },
        ),
      );

      notifyListeners();
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

  Future<String?> _getAuthHeader() async {
    return _authRepository.getAuthHeader();
  }

  Future<void> _saveAuthHeader(String? authHeader) async {
    _authRepository.storeAuthHeader(authHeader);
  }
}
