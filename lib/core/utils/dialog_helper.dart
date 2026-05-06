import 'package:flutter/material.dart';
import '../widgets/buttons/app_button.dart';

class DialogAction {
  const DialogAction({
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
  });

  final String label;
  final VoidCallback onPressed;
  final AppButtonVariant variant;
}

Future<void> showAppDialog(
  BuildContext context, {
  required String title,
  required String content,
  required List<DialogAction> actions,
}) {
  return showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(content),
          const SizedBox(height: 24),
          for (final action in actions) ...[
            AppButton(
              label: action.label,
              variant: action.variant,
              onPressed: () {
                Navigator.of(ctx).pop();
                action.onPressed();
              },
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    ),
  );
}
