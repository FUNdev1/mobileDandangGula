import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../global_widgets/input/app_password_field.dart';
import '../../../../global_widgets/input/app_text_field.dart';
import '../../../../global_widgets/text/app_text.dart';
import '../controllers/setting_controller.dart';

class ProfileTabPages extends StatelessWidget {
  const ProfileTabPages({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SettingController>();
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto
            _buildMenu(
              title: "Foto Kamu",
              subTitle: "Foto akan ditampilkan di profil",
              rightMenu: Container(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      height: 71,
                      width: 71,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                          alignment: Alignment.center,
                          child: AppText(
                            "Delete",
                            style: AppTextStyles.contentLabel,
                          ),
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                          alignment: Alignment.center,
                          child: AppText(
                            "Update",
                            style: AppTextStyles.contentLabel.copyWith(color: AppColors.info),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
        
            // Nama Lengkap
            _buildMenu(
              title: "Nama Lengkap",
              subTitle: "Nama Lengkap akan ditampilkan di profil",
              rightMenu: Container(
                padding: const EdgeInsets.all(10),
                child: const AppTextField(
                  hint: "Enter Nama Lengkap",
                ),
              ),
            ),
        
            // Username
            _buildMenu(
              title: "Username",
              subTitle: "Username akan ditampilkan di profil",
              rightMenu: Container(
                padding: const EdgeInsets.all(10),
                child: const AppTextField(
                  enabled: false,
                  hint: "Enter Username",
                ),
              ),
            ),
        
            // Password
            _buildMenu(
              title: "Password",
              subTitle: "Password akan ditampilkan di profil",
              rightMenu: Container(
                padding: const EdgeInsets.all(10),
                child: AppPasswordField(
                  controller: controller.passwordController,
                ),
              ),
            ),
        
            // Pin
            _buildMenu(
              title: "PIN",
              subTitle: "PIN akan ditampilkan di profil",
              rightMenu: Container(
                padding: const EdgeInsets.all(10),
                child: AppPasswordField(
                  controller: controller.pinController,
                  hint: "Enter PIN",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenu({
    required String title,
    required String subTitle,
    required Widget rightMenu,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.menuDivider),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Added to align items at the top
        children: [
          // This is where the issue might be happening - you were setting a fixed width
          // which can cause issues on different screen sizes
          Expanded(
            flex: 2, // Give it 2/3 of the available space
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    title,
                    style: AppTextStyles.contentLabel.copyWith(fontWeight: FontWeight.bold),
                  ),
                  AppText(
                    subTitle,
                    style: AppTextStyles.contentLabel,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 3, // Give it 1/3 of the available space
            child: rightMenu,
          ),
        ],
      ),
    );
  }
}
