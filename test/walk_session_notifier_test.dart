import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kasampo_app/core/services/location_service.dart';
import 'package:kasampo_app/features/walk/domain/repositories/i_walk_session_repository.dart';
import 'package:kasampo_app/features/walk/providers/walk_providers.dart';
import 'package:kasampo_app/features/walk/providers/walk_session_notifier.dart';

// --- Fakes ---

class _FakeLocationService extends LocationService {
  final bool permissionGranted;
  final Position? position;

  _FakeLocationService({this.permissionGranted = true, this.position});

  @override
  Future<bool> requestPermission() async => permissionGranted;

  @override
  Future<Position?> getCurrentPosition() async => position;

  @override
  Stream<Position> watchPosition() => const Stream.empty();

  @override
  double calcDistance(GeoPoint from, GeoPoint to) => 0;
}

class _FakeWalkSessionRepository implements IWalkSessionRepository {
  @override
  Future<String> create(String userId, DateTime startedAt) async => 'session-1';

  @override
  Future<void> appendRoutePoint(String sessionId, GeoPoint point) async {}

  @override
  Future<void> finish(
    String sessionId, {
    required DateTime endedAt,
    required double distanceMeters,
    required int durationSeconds,
  }) async {}
}

ProviderContainer _makeContainer({
  bool permissionGranted = true,
  Position? position,
}) =>
    ProviderContainer(
      overrides: [
        locationServiceProvider.overrideWith(
          (_) => _FakeLocationService(
            permissionGranted: permissionGranted,
            position: position,
          ),
        ),
        walkSessionRepositoryProvider.overrideWith(
          (_) => _FakeWalkSessionRepository(),
        ),
      ],
    );

void main() {
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
      final container = _makeContainer(permissionGranted: false);
      addTearDown(container.dispose);

      final ok = await container.read(walkSessionProvider.notifier).start();

      expect(ok, isFalse);
      expect(container.read(walkSessionProvider).isActive, isFalse);
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
  });
}
