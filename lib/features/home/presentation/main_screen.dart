import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../core/widgets/buttons/circle_icon_button.dart';
import '../../../core/widgets/navigation/bottom_nav_item.dart';
import '../../map/presentation/map_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const MapScreen(),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: CircleIconButton(
                  icon: Icons.settings,
                  size: AppDimens.circleButtonSize,
                  color: AppColors.settingGray,
                  onPressed: () {},
                ),
              ),
            ),
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
      floatingActionButton: CircleIconButton(
        icon: Icons.add,
        size: AppDimens.circleButtonSize,
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
