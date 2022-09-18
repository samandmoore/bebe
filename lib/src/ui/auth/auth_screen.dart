import 'package:bebe/src/data/auth/providers.dart';
import 'package:bebe/src/ui/auth/login_or_signup_notifier.dart';
import 'package:bebe/src/ui/shared/loading.dart';
import 'package:bebe/src/ui/shared/modal.dart';
import 'package:bebe/src/ui/shared/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

final loginOrSignupProvider = StateNotifierProvider.autoDispose<
    LoginOrSignupNotifier, AsyncValue<LoginOrSignupResult?>>((ref) {
  return LoginOrSignupNotifier(ref);
}, dependencies: [
  authRepositoryProvider,
]);

class AuthScreen extends ConsumerWidget {
  static const route = '/auth';

  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.read(loginOrSignupProvider.notifier).form;
    final isSubmitting =
        ref.watch(loginOrSignupProvider.select((v) => v.isLoading));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Log-in or Sign-up'),
      ),
      body: Modal(
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
                  ),
                ),
                const VSpace(),
                ButtonBar(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final model = ref.read(loginOrSignupProvider.notifier);
                        model.save();
                      },
                      child: const Text('Log-in'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
