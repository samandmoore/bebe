import 'package:bebe/src/data/auth/providers.dart';
import 'package:bebe/src/data/auth/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

enum SignupResult { success, failure }

class SignupNotifier extends StateNotifier<AsyncValue<SignupResult?>> {
  final FormGroup form;
  final Ref ref;

  SignupNotifier(this.ref)
      : form = FormGroup({
          'name': FormControl<String>(
            validators: [Validators.required],
          ),
          'email': FormControl<String>(
            validators: [Validators.required],
          ),
          'password': FormControl<String>(
            validators: [Validators.required],
          ),
        }),
        super(const AsyncValue.data(null));

  Future<void> save() async {
    if (!form.valid) {
      form.markAllAsTouched();
      return;
    }

    final repo = ref.read(authRepositoryProvider);

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await repo.createUser(
        UserInput(
          name: form.value['name'] as String,
          email: form.value['email'] as String,
          password: form.value['password'] as String,
        ),
      );
      return SignupResult.success;
    });
  }
}
