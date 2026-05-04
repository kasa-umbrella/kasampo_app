import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import '../../../core/widgets/map/app_tile_layer.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: const MapOptions(
        initialCenter: LatLng(35.6762, 139.6503),
        initialZoom: 14,
      ),
      children: [
        const AppTileLayer(),
      ],
    );
  }
}