import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../indicators/loading_indicator.dart';

enum AppButtonVariant { primary, outlined }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;

  static const _shape = StadiumBorder();
  static const _textStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  static const _minSize = Size.fromHeight(52);

  Widget get _child => isLoading
      ? const LoadingIndicator()
      : Text(label, style: _textStyle);

  VoidCallback? get _onPressed => isLoading ? null : onPressed;

  @override
  Widget build(BuildContext context) {
    return switch (variant) {
      AppButtonVariant.primary => FilledButton(
          onPressed: _onPressed,
          style: FilledButton.styleFrom(
            minimumSize: _minSize,
            shape: _shape,
          ),
          child: _child,
        ),
      AppButtonVariant.outlined => OutlinedButton(
          onPressed: _onPressed,
          style: OutlinedButton.styleFrom(
            minimumSize: _minSize,
            shape: _shape,
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary),
          ),
          child: _child,
        ),
    };
  }
}
