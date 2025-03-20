// lib/app/modules/common/inventory/views/stock_out_view.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../global_widgets/buttons/app_button.dart';
import '../../../../global_widgets/input/app_text_field.dart';
import '../../../../global_widgets/layout/app_card.dart';
import '../../../../global_widgets/layout/app_layout.dart';
import '../../../../global_widgets/text/app_text.dart';
import '../controllers/inventory_controller.dart';

class StockOutView extends GetView<InventoryController> {
  const StockOutView({Key? key}) : super(key: key);

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
                  'Pencatatan Stok Keluar',
                  style: AppTextStyles.h3,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                child: _StockOutForm(
                  isLoading: controller.isSubmittingOut.value,
                  onSubmit: (data) => controller.submitStockOut(data),
                  items: controller.inventoryItems,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StockOutForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit;
  final bool isLoading;
  final List<Map<String, dynamic>> items;

  const _StockOutForm({
    Key? key,
    required this.onSubmit,
    required this.isLoading,
    required this.items,
  }) : super(key: key);

  @override
  State<_StockOutForm> createState() => _StockOutFormState();
}

class _StockOutFormState extends State<_StockOutForm> {
  final quantityController = TextEditingController();
  final notesController = TextEditingController();

  String? selectedItemId;
  String selectedReason = 'Penggunaan';

  final reasons = [
    'Penggunaan',
    'Kadaluarsa',
    'Rusak',
    'Kesalahan Produksi',
    'Lain-lain',
  ];

  @override
  void dispose() {
    quantityController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              'Form Pencatatan Stok Keluar',
              style: AppTextStyles.h3,
            ),
            const SizedBox(height: 24),

            // Item selection
            AppText(
              'Pilih Bahan',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(6),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: const Text('Pilih bahan'),
                  value: selectedItemId,
                  items: widget.items.map((item) {
                    return DropdownMenuItem<String>(
                      value: item['id'].toString(),
                      child: Text('${item['name']} (${item['stock']} ${item['unit']})'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedItemId = value;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Quantity
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        'Jumlah',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      AppTextField(
                        controller: quantityController,
                        hint: 'Masukkan jumlah',
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                // Reason for stock out
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        'Alasan',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 48,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: selectedReason,
                            items: reasons.map((reason) {
                              return DropdownMenuItem<String>(
                                value: reason,
                                child: Text(reason),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  selectedReason = value;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Notes
            AppText(
              'Catatan',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(6),
              ),
              child: TextField(
                controller: notesController,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(12),
                  border: InputBorder.none,
                  hintText: 'Tambahkan catatan (opsional)',
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Submit buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppButton(
                  label: 'Batal',
                  variant: ButtonVariant.outline,
                  onPressed: () => Get.back(),
                  fullWidth: false,
                  width: 120,
                ),
                const SizedBox(width: 16),
                AppButton(
                  label: 'Simpan',
                  variant: ButtonVariant.primary,
                  isLoading: widget.isLoading,
                  onPressed: _submitForm,
                  fullWidth: false,
                  width: 120,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    // Form validation
    if (selectedItemId == null) {
      Get.snackbar(
        'Error',
        'Silakan pilih bahan terlebih dahulu',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
      return;
    }

    if (quantityController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Jumlah harus diisi',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
      return;
    }

    // Get selected item
    final selectedItem = widget.items.firstWhere(
      (item) => item['id'].toString() == selectedItemId,
      orElse: () => {},
    );

    if (selectedItem.isEmpty) {
      Get.snackbar(
        'Error',
        'Item tidak ditemukan',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
      return;
    }

    // Check if quantity exceeds available stock
    final availableStock = int.parse(selectedItem['stock'].toString());
    final requestedQuantity = int.parse(quantityController.text);

    if (requestedQuantity > availableStock) {
      Get.snackbar(
        'Error',
        'Jumlah melebihi stok yang tersedia',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
      return;
    }

    // Create data object
    final data = {
      'itemId': selectedItemId,
      'itemName': selectedItem['name'],
      'quantity': requestedQuantity,
      'unit': selectedItem['unit'],
      'reason': selectedReason,
      'notes': notesController.text,
      'date': DateTime.now().toIso8601String(),
    };

    // Submit the form
    widget.onSubmit(data);
  }
}
