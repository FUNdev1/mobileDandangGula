import 'package:flutter/material.dart';
import '../../config/theme/app_text_styles.dart';
import '../../config/theme/app_dimensions.dart';
import 'app_text_field.dart';

class AppPasswordField extends StatefulWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool enabled;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final ValueChanged<String>? onSubmitted;
  final AppTextFieldEnum appTextFieldEnum;

  const AppPasswordField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.focusNode,
    this.enabled = true,
    this.errorText,
    this.onChanged,
    this.onTap,
    this.onSubmitted,
    this.appTextFieldEnum = AppTextFieldEnum.field,
  });

  @override
  AppPasswordFieldState createState() => AppPasswordFieldState();
}

class AppPasswordFieldState extends State<AppPasswordField> {
  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
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
        TextField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          obscureText: _obscureText,
          enabled: widget.enabled,
          onChanged: widget.onChanged,
          onTap: widget.onTap,
          onSubmitted: widget.onSubmitted,
          style: AppTextStyles.contentLabel.copyWith(color: Colors.black),
          decoration: InputDecoration(
            hintText: widget.hint ?? 'Enter password',
            hintStyle: AppTextStyles.contentLabel.copyWith(color: const Color(0xFF8B8B8B)),
            suffixIconConstraints: const BoxConstraints(maxWidth: 16, maxHeight: 16),
            suffix: GestureDetector(
              onTap: _togglePasswordVisibility,
              child: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
                color: Colors.black,
                size: 16,
              ),
            ),
            border: InputBorder.none,
            isDense: true,
            isCollapsed: false,
            filled: false,
            // Removed errorText from here
          ),
        ),
        // Display error text below the text field container
        if (widget.errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            widget.errorText!,
            style: const TextStyle(
              fontFamily: 'Work Sans',
              fontSize: 12,
              fontWeight: FontWeight.normal,
              letterSpacing: -0.48,
              color: Colors.red,
            ),
          ),
        ],
      ],
    );
  }
}
