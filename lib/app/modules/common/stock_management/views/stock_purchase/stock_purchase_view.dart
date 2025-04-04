import 'package:dandang_gula/app/config/constant/app_constants.dart';
import 'package:dandang_gula/app/config/theme/app_colors.dart';
import 'package:dandang_gula/app/config/theme/app_dimensions.dart';
import 'package:dandang_gula/app/core/utils.dart';
import 'package:dandang_gula/app/global_widgets/input/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../../global_widgets/buttons/app_button.dart';
import '../../../../../global_widgets/text/app_text.dart';
import '../../controllers/stock_management_controller.dart';

class StockPurchaseView extends StatelessWidget {
  final StockManagementController controller = Get.find<StockManagementController>();
  final RxString selectedCategory = RxString('all');
  final RxString searchQuery = RxString('');
  final Map<String, TextEditingController> stockControllers = {};
  final Map<String, TextEditingController> hargaController = {};

  final uangBelanjaController = TextEditingController();
  final totalPembelianController = RxInt(0);
  final sisaUangController = RxInt(0);

  StockPurchaseView({super.key});

  @override
  Widget build(BuildContext context) {
    // Load initial data
    controller.fetchData();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pembelian Stok',
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
          onPressed: () => Get.back(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: AppButton(
              label: 'Submit',
              width: 108,
              height: 32,
              customBackgroundColor: AppColors.darkGreen,
              suffixSvgPath: AppIcons.caretRight,
              onPressed: () {},
              variant: ButtonVariant.secondary,
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, 1),
          child: Container(
            color: Color(0xFFF4F4F4),
            height: 3,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(),
          _buildCategoryTabs(),
          // _buildSearchBar(),
          Expanded(
            child: Obx(() => _buildInventoryItemsList()),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          // Uang Belanja
          Expanded(
            flex: 1,
            child: AppTextField(
              controller: uangBelanjaController,
              isMandatory: true,
              label: "Uang Belanja",
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
          ),
          const SizedBox(width: 10),

          // Total Pembelian
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      "Total Pembelian",
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      ' *',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 42,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    CurrencyFormatter.formatRupiah(totalPembelianController.toDouble()),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),

          // Sisa Uang
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Text(
                      "Sisa Uang",
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      ' *',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 42,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    CurrencyFormatter.formatRupiah(sisaUangController.toDouble()),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),

          // Search and button
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Empty container to align with other headers
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 210,
                      child: AppTextField(
                        controller: controller.searchTextController,
                        suffixIcon: AppIcons.search,
                        appTextFieldEnum: AppTextFieldEnum.field,
                        hint: "Cari Bahan",
                        onSubmitted: (val) {},
                      ),
                    ),
                    const SizedBox(width: 8),
                    AppButton(
                      label: 'Cari',
                      height: 40,
                      width: 54,
                      variant: ButtonVariant.outline,
                      outlineBorderColor: const Color(0xFF88DE7B),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: AppButton(
                        label: 'Tambahkan bahan',
                        height: 40,
                        width: 168,
                        prefixSvgPath: AppIcons.add,
                        variant: ButtonVariant.text,
                        customBackgroundColor: const Color(0xFF88DE7B),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      height: 62,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Obx(() {
        // Get categories from controller
        final categories = controller.categories;
        return ListView(
          scrollDirection: Axis.horizontal,
          children: [
            _buildCategoryTab('Semua', 'all', selectedCategory.value == 'all', '${controller.inventoryItems.length}'),
            ...categories.map((category) {
              return _buildCategoryTab(
                category['group_name'] ?? 'Unknown',
                category['id'] ?? 'unknown',
                selectedCategory.value == category['id'],
                '',
              );
            }),
          ],
        );
      }),
    );
  }

  Widget _buildCategoryTab(String title, String category, bool isSelected, String itemCount) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: InkWell(
        onTap: () {
          selectedCategory.value = category;
          // _filterItemsByCategory(category);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF1B9851) : null,
            borderRadius: BorderRadius.circular(54),
            border: isSelected ? Border.all(color: Color(0xFF136C3A)) : null,
          ),
          child: Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? Color(0xFFE9FBF1) : Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (itemCount.isNotEmpty)
                Text(
                  ' ($itemCount items)',
                  style: TextStyle(
                    color: isSelected ? Colors.white.withOpacity(0.52) : Color(0xFF3C3C4399).withOpacity(0.60),
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInventoryItemsList() {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTableHeader(),
            const Divider(),
            // Group items by category
            ...controller.groupItemsByCategory().entries.map((entry) {
              final categoryName = entry.key;
              final items = entry.value;

              return _buildCategorySection(
                  categoryName,
                  items.map((item) {
                    final itemId = item.id ?? '';
                    if (!stockControllers.containsKey(itemId)) {
                      stockControllers[itemId] = TextEditingController();
                      hargaController[itemId] = TextEditingController();
                    }

                    return _buildItemRow(
                      item.id ?? '',
                      item.name ?? '',
                      item.unitName ?? '',
                      (item.stock ?? 0).toStringAsFixed(0).toString(),
                      stockControllers[itemId]!,
                      hargaController[itemId]!,
                    );
                  }).toList());
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Nama Bahan',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Stok Saat Ini',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Jumlah Pembelian',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: Text(
              'Harga',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(String title, List<Widget> items) {
    if (items.isEmpty) return Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var item in items) ...[
          item,
          const SizedBox(height: 8),
        ],
      ],
    );
  }

  Widget _buildItemRow(
    String id,
    String? name,
    String? unit,
    String currentStock,
    TextEditingController jumlahPembelian,
    TextEditingController harga,
  ) {
    return Container(
      height: 71,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Color(0xFFFBFCFE),
      ),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Expanded(
            child: Text(name ?? "-"),
          ),
          Expanded(
            child: Text("$currentStock ${unit ?? "-"}"),
          ),
          Expanded(
            flex: 2,
            child: SizedBox(
              child: AppTextField(
                controller: jumlahPembelian,
                suffixIcon: unit,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: SizedBox(
              child: AppTextField(
                controller: harga,
                prefixIcon: "Rp",
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
