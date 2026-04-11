import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:instagram_appwrite/core/config/appwrite_config.dart';

part 'auth_service.g.dart';

class AuthService {
  final Account _account;

  AuthService(this._account);

  Future<models.User> register({
    required String email,
    required String password,
    required String name,
  }) async {
    return await _account.create(
      userId: ID.unique(),
      email: email,
      password: password,
      name: name,
    );
  }

  Future<models.Session> login({
    required String email,
    required String password,
  }) async {
    return await _account.createEmailPasswordSession(
      email: email,
      password: password,
    );
  }

  Future<models.User?> getCurrentUser() async {
    try {
      return await _account.get();
    } on AppwriteException {
      return null;
    }
  }

  Future<void> logout() async {
    await _account.deleteSession(sessionId: 'current');
  }
}

@riverpod
AuthService authService(Ref ref) {
  final account = ref.watch(appwriteAccountProvider);
  return AuthService(account);
}
