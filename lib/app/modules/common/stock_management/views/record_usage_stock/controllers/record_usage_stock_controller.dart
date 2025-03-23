import 'package:dandang_gula/app/data/repositories/stock_management_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../global_widgets/alert/app_snackbar.dart';
import '../../../data/models/inventory_item_model.dart';

class RecordUsageController extends GetxController {
  final StockManagementRepository stockManagementRepository = Get.find<StockManagementRepository>();

  // Form key for validation
  final formKey = GlobalKey<FormState>();

  // Form controllers
  final quantityController = TextEditingController();
  final customReasonController = TextEditingController();
  final notesController = TextEditingController();

  // Dropdown and visibility controls
  final selectedReason = 'production'.obs;
  final showCustomReasonField = false.obs;

  // Date picker
  final selectedDate = DateTime.now().obs;

  // Loading state
  final isLoading = false.obs;

  // Item being used
  late InventoryItem item;

  // Reason options
  final List<Map<String, String>> reasons = [
    {'label': 'Produksi', 'value': 'production'},
    {'label': 'Kadaluarsa', 'value': 'expired'},
    {'label': 'Rusak', 'value': 'damaged'},
    {'label': 'Hilang', 'value': 'lost'},
    {'label': 'Koreksi Stok', 'value': 'correction'},
    {'label': 'Lainnya', 'value': 'other'},
  ];

  @override
  void onInit() {
    super.onInit();

    // Get item from arguments
    if (Get.arguments != null && Get.arguments is InventoryItem) {
      item = Get.arguments;
    } else {
      // Handle error case - no item provided
      Get.back();
      AppSnackBar.error(message: 'Gagal memuat data bahan');
    }
  }

  @override
  void onClose() {
    quantityController.dispose();
    customReasonController.dispose();
    notesController.dispose();
    super.onClose();
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

  String getReasonText() {
    if (selectedReason.value == 'other') {
      return customReasonController.text;
    } else {
      final reasonMap = reasons.firstWhere(
        (reason) => reason['value'] == selectedReason.value,
        orElse: () => {'label': 'Produksi', 'value': 'production'},
      );
      return reasonMap['label'] ?? 'Produksi';
    }
  }

  Future<void> saveUsage() async {
    if (!validateForm()) return;

    isLoading.value = true;

    try {
      final quantity = int.parse(quantityController.text);
      final reason = getReasonText();

      await stockManagementRepository.recordStockUsage(
        item.id,
        quantity,
        reason,
      );

      Get.back(result: true);
      AppSnackBar.success(message: 'Pemakaian stok berhasil dicatat');
    } catch (e) {
      print('Error recording usage: $e');
      AppSnackBar.error(message: 'Gagal mencatat pemakaian');
    } finally {
      isLoading.value = false;
    }
  }
}
