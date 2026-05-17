import 'package:flutter_map_heatmap/flutter_map_heatmap.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/utils/app_logger.dart';
import '../../walk/providers/walk_providers.dart';
import '../data/repositories/firestore_heatmap_repository.dart';

part 'heatmap_providers.g.dart';

@riverpod
FirestoreHeatmapRepository heatmapRepository(Ref ref) =>
    FirestoreHeatmapRepository();

@riverpod
Future<List<WeightedLatLng>> heatmapPoints(Ref ref) async {
  final uid = ref.watch(currentUidProvider);
  appLogger.d('[Heatmap] uid=$uid');
  if (uid == null) return [];

  final points =
      await ref.read(heatmapRepositoryProvider).fetchSampledRoutePoints(uid);
  appLogger.d('[Heatmap] sampled points count=${points.length}');
  for (final p in points) {
    appLogger.d('[Heatmap]   lat=${p.latitude}, lng=${p.longitude}');
  }

  return points.map((p) => WeightedLatLng(p, 1.0)).toList();
}
