import 'package:bebe/src/data/events/event.dart';
import 'package:bebe/src/data/events/event_repository.dart';
import 'package:bebe/src/data/http/http_client.dart';
import 'package:bebe/src/data/liquid_unit.dart';
import 'package:bebe/src/data/user/auth_repository.dart';
import 'package:bebe/src/data/user/kid.dart';
import 'package:bebe/src/data/user/user_repository.dart';
import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final httpClientProvider = Provider((ref) => buildDioClient());

final authRepositoryProvider =
    ChangeNotifierProvider((ref) => AuthRepository());

final userRepositoryProvider = ChangeNotifierProvider((ref) {
  final httpClient = ref.watch(httpClientProvider);
  final authRepo = ref.watch(authRepositoryProvider);
  return UserRepository(authRepository: authRepo, httpClient: httpClient);
});

final eventRepositoryProvider = ChangeNotifierProvider((ref) {
  final httpClient = ref.watch(httpClientProvider);
  final authRepo = ref.watch(authRepositoryProvider);
  final repo = EventRepository(
    authRepository: authRepo,
    httpClient: httpClient,
  );
  ref.onDispose(() {
    repo.dispose();
  });
  return repo;
});

final editingDiaperEventProvider = Provider<DiaperEvent?>((_) => null);

final userProvider = FutureProvider.autoDispose((ref) async {
  final repo = ref.watch(userRepositoryProvider);
  repo.addListener(() => ref.invalidateSelf());

  final user = await repo.getUser();
  return user.map(
    success: (data) => data,
    error: (error) => throw error,
    validationError: (error) => throw error,
  );
});

final kidsProvider = FutureProvider.autoDispose((ref) async {
  final user = await ref.watch(userProvider.future);
  return user.kids;
});

final currentKidProvider = FutureProvider.autoDispose((ref) async {
  final kids = await ref.watch(kidsProvider.future);
  final kid = kids.firstWhereOrNull((k) => k.isCurrent) ?? kids.first;
  return kid;
});

final editingKidProvider = Provider<Kid?>((_) => null);

final liquidUnitProvider = StateProvider((_) => LiquidUnit.ml);
