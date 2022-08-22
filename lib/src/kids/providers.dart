import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'kid.dart';
import 'kid_repository.dart';

final kidRepositoryProvider = Provider<KidRepository>((ref) {
  return KidRepository(ref);
});

final kidsProvider = FutureProvider.autoDispose((ref) async {
  final repo = ref.watch(kidRepositoryProvider);
  final selectedKid = ref.read(selectedKidProvider.notifier);

  final kids = await repo.fetchAll();

  final currentKid = kids.firstWhereOrNull((k) => k.isCurrent);
  selectedKid.state = currentKid;

  return kids;
});

final selectedKidProvider = StateProvider<Kid?>((_) => null);

final editingKidProvider = StateProvider<Kid?>((_) => null);
