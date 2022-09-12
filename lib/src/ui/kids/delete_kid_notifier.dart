import 'package:bebe/src/data/kids/kid.dart';
import 'package:bebe/src/ui/kids/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeleteKidNotifier extends StateNotifier<AsyncValue<String?>> {
  final Ref ref;
  final Kid kid;

  DeleteKidNotifier(this.ref, {required this.kid})
      : super(const AsyncValue.data(null));

  Future<void> delete() async {
    final repo = ref.read(kidRepositoryProvider);

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await repo.delete(kid.id);
      return kid.id;
    });
  }
}
