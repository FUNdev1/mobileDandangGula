import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/utils/theme/app_colors.dart';
import '../../core/utils/theme/app_dimensions.dart';

class AppIconButton extends StatelessWidget {
  final String icon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;
  final double? iconSize;
  final String? tooltip;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.size = 48,
    this.iconSize,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          surfaceTintColor: backgroundColor,
          backgroundColor: backgroundColor ?? Colors.transparent,
          shadowColor: backgroundColor ??Colors.transparent,
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            side: backgroundColor != null ? const BorderSide(color: Color(0xFFEAEEF2)) : BorderSide.none,
          ),
        ),
        child: SvgPicture.asset(
          icon,
          height: iconSize ?? AppDimensions.iconSizeMedium,
          colorFilter: ColorFilter.mode(
            iconColor ?? AppColors.textPrimary,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
