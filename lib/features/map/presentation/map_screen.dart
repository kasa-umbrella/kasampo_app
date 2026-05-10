import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/snack_bar_helper.dart';
import '../../../core/widgets/map/app_tile_layer.dart';
import 'package:geolocator/geolocator.dart';
import '../../../core/providers/app_lifecycle_provider.dart';
import '../../../core/services/location_service.dart';
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

    ref.listen<GeoPoint?>(
      walkSessionProvider.select(
        (s) => s.routePoints.isEmpty ? null : s.routePoints.last,
      ),
      (_, point) {
        if (point != null) _moveToPoint(point);
      },
    );

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

    final routePoints = ref.watch(
      walkSessionProvider.select((s) => s.routePoints),
    );
    final Position? currentPosition = shouldTrackLocation
        ? ref.watch(currentPositionProvider).asData?.value
        : null;

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: const LatLng(35.6762, 139.6503),
        initialZoom: 14,
        onMapReady: _moveToCurrentLocation,
      ),
      children: [
        const AppTileLayer(),
        CircleLayer(
          circles: routePoints
              .map(
                (p) => CircleMarker(
                  point: LatLng(p.latitude, p.longitude),
                  radius: 6,
                  color: AppColors.primary,
                ),
              )
              .toList(),
        ),
        if (currentPosition != null)
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(
                  currentPosition.latitude,
                  currentPosition.longitude,
                ),
                child: Transform.rotate(
                  angle: currentPosition.heading * math.pi / 180,
                  child: const Icon(
                    Icons.navigation,
                    color: AppColors.locationBlue,
                    size: 36,
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
