import 'package:dandang_gula/app/global_widgets/alert/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/repositories/menu_management_repository.dart';
import '../../../../global_widgets/buttons/app_button.dart';
import '../../../../global_widgets/input/app_text_field.dart';
import '../../../../global_widgets/text/app_text.dart';
import '../controllers/menu_management_controller.dart';

class CategoryManagementDialog extends StatelessWidget {
  final MenuManagementController controller;
  final TextEditingController categoryNameController = TextEditingController();

  CategoryManagementDialog({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 800,
        height: 600,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: _buildAddCategoryForm(),
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: 1,
                  child: _buildCategoryList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText('Manajemen Kategori'),
        IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }

  Widget _buildAddCategoryForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText('Tambahkan Kategori'),
        const SizedBox(height: 16),
        AppTextField(
          label: 'Input Field',
          controller: categoryNameController,
          hint: 'Masukan value',
          isMandatory: true,
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: AppButton(
            label: 'Tambahkan',
            onPressed: () {
              if (categoryNameController.text.isNotEmpty) {
                _addCategory(categoryNameController.text);
                categoryNameController.clear();
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText('Kategori'),
        const SizedBox(height: 16),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Obx(() {
              if (controller.categories.isEmpty) {
                return const Center(
                  child: Text('Belum ada kategori'),
                );
              }

              return ListView.separated(
                itemCount: controller.categories.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final category = controller.categories[index];
                  return _buildCategoryItem(category);
                },
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryItem(dynamic category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            category['category_name'] ?? 'Unnamed Category',
            style: const TextStyle(fontSize: 16),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () => _editCategory(category),
                icon: const Icon(Icons.edit, size: 20, color: Colors.grey),
              ),
              IconButton(
                onPressed: () => _deleteCategory(category['id']),
                icon: const Icon(Icons.delete, size: 20, color: Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _addCategory(String name) async {
    try {
      final repository = Get.find<MenuManagementRepositoryImpl>();
      final response = await repository.createMenuCategory(name);

      if (response['success'] == true) {
        controller.loadRolesAndUsers();
        AppSnackBar.success(message: response['message'] ?? 'Kategori berhasil ditambahkan');
      } else {
        AppSnackBar.error(message: response['message'] ?? 'Gagal menambahkan kategori');
      }
    } catch (e) {
      AppSnackBar.error(message: 'Gagal menambahkan kategori');
    }
  }

  void _editCategory(dynamic category) {
    final editController = TextEditingController(text: category['category_name']);

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText('Edit Kategori'),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Nama Kategori',
                controller: editController,
                hint: 'Masukan nama kategori',
                isMandatory: true,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppButton(
                    label: 'Batal',
                    variant: ButtonVariant.secondary,
                    onPressed: () => Get.back(),
                  ),
                  const SizedBox(width: 16),
                  AppButton(
                    label: 'Simpan',
                    onPressed: () {
                      if (editController.text.isNotEmpty) {
                        _updateCategory(category['id'], editController.text);
                        Get.back();
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateCategory(String id, String name) async {
    try {
      final repository = Get.find<MenuManagementRepositoryImpl>();
      final response = await repository.updateMenuCategory(
        id,
        name,
      );

      if (response['success'] == true) {
        controller.loadRolesAndUsers();
        Get.snackbar(
          'Success',
          'Kategori berhasil diperbarui',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Gagal memperbarui kategori',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _deleteCategory(String id) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.amber,
                size: 64,
              ),
              const SizedBox(height: 16),
              AppText('Hapus Kategori?'),
              const SizedBox(height: 8),
              const Text(
                'Kategori yang dihapus tidak dapat dikembalikan. Menu yang terkait kategori ini akan kehilangan kategorinya.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppButton(
                    label: 'Batal',
                    variant: ButtonVariant.secondary,
                    onPressed: () => Get.back(),
                  ),
                  const SizedBox(width: 16),
                  AppButton(
                    label: 'Hapus',
                    variant: ButtonVariant.outline,
                    outlineBorderColor: Colors.red,
                    onPressed: () {
                      _confirmDeleteCategory(id);
                      Get.back();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDeleteCategory(String id) async {
    try {
      final repository = Get.find<MenuManagementRepositoryImpl>();
      final response = await repository.deleteMenuCategory(id);

      if (response['success'] == true) {
        controller.loadRolesAndUsers();
        Get.snackbar(
          'Success',
          'Kategori berhasil dihapus',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Gagal menghapus kategori',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
