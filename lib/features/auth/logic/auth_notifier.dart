import 'package:appwrite/models.dart' as models;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:instagram_appwrite/features/auth/data/services/auth_service.dart';

part 'auth_notifier.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  Future<models.User?> build() async {
    return await ref.read(authServiceProvider).getCurrentUser();
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(authServiceProvider).login(email: email, password: password);
      return await ref.read(authServiceProvider).getCurrentUser();
    });
  }

  Future<void> register(String email, String password, String name) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(authServiceProvider).register(email: email, password: password, name: name);
      // Automatically login after successful registration
      await ref.read(authServiceProvider).login(email: email, password: password);
      return await ref.read(authServiceProvider).getCurrentUser();
    });
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(authServiceProvider).logout();
      return null;
    });
  }
}
