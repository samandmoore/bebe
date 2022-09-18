import 'package:bebe/src/data/auth/providers.dart';
import 'package:bebe/src/data/auth/session.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

enum LoginOrSignupResult { loggedIn, signedUp }

class LoginOrSignupNotifier
    extends StateNotifier<AsyncValue<LoginOrSignupResult?>> {
  final FormGroup form;
  final Ref ref;

  LoginOrSignupNotifier(this.ref)
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

    final repo = ref.read(authRepositoryProvider);

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await repo.createSession(
        SessionInput(
          email: form.value['email'] as String,
          password: form.value['password'] as String,
        ),
      );
      return LoginOrSignupResult.loggedIn;
    });
  }
}
