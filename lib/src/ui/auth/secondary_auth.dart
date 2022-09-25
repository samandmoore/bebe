import 'package:bebe/src/data/auth/auth_repository.dart';
import 'package:bebe/src/ui/shared/modal.dart';
import 'package:bebe/src/ui/shared/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SecondaryAuthScreen extends ConsumerWidget {
  static const route = '/secondary-auth';

  const SecondaryAuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Locked for your safety!'),
              const VSpace(),
              const VSpace(),
              const VSpace(),
              const VSpace(),
              ElevatedButton(
                onPressed: () =>
                    ref.read(authRepositoryProvider).secondaryAuthLogIn(),
                child: const Text('Unlock'),
              ),
              TextButton(
                onPressed: () => ref.read(authRepositoryProvider).logout(),
                child: const Text('Log out'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SecondaryAuth extends ConsumerStatefulWidget {
  final Widget child;

  const SecondaryAuth({super.key, required this.child});

  @override
  ConsumerState<SecondaryAuth> createState() => _SecondaryAuthState();
}

class _SecondaryAuthState extends ConsumerState<SecondaryAuth>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      ref.read(authRepositoryProvider).clearSecondaryAuth();
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasEverSecondaryAuthed = ref.watch(
        authRepositoryProvider.select((value) => value.hasEverSecondaryAuthed));
    final needsSecondaryAuth = ref.watch(
        authRepositoryProvider.select((value) => value.needsSecondaryAuth));

    return Modal(
      visible: hasEverSecondaryAuthed && needsSecondaryAuth,
      modal: const SecondaryAuthScreen(),
      child: widget.child,
    );
  }
}
