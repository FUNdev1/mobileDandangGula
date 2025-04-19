import 'package:dandang_gula/app/global_widgets/input/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/theme/app_dimensions.dart';
import '../../../../core/utils.dart';
import '../../../../global_widgets/buttons/app_button.dart';
import '../../../../global_widgets/buttons/app_pagination.dart';
import '../../../../global_widgets/input/app_dropdown_field.dart';
import '../../../../global_widgets/layout/app_layout.dart';
import '../../../../global_widgets/text/app_text.dart';
import '../component/page/menu_management_detail/menu_management_detail_view.dart';
import '../controllers/menu_management_controller.dart';

class MenuManagementView extends GetView<MenuManagementController> {
  const MenuManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final refreshKey = args['refreshKey'] ?? 0;

    return AppLayout(
      key: ValueKey('stock_management_$refreshKey'),
      content: _buildContent(),
      onRefresh: () async {
        controller.fetchData(firstTime: true);
      },
    );
  }

  Widget _buildContent() {
    return Container(
      color: Color(0xFFF4F4F4),
      padding: AppDimensions.contentPadding,
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildMenuSection(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppButton(
            width: 180,
            height: 40,
            label: 'Manajemen Kategori',
            suffixSvgPath: AppIcons.arrowRight,
            variant: ButtonVariant.outline,
            onPressed: controller.openManajemenKategori,
          ),
          AppButton(
            width: 163,
            height: 40,
            prefixSvgPath: AppIcons.add,
            label: 'Tambah Menu',
            onPressed: controller.openAddMenu,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildFilterSection(),
          const SizedBox(height: 16),
          _buildMenuTable(),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Row(
            children: [
              AppText(
                'Data Menu',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Obx(() => AppText('(${controller.roles.length} menu)')),
            ],
          ),
        ),
        Expanded(
          child: Obx(() {
            return AppDropdownField(
              selectedValue: controller.selectedCategory.value ?? "",
              displayKey: "category_name",
              items: controller.categories,
              onChanged: (value) {
                controller.selectedCategory.value = value;
                controller.loadRolesAndUsers();
              },
              hint: 'Semua Kategori',
            );
          }),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: AppTextField(
            hint: 'Cari Menu',
            controller: controller.searchController,
            onFocusChanged: (val) {
              if (val.isNotEmpty) {
                controller.searchMenu();
              }
            },
          ),
        ),
        const SizedBox(width: 9),
        AppButton(
          width: 54,
          height: 40,
          label: 'Cari',
          variant: ButtonVariant.outline,
          outlineBorderColor: const Color(0xFF88DE7B),
          onPressed: controller.searchMenu,
        ),
      ],
    );
  }

  Widget _buildMenuTable() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return Column(
        children: [
          if (controller.roles.isEmpty)
            AppText(
              "Tidak ada data menu",
            )
          else
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildTableHeader(),
                  ...controller.roles.map((menu) => _buildMenuRow(menu)),
                ],
              ),
            ),
          if (controller.roles.isNotEmpty) _buildPagination(),
        ],
      );
    });
  }

  Widget _buildTableHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          _buildSortableTableCell(
            'Tanggal Dibuat',
            'created_at',
            flex: 1,
            isHeader: true,
            isDate: true,
          ),
          _buildSortableTableCell(
            'Kategori',
            'category_name',
            flex: 1,
            isHeader: true,
          ),
          _buildSortableTableCell(
            'Nama Menu',
            'menu_name',
            flex: 2,
            isHeader: true,
          ),
          _buildSortableTableCell(
            'Harga Jual',
            'price',
            flex: 1,
            isHeader: true,
            isPrice: true,
          ),
          _buildTableCell('Bahan', flex: 3, isHeader: true),
          _buildTableCell('Action', flex: 1, isHeader: true, isCenter: true),
        ],
      ),
    );
  }

  Widget _buildSortableTableCell(
    String text,
    String sortKey, {
    int flex = 1,
    bool isHeader = false,
    bool isDate = false,
    bool isPrice = false,
    bool isCenter = false,
  }) {
    return Expanded(
      flex: flex,
      child: InkWell(
        onTap: () => controller.sortBy(sortKey),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: isCenter || isPrice ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              Text(
                text,
                style: TextStyle(
                  fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                  color: isHeader ? Colors.black87 : Colors.black,
                ),
              ),
              Obx(() {
                if (controller.sortColumn.value == sortKey) {
                  return Icon(
                    controller.sortAscending.value ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 16,
                    color: Colors.grey.shade700,
                  );
                }
                return const SizedBox.shrink();
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuRow(dynamic menu) {
    List<Widget> ingredientChips = [];

    // Create ingredient chips for display
    if (menu['ingredients'] != null && menu['ingredients'] is List) {
      for (var ingredient in menu['ingredients']) {
        if (ingredient is Map) {
          ingredientChips.add(
            Container(
              margin: const EdgeInsets.only(right: 4, bottom: 4),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '${ingredient['name']} ${ingredient['amount']} ${ingredient['uom']}',
                style: const TextStyle(fontSize: 12),
              ),
            ),
          );
        } else {
          ingredientChips.add(
            Container(
              margin: const EdgeInsets.only(right: 4, bottom: 4),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                '$ingredient',
                style: const TextStyle(fontSize: 12),
              ),
            ),
          );
        }
      }
    }

    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          _buildTableCell(menu['created_at'] ?? '-', flex: 1, isDate: true),
          _buildTableCell(menu['category_name'] ?? '-', flex: 1),
          _buildTableCell(menu['menu_name'] ?? '-', flex: 2),
          _buildTableCell('Rp ${menu['price'] != null ? menu['price'].toString() : '-'}', flex: 1, isPrice: true),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Wrap(
                children: ingredientChips,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: AppButton(
                label: "Lihat Detail",
                variant: ButtonVariant.outline,
                suffixSvgPath: AppIcons.caretRight,
                onPressed: () => controller.openMenuDetail(menu['id']),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableCell(
    String text, {
    int flex = 1,
    bool isHeader = false,
    bool isDate = false,
    bool isPrice = false,
    bool isCenter = false,
  }) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
            color: isHeader ? Colors.black87 : Colors.black,
          ),
          textAlign: isCenter || isPrice ? TextAlign.center : TextAlign.left,
        ),
      ),
    );
  }

  Widget _buildPagination() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppPagination(
            currentPage: controller.currentPage.value,
            totalPages: controller.totalPages.value,
            onPageChanged: controller.goToPage,
          ),
        ],
      ),
    );
  }

  void _showMenuDetailDialog(dynamic menu) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: MenuDetailDialog(menu: menu),
      ),
    );
  }
}
