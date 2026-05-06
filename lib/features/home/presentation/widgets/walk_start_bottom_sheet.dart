import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_config.dart';
import '../../../../core/utils/dialog_helper.dart';
import '../../../../core/utils/snack_bar_helper.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/sheets/app_bottom_sheet.dart';
import '../../../walk/providers/walk_session_notifier.dart';

class WalkStartBottomSheet extends ConsumerWidget {
  const WalkStartBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return AppBottomSheet.show(context, child: const WalkStartBottomSheet());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'さあ、夢の世界で散歩しよう。',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 32),
        AppButton(
          label: '開始',
          onPressed: () async {
            Navigator.of(context).pop();
            final ok = await ref.read(walkSessionProvider.notifier).start();
            if (!ok && context.mounted) {
              final error = ref.read(walkSessionProvider).error;
              if (error == AppConfig.locationServiceDisabledError) {
                showAppDialog(
                  context,
                  title: '位置情報がオフです',
                  content: '散歩を記録するには、位置情報サービスをオンにしてください。',
                  actions: [
                    DialogAction(label: 'キャンセル', onPressed: () {}, variant: AppButtonVariant.outlined),
                    DialogAction(label: '設定を開く', onPressed: Geolocator.openLocationSettings),
                  ],
                );
              } else if (error == AppConfig.backgroundPermissionError) {
                showAppDialog(
                  context,
                  title: '位置情報の許可が必要です',
                  content: 'バックグラウンドでの散歩記録には、位置情報の許可を「常に許可」に変更してください。',
                  actions: [
                    DialogAction(label: 'キャンセル', onPressed: () {}, variant: AppButtonVariant.outlined),
                    DialogAction(label: '設定を開く', onPressed: Geolocator.openAppSettings),
                  ],
                );
              } else {
                showSnackBar(context, 'GPS情報を取得できませんでした');
              }
            }
          },
        ),
      ],
    );
  }
}
