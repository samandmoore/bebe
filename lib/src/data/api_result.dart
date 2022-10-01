import 'package:dio/dio.dart';

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
    required R Function(T data) success,
    required R Function(DioError error) error,
    required R Function(Map<String, String> errors) validationError,
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

  T unwrapOrThrow() {
    return map(
      success: (data) => data,
      error: (error) => throw error,
      validationError: (errors) => throw errors,
    );
  }
}

class ApiResultSuccess<T> extends ApiResult<T> {
  final T data;
  ApiResultSuccess({required this.data}) : super._();
}

class ApiResultError<T> extends ApiResult<T> {
  final DioError error;
  ApiResultError({required this.error}) : super._();
}

class ApiResultValidationError<T> extends ApiResult<T> {
  final Map<String, String> errors;
  ApiResultValidationError({required this.errors}) : super._();
}
