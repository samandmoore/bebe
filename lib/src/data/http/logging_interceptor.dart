import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';

/// [SimpleLoggingInterceptor] is used to print logs during network requests,
/// usually during development and debug workflows during .
class SimpleLoggingInterceptor extends Interceptor {
  final void Function(
    String message, {
    DateTime? time,
    int? sequenceNumber,
    int level,
    String name,
    Zone? zone,
    Object? error,
    StackTrace? stackTrace,
  }) logger;

  SimpleLoggingInterceptor({this.logger = log});

  @override
  Future onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    logger('HttpClient - ⬆️ [${options.method}] ${options.uri}');
    if (options.data != null) {
      logger('\t data: ${options.data}');
    }
    super.onRequest(options, handler);
  }

  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode != null
        ? ' [${err.response!.statusCode}]'
        : '';
    final requestUri = ' ${err.requestOptions.uri}';

    logger('HttpClient - 🛑 ERROR$statusCode$requestUri');
    if (err.response?.data != null) {
      logger('\t data: ${err.response!.data}');
    } else {
      logger('\t message: ${err.message}');
    }
    super.onError(err, handler);
  }

  @override
  Future onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    logger(
      'HttpClient - ⬇️ [${response.statusCode}] ${response.requestOptions.uri}',
    );
    if (response.data != null) {
      logger('\t data: ${response.data}');
    }
    super.onResponse(response, handler);
  }
}
