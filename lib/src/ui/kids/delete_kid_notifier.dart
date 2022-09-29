import 'package:bebe/src/data/user/kid.dart';
import 'package:bebe/src/data/user/user_repository.dart';
import 'package:bebe/src/ui/kids/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeleteKidNotifier extends StateNotifier<AsyncValue<String?>> {
  final Ref ref;
  final Kid kid;

  DeleteKidNotifier(this.ref, {required this.kid})
      : super(const AsyncValue.data(null));

  Future<void> delete() async {
    final repo = ref.read(userRepositoryProvider);

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final result = await repo.deleteKid(kid.id);
      return result.map(
        success: (_) {
          ref.invalidate(userProvider);
          return kid.id;
        },
        error: (error) => throw error,
        validationError: (errors) => throw errors,
      );
    });
  }
}
