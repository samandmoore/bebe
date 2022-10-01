import 'package:dio/dio.dart';

Dio buildDioClient() {
  return Dio()..options.baseUrl = 'http://localhost:3000';
}
