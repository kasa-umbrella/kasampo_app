import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../indicators/loading_indicator.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  final bool isLoading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 312,
      height: 52,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.onPrimary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: AppColors.onPrimary,
        ),
        child: isLoading
            ? const LoadingIndicator(size: 22, strokeWidth: 2.5)
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    'https://developers.google.com/identity/images/g-logo.png',
                    width: 20,
                    height: 20,
                    errorBuilder: (_, _, _) => const Icon(
                      Icons.login,
                      size: 20,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Googleでサインイン',
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
