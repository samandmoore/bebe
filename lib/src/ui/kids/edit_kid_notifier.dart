import 'package:bebe/src/data/kids/kid.dart';
import 'package:bebe/src/ui/kids/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

class EditKidNotifier extends StateNotifier<AsyncValue<Kid?>> {
  final FormGroup form;
  final Ref ref;
  final Kid kid;

  EditKidNotifier(this.ref, {required this.kid})
      : form = FormGroup({
          'name': FormControl<String>(
            validators: [Validators.required],
            value: kid.name,
          ),
          'birthDate': FormControl<DateTime>(
            validators: [Validators.required],
            value: kid.birthDate,
          ),
        }),
        super(const AsyncValue.data(null));

  Future<void> update() async {
    if (!form.valid) {
      form.markAllAsTouched();
      return;
    }

    final repo = ref.read(kidRepositoryProvider);
    final input = Kid(
      id: kid.id,
      name: form.control('name').value as String,
      birthDate: form.control('birthDate').value as DateTime,
    );

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await repo.update(input);
      return input;
    });
  }
}
