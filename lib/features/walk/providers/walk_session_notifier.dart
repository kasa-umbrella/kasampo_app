import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/constants/app_config.dart';
import '../../../core/services/walk_foreground_service.dart';
import '../../../core/utils/app_logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';
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
    String? error,
  }) = _WalkSessionState;
}

@Riverpod(keepAlive: true)
class WalkSessionNotifier extends _$WalkSessionNotifier {
  final List<GeoPoint> _buffer = [];

  @override
  WalkSessionState build() {
    ref.listen(currentPositionProvider, (_, next) {
      next.whenData(_onPositionUpdate);
    });
    return const WalkSessionState();
  }

  Future<bool> start() async {
    final locationService = ref.read(locationServiceProvider);
    final granted = await locationService.requestPermission();
    if (!ref.mounted || !granted) return false;

    final initialPosition = await locationService.getCurrentPosition();
    if (!ref.mounted || initialPosition == null) return false;

    final uid = FirebaseAuth.instance.currentUser?.uid;
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

    return true;
  }

  Future<void> _onPositionUpdate(Position pos) async {
    if (!ref.mounted || !state.isActive) return;
    final sessionId = state.sessionId;
    if (sessionId == null) return;

    if (!pos.latitude.isFinite || !pos.longitude.isFinite) {
      appLogger.w('[WalkSession] 無効なGPS座標を受信、セッションを中断: lat=${pos.latitude}, lng=${pos.longitude}');
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
  }

  Future<void> addSpot({
    required File photo,
    required String description,
  }) async {
    final sessionId = state.sessionId;
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (sessionId == null || uid == null || state.routePoints.isEmpty) return;

    final location = state.routePoints.last;
    final path = 'spots/$uid/${DateTime.now().millisecondsSinceEpoch}.jpg';
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

  Future<void> finish() async {
    final sessionId = state.sessionId;
    final startedAt = state.startedAt;
    if (sessionId == null || startedAt == null) return;

    if (_buffer.isNotEmpty) {
      final toSend = List<GeoPoint>.from(_buffer);
      _buffer.clear();
      try {
        await ref.read(walkSessionRepositoryProvider).appendRoutePoints(sessionId, toSend);
      } catch (e) {
        appLogger.w('[WalkSession] appendRoutePoints flush failed: $e');
      }
    }

    final now = DateTime.now();
    await ref.read(walkSessionRepositoryProvider).finish(
          sessionId,
          endedAt: now,
          distanceMeters: state.distanceMeters.isFinite ? state.distanceMeters : 0.0,
          durationSeconds: now.difference(startedAt).inSeconds,
        );

    await WalkForegroundService.stop();

    if (!ref.mounted) return;
    state = const WalkSessionState();
  }
}
