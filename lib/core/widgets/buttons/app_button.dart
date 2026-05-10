import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../indicators/loading_indicator.dart';

enum AppButtonVariant { primary, outlined, danger }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.isExpanded = true,
    this.icon,
    this.foregroundColor,
    this.backgroundColor,
    this.borderColor,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final bool isExpanded;
  final Widget? icon;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final Color? borderColor;

  static const _shape = StadiumBorder();
  static const _textStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  static const _minSize = Size(0, 52);

  Widget get _child {
    if (isLoading) return const LoadingIndicator();
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon!,
          const SizedBox(width: 8),
          Text(label, style: _textStyle),
        ],
      );
    }
    return Text(label, style: _textStyle);
  }

  VoidCallback? get _onPressed => isLoading ? null : onPressed;

  @override
  Widget build(BuildContext context) {
    final button = switch (variant) {
      AppButtonVariant.primary => FilledButton(
          onPressed: _onPressed,
          style: FilledButton.styleFrom(
            minimumSize: _minSize,
            shape: _shape,
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
          ),
          child: _child,
        ),
      AppButtonVariant.outlined => OutlinedButton(
          onPressed: _onPressed,
          style: OutlinedButton.styleFrom(
            minimumSize: _minSize,
            shape: _shape,
            foregroundColor: foregroundColor ?? AppColors.primary,
            backgroundColor: backgroundColor,
            side: BorderSide(color: borderColor ?? foregroundColor ?? AppColors.primary),
          ),
          child: _child,
        ),
      AppButtonVariant.danger => FilledButton(
          onPressed: _onPressed,
          style: FilledButton.styleFrom(
            minimumSize: _minSize,
            shape: _shape,
            backgroundColor: backgroundColor ?? AppColors.error,
            foregroundColor: foregroundColor,
          ),
          child: _child,
        ),
    };
    if (!isExpanded) return button;
    return SizedBox(width: double.infinity, child: button);
  }
}
