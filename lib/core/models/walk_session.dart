import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'walk_session.freezed.dart';

@freezed
abstract class WalkSession with _$WalkSession {
  const WalkSession._();

  const factory WalkSession({
    required String id,
    required String userId,
    required DateTime startedAt,
    DateTime? endedAt,
    required List<GeoPoint> routePoints,
    required double distanceMeters,
    required int durationSeconds,
    required bool isPublic,
  }) = _WalkSession;

  factory WalkSession.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return WalkSession(
      id: doc.id,
      userId: data['userId'] as String,
      startedAt: (data['startedAt'] as Timestamp).toDate(),
      endedAt: data['endedAt'] != null
          ? (data['endedAt'] as Timestamp).toDate()
          : null,
      routePoints: (data['routePoints'] as List<dynamic>).cast<GeoPoint>(),
      distanceMeters: (data['distance'] as num).toDouble(),
      durationSeconds: data['duration'] as int,
      isPublic: data['isPublic'] as bool,
    );
  }

  Map<String, dynamic> toFirestore() => {
        'userId': userId,
        'startedAt': Timestamp.fromDate(startedAt),
        'endedAt': endedAt != null ? Timestamp.fromDate(endedAt!) : null,
        'routePoints': routePoints,
        'distance': distanceMeters,
        'duration': durationSeconds,
        'isPublic': isPublic,
      };
}
