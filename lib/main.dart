import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/firebase/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // firebase_options.dart が未生成の場合はコンソールにエラーを出して続行する
  // `flutterfire configure` を実行してから再ビルドすること
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('[Firebase] 未初期化: $e');
    debugPrint('[Firebase] `flutterfire configure` を実行してください');
  }

  runApp(const ProviderScope(child: KasanpoApp()));
}
