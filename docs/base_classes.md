# 基底クラス一覧

## アーキテクチャ概要

```
lib/
├── models/          # データモデル（Firestore ドキュメントの型）
├── repositories/    # Firestore アクセス層
├── services/        # 外部サービス（GPS・Storage・Auth）
├── providers/       # Riverpod プロバイダー・Notifier
├── screens/         # 各画面ウィジェット
└── widgets/         # 共通UIコンポーネント
```

レイヤー依存の方向: `screens → providers → repositories / services → models`

---

## models/

Firestore ドキュメントとアプリ内データの型定義。immutable で扱う。

### `AppUser`

```dart
class AppUser {
  final String uid;
  final String displayName;
  final String? avatarUrl;
  final DateTime createdAt;

  factory AppUser.fromFirestore(DocumentSnapshot doc);
  Map<String, dynamic> toFirestore();
}
```

### `WalkSession`

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

  factory WalkSession.fromFirestore(DocumentSnapshot doc);
  Map<String, dynamic> toFirestore();

  // セッション中か否か
  bool get isActive => endedAt == null;

  // 表示用フォーマット済み距離（例: "1.2 km"）
  String get formattedDistance;

  // 表示用フォーマット済み時間（例: "32分"）
  String get formattedDuration;
}
```

### `Spot`

```dart
class Spot {
  final String id;
  final String sessionId;
  final String userId;
  final GeoPoint location;
  final String photoUrl;
  final String description;
  final DateTime createdAt;

  factory Spot.fromFirestore(DocumentSnapshot doc);
  Map<String, dynamic> toFirestore();
}
```

---

## repositories/

Firestore の CRUD を担うクラス。Provider 経由で注入する。
直接 Firebase SDK を呼ぶのはこのレイヤーのみ。

### `BaseRepository<T>`

```dart
abstract class BaseRepository<T> {
  final FirebaseFirestore _db;
  final String collectionPath;

  BaseRepository(this._db, this.collectionPath);

  CollectionReference get collection => _db.collection(collectionPath);

  // サブクラスで実装: ドキュメント → モデル変換
  T fromSnapshot(DocumentSnapshot doc);

  // 共通: ID指定で1件取得
  Future<T?> findById(String id);

  // 共通: リアルタイム監視
  Stream<T?> watchById(String id);
}
```

### `WalkSessionRepository extends BaseRepository<WalkSession>`

```dart
class WalkSessionRepository extends BaseRepository<WalkSession> {
  // 新規セッション作成
  Future<String> create(WalkSession session);

  // ルートポイント追記（セッション中に逐次呼ぶ）
  Future<void> appendRoutePoint(String sessionId, GeoPoint point);

  // セッション終了（endedAt・distance・duration を更新）
  Future<void> finish(String sessionId, {
    required DateTime endedAt,
    required double distanceMeters,
    required int durationSeconds,
  });

  // 地図表示用: 直近N件の公開セッション取得
  Future<List<WalkSession>> fetchRecent({int limit = 20});

  // 一覧画面用: ページネーション付き取得
  Future<List<WalkSession>> fetchPage({
    DocumentSnapshot? lastDoc,
    int limit = 20,
    String? filterUserId,
    DateTimeRange? dateRange,
  });

  // 自分のセッション一覧
  Stream<List<WalkSession>> watchMySession(String uid);
}
```

### `SpotRepository extends BaseRepository<Spot>`

```dart
class SpotRepository extends BaseRepository<Spot> {
  // スポット作成
  Future<String> create(Spot spot);

  // セッションに紐づくスポット一覧（リアルタイム）
  Stream<List<Spot>> watchBySession(String sessionId);

  // 地図表示用: GeoPoint の範囲内スポット取得
  Future<List<Spot>> fetchInBounds(LatLngBounds bounds);

  // スポット削除（自分のもののみ）
  Future<void> delete(String spotId);
}
```

### `UserRepository extends BaseRepository<AppUser>`

```dart
class UserRepository extends BaseRepository<AppUser> {
  // 初回ログイン時にドキュメント作成
  Future<void> createIfNotExists(AppUser user);

  // プロフィール更新
  Future<void> updateProfile(String uid, {String? displayName, String? avatarUrl});

  // 統計取得（総距離・総時間・総回数）
  Future<UserStats> fetchStats(String uid);
}
```

---

## services/

Firebase / OS ネイティブ機能のラッパー。副作用を持つ処理を集約する。

### `AuthService`

```dart
class AuthService {
  final FirebaseAuth _auth;

  // 現在のユーザー
  User? get currentUser;

  // 認証状態の Stream
  Stream<User?> get authStateChanges;

  // Google サインイン
  Future<UserCredential> signInWithGoogle();

  // メール + パスワード サインイン / 登録
  Future<UserCredential> signInWithEmail(String email, String password);
  Future<UserCredential> signUpWithEmail(String email, String password);

  // サインアウト
  Future<void> signOut();

  // パスワードリセットメール送信
  Future<void> sendPasswordReset(String email);
}
```

### `LocationService`

```dart
class LocationService {
  // 位置情報パーミッション確認・リクエスト
  Future<bool> requestPermission();

  // 現在地を1回取得
  Future<Position> getCurrentPosition();

  // 位置情報の継続監視 Stream（散歩セッション中に使用）
  // accuracy: high, interval: 5秒
  Stream<Position> watchPosition();

  // 2点間の距離を計算（メートル）
  double distanceBetween(Position a, Position b);
}
```

### `StorageService`

```dart
class StorageService {
  final FirebaseStorage _storage;

  // 写真をアップロードしてダウンロードURLを返す
  // アップロード前に圧縮・リサイズを実施
  Future<String> uploadSpotPhoto({
    required String userId,
    required String sessionId,
    required File imageFile,
  });

  // 写真削除
  Future<void> deletePhoto(String downloadUrl);
}
```

---

## providers/（Riverpod）

### 認証系

```dart
// 現在の認証ユーザー
final authUserProvider = StreamProvider<User?>(...);

// 現在の AppUser モデル
final currentUserProvider = FutureProvider<AppUser?>(...);
```

### セッション系

```dart
// アクティブな散歩セッションの状態管理
class WalkSessionNotifier extends AsyncNotifier<WalkSession?> {
  // セッション開始
  Future<void> start();

  // GPSポイント追加（LocationService の watchPosition を受けて呼ぶ）
  Future<void> addRoutePoint(Position position);

  // スポット追加
  Future<void> addSpot({required File photo, required String description});

  // セッション終了
  Future<void> finish();
}

final walkSessionProvider = AsyncNotifierProvider<WalkSessionNotifier, WalkSession?>(...);
```

### 地図系

```dart
// 地図上に表示するセッション一覧
final mapSessionsProvider = FutureProvider<List<WalkSession>>(...);

// 地図上に表示するスポット一覧（表示範囲に応じて更新）
final mapSpotsProvider = FutureProvider.family<List<Spot>, LatLngBounds>(...);
```

### 一覧系

```dart
// 記録一覧（ページネーション）
class SessionListNotifier extends AsyncNotifier<List<WalkSession>> {
  Future<void> fetchMore();
  Future<void> applyFilter({String? userId, DateTimeRange? range});
}

final sessionListProvider = AsyncNotifierProvider<SessionListNotifier, List<WalkSession>>(...);
```

---

## 補足: 命名・設計方針

| 項目 | 方針 |
|------|------|
| モデルの不変性 | `copyWith` を持つ immutable クラス。`freezed` を使用する |
| エラーハンドリング | Repository / Service は例外をそのまま投げる。Provider 層でキャッチして UI に伝える |
| Firestore 直接参照 | Repository 以外では `FirebaseFirestore.instance` を呼ばない |
| テスト | Phase 1 から対応。Repository はインターフェース化して mock 差し替えを可能にし、主要ロジックには単体テストを書く |