import 'package:flutter/material.dart';

import '../../core/utils/theme/app_colors.dart';
import '../../core/utils/theme/app_dimensions.dart';
import '../../core/utils/theme/app_text_styles.dart';
import '../text/app_text.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final String? title;
  final Widget? action;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppDimensions.cardPadding),
    this.title,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.cardBorderRadius),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null || action != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (title != null)
                    AppText(
                      title!,
                      style: AppTextStyles.h3,
                    ),
                  if (action != null) action!,
                ],
              ),
              const SizedBox(height: AppDimensions.spacing16),
            ],
            child,
          ],
        ),
      ),
    );
  }
}
