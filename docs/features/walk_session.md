# 散歩セッション機能 実装プラン

## 概要

散歩の開始〜終了をGPSで記録し、Firestoreへ保存する機能。  
`construct_load_map.md` の **Phase 3** に相当する。

---

## 画面・機能スコープ

| 機能 | 内容 |
|------|------|
| セッション開始 | メイン画面の+ボタン → 開始ボタン → メイン画面にオーバーレイ表示 |
| GPS記録 | 5秒間隔でGeoPointを取得・`routePoints`に追記 |
| 経過時間・距離表示 | セッション中画面でリアルタイム更新 |
| スポット追加 | カメラ起動 → 写真 + 説明入力 → Firestore保存 |
| セッション終了 | 確認ダイアログ → `walkSessions`に保存 → メイン画面へ |

スコープ外: バックグラウンドGPS（Phase 5 以降で検討）

---

## 実装ファイル一覧

```
lib/
├── core/
│   ├── models/
│   │   ├── walk_session.dart          # WalkSessionモデル
│   │   └── spot.dart                  # Spotモデル
│   └── services/
│       ├── location_service.dart      # GPS取得・距離計算
│       ├── i_storage_service.dart     # ストレージ インターフェース
│       └── firebase_storage_service.dart  # 写真アップロード
│
└── features/
    └── walk/
        ├── domain/
        │   └── repositories/
        │       ├── i_walk_session_repository.dart
        │       └── i_spot_repository.dart
        ├── data/
        │   └── repositories/
        │       ├── firestore_walk_session_repository.dart
        │       └── firestore_spot_repository.dart
        ├── providers/
        │   ├── walk_providers.dart        # Repository注入
        │   ├── walk_providers.g.dart
        │   ├── walk_session_notifier.dart # セッション状態管理
        │   └── walk_session_notifier.g.dart
        └── presentation/
            ├── result/
            │   └── walk_result_screen.dart    # 結果画面
            └── spot/
                └── spot_record_screen.dart    # スポット記録画面

    └── home/
        └── presentation/
            └── widgets/
                ├── walk_session_overlay.dart  # セッション中オーバーレイ（MainScreen上に表示）
                └── walk_start_bottom_sheet.dart  # セッション開始ボタンシート
```

---

## 実装ステップ

### Step 1 — モデル定義

**`core/models/walk_session.dart`**

```dart
class WalkSession {
  final String id;
  final String userId;
  final DateTime startedAt;
  final DateTime? endedAt;
  final List<GeoPoint> routePoints;
  final double distanceMeters;
  final int durationSeconds;
  final bool isPublic;
}
```

**`core/models/spot.dart`**

```dart
class Spot {
  final String id;
  final String sessionId;
  final String userId;
  final GeoPoint location;
  final String photoUrl;
  final String description;
  final DateTime createdAt;
}
```

両モデルに `fromFirestore` / `toFirestore` を実装する。

---

### Step 2 — ドメイン層（インターフェース定義）

**`i_walk_session_repository.dart`**

```dart
abstract class IWalkSessionRepository {
  Future<String> create(String userId, DateTime startedAt);
  Future<void> appendRoutePoint(String sessionId, GeoPoint point);
  Future<void> finish(String sessionId, {
    required DateTime endedAt,
    required double distanceMeters,
    required int durationSeconds,
  });
}
```

**`i_spot_repository.dart`**

```dart
abstract class ISpotRepository {
  Future<String> create(Spot spot);
  Stream<List<Spot>> watchBySession(String sessionId);
}
```

---

### Step 3 — データ層（Firebase実装）

**`firestore_walk_session_repository.dart`**

| メソッド | Firestore操作 |
|----------|--------------|
| `create` | `walkSessions` にドキュメント追加、生成IDを返す |
| `appendRoutePoint` | `FieldValue.arrayUnion` で `routePoints` に追記 |
| `finish` | `endedAt` / `distanceMeters` / `durationSeconds` を `update` |

**`firestore_spot_repository.dart`**

| メソッド | Firestore操作 |
|----------|--------------|
| `create` | `spots` にドキュメント追加 |
| `watchBySession` | `where('sessionId', ==)` の `snapshots()` |

---

### Step 4 — サービス層

**`location_service.dart`**

```dart
class LocationService {
  // 位置情報パーミッション確認
  Future<bool> requestPermission();

  // 5秒間隔のGPS Streamを返す
  Stream<Position> watchPosition();

  // 2点間の距離を計算（メートル）
  double calcDistance(GeoPoint from, GeoPoint to);
}
```

- `geolocator` パッケージを使用
- 精度: `LocationAccuracy.high`、間隔: `5000ms`

**`i_storage_service.dart` / `firebase_storage_service.dart`**

```dart
abstract class IStorageService {
  Future<String> uploadPhoto(File file, String path);
}
```

- アップロード前に `flutter_image_compress` でリサイズ（長辺1200px, quality 85）
- 保存先: `spots/{userId}/{timestamp}.jpg`
- 戻り値: Firebase StorageのダウンロードURL

---

### Step 5 — 状態管理（WalkSessionNotifier）

```dart
@riverpod
class WalkSessionNotifier extends _$WalkSessionNotifier {
  // セッション開始（Firestoreにドキュメント作成 → GPS監視開始）
  Future<void> start();

  // GPS位置をroutePointsに追記（5秒ごとにLocationServiceから呼ばれる）
  Future<void> _onPositionUpdate(Position pos);

  // スポット追加（写真アップロード → spotsドキュメント作成）
  Future<void> addSpot({required File photo, required String description});

  // セッション終了（Firestoreに保存 → GPS監視停止 → 状態クリア）
  Future<void> finish();
}
```

**状態の型**

```dart
class WalkSessionState {
  final String? sessionId;
  final DateTime? startedAt;
  final List<GeoPoint> routePoints;
  final double distanceMeters;
  final bool isActive;
}
```

**GPS監視の管理**

- `start()` 内で `LocationService.watchPosition()` を listen → `StreamSubscription` を保持
- `finish()` で `subscription.cancel()`

---

### Step 6 — UI

#### セッション中オーバーレイ（`walk_session_overlay.dart`）

専用画面へは遷移せず、`MainScreen` の `Stack` 上にオーバーレイとして表示する。
`walkSessionProvider` を watch し、`isActive == true` のときのみ表示される。

| 要素 | 実装 |
|------|------|
| 経過時間 | `Timer.periodic(1s)` でカウントアップ表示 |
| 移動距離 | `WalkSessionState.distanceMeters` を `ref.watch` |
| スポットボタン | カメラアイコン → `context.go('/session/spot')` |
| 終了ボタン | 確認ダイアログ → `notifier.finish()` → `context.go('/result')` |

地図は `MainScreen` に常駐する `MapScreen` がそのまま使われ、GPS更新のたびに現在地へカメラ追従する。

#### スポット記録画面（`spot_record_screen.dart`）

| 要素 | 実装 |
|------|------|
| 写真選択 | `image_picker` でカメラ or カメラロール |
| 写真プレビュー | 選択後に画面内表示 |
| 説明入力 | `TextField` |
| 保存ボタン | `notifier.addSpot()` → `context.go('/home')` |
| キャンセル | `context.go('/home')` |

---

### Step 7 — ルーティング

セッション中は専用ルートへ遷移せず、`/home` にとどまりオーバーレイを表示する。
`app.dart` の `GoRouter` に定義するルートは以下：

```dart
GoRoute(path: '/home', builder: (_, __) => const MainScreen()),
GoRoute(path: '/session/spot', builder: (_, __) => const SpotRecordScreen()),
GoRoute(path: '/result', builder: (_, state) => WalkResultScreen(data: state.extra as WalkResultData)),
```

`WalkStartBottomSheet` の開始ボタンは `notifier.start()` を呼ぶのみで画面遷移しない。
`isActive` を watch した `MainScreen` が自動的にオーバーレイを表示する。

---

## データフロー

```
+ボタン（MainScreen）
  └─ WalkStartBottomSheet「開始」
       └─ WalkSessionNotifier.start()
            ├─ Firestore: walkSessions ドキュメント作成
            ├─ LocationService.watchPosition() 開始
            │     └─ (5mごと) _onPositionUpdate()
            │           ├─ Firestore: routePoints に追記
            │           └─ State: distanceMeters を加算
            └─ isActive = true → MainScreen が WalkSessionOverlay を表示

カメラボタン（WalkSessionOverlay）
  └─ context.go('/session/spot') → SpotRecordScreen
       └─ WalkSessionNotifier.addSpot()
            ├─ FirebaseStorageService.uploadPhoto()
            └─ Firestore: spots ドキュメント作成
       └─ 保存/キャンセル → context.go('/home')

終了ボタン（WalkSessionOverlay）
  └─ 確認ダイアログ
       └─ WalkSessionNotifier.finish()
            ├─ Firestore: walkSessions を更新（endedAt / distance / duration）
            ├─ LocationService watchPosition キャンセル
            ├─ State クリア（isActive = false）
            └─ context.go('/result') → WalkResultScreen
```

---

## 実装上の注意点

- **パーミッション**: `LocationService.requestPermission()` は `WalkSessionNotifier.start()` の冒頭で呼ぶ。拒否された場合はセッション開始しないでエラーを返す。
- **途中クラッシュ対策**: Phase 3 では `endedAt == null` のセッションはアプリ再起動時に「中断されたセッション」として扱う（一覧から非表示にする）。ローカル永続化（sqflite）は Phase 5 以降で対応。
- **距離計算**: `routePoints` が空の状態で `calcDistance` を呼ばないよう注意。
- **UI設計**: デザイン指示を受けてから実装すること（`instruction.md` 参照）。
