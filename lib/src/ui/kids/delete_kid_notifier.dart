import 'package:bebe/src/data/auth/auth_repository.dart';
import 'package:bebe/src/data/kids/kid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeleteKidNotifier extends StateNotifier<AsyncValue<String?>> {
  final Ref ref;
  final Kid kid;

  DeleteKidNotifier(this.ref, {required this.kid})
      : super(const AsyncValue.data(null));

  Future<void> delete() async {
    final repo = ref.read(authRepositoryProvider);

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final result = await repo.deleteKid(kid.id);
      return result.map(
        success: (_) => kid.id,
        error: (error) => throw error,
        validationError: (errors) => throw errors,
      );
    });
  }
}
