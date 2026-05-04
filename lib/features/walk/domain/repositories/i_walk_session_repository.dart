import 'package:cloud_firestore/cloud_firestore.dart';

abstract class IWalkSessionRepository {
  Future<String> create(String userId, DateTime startedAt);
  Future<void> appendRoutePoints(String sessionId, List<GeoPoint> points);
  Future<void> finish(
    String sessionId, {
    required DateTime endedAt,
    required double distanceMeters,
    required int durationSeconds,
  });
}
