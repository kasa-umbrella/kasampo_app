# ヒートマップ機能 実装プラン

## 概要

ユーザーの全散歩セッションのGPS軌跡を集計し、よく歩くエリアをヒートマップでメインマップに常時オーバーレイ表示する機能。

---

## 画面・機能スコープ

| 機能 | 内容 |
|------|------|
| ヒートマップ表示 | メインマップ画面に常時オーバーレイ表示 |
| データ取得 | Firestoreから自分の全セッションのroutePointsを取得 |
| ポイント間引き | 取得後クライアント側でN件に1件にダウンサンプリング |

スコープ外: 期間フィルタ・表示ON/OFF切り替え・他ユーザーのデータ表示

---

## 使用パッケージ

- [`flutter_map_heatmap`](https://pub.dev/packages/flutter_map_heatmap) — flutter_mapに重ねて使うヒートマップレイヤー

---

## 実装ファイル一覧

```
lib/
├── core/
│   └── constants/
│       └── app_config.dart          # heatmapSampleRate 定数を追加
│
└── features/
    ├── heatmap/
    │   ├── data/
    │   │   └── repositories/
    │   │       └── firestore_heatmap_repository.dart  # 全routePoints取得
    │   └── providers/
    │       └── heatmap_providers.dart                 # Repository注入 + 非同期取得
    │
    └── map/
        └── presentation/
            └── map_screen.dart      # HeatMapLayer を children に追加
```

---

## 実装ステップ

### Step 1 — 定数追加

**`core/constants/app_config.dart`**

```dart
static const int heatmapSampleRate = 5; // N件に1件を使用
```

---

### Step 2 — データ層

**`firestore_heatmap_repository.dart`**

```dart
class FirestoreHeatmapRepository {
  final _collection = FirebaseFirestore.instance.collection('walkSessions');

  Future<List<LatLng>> fetchSampledRoutePoints(String userId) async {
    final snapshot = await _collection
        .where('userId', isEqualTo: userId)
        .where('endedAt', isNull: false)
        .get();

    final allPoints = snapshot.docs
        .expand((doc) => (doc.data()['routePoints'] as List).cast<GeoPoint>())
        .toList();

    return allPoints
        .asMap()
        .entries
        .where((e) => e.key % AppConfig.heatmapSampleRate == 0)
        .map((e) => LatLng(e.value.latitude, e.value.longitude))
        .toList();
  }
}
```

---

### Step 3 — プロバイダー層

**`heatmap_providers.dart`**

```dart
@riverpod
FirestoreHeatmapRepository heatmapRepository(Ref ref) =>
    FirestoreHeatmapRepository();

@riverpod
Future<List<WeightedLatLng>> heatmapPoints(Ref ref) async {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return [];
  final points = await ref
      .read(heatmapRepositoryProvider)
      .fetchSampledRoutePoints(uid);
  return points.map((p) => WeightedLatLng(p, 1.0)).toList();
}
```

---

### Step 4 — MapScreen への統合

**`map_screen.dart`** の `FlutterMap` の `children` に `HeatMapLayer` を追加する。

```dart
final points = ref.watch(heatmapPointsProvider).asData?.value ?? [];

// children に追加
if (points.isNotEmpty)
  HeatMapLayer(
    heatMapDataSource: InMemoryHeatMapDataSource(data: points),
    heatMapOptions: HeatMapOptions(
      gradient: HeatMapOptions.defaultGradient,
      minOpacity: 0.3,
    ),
  ),
```

ヒートマップは `AppTileLayer` の直後、ルートや現在地マーカーより下に描画する。

---

## データフロー

```
MapScreen 表示
  └─ heatmapPointsProvider (AsyncProvider)
       └─ FirestoreHeatmapRepository.fetchSampledRoutePoints(userId)
            └─ walkSessions where userId == me && endedAt != null
                 └─ 全ドキュメントの routePoints をフラット展開
                      └─ N件に1件にダウンサンプリング
                           └─ List<WeightedLatLng> → HeatMapLayer に渡す
```

---

## 実装上の注意点

- **読み取りコスト**: セッション数が増えるほどドキュメント読み取り数が増える。将来的にセッション数が多くなった場合はサーバー側集計（Cloud Functions）を検討。
- **サンプリングレート**: `heatmapSampleRate` を上げると軽くなるが密度の精度が落ちる。5〜10を目安に調整。
- **空データ対応**: routePointsが空のセッション（即終了など）が混在しても `expand` で問題なく動く。データが0件のときは `HeatMapLayer` を描画しない。
- **描画順**: HeatMapLayer は AppTileLayer の直後、マーカー類より前に入れること。
- **UI設計**: デザイン指示を受けてから実装すること（`instruction.md` 参照）。
