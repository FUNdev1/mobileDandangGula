import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/theme/app_colors.dart';
import '../../../../../core/utils/theme/app_text_styles.dart';
import '../../../../../core/utils/utils.dart';
import '../../../../../core/repositories/stock_management_repository.dart';
import '../../../../../global_widgets/buttons/app_button.dart';
import '../../../../../global_widgets/text/app_text.dart';
import '../../data/models/inventory_item_model.dart';

class SelectIngredientPage extends StatefulWidget {
  final List<RecipeIngredient?>? existingIngredients;

  const SelectIngredientPage({
    super.key,
    this.existingIngredients,
  });

  @override
  State<SelectIngredientPage> createState() => _SelectIngredientPageState();
}

class _SelectIngredientPageState extends State<SelectIngredientPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  // Repository
  final StockManagementRepository stockManagementRepository = Get.find<StockManagementRepository>();

  // Categories from API
  final RxList<Map<String, dynamic>> categories = <Map<String, dynamic>>[].obs;

  // State variables
  final RxList<InventoryItem> allIngredients = <InventoryItem>[].obs;
  final RxList<InventoryItem> filteredIngredients = <InventoryItem>[].obs;
  final RxList<InventoryItem> selectedIngredients = <InventoryItem>[].obs;
  final RxString currentCategory = 'all'.obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = true.obs;

  @override
  void initState() {
    super.initState();

    // Initialize with a default "All" category
    categories.add({'id': 'all', 'group_name': 'Semua', 'items': 0});

    // Fetch categories and ingredients
    _fetchCategoriesAndIngredients();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _fetchCategoriesAndIngredients() async {
    isLoading.value = true;

    try {
      // Fetch categories
      final groupsResponse = await stockManagementRepository.getListGroup();

      if (groupsResponse.containsKey('data') && groupsResponse['data'] is List) {
        final List<dynamic> groupsList = groupsResponse['data'];

        // Prepare a new list with the All category

        // Add each group to new categories list
        for (var group in groupsList) {
          if (group is Map<String, dynamic>) {
            categories.add({
              'id': group['id'],
              'group_name': group['group_name'],
              'items': 0 // Will update count after fetching ingredients
            });
          }
        }

        // Update categories list
        categories.refresh();
      }

      // Then fetch ingredients
      await fetchIngredients();
    } catch (e) {
      print('Error fetching categories: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchIngredients() async {
    try {
      final response = await stockManagementRepository.getAllInventoryItems(
        type: 'raw',
        limit: 100,
      );
      if (response.isNotEmpty && response.containsKey("data") && response['data'] is List) {
        final List<dynamic> dataList = response['data'];
        final List<InventoryItem> ingredients = dataList.map((item) => InventoryItem.fromJson(item)).toList();
        allIngredients.value = ingredients;
      }

      // Update item counts for each category
      _updateCategoryCounts();

      // Apply initial filters
      applyFilters();

      // If editing, pre-select existing ingredients
      if (widget.existingIngredients != null && widget.existingIngredients!.isNotEmpty) {
        for (var existingIngredient in widget.existingIngredients!) {
          final existingItem = allIngredients.firstWhere((item) => item.id == existingIngredient?.id, orElse: () => InventoryItem());

          if (existingItem.id != null) {
            toggleIngredient(existingItem);
          }
        }
      }
    } catch (e) {
      print('Error fetching ingredients: $e');
    }
  }

  void _updateCategoryCounts() {
    if (categories.isEmpty) return;

    // Create a new list to update the items count
    List<Map<String, dynamic>> updatedCategories = [];

    // Update "All" category count
    if (categories.isNotEmpty) {
      var allCategory = Map<String, dynamic>.from(categories[0]);
      allCategory['items'] = allIngredients.length;
      updatedCategories.add(allCategory);
    }

    // Update other category counts
    for (int i = 1; i < categories.length; i++) {
      var category = Map<String, dynamic>.from(categories[i]);
      final categoryId = category['id'];
      final count = allIngredients.where((item) => item.category == categoryId).length;
      category['items'] = count;
      updatedCategories.add(category);
    }

    // Update the categories list
    if (updatedCategories.isNotEmpty) {
      categories.value = updatedCategories;
    }
  }

  void setCurrentCategory(String categoryId) {
    currentCategory.value = categoryId;
    applyFilters();
  }

  void filterIngredients(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  void applyFilters() {
    var filtered = List<InventoryItem>.from(allIngredients);

    if (currentCategory.value != 'all') {
      filtered = filtered.where((ingredient) => ingredient.category == currentCategory.value).toList();
    }

    if (searchQuery.value.isNotEmpty) {
      filtered = filtered.where((ingredient) => ingredient.name?.toLowerCase().contains(searchQuery.value.toLowerCase()) ?? false).toList();
    }

    filteredIngredients.value = filtered;
  }

  bool isSelected(String? id) {
    if (id == null) return false;
    return selectedIngredients.any((item) => item.id == id);
  }

  void toggleIngredient(InventoryItem ingredient) {
    if (isSelected(ingredient.id)) {
      selectedIngredients.removeWhere((item) => item.id == ingredient.id);
    } else {
      // Add to selection (multiple selection enabled)
      selectedIngredients.add(ingredient);
    }
  }

  void saveSelectedIngredients() {
    if (selectedIngredients.isEmpty) return;

    // Create recipe ingredients from selected inventory items
    final List<RecipeIngredient> recipeIngredients = [];

    for (var selectedIngredient in selectedIngredients) {
      // Check if it exists in the existing ingredients
      RecipeIngredient? existing;
      if (widget.existingIngredients != null) {
        existing = widget.existingIngredients!.firstWhere(
          (item) => item?.id == selectedIngredient.id,
          orElse: () => RecipeIngredient(),
        );
      }

      // Create a new RecipeIngredient with existing values or defaults
      final recipeIngredient = RecipeIngredient(
        id: selectedIngredient.id,
        name: selectedIngredient.name,
        amount: existing?.amount ?? 1.0,
        unit: existing?.unit ?? selectedIngredient.unitName ?? '',
        price: selectedIngredient.currentPrice ?? 0,
      );

      recipeIngredients.add(recipeIngredient);
    }

    Get.back(result: recipeIngredients);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(
            AppIcons.close,
            width: 20,
            height: 20,
          ),
          onPressed: () => Get.back(closeOverlays: true),
        ),
        title: const Text(
          'Pilih Bahan',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Obx(() {
        if (isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            _buildCategoryTabs(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildSearchField(),
            ),
            Expanded(
              child: _buildIngredientList(),
            ),
            _buildBottomButtons(),
          ],
        );
      }),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      height: 62,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Obx(() {
        return ListView(
          scrollDirection: Axis.horizontal,
          children: [
            _buildCategoryTab('Semua', 'all', currentCategory.value == 'all', '${allIngredients.length} items'),
            ...categories.where((cat) => cat['id'] != 'all').map((category) {
              final categoryId = category['id'] ?? 'unknown';
              final count = allIngredients.where((item) => item.category == categoryId).length;
              return _buildCategoryTab(
                category['group_name'] ?? 'Unknown',
                categoryId,
                currentCategory.value == categoryId,
                '$count items',
              );
            }),
          ],
        );
      }),
    );
  }

  Widget _buildCategoryTab(String title, String category, bool isSelected, String itemCount) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: InkWell(
        onTap: () {
          setCurrentCategory(category);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF1B9851) : null,
            borderRadius: BorderRadius.circular(54),
            border: isSelected ? Border.all(color: Color(0xFF136C3A)) : null,
          ),
          child: Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? Color(0xFFE9FBF1) : Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (itemCount.isNotEmpty)
                Text(
                  ' ($itemCount)',
                  style: TextStyle(
                    color: isSelected ? Colors.white.withOpacity(0.52) : Color(0xFF3C3C4399).withOpacity(0.60),
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Not full width search - add width constrains
        SizedBox(
          width: 210,
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              decoration: InputDecoration(
                hintText: 'Cari Bahan',
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                suffixIcon: const Icon(Icons.search, color: Colors.grey),
              ),
              onChanged: filterIngredients,
            ),
          ),
        ),
        const SizedBox(width: 8),
        AppButton(
          label: 'Cari',
          height: 40,
          width: 54,
          variant: ButtonVariant.outline,
          outlineBorderColor: const Color(0xFF88DE7B),
          onPressed: () => filterIngredients(_searchController.text),
        ),
      ],
    );
  }

  Widget _buildIngredientList() {
    if (filteredIngredients.isEmpty) {
      return Center(
        child: Text(
          'Tidak ada bahan ditemukan',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: filteredIngredients.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final ingredient = filteredIngredients[index];
        return _buildIngredientItem(ingredient);
      },
    );
  }

  Widget _buildIngredientItem(InventoryItem ingredient) {
    return Obx(() {
      final isSelected = this.isSelected(ingredient.id);

      return GestureDetector(
        onTap: () => toggleIngredient(ingredient),
        child: Container(
          height: 71,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Color(0xFFF9FAFB),
          ),
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              // Proper checkbox container
              Container(
                width: 16,
                height: 16,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1),
                  border: Border.all(
                    color: isSelected ? AppColors.white : Color(0xFFD8D8D8),
                    width: 1.5,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Color(0xFF88DE7B),
                            blurRadius: 0,
                            spreadRadius: 1,
                            offset: const Offset(0, 0),
                          ),
                        ]
                      : [],
                  color: isSelected ? Color(0xFF88DE7B) : Colors.transparent,
                ),
              ),
              Expanded(
                child: Text(
                  ingredient.name ?? 'Bahan',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              // Text(
              //   '${ingredient.stock?.toStringAsFixed(0)} ${ingredient.unitName ?? ''}',
              //   style: TextStyle(
              //     color: Colors.grey.shade600,
              //   ),
              // ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: 'Cancel',
                  variant: ButtonVariant.outline,
                  onPressed: () => Get.back(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Obx(() {
                  return AppButton(
                    label: 'Simpan',
                    variant: ButtonVariant.primary,
                    onPressed: selectedIngredients.isNotEmpty ? () => saveSelectedIngredients() : null,
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
