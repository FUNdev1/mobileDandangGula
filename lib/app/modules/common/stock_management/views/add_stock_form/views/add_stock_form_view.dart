import 'package:dandang_gula/app/core/utils.dart';
import 'package:dandang_gula/app/global_widgets/input/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../../../config/theme/app_colors.dart';
import '../../../../../../config/theme/app_dimensions.dart';
import '../../../../../../config/theme/app_text_styles.dart';
import '../../../../../../global_widgets/buttons/app_button.dart';
import '../../../../../../global_widgets/input/app_dropdown_field.dart';
import '../../../../../../global_widgets/text/app_text.dart';
import '../../../data/models/inventory_item_model.dart';
import '../../ingredient_select/ingredient_select_view.dart';
import '../controllers/add_stock_form_controller.dart';

class AddStockForm extends GetView<AddStockController> {
  final bool isEdit;

  const AddStockForm({
    super.key,
    this.isEdit = false,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isRawMaterial = controller.selectedType.value == 'raw';
      final title = isEdit ? 'Edit Bahan' : 'Buat Stok bahan ${isRawMaterial ? 'dasar' : 'Setengah Jadi'}';
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          shadowColor: Colors.transparent,
          backgroundColor: Colors.white,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(2),
            child: Container(
              height: 2,
              color: AppColors.grey.withOpacity(0.2),
            ),
          ),
          title: AppText(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: SvgPicture.asset(
              AppIcons.close,
              width: 20,
              height: 20,
            ),
            onPressed: () => Get.back(closeOverlays: true),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Form(
              key: controller.formKey,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBasicInfoSection(isRawMaterial),
                  // Type-specific sections
                  if (isRawMaterial) _buildRawMaterialSection() else _buildSemiFinishedSection(context),
                  if (!isRawMaterial) _buildSemiFinishedResepBahan(context),
                ],
              ),
            ),
          ),
        ),
        // Action buttons
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          height: 79,
          decoration: BoxDecoration(border: Border(top: BorderSide(color: Color(0x8BEAEEF2), width: 1))),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppButton(
                label: 'Cancel',
                variant: ButtonVariant.outline,
                onPressed: () => Get.back(closeOverlays: true),
                width: 100,
                fullWidth: false,
              ),
              const SizedBox(width: 16),
              Obx(() {
                return AppButton(
                  label: isEdit ? 'Simpan Perubahan' : 'Create',
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
                );
              }),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildBasicInfoSection(bool isRawMaterial) {
    return Container(
      width: isRawMaterial ? 455 : 367,
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(Get.context!).size.height,
      ),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: Color(0xFFDFDFDF), width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 58,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerLeft,
            color: Color(0xFFF3F3F3),
            child: AppText(
              'Informasi Bahan',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(AppDimensions.cardPadding),
            color: Colors.white,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name field
                Obx(() {
                  return _buildInputField(
                    label: 'Nama Bahan',
                    hint: 'Tulis nama bahan...',
                    controller: controller.nameController,
                    errorText: controller.isNameError.value ? 'Nama bahan tidak boleh kosong' : null,
                    isRequired: true,
                    helperText: null,
                  );
                }),
                const SizedBox(height: 16),
                // Group/Category dropdown
                Obx(() {
                  return AppDropdownField(
                    label: 'Group',
                    hint: "Pilih Group",
                    isMandatory: true,
                    items: controller.categories.value,
                    selectedValue: controller.selectedCategoryFilter.value?["id"] ?? "",
                    displayKey: "group_name",
                    errorText: controller.isCategoryError.value ? 'Group tidak boleh kosong' : null,
                    valueKey: "id",
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        final selectedGroup = controller.categories.value.firstWhere((group) => group["id"] == newValue, orElse: () => {"id": newValue, "group_name": ""});
                        controller.selectedCategoryFilter.value = selectedGroup;
                      }
                    },
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRawMaterialSection() {
    return Expanded(
      flex: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            height: 58,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: Color(0xFFF3F3F3),
            ),
            child: AppText(
              'Konversi Unit',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          // Content Container
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Recipe Unit Section - Card 1
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFABABAB)),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppDropdownField(
                        label: 'Nama Unit Resep',
                        isMandatory: true,
                        hint: 'Cari unit...',
                        displayKey: "uom",
                        valueKey: "id",
                        items: controller.uomList,
                        errorText: controller.isRecipeUnitNameError.value ? 'UOM tidak boleh kosong' : null,
                        selectedValue: controller.selectedUom.value?["id"] ?? "",
                        onChanged: (val) {
                          if (val != null) {
                            // Find the full UOM map object by its ID
                            final selectedUomObject = controller.uomList.firstWhere((uom) => uom["id"] == val, orElse: () => {"id": val, "uom": ""});
                            controller.selectedUom.value = selectedUomObject;
                          }
                        },
                      ),
                      const SizedBox(height: 24),

                      // Conversion fields in row
                      Row(
                        children: [
                          Expanded(
                            child: _buildInputField(
                              label: 'Konversi',
                              controller: controller.conversionRateController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                              ],
                              errorText: controller.isConversionRateError.value ? 'Konversi tidak boleh kosong' : null,
                              isRequired: true,
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: _buildInputField(
                              enable: false,
                              label: 'Per UOM',
                              controller: TextEditingController(text: controller.selectedUomName),
                              isRequired: true,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Purchase Unit Section - Card 2
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFABABAB)),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInputField(
                        label: 'Nama Unit Pembelian',
                        hint: 'Cth: Karung, botol, kilogram',
                        controller: controller.purchaseUnitController,
                        errorText: controller.isPurchaseUnitError.value ? 'Unit pembelian tidak boleh kosong' : null,
                        isRequired: true,
                        helperText: 'Satuan unit yang dipakai untuk pembelian.',
                      ),

                      const SizedBox(height: 24),

                      // Conversion fields in row
                      Row(
                        children: [
                          Expanded(
                            child: _buildInputField(
                                label: 'Konversi',
                                hint: '100',
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                                ],
                                errorText: controller.isPurchaseConversionError.value ? 'Konversi tidak boleh kosong' : null,
                                isRequired: true,
                                controller: controller.purchaseConversionController),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: _buildInputField(
                              label: 'Per UOM',
                              isRequired: true,
                              enable: false,
                              controller: TextEditingController(text: controller.selectedUomName),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                _buildInputField(
                  label: 'Level Limit',
                  hint: 'Batas bawah stok',
                  controller: controller.minStockController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  suffixText: '${controller.selectedUom.value?["uom"] ?? ""}',
                  errorText: controller.isMinStockError.value ? 'Stok minimum tidak boleh kosong' : null,
                  isRequired: true,
                  helperText: 'Jika jumlah stok mencapai batas maka akan muncul peringatan stok akan habis.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSemiFinishedSection(BuildContext context) {
    return Container(
      width: 455,
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(Get.context!).size.height,
      ),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: Color(0xFFDFDFDF), width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 58,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerLeft,
            color: Color(0xFFF3F3F3),
            child: Text(
              'Konversi Unit',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Recipe Unit Section
                AppDropdownField(
                  label: 'Nama Unit Resep',
                  isMandatory: true,
                  hint: 'Cari unit...',
                  displayKey: "uom",
                  valueKey: "id",
                  items: controller.uomList,
                  errorText: controller.isRecipeUnitNameError.value ? 'UOM tidak boleh kosong' : null,
                  selectedValue: controller.selectedUom.value?["id"] ?? "",
                  onChanged: (val) {
                    if (val != null) {
                      // Find the full UOM map object by its ID
                      final selectedUomObject = controller.uomList.firstWhere((uom) => uom["id"] == val, orElse: () => {"id": val, "uom": ""});
                      controller.selectedUom.value = selectedUomObject;
                    }
                  },
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: _buildInputField(
                        enable: false,
                        label: 'Konversi',
                        controller: controller.conversionRateController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                        ],
                        errorText: controller.isConversionRateError.value ? 'Konversi tidak boleh kosong' : null,
                        isRequired: true,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 1,
                      child: _buildInputField(
                        label: 'Per UOM',
                        enable: false,
                        controller: TextEditingController(text: controller.selectedUomName),
                        isRequired: true,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Production Estimate
                _buildInputField(
                  label: 'Estimasi Produksi per Resep',
                  hint: '10000',
                  controller: controller.resultPerRecipeController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  errorText: controller.isResultPerRecipeError.value ? 'Estimasi produksi tidak boleh kosong' : null,
                  isRequired: true,
                  helperText: 'Jumlah',
                ),

                const SizedBox(height: 24),
                _buildInputField(
                  label: 'Level Limit',
                  hint: 'Batas bawah stok',
                  controller: controller.minStockController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  errorText: controller.isMinStockError.value ? 'Stok minimum tidak boleh kosong' : null,
                  isRequired: true,
                  suffixText: '${controller.selectedUom.value?["uom"] ?? ""}',
                  helperText: 'Jika jumlah stok mencapai batas maka akan muncul peringatan stok akan habis.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildSemiFinishedResepBahan(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Column(
        children: [
          Container(
            height: 58,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerLeft,
            color: Color(0xFFF3F3F3),
            child: AppText(
              'Resep Bahan',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(AppDimensions.cardPadding),
            color: Colors.white,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total HPP',
                      style: const TextStyle(
                        color: Color(0xFF303030),
                      ),
                    ),
                    Obx(() {
                      return Text(
                        'Rp${controller.totalCost.value.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Jumlah Bahan (${controller.ingredients.length})',
                      style: const TextStyle(
                        fontFamily: 'IBM Plex Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.3,
                        color: Color(0xFF303030),
                      ),
                    ),
                    SizedBox(
                      width: 120,
                      child: AppButton(
                        label: "Tambah",
                        variant: ButtonVariant.outline,
                        onPressed: () => _showAddIngredientDialog(),
                        prefixSvgPath: AppIcons.add,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Ingredients list
                Obx(() {
                  return Column(
                    children: controller.ingredients.map((ingredient) {
                      return _buildIngredientItem(context, ingredient);
                    }).toList(),
                  );
                }),

                // Show error message if ingredients is empty
                Obx(() {
                  if (controller.isIngredientsError.value) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: AppText(
                        'Tambahkan minimal satu bahan untuk resep',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.red,
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    String? hint,
    required TextEditingController controller,
    String? errorText,
    String? helperText,
    bool isRequired = false,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    bool enable = true,
    String? suffixText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          enabled: enable,
          label: label,
          controller: controller,
          hint: hint,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          isMandatory: isRequired,
          suffixIcon: suffixText,
        ),
        if (errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            errorText,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.red,
            ),
          ),
        ] else if (helperText != null) ...[
          const SizedBox(height: 4),
          Text(
            helperText,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.grey,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildIngredientItem(BuildContext context, RecipeIngredient ingredient) {
    final textController = TextEditingController(text: ingredient.amount?.toStringAsFixed(0).toString());
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  ingredient.name ?? 'Bahan',
                ),
                const SizedBox(height: 4),
                AppText(
                  'Rp${ingredient.price?.toStringAsFixed(0) ?? '0'}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF8B8B8B),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SizedBox(
              child: AppTextField(
                controller: textController,
                hint: "${ingredient.unit}",
              ),
            ),
          ),
          SizedBox(width: 16),
          Row(
            children: [
              InkWell(
                onTap: () => _showAddIngredientDialog(),
                child: Container(
                  width: 32,
                  height: 32,
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    AppIcons.edit,
                    width: 16,
                    height: 16,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Delete button
              Material(
                borderRadius: BorderRadius.circular(8),
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => controller.removeIngredient(ingredient.id),
                  child: Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.grey,
                        width: 1,
                      ),
                    ),
                    child: SvgPicture.asset(
                      AppIcons.trashCan,
                      width: 16,
                      height: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddIngredientDialog() {
    Get.to(() {
      return SelectIngredientPage(
        existingIngredients: controller.ingredients.toList(),
      );
    })?.then((result) {
      if (result != null && result is List<RecipeIngredient>) {
        // Clear existing ingredients first
        controller.ingredients.clear();

        // Add all selected ingredients
        for (var ingredient in result) {
          controller.addIngredient(ingredient);
        }
      }
    });
  }
}
