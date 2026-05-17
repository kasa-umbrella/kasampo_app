import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_config.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/map/app_tile_layer.dart';

class WalkResultData {
  const WalkResultData({
    required this.routePoints,
    required this.distanceMeters,
    required this.durationSeconds,
  });

  final List<GeoPoint> routePoints;
  final double distanceMeters;
  final int durationSeconds;
}

class WalkResultScreen extends StatefulWidget {
  const WalkResultScreen({super.key, required this.data});

  final WalkResultData data;

  @override
  State<WalkResultScreen> createState() => _WalkResultScreenState();
}

class _WalkResultScreenState extends State<WalkResultScreen> {
  final _mapController = MapController();

  late final List<LatLng> _latLngs = widget.data.routePoints
      .map((p) => LatLng(p.latitude, p.longitude))
      .toList();

  late final LatLngBounds? _bounds =
      _latLngs.isNotEmpty ? LatLngBounds.fromPoints(_latLngs) : null;

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  String _formatDistance(double meters) {
    if (meters >= 1000) return '${(meters / 1000).toStringAsFixed(2)}km';
    return '${meters.toStringAsFixed(0)}m';
  }

  String _formatDuration(int seconds) {
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    final s = seconds % 60;
    if (h > 0) return '$h時間$m分';
    if (m > 0) return '$m分$s秒';
    return '$s秒';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _latLngs.isNotEmpty
                  ? _latLngs.first
                  : const LatLng(35.6762, 139.6503),
              initialZoom: AppConfig.initialMapZoom,
              onMapReady: () {
                final b = _bounds;
                if (b != null &&
                    (b.north != b.south || b.east != b.west)) {
                  _mapController.fitCamera(
                    CameraFit.bounds(
                      bounds: b,
                      padding: const EdgeInsets.fromLTRB(40, 120, 40, 240),
                      maxZoom: 17,
                    ),
                  );
                }
              },
            ),
            children: [
              const AppTileLayer(),
              if (_latLngs.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _latLngs,
                      color: AppColors.primary,
                      strokeWidth: 4,
                    ),
                  ],
                ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _StatItem(
                            label: '距離',
                            value: _formatDistance(widget.data.distanceMeters),
                          ),
                          _StatItem(
                            label: '時間',
                            value: _formatDuration(widget.data.durationSeconds),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      AppButton(
                        label: '完了',
                        onPressed: () => context.go('/home'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: IconButton(
                onPressed: () => context.go('/home'),
                icon: const Icon(Icons.close),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.surface,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
