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
          _buildTableCell('Tanggal Dibuat', flex: 1, isHeader: true, isDate: true),
          _buildTableCell('Kategori', flex: 1, isHeader: true),
          _buildTableCell('Nama Menu', flex: 2, isHeader: true),
          _buildTableCell('Harga Jual', flex: 1, isHeader: true, isPrice: true),
          _buildTableCell('Bahan', flex: 3, isHeader: true),
          _buildTableCell('Action', flex: 1, isHeader: true, isCenter: true),
        ],
      ),
    );
  }

  Widget _buildMenuRow(dynamic menu) {
    List<Widget> ingredientChips = [];

    // Create ingredient chips for display
    if (menu['ingredients'] != null && menu['ingredients'] is List) {
      for (var ingredient in menu['ingredients']) {
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
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                  onPressed: () => _showMenuDetailDialog(menu),
                  icon: const Icon(Icons.visibility, color: Color(0xFF0D4927)),
                  label: const Text('Lihat Detail', style: TextStyle(color: Color(0xFF0D4927))),
                ),
              ],
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

class MenuDetailDialog extends StatelessWidget {
  final dynamic menu;

  const MenuDetailDialog({super.key, required this.menu});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 600,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Details Menu',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        menu['menu_name'] ?? 'Menu Name',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          menu['category_name'] ?? 'Category',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // Handle edit menu logic
                  Get.back();
                },
                icon: const Icon(Icons.edit),
                label: const Text('Edit Menu'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF0D4927),
                  side: const BorderSide(color: Color(0xFF0D4927)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          const Text(
            'Resep',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
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
                  child: Row(
                    children: const [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Nama Bahan',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Kebutuhan',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Harga',
                          textAlign: TextAlign.right,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                _buildIngredientsList(),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5F5F5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Biaya Bahan',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Rp ${menu['total_ingredient_cost'] ?? '0'}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildCostDetail('Biaya Produksi', menu['production_cost'] ?? 0),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildCostDetail('Biaya Overhead', menu['overhead_cost'] ?? 0),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildCostDetail('Persentase Keuntungan', menu['profit_percentage'] ?? 0, isPercentage: true),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildCostDetail('HPP', menu['hpp'] ?? 0),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F9FF),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFD0E1FF)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Harga Jual',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Rp ${menu['price'] ?? '0'}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Tutup'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientsList() {
    final ingredients = menu['ingredients'] ?? [];

    if (ingredients.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: Text('Tidak ada bahan')),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: ingredients.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final ingredient = ingredients[index];
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Text(ingredient['name'] ?? '-'),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getIngredientTypeColor(ingredient['type']),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        ingredient['type'] ?? 'Ingredient',
                        style: const TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Text('${ingredient['amount'] ?? '0'} ${ingredient['uom'] ?? ''}'),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  'Rp ${ingredient['price'] ?? '0'}',
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getIngredientTypeColor(String? type) {
    switch (type) {
      case 'Daging':
        return Colors.red.shade400;
      case 'Syrup':
        return Colors.green.shade400;
      case 'Seasoning':
        return Colors.orange.shade400;
      case 'Rice':
        return Colors.purple.shade400;
      default:
        return Colors.blue.shade400;
    }
  }

  Widget _buildCostDetail(String label, dynamic value, {bool isPercentage = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            isPercentage ? '$value%' : 'Rp $value',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isPercentage ? Colors.green.shade700 : Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
