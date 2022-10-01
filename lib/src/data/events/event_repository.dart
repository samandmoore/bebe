import 'package:bebe/src/data/api_result.dart';
import 'package:bebe/src/data/events/event.dart';
import 'package:bebe/src/data/user/auth_repository.dart';
import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

Dio buildDioClient() {
  return Dio()..options.baseUrl = 'http://localhost:3000';
}

class EventRepository with ChangeNotifier {
  final Dio _dio;
  final AuthRepository _authRepository;

  EventRepository({
    Dio? dio,
    AuthRepository? authRepository,
  })  : _dio = dio ?? buildDioClient(),
        _authRepository = authRepository ?? AuthRepository();

  Future<Map<EventType, Event?>> getLatestByTypes(
    final String kidId,
    List<EventType> eventTypes,
  ) async {
    final result = await fetchAllForKid(kidId);
    final all = result.successOrThrow().events;
    final grouped = all.groupListsBy((e) => e.eventType);
    final sorted = grouped.map((key, value) => MapEntry(
          key,
          value..sortBy((e) => e.startedAt),
        ));

    return Map.fromEntries(
      eventTypes.map(
        (eventType) => MapEntry(eventType, sorted[eventType]?.last),
      ),
    );
  }

  Future<ApiResult<EventPage>> fetchAllForKid(
    String kidId, {
    String? cursor,
  }) async {
    return ApiResult.from(() async {
      final header = await _getAuthHeader();
      final response = await _dio.get<Object?>(
        '/api/mobile/v1/kids/$kidId/events',
        queryParameters: <String, Object?>{'cursor': cursor},
        options: Options(
          headers: <String, Object?>{
            'Authorization': header,
          },
        ),
      );

      return EventPage.fromJson(response.data as Map<String, Object?>);
    });
  }

  Future<ApiResult<void>> createDiaperEvent(
      final DiaperEventInput input) async {
    return ApiResult.from(() async {
      final header = await _getAuthHeader();
      await _dio.post<Object?>(
        '/api/mobile/v1/kids/${input.kidId}/diaper_events',
        data: {'diaper_event': input.toJson()},
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

  Future<ApiResult<void>> updateDiaperEvent(DiaperEventUpdate update) async {
    return ApiResult.from(() async {
      final header = await _getAuthHeader();
      await _dio.put<Object?>(
        '/api/mobile/v1/kids/${update.kidId}/diaper_events/${update.id}',
        data: {'diaper_event': update.toJson()},
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

  Future<ApiResult<void>> delete(String eventId) async {
    return ApiResult.from(() async {
      final header = await _getAuthHeader();
      await _dio.delete<Object?>(
        '/api/mobile/v1/events/$eventId',
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

  Future<String?> _getAuthHeader() async {
    return _authRepository.getAuthHeader();
  }
}
