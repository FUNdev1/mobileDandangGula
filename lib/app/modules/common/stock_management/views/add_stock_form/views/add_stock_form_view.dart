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
import '../controllers/add_stock_form_controller.dart';

class AddStockForm extends GetView<AddStockController> {
  final bool isEdit;

  const AddStockForm({
    super.key,
    this.isEdit = false,
  });

  @override
  Widget build(BuildContext context) {
    final title = isEdit ? 'Edit Bahan' : 'Tambah Bahan Baru';

    return AppLayout(
      title: title,
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
                AppText(
                  title,
                  style: AppTextStyles.h2,
                ),
                const SizedBox(height: 24),

                // Name field
                AppTextField(
                  label: 'Nama Bahan',
                  controller: controller.nameController,
                  hint: 'Masukkan nama bahan',
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return 'Nama bahan tidak boleh kosong';
                  //   }
                  //   return null;
                  // },
                ),
                const SizedBox(height: 16),

                // Category dropdown
                _buildDropdownField(
                  label: 'Kategori',
                  value: controller.selectedCategory.value,
                  items: controller.categories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      controller.selectedCategory.value = value;
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Type dropdown
                _buildDropdownField(
                  label: 'Jenis Bahan',
                  value: controller.selectedType.value,
                  items: controller.types.map((type) {
                    return DropdownMenuItem<String>(
                      value: type['value'],
                      child: Text(type['label'] ?? ""),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      controller.selectedType.value = value;
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Unit field
                AppTextField(
                  label: 'Unit Pembelian',
                  controller: controller.unitController,
                  hint: 'contoh: Kg, Gram, Liter, dll',
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return 'Unit pembelian tidak boleh kosong';
                  //   }
                  //   return null;
                  // },
                ),
                const SizedBox(height: 16),

                // Current price field
                AppTextField(
                  label: 'Harga Saat Ini',
                  controller: controller.priceController,
                  hint: 'Rp 0',
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return 'Harga tidak boleh kosong';
                  //   }
                  //   return null;
                  // },
                ),
                const SizedBox(height: 16),

                // Current stock field
                AppTextField(
                  label: 'Stok Saat Ini',
                  controller: controller.stockController,
                  hint: '0',
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return 'Stok tidak boleh kosong';
                  //   }
                  //   return null;
                  // },
                ),
                const SizedBox(height: 16),

                // Minimum stock field
                AppTextField(
                  label: 'Stok Minimum',
                  controller: controller.minStockController,
                  hint: '0',
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return 'Stok minimum tidak boleh kosong';
                  //   }
                  //   return null;
                  // },
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
                          label: isEdit ? 'Simpan Perubahan' : 'Tambah Bahan',
                          variant: ButtonVariant.primary,
                          isLoading: controller.isLoading.value,
                          onPressed: () {
                            if (!controller.isLoading.value && controller.validateForm()) {
                              if (isEdit) {
                                controller.updateItem();
                              } else {
                                controller.saveItem();
                              }
                            }
                          },
                          width: 150,
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

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<DropdownMenuItem<String>> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Work Sans',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.56,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: AppDimensions.spacing8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFDFDFDF)),
            borderRadius: BorderRadius.circular(6),
            color: AppColors.white,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 15),
          height: 40,
          child: DropdownButtonFormField<String>(
            value: value,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            icon: const Icon(Icons.keyboard_arrow_down),
            style: AppTextStyles.contentLabel.copyWith(color: Colors.black, height: 1),
            onChanged: onChanged,
            items: items,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '$label tidak boleh kosong';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
