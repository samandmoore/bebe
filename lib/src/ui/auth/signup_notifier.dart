import 'package:bebe/src/data/user/user.dart';
import 'package:bebe/src/ui/providers.dart';
import 'package:bebe/src/utilities/extensions.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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

    final repo = ref.read(userRepositoryProvider);

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final result = await repo.createUser(
        UserInput(
          name: form.value['name'] as String,
          email: form.value['email'] as String,
          password: form.value['password'] as String,
        ),
      );
      return result.map(
        success: (_) => SignupResult.success,
        error: (e) => throw e,
        validationError: (errors) {
          form.setErrorsForControls(errors);
          return null;
        },
      );
    });
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}
