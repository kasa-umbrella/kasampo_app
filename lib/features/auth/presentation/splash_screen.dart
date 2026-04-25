import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Phase 1 で auth 状態を見てルーティングを分岐する
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) context.go('/sign-in');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),
            _Logo(),
            const Spacer(flex: 3),
            _Copyright(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Icon(
            Icons.directions_walk,
            size: 56,
            color: AppColors.onPrimary,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'かさんぽ',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            letterSpacing: 4,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          '散歩を、記録しよう',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}

class _Copyright extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Text(
      '© 2025 Kasahara',
      style: TextStyle(
        fontSize: 12,
        color: AppColors.textSecondary,
      ),
    );
  }
}