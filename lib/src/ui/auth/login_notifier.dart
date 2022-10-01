import 'package:bebe/src/data/user/session.dart';
import 'package:bebe/src/ui/providers.dart';
import 'package:bebe/src/utilities/extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

enum LoginResult { success, failure }

class LoginNotifier extends StateNotifier<AsyncValue<LoginResult?>> {
  final FormGroup form;
  final Ref ref;

  LoginNotifier(this.ref)
      : form = FormGroup({
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
      final result = await repo.createSession(
        SessionInput(
          email: form.value['email'] as String,
          password: form.value['password'] as String,
        ),
      );
      return result.map(
        success: (_) => LoginResult.success,
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
