import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../data/models/stock_alert_model.dart';
import '../../../../data/repositories/stock_management_repository.dart';
import '../../../../global_widgets/alert/app_snackbar.dart';
import '../data/models/inventory_item_model.dart';

class StockManagementController extends GetxController {
  final StockManagementRepository stockManagementRepository = Get.find<StockManagementRepository>();

  // Observable states
  final isLoading = true.obs;
  final selectedTab = 0.obs;
  final selectedPeriod = 'real-time'.obs;
  final searchQuery = ''.obs;
  final selectedCategoryFilter = 'Semua Group'.obs;

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

  Future<void> fetchData() async {
    isLoading.value = true;
    try {
      // Fetch inventory items
      final items = await stockManagementRepository.getAllInventoryItems();
      inventoryItems.value = items;

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

  // Sorting
  void sortItems(String column) {
    if (sortColumn.value == column) {
      sortAscending.value = !sortAscending.value;
    } else {
      sortColumn.value = column;
      sortAscending.value = true;
    }

    inventoryItems.sort((a, b) {
      var aValue, bValue;

      switch (column) {
        case 'name':
          aValue = a.name;
          bValue = b.name;
          break;
        case 'unit':
          aValue = a.unit;
          bValue = b.unit;
          break;
        case 'price':
          aValue = a.currentPrice;
          bValue = b.currentPrice;
          break;
        case 'purchases':
          aValue = a.purchases;
          bValue = b.purchases;
          break;
        case 'sales':
          aValue = a.sales;
          bValue = b.sales;
          break;
        case 'stock':
          aValue = a.currentStock;
          bValue = b.currentStock;
          break;
        default:
          aValue = a.name;
          bValue = b.name;
      }

      if (sortAscending.value) {
        return aValue.compareTo(bValue);
      } else {
        return bValue.compareTo(aValue);
      }
    });
  }

  // Action methods
  void openAddStockModal() {
    Get.toNamed('/inventory/add');
  }

  void showItemActionMenu(InventoryItem item) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: AppColors.primary),
              title: const Text('Edit Informasi Bahan'),
              onTap: () {
                Get.back();
                _editItem(item);
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_shopping_cart, color: AppColors.primary),
              title: const Text('Catat Pembelian Stok'),
              onTap: () {
                Get.back();
                _recordPurchase(item);
              },
            ),
            ListTile(
              leading: const Icon(Icons.remove_shopping_cart, color: AppColors.warning),
              title: const Text('Catat Pemakaian Stok'),
              onTap: () {
                Get.back();
                _recordUsage(item);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: AppColors.error),
              title: const Text('Hapus Bahan'),
              onTap: () {
                Get.back();
                _showDeleteConfirmation(item);
              },
            ),
          ],
        ),
      ),
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

  void _showDeleteConfirmation(InventoryItem item) {
    Get.dialog(
      AlertDialog(
        title: Text('Hapus ${item.name}?'),
        content: const Text('Bahan yang sudah dihapus tidak dapat dikembalikan. Lanjutkan?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              _deleteItem(item);
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Hapus'),
          ),
        ],
      ),
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
