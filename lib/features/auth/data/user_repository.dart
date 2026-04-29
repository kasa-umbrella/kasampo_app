import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/models/app_user.dart';

part 'user_repository.g.dart';

@riverpod
UserRepository userRepository(UserRepositoryRef ref) => UserRepository();

class UserRepository {
  final _db = FirebaseFirestore.instance;

  Future<AppUser?> fetchUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return AppUser.fromFirestore(doc);
  }

  Future<void> createUser({
    required String uid,
    required String displayName,
    String avatarUrl = '',
  }) async {
    await _db.collection('users').doc(uid).set({
      'displayName': displayName,
      'avatarUrl': avatarUrl,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
