import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dandang_gula/app/data/repositories/menu_management_repository.dart';
import 'package:dandang_gula/app/data/repositories/stock_management_repository.dart';
import 'package:dandang_gula/app/global_widgets/alert/app_snackbar.dart';

import '../../../stock_management/data/models/inventory_item_model.dart';

class AddMenuController extends GetxController {
  // Form controllers
  final menuNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final productionCostController = TextEditingController(text: '0');
  final sellingPriceController = TextEditingController(text: '0');

  // Search ingredients
  final ingredientSearchController = TextEditingController();

  // Observable variables
  final selectedCategoryId = RxnString();
  final selectedImage = Rxn<File?>();

  // Ingredient-related variables
  final isLoadingIngredients = false.obs;
  final allIngredients = <Map<String, dynamic>>[].obs;
  final filteredIngredients = <Map<String, dynamic>>[].obs;
  final selectedIngredients = <Map<String, dynamic>>[].obs;

  // Calculations
  final totalIngredientCost = 0.obs;
  final hpp = 0.obs;
  final grossMargin = 0.obs;
  final priceWithTax = 0.obs;

  // Form state
  final isSaving = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize controllers with default values
    productionCostController.text = '0';
    sellingPriceController.text = '0';
    
    // Setup listeners after controllers are initialized
    setupListeners();
    
    // Load ingredients
    loadIngredients();
  }

  void setupListeners() {
    // Remove existing listeners to avoid duplicates
    productionCostController.removeListener(calculateTotals);
    sellingPriceController.removeListener(calculateGrossMargin);
    
    // Add new listeners
    productionCostController.addListener(calculateTotals);
    sellingPriceController.addListener(calculateGrossMargin);
    
    // Calculate initial values
    calculateTotals();
  }

  Future<void> loadIngredients() async {
    if (isLoadingIngredients.value) return;
    
    isLoadingIngredients.value = true;
    try {
      final repository = Get.find<StockManagementRepositoryImpl>();
      final response = await repository.getAllInventoryItems(type: 'menu');

      if (response != null) {
        allIngredients.value = response.map((item) {
          return {
            'id': item.id,
            'name': item.name,
            'uom': item.uom,
            'type': item.type,
          };
        }).toList();
        filteredIngredients.value = allIngredients;
      } else {
        AppSnackBar.error(message: 'Failed to load ingredients: No data received');
      }
    } catch (e) {
      AppSnackBar.error(message: 'Failed to load ingredients: $e');
    } finally {
      isLoadingIngredients.value = false;
    }
  }

  void searchIngredients(String searchTerm) {
    if (searchTerm.isEmpty) {
      filteredIngredients.value = allIngredients;
    } else {
      filteredIngredients.value = allIngredients.where((ingredient) {
        final name = ingredient['name']?.toString().toLowerCase() ?? '';
        return name.contains(searchTerm.toLowerCase());
      }).toList();
    }
  }

  void addIngredient(Map<String, dynamic> ingredient) {
    if (!selectedIngredients.any((i) => i['id'] == ingredient['id'])) {
      selectedIngredients.add({
        'id': ingredient['id'],
        'name': ingredient['name'],
        'amount': '0',
        'uom': ingredient['uom'],
        'price': '0',
        'type': ingredient['type'] ?? 'Ingredient',
      });
    }
  }

  void removeIngredient(String id) {
    selectedIngredients.removeWhere((ingredient) => ingredient['id'] == id);
    calculateTotals();
  }

  void updateIngredientAmount(String id, String amount) {
    final index = selectedIngredients.indexWhere((ingredient) => ingredient['id'] == id);
    if (index != -1) {
      final ingredient = Map<String, dynamic>.from(selectedIngredients[index]);
      ingredient['amount'] = amount;
      selectedIngredients[index] = ingredient;
      calculateTotals();
    }
  }

  void updateIngredientPrice(String id, String price) {
    final index = selectedIngredients.indexWhere((ingredient) => ingredient['id'] == id);
    if (index != -1) {
      final ingredient = Map<String, dynamic>.from(selectedIngredients[index]);
      ingredient['price'] = price;
      selectedIngredients[index] = ingredient;
      calculateTotals();
    }
  }

  void calculateTotals() {
    // Calculate total ingredient cost
    int total = 0;
    for (final ingredient in selectedIngredients) {
      final amount = int.tryParse(ingredient['amount'] ?? '0') ?? 0;
      final price = int.tryParse(ingredient['price'] ?? '0') ?? 0;
      total += amount * price;
    }
    totalIngredientCost.value = total;

    // Calculate HPP (Harga Pokok Produksi)
    final productionCost = int.tryParse(productionCostController.text) ?? 0;
    hpp.value = totalIngredientCost.value + productionCost;

    // Recalculate gross margin
    calculateGrossMargin();
  }

  void calculateGrossMargin() {
    final sellingPrice = int.tryParse(sellingPriceController.text) ?? 0;
    grossMargin.value = sellingPrice - hpp.value;

    // Calculate price with tax (10%)
    priceWithTax.value = sellingPrice + (sellingPrice * 0.1).round();
  }

  bool validateForm() {
    if (menuNameController.text.isEmpty) {
      AppSnackBar.error(message: 'Nama menu harus diisi');
      return false;
    }

    if (selectedCategoryId.value == null || selectedCategoryId.value!.isEmpty) {
      AppSnackBar.error(message: 'Kategori harus dipilih');
      return false;
    }

    if (selectedIngredients.isEmpty) {
      AppSnackBar.error(message: 'Minimal 1 bahan harus dipilih');
      return false;
    }

    // Validate ingredient amounts and prices
    for (final ingredient in selectedIngredients) {
      final amount = int.tryParse(ingredient['amount'] ?? '0') ?? 0;
      if (amount <= 0) {
        AppSnackBar.error(message: 'Jumlah ${ingredient['name']} harus lebih dari 0');
        return false;
      }

      final price = int.tryParse(ingredient['price'] ?? '0') ?? 0;
      if (price <= 0) {
        AppSnackBar.error(message: 'Harga ${ingredient['name']} harus lebih dari 0');
        return false;
      }
    }

    final sellingPrice = int.tryParse(sellingPriceController.text) ?? 0;
    if (sellingPrice <= 0) {
      AppSnackBar.error(message: 'Harga jual harus lebih dari 0');
      return false;
    }

    return true;
  }

  void validateAndSave() {
    if (!validateForm()) {
      return;
    }

    saveMenu();
  }

  Future<void> saveMenu() async {
    isSaving.value = true;

    try {
      final repository = MenuManagementRepositoryImpl();

      // Prepare ingredients data
      final ingredients = selectedIngredients.map((ingredient) => {'raw_id': ingredient['id'], 'amount': ingredient['amount'], 'uom': ingredient['uom'], 'price': ingredient['price']}).toList();

      // Prepare request data
      final formData = {
        'photo': selectedImage.value?.path ?? "",
        'menu_name': menuNameController.text,
        'description': descriptionController.text,
        'category_id': selectedCategoryId.value,
        'total_gross': grossMargin.value.toString(),
        'cost': productionCostController.text,
        'hpp': hpp.value.toString(),
        'price': sellingPriceController.text,
        'gross_margin': grossMargin.value.toString(),
        'ingredients': ingredients,
      };

      final response = await repository.createMenu(formData);

      if (response['success'] == true) {
        AppSnackBar.success(message: 'Menu berhasil disimpan');
        Get.back(result: true); // Close dialog and refresh list
      } else {
        AppSnackBar.error(message: 'Gagal menyimpan menu: ${response['message']}');
      }
    } catch (e) {
      AppSnackBar.error(message: 'Error: $e');
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    menuNameController.dispose();
    descriptionController.dispose();
    productionCostController.dispose();
    sellingPriceController.dispose();
    ingredientSearchController.dispose();
    super.onClose();
  }
}
