import 'package:bebe/src/data/http/logging_interceptor.dart';
import 'package:dio/dio.dart';

Dio buildDioClient() {
  return Dio(
    BaseOptions(
      baseUrl: 'http://localhost:3000',
      connectTimeout: 2000,
      sendTimeout: 3000,
      receiveTimeout: 3000,
      listFormat: ListFormat.multiCompatible,
    ),
  )..interceptors.addAll([
      SimpleLoggingInterceptor(),
    ]);
}
