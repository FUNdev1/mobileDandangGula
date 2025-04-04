import 'package:dandang_gula/app/config/theme/app_text_styles.dart';
import 'package:dandang_gula/app/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../data/models/stock_alert_model.dart';
import '../../../../data/models/stock_flow_data_model.dart';
import '../../../../data/models/stock_usage_model.dart';
import '../../../../data/repositories/stock_management_repository.dart';
import '../../../../global_widgets/alert/app_snackbar.dart';
import '../../../../global_widgets/buttons/action_popup.dart';
import '../../../../routes/app_routes.dart';
import '../data/models/inventory_item_model.dart';
import '../views/stock_detail/stock_detail_view.dart';

class StockManagementController extends GetxController {
  final StockManagementRepository stockManagementRepository = Get.find<StockManagementRepository>();

  // Observable states
  final isLoading = true.obs;
  final selectedTab = 0.obs; // 0 : raw | 1 : semifinished
  final selectedPeriod = 'real-time'.obs;
  final searchTextController = TextEditingController();
  final selectedCategoryFilter = RxnString();
  final currentPage = 1.obs;
  final totalPages = 1.obs;
  final RxList<dynamic> categories = <dynamic>[].obs;
  final RxList<InventoryItem> inventoryItems = <InventoryItem>[].obs;
  final RxList<StockAlert> lowStockItems = <StockAlert>[].obs;
  final RxList<StockFlowData> stockFlowData = <StockFlowData>[].obs;
  final RxList<StockUsage> stockUsageByGroup = <StockUsage>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  @override
  onClose() {
    searchTextController.dispose();
    super.onClose();
  }

  Future<void> fetchData({int page = 1}) async {
    isLoading.value = true;
    try {
      // Fetch categories (groups)
      final groupsResponse = await stockManagementRepository.getListGroup();
      if (groupsResponse.containsKey('data') && groupsResponse['data'] is List) {
        categories.value = groupsResponse['data'];
        selectedCategoryFilter.value ??= '';
      }

      // Fetch inventory items
      final items = await stockManagementRepository.getAllInventoryItems(
        page: page,
        type: selectedTab.value == 0 ? 'raw' : 'semi-finished',
        search: searchTextController.text,
        group: selectedCategoryFilter.value,
      );
      inventoryItems.value = items;
      currentPage.value = page;

      // Fetch low stock items
      final alerts = await stockManagementRepository.getStockAlerts();
      lowStockItems.value = alerts;

      // Fetch stock flow data
      final flowData = await stockManagementRepository.getStockFlowData();
      stockFlowData.value = flowData;

      // Fetch stock usage by group
      final usageData = await stockManagementRepository.getStockUsageByGroup();
      stockUsageByGroup.value = usageData;
    } catch (e) {
      print('Error fetching inventory data: $e');
      AppSnackBar.error(message: 'Gagal memuat data inventori');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    await fetchData();
  }

  void onCategoryFilterChanged(String category) {
    selectedCategoryFilter.value = category;
    refreshData();
  }

  void onPeriodChanged(String period) {
    selectedPeriod.value = period;
    refreshData();
  }

  void onTabChanged(int tabIndex) {
    selectedTab.value = tabIndex;
    refreshData();
  }

  void onPageChanged(int page) {
    currentPage.value = page;
    // Implementasi logic untuk load data halaman tertentu
    fetchData(page: page);
  }

  // Action methods
  void openAddStockModal() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          width: 497,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header dengan icon X untuk close
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: SvgPicture.asset(
                      AppIcons.close,
                      width: 24,
                      height: 24,
                    ),
                  ),
                  SizedBox(width: 10),
                  const Text(
                    'Perbarui Bahan',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              _itemAddStock(
                AppIcons.wheat,
                "Tambah Bahan Dasar",
                "Bahan mentah untuk membuat resep atau bahan setengah jadi. Contoh: Air, Gula, dll",
                () {
                  Get.back();
                  Get.toNamed(Routes.STOCK_MANAGEMENT_ADD, arguments: {'type': 'raw'});
                },
              ),
              _itemAddStock(
                AppIcons.noodleBowl,
                "Tambah Bahan Setengah Jadi",
                "Bahan yang diolah dari beberapa bahan dasar. Contoh: Sambal, Kaldu, dll.",
                () {
                  Get.back();
                  Get.toNamed(Routes.STOCK_MANAGEMENT_ADD, arguments: {'type': 'semi-finished'});
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _itemAddStock(
    String asset,
    String title,
    String subtitle,
    VoidCallback ontap,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Material(
        color: Colors.transparent,
        child: Column(
          children: [
            Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              clipBehavior: Clip.antiAlias,
              elevation: 0.5,
              child: InkWell(
                onTap: ontap,
                splashColor: Color(0xFF136C3A).withOpacity(0.15),
                highlightColor: Color(0xFFE2B472).withOpacity(0.08),
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xFFD9D9D9),
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF136C3A),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF136C3A).withOpacity(0.2),
                              blurRadius: 8,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: SvgPicture.asset(
                          asset,
                          width: 4,
                          colorFilter: ColorFilter.mode(Color(0xFFE2B472), BlendMode.srcIn),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Text(
                              subtitle,
                              style: AppTextStyles.bodyMedium.copyWith(color: Color(0xFF999999)),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ActionPopupMenu showItemActionMenu(InventoryItem item) {
    return ActionPopupMenu(
      actions: {
        'detail': () {
          Get.to(() {
            return StockDetailView(
              stockId: item.id ?? "",
            );
          });
        },
        'delete': () => showDeleteConfirmation(item),
      },
    );
  }

  void _editItem(InventoryItem item) {
    Get.toNamed('/inventory/edit', arguments: item);
  }

  void _recordPurchase(InventoryItem item) {
    Get.toNamed('/inventory/purchase', arguments: item);
  }

  void _recordUsage(InventoryItem item) {
    Get.toNamed('/inventory/usage', arguments: item);
  }

  void showDeleteConfirmation(InventoryItem item) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header dengan icon X untuk close
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(), // Empty space for alignment
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Title
              Text(
                'Yakin ingin menghapus bahan?',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),

              // Content
              Text(
                'Semua yang menggunakan bahan tersebut akan terhapus termasuk di resep bahan setengah jadi.',
                style: const TextStyle(
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
                      onPressed: () => Get.back(),
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
                      onPressed: () {
                        Get.back();
                        _deleteItem(item);
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
      ),
      barrierDismissible: false,
    );
  }

  void filterItemsByCategory(String category) {
    // Filter items by category
    if (category == 'all') {
      fetchData(); // Reset to all items
    } else {
      stockManagementRepository
          .getAllInventoryItems(
        type: selectedTab.value == 0 ? "raw" : "semi-finished",
        group: category,
      )
          .then((items) {
        inventoryItems.value = items;
      });
    }
  }

  void filterItemsBySearch(String query) {
    if (query.isEmpty) {
      fetchData(); // Reset to all items
    } else {
      stockManagementRepository
          .getAllInventoryItems(
        type: selectedTab.value == 0 ? "raw" : "semi-finished",
        search: query,
      )
          .then((items) {
        inventoryItems.value = items;
      });
    }
  }

  // Helper method to group items by category for the UI
  Map<String, List<InventoryItem>> groupItemsByCategory() {
    Map<String, List<InventoryItem>> groupedItems = {};

    for (var item in inventoryItems) {
      // Find category name from ID
      String categoryName = 'Uncategorized';

      for (var category in categories) {
        if (category['id'] == item.categoryId) {
          categoryName = category['group_name'] ?? 'Uncategorized';
          break;
        }
      }

      if (!groupedItems.containsKey(categoryName)) {
        groupedItems[categoryName] = [];
      }

      groupedItems[categoryName]!.add(item);
    }

    return groupedItems;
  }

  Future<void> _deleteItem(InventoryItem item) async {
    try {
      final result = await stockManagementRepository.deleteInventoryItem(item.id ?? "");
      fetchData();
      AppSnackBar.success(message: result["message"] ?? '${item.name} telah dihapus');
    } catch (e) {
      print('Error deleting inventory item: $e');
      AppSnackBar.error(message: 'Gagal menghapus ${item.name}');
    }
  }

  Future<Map<String, dynamic>> recordStockOpname(List<Map<String, dynamic>> stockData) async {
    try {
      final result = await stockManagementRepository.recordStockOpname(stockData);
      if (result['success'] == true) {
        fetchData();
      }
      return result;
    } catch (e) {
      print('Error recording stock opname: $e');
      return {'success': false, 'message': 'Gagal menyimpan stock opname'};
    }
  }
}
