import 'package:flutter_map_heatmap/flutter_map_heatmap.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../walk/providers/walk_providers.dart';
import '../data/repositories/firestore_heatmap_repository.dart';

part 'heatmap_providers.g.dart';

@riverpod
FirestoreHeatmapRepository heatmapRepository(Ref ref) =>
    FirestoreHeatmapRepository();

@riverpod
Future<List<WeightedLatLng>> heatmapPoints(Ref ref) async {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return [];
  final points =
      await ref.read(heatmapRepositoryProvider).fetchSampledRoutePoints(uid);
  return points.map((p) => WeightedLatLng(p, 1.0)).toList();
}
