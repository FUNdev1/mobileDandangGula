import 'package:dandang_gula/app/config/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_dimensions.dart';

enum AppTextFieldEnum { login, field }

class AppTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final ValueChanged<String>? onSubmitted;
  final bool readOnly;
  final bool enabled;
  final List<TextInputFormatter>? inputFormatters;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconTap;
  final AppTextFieldEnum appTextFieldEnum;

  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.focusNode,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.errorText,
    this.onChanged,
    this.onTap,
    this.onSubmitted,
    this.readOnly = false,
    this.enabled = true,
    this.inputFormatters,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconTap,
    this.appTextFieldEnum = AppTextFieldEnum.field,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: const TextStyle(
              fontFamily: 'Work Sans',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.56,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: AppDimensions.spacing8),
        ],
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFDFDFDF)),
              borderRadius: BorderRadius.circular(6),
              color: appTextFieldEnum == AppTextFieldEnum.login
                  ? const Color(0xFFF5F4EF)
                  : enabled
                      ? AppColors.white
                      : const Color(0xFFF2F2F2)),
          alignment: Alignment.center,
          height: appTextFieldEnum == AppTextFieldEnum.field ? 40 : 48,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            obscureText: obscureText,
            keyboardType: keyboardType,
            readOnly: readOnly,
            enabled: enabled,
            onChanged: onChanged,
            onTap: onTap,
            onSubmitted: onSubmitted,
            inputFormatters: inputFormatters,
            style: AppTextStyles.contentLabel.copyWith(color: Colors.black, height: 1),
            decoration: InputDecoration(
              hintText: hint,
              errorText: errorText,
              hintStyle: AppTextStyles.contentLabel.copyWith(color: const Color(0xFF8B8B8B)),
              prefixIcon: prefixIcon != null
                  ? Icon(
                      prefixIcon,
                      size: 16,
                      color: Colors.black,
                    )
                  : null,
              suffixIconConstraints: const BoxConstraints(maxWidth: 16, maxHeight: 16),
              suffixIcon: suffixIcon != null
                  ? GestureDetector(
                      onTap: onSuffixIconTap,
                      child: Icon(
                        suffixIcon,
                        color: Colors.black,
                      ),
                    )
                  : null,
              // contentPadding: suffixIcon == null
              //     ? null
              //     : const EdgeInsets.symmetric(
              //         horizontal: 10,
              //         vertical: 7,
              //       ),
              disabledBorder: InputBorder.none,
              border: InputBorder.none,
              isDense: true,
              isCollapsed: false,
              filled: false,
            ),
          ),
        ),
      ],
    );
  }
}
