import 'package:firebase_auth/firebase_auth.dart';
import 'app_user.dart';

sealed class UserAuthState {
  const UserAuthState();
}

// Firebase Auth・Firestore どちらの確認もまだ終わっていない
class UserAuthLoading extends UserAuthState {
  const UserAuthLoading();
}

// 未ログイン
class UserAuthUnauthenticated extends UserAuthState {
  const UserAuthUnauthenticated();
}

// ログイン済み・Firestore にユーザードキュメントあり
class UserAuthRegistered extends UserAuthState {
  const UserAuthRegistered(this.user);
  final AppUser user;
}

// ログイン済み・Firestore にユーザードキュメントなし（初回登録が必要）
class UserAuthUnregistered extends UserAuthState {
  const UserAuthUnregistered(this.firebaseUser);
  final User firebaseUser;
}
