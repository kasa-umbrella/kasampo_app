import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../../core/constants/app_config.dart';

import '../../../core/services/location_service.dart';
import '../../../core/services/walk_foreground_service.dart';
import '../../../core/utils/app_logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/models/spot.dart';
import 'walk_providers.dart';

part 'walk_session_notifier.freezed.dart';
part 'walk_session_notifier.g.dart';

@freezed
abstract class WalkSessionState with _$WalkSessionState {
  const factory WalkSessionState({
    String? sessionId,
    DateTime? startedAt,
    @Default([]) List<GeoPoint> routePoints,
    @Default(0.0) double distanceMeters,
    @Default(false) bool isActive,
    @Default(false) bool isPaused,
    @Default(0) int pausedDurationSeconds,
    String? error,
  }) = _WalkSessionState;
}

@Riverpod(keepAlive: true)
class WalkSessionNotifier extends _$WalkSessionNotifier {
  final List<GeoPoint> _buffer = [];
  DateTime? _pausedAt;
  ProviderSubscription<AsyncValue<Position>>? _positionSubscription;
  Future<void> _pendingUpdate = Future.value();

  @override
  WalkSessionState build() {
    return const WalkSessionState();
  }

  Future<bool> start() async {
    state = state.copyWith(error: null);
    final locationService = ref.read(locationServiceProvider);
    final result = await locationService.requestPermission();
    if (!ref.mounted) return false;

    if (result == LocationPermissionResult.serviceDisabled) {
      state = const WalkSessionState(error: AppConfig.locationServiceDisabledError);
      return false;
    }
    if (result != LocationPermissionResult.granted) return false;

    if (Platform.isIOS && !await locationService.hasAlwaysPermission()) {
      if (!ref.mounted) return false;
      state = const WalkSessionState(error: AppConfig.backgroundPermissionError);
      return false;
    }

    final initialPosition = await locationService.getCurrentPosition();
    if (!ref.mounted || initialPosition == null) return false;

    final uid = ref.read(currentUidProvider);
    if (uid == null) return false;

    final now = DateTime.now();
    final initialPoint = GeoPoint(initialPosition.latitude, initialPosition.longitude);
    final repo = ref.read(walkSessionRepositoryProvider);
    final sessionId = await repo.create(uid, now);
    await repo.appendRoutePoints(sessionId, [initialPoint]);

    if (!ref.mounted) return false;

    await WalkForegroundService.start();

    if (!ref.mounted) return false;

    state = WalkSessionState(
      sessionId: sessionId,
      startedAt: now,
      isActive: true,
      routePoints: [initialPoint],
    );

    _positionSubscription = ref.listen(currentPositionProvider, (_, next) {
      next.whenData((pos) {
        _pendingUpdate = _pendingUpdate
            .then((_) => _onPositionUpdate(pos))
            .catchError((e) => appLogger.w('[WalkSession] position update error: $e'));
      });
    });

    return true;
  }

  Future<void> pause() async {
    if (!state.isActive || state.isPaused) return;
    final sessionId = state.sessionId;
    if (sessionId != null && _buffer.isNotEmpty) {
      final toSend = List<GeoPoint>.from(_buffer);
      _buffer.clear();
      try {
        await ref.read(walkSessionRepositoryProvider).appendRoutePoints(sessionId, toSend);
      } catch (e) {
        appLogger.w('[WalkSession] appendRoutePoints pause flush failed: $e');
      }
    }
    _pausedAt = DateTime.now();
    if (!ref.mounted) return;
    state = state.copyWith(isPaused: true);
  }

  void resume() {
    if (!state.isPaused) return;
    final paused = _pausedAt;
    _pausedAt = null;
    final added = paused != null ? DateTime.now().difference(paused).inSeconds : 0;
    state = state.copyWith(
      isPaused: false,
      pausedDurationSeconds: state.pausedDurationSeconds + added,
    );
  }

  Future<void> _onPositionUpdate(Position pos) async {
    if (!ref.mounted || !state.isActive || state.isPaused) return;
    final sessionId = state.sessionId;
    if (sessionId == null) return;

    if (!pos.latitude.isFinite || !pos.longitude.isFinite) {
      appLogger.w('[WalkSession] 無効なGPS座標を受信、セッションを中断: lat=${pos.latitude}, lng=${pos.longitude}');
      _positionSubscription?.close();
      _positionSubscription = null;
      state = const WalkSessionState();
      return;
    }

    if (pos.accuracy > AppConfig.maxGpsAccuracyMeters) {
      appLogger.d('[WalkSession] GPS精度不足でスキップ: accuracy=${pos.accuracy.toStringAsFixed(1)}m');
      return;
    }

    final newPoint = GeoPoint(pos.latitude, pos.longitude);
    _buffer.add(newPoint);
    if (_buffer.length >= AppConfig.routePointBufferSize) {
      final toSend = List<GeoPoint>.from(_buffer);
      _buffer.clear();
      try {
        await ref.read(walkSessionRepositoryProvider).appendRoutePoints(sessionId, toSend);
      } catch (e) {
        appLogger.w('[WalkSession] appendRoutePoints failed: $e');
      }
    }

    if (!ref.mounted) return;

    double added = 0;
    if (state.routePoints.isNotEmpty) {
      final d = ref
          .read(locationServiceProvider)
          .calcDistance(state.routePoints.last, newPoint);
      if (d.isFinite) added = d;
    }

    state = state.copyWith(
      routePoints: [...state.routePoints, newPoint],
      distanceMeters: state.distanceMeters + added,
    );

    if (kDebugMode) {
      WalkForegroundService.updateLocation(pos.latitude, pos.longitude, pos.accuracy)
          .ignore();
    }
  }

  Future<void> addSpot({
    required File photo,
    required String description,
  }) async {
    final sessionId = state.sessionId;
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (sessionId == null || uid == null || state.routePoints.isEmpty) return;

    final location = state.routePoints.last;
    final ext = photo.path.contains('.') ? photo.path.split('.').last.toLowerCase() : 'jpg';
    final path = 'spot_photos/$uid/${DateTime.now().millisecondsSinceEpoch}.$ext';
    final photoUrl =
        await ref.read(storageServiceProvider).uploadPhoto(photo, path);

    if (!ref.mounted) return;

    final spot = Spot(
      id: '',
      sessionId: sessionId,
      userId: uid,
      location: location,
      photoUrl: photoUrl,
      description: description,
      createdAt: DateTime.now(),
    );

    await ref.read(spotRepositoryProvider).create(spot);
  }

  Future<void> deleteSpot(Spot spot) async {
    await ref.read(storageServiceProvider).deletePhoto(spot.photoUrl);
    await ref.read(spotRepositoryProvider).delete(spot.id);
  }

  Future<void> finish() async {
    final sessionId = state.sessionId;
    final startedAt = state.startedAt;
    if (sessionId == null || startedAt == null) return;

    _positionSubscription?.close();
    _positionSubscription = null;
    await _pendingUpdate;
    _pendingUpdate = Future.value();

    if (_buffer.isNotEmpty) {
      final toSend = List<GeoPoint>.from(_buffer);
      try {
        await ref.read(walkSessionRepositoryProvider).appendRoutePoints(sessionId, toSend);
        _buffer.clear();
      } catch (e) {
        appLogger.w('[WalkSession] appendRoutePoints flush failed: $e');
      }
    }

    final now = DateTime.now();
    await ref.read(walkSessionRepositoryProvider).finish(
          sessionId,
          endedAt: now,
          distanceMeters: state.distanceMeters.isFinite ? state.distanceMeters : 0.0,
          durationSeconds: now.difference(startedAt).inSeconds - state.pausedDurationSeconds,
        );

    await WalkForegroundService.stop();

    if (!ref.mounted) return;
    state = const WalkSessionState();
  }
}
