import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    super.key,
    required this.icon,
    required this.size,
    required this.onPressed,
    this.color = AppColors.primary,
  });

  final IconData icon;
  final double size;
  final VoidCallback onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      shape: const CircleBorder(),
      elevation: 4,
      shadowColor: Colors.black26,
      child: InkWell(
        customBorder: const CircleBorder(),
        splashColor: AppColors.splashWhite,
        highlightColor: AppColors.highlightWhite,
        onTap: onPressed,
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(icon, color: AppColors.onPrimary, size: size * 0.6),
        ),
      ),
    );
  }
}
