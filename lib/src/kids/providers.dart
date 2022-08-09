import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'kid.dart';
import 'kid_repository.dart';

final kidRepositoryProvider = Provider<KidRepository>((_) {
  return KidRepository();
});

final kidsProvider = FutureProvider.autoDispose((ref) async {
  final repo = ref.watch(kidRepositoryProvider);
  final selectedKid = ref.read(selectedKidProvider.notifier);

  final kids = await repo.fetchAll();

  // this should be remote state...
  // but for now, we'll just use local state
  if (kids.isEmpty) {
    selectedKid.state = null;
  } else if (!kids.contains(selectedKid.state)) {
    selectedKid.state = selectedKid.state;
  } else {
    selectedKid.state = kids.first;
  }

  return kids;
});

final selectedKidProvider = StateProvider<Kid?>((_) => null);

final editingKidProvider = StateProvider<Kid?>((_) => null);
