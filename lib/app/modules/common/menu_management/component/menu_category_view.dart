import 'package:dandang_gula/app/global_widgets/input/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../core/utils.dart';
import '../../../../global_widgets/alert/app_snackbar.dart';
import '../controllers/menu_management_controller.dart';

class MenuCategoryView extends StatelessWidget {
  final MenuManagementController controller = Get.find<MenuManagementController>();
  final TextEditingController nameController = TextEditingController();
  final RxString selectedCategoryId = RxString('');
  final RxBool isAddingNew = RxBool(true);

  MenuCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Manajemen Kategori Menu',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: SvgPicture.asset(
            AppIcons.close,
            width: 20,
            height: 20,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: Row(
        children: [
          // Left side - Form
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Add/Edit Category section
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Obx(() => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isAddingNew.value ? 'Tambahkan Kategori' : 'Edit Kategori',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Name input field
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'Nama Kategori',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const Text(
                                    ' *',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              AppTextField(
                                controller: nameController,
                                hint: 'Masukkan nama kategori',
                                onFocusChanged: (value) {
                                  if (value.isNotEmpty) {
                                    nameController.text = value;
                                  }
                                },
                              ),
                              const SizedBox(height: 16),

                              // Action buttons
                              Row(
                                children: [
                                  // Add/Update button
                                  Expanded(
                                    child: SizedBox(
                                      height: 40,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          if (nameController.text.isEmpty) {
                                            AppSnackBar.error(message: 'Nama kategori tidak boleh kosong');
                                            return;
                                          }

                                          try {
                                            Map<String, dynamic> categoryData = {
                                              'category_name': nameController.text.trim(),
                                            };

                                            Map<String, dynamic> response;

                                            if (isAddingNew.value) {
                                              response = await controller.menuManagementRepository.createMenuCategory(nameController.text.trim());
                                            } else {
                                              response = await controller.menuManagementRepository.updateMenuCategory(selectedCategoryId.value, nameController.text.trim());
                                            }

                                            if (response['success'] == true) {
                                              AppSnackBar.success(message: response['message']);
                                              nameController.clear();
                                              isAddingNew.value = true;
                                              selectedCategoryId.value = '';
                                              controller.loadRolesAndUsers();
                                            } else {
                                              AppSnackBar.error(message: response['message'] ?? 'Terjadi kesalahan');
                                            }
                                          } catch (e) {
                                            AppSnackBar.error(message: isAddingNew.value ? 'Gagal menambahkan kategori' : 'Gagal memperbarui kategori');
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFFE3F1E9),
                                          foregroundColor: AppColors.primary,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                        ),
                                        child: Text(isAddingNew.value ? 'Tambahkan' : 'Perbarui'),
                                      ),
                                    ),
                                  ),

                                  // Cancel button (only show when editing)
                                  if (!isAddingNew.value) ...[
                                    const SizedBox(width: 8),
                                    SizedBox(
                                      height: 40,
                                      child: OutlinedButton(
                                        onPressed: () {
                                          nameController.clear();
                                          isAddingNew.value = true;
                                          selectedCategoryId.value = '';
                                        },
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: Colors.black87,
                                          side: const BorderSide(color: Color(0xFFE0E0E0)),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                        ),
                                        child: const Text('Batal'),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ],
                      )),
                ),
              ],
            ),
          ),
          // Divider
          Container(
            width: 1,
            color: AppColors.grey.withOpacity(0.3),
          ),

          // Right side - List
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Kategori',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // List of categories
                  Expanded(
                    child: Obx(() {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: controller.categories.length,
                        itemBuilder: (context, index) {
                          final category = controller.categories[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.grey.withOpacity(0.3)),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: ListTile(
                              title: Text(
                                category['category_name'] ?? '',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Edit button
                                  IconButton(
                                    icon: SvgPicture.asset(
                                      AppIcons.edit,
                                      width: 18,
                                      height: 18,
                                    ),
                                    onPressed: () {
                                      // Set edit mode for this item only
                                      nameController.text = category['category_name'] ?? '';
                                      selectedCategoryId.value = category['id'] ?? '';
                                      isAddingNew.value = false;
                                    },
                                  ),
                                  // Delete button
                                  IconButton(
                                    icon: SvgPicture.asset(
                                      AppIcons.delete,
                                      width: 18,
                                      height: 18,
                                      colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn),
                                    ),
                                    onPressed: () {
                                      _showDeleteCategoryConfirmation(context, category);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _showDeleteCategoryConfirmation(BuildContext context, dynamic category) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Container(
            width: 400,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with close icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Title
                const Text(
                  'Yakin ingin menghapus kategori?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),

                // Content
                const Text(
                  'Semua menu yang menggunakan kategori ini akan dihapus dari kategorinya.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 24),

                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Cancel Button
                    SizedBox(
                      height: 40,
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black87,
                          side: const BorderSide(color: Color(0xFFE0E0E0)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text('Batal'),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Confirm Button
                    SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          try {
                            final response = await controller.menuManagementRepository.deleteMenuCategory(category['id']);
                            if (response['success'] == true) {
                              AppSnackBar.success(message: response['message'] ?? 'Kategori berhasil dihapus');
                              controller.loadRolesAndUsers();
                            } else {
                              AppSnackBar.error(message: response['message'] ?? 'Gagal menghapus kategori');
                            }
                          } catch (e) {
                            AppSnackBar.error(message: 'Gagal menghapus kategori');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xFF1B9851),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text('Lanjutkan'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
} 