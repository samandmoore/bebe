import 'package:bebe/src/data/auth/auth_repository.dart';
import 'package:bebe/src/data/kids/kid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

enum EditKidResult {
  success,
  error,
}

class EditKidNotifier extends StateNotifier<AsyncValue<EditKidResult?>> {
  final FormGroup form;
  final Ref ref;
  final Kid kid;

  EditKidNotifier(this.ref, {required this.kid})
      : form = FormGroup({
          'name': FormControl<String>(
            validators: [Validators.required],
            value: kid.name,
          ),
          'dateOfBirth': FormControl<DateTime>(
            validators: [Validators.required],
            value: kid.dateOfBirth,
          ),
        }),
        super(const AsyncValue.data(null));

  Future<void> update() async {
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
      final result = await repo.updateKid(kid.id, input);
      return result.map(
        success: (_) => EditKidResult.success,
        error: (error) => throw error,
        validationError: (errors) => throw errors,
      );
    });
  }
}
