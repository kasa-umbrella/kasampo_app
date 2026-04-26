import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/sign_in_screen.dart';
import 'features/auth/presentation/splash_screen.dart';
import 'features/auth/providers/auth_providers.dart';
import 'features/map/presentation/map_screen.dart';

class _RouterNotifier extends ChangeNotifier {
  _RouterNotifier(Ref ref) {
    ref.listen<AsyncValue>(authStateProvider, (_, _) => notifyListeners());
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = _RouterNotifier(ref);
  return GoRouter(
    initialLocation: '/',
    refreshListenable: notifier,
    redirect: (context, state) {
      final authValue = ref.read(authStateProvider);
      if (authValue.isLoading) return null;

      final isLoggedIn = authValue.valueOrNull != null;
      final loc = state.matchedLocation;

      if (loc == '/') return null;
      if (!isLoggedIn && loc != '/sign-in') return '/sign-in';
      if (isLoggedIn && loc == '/sign-in') return '/home';
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (_, _) => const SplashScreen()),
      GoRoute(path: '/sign-in', builder: (_, _) => const SignInScreen()),
      GoRoute(path: '/home', builder: (_, _) => const MapScreen()),
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
