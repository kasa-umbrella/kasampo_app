import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

enum SnackBarVariant { success, error }

void showSnackBar(
  BuildContext context,
  String message, {
  SnackBarVariant variant = SnackBarVariant.error,
  Duration duration = const Duration(seconds: 4),
}) {
  final backgroundColor = switch (variant) {
    SnackBarVariant.success => AppColors.success,
    SnackBarVariant.error => AppColors.error,
  };
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: AppColors.onPrimary),
      ),
      backgroundColor: backgroundColor,
      duration: duration,
    ),
  );
}
