import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../../data/models/chart_data_model.dart';
import '../../../../data/models/menu_model.dart';
import '../../../../data/models/product_sales_model.dart';
import '../../../../data/models/payment_method_model.dart';
import 'base_dashboard_controller.dart';

class KasirDashboardController extends BaseDashboardController {
  // Kasir-specific observable variables
  final dailySales = <ChartData>[].obs;
  final topProducts = <ProductSales>[].obs;
  final paymentMethods = <PaymentMethod>[].obs;
  final todayTransactions = <Map<String, dynamic>>[].obs;
  final personalSales = 0.0.obs;
  final personalTarget = 0.0.obs;
  final personalTransactionCount = 0.obs;

  // Cart variables
  final selectedItems = <Map<String, dynamic>>[].obs;
  final customerName = ''.obs;

  var menuPage = <Map<String, dynamic>>[].obs;
  var menuCards = <Menu>[].obs;

  var selectedStockGroup = <Map<String, dynamic>>{}.obs;

  var searchValue = ''.obs;

  @override
  Future<void> loadDashboardData() async {
    try {
      isLoading.value = true;
      final filterParams = periodFilterController.getFilterParams();

      // Dapatkan data dasar dashboard
      final summary = await dashboardRepository.fetchDashboardSummary(filterParams: filterParams);
      todaySales.value = summary.totalIncome;

      // Dapatkan data produk dan metode pembayaran
      final resMenuPage = await orderRepository.getMenuPage(category: '', page: 1, pageSize: 10, search: searchValue.value);
      menuPage.value = resMenuPage['data'] ?? [];

      final resMenuCards = await orderRepository.getMenuCards(category: '', page: 1, pageSize: 10, search: searchValue.value);
      if (resMenuCards.isNotEmpty) {
        menuCards.value = resMenuCards;
        menuCards.refresh();
      }

      // Dapatkan data produk dan metode pembayaran

      // Dapatkan data penjualan harian
      // dailySales.value = await dashboardRepository.fetchDailySales(branchId: selectedBranchId.value, filterParams: filterParams);

      // Dapatkan data produk dan metode pembayaran
      topProducts.value = await orderRepository.getTopProductSales(filterParams: filterParams);
      paymentMethods.value = await orderRepository.getPaymentMethodData(filterParams: filterParams);

      // Dapatkan data transaksi hari ini
      // todayTransactions.value = await orderRepository.getTodayTransactions(branchId: selectedBranchId.value);

      // Dapatkan data performa kasir
      // final kasirPerformance = await dashboardRepository.fetchKasirPerformance(userId: authService.currentUser.value?.id ?? '', filterParams: filterParams);

      // personalSales.value = kasirPerformance['totalSales'] != null ? double.parse(kasirPerformance['totalSales'].toString()) : 0.0;
      // personalTarget.value = kasirPerformance['target'] != null ? double.parse(kasirPerformance['target'].toString()) : 0.0;
      // personalTransactionCount.value = kasirPerformance['transactionCount'] != null ? int.parse(kasirPerformance['transactionCount'].toString()) : 0;
    } catch (e) {
      if (kDebugMode) {
        print('Error loading kasir dashboard data: $e');
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Add an item to the cart
  void addItemToCart(Map<String, dynamic> item) {
    // Check if the item already exists in the cart
    final existingIndex = selectedItems.indexWhere((element) => element['id'] == item['id']);

    if (existingIndex >= 0) {
      // If the item exists, increment its quantity
      selectedItems[existingIndex]['quantity'] = (selectedItems[existingIndex]['quantity'] ?? 1) + 1;
      selectedItems.refresh();
    } else {
      // Otherwise, add it as a new item with quantity 1
      final newItem = Map<String, dynamic>.from(item);
      newItem['quantity'] = 1;
      selectedItems.add(newItem);
    }
  }

  // Remove an item from the cart
  void removeItemFromCart(int index) {
    if (index >= 0 && index < selectedItems.length) {
      selectedItems.removeAt(index);
    }
  }

  // Update item quantity
  void updateItemQuantity(int index, int quantity) {
    if (index >= 0 && index < selectedItems.length) {
      if (quantity <= 0) {
        // Remove the item if quantity is 0 or less
        selectedItems.removeAt(index);
      } else {
        // Update the quantity
        selectedItems[index]['quantity'] = quantity;
        selectedItems.refresh();
      }
    }
  }

  // Calculate subtotal
  double calculateSubtotal() {
    return selectedItems.fold(0, (sum, item) {
      double price = double.tryParse(item['price'].toString().replaceAll('Rp', '').replaceAll(',', '').trim()) ?? 0;
      int quantity = item['quantity'] ?? 1;
      return sum + (price * quantity);
    });
  }

  // Method untuk menangani perubahan filter periode
  @override
  void onPeriodFilterChanged(String periodId) {
    super.onPeriodFilterChanged(periodId);
    periodFilterController.changePeriod(periodId);
    loadDashboardData();
  }

  // Calculate service fee (example: 10% of subtotal)
  double calculateServiceFee() {
    return calculateSubtotal() * 0.1;
  }

  // Calculate total
  double calculateTotal() {
    return calculateSubtotal() + calculateServiceFee();
  }

  // Process payment
  Future<Map<String, dynamic>> processPayment(Map<String, dynamic> paymentDetails) async {
    try {
      // Here you would typically call your payment API
      // For now, we'll just simulate a successful payment

      // Clear the cart after successful payment
      selectedItems.clear();
      customerName.value = '';

      return {
        'success': true,
        'message': 'Payment processed successfully',
        'transactionId': 'TRX-${DateTime.now().millisecondsSinceEpoch}',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Payment failed: $e',
      };
    }
  }
}
