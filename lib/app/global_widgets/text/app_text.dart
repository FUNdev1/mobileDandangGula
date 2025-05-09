import 'package:flutter/material.dart';

import '../../core/utils/theme/app_text_styles.dart';

class AppText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;

  const AppText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.overflow = TextOverflow.ellipsis,
    this.maxLines,
  });

  // Factory constructors untuk berbagai jenis teks
  factory AppText.heading1(String text, {TextAlign? textAlign, TextOverflow? overflow, int? maxLines}) {
    return AppText(
      text,
      style: AppTextStyles.h1,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }

  factory AppText.body(String text, {TextAlign? textAlign, TextOverflow? overflow, int? maxLines}) {
    return AppText(
      text,
      style: AppTextStyles.bodyMedium,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }

  factory AppText.code(String text, {TextAlign? textAlign, TextOverflow? overflow, int? maxLines}) {
    return AppText(
      text,
      style: AppTextStyles.codeText,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }
}
