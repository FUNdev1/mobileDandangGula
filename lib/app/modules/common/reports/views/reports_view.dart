import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/theme/app_text_styles.dart';
import '../../../../global_widgets/layout/app_layout.dart';
import '../../../../global_widgets/text/app_text.dart';
import '../controllers/reports_controller.dart';

class ReportsView extends GetView<ReportsController> {
  const ReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      content: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              'Laporan',
              style: AppTextStyles.h3,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Center(
                child: Obx(() => controller.isLoading.value
                  ? const CircularProgressIndicator()
                  : const AppText('Konten Laporan')
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}