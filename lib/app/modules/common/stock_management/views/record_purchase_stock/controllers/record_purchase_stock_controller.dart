import 'package:dandang_gula/app/data/repositories/stock_management_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../global_widgets/alert/app_snackbar.dart';
import '../../../data/models/inventory_item_model.dart';

class RecordPurchaseStockController extends GetxController {
  final StockManagementRepository stockManagementRepository = Get.find<StockManagementRepository>();

  // Form key for validation
  final formKey = GlobalKey<FormState>();

  // Form controllers
  final quantityController = TextEditingController();
  final priceController = TextEditingController();
  final supplierController = TextEditingController();
  final notesController = TextEditingController();

  // Date picker
  final selectedDate = DateTime.now().obs;

  // Loading state
  final isLoading = false.obs;

  // Item being purchased
  late InventoryItem item;

  @override
  void onInit() {
    super.onInit();

    // Get item from arguments
    if (Get.arguments != null && Get.arguments is InventoryItem) {
      item = Get.arguments;
      // Pre-fill price with current item price
      priceController.text = item.currentPrice.toStringAsFixed(0);
    } else {
      // Handle error case - no item provided
      Get.back();
      AppSnackBar.error(message: 'Gagal memuat data bahan');
    }

    // Listen for changes to calculate total
    quantityController.addListener(_updateTotal);
    priceController.addListener(_updateTotal);
  }

  @override
  void onClose() {
    quantityController.removeListener(_updateTotal);
    priceController.removeListener(_updateTotal);

    quantityController.dispose();
    priceController.dispose();
    supplierController.dispose();
    notesController.dispose();

    super.onClose();
  }

  void _updateTotal() {
    // This is just to trigger a rebuild for the total calculation
    // The actual calculation is done in the UI since it's just for display
    update();
  }

  bool validateForm() {
    return formKey.currentState?.validate() ?? false;
  }

  Future<void> selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: selectedDate.value,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF136C3A),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != selectedDate.value) {
      selectedDate.value = pickedDate;
    }
  }

  Future<void> savePurchase() async {
    if (!validateForm()) return;

    isLoading.value = true;

    try {
      final quantity = int.parse(quantityController.text);
      final price = double.parse(priceController.text);

      await stockManagementRepository.recordStockPurchase(
        item.id,
        quantity,
        price,
      );

      Get.back(result: true);
      AppSnackBar.success(message: 'Pembelian stok berhasil dicatat');
    } catch (e) {
      print('Error recording purchase: $e');
      AppSnackBar.error(message: 'Gagal mencatat pembelian');
    } finally {
      isLoading.value = false;
    }
  }
}
