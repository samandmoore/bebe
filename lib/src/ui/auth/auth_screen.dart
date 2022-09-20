import 'package:bebe/src/data/auth/providers.dart';
import 'package:bebe/src/ui/auth/login_notifier.dart';
import 'package:bebe/src/ui/auth/signup_notifier.dart';
import 'package:bebe/src/ui/shared/loading.dart';
import 'package:bebe/src/ui/shared/modal.dart';
import 'package:bebe/src/ui/shared/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

final loginProvider =
    StateNotifierProvider.autoDispose<LoginNotifier, AsyncValue<LoginResult?>>(
        (ref) {
  return LoginNotifier(ref);
}, dependencies: [
  authRepositoryProvider,
]);

final signupProvider = StateNotifierProvider.autoDispose<SignupNotifier,
    AsyncValue<SignupResult?>>((ref) {
  return SignupNotifier(ref);
}, dependencies: [
  authRepositoryProvider,
]);

enum AuthType { login, signup }

final authTypeProvider = StateProvider.autoDispose((_) => AuthType.login);

class AuthScreen extends ConsumerWidget {
  static const route = '/auth';

  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authType = ref.watch(authTypeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
      ),
      body: ListView(
        children: [
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: authType == AuthType.login
                    ? null
                    : () => ref.read(authTypeProvider.notifier).state =
                        AuthType.login,
                child: const Text('Log in'),
              ),
              const Text('or'),
              TextButton(
                onPressed: authType == AuthType.signup
                    ? null
                    : () => ref.read(authTypeProvider.notifier).state =
                        AuthType.signup,
                child: const Text('Sign Up'),
              ),
            ],
          ),
          authType == AuthType.login ? const _LoginForm() : const _SignupForm(),
        ],
      ),
    );
  }
}

class _LoginForm extends ConsumerWidget {
  const _LoginForm();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.read(loginProvider.notifier).form;
    final isSubmitting = ref.watch(loginProvider.select((v) => v.isLoading));
    return Modal(
      visible: isSubmitting,
      modal: LoadingIndicator.white(),
      child: SafeArea(
        child: ReactiveForm(
          formGroup: form,
          child: Column(
            children: [
              const VSpace(),
              ListTile(
                title: const Text('Email'),
                subtitle: ReactiveTextField<String>(
                  formControlName: 'email',
                ),
              ),
              const VSpace(),
              ListTile(
                title: const Text('Password'),
                subtitle: ReactiveTextField<String>(
                  formControlName: 'password',
                  obscureText: true,
                ),
              ),
              const VSpace(),
              ButtonBar(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final model = ref.read(loginProvider.notifier);
                      model.save();
                    },
                    child: const Text('Log in'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SignupForm extends ConsumerWidget {
  const _SignupForm();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.read(signupProvider.notifier).form;
    final isSubmitting = ref.watch(signupProvider.select((v) => v.isLoading));

    return Modal(
      visible: isSubmitting,
      modal: LoadingIndicator.white(),
      child: SafeArea(
        child: ReactiveForm(
          formGroup: form,
          child: Column(
            children: [
              const VSpace(),
              ListTile(
                title: const Text('Name'),
                subtitle: ReactiveTextField<String>(
                  formControlName: 'name',
                ),
              ),
              const VSpace(),
              ListTile(
                title: const Text('Email'),
                subtitle: ReactiveTextField<String>(
                  formControlName: 'email',
                ),
              ),
              const VSpace(),
              ListTile(
                title: const Text('Password'),
                subtitle: ReactiveTextField<String>(
                  formControlName: 'password',
                  obscureText: true,
                ),
              ),
              const VSpace(),
              ButtonBar(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final model = ref.read(signupProvider.notifier);
                      model.save();
                    },
                    child: const Text('Sign up'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
