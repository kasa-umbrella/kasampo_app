import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/constants/app_config.dart';

class FirestoreHeatmapRepository {
  final _collection = FirebaseFirestore.instance.collection('walkSessions');

  Future<List<LatLng>> fetchSampledRoutePoints(String userId) async {
    final snapshot = await _collection
        .where('userId', isEqualTo: userId)
        .where('endedAt', isNull: false)
        .get();

    final allPoints = snapshot.docs
        .expand((doc) => (doc.data()['routePoints'] as List).cast<GeoPoint>())
        .toList();

    return allPoints
        .asMap()
        .entries
        .where((e) => e.key % AppConfig.heatmapSampleRate == 0)
        .map((e) => LatLng(e.value.latitude, e.value.longitude))
        .toList();
  }
}
