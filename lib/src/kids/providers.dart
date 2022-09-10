import 'package:bebe/src/kids/kid.dart';
import 'package:bebe/src/kids/kid_repository.dart';
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
  return kids.firstWhere((k) => k.isCurrent);
});

final editingKidProvider = Provider<Kid?>((_) => null);
