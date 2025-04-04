import 'package:dandang_gula/app/config/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../config/theme/app_colors.dart';

enum ButtonVariant { primary, secondary, outline, text }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final double height;
  final ButtonVariant variant;
  final String? prefixSvgPath;
  final String? suffixSvgPath;
  final bool isLoading;
  final bool fullWidth;
  final double? width;
  final Color? outlineBorderColor;
  final Color? customBackgroundColor;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.height = 40,
    this.variant = ButtonVariant.primary,
    this.prefixSvgPath,
    this.suffixSvgPath,
    this.isLoading = false,
    this.fullWidth = true,
    this.width,
    this.outlineBorderColor,
    this.customBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? (fullWidth ? double.infinity : 60),
      height: height,
      child: _buildButton(),
    );
  }

  Widget _buildButton() {
    switch (variant) {
      case ButtonVariant.primary:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: customBackgroundColor ?? const Color(0xFF136C3A),
            foregroundColor: Colors.white,
            padding: _getPadding(),
            textStyle: _getTextStyle(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            elevation: 0,
          ),
          child: _buildContent(),
        );
      case ButtonVariant.secondary:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: customBackgroundColor ?? AppColors.secondary,
            foregroundColor: Colors.white,
            padding: _getPadding(),
            textStyle: _getTextStyle(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            elevation: 0,
          ),
          child: _buildContent(),
        );
      case ButtonVariant.outline:
        return OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF111111),
            padding: _getPadding(),
            textStyle: _getTextStyle(),
            side: BorderSide(color: outlineBorderColor ?? const Color(0xFFEAEEF2)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            elevation: 0,
          ),
          child: _buildContent(),
        );
      case ButtonVariant.text:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            backgroundColor: customBackgroundColor,
            foregroundColor: const Color(0xFF111111),
            padding: _getPadding(),
            textStyle: _getTextStyle(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            elevation: 0,
          ),
          child: _buildContent(),
        );
    }
  }

  Widget _buildContent() {
    if (isLoading) {
      return const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 3,
        ),
      );
    }

    if (prefixSvgPath == null && suffixSvgPath == null) {
      return Text(
        label,
        style: _getTextStyle(),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (prefixSvgPath != null) ...[
          SizedBox(
            width: 24,
            height: 24,
            child: Center(
              child: SvgPicture.asset(
                prefixSvgPath!,
                width: 16,
                height: 16,
                colorFilter: ColorFilter.mode(
                  _getIconColor(),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
        ],
        Text(
          label,
          style: _getTextStyle(),
        ),
        if (suffixSvgPath != null) ...[
          const SizedBox(width: 6),
          SizedBox(
            width: 24,
            height: 24,
            child: Center(
              child: SvgPicture.asset(
                suffixSvgPath!,
                width: 16,
                height: 16,
                colorFilter: ColorFilter.mode(
                  _getIconColor(),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  EdgeInsetsGeometry _getPadding() {
    if (variant == ButtonVariant.primary || variant == ButtonVariant.secondary) {
      if (prefixSvgPath != null && suffixSvgPath == null) {
        return const EdgeInsets.fromLTRB(14, 8, 22, 8);
      } else if (prefixSvgPath == null && suffixSvgPath != null) {
        return const EdgeInsets.fromLTRB(22, 8, 14, 8);
      } else if (prefixSvgPath != null && suffixSvgPath != null) {
        return const EdgeInsets.fromLTRB(14, 8, 14, 8);
      } else {
        return const EdgeInsets.fromLTRB(22, 8, 22, 8);
      }
    } else {
      return const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 8,
      );
    }
  }

  // Get consistent color for both text and icons
  Color _getTextColor() {
    if (variant == ButtonVariant.primary || variant == ButtonVariant.secondary) {
      return Colors.white;
    }

    if (variant == ButtonVariant.outline && outlineBorderColor != null) {
      return outlineBorderColor!;
    }

    return const Color(0xFF111111);
  }

  // Use the same color logic for icons
  Color _getIconColor() {
    return _getTextColor();
  }

  TextStyle _getTextStyle() {
    return AppTextStyles.contentLabel.copyWith(
      fontSize: 14,
      letterSpacing: -0.56,
      height: 16 / 14,
      color: _getTextColor(),
    );
  }
}
