import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../../../config/theme/app_colors.dart';
import '../../../../../../config/theme/app_dimensions.dart';
import '../../../../../../config/theme/app_text_styles.dart';
import '../../../../../../global_widgets/buttons/app_button.dart';
import '../../../../../../global_widgets/input/app_text_field.dart';
import '../../../../../../global_widgets/layout/app_layout.dart';
import '../../../../../../global_widgets/text/app_text.dart';
import 'package:intl/intl.dart';

import '../../record_purchase_stock/controllers/record_purchase_stock_controller.dart';

class RecordPurchaseStockView extends GetView<RecordPurchaseStockController> {
  const RecordPurchaseStockView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Catat Pembelian Stok',
      showBackButton: true,
      content: SingleChildScrollView(
        padding: AppDimensions.contentPadding,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                AppText(
                  'Catat Pembelian Stok',
                  style: AppTextStyles.h2,
                ),
                const SizedBox(height: 24),

                // Item info section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const AppText(
                                  'Informasi Bahan',
                                  style: TextStyle(
                                    fontFamily: 'IBM Plex Sans',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                AppText(
                                  controller.item.name,
                                  style: AppTextStyles.h3,
                                ),
                                AppText(
                                  controller.item.category,
                                  style: AppTextStyles.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const AppText(
                                'Stok Saat Ini',
                                style: TextStyle(
                                  fontFamily: 'IBM Plex Sans',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              AppText(
                                '${controller.item.currentStock} ${controller.item.unit}',
                                style: AppTextStyles.h3,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Purchase date
                AppText(
                  'Tanggal Pembelian',
                  style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: controller.selectDate,
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFDFDFDF)),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(() => Text(
                              DateFormat('dd MMMM yyyy').format(controller.selectedDate.value),
                              style: AppTextStyles.bodyMedium,
                            )),
                        const Icon(Icons.calendar_today, size: 16),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Quantity field
                AppTextField(
                  label: 'Jumlah',
                  controller: controller.quantityController,
                  hint: '0',
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  suffixIcon: Icons.shopping_bag,
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return 'Jumlah tidak boleh kosong';
                  //   }
                  //   if (int.tryParse(value) == null || int.parse(value) <= 0) {
                  //     return 'Jumlah harus lebih dari 0';
                  //   }
                  //   return null;
                  // },
                ),
                const SizedBox(height: 8),
                // Unit info
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: AppText(
                    'dalam ${controller.item.unit}',
                    style: AppTextStyles.bodySmall,
                  ),
                ),
                const SizedBox(height: 16),

                // Price per unit field
                AppTextField(
                  label: 'Harga per ${controller.item.unit}',
                  controller: controller.priceController,
                  hint: 'Rp0',
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return 'Harga tidak boleh kosong';
                  //   }
                  //   if (int.tryParse(value) == null || int.parse(value) <= 0) {
                  //     return 'Harga harus lebih dari 0';
                  //   }
                  //   return null;
                  // },
                ),
                const SizedBox(height: 16),

                // Supplier field
                AppTextField(
                  label: 'Supplier',
                  controller: controller.supplierController,
                  hint: 'Nama supplier',
                ),
                const SizedBox(height: 16),

                // Notes field
                AppTextField(
                  label: 'Catatan',
                  controller: controller.notesController,
                  hint: 'Tambahkan catatan (opsional)',
                  // maxLines: 3,
                ),
                const SizedBox(height: 32),

                // Total section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const AppText(
                        'Total Harga',
                        style: TextStyle(
                          fontFamily: 'IBM Plex Sans',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Obx(() {
                        final quantity = int.tryParse(controller.quantityController.text) ?? 0;
                        final price = int.tryParse(controller.priceController.text) ?? 0;
                        final total = quantity * price;

                        return AppText(
                          'Rp ${NumberFormat('#,##0', 'id').format(total)}',
                          style: AppTextStyles.h3.copyWith(
                            color: AppColors.primary,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppButton(
                      label: 'Batal',
                      variant: ButtonVariant.outline,
                      onPressed: () => Get.back(),
                      width: 100,
                      fullWidth: false,
                    ),
                    const SizedBox(width: 16),
                    Obx(() => AppButton(
                          label: 'Simpan',
                          variant: ButtonVariant.primary,
                          isLoading: controller.isLoading.value,
                          onPressed: () {
                            if (!controller.isLoading.value && controller.validateForm()) {
                              controller.savePurchase();
                            }
                          },
                          width: 100,
                          fullWidth: false,
                        )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
