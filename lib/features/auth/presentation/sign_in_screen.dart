import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/snack_bar_helper.dart';
import '../../../core/widgets/buttons/google_sign_in_button.dart';
import '../providers/auth_providers.dart';

class SignInScreen extends ConsumerWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signInState = ref.watch(signInControllerProvider);

    ref.listen<AsyncValue<void>>(signInControllerProvider, (_, next) {
      if (next.hasError) {
        showErrorSnackBar(context, next.error.toString());
      }
    });

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        children: [
          Center(child: Image.asset('assets/images/app_logo.png', width: 260)),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 64),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GoogleSignInButton(
                    isLoading: signInState.isLoading,
                    onPressed: signInState.isLoading
                        ? null
                        : () => ref
                            .read(signInControllerProvider.notifier)
                            .signInWithGoogle(),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'copyright @kasatata',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
