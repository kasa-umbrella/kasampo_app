import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/models/user_auth_state.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/register_screen.dart';
import 'features/auth/presentation/sign_in_screen.dart';
import 'features/auth/presentation/splash_screen.dart';
import 'features/auth/providers/auth_providers.dart';
import 'features/home/presentation/main_screen.dart';

// スプラッシュの最低表示時間（1.8秒）が経過したかどうか
final splashReadyProvider = StateProvider<bool>((ref) => false);

class _RouterNotifier extends ChangeNotifier {
  _RouterNotifier(Ref ref) {
    ref.listen<AsyncValue>(userAuthStateProvider, (_, _) => notifyListeners());
    ref.listen<bool>(splashReadyProvider, (_, _) => notifyListeners());
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = _RouterNotifier(ref);
  return GoRouter(
    initialLocation: '/',
    refreshListenable: notifier,
    redirect: (context, state) {
      final splashReady = ref.read(splashReadyProvider);
      final authValue = ref.read(userAuthStateProvider);
      final loc = state.matchedLocation;

      // スプラッシュ表示中 or auth 確認中はスプラッシュに留まる
      if (loc == '/' && (!splashReady || authValue.isLoading)) return null;

      final userState = authValue.valueOrNull ?? const UserAuthLoading();

      return switch (userState) {
        UserAuthLoading() => null,
        UserAuthUnauthenticated() => loc == '/sign-in' ? null : '/sign-in',
        UserAuthUnregistered() => loc == '/register' ? null : '/register',
        UserAuthRegistered() =>
          (loc == '/sign-in' || loc == '/register' || loc == '/') ? '/home' : null,
      };
    },
    routes: [
      GoRoute(path: '/', builder: (_, _) => const SplashScreen()),
      GoRoute(path: '/sign-in', builder: (_, _) => const SignInScreen()),
      GoRoute(path: '/register', builder: (_, _) => const RegisterScreen()),
      GoRoute(path: '/home', builder: (_, _) => const MainScreen()),
    ],
  );
});

class KasanpoApp extends ConsumerWidget {
  const KasanpoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'かさんぽ',
      theme: AppTheme.light,
      routerConfig: ref.watch(routerProvider),
      debugShowCheckedModeBanner: false,
    );
  }
}
