import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/auth_repository.dart';

part 'auth_providers.g.dart';

@riverpod
Stream<User?> authState(AuthStateRef ref) =>
    ref.watch(authRepositoryProvider).authStateChanges();

@riverpod
class SignInController extends _$SignInController {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).signInWithGoogle(),
    );
  }
}
