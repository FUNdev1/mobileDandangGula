import 'dart:io';
import 'package:dandang_gula/app/global_widgets/input/app_dropdown_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/repositories/user_repository.dart';
import '../../../../global_widgets/buttons/app_button.dart';
import '../../../../global_widgets/input/app_password_field.dart';
import '../../../../global_widgets/input/app_switch_field.dart';
import '../../../../global_widgets/input/app_text_field.dart';
import '../controllers/setting_controller.dart';

abstract class UserFormController {
  // Properties
  Rxn<File?> get selectedImage;
  RxnString get selectedRoleId;
  RxList<Role> get roles;
  TextEditingController get nameController;
  TextEditingController get usernameController;
  TextEditingController get passwordController;
  TextEditingController get pinController;
  RxBool get isSubmitting;
  RxBool get isEditing;
  RxBool get isAccountActive;

  // Methods
  void closeUserForm();
  void submitUserForm({bool isActive});
}

class UserAccountSidePanel<T extends UserFormController> extends StatefulWidget {
  final T controller;

  const UserAccountSidePanel({super.key, required this.controller});

  @override
  State<UserAccountSidePanel> createState() => _UserAccountSidePanelState();
}

class _UserAccountSidePanelState extends State<UserAccountSidePanel> {
  File? selectedImage;
  String? selectedRole;
  bool isActive = true;

  @override
  void initState() {
    super.initState();
    selectedImage = widget.controller.selectedImage.value;
    isActive = widget.controller.isAccountActive.value;

    // Listen for changes in the selected image from controller
    ever(widget.controller.selectedImage, (image) {
      setState(() {
        selectedImage = image;
      });
    });

    // Listen for changes in the account active status
    ever(widget.controller.isAccountActive, (active) {
      setState(() {
        isActive = active;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      color: Colors.white,
      child: SizedBox(
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with close button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1),
                ),
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => widget.controller.closeUserForm(),
                    child: const Icon(Icons.close, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Obx(() => Text(
                        widget.controller.isEditing.value ? 'Edit Akun' : 'Buat Akun baru',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      )),
                ],
              ),
            ),

            // Form content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile picture section
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 93,
                            height: 93,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0D4927),
                              shape: BoxShape.circle,
                              image: selectedImage != null
                                  ? DecorationImage(
                                      image: FileImage(selectedImage!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: selectedImage == null
                                ? const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 60,
                                  )
                                : null,
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: GestureDetector(
                              onTap: _pickImage,
                              child: Container(
                                width: 24,
                                height: 24,
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: const Color(0xFFE0E0E0)),
                                ),
                                child: SvgPicture.asset(
                                  'assets/icons/edit.svg',
                                  width: 16,
                                  height: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Role selection field
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Text(
                              'Roles',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 4),
                            Text(
                              '*',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Obx(() {
                          final rolesList = (widget.controller.roles.value as List)
                              .map((role) => {
                                    "id": role.id,
                                    "role": role.role,
                                  })
                              .toList();
                          return AppDropdownField(
                            hint: "Pilih Role Akun",
                            items: (widget.controller.roles.value as List).cast<dynamic>(),
                            selectedValue: widget.controller.selectedRoleId.value ?? "",
                            valueKey: "id",
                            displayKey: "role",
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                widget.controller.selectedRoleId.value = newValue;
                              }
                            },
                          );
                        }),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Name field
                    AppTextField(
                      label: "Nama Lengkap",
                      isMandatory: true,
                      controller: widget.controller.nameController,
                      hint: 'Nama lengkap akun..',
                    ),
                    const SizedBox(height: 24),

                    // Username field
                    AppTextField(
                      label: "Username",
                      isMandatory: true,
                      controller: widget.controller.usernameController,
                      hint: 'Tulis username disini...',
                    ),
                    const SizedBox(height: 24),

                    // Password field
                    Obx(() => AppPasswordField(
                          label: "Password",

                          // isMandatory: !widget.controller.isEditing.value,
                          controller: widget.controller.passwordController,
                          hint: widget.controller.isEditing.value ? 'Kosongkan jika tidak diubah' : 'Tulis password akun..',
                        )),
                    const SizedBox(height: 24),

                    // PIN field
                    AppTextField(
                      label: "PIN",
                      isMandatory: true,
                      controller: widget.controller.pinController,
                      hint: 'Masukan 6 Digit angka',
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(6),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Account Status
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Status Akun',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        AppSwitch(
                          activeText: "Aktif",
                          inactiveText: "Nonaktif",
                          value: isActive,
                          onChanged: (value) {
                            setState(() {
                              isActive = value;
                            });
                            widget.controller.isAccountActive.value = value;
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 36),
                  ],
                ),
              ),
            ),

            // Bottom action buttons
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    offset: const Offset(0, -2),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: 'Cancel',
                      variant: ButtonVariant.outline,
                      onPressed: () => widget.controller.closeUserForm(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Obx(() {
                      return AppButton(
                        label: widget.controller.isEditing.value ? 'Update' : 'Create',
                        variant: ButtonVariant.primary,
                        isLoading: widget.controller.isSubmitting.value,
                        onPressed: () => widget.controller.submitUserForm(isActive: isActive),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _pickImage() async {
    // Show image picker options
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Ambil Foto'),
            onTap: () {
              Navigator.of(context).pop();
              _getImage(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Pilih dari Galeri'),
            onTap: () {
              Navigator.of(context).pop();
              _getImage(ImageSource.gallery);
            },
          ),
          if (selectedImage != null)
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Hapus Foto', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.of(context).pop();
                setState(() {
                  selectedImage = null;
                });
                widget.controller.selectedImage.value = null;
              },
            ),
        ],
      ),
    );
  }

  Future<void> _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source,
      imageQuality: 70,
      maxWidth: 500,
      maxHeight: 500,
    );

    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
      widget.controller.selectedImage.value = File(pickedFile.path);
    }
  }
}
