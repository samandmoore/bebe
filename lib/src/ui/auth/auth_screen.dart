import 'dart:math';

import 'package:bebe/src/data/auth/auth_repository.dart';
import 'package:bebe/src/data/auth/providers.dart';
import 'package:bebe/src/data/auth/user.dart';
import 'package:bebe/src/ui/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthScreen extends ConsumerStatefulWidget {
  static const route = '/auth';

  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  AuthRepository get authRepository => ref.read(authRepositoryProvider);

  AsyncValue<User> currentUser = const AsyncValue.loading();

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    setState(() {
      currentUser = const AsyncValue.loading();
    });
    final user = await AsyncValue.guard(() => authRepository.getUser());
    setState(() {
      currentUser = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auth'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('isLoggedIn'),
            subtitle: Text(authRepository.isLoggedIn.toString()),
          ),
          currentUser.when(
            data: (user) => ListTile(
              title: Text(user.name),
              subtitle: Text(user.email),
            ),
            error: (e, s) => Text('$e$s'),
            loading: () => const LoadingIndicator(),
          ),
          ElevatedButton(
            onPressed: () async {
              await authRepository.createUser(
                UserInput(
                  name: 'Sam',
                  email: '${Random().nextInt(10000)}@example.org',
                  password: 'asdfasdf',
                ),
              );
              await _loadCurrentUser();
            },
            child: const Text('Create user'),
          ),
        ],
      ),
    );
  }
}
