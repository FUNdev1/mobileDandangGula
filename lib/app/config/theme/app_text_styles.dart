import 'package:flutter/material.dart';
import '../../core/utils.dart';
import '../constant/app_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Heading styles
  static final TextStyle h1 = FontUtils.getFont(
    font: AppFont.sfProDisplay,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static final TextStyle h2 = FontUtils.getFont(
    font: AppFont.sfProDisplay,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static final TextStyle h3 = FontUtils.getFont(
    font: AppFont.sfProDisplay,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static final TextStyle h4 = FontUtils.getFont(
    font: AppFont.sfProDisplay,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Body styles
  static final TextStyle bodyLarge = FontUtils.getFont(
    font: AppFont.ibmPlexSans,
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static final TextStyle bodyMedium = FontUtils.getFont(
    font: AppFont.ibmPlexSans,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static final TextStyle bodySmall = FontUtils.getFont(
    font: AppFont.ibmPlexSans,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  // Button styles
  static final TextStyle buttonLarge = FontUtils.getFont(
    font: AppFont.inter,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle buttonMedium = FontUtils.getFont(
    font: AppFont.roboto,
    fontSize: 15,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle buttonSmall = FontUtils.getFont(
    font: AppFont.inter,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  // Label styles
  static final TextStyle labelLarge = FontUtils.getFont(
    font: AppFont.ibmPlexSans,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static final TextStyle labelMedium = FontUtils.getFont(
    font: AppFont.ibmPlexSans,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static final TextStyle labelSmall = FontUtils.getFont(
    font: AppFont.ibmPlexSans,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // Input styles
  static final TextStyle inputText = FontUtils.getFont(
    font: AppFont.roboto,
    fontSize: 15,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static final TextStyle inputHint = FontUtils.getFont(
    font: AppFont.roboto,
    fontSize: 15,
    fontWeight: FontWeight.normal,
    color: AppColors.textTertiary,
  );

  static final TextStyle inputLabel = FontUtils.getFont(
    font: AppFont.ibmPlexSans,
    fontSize: 11,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    letterSpacing: 0.3,
  );

  static final TextStyle contentLabel = FontUtils.getFont(
    font: AppFont.workSans,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 16.42 / 14,
    letterSpacing: -0.04 * 14,
  );

  // Code styles
  static final TextStyle codeText = FontUtils.getFont(
    font: AppFont.ibmPlexMono,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  // Card Styles
  static final TextStyle cardLabel = FontUtils.getFont(
    font: AppFont.inter,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 16.94 / 14,
    letterSpacing: 0,
  );
}
