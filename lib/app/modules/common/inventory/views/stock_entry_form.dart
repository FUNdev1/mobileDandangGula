import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../global_widgets/buttons/app_button.dart';
import '../../../../global_widgets/input/app_text_field.dart';
import '../../../../global_widgets/layout/app_card.dart';
import '../../../../global_widgets/text/app_text.dart';

class StockEntryForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit;
  final bool isLoading;

  const StockEntryForm({
    super.key,
    required this.onSubmit,
    this.isLoading = false,
  });

  @override
  State<StockEntryForm> createState() => _StockEntryFormState();
}

class _StockEntryFormState extends State<StockEntryForm> {
  final nameController = TextEditingController();
  final quantityController = TextEditingController();
  final priceController = TextEditingController();
  final supplierController = TextEditingController();
  final notesController = TextEditingController();

  String selectedCategory = 'Protein';
  String selectedUnit = 'gram';

  final categories = [
    'Protein',
    'Sayuran',
    'Minuman',
    'Seafood',
    'Bumbu',
  ];

  final units = [
    'gram',
    'kilogram',
    'liter',
    'buah',
    'pack',
    'karton',
  ];

  @override
  void dispose() {
    nameController.dispose();
    quantityController.dispose();
    priceController.dispose();
    supplierController.dispose();
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
              'Form Pencatatan Stok Masuk',
              style: AppTextStyles.h3,
            ),
            const SizedBox(height: 24),

            // Item details
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Item name and category
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Item name
                      AppText(
                        'Nama Barang',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      AppTextField(
                        controller: nameController,
                        hint: 'Masukkan nama barang',
                      ),
                      const SizedBox(height: 16),

                      // Category
                      AppText(
                        'Kategori',
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
                            value: selectedCategory,
                            items: categories.map((category) {
                              return DropdownMenuItem<String>(
                                value: category,
                                child: AppText(category),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  selectedCategory = value;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                // Quantity and unit
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Quantity
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
                      const SizedBox(height: 16),

                      // Unit
                      AppText(
                        'Satuan',
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
                            value: selectedUnit,
                            items: units.map((unit) {
                              return DropdownMenuItem<String>(
                                value: unit,
                                child: AppText(unit),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  selectedUnit = value;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                // Price and supplier
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Price
                      AppText(
                        'Harga (Rp)',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      AppTextField(
                        controller: priceController,
                        hint: 'Masukkan harga',
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Supplier
                      AppText(
                        'Supplier',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      AppTextField(
                        controller: supplierController,
                        hint: 'Nama supplier',
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

            // Submit button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppButton(
                  label: 'Batal',
                  variant: ButtonVariant.outline,
                  onPressed: () {
                    // Clear form or go back
                    Get.back();
                  },
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
    // Validate form
    if (nameController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Nama barang harus diisi',
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

    if (priceController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Harga harus diisi',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
      return;
    }

    // Create data object
    final data = {
      'name': nameController.text,
      'category': selectedCategory,
      'quantity': int.parse(quantityController.text),
      'unit': selectedUnit,
      'price': int.parse(priceController.text),
      'supplier': supplierController.text,
      'notes': notesController.text,
      'date': DateTime.now().toIso8601String(),
    };

    // Submit form
    widget.onSubmit(data);
  }
}
