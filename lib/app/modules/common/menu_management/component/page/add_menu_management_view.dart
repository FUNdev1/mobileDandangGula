import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/utils.dart';
import '../../../../../global_widgets/buttons/app_button.dart';
import '../../../../../global_widgets/input/app_dropdown_field.dart';
import '../../../../../global_widgets/input/app_text_field.dart';
import '../../../../../global_widgets/text/app_text.dart';
import '../../controllers/menu_management_controller.dart';
import 'add_menu_management_controller.dart';

class AddMenuDialog extends StatefulWidget {
  final MenuManagementController menuController;

  const AddMenuDialog({
    Key? key,
    required this.menuController,
  }) : super(key: key);

  @override
  State<AddMenuDialog> createState() => _AddMenuDialogState();
}

class _AddMenuDialogState extends State<AddMenuDialog> {
  final controller = Get.put(AddMenuController());

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          width: min(MediaQuery.of(context).size.width * 0.95, 1200.0),
          height: min(MediaQuery.of(context).size.height * 0.95, 800.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildUploadSection(),
                              const SizedBox(width: 24),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: AppTextField(
                                            label: 'Nama Menu',
                                            controller: controller.menuNameController,
                                            hint: 'Masukkan nama menu',
                                            isMandatory: true,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Obx(() => AppDropdownField(
                                                hint: 'Kategori',
                                                selectedValue: controller.selectedCategoryId.value ?? "",
                                                items: [
                                                  {'label': 'Pilih Kategori', 'value': ''},
                                                  ...widget.menuController.categories.map((category) {
                                                    return {
                                                      'label': category['category_name'] ?? 'Unnamed',
                                                      'value': category['id'] ?? '',
                                                    };
                                                  }),
                                                ],
                                                onChanged: (value) {
                                                  controller.selectedCategoryId.value = value;
                                                },
                                              )),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    AppTextField(
                                      label: 'Deskripsi Menu',
                                      controller: controller.descriptionController,
                                      hint: 'Deskripsi menu',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          const Divider(),
                          const SizedBox(height: 24),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: _buildIngredientsSection()),
                              const SizedBox(width: 24),
                              Expanded(child: _buildPricingSection()),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          AppText('Tambah Menu'),
          const Spacer(),
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadSection() {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText('Upload Foto Menu'),
          const SizedBox(height: 16),
          Obx(() => GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
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
                              size: 64,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            const Text('Upload File'),
                            const SizedBox(height: 8),
                            Text(
                              'File maksimal 1MB, ukuran file 1:1, Format PNG, JPG.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildIngredientsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText('Pilih Bahan'),
        const SizedBox(height: 16),
        AppTextField(
          prefixIcon: AppIcons.search,
          controller: controller.ingredientSearchController,
          hint: 'Cari Bahan',
          onChanged: controller.searchIngredients,
        ),
        const SizedBox(height: 16),
        Container(
          height: 300,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Obx(() {
            if (controller.isLoadingIngredients.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.filteredIngredients.isEmpty) {
              return const Center(child: Text('Tidak ada bahan'));
            }

            return ListView.builder(
              itemCount: controller.filteredIngredients.length,
              itemBuilder: (context, index) {
                final ingredient = controller.filteredIngredients[index];
                final isSelected = controller.selectedIngredients.any((i) => i['id'] == ingredient['id']);

                return CheckboxListTile(
                  title: Text(ingredient['name'] ?? 'Unnamed'),
                  subtitle: Text('Stok: ${ingredient['stock'] ?? 0} ${ingredient['uom'] ?? ''}'),
                  value: isSelected,
                  onChanged: (selected) {
                    if (selected == true) {
                      controller.addIngredient(ingredient);
                    } else {
                      controller.removeIngredient(ingredient['id']);
                    }
                  },
                );
              },
            );
          }),
        ),
        const SizedBox(height: 24),
        AppText('Atur Resep'),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Obx(() {
            if (controller.selectedIngredients.isEmpty) {
              return Container(
                height: 150,
                alignment: Alignment.center,
                child: const Text('Pilih Bahan Terlebih dahulu.'),
              );
            }

            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Expanded(flex: 3, child: Text('Bahan', style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(flex: 2, child: Text('Jumlah', style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(flex: 2, child: Text('Harga', style: TextStyle(fontWeight: FontWeight.bold))),
                      SizedBox(width: 40),
                    ],
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.selectedIngredients.length,
                  itemBuilder: (context, index) {
                    final ingredient = controller.selectedIngredients[index];
                    final amountController = TextEditingController(text: ingredient['amount']?.toString() ?? '');
                    final priceController = TextEditingController(text: ingredient['price']?.toString() ?? '');

                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border(top: BorderSide(color: Colors.grey.shade300)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(ingredient['name'] ?? 'Unnamed'),
                          ),
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: amountController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                      border: OutlineInputBorder(),
                                    ),
                                    onChanged: (value) {
                                      controller.updateIngredientAmount(ingredient['id'], value);
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(ingredient['uom'] ?? ''),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: [
                                const Text('Rp'),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    controller: priceController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                      border: OutlineInputBorder(),
                                    ),
                                    onChanged: (value) {
                                      controller.updateIngredientPrice(ingredient['id'], value);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => controller.removeIngredient(ingredient['id']),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            );
          }),
        ),
      ],
    );
  }

  Widget _buildPricingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText('Rincian'),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText('Total Biaya Bahan'),
              Obx(() => Text(
                    'Rp ${controller.totalIngredientCost.value}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  )),
              const SizedBox(height: 4),
              Text(
                'Total biaya bahan baku yang dipakai.',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        AppText('Biaya Produksi'),
        const SizedBox(height: 8),
        Row(
          children: [
            const Text('Rp'),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: controller.productionCostController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => controller.calculateTotals(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Tenaga Kerja',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 16),
        AppText('HPP'),
        const SizedBox(height: 8),
        Obx(() => Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Rp'),
                  Text(
                    controller.hpp.value.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            )),
        const SizedBox(height: 8),
        Text(
          'Total biaya bahan ditambah biaya produksi',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 16),
        AppText('Harga Jual'),
        const SizedBox(height: 8),
        Row(
          children: [
            const Text('Rp'),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: controller.sellingPriceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => controller.calculateGrossMargin(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Berikut harga jual yang didapat.',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText('Gross Margin'),
                  const SizedBox(height: 8),
                  Obx(() => Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Rp'),
                            Text(
                              controller.grossMargin.value.toString(),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText('Harga Jual + Pajak'),
                  const SizedBox(height: 8),
                  Obx(() => Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Rp'),
                            Text(
                              controller.priceWithTax.value.toString(),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AppButton(
            label: 'Batal',
            variant: ButtonVariant.secondary,
            onPressed: () => Get.back(),
          ),
          const SizedBox(width: 16),
          Obx(() => AppButton(
                label: 'Simpan Menu',
                isLoading: controller.isSaving.value,
                onPressed: controller.validateAndSave,
              )),
        ],
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
