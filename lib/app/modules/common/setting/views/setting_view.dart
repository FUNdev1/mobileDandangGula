import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Add this import for number formatting
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/utils.dart';
import '../../../../global_widgets/buttons/app_button.dart';
import '../../../../global_widgets/text/app_text.dart';
import '../controllers/setting_controller.dart';
import '../pages/pengaturan_akun_tab_pages.dart';
import '../pages/profil_tab_pages.dart';
import '../widget/user_account_side_panel.dart';

class SettingView extends StatelessWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SettingController>();
    final NumberFormat currencyFormat = NumberFormat("#,##0.00", "en_US"); // Define the number format

    return ColoredBox(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            forceMaterialTransparency: true,
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Get.back(),
            ),
            title: Text(
              "Pengaturan",
              style: AppTextStyles.bodyMedium.copyWith(fontSize: 18),
            ),
            elevation: 0,
            backgroundColor: Colors.white,
          ),
          body: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Column(
              children: [
                // Tab selector
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                  margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6E6E6),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      _buildTabButton(controller, 1, "Profil"),
                      _buildTabButton(controller, 2, "Pengaturan Akun Pusat"),
                    ],
                  ),
                ),

                // Tab content
                Obx(() => controller.onSelectedTab.value == 1 ? const ProfileTabPages() : const PengaturanAkunTabPages()),
              ],
            ),
          ),
          bottomNavigationBar: Obx(() {
            if (controller.onSelectedTab.value == 1) {
              return Container(
                width: double.infinity,
                height: 79,
                padding: const EdgeInsets.symmetric(horizontal: 21),
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Color(0xFFEAEEF2)),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppButton(
                      height: 54,
                      width: 72,
                      label: 'Cancel',
                      variant: ButtonVariant.text,
                      onPressed: () {
                        Get.back();
                      },
                    ),
                    const SizedBox(width: 10),
                    AppButton(
                      label: 'Simpan',
                      height: 54,
                      width: 115,
                      prefixSvgPath: AppIcons.save,
                      variant: ButtonVariant.secondary,
                      onPressed: () {
                        // Implementasi save
                        Get.back();
                      },
                    ),
                  ],
                ),
              );
            }
            return const SizedBox();
          }),
        ),
      ),
    );
  }

  Widget _buildTabButton(SettingController controller, int index, String label) {
    return Obx(() {
      final isSelected = controller.onSelectedTab.value == index;

      return GestureDetector(
        onTap: () => controller.onSelectedTab.value = index,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 14),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : null,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected
                ? [
                    const BoxShadow(
                      color: Color.fromRGBO(152, 152, 152, 0.12),
                      blurRadius: 2,
                      offset: Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: AppTextStyles.contentLabel.copyWith(
              color: const Color(0xFF0C4123),
            ),
          ),
        ),
      );
    });
  }
}
