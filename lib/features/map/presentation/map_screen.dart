import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_heatmap/flutter_map_heatmap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_config.dart';
import '../../../core/providers/app_lifecycle_provider.dart';
import '../../../core/services/location_service.dart';
import '../../../core/utils/snack_bar_helper.dart';
import '../../../core/widgets/map/app_tile_layer.dart';
import '../../heatmap/providers/heatmap_providers.dart';
import '../../walk/providers/walk_providers.dart';
import '../../walk/providers/walk_session_notifier.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final _mapController = MapController();

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _moveToCurrentLocation() async {
    final locationService = ref.read(locationServiceProvider);
    final result = await locationService.requestPermission();
    if (result != LocationPermissionResult.granted) return;

    final position = await locationService.getCurrentPosition();
    if (position == null || !mounted) return;

    _mapController.move(
      LatLng(position.latitude, position.longitude),
      _mapController.camera.zoom,
    );
  }

  void _moveToPoint(GeoPoint point) {
    _mapController.move(
      LatLng(point.latitude, point.longitude),
      _mapController.camera.zoom,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSessionActive = ref.watch(walkSessionProvider.select((s) => s.isActive));
    final lifecycle = ref.watch(appLifecycleProvider);
    final shouldTrackLocation = isSessionActive || lifecycle != AppLifecycleState.paused;

    // セッション中は最新ルートポイントへマップを追従（rebuild は起こさない）
    ref.listen<GeoPoint?>(
      walkSessionProvider.select(
        (s) => s.routeSegments.isEmpty ? null : s.routeSegments.last.last,
      ),
      (_, point) {
        if (point != null) _moveToPoint(point);
      },
    );

    // 位置取得エラーのスナックバー通知（rebuild は起こさない）
    if (shouldTrackLocation) {
      ref.listen(currentPositionProvider, (prev, next) {
        final pos = next.asData?.value;
        final isInvalid =
            next.hasError ||
            (pos != null && (!pos.latitude.isFinite || !pos.longitude.isFinite));
        final prevPos = prev?.asData?.value;
        final wasInvalid =
            (prev?.hasError ?? false) ||
            (prevPos != null &&
                (!prevPos.latitude.isFinite || !prevPos.longitude.isFinite));
        if (isInvalid && !wasInvalid && context.mounted) {
          showSnackBar(context, '現在地を取得できませんでした');
        }
      });
    }

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: const LatLng(35.6762, 139.6503),
        initialZoom: AppConfig.initialMapZoom,
        onMapReady: _moveToCurrentLocation,
      ),
      children: [
        const AppTileLayer(),
        const _HeatmapLayer(),
        const _RoutePointsLayer(),
        const _SpotMarkerLayer(),
        _CurrentPositionLayer(shouldTrackLocation: shouldTrackLocation),
      ],
    );
  }
}

// GPS更新のたびにこの widget だけが rebuild される
class _CurrentPositionLayer extends ConsumerWidget {
  const _CurrentPositionLayer({required this.shouldTrackLocation});

  final bool shouldTrackLocation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!shouldTrackLocation) return const MarkerLayer(markers: []);

    final position = ref.watch(currentPositionProvider).asData?.value;
    if (position == null) return const MarkerLayer(markers: []);

    return MarkerLayer(
      markers: [
        Marker(
          point: LatLng(position.latitude, position.longitude),
          child: Transform.rotate(
            angle: position.heading * math.pi / 180,
            child: const Icon(
              Icons.navigation,
              color: AppColors.locationBlue,
              size: 36,
            ),
          ),
        ),
      ],
    );
  }
}

// ルートポイント追加時にこの widget だけが rebuild される
class _RoutePointsLayer extends ConsumerWidget {
  const _RoutePointsLayer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routeSegments = ref.watch(
      walkSessionProvider.select((s) => s.routeSegments),
    );
    return CircleLayer(
      circles: routeSegments
          .expand((seg) => seg)
          .map(
            (p) => CircleMarker(
              point: LatLng(p.latitude, p.longitude),
              radius: 6,
              color: AppColors.primary,
            ),
          )
          .toList(),
    );
  }
}

// ヒートマップデータ更新時にこの widget だけが rebuild される
class _HeatmapLayer extends ConsumerWidget {
  const _HeatmapLayer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSessionActive = ref.watch(walkSessionProvider.select((s) => s.isActive));
    if (isSessionActive) return const SizedBox.shrink();

    final points = ref.watch(heatmapPointsProvider).asData?.value ?? [];
    if (points.isEmpty) return const SizedBox.shrink();

    try {
      return HeatMapLayer(
        heatMapDataSource: InMemoryHeatMapDataSource(data: points),
        heatMapOptions: HeatMapOptions(
          gradient: HeatMapOptions.defaultGradient,
          minOpacity: 0.3,
        ),
      );
    } catch (_) {
      return const SizedBox.shrink();
    }
  }
}

class _SpotMarkerLayer extends ConsumerWidget {
  const _SpotMarkerLayer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spots = ref.watch(userSpotsProvider).value ?? const [];
    return MarkerLayer(
      markers: spots
          .map(
            (spot) => Marker(
              key: ValueKey(spot.id),
              point: LatLng(
                spot.location.latitude,
                spot.location.longitude,
              ),
              child: const Icon(
                Icons.photo_camera,
                color: AppColors.primary,
                size: 28,
              ),
            ),
          )
          .toList(),
    );
  }
}