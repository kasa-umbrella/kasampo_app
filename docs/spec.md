# 地図アプリ仕様書

## アプリ名

かさんぽ  
開発者の笠原 + 散歩でかさんぽ

---

## アプリ概要

散歩を記録するアプリ。  
散歩を始めるときに開始ボタンを押して、散歩セッションを開始する。散歩コースをGPSで記録する。  
散歩中に面白い箇所を見つけたら、それを写真に撮ってディスクリプションといっしょに記録することができる。

記録はすべてFirestoreもしくはCloudflare上のNoSQL DBに保存される。

他のユーザーがどこを歩いて、どんな記録をしたかがメイン画面に表示されて、詳細を見ることができる。

---

## 技術スタック

| 項目 | 内容 |
|------|------|
| フレームワーク | Flutter (Dart) |
| 対応プラットフォーム | iOS / Android |
| データベース | Firestore (Cloud Firestore) |
| ストレージ | Firebase Storage（写真保存用） |
| 認証 | Firebase Authentication |
| 地図 | Google Maps Flutter / MapLibre |
| GPS | geolocator パッケージ |
| 状態管理 | Riverpod |

---

## データモデル

### users コレクション

```
users/{userId}
  - displayName: string
  - avatarUrl: string
  - createdAt: timestamp
```

### walkSessions コレクション

```
walkSessions/{sessionId}
  - userId: string
  - startedAt: timestamp
  - endedAt: timestamp | null
  - routePoints: Array<GeoPoint>   // GPSログ（一定間隔でサンプリング）
  - distance: number               // 合計距離（m）
  - duration: number               // 合計時間（秒）
  - isPublic: bool
```

### spots コレクション

```
spots/{spotId}
  - sessionId: string
  - userId: string
  - location: GeoPoint
  - photoUrl: string
  - description: string
  - createdAt: timestamp
```

---

## 画面一覧

---

### 1. スプラッシュ画面（初期画面）

ロゴと copyright を表示する。アプリ起動直後に表示され、認証状態に応じて遷移する。

**機能**
- アプリロゴ・アプリ名表示
- copyright 表示
- Firebase Auth の認証状態チェック
  - 未ログイン → サインイン画面へ
  - ログイン済み → メイン画面へ

**実装メモ**
- 表示時間: 1.5〜2秒程度（またはFirebase初期化完了まで）
- `SplashScreen` ウィジェット、`firebase_core` 初期化と並行して実行

---

### 2. サインイン / サインアップ画面

**機能**
- Googleアカウントでサインイン（`google_sign_in` パッケージ）
- メールアドレス + パスワードでサインイン / 新規登録
- パスワードリセット

**実装メモ**
- 匿名ログインは対応しない（セキュリティおよびデータ品質の観点から意図的に除外）
- 初回ログイン時はFirestoreに `users/{uid}` ドキュメントを作成する

---

### 3. メイン画面（地図画面）

地図を中心に据えたメイン画面。自分・他ユーザーの散歩コースとスポット写真を重ねて表示する。

**機能**
- インタラクティブな地図（パン・ズーム）
- 他ユーザーの散歩ルート（ポリライン）表示
- スポット写真をマーカーとして地図上に表示
- マーカータップ → スポット詳細ポップアップ
- 現在地への移動ボタン
- 右下のFAB（+ボタン）→ 散歩セッション開始
- ボトムナビゲーション or タブ：地図 / 記録一覧 / プロフィール

**表示データの取得**
- `walkSessions` から直近N件（またはマップの表示範囲内）を取得
- `spots` をリアルタイムリスナーで監視（Firestore `onSnapshot`）

**実装メモ**
- ルートはポリラインで描画（`routePoints` を順番に繋げる）
- マーカーはサムネイル画像を使うと見栄えが良い
- 大量データ対策：マップのズームレベルに応じてクラスタリングを実装する

---

### 4. 散歩セッション中画面

散歩セッション開始後に表示されるオーバーレイ or フルスクリーン画面。

**機能**
- 経過時間のリアルタイム表示
- 現在の移動距離表示
- 現在地を中心とした地図（自動追従）
- 歩いたルートのリアルタイム描画
- スポット追加ボタン（カメラアイコン）→ スポット記録画面へ
- 散歩終了ボタン → 確認ダイアログ → 記録保存 → メイン画面へ

**GPS記録**
- `geolocator` で位置情報を定期取得（例: 5秒間隔）
- 取得した `GeoPoint` を `routePoints` に随時追記
- セッション終了時に Firestore へ保存

**実装メモ**
- バックグラウンド位置情報が必要な場合は `flutter_background_geolocation` を検討
- 電池消費を考慮して精度と取得間隔を調整（`LocationAccuracy.high` / 5〜10秒）
- セッション中のデータはローカル保持し、終了時に一括書き込み（途中クラッシュ対策として `sqflite` 等のローカルDBで永続化する）

---

### 5. スポット記録画面

散歩中に面白い場所を見つけたときに記録する画面。

**機能**
- カメラ起動 or カメラロールから写真選択（`image_picker` パッケージ）
- 写真プレビュー表示
- ディスクリプションのテキスト入力
- 現在地の自動取得・表示
- 保存ボタン → Firebase Storage にアップロード → Firestore に `spots` 追加
- キャンセルボタン → セッション中画面に戻る

**実装メモ**
- 写真はアップロード前にリサイズ・圧縮（`flutter_image_compress`）
- `photoUrl` には Firebase Storage のダウンロードURLを保存

---

### 6. 記録一覧画面

自分・他ユーザーの散歩記録を一覧で確認・検索できる画面。

**機能**
- 散歩記録カードのリスト表示（ユーザー名・日時・距離・時間・サムネイル）
- 検索・フィルタ
  - ユーザー名で絞り込み
  - 日付範囲で絞り込み
  - 自分の記録のみ表示切り替え
- カードタップ → 散歩記録詳細画面へ
- 無限スクロール / ページネーション

**実装メモ**
- Firestore クエリに `orderBy('startedAt', descending: true)` + `limit` でページング
- `isPublic: false` のレコードは本人以外には表示しない

---

### 7. 散歩記録詳細画面

特定の散歩記録の詳細を確認する画面。

**機能**
- 地図上にルートとスポットマーカーを表示
- 記録情報（日時・距離・時間）表示
- スポット一覧（写真サムネイル + ディスクリプション）
- 自分の記録の場合：削除ボタン・公開/非公開切り替え

**実装メモ**
- `walkSessions/{sessionId}` と関連する `spots` を結合して表示
- ルートはポリラインで描画

---

### 8. ユーザープロフィール画面

自分のプロフィールと統計情報を確認・編集する画面。

**機能**
- アバター画像・表示名の表示と編集
- 統計（総散歩回数・総距離・総時間）
- 自分の散歩記録一覧（記録一覧画面と同様のUI）
- サインアウトボタン

**実装メモ**
- 統計はオンデマンドで集計（Firestoreのクエリ）またはユーザードキュメントに非正規化して持つ

---

## 権限（パーミッション）

| 権限 | 用途 | プラットフォーム |
|------|------|------------------|
| 位置情報（使用中） | GPS記録・現在地表示 | iOS / Android |
| 位置情報（常に許可） | バックグラウンドGPS（将来） | iOS / Android |
| カメラ | スポット写真撮影 | iOS / Android |
| フォトライブラリ | カメラロールから写真選択 | iOS |

---

## 主要パッケージ

```yaml
dependencies:
  firebase_core: ^x.x.x
  firebase_auth: ^x.x.x
  cloud_firestore: ^x.x.x
  firebase_storage: ^x.x.x
  google_maps_flutter: ^x.x.x   # または maplibre_gl
  geolocator: ^x.x.x
  image_picker: ^x.x.x
  flutter_image_compress: ^x.x.x
  google_sign_in: ^x.x.x
  riverpod: ^x.x.x               # 状態管理
  go_router: ^x.x.x              # ルーティング
```

---

## 画面遷移フロー

```
スプラッシュ
  ├── 未認証 → サインイン/サインアップ → メイン
  └── 認証済み → メイン
       ├── + ボタン → セッション中
       │     └── カメラ → スポット記録 → セッション中
       │     └── 終了 → メイン
       ├── ボトムナビ「記録一覧」→ 記録一覧 → 記録詳細
       └── ボトムナビ「プロフィール」→ プロフィール
```