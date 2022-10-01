import 'package:bebe/src/data/events/event.dart';
import 'package:bebe/src/ui/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HistoryNotifier extends StateNotifier<AsyncValue<List<Event>>> {
  final Ref ref;
  final String kidId;

  HistoryNotifier(this.ref, this.kidId) : super(const AsyncValue.loading()) {
    fetch();
  }

  Future<void> fetch() async {
    final repo = ref.read(eventRepositoryProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final result = await repo.fetchAllForKid(kidId);
      return result.map(
        success: (data) => data!.events,
        error: (e) => throw e,
        validationError: (e) => throw e,
      );
    });
  }

  Future<void> delete(String id) async {
    final repo = ref.read(eventRepositoryProvider);
    await repo.delete(id);
    state = state.whenData((value) => value.where((e) => e.id != id).toList());
  }
}
