import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'spot.freezed.dart';

@freezed
abstract class Spot with _$Spot {
  const Spot._();

  const factory Spot({
    required String id,
    required String sessionId,
    required String userId,
    required GeoPoint location,
    required String photoUrl,
    required String description,
    required DateTime createdAt,
  }) = _Spot;

  factory Spot.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Spot(
      id: doc.id,
      sessionId: data['sessionId'] as String,
      userId: data['userId'] as String,
      location: data['location'] as GeoPoint,
      photoUrl: data['photoUrl'] as String,
      description: data['description'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'sessionId': sessionId,
        'userId': userId,
        'location': location,
        'photoUrl': photoUrl,
        'description': description,
        'createdAt': Timestamp.fromDate(createdAt),
      };
}
