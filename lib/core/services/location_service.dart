import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import '../utils/app_logger.dart';

enum LocationPermissionResult { granted, serviceDisabled, permissionDenied }

class LocationService {
  static const _distanceFilter = 5;

  Stream<Position>? _positionStream;

  Future<LocationPermissionResult> requestPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return LocationPermissionResult.serviceDisabled;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      return LocationPermissionResult.granted;
    }
    return LocationPermissionResult.permissionDenied;
  }

  Future<bool> hasAlwaysPermission() async {
    return (await Geolocator.checkPermission()) == LocationPermission.always;
  }

  Future<Position?> getCurrentPosition() async {
    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      ).timeout(const Duration(seconds: 10));
      appLogger.d(
        '[Location] getCurrentPosition: '
        'lat=${pos.latitude}, lng=${pos.longitude}, '
        'accuracy=${pos.accuracy.toStringAsFixed(1)}m',
      );
      return pos;
    } catch (_) {
      return null;
    }
  }

  Stream<Position> watchPosition() {
    final locationSettings = Platform.isIOS
        ? AppleSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: _distanceFilter,
            activityType: ActivityType.fitness,
            pauseLocationUpdatesAutomatically: false,
            allowBackgroundLocationUpdates: true,
            showBackgroundLocationIndicator: true,
          )
        : AndroidSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: _distanceFilter,
          );
    _positionStream = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).map((pos) {
      appLogger.d(
        '[Location] watchPosition: '
        'lat=${pos.latitude}, lng=${pos.longitude}, '
        'accuracy=${pos.accuracy.toStringAsFixed(1)}m, '
        'speed=${pos.speed.toStringAsFixed(1)}m/s',
      );
      return pos;
    });
    return _positionStream!;
  }

  double calcDistance(GeoPoint from, GeoPoint to) {
    return Geolocator.distanceBetween(
      from.latitude,
      from.longitude,
      to.latitude,
      to.longitude,
    );
  }
}
