import 'package:bebe/src/data/auth/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider =
    ChangeNotifierProvider((ref) => AuthRepository());
