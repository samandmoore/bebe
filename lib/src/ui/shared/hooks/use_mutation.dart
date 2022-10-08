import 'package:bebe/src/utilities/extensions.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Mutation<T> {
  final AsyncValue<T?> result;
  final Future<T> Function() run;

  const Mutation(this.result, this.run);
}

Mutation<T> useMutation<T extends Object?>(
  Future<T> Function() action,
) {
  final asyncValue = useState<AsyncValue<T?>>(const AsyncValue.data(null));
  final context = useContext();
  final isMounted = useIsMounted();

  Future<T> actionWrapper() async {
    try {
      asyncValue.value = const AsyncValue.loading();
      final result = await action();
      asyncValue.value = AsyncValue.data(result);
      return result;
    } catch (e, s) {
      if (isMounted()) {
        context.logErrorAndShowSnackbar(e, s);
      }
      asyncValue.value = AsyncValue.error(e, s);
      rethrow;
    } finally {
      asyncValue.value = const AsyncValue.data(null);
    }
  }

  return Mutation(asyncValue.value, actionWrapper);
}
