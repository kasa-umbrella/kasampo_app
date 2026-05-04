import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/models/user_auth_state.dart';
import '../data/auth_repository.dart';
import '../data/user_repository.dart';

part 'auth_providers.g.dart';

@riverpod
Stream<User?> authState(Ref ref) =>
    ref.watch(authRepositoryProvider).authStateChanges();

// Firebase Auth の状態変化に連動して Firestore のユーザー存在を確認するストリーム
@riverpod
Stream<UserAuthState> userAuthState(Ref ref) async* {
  yield const UserAuthLoading();

  final authStream = ref.watch(authRepositoryProvider).authStateChanges();

  // 起動時のセッション復元か、明示的なサインイン操作後かを区別するフラグ
  var isFirstEmit = true;

  await for (final firebaseUser in authStream) {
    if (firebaseUser == null) {
      isFirstEmit = false;
      yield const UserAuthUnauthenticated();
      continue;
    }

    // コンソール削除・無効化されたトークンをサーバーサイドで検証
    try {
      await firebaseUser.reload();
    } on FirebaseAuthException {
      isFirstEmit = false;
      await ref.read(authRepositoryProvider).signOut();
      continue;
    }

    final appUser =
        await ref.read(userRepositoryProvider).fetchUser(firebaseUser.uid);

    if (appUser != null) {
      isFirstEmit = false;
      yield UserAuthRegistered(appUser);
    } else if (isFirstEmit) {
      isFirstEmit = false;
      await ref.read(authRepositoryProvider).signOut();
    } else {
      isFirstEmit = false;
      yield UserAuthUnregistered(firebaseUser);
    }
  }
}

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

@riverpod
class RegisterController extends _$RegisterController {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<void> register({
    required String uid,
    required String displayName,
    String avatarUrl = '',
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(userRepositoryProvider).createUser(
            uid: uid,
            displayName: displayName,
            avatarUrl: avatarUrl,
          ),
    );
    if (state is AsyncData) {
      ref.invalidate(userAuthStateProvider);
    }
  }
}
