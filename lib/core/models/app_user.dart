import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  const AppUser({
    required this.uid,
    required this.displayName,
    required this.avatarUrl,
    required this.createdAt,
  });

  final String uid;
  final String displayName;
  final String avatarUrl;
  final DateTime createdAt;

  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppUser(
      uid: doc.id,
      displayName: data['displayName'] as String,
      avatarUrl: data['avatarUrl'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'displayName': displayName,
        'avatarUrl': avatarUrl,
        'createdAt': Timestamp.fromDate(createdAt),
      };

  static Map<String, dynamic> toNewUserMap({
    required String displayName,
    String avatarUrl = '',
  }) =>
      {
        'displayName': displayName,
        'avatarUrl': avatarUrl,
        'createdAt': FieldValue.serverTimestamp(),
      };
}