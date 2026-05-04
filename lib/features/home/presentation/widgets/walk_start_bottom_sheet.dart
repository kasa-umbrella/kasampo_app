import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/snack_bar_helper.dart';
import '../../../../core/widgets/sheets/app_bottom_sheet.dart';
import '../../../walk/providers/walk_session_notifier.dart';

class WalkStartBottomSheet extends ConsumerWidget {
  const WalkStartBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return AppBottomSheet.show(
      context,
      child: const WalkStartBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          '散歩を始める',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final ok = await ref.read(walkSessionProvider.notifier).start();
              if (!ok && context.mounted) {
                showErrorSnackBar(context, 'GPS情報を取得できませんでした');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              '開始',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
