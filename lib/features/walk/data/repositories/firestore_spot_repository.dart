import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/models/spot.dart';
import '../../domain/repositories/i_spot_repository.dart';

class FirestoreSpotRepository implements ISpotRepository {
  final _collection = FirebaseFirestore.instance.collection('spots');

  @override
  Future<String> create(Spot spot) async {
    final doc = await _collection.add(spot.toFirestore());
    return doc.id;
  }

  @override
  Future<void> delete(String spotId) => _collection.doc(spotId).delete();

  @override
  Stream<List<Spot>> watchBySession(String sessionId) {
    return _collection
        .where('sessionId', isEqualTo: sessionId)
        .orderBy('createdAt')
        .snapshots()
        .map((snap) => snap.docs.map(Spot.fromFirestore).toList());
  }
}
