import 'package:bebe/src/data/auth/session.dart';
import 'package:bebe/src/data/auth/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepository with ChangeNotifier {
  static const _authHeaderStorageKey = 'auth_header';

  final Dio _dio;
  final FlutterSecureStorage _storage;

  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  AuthRepository({
    Dio? dio,
    FlutterSecureStorage storage = const FlutterSecureStorage(),
  })  : _dio = dio ?? Dio()
          ..options.baseUrl = 'http://localhost:3000',
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
          'Authorization': header?.trim(),
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

class ApiResult<T> {
  ApiResult._();

  factory ApiResult.success(T data) {
    return ApiResultSuccess(data: data);
  }

  factory ApiResult.error(DioError error) {
    return ApiResultError(error: error);
  }

  factory ApiResult.validationError(Map<String, String> errors) {
    return ApiResultValidationError(errors: errors);
  }

  static Future<ApiResult<T>> from<T>(Future<T> Function() action) async {
    try {
      final data = await action();
      return ApiResult.success(data);
    } on DioError catch (e) {
      if (e.response?.statusCode == 422) {
        final rawErrors = e.response?.data['errors'] as Map<String, Object?>;
        final errors = rawErrors.map((key, value) {
          final fieldErrors = value as List<Object?>;
          final firstError = fieldErrors.first as Map<String, Object?>;
          final errorSlug = firstError['error'] as String;
          return MapEntry(key, errorSlug);
        });
        return ApiResult.validationError(errors);
      }
      return ApiResult.error(e);
    }
  }

  R map<R>({
    required R Function(T?) success,
    required R Function(DioError) error,
    required R Function(Map<String, String>) validationError,
  }) {
    if (this is ApiResultSuccess<T>) {
      return success((this as ApiResultSuccess<T>).data);
    } else if (this is ApiResultError) {
      return error((this as ApiResultError).error);
    } else if (this is ApiResultValidationError) {
      return validationError((this as ApiResultValidationError).errors);
    } else {
      throw UnimplementedError();
    }
  }
}

class ApiResultSuccess<T> extends ApiResult<T> {
  final T? data;
  ApiResultSuccess({this.data}) : super._();
}

class ApiResultError<T> extends ApiResult<T> {
  final DioError error;
  ApiResultError({required this.error}) : super._();
}

class ApiResultValidationError<T> extends ApiResult<T> {
  final Map<String, String> errors;
  ApiResultValidationError({required this.errors}) : super._();
}
