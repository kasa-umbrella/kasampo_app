# 開発ロードマップ

## 方針

**Phase 1〜3**: Firebase 直接接続で全機能を動かす。  
**Phase 4**: バックエンドAPIを実装し、`core/providers/` の注入先を差し替えてつなぎ込む。

Repository インターフェースは Phase 1 の時点から `domain/` に定義しておく。  
Firebase 実装は「後から差し替えられる実装の一つ」として書くことで、Phase 4 の移行コストを最小化する。

---

## Phase 0 — 環境構築・土台

### 目標
アプリが起動してスプラッシュ画面が表示される状態にする。

### タスク

- [ ] Firebase プロジェクト作成（iOS / Android の `google-services.json` / `GoogleService-Info.plist` 配置）
- [ ] `pubspec.yaml` に依存パッケージ追加

  ```yaml
  firebase_core, firebase_auth, cloud_firestore, firebase_storage,
  google_sign_in, riverpod_annotation, go_router,
  geolocator, google_maps_flutter, image_picker, flutter_image_compress
  ```

- [ ] `app.dart` 作成（`MaterialApp.router` + `GoRouter` の骨格）
- [ ] `core/theme/` にカラー・テキストスタイル定義
- [ ] `core/errors/` にアプリ共通例外クラス定義
- [ ] スプラッシュ画面（ロゴ表示 + Firebase 初期化待ち）実装
- [ ] `main.dart` で `Firebase.initializeApp()` を呼ぶ

### 完了基準
`flutter run` でスプラッシュ画面が表示される。

---

## Phase 1 — 認証

### 目標
サインイン・サインアウトが動く状態にする。

### タスク

**インターフェース定義（domain）**
- [ ] `features/auth/domain/repositories/i_auth_repository.dart` 作成

  ```dart
  abstract class IAuthRepository {
    Stream<AppUser?> get authStateChanges;
    Future<AppUser> signInWithGoogle();
    Future<AppUser> signInWithEmail(String email, String password);
    Future<void> signOut();
  }
  ```

**Firebase 実装（data）**
- [ ] `features/auth/data/repositories/firebase_auth_repository.dart` 作成

**モデル**
- [ ] `core/models/app_user.dart` 作成（`fromFirestore` / `toFirestore` 含む）

**プロバイダー注入**
- [ ] `core/providers/repository_providers.dart` に `authRepositoryProvider` 追加

  ```dart
  // ← ここを差し替えるだけでバックエンド版に切り替わる
  final authRepositoryProvider = Provider<IAuthRepository>(
    (ref) => FirebaseAuthRepository(),
  );
  ```

**UI**
- [ ] サインイン画面（Google ボタン + メール入力フォーム）
- [ ] 認証状態に応じたルーティング（スプラッシュ → サインイン or メイン）

### 完了基準
Google アカウントでサインイン・サインアウトできる。

---

## Phase 2 — メイン地図画面（閲覧のみ）

### 目標
地図が表示され、Firestore に入っているデータをルート・スポットとして表示できる状態にする。  
（この時点ではデータ投入は Firestore コンソールから手動で行う）

### タスク

**インターフェース定義**
- [ ] `features/map/domain/repositories/i_map_repository.dart` 作成

  ```dart
  abstract class IMapRepository {
    Future<List<WalkSession>> fetchRecentSessions({int limit});
    Future<List<Spot>> fetchSpotsInBounds(LatLngBounds bounds);
  }
  ```

**Firebase 実装**
- [ ] `features/map/data/repositories/firestore_map_repository.dart` 作成

**モデル**
- [ ] `core/models/walk_session.dart` 作成
- [ ] `core/models/spot.dart` 作成

**プロバイダー**
- [ ] `mapRepositoryProvider` を `core/providers/repository_providers.dart` に追加
- [ ] `mapSessionsProvider` / `mapSpotsProvider`（`FutureProvider`）を `features/map/` に追加

**UI**
- [ ] Google Maps ウィジェット配置
- [ ] 他ユーザーのルートをポリラインで描画
- [ ] スポットをマーカーで表示・タップでポップアップ
- [ ] 現在地ボタン
- [ ] ボトムナビゲーション骨格（地図 / 記録一覧 / プロフィール）

### 完了基準
地図が表示され、Firestore の既存データがルート・マーカーとして表示される。

---

## Phase 3 — 散歩セッション・スポット記録

### 目標
アプリ単体で散歩を開始・記録・終了できる状態にする。

### タスク

**インターフェース定義**
- [ ] `features/walk/domain/repositories/i_walk_session_repository.dart` 作成

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

- [ ] `features/walk/domain/repositories/i_spot_repository.dart` 作成

  ```dart
  abstract class ISpotRepository {
    Future<String> create(Spot spot);
    Stream<List<Spot>> watchBySession(String sessionId);
  }
  ```

**Firebase 実装**
- [ ] `features/walk/data/repositories/firestore_walk_session_repository.dart`
- [ ] `features/walk/data/repositories/firestore_spot_repository.dart`

**サービス**
- [ ] `core/services/location_service.dart`（GPS 取得・距離計算）
- [ ] `core/services/i_storage_service.dart`（インターフェース）
- [ ] `core/services/firebase_storage_service.dart`（写真アップロード + 圧縮）

**プロバイダー**
- [ ] `walkSessionRepositoryProvider` / `spotRepositoryProvider` を注入
- [ ] `WalkSessionNotifier`（セッション開始〜終了の状態管理）を実装

  ```dart
  class WalkSessionNotifier extends AsyncNotifier<WalkSession?> {
    Future<void> start();
    Future<void> addRoutePoint(Position pos);
    Future<void> addSpot({required File photo, required String description});
    Future<void> finish();
  }
  ```

**UI**
- [ ] セッション中画面（経過時間・距離・リアルタイムルート描画）
- [ ] FAB（+ボタン）からセッション開始
- [ ] スポット記録画面（カメラ起動・説明入力・保存）
- [ ] 終了確認ダイアログ

### 完了基準
散歩を開始 → GPSで記録 → スポット写真を追加 → 終了 → Firestore にデータが保存される。

---

## Phase 4 — 記録一覧・詳細・プロフィール

### 目標
一覧・詳細・プロフィール画面を実装し、アプリとして一通り完結する状態にする。

### タスク

**記録一覧・詳細**
- [ ] `features/record/domain/repositories/i_record_repository.dart`

  ```dart
  abstract class IRecordRepository {
    Future<List<WalkSession>> fetchPage({
      DocumentSnapshot? lastDoc,
      int limit,
      String? filterUserId,
      DateTimeRange? dateRange,
    });
    Future<WalkSession> fetchById(String sessionId);
    Future<List<Spot>> fetchSpotsBySession(String sessionId);
    Future<void> deleteSession(String sessionId);
    Future<void> updateVisibility(String sessionId, {required bool isPublic});
  }
  ```

- [ ] Firebase 実装・プロバイダー注入
- [ ] 記録一覧画面（無限スクロール・フィルタ）
- [ ] 記録詳細画面（地図上にルート＋スポット）

**プロフィール**
- [ ] `features/profile/domain/repositories/i_user_repository.dart`
- [ ] プロフィール画面（統計・アバター編集・サインアウト）

**Firestore Security Rules 設定**
- [ ] 書き込みは `request.auth.uid == resource.data.userId` を全コレクションに適用
- [ ] `isPublic: false` のセッションは本人以外読み取り不可
- [ ] `description` / `routePoints` のサイズ上限をルールで制限

### 完了基準
全画面が動作し、一通りのユーザーフローが完結する。

---

## Phase 5 — バックエンドAPI実装・差し替え

### 目標
カスタムバックエンド（Cloud Functions / 独自サーバー）を実装し、Firebase 直接接続から切り替える。

### 前提
Phase 1〜4 で全 Repository・Service をインターフェース経由で注入しているため、  
差し替えは `core/providers/repository_providers.dart` の実装クラスを変えるだけで完結する。

### タスク

**API実装（バックエンド側）**
- [ ] バックエンドの技術選定（Cloud Functions / Go / Node.js 等）
- [ ] エンドポイント設計（`spec.md` のデータモデルを参照）
- [ ] 認証ミドルウェア実装（Firebase Auth の JWT 検証）

**APIクライアント追加（`core/network/`）**
- [ ] `Dio` セットアップ・認証ヘッダー付与インターセプター
- [ ] 各 Repository の API 版実装を追加

  ```
  features/walk/data/repositories/
  ├── firestore_walk_session_repository.dart  # そのまま残す
  └── api_walk_session_repository.dart        # 新規追加
  ```

**注入先の切り替え**
- [ ] `core/providers/repository_providers.dart` の実装クラスを差し替える

  ```dart
  // Before
  final walkSessionRepositoryProvider = Provider(
    (ref) => FirestoreWalkSessionRepository(...),
  );

  // After
  final walkSessionRepositoryProvider = Provider(
    (ref) => ApiWalkSessionRepository(ref.read(dioProvider)),
  );
  ```

- [ ] Firebase Firestore のクライアント側ルールを書き込み禁止に変更（バックエンドのみ書き込み可）

### 完了基準
UI・ドメインロジックを一切変更せず、データソースがバックエンドAPIに切り替わる。

---

## フェーズサマリー

| Phase | 内容 | Firebase | バックエンド |
|-------|------|----------|-------------|
| 0 | 環境構築・スプラッシュ | 初期化のみ | なし |
| 1 | 認証 | Auth | なし |
| 2 | 地図閲覧 | Firestore 読み取り | なし |
| 3 | 散歩記録・スポット | Firestore 読み書き・Storage | なし |
| 4 | 一覧・詳細・プロフィール | Firestore 全機能 | なし |
| 5 | バックエンド差し替え | 読み取りのみ or 廃止 | API全面移行 |