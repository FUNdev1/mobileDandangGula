import 'package:dandang_gula/app/data/repositories/stock_management_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../global_widgets/alert/app_snackbar.dart';
import '../../../data/models/inventory_item_model.dart';

class AddStockController extends GetxController {
  final StockManagementRepository stockManagementRepository = Get.find<StockManagementRepository>();

  // Form key for validation
  final formKey = GlobalKey<FormState>();

  // Form controllers
  final nameController = TextEditingController();
  final unitController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController();
  final minStockController = TextEditingController();

  // Dropdown values
  final selectedCategory = 'Bumbu'.obs;
  final selectedType = 'raw'.obs;

  // Loading state
  final isLoading = false.obs;

  // Item being edited (null if adding new)
  InventoryItem? editItem;

  // Dropdown options
  final List<String> categories = [
    'Bumbu',
    'Protein',
    'Sayuran',
    'Minuman',
    'Lainnya',
  ];

  final List<Map<String, String>> types = [
    {'label': 'Bahan Mentah', 'value': 'raw'},
    {'label': 'Bahan Setengah Jadi', 'value': 'semi-finished'},
  ];

  @override
  void onInit() {
    super.onInit();

    // Check if we're editing an existing item
    if (Get.arguments != null && Get.arguments is InventoryItem) {
      editItem = Get.arguments;
      _populateFormWithExistingData();
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    unitController.dispose();
    priceController.dispose();
    stockController.dispose();
    minStockController.dispose();
    super.onClose();
  }

  void _populateFormWithExistingData() {
    if (editItem != null) {
      nameController.text = editItem!.name;
      unitController.text = editItem!.unit;
      priceController.text = editItem!.currentPrice.toStringAsFixed(0);
      stockController.text = editItem!.currentStock.toString();
      minStockController.text = editItem!.minimumStock.toString();
      selectedCategory.value = editItem!.category;
      selectedType.value = editItem!.type;
    }
  }

  bool validateForm() {
    return formKey.currentState?.validate() ?? false;
  }

  Future<void> saveItem() async {
    if (!validateForm()) return;

    isLoading.value = true;

    try {
      final item = InventoryItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // Temporary ID, will be replaced by server
        name: nameController.text,
        unit: unitController.text,
        category: selectedCategory.value,
        type: selectedType.value,
        currentPrice: double.parse(priceController.text),
        purchases: 0,
        sales: 0,
        currentStock: int.parse(stockController.text),
        minimumStock: int.parse(minStockController.text),
        stockPercentage: int.parse(stockController.text) / int.parse(minStockController.text),
      );

      await stockManagementRepository.addInventoryItem(item);

      Get.back(result: true);
      AppSnackBar.success(message: 'Bahan berhasil ditambahkan');
    } catch (e) {
      print('Error saving item: $e');
      AppSnackBar.error(message: 'Gagal menambahkan bahan');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateItem() async {
    if (!validateForm() || editItem == null) return;

    isLoading.value = true;

    try {
      final updatedItem = InventoryItem(
        id: editItem!.id,
        name: nameController.text,
        unit: unitController.text,
        category: selectedCategory.value,
        type: selectedType.value,
        currentPrice: double.parse(priceController.text),
        purchases: editItem!.purchases,
        sales: editItem!.sales,
        currentStock: int.parse(stockController.text),
        minimumStock: int.parse(minStockController.text),
        stockPercentage: int.parse(stockController.text) / int.parse(minStockController.text),
      );

      await stockManagementRepository.updateInventoryItem(updatedItem);

      Get.back(result: true);
      AppSnackBar.success(message: 'Bahan berhasil diperbarui');
    } catch (e) {
      print('Error updating item: $e');
      AppSnackBar.error(message: 'Gagal memperbarui bahan');
    } finally {
      isLoading.value = false;
    }
  }
}
