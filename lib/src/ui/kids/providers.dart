import 'package:bebe/src/data/auth/auth_repository.dart';
import 'package:bebe/src/data/kids/kid.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final kidsProvider = FutureProvider.autoDispose((ref) async {
  final repo = ref.watch(authRepositoryProvider);
  repo.addListener(() => ref.invalidateSelf());

  final user = await repo.getUser();
  return user.map(
    success: ((data) => data!.kids),
    error: (error) => throw error,
    validationError: (error) => throw error,
  );
});

final currentKidProvider = FutureProvider.autoDispose((ref) async {
  final kids = await ref.watch(kidsProvider.future);
  final kid = kids.firstWhereOrNull((k) => k.isCurrent) ?? kids.first;
  return kid;
});

final editingKidProvider = Provider<Kid?>((_) => null);
