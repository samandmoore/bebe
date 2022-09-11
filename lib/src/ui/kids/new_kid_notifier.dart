import 'package:bebe/src/data/kids/kid.dart';
import 'package:bebe/src/ui/kids/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

class NewKidNotifier extends StateNotifier<AsyncValue<Kid?>> {
  final form = FormGroup({
    'name': FormControl<String>(
      validators: [Validators.required],
    ),
    'birthDate': FormControl<DateTime>(
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

    final repo = ref.read(kidRepositoryProvider);
    final input = KidInput(
      name: form.control('name').value as String,
      birthDate: form.control('birthDate').value as DateTime,
    );

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final kid = await repo.create(input);
      ref.invalidate(kidsProvider);
      return kid;
    });
  }
}
