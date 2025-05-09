import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/theme/app_colors.dart';
import '../../core/utils/theme/app_text_styles.dart';

enum SnackBarType {
  success,
  error,
  warning,
  info,
}

class AppSnackBar {
  // Private constructor to prevent instantiation
  AppSnackBar._();

  // Snackbar duration settings
  static const Duration _shortDuration = Duration(seconds: 2);
  static const Duration _normalDuration = Duration(seconds: 3);
  static const Duration _longDuration = Duration(seconds: 5);

  // Default snackbar settings
  static const SnackPosition _defaultPosition = SnackPosition.BOTTOM;
  static const double _defaultMargin = 16.0;
  static const double _snackBarBorderRadius = 8.0;

  // Show a snackbar with custom options
  static void show({
    required String title,
    required String message,
    SnackBarType type = SnackBarType.info,
    SnackPosition position = _defaultPosition,
    Duration? duration,
    VoidCallback? onTap,
    String? actionLabel,
    VoidCallback? onActionTap,
    bool dismissible = true,
  }) {
    // Determine colors based on type
    final (backgroundColor, iconData, iconColor) = _getTypeAttributes(type);

    // Determine duration based on message length
    final messageDuration = duration ?? _getDurationByLength(message);

    // Create and show the snackbar
    Get.snackbar(
      title,
      message,
      snackPosition: position,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
      margin: const EdgeInsets.all(_defaultMargin),
      borderRadius: _snackBarBorderRadius,
      duration: messageDuration,
      isDismissible: dismissible,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutQuad,
      reverseAnimationCurve: Curves.easeInQuad,
      titleText: Text(
        title,
        style: AppTextStyles.bodyMedium.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      messageText: Text(
        message,
        style: AppTextStyles.bodyMedium.copyWith(
          color: Colors.white,
        ),
      ),
      icon: Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: Icon(
          iconData,
          color: iconColor,
          size: 24,
        ),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 12.0,
        horizontal: 16.0,
      ),
      mainButton: actionLabel != null && onActionTap != null
          ? TextButton(
              onPressed: () {
                Get.back(); // Close the snackbar
                onActionTap();
              },
              child: Text(
                actionLabel,
                style: AppTextStyles.buttonMedium.copyWith(
                  color: Colors.white,
                ),
              ),
            )
          : null,
      onTap: onTap != null
          ? (_) {
              onTap();
            }
          : null,
    );
  }

  // Helper method to show success snackbar
  static void success({
    String title = 'Success',
    required String message,
    SnackPosition position = _defaultPosition,
    Duration? duration,
    VoidCallback? onTap,
    String? actionLabel,
    VoidCallback? onActionTap,
  }) {
    show(
      title: title,
      message: message,
      type: SnackBarType.success,
      position: position,
      duration: duration,
      onTap: onTap,
      actionLabel: actionLabel,
      onActionTap: onActionTap,
    );
  }

  // Helper method to show error snackbar
  static void error({
    String title = 'Error',
    required String message,
    SnackPosition position = _defaultPosition,
    Duration? duration,
    VoidCallback? onTap,
    String? actionLabel,
    VoidCallback? onActionTap,
  }) {
    show(
      title: title,
      message: message,
      type: SnackBarType.error,
      position: position,
      duration: duration,
      onTap: onTap,
      actionLabel: actionLabel,
      onActionTap: onActionTap,
    );
  }

  // Helper method to show warning snackbar
  static void warning({
    String title = 'Warning',
    required String message,
    SnackPosition position = _defaultPosition,
    Duration? duration,
    VoidCallback? onTap,
    String? actionLabel,
    VoidCallback? onActionTap,
  }) {
    show(
      title: title,
      message: message,
      type: SnackBarType.warning,
      position: position,
      duration: duration,
      onTap: onTap,
      actionLabel: actionLabel,
      onActionTap: onActionTap,
    );
  }

  // Helper method to show info snackbar
  static void info({
    String title = 'Information',
    required String message,
    SnackPosition position = _defaultPosition,
    Duration? duration,
    VoidCallback? onTap,
    String? actionLabel,
    VoidCallback? onActionTap,
  }) {
    show(
      title: title,
      message: message,
      type: SnackBarType.info,
      position: position,
      duration: duration,
      onTap: onTap,
      actionLabel: actionLabel,
      onActionTap: onActionTap,
    );
  }

  // Get color, icon, and other attributes based on snackbar type
  static (Color, IconData, Color) _getTypeAttributes(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return (
          AppColors.success,
          Icons.check_circle,
          Colors.white,
        );
      case SnackBarType.error:
        return (
          AppColors.error,
          Icons.error,
          Colors.white,
        );
      case SnackBarType.warning:
        return (
          AppColors.warning,
          Icons.warning,
          Colors.white,
        );
      case SnackBarType.info:
        return (
          AppColors.info,
          Icons.info,
          Colors.white,
        );
    }
  }

  // Determine duration based on message length
  static Duration _getDurationByLength(String message) {
    if (message.length < 30) {
      return _shortDuration;
    } else if (message.length < 100) {
      return _normalDuration;
    } else {
      return _longDuration;
    }
  }
}
