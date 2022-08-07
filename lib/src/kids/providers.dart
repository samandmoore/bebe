import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'kid_repository.dart';

final kidRepositoryProvider = Provider<KidRepository>((_) {
  return KidRepository();
});

final kidsProvider = FutureProvider.autoDispose((ref) async {
  final repo = ref.watch(kidRepositoryProvider);

  return repo.fetchAll();
});

final currentKidProvider = StateProvider((_) => 0);
