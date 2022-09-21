import 'package:bebe/src/data/kids/kid.dart';
import 'package:bebe/src/data/kids/kid_repository.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final kidRepositoryProvider = Provider<KidRepository>((ref) {
  final repo = KidRepository(ref);
  ref.onDispose(() {
    repo.dispose();
  });
  return repo;
});

final kidsProvider = FutureProvider.autoDispose((ref) async {
  final repo = ref.watch(kidRepositoryProvider);
  repo.addListener(() => ref.invalidateSelf());

  final kids = await repo.fetchAll();

  return kids;
});

final currentKidProvider = FutureProvider.autoDispose((ref) async {
  final kids = await ref.watch(kidsProvider.future);
  final kid = kids.firstWhereOrNull((k) => k.isCurrent) ?? kids.first;
  return kid;
});

final editingKidProvider = Provider<Kid?>((_) => null);
