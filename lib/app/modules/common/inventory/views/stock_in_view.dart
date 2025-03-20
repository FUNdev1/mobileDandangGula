// lib/app/modules/common/inventory/views/stock_in_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../global_widgets/layout/app_layout.dart';
import '../../../../global_widgets/text/app_text.dart';
import '../controllers/inventory_controller.dart';
import 'stock_entry_form.dart';

class StockInView extends GetView<InventoryController> {
  const StockInView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      content: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Get.back(),
                ),
                const SizedBox(width: 8),
                AppText(
                  'Pencatatan Stok Masuk',
                  style: AppTextStyles.h3,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                child: Obx(() => StockEntryForm(
                      isLoading: controller.isSubmitting.value,
                      onSubmit: (data) => controller.submitStockEntry(data),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
