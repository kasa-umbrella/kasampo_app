import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../core/widgets/buttons/circle_icon_button.dart';
import '../../../core/widgets/navigation/bottom_nav_item.dart';
import '../../map/presentation/map_screen.dart';
import '../../walk/providers/walk_session_notifier.dart';
import 'widgets/walk_session_overlay.dart';
import 'widgets/walk_start_bottom_sheet.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSessionActive = ref.watch(
      walkSessionProvider.select((s) => s.isActive),
    );
    return Scaffold(
      body: Stack(
        children: [
          const MapScreen(),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: CircleIconButton(
                  icon: Icons.settings,
                  size: AppDimens.circleButtonSize,
                  color: AppColors.settingGray,
                  onPressed: () => context.push('/settings'),
                ),
              ),
            ),
          ),
          if (isSessionActive)
            const Align(
              alignment: Alignment.bottomCenter,
              child: WalkSessionOverlay(),
            ),
        ],
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Material(
          type: MaterialType.transparency,
          child: SafeArea(
            child: SizedBox(
              height: 60,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  BottomNavItem(
                    icon: Icons.emoji_events_outlined,
                    label: 'ランキング',
                    onTap: () {},
                  ),
                  BottomNavItem(
                    icon: Icons.history,
                    label: '過去の記録',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: isSessionActive
          ? null
          : CircleIconButton(
              icon: Icons.add,
              size: AppDimens.circleButtonSize,
              onPressed: () => WalkStartBottomSheet.show(context),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
