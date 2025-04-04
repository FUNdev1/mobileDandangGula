import 'package:dandang_gula/app/global_widgets/text/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_dimensions.dart';

enum AppTextFieldEnum { login, field }

class AppTextField extends StatefulWidget {
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
  final String? prefixIcon;
  final String? suffixIcon;
  final VoidCallback? onPrefixIconTap;
  final VoidCallback? onSuffixIconTap;
  final AppTextFieldEnum appTextFieldEnum;
  final bool isMandatory;

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
    this.onPrefixIconTap,
    this.onSuffixIconTap,
    this.appTextFieldEnum = AppTextFieldEnum.field,
    this.isMandatory = false,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late FocusNode _focusNode;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    } else {
      _focusNode.removeListener(_onFocusChange);
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _hasFocus = _focusNode.hasFocus;
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    final isDisabled = !widget.enabled;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Row(
            children: [
              Text(
                widget.label!,
                style: TextStyle(
                  fontSize: 14,
                  color: isDisabled ? Color(0xFF8B8B8B) : Colors.black,
                ),
              ),
              if (widget.isMandatory)
                const Text(
                  ' *',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
        ],
        Container(
          height: 40,
          decoration: BoxDecoration(
            color: isDisabled ? Color(0xFFF5F5F5) : Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: widget.errorText != null
                  ? Colors.red
                  : _hasFocus
                      ? AppColors.primary
                      : const Color(0xFFDFDFDF),
              width: _hasFocus || widget.errorText != null ? 1.5 : 1,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Prefix Icon (if any)
              if (widget.prefixIcon != null)
                Positioned(
                  left: 10,
                  child: widget.prefixIcon!.contains("assets")
                      ? GestureDetector(
                          onTap: widget.enabled ? widget.onPrefixIconTap : null,
                          child: SvgPicture.asset(
                            widget.prefixIcon!,
                            height: 16,
                            width: 16,
                            color: isDisabled ? Color(0xFFB0B0B0) : Colors.black,
                          ),
                        )
                      : AppText(
                          widget.prefixIcon!,
                          style: TextStyle(
                            color: Color(0xFFB0B0B0),
                          ),
                        ),
                ),

              // TextField with adjusted padding
              Padding(
                padding: EdgeInsets.only(
                  left: widget.prefixIcon != null ? 36 : 10,
                  right: widget.suffixIcon != null ? 36 : 10,
                ),
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  obscureText: widget.obscureText,
                  keyboardType: widget.keyboardType,
                  readOnly: widget.readOnly,
                  enabled: widget.enabled,
                  onChanged: widget.onChanged,
                  onTap: widget.onTap,
                  onSubmitted: widget.onSubmitted,
                  inputFormatters: widget.inputFormatters,
                  style: TextStyle(
                    color: isDisabled ? Color(0xFF8B8B8B) : Colors.black,
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.hint,
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF8B8B8B),
                    ),
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    filled: false,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                  ),
                ),
              ),

              // Suffix Icon (if any)
              if (widget.suffixIcon != null)
                Positioned(
                  right: 10,
                  child: widget.suffixIcon!.contains("assets")
                      ? GestureDetector(
                          onTap: widget.enabled ? widget.onSuffixIconTap : null,
                          child: SvgPicture.asset(
                            widget.suffixIcon!,
                            height: 16,
                            width: 16,
                            color: isDisabled ? Color(0xFFB0B0B0) : Colors.black,
                          ))
                      : AppText(
                          widget.suffixIcon!,
                          style: TextStyle(
                            color: Color(0xFFB0B0B0),
                          ),
                        ),
                ),
            ],
          ),
        ),
        if (widget.errorText != null) ...[
          const SizedBox(height: 4),
          AppText(
            widget.errorText!,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
              letterSpacing: -0.48,
              color: Colors.red,
            ),
          ),
        ]
      ],
    );
  }
}
