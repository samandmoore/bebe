import 'package:bebe/src/data/auth/auth_repository.dart';
import 'package:bebe/src/data/kids/kid.dart';
import 'package:bebe/src/ui/kids/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

enum NewKidResult {
  success,
  error,
}

class NewKidNotifier extends StateNotifier<AsyncValue<NewKidResult?>> {
  final form = FormGroup({
    'name': FormControl<String>(
      validators: [Validators.required],
    ),
    'dateOfBirth': FormControl<DateTime>(
      validators: [Validators.required],
    ),
  });

  final Ref ref;

  NewKidNotifier(this.ref) : super(const AsyncValue.data(null));

  Future<void> create() async {
    if (!form.valid) {
      form.markAllAsTouched();
      return;
    }

    final repo = ref.read(authRepositoryProvider);
    final input = KidInput(
      name: form.control('name').value as String,
      dateOfBirth: form.control('dateOfBirth').value as DateTime,
    );

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final result = await repo.createKid(input);
      return result.map(
        success: (_) {
          ref.invalidate(userProvider);
          return NewKidResult.success;
        },
        error: (error) => throw error,
        validationError: (errors) => throw errors,
      );
    });
  }
}
