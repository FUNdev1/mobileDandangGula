// lib/app/modules/common/inventory/controllers/inventory_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/repositories/inventory_repository.dart';
import '../../../../global_widgets/alert/app_snackbar.dart';

class InventoryController extends GetxController {
  final InventoryRepository _inventoryRepository = Get.find<InventoryRepository>();

  // Loading states
  final isLoading = false.obs;
  final isSubmitting = false.obs;
  final isSubmittingOut = false.obs;
  final isLoadingTransactions = false.obs;

  // Filter states
  final searchQuery = ''.obs;
  final selectedCategory = ''.obs;
  final selectedTransactionType = ''.obs;
  final dateRangeText = 'Seminggu terakhir'.obs;
  final startDate = DateTime.now().subtract(const Duration(days: 7)).obs;
  final endDate = DateTime.now().obs;

  // Categories list
  final categories = ['Protein', 'Sayuran', 'Minuman', 'Seafood', 'Bumbu'];

  // Mock inventory items for the dropdown
  final inventoryItems = [
    {
      'id': '1',
      'name': 'Daging Ayam',
      'category': 'Protein',
      'stock': '5000',
      'unit': 'gram',
    },
    {
      'id': '2',
      'name': 'Selada',
      'category': 'Sayuran',
      'stock': '3000',
      'unit': 'gram',
    },
    {
      'id': '3',
      'name': 'Susu Full Cream',
      'category': 'Minuman',
      'stock': '2000',
      'unit': 'gram',
    },
    {
      'id': '4',
      'name': 'Tomat',
      'category': 'Sayuran',
      'stock': '4000',
      'unit': 'gram',
    },
    {
      'id': '5',
      'name': 'Telur Ayam',
      'category': 'Protein',
      'stock': '5000',
      'unit': 'gram',
    },
  ].obs;

  // Mock transactions
  final transactions = [
    {
      'id': '001',
      'date': '15 Jan 2025',
      'type': 'Stok Masuk',
      'item': 'Daging Ayam',
      'description': 'Pembelian Daging Ayam',
      'quantity': '2000',
      'unit': 'gram',
      'price': 'Rp 50.000',
      'category': 'Protein',
      'user': 'Martha Elbert',
      'notes': 'Pembelian rutin',
    },
    {
      'id': '002',
      'date': '15 Jan 2025',
      'type': 'Stok Keluar',
      'item': 'Daging Ayam',
      'description': 'Penggunaan untuk menu Ayam Goreng',
      'quantity': '500',
      'unit': 'gram',
      'price': 'Rp 12.500',
      'category': 'Protein',
      'user': 'Martha Elbert',
      'notes': 'Penggunaan harian',
    },
    {
      'id': '003',
      'date': '14 Jan 2025',
      'type': 'Stok Masuk',
      'item': 'Selada',
      'description': 'Pembelian Selada Segar',
      'quantity': '1000',
      'unit': 'gram',
      'price': 'Rp 25.000',
      'category': 'Sayuran',
      'user': 'Martha Elbert',
      'notes': 'Pembelian rutin',
    },
    {
      'id': '004',
      'date': '14 Jan 2025',
      'type': 'Stok Keluar',
      'item': 'Selada',
      'description': 'Penggunaan untuk menu Salad',
      'quantity': '300',
      'unit': 'gram',
      'price': 'Rp 7.500',
      'category': 'Sayuran',
      'user': 'Martha Elbert',
      'notes': 'Penggunaan harian',
    },
    {
      'id': '005',
      'date': '13 Jan 2025',
      'type': 'Stok Keluar',
      'item': 'Tomat',
      'description': 'Penggunaan untuk menu Sop',
      'quantity': '200',
      'unit': 'gram',
      'price': 'Rp 5.000',
      'category': 'Sayuran',
      'user': 'Martha Elbert',
      'notes': 'Penggunaan harian',
    },
  ].obs;

  @override
  void onInit() {
    super.onInit();
    // Load inventory data
    _loadInventoryItems();
    _loadTransactions();

    // Set up listeners for filtering
    ever(searchQuery, (_) => update());
    ever(selectedCategory, (_) => update());
    ever(selectedTransactionType, (_) => update());
  }

  Future<void> _loadInventoryItems() async {
    isLoading.value = true;
    try {
      // In a real app, this would come from your repository
      // For now we're using the mock data already defined
      await Future.delayed(const Duration(milliseconds: 500));
      // Replace with repository call when ready:
      // final items = await _inventoryRepository.getInventoryItems();
      // inventoryItems.assignAll(items);
    } catch (e) {
      debugPrint('Error loading inventory items: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadTransactions() async {
    isLoadingTransactions.value = true;
    try {
      // In a real app, this would come from your repository
      await Future.delayed(const Duration(milliseconds: 500));
      // Replace with repository call when ready:
      // final transactionData = await _inventoryRepository.getTransactions(startDate.value, endDate.value);
      // transactions.assignAll(transactionData);
    } catch (e) {
      debugPrint('Error loading transactions: $e');
    } finally {
      isLoadingTransactions.value = false;
    }
  }

  // Filter inventory items based on search and category
  List<Map<String, dynamic>> getFilteredItems() {
    if (searchQuery.isEmpty && selectedCategory.isEmpty) {
      return inventoryItems;
    }

    return inventoryItems.where((item) {
      // Apply category filter
      final categoryMatch = selectedCategory.isEmpty || item['category'].toString().toLowerCase() == selectedCategory.value.toLowerCase();

      // Apply search filter
      final nameMatch = searchQuery.isEmpty || item['name'].toString().toLowerCase().contains(searchQuery.value.toLowerCase());

      return categoryMatch && nameMatch;
    }).toList();
  }

  // Filter transactions based on date range and type
  List<Map<String, dynamic>> getFilteredTransactions() {
    if (selectedTransactionType.isEmpty) {
      return transactions;
    }

    return transactions.where((transaction) {
      // Apply transaction type filter
      return transaction['type'] == selectedTransactionType.value;
    }).toList();
  }

  // Show date range picker for transactions
  void showDatePicker() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: Get.context!,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: startDate.value,
        end: endDate.value,
      ),
    );

    if (picked != null) {
      startDate.value = picked.start;
      endDate.value = picked.end;

      // Format date range for display
      final startFormatted = '${picked.start.day}/${picked.start.month}/${picked.start.year}';
      final endFormatted = '${picked.end.day}/${picked.end.month}/${picked.end.year}';
      dateRangeText.value = '$startFormatted - $endFormatted';

      // Reload transactions with new date range
      _loadTransactions();
    }
  }

  Future<void> submitStockEntry(Map<String, dynamic> data) async {
    isSubmitting.value = true;

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // For demonstration purposes, just log the data
      debugPrint('Stock entry data: $data');

      // Update local inventory items (in a real app, this would be done by reloading from repository)
      final itemIndex = inventoryItems.indexWhere((item) => item['name'].toString().toLowerCase() == data['name'].toString().toLowerCase() && item['category'].toString().toLowerCase() == data['category'].toString().toLowerCase());

      if (itemIndex >= 0) {
        // Update existing item
        final currentStock = int.parse(inventoryItems[itemIndex]['stock'].toString());
        final newStock = currentStock + int.parse(data['quantity'].toString());
        inventoryItems[itemIndex]['stock'] = newStock.toString();
      } else {
        // Add new item
        inventoryItems.add({
          'id': '${inventoryItems.length + 1}',
          'name': data['name'],
          'category': data['category'],
          'stock': data['quantity'],
          'unit': data['unit'],
        });
      }

      // Add transaction
      transactions.insert(0, {
        'id': '${transactions.length + 1}'.padLeft(3, '0'),
        'date': '${DateTime.now().day} ${_getMonthName(DateTime.now().month)} ${DateTime.now().year}',
        'type': 'Stok Masuk',
        'item': data['name'],
        'description': 'Pembelian ${data['name']}',
        'quantity': data['quantity'],
        'unit': data['unit'],
        'price': 'Rp ${data['price']}',
        'category': data['category'],
        'user': 'Martha Elbert',
        'notes': data['notes'] ?? '-',
      });

      // Refresh data
      inventoryItems.refresh();
      transactions.refresh();

      // Show success message
      AppSnackBar.success(
        message: 'Stok bahan berhasil disimpan',
      );

      // Go back to inventory page
      Get.back();
    } catch (e) {
      // Show error message
      AppSnackBar.error(
        message: 'Gagal menyimpan data stok: $e',
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> submitStockOut(Map<String, dynamic> data) async {
    isSubmittingOut.value = true;

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // For demonstration purposes, just log the data
      debugPrint('Stock out data: $data');

      // Get selected item
      final itemIndex = inventoryItems.indexWhere((item) => item['id'] == data['itemId']);
      if (itemIndex >= 0) {
        final currentStock = int.parse(inventoryItems[itemIndex]['stock'].toString());
        final requestedQuantity = int.parse(data['quantity'].toString());
        final newStock = currentStock - requestedQuantity;

        // Update inventory item
        inventoryItems[itemIndex]['stock'] = newStock.toString();

        // Add transaction
        transactions.insert(0, {
          'id': '${transactions.length + 1}'.padLeft(3, '0'),
          'date': '${DateTime.now().day} ${_getMonthName(DateTime.now().month)} ${DateTime.now().year}',
          'type': 'Stok Keluar',
          'item': data['itemName'],
          'description': '${data['reason']} ${data['itemName']}',
          'quantity': data['quantity'],
          'unit': data['unit'],
          'price': 'Rp ${(int.parse(data['quantity']) * 25).toString()}',
          'category': inventoryItems[itemIndex]['category'] ?? "",
          'user': 'Martha Elbert',
          'notes': data['notes'] ?? '-',
        });

        // Refresh data
        inventoryItems.refresh();
        transactions.refresh();
      }

      // Show success message
      AppSnackBar.success(
        message: 'Stok keluar berhasil dicatat',
      );

      // Go back to inventory page
      Get.back();
    } catch (e) {
      // Show error message
      AppSnackBar.error(
        message: 'Gagal mencatat stok keluar: $e',
      );
    } finally {
      isSubmittingOut.value = false;
    }
  }

  // Helper method to get month name
  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Ags', 'Sep', 'Okt', 'Nov', 'Des'];
    return months[month - 1];
  }
}
