import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepository with ChangeNotifier {
  static const _authHeaderStorageKey = 'auth_header';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  Future<void> initialize() async {
    final authHeader = await _storage.read(key: _authHeaderStorageKey);
    if (authHeader != null) {
      _isLoggedIn = true;
      notifyListeners();
    }
  }

  Future<String?> getAuthHeader() async {
    final header = await _storage.read(key: _authHeaderStorageKey);
    return header;
  }

  Future<void> storeAuthHeader(String? authHeader) async {
    await _storage.write(key: _authHeaderStorageKey, value: authHeader);
    _isLoggedIn = true;
    notifyListeners();
  }

  Future<void> clearAuthHeader() async {
    await _storage.delete(key: _authHeaderStorageKey);
    _isLoggedIn = false;
    notifyListeners();
  }
}
