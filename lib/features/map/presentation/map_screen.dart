import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/widgets/map/app_tile_layer.dart';
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
    final granted = await locationService.requestPermission();
    if (!granted) return;

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
    ref.listen<GeoPoint?>(
      walkSessionProvider.select(
        (s) => s.routePoints.isEmpty ? null : s.routePoints.last,
      ),
      (_, point) {
        if (point != null) _moveToPoint(point);
      },
    );

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: const LatLng(35.6762, 139.6503),
        initialZoom: 14,
        onMapReady: _moveToCurrentLocation,
      ),
      children: [
        const AppTileLayer(),
      ],
    );
  }
}
