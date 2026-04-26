import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // firebase_options.dart が未生成の場合はコンソールにエラーを出して続行する
  // `flutterfire configure` を実行してから再ビルドすること
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // App Check: デバッグ時はデバッグプロバイダー、本番は Play Integrity / App Attest を使用
    // 本番デプロイ前に Firebase Console で App Check を有効化すること
    await FirebaseAppCheck.instance.activate(
      androidProvider:
          kDebugMode ? AndroidProvider.debug : AndroidProvider.playIntegrity,
      appleProvider:
          kDebugMode ? AppleProvider.debug : AppleProvider.appAttest,
    );
  } catch (e) {
    debugPrint('[Firebase] 未初期化: $e');
    debugPrint('[Firebase] `flutterfire configure` を実行してください');
  }

  runApp(const ProviderScope(child: KasanpoApp()));
}
