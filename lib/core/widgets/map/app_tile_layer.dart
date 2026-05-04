import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class AppTileLayer extends StatelessWidget {
  const AppTileLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return TileLayer(
      urlTemplate:
          'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
      subdomains: const ['a', 'b', 'c', 'd'],
      userAgentPackageName: 'com.example.kasampoApp',
      retinaMode: RetinaMode.isHighDensity(context),
    );
  }
}
