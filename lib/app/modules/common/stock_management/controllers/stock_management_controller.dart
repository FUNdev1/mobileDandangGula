import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../data/models/stock_alert_model.dart';
import '../../../../data/repositories/stock_management_repository.dart';
import '../../../../global_widgets/alert/app_snackbar.dart';
import '../../../../global_widgets/buttons/action_popup.dart';
import '../data/models/inventory_item_model.dart';

class StockManagementController extends GetxController {
  final StockManagementRepository stockManagementRepository = Get.find<StockManagementRepository>();

  // Observable states
  final isLoading = true.obs;
  final selectedTab = 0.obs;
  final selectedPeriod = 'real-time'.obs;
  final searchQuery = ''.obs;
  final selectedCategoryFilter = 'Semua Group'.obs;
  final currentPage = 1.obs;
  final totalPages = 1.obs;
  final categories = <String>['Semua Group'].obs;

  // Inventory data
  final inventoryItems = <InventoryItem>[].obs;
  final lowStockItems = <StockAlert>[].obs;

  // Sort states
  final sortColumn = ''.obs;
  final sortAscending = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData({int page = 1}) async {
    isLoading.value = true;
    try {
      // Fetch inventory items
      final response = await stockManagementRepository.getAllInventoryItems(page: page);
      inventoryItems.value = response;

      // totalPages.value = response.totalPages;
      currentPage.value = page;

      // Fetch low stock items
      final alerts = await stockManagementRepository.getStockAlerts();
      lowStockItems.value = alerts;
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

  // Filter methods
  List<InventoryItem> get filteredInventoryItems {
    return inventoryItems.where((item) {
      // Filter by category
      if (selectedCategoryFilter.value != 'Semua Group' && item.category != selectedCategoryFilter.value) {
        return false;
      }

      // Filter by search query
      if (searchQuery.value.isNotEmpty && !item.name.toLowerCase().contains(searchQuery.value.toLowerCase())) {
        return false;
      }

      // Filter by item type
      return item.type == 'raw';
    }).toList();
  }

  List<InventoryItem> get filteredSemiFinishedItems {
    return inventoryItems.where((item) {
      // Filter by category
      if (selectedCategoryFilter.value != 'Semua Group' && item.category != selectedCategoryFilter.value) {
        return false;
      }

      // Filter by search query
      if (searchQuery.value.isNotEmpty && !item.name.toLowerCase().contains(searchQuery.value.toLowerCase())) {
        return false;
      }

      // Filter by item type
      return item.type == 'semi-finished';
    }).toList();
  }

  // Filter actions
  void onSearchChanged(String query) {
    searchQuery.value = query;
  }

  void onCategoryFilterChanged(String category) {
    selectedCategoryFilter.value = category;
  }

  void onPeriodChanged(String period) {
    selectedPeriod.value = period;
    refreshData();
  }

  void onTabChanged(int tabIndex) {
    selectedTab.value = tabIndex;
  }

  void onPageChanged(int page) {
    currentPage.value = page;
    // Implementasi logic untuk load data halaman tertentu
    fetchData(page: page);
  }

  // Action methods
  void openAddStockModal() {
    Get.toNamed('/inventory/add');
  }

  ActionPopupMenu showItemActionMenu(InventoryItem item) {
    return ActionPopupMenu(
      actions: {
        // 'detail': () => _showItemDetails(item),
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

  Future<void> _deleteItem(InventoryItem item) async {
    try {
      await stockManagementRepository.deleteInventoryItem(item.id);
      inventoryItems.removeWhere((element) => element.id == item.id);
      AppSnackBar.success(message: '${item.name} telah dihapus');
    } catch (e) {
      print('Error deleting inventory item: $e');
      AppSnackBar.error(message: 'Gagal menghapus ${item.name}');
    }
  }
}
