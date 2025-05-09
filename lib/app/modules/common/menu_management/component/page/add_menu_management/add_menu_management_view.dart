import 'dart:io';
import 'package:dandang_gula/app/core/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../core/utils/utils.dart';
import '../../../../../../global_widgets/buttons/app_button.dart';
import '../../../../../../global_widgets/input/app_checkbox.dart';
import '../../../../../../global_widgets/input/app_dropdown_field.dart';
import '../../../../../../global_widgets/input/app_text_field.dart';
import '../../../../../../global_widgets/text/app_text.dart';
import '../../../controllers/menu_management_controller.dart';
import 'add_menu_management_controller.dart';

class AddMenuPage extends GetView<AddMenuController> {
  final MenuManagementController menuController;

  const AddMenuPage({
    super.key,
    required this.menuController,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(),
      body: _bodyContent(),
    );
  }

  Container _bodyContent() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Section
          Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildUploadSection(),
                  Container(
                    width: 1,
                    color: Colors.grey.shade300,
                  ),
                  _buildMenuDetails(),
                ],
              ),
            ),
          ),

          // Bottom Section
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(color: Colors.white),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildIngredientSelection(),
                    _buildRecipeSection(),
                    _buildPricingSection(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: Size(Get.width, 1),
        child: Container(
          height: 1,
          decoration: BoxDecoration(color: Color(0xFFE0E0E0)),
        ),
      ),
      title: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: SvgPicture.asset(
              AppIcons.close,
              width: 32,
              height: 32,
            ),
          ),
          const SizedBox(width: 8),
          Text('Tambah Menu'),
          const Spacer(),
          SizedBox(
            width: 124,
            child: AppButton(
              label: 'Simpan Menu',
              onPressed: controller.validateAndSave,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget _buildUploadSection() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              return Container(
                height: 144,
                width: 144,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: controller.selectedImage.value != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          controller.selectedImage.value!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image,
                            size: 36,
                            color: Colors.grey.shade400,
                          ),
                        ],
                      ),
              );
            }),
            const SizedBox(width: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Upload Foto Menu',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 280,
                    height: 36,
                    padding: const EdgeInsets.only(left: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Obx(() {
                            return Text(
                              controller.selectedImage.value != null ? controller.selectedImage.value!.path.split('/').last : 'Upload File',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            );
                          }),
                        ),
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Color(0xFFF4F4F5),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(5),
                              bottomRight: Radius.circular(5),
                            ),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              AppIcons.download,
                              width: 20,
                              height: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'File maksimal 1MB, ukuran file 1:1, Format PNG, JPG.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuDetails() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Obx(() => AppTextField(
                        label: 'Nama Menu',
                        isMandatory: true,
                        controller: controller.menuNameController,
                        hint: 'Masukan value',
                        onFocusChanged: (value) {
                          if (value.trim().isNotEmpty) {
                            controller.menuNameError.value = false;
                          }
                        },
                        errorText: controller.menuNameError.value ? 'Nama menu harus diisi' : null,
                      )),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Obx(() {
                    return AppDropdownField(
                      label: 'Kategori',
                      isMandatory: true,
                      hint: 'Pilih Kategori',
                      items: menuController.categories,
                      selectedValue: controller.selectedCategoryId.value ?? "",
                      displayKey: 'category_name',
                      onChanged: (value) {
                        controller.selectedCategoryId.value = value;
                        controller.categoryError.value = false;
                      },
                      errorText: controller.categoryError.value ? 'Kategori harus dipilih' : null,
                    );
                  }),
                ),
              ],
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: "Deskripsi Menu",
              controller: controller.descriptionController,
              hint: 'Deskripsi menu',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIngredientSelection() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border(right: BorderSide(color: Colors.grey.shade300)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pilih Bahan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              controller: controller.ingredientSearchController,
                              hint: 'Cari Bahan',
                              prefixIcon: AppIcons.search,
                              onFocusChanged: controller.searchIngredients,
                            ),
                          ),
                          if (controller.ingredientSearchController.text.isNotEmpty)
                            IconButton(
                              icon: Icon(Icons.close, size: 20, color: Colors.grey),
                              onPressed: () {
                                controller.ingredientSearchController.clear();
                                controller.searchIngredients('');
                              },
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Obx(() {
                if (controller.isLoadingIngredients.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.filteredIngredients.isEmpty) {
                  return const Center(child: Text('Tidak ada bahan'));
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.filteredIngredients.length,
                  separatorBuilder: (context, index) => Container(
                    height: 1,
                    color: Colors.grey.shade300,
                  ),
                  itemBuilder: (context, index) {
                    final ingredient = controller.filteredIngredients[index];

                    return Obx(() {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
                        child: AppCheckbox(
                          title: ingredient.name ?? 'Unnamed',
                          value: controller.selectedIngredients.any((i) => i.id == ingredient.id),
                          onChanged: (selected) {
                            if (selected == true) {
                              controller.addIngredient(ingredient);
                            } else {
                              if ((ingredient.id ?? "").isNotEmpty) {
                                controller.removeIngredient(ingredient.id!);
                              }
                            }
                          },
                        ),
                      );
                    });
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecipeSection() {
    return Expanded(
      flex: 3,
      child: Container(
        decoration: BoxDecoration(
          border: Border(right: BorderSide(color: Colors.grey.shade300)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Text(
                'Atur Resep',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Obx(() {
              if (controller.selectedIngredients.isEmpty) {
                return Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Pilih Bahan Terlebih dahulu.',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Bahan yang dipilih akan ditampilkan disini",
                        )
                      ],
                    ),
                  ),
                );
              }

              return Column(
                children: [
                  // Container(
                  //   padding: const EdgeInsets.all(12),
                  //   decoration: BoxDecoration(
                  //     color: Colors.grey.shade100,
                  //     borderRadius: const BorderRadius.only(
                  //       topLeft: Radius.circular(8),
                  //       topRight: Radius.circular(8),
                  //     ),
                  //   ),
                  //   child: Row(
                  //     children: [
                  //       Expanded(flex: 2, child: Text('Bahan', style: TextStyle(fontWeight: FontWeight.bold))),
                  //       Expanded(child: Text('Jumlah', style: TextStyle(fontWeight: FontWeight.bold))),
                  //       Expanded(child: Text('Gram', style: TextStyle(fontWeight: FontWeight.bold))),
                  //       Expanded(flex: 2, child: Text('Harga', style: TextStyle(fontWeight: FontWeight.bold))),
                  //       SizedBox(width: 40),
                  //     ],
                  //   ),
                  // ),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.selectedIngredients.length,
                    separatorBuilder: (context, index) => Container(
                      height: 1,
                      color: Colors.grey.shade300,
                    ),
                    itemBuilder: (context, index) {
                      final ingredient = controller.selectedIngredients[index];

                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                ingredient.name ?? 'Unnamed',
                                maxLines: 3,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: Obx(() {
                                  return AppTextField(
                                    controller: TextEditingController(text: ingredient.purchases?.toString() ?? ''),
                                    keyboardType: TextInputType.number,
                                    onFocusChanged: (value) {
                                      controller.updateIngredientPurchases((ingredient.id ?? ""), value);
                                    },
                                    errorText: controller.ingredientAmountErrors[ingredient.id] ?? false ? 'Jumlah harus lebih dari 0' : null,
                                    suffixIcon: "${ingredient.uom}",
                                  );
                                }),
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Obx(() {
                                      return AppTextField(
                                        prefixIcon: "Rp",
                                        controller: TextEditingController(text: ingredient.price?.toStringAsFixed(0) ?? ''),
                                        keyboardType: TextInputType.number,
                                        onFocusChanged: (value) {
                                          controller.updateIngredientPrice(ingredient.id ?? "", value);
                                        },
                                        errorText: controller.ingredientPriceErrors[ingredient.id] ?? false ? 'Harga harus lebih dari 0' : null,
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Material(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(8),
                                  onTap: () {
                                    controller.removeIngredient(ingredient.id ?? "");
                                  },
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
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildPricingSection() {
    return Expanded(
      flex: 2,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Rincian',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              // Total Biaya Bahan
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total Biaya Bahan'),
                  const SizedBox(height: 8),
                  Obx(() {
                    return Text(
                      CurrencyFormatter.formatRupiah(controller.totalIngredientCost.value.toDouble()),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }),
                  const SizedBox(height: 4),
                  Text(
                    'Total biaya bahan yang dipakai',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Biaya Produksi
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Biaya Produksi'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text('Rp'),
                      const SizedBox(width: 8),
                      Expanded(
                        child: AppTextField(
                          controller: controller.productionCostController,
                          keyboardType: TextInputType.number,
                          onFocusChanged: (_) => controller.calculateTotals(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tenaga Kerja',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // HPP

              Obx(() => AppTextField(
                    label: 'HPP',
                    controller: TextEditingController(text: controller.hpp.value.toString()),
                    keyboardType: TextInputType.number,
                    prefixIcon: "Rp",
                    onFocusChanged: (_) {
                      controller.calculateTotals();
                    },
                    enabled: false,
                  )),
              const SizedBox(height: 4),
              Text(
                'Total biaya bahan ditambah biaya produksi',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 16),
              // Harga Jual
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextField(
                    label: 'Harga Jual',
                    controller: controller.sellingPriceController,
                    keyboardType: TextInputType.number,
                    prefixIcon: "Rp",
                    onFocusChanged: (_) {
                      controller.calculateGrossMargin();
                    },
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Berikut harga jual yang didapat.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Gross Margin
              Text('Gross Margin'),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Rp'),
                        Text(
                          controller.grossMargin.value.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        controller.selectedImage.value = File(image.path);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memilih gambar: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
