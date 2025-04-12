import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../data/repositories/stock_management_repository.dart';
import '../../../../../../global_widgets/alert/app_snackbar.dart';
import '../../../data/models/inventory_item_model.dart';
import '../../ingredient_select/ingredient_select_view.dart';

class AddStockController extends GetxController {
  final StockManagementRepository stockManagementRepository = Get.find<StockManagementRepository>();

  // Form key for validation
  final formKey = GlobalKey<FormState>();

  // Form controllers for basic information
  final nameController = TextEditingController();
  final stockController = TextEditingController();
  final minStockController = TextEditingController();

  // Form controllers for recipe unit
  final conversionRateController = TextEditingController();

  // Form controllers for purchase unit (only for raw materials)
  final purchaseUnitController = TextEditingController();
  final purchaseConversionController = TextEditingController();

  // Form controller for production estimate (only for semi-finished)
  final resultPerRecipeController = TextEditingController();

  // Dropdown values
  final selectedType = 'raw'.obs;

  // Loading state
  final isLoading = false.obs;

  // Item being edited (null if adding new)
  InventoryItem? editItem;

  // Selected ingredients for semi-finished products
  final ingredients = <RecipeIngredient>[].obs;

  // Total cost calculation
  final totalCost = 0.0.obs;

  // Error states for form fields
  final isNameError = false.obs;
  final isCategoryError = false.obs;
  final isStockError = false.obs;
  final isMinStockError = false.obs;
  final isRecipeUnitNameError = false.obs;
  final isConversionRateError = false.obs;
  final isPurchaseUnitError = false.obs;
  final isPurchaseConversionError = false.obs;
  final isPurchaseUomError = false.obs;
  final isResultPerRecipeError = false.obs;
  final isIngredientsError = false.obs;

  // Dropdown options
  final selectedCategoryFilter = Rxn<Map<String, dynamic>>();
  final RxList<dynamic> categories = <dynamic>[].obs;
  final selectedUom = Rxn<Map<String, dynamic>>();
  final RxList<dynamic> uomList = <dynamic>[].obs;

  String get selectedUomName => selectedUom.value?["uom"] ?? "";
  String get selectedGroupName => selectedCategoryFilter.value?["group_name"] ?? "";

  final List<Map<String, String>> types = [
    {'label': 'Bahan Mentah', 'value': 'raw'},
    {'label': 'Bahan Setengah Jadi', 'value': 'semi-finished'},
  ];

  @override
  Future<void> onInit() async {
    super.onInit();
    isLoading.value = true;
    // Set default values
    conversionRateController.text = '1';
    purchaseConversionController.text = '100';
    stockController.text = '0';

    // Fetch UOM (unit of measurement)
    final getListUom = await stockManagementRepository.getListUom();
    if (getListUom.containsKey('data') && getListUom['data'] is List) {
      uomList.value = getListUom['data'] as List;
    }

    // Fetch categories (groups)
    final groupsResponse = await stockManagementRepository.getListGroup();
    if (groupsResponse.containsKey('data') && groupsResponse['data'] is List) {
      categories.value = groupsResponse['data'];
    }

    // Check if we're editing an existing item
    if (Get.arguments != null) {
      if (Get.arguments is Map<String, dynamic>) {
        final args = Get.arguments as Map<String, dynamic>;
        if (args['type'] != null && args['type'] is String) {
          selectedType.value = args['type'] as String;
        }
        if (args['item'] != null && args['item'] is InventoryItem) {
          editItem = args['item'] as InventoryItem;
          _populateFormWithExistingData();
        }
      } else if (Get.arguments is InventoryItem) {
        editItem = Get.arguments as InventoryItem;
        selectedType.value = editItem?.type ?? 'raw';
        _populateFormWithExistingData();
      }
    }
    isLoading.value = false;
  }

  @override
  void onClose() {
    // Dispose all controllers
    _resetFormFields();
    nameController.dispose();
    stockController.dispose();
    minStockController.dispose();
    conversionRateController.dispose();
    purchaseUnitController.dispose();
    purchaseConversionController.dispose();
    resultPerRecipeController.dispose();
    super.onClose();
  }

  void _populateFormWithExistingData() {
    if (editItem != null) {
      nameController.text = editItem!.name ?? "";
      stockController.text = editItem!.stock.toString();
      minStockController.text = editItem!.minimumStock.toString();
      selectedType.value = editItem!.type ?? "raw";

      // Group Bahan
      if (editItem!.category != null) {
        selectedCategoryFilter.value = categories.firstWhere(
          (category) => category['id'] == editItem!.category,
          orElse: () => null,
        );
      }
      // Recipe unit
      if (editItem!.unitName != null) {
        selectedUom.value = uomList.firstWhere(
          (uom) => uom['name'] == editItem!.unitName,
          orElse: () => null,
        );
      }

      if (editItem!.conversionRate != null) {
        conversionRateController.text = editItem!.conversionRate!.toString();
      }

      // Purchase unit (only for raw)
      if (selectedType.value == 'raw') {
        if (editItem!.purchaseUnit != null) {
          purchaseUnitController.text = editItem!.purchaseUnit!;
        }

        // Also load purchase conversion and UOM if available
        if (editItem!.additionalData != null) {
          if (editItem!.additionalData!.containsKey('purchaseConversion')) {
            purchaseConversionController.text = editItem!.additionalData!['purchaseConversion'].toString();
          }
        }
      }

      // Result per recipe (only for semi-finished)
      if (selectedType.value == 'semi-finished' && editItem!.resultPerRecipe != null) {
        resultPerRecipeController.text = editItem!.resultPerRecipe!.toString();
      }

      // Recipe ingredients (only for semi-finished)
      if (selectedType.value == 'semi-finished' && editItem!.ingredients != null) {
        ingredients.value = editItem!.ingredients!;
        _calculateTotalCost();
      }
    }
  }

  void _resetFormFields() {
    // Reset relevant fields based on the selected type
    if (selectedType.value == 'raw') {
      resultPerRecipeController.text = '';
      ingredients.clear();
      isResultPerRecipeError.value = false;
      isIngredientsError.value = false;
    } else {
      purchaseUnitController.text = '';
      purchaseConversionController.text = '';
      isPurchaseUnitError.value = false;
      isPurchaseConversionError.value = false;
      isPurchaseUomError.value = false;
    }
  }

  bool validateForm() {
    // Reset all error states
    isNameError.value = false;
    isCategoryError.value = false;
    isStockError.value = false;
    isMinStockError.value = false;
    isRecipeUnitNameError.value = false;
    isConversionRateError.value = false;
    isPurchaseUnitError.value = false;
    isPurchaseConversionError.value = false;
    isPurchaseUomError.value = false;
    isResultPerRecipeError.value = false;
    isIngredientsError.value = false;

    bool isValid = true;

    // Validate basic info
    if (nameController.text.isEmpty) {
      isNameError.value = true;
      isValid = false;
    }

    if (selectedCategoryFilter.value == null) {
      isCategoryError.value = true;
      isValid = false;
    }

    if (minStockController.text.isEmpty) {
      isMinStockError.value = true;
      isValid = false;
    }

    // Validate recipe unit info
    if (selectedUom.value == null) {
      isRecipeUnitNameError.value = true;
      isValid = false;
    }

    if (conversionRateController.text.isEmpty) {
      isConversionRateError.value = true;
      isValid = false;
    }

    // Type-specific validation
    if (selectedType.value == 'raw') {
      if (purchaseUnitController.text.isEmpty) {
        isPurchaseUnitError.value = true;
        isValid = false;
      }

      if (purchaseConversionController.text.isEmpty) {
        isPurchaseConversionError.value = true;
        isValid = false;
      }
    } else {
      // Semi-finished validation
      if (resultPerRecipeController.text.isEmpty) {
        isResultPerRecipeError.value = true;
        isValid = false;
      }

      if (ingredients.isEmpty) {
        isIngredientsError.value = true;
        isValid = false;
        AppSnackBar.error(message: 'Tambahkan minimal satu bahan untuk resep');
      }
    }

    return isValid;
  }

  void addIngredient(RecipeIngredient ingredient) {
    // Check if ingredient already exists
    final existingIndex = ingredients.indexWhere((item) => item.id == ingredient.id);

    if (existingIndex >= 0) {
      // Update existing ingredient
      ingredients[existingIndex] = ingredient;
    } else {
      // Add new ingredient
      ingredients.add(ingredient);
    }

    // Clear error if ingredients were previously empty
    if (isIngredientsError.value && ingredients.isNotEmpty) {
      isIngredientsError.value = false;
    }

    _calculateTotalCost();
  }

  void removeIngredient(String? id) {
    if (id == null) return;
    ingredients.removeWhere((item) => item.id == id);

    // Set error if ingredients become empty
    if (ingredients.isEmpty && selectedType.value == 'semi-finished') {
      isIngredientsError.value = true;
    }

    _calculateTotalCost();
  }

  void _calculateTotalCost() {
    double total = 0;
    for (var ingredient in ingredients) {
      total += (ingredient.price ?? 0) * (ingredient.amount ?? 0);
    }
    totalCost.value = total;
  }

  // Convert RecipeIngredient objects to Map<String, dynamic>
  List<Map<String, dynamic>> _ingredientsToMapList() {
    return ingredients.map((ingredient) {
      return {
        'raw_id': ingredient.id,
        'amount': ingredient.amount.toString(),
        'uom': ingredient.unit,
        'price': ingredient.price.toString(),
      };
    }).toList();
  }

  Future<void> saveItem() async {
    if (!validateForm()) return;

    isLoading.value = true;

    try {
      // Create a Map<String, dynamic> for the API payload
      final Map<String, dynamic> data = {
        'name': nameController.text,
        'uom': selectedUomName,
        'group_id': selectedCategoryFilter.value?['id'],
        'stock_limit': int.tryParse(minStockController.text) ?? 0,
        'type': selectedType.value.replaceAll("-", ""),
      };

      // Add type-specific fields
      if (selectedType.value == 'raw') {
        // For raw materials
        data['uom_buy'] = purchaseUnitController.text;
        data['conversion'] = conversionRateController.text;
      } else {
        // For semi-finished products
        data['result_per_recipe'] = resultPerRecipeController.text;
        data['price'] = totalCost.value;
        data['recipe'] = _ingredientsToMapList();
      }

      final res = await stockManagementRepository.addInventoryItem((data));
      if (res["status"] == false) {
        AppSnackBar.error(message: res["message"]);
        return;
      }

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
      // Create a Map<String, dynamic> for the API payload
      final Map<String, dynamic> data = {
        'id': editItem!.id,
        'name': nameController.text,
        'uom': selectedUomName,
        'group_id': selectedCategoryFilter.value?["id"],
        'stock_limit': int.tryParse(minStockController.text) ?? 0,
        'type': selectedType.value,
        'stock': int.tryParse(stockController.text) ?? 0,
      };

      // Add type-specific fields
      if (selectedType.value == 'raw') {
        // For raw materials
        data['uom_buy'] = purchaseUnitController.text;
        data['conversion'] = conversionRateController.text;
      } else {
        // For semi-finished products
        data['result_per_recipe'] = resultPerRecipeController.text;
        data['price'] = totalCost.value;
        data['recipe'] = _ingredientsToMapList();
      }

      final res = await stockManagementRepository.updateInventoryItem(data);
      if (res["status"] == false) {
        AppSnackBar.error(message: res["message"]);
        return;
      }

      Get.back(result: true);
      AppSnackBar.success(message: 'Bahan berhasil diperbarui');
    } catch (e) {
      print('Error updating item: $e');
      AppSnackBar.error(message: 'Gagal memperbarui bahan');
    } finally {
      isLoading.value = false;
    }
  }

  void showAddIngredientDialog(BuildContext? context) {
    if (context == null) return;

    Get.to(() => SelectIngredientPage(
          existingIngredients: ingredients.toList(),
        ))?.then((result) {
      if (result != null && result is List<RecipeIngredient>) {
        // Clear existing ingredients first
        ingredients.clear();

        // Add all selected ingredients
        for (var ingredient in result) {
          addIngredient(ingredient);
        }
      }
    });
  }
}
