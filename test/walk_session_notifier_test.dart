import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kasampo_app/core/constants/app_config.dart';
import 'package:kasampo_app/core/services/location_service.dart';
import 'package:kasampo_app/features/walk/domain/repositories/i_walk_session_repository.dart';
import 'package:kasampo_app/features/walk/providers/walk_providers.dart';
import 'package:kasampo_app/features/walk/providers/walk_session_notifier.dart';

// --- Fakes ---

class _FakeLocationService extends LocationService {
  final LocationPermissionResult permissionResult;
  final Position? position;
  final Stream<Position> positionStream;

  _FakeLocationService({
    this.permissionResult = LocationPermissionResult.granted,
    this.position,
    Stream<Position>? positionStream,
  }) : positionStream = positionStream ?? const Stream.empty();

  @override
  Future<LocationPermissionResult> requestPermission() async => permissionResult;

  @override
  Future<Position?> getCurrentPosition() async => position;

  @override
  Stream<Position> watchPosition() => positionStream;

  @override
  double calcDistance(GeoPoint from, GeoPoint to) => 0;
}

class _FakeWalkSessionRepository implements IWalkSessionRepository {
  @override
  Future<String> create(String userId, DateTime startedAt) async => 'session-1';

  @override
  Future<void> appendRoutePoints(String sessionId, List<GeoPoint> points) async {}

  @override
  Future<void> finish(
    String sessionId, {
    required DateTime endedAt,
    required double distanceMeters,
    required int durationSeconds,
  }) async {}
}

/// appendRoutePoints に渡されたポイントを全件記録するリポジトリ
class _TrackingWalkSessionRepository implements IWalkSessionRepository {
  final List<GeoPoint> allAppendedPoints = [];

  @override
  Future<String> create(String userId, DateTime startedAt) async => 'session-1';

  @override
  Future<void> appendRoutePoints(String sessionId, List<GeoPoint> points) async {
    allAppendedPoints.addAll(points);
  }

  @override
  Future<void> finish(
    String sessionId, {
    required DateTime endedAt,
    required double distanceMeters,
    required int durationSeconds,
  }) async {}
}

// --- Helpers ---

Position _makePosition(double lat, double lng, {double accuracy = 10.0}) =>
    Position(
      latitude: lat,
      longitude: lng,
      timestamp: DateTime.now(),
      accuracy: accuracy,
      altitude: 0,
      altitudeAccuracy: 0,
      heading: 0,
      headingAccuracy: 0,
      speed: 0,
      speedAccuracy: 0,
    );

ProviderContainer _makeContainer({
  LocationPermissionResult permissionResult = LocationPermissionResult.granted,
  Position? position,
  Stream<Position>? positionStream,
  String? uid,
  IWalkSessionRepository? repo,
}) =>
    ProviderContainer(
      overrides: [
        locationServiceProvider.overrideWith(
          (_) => _FakeLocationService(
            permissionResult: permissionResult,
            position: position,
            positionStream: positionStream,
          ),
        ),
        walkSessionRepositoryProvider.overrideWith(
          (_) => repo ?? _FakeWalkSessionRepository(),
        ),
        if (uid != null) currentUidProvider.overrideWith((_) => uid),
      ],
    );

/// flutter_foreground_task のメソッドチャンネルをモックする。
/// テスト環境ではプラットフォームの実装がないため、最低限の応答を返す。
void _setupForegroundTaskMock() {
  const channel = MethodChannel('flutter_foreground_task/methods');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (call) async {
    return switch (call.method) {
      'isRunningService' => false,
      'checkNotificationPermission' => 0, // NotificationPermission.granted (index 0)
      'requestNotificationPermission' => 0,
      _ => null, // startService / stopService / updateService → void
    };
  });
}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    _setupForegroundTaskMock();
  });

  group('WalkSessionNotifier', () {
    test('初期状態はセッション非アクティブ', () {
      final container = _makeContainer();
      addTearDown(container.dispose);

      final state = container.read(walkSessionProvider);
      expect(state.isActive, isFalse);
      expect(state.sessionId, isNull);
      expect(state.routePoints, isEmpty);
      expect(state.distanceMeters, 0.0);
      expect(state.error, isNull);
    });

    test('start() は位置情報権限が拒否された場合 false を返す', () async {
      final container = _makeContainer(permissionResult: LocationPermissionResult.permissionDenied);
      addTearDown(container.dispose);

      final ok = await container.read(walkSessionProvider.notifier).start();

      expect(ok, isFalse);
      expect(container.read(walkSessionProvider).isActive, isFalse);
    });

    test('start() は位置情報サービスが無効な場合 false を返し error をセットする', () async {
      final container = _makeContainer(permissionResult: LocationPermissionResult.serviceDisabled);
      addTearDown(container.dispose);

      final ok = await container.read(walkSessionProvider.notifier).start();

      expect(ok, isFalse);
      expect(container.read(walkSessionProvider).isActive, isFalse);
      expect(container.read(walkSessionProvider).error, AppConfig.locationServiceDisabledError);
    });

    test('start() は現在地が取得できない場合 false を返す', () async {
      final container = _makeContainer(position: null);
      addTearDown(container.dispose);

      final ok = await container.read(walkSessionProvider.notifier).start();

      expect(ok, isFalse);
      expect(container.read(walkSessionProvider).isActive, isFalse);
    });

    test('finish() はセッションが存在しない場合に何もしない', () async {
      final container = _makeContainer();
      addTearDown(container.dispose);

      await expectLater(
        container.read(walkSessionProvider.notifier).finish,
        returnsNormally,
      );
      expect(container.read(walkSessionProvider).isActive, isFalse);
    });

    test('finish() はアクティブなセッションを終了して状態をリセットする', () async {
      final container = _makeContainer();
      addTearDown(container.dispose);

      // 手動でアクティブ状態をセット
      container.read(walkSessionProvider.notifier).state = WalkSessionState(
        sessionId: 'session-1',
        startedAt: DateTime.now().subtract(const Duration(minutes: 10)),
        isActive: true,
        distanceMeters: 500,
        routePoints: [const GeoPoint(35.6, 139.6)],
      );
      expect(container.read(walkSessionProvider).isActive, isTrue);

      await container.read(walkSessionProvider.notifier).finish();

      final after = container.read(walkSessionProvider);
      expect(after.isActive, isFalse);
      expect(after.sessionId, isNull);
      expect(after.routePoints, isEmpty);
      expect(after.distanceMeters, 0.0);
    });

    test('複数の位置更新が順番に処理され全件がリポジトリに保存される', () async {
      final streamController = StreamController<Position>();
      addTearDown(streamController.close);

      final repo = _TrackingWalkSessionRepository();
      final container = _makeContainer(
        position: _makePosition(35.600, 139.600),
        positionStream: streamController.stream,
        uid: 'test-uid',
        repo: repo,
      );
      addTearDown(container.dispose);

      await container.read(walkSessionProvider.notifier).start();

      // 3件の位置更新を連続して流す
      streamController.add(_makePosition(35.601, 139.601));
      streamController.add(_makePosition(35.602, 139.602));
      streamController.add(_makePosition(35.603, 139.603));

      // _pendingUpdate チェーンが積まれるまで待つ
      await Future.delayed(Duration.zero);

      // finish() が _pendingUpdate を await するため、全件処理を保証できる
      await container.read(walkSessionProvider.notifier).finish();

      // 初期位置 1件 + 更新 3件 = 4件が順番どおりに保存されていること
      expect(repo.allAppendedPoints, hasLength(4));
      expect(repo.allAppendedPoints[1], const GeoPoint(35.601, 139.601));
      expect(repo.allAppendedPoints[2], const GeoPoint(35.602, 139.602));
      expect(repo.allAppendedPoints[3], const GeoPoint(35.603, 139.603));
    });

    test('finish() は処理中の位置更新を待ってからバッファをフラッシュする', () async {
      final streamController = StreamController<Position>();
      addTearDown(streamController.close);

      final repo = _TrackingWalkSessionRepository();
      final container = _makeContainer(
        position: _makePosition(35.600, 139.600),
        positionStream: streamController.stream,
        uid: 'test-uid',
        repo: repo,
      );
      addTearDown(container.dispose);

      await container.read(walkSessionProvider.notifier).start();

      // 位置更新をキューに積む
      streamController.add(_makePosition(35.601, 139.601));

      // _pendingUpdate にチェーンが積まれるまで待つ
      await Future.delayed(Duration.zero);

      // finish() は _pendingUpdate を await してからバッファをフラッシュする
      await container.read(walkSessionProvider.notifier).finish();

      // フラッシュで repo に渡されたポイントにキューの位置が含まれていること
      expect(
        repo.allAppendedPoints,
        contains(const GeoPoint(35.601, 139.601)),
        reason: 'finish() が _pendingUpdate を待たない場合、処理中の位置更新が失われる',
      );
    });
  });
}
