import 'package:dandang_gula/app/global_widgets/text/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import '../../core/utils/theme/app_colors.dart';
import '../../core/utils/theme/app_dimensions.dart';
import '../../core/utils/utils.dart';

enum AppTextFieldEnum { login, field }

class AppTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? errorText;
  final ValueChanged<String>? onFocusChanged;
  final VoidCallback? onTap;
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
    this.onFocusChanged,
    this.onTap,
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
  String? _lastValue;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
    _lastValue = widget.controller?.text;
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

      if (!_hasFocus && widget.onFocusChanged != null && widget.controller != null) {
        final currentValue = widget.controller!.text;
        if (currentValue != _lastValue) {
          widget.onFocusChanged!(currentValue);
          _lastValue = currentValue;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = !widget.enabled;

    // Add automatic input formatter for numeric input
    final List<TextInputFormatter> formatters = [
      ...?widget.inputFormatters,
      if (widget.keyboardType == TextInputType.number)
        FilteringTextInputFormatter.digitsOnly,
    ];

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
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: widget.errorText != null
                  ? Colors.red
                  : _hasFocus
                      ? AppColors.primary
                      : const Color(0xFFDFDFDF),
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
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
                  onTap: widget.onTap,
                  inputFormatters: formatters,
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
