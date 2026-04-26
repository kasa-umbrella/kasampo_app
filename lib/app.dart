import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/splash_screen.dart';
import 'features/map/presentation/map_screen.dart';

// Phase 1 で auth 状態を見た redirect ロジックを追加する
final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/sign-in',
      builder: (context, state) => const Scaffold(
        body: Center(child: Text('サインイン画面 (Phase 1 で実装)')),
      ),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const MapScreen(),
    ),
  ],
);

class KasanpoApp extends StatelessWidget {
  const KasanpoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'かさんぽ',
      theme: AppTheme.light,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
