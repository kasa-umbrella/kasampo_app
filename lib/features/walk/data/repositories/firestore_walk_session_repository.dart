import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/i_walk_session_repository.dart';

class FirestoreWalkSessionRepository implements IWalkSessionRepository {
  final _collection = FirebaseFirestore.instance.collection('walkSessions');

  @override
  Future<String> create(String userId, DateTime startedAt) async {
    final doc = await _collection.add({
      'userId': userId,
      'startedAt': Timestamp.fromDate(startedAt),
      'endedAt': null,
      'routePoints': [],
      'distance': 0.0,
      'duration': 0,
      'isPublic': true,
    });
    return doc.id;
  }

  @override
  Future<void> appendRoutePoint(String sessionId, GeoPoint point) async {
    await _collection.doc(sessionId).update({
      'routePoints': FieldValue.arrayUnion([point]),
    });
  }

  @override
  Future<void> finish(
    String sessionId, {
    required DateTime endedAt,
    required double distanceMeters,
    required int durationSeconds,
  }) async {
    await _collection.doc(sessionId).update({
      'endedAt': Timestamp.fromDate(endedAt),
      'distance': distanceMeters,
      'duration': durationSeconds,
    });
  }
}
