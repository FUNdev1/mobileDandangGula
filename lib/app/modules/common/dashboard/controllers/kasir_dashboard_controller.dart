import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/models/menu_model.dart';
import '../../../../core/models/report_model.dart';
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
  var menuList = <Menu>[].obs;

  var selectedStockGroup = <Map<String, dynamic>>{}.obs;
  var isMenuLoaded = false.obs;

  final searchController = TextEditingController();
  final selectedCategory = ''.obs;

  final subtotal = 0.0.obs;
  final serviceFee = 0.0.obs;
  final total = 0.0.obs;
  final orderType = 'Dine in'.obs;

  @override
  void onInit() {
    super.onInit();
    // Inisialisasi nilai default untuk menghindari error layout
    menuList.value = [];
    menuPage.value = [];
    selectedItems.value = [];

    // Jalankan inisialisasi controller dengan delay kecil
    // untuk memastikan widget sudah ter-mount dengan benar
    Future.delayed(Duration(milliseconds: 100), () {
      initializeController();
    });
  }

  @override
  Future<void> loadDashboardData() async {
    try {
      isLoading.value = true;

      // Dapatkan data dasar dashboard
      final summary = await dashboardRepository.fetchDashboardSummary();
      todaySales.value = summary.totalIncome;

      // Dapatkan data produk dan metode pembayaran
      final resMenuPage = await menuRepository.getMenuPage(
        page: 1,
        pageSize: 10,
        search: searchController.text,
        categoryId: selectedCategory.value,
      );
      menuPage.value = (resMenuPage['data'] is List) ? (resMenuPage['data'] as List).map((item) => Map<String, dynamic>.from(item)).toList() : [];

      final resMenuCards = await menuRepository.getMenuCards(
        categoryId: selectedCategory.value,
        page: 1,
        pageSize: 10,
        search: searchController.text,
      );

      if (resMenuCards.isNotEmpty && resMenuCards["data"] is List) {
        if (resMenuCards["data"] is List && (resMenuCards["data"] as List).isNotEmpty) {
          // Explicitly cast each element to Map<String, dynamic> before converting to Menu
          menuList.value = (resMenuCards["data"] as List).map((e) => Menu.fromJson(e as Map<String, dynamic>)).toList();
        } else {
          menuList.value = [];
        }
        menuList.refresh();

        // Make category filter from menuCards
        final categories = menuList.map((e) => e.categoryName).toSet().toList();
        final stockGroups = <Map<String, dynamic>>[];
      }
      isMenuLoaded.value = true;

      // Dapatkan data produk dan metode pembayaran

      // Dapatkan data penjualan harian
      // dailySales.value = await dashboardRepository.fetchDailySales(branchId: selectedBranchId.value, filterParams: filterParams);

      // Dapatkan data produk dan metode pembayaran
      // topProducts.value = await orderRepository.getTopProductSales();
      // paymentMethods.value = await orderRepository.getPaymentMethodData();

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
    final existingIndex = selectedItems.indexWhere((element) => element['id'] == item['id']);

    if (existingIndex >= 0) {
      selectedItems[existingIndex]['quantity'] = (selectedItems[existingIndex]['quantity'] ?? 1) + 1;
    } else {
      final newItem = Map<String, dynamic>.from(item);
      newItem['quantity'] = 1;
      selectedItems.add(newItem);
    }
    calculateOrderSummary();
    selectedItems.refresh();
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

  // Calculate order summary
  void calculateOrderSummary() {
    subtotal.value = selectedItems.fold(0.0, (sum, item) => sum + (item['price'] * item['quantity']));
    serviceFee.value = subtotal.value * 0.1; // 10% service fee
    total.value = subtotal.value + serviceFee.value;
  }

  // Calculate service fee (example: 10% of subtotal)
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
