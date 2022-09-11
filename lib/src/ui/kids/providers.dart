import 'package:bebe/src/data/kids/kid.dart';
import 'package:bebe/src/data/kids/kid_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final kidRepositoryProvider = Provider<KidRepository>((ref) {
  return KidRepository(ref);
});

final kidsProvider = FutureProvider.autoDispose((ref) async {
  final repo = ref.watch(kidRepositoryProvider);

  final kids = await repo.fetchAll();

  return kids;
});

final currentKidProvider = FutureProvider.autoDispose((ref) async {
  final kids = await ref.watch(kidsProvider.future);
  final kid = kids.firstWhere((k) => k.isCurrent);
  return kid;
});

final editingKidProvider = Provider<Kid?>((_) => null);
