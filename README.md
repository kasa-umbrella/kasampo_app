# かさんぽ

散歩ルートとスポット写真を記録・共有するモバイルアプリ。

## 概要

散歩を開始するとGPSでルートを自動記録する。途中で気になった場所を写真とメモで残せる。
他のユーザーの散歩ルートやスポット写真をメイン画面の地図上でリアルタイムに確認できる。

## 技術スタック

| 項目 | 内容 |
|------|------|
| フレームワーク | Flutter (Dart) |
| 対応プラットフォーム | iOS / Android |
| データベース | Cloud Firestore |
| ストレージ | Firebase Storage |
| 認証 | Firebase Authentication |
| 地図 | Google Maps Flutter |
| 状態管理 | Riverpod |
| ルーティング | go_router |

## 画面構成

| 画面 | 概要 |
|------|------|
| スプラッシュ | 起動時のロゴ表示・認証状態チェック |
| サインイン / サインアップ | Google / メールアドレスで認証 |
| メイン（地図） | 他ユーザーのルート・スポットを地図上に表示 |
| セッション中 | GPS記録・経過時間・距離をリアルタイム表示 |
| スポット記録 | 写真撮影とメモを現在地に紐付けて保存 |
| 記録一覧 | 散歩記録の検索・フィルタ・ページネーション |
| 記録詳細 | ルートとスポットを地図上で確認 |
| プロフィール | ユーザー情報・統計・設定 |

## フォルダ構成

```
lib/
├── main.dart
├── app.dart                      # MaterialApp・ルーター・テーマ設定
├── core/                         # アプリ全体の共通基盤
│   ├── constants/                # 色・サイズ・文字列定数
│   ├── errors/                   # カスタム例外クラス
│   ├── firebase/                 # Firebase初期化・設定
│   ├── models/                   # 共有データモデル（WalkSession, Spot, AppUser）
│   ├── providers/                # Riverpod: リポジトリ注入スイッチ
│   ├── services/                 # LocationService / IAuthService / IStorageService
│   ├── theme/                    # アプリ共通テーマ
│   └── widgets/                  # 共通UIコンポーネント
├── features/
│   ├── auth/                     # サインイン・サインアップ
│   │   ├── data/repositories/
│   │   ├── domain/repositories/  # IAuthRepository
│   │   └── presentation/
│   ├── map/                      # メイン地図画面
│   │   ├── data/repositories/
│   │   ├── domain/repositories/
│   │   └── presentation/
│   ├── walk/                     # 散歩セッション + スポット記録
│   │   ├── data/repositories/
│   │   ├── domain/repositories/  # IWalkSessionRepository, ISpotRepository
│   │   └── presentation/
│   │       ├── session/          # セッション中画面
│   │       └── spot/             # スポット記録画面
│   ├── record/                   # 記録一覧・詳細
│   │   ├── data/repositories/
│   │   ├── domain/repositories/
│   │   └── presentation/
│   │       ├── list/
│   │       └── detail/
│   └── profile/                  # プロフィール・統計
│       ├── data/repositories/
│       ├── domain/repositories/
│       └── presentation/
└── l10n/                         # 多言語対応（将来）
```

### 設計方針

- **Feature-first + Clean Architecture**: 各 feature を `data / domain / presentation` の3層で構成
- **Repository インターフェース**: `domain/repositories/` に抽象クラスを定義し、Firebase / バックエンドAPIの差し替えを `core/providers/` の1ファイルで完結させる
- **Firestore直接接続**: 現状は Firebase SDK を直接使用。Security Rules で認証・アクセス制御を担保
- **クロスfeature共有モデル**: `core/models/` に集約し、feature 間の依存を排除

## セットアップ

### 必要なツール

- Flutter SDK
- Firebase CLI（`npm install -g firebase-tools`）
- FlutterFire CLI（`dart pub global activate flutterfire_cli`）

### 初回セットアップ

```bash
# 依存パッケージのインストール
flutter pub get

# Firebase プロジェクトの設定ファイルを生成
# ※ google-services.json / GoogleService-Info.plist / firebase_options.dart は .gitignore されているため要実行
flutterfire configure

# Firebase CLI にログイン
firebase login
```

## Firebase デプロイ

### Security Rules のデプロイ

Firestore と Storage のセキュリティルールをクラウドに反映する。
ルールを変更したら必ずデプロイすること。

```bash
# Firestore のルールをデプロイ
firebase deploy --only firestore:rules

# Firebase Storage を有効化したら storage.rules も追加してデプロイ
# firebase.json の storage セクションを復活させてから実行
# firebase deploy --only storage
```

### Firebase App Check の有効化（本番リリース前）

App Check は「正規のアプリからのリクエストのみ通す」仕組み。
コードは既に対応済みのため、Firebase Console での設定が必要。

1. [Firebase Console](https://console.firebase.google.com) → プロジェクト選択
2. 左メニュー「App Check」→「アプリを登録」
3. Android：**Play Integrity** を選択
4. iOS：**App Attest** を選択
5. Cloud Firestore・Firebase Storage・Firebase Auth の App Check 適用を有効化

**開発中のデバッグトークン登録**

`kDebugMode` のときはデバッグプロバイダーが使われる。
初回実行時にコンソールに出力されるトークンを Console に登録すること。

1. アプリを実行して Xcode / Android Studio のログを確認
2. `AppCheckDebugProviderFactory: ...` のトークンをコピー
3. Firebase Console → App Check → 対象アプリ → 「デバッグトークンを管理」→ 追加

## 仕様書

詳細仕様は [docs/spec.md](docs/spec.md) を参照。  
基底クラス・インターフェース一覧は [docs/base_classes.md](docs/base_classes.md) を参照。