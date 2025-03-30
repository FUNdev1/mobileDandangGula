class InventoryItem {
  final String id;
  final String name;
  final String unit;
  final String? purchaseUnit;
  final String? unitName;
  final double? conversionRate;
  final String category;
  final String? categoryId;
  final String type;
  final double currentPrice;
  final int purchases;
  final int sales;
  final int currentStock;
  final int minimumStock;
  final double stockPercentage;
  final double? resultPerRecipe;
  final List<RecipeIngredient>? ingredients;

  InventoryItem({
    required this.id,
    required this.name,
    required this.unit,
    this.purchaseUnit,
    this.unitName,
    this.conversionRate,
    required this.category,
    this.categoryId,
    required this.type,
    required this.currentPrice,
    required this.purchases,
    required this.sales,
    required this.currentStock,
    required this.minimumStock,
    required this.stockPercentage,
    this.resultPerRecipe,
    this.ingredients,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    // Safe parsing for stock values
    final int minStock = _parseIntSafely(json, ['minimum_stock', 'limit', 'stock_limit']);
    final int currStock = _parseIntSafely(json, ['current_stock', 'stock']);

    // Calculate stock percentage safely
    final double stockLevel = minStock > 0 ? currStock / minStock : 0.0;

    // Parse recipe ingredients if available
    List<RecipeIngredient>? recipeIngredients;
    if (json['recipe'] != null && json['recipe'] is List) {
      recipeIngredients = (json['recipe'] as List).map((item) => RecipeIngredient.fromJson(item)).toList();
    }

    return InventoryItem(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      unit: _getFirstNonNull(json, ['unit', 'uom']) ?? '',
      purchaseUnit: json['uom_buy']?.toString(),
      unitName: _getFirstNonNull(json, ['unit_name', 'uom']),
      conversionRate: _parseDoubleSafely(json, ['conversion']),
      category: json['category']?.toString() ?? '',
      categoryId: _getFirstNonNull(json, ['group_id', 'category_id']),
      type: json['type']?.toString() ?? 'raw',
      currentPrice: _parseDoubleSafely(json, ['current_price', 'price']) ?? 0.0,
      purchases: _parseIntSafely(json, ['purchases']) ?? 0,
      sales: _parseIntSafely(json, ['sales']) ?? 0,
      currentStock: currStock,
      minimumStock: minStock,
      stockPercentage: stockLevel > 1.0 ? 1.0 : stockLevel,
      resultPerRecipe: _parseDoubleSafely(json, ['result_per_recipe']),
      ingredients: recipeIngredients,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'id': id,
      'name': name,
      'uom': unit,
      'category': category,
      'type': type,
      'current_price': currentPrice,
      'purchases': purchases,
      'sales': sales,
      'current_stock': currentStock,
      'stock_limit': minimumStock,
    };

    // Add optional fields only if they're not null
    if (purchaseUnit != null) map['uom_buy'] = purchaseUnit;
    if (conversionRate != null) map['conversion'] = conversionRate;
    if (categoryId != null) map['group_id'] = categoryId;
    if (resultPerRecipe != null) map['result_per_recipe'] = resultPerRecipe;

    // Add recipe for semi-finished items
    if (ingredients != null && ingredients!.isNotEmpty) {
      map['recipe'] = ingredients!.map((ingredient) => ingredient.toJson()).toList();
    }

    return map;
  }

  // Helper untuk parsing integer dari berbagai field nama yang mungkin
  static int _parseIntSafely(Map<String, dynamic> json, List<String> possibleKeys) {
    for (final key in possibleKeys) {
      if (json[key] != null) {
        try {
          if (json[key] is int) return json[key];
          return int.tryParse(json[key].toString()) ?? 0;
        } catch (_) {}
      }
    }
    return 0;
  }

  // Helper untuk parsing double dari berbagai field nama yang mungkin
  static double? _parseDoubleSafely(Map<String, dynamic> json, List<String> possibleKeys) {
    for (final key in possibleKeys) {
      if (json[key] != null) {
        try {
          if (json[key] is double) return json[key];
          return double.tryParse(json[key].toString());
        } catch (_) {}
      }
    }
    return null;
  }

  // Helper untuk mendapatkan nilai pertama yang tidak null dari beberapa field
  static String? _getFirstNonNull(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      if (json[key] != null) {
        return json[key].toString();
      }
    }
    return null;
  }
}

class RecipeIngredient {
  final String id;
  final double amount;
  final String unit;
  final double price;
  final String? name; // Tambahan untuk menyimpan nama bahan jika tersedia

  RecipeIngredient({
    required this.id,
    required this.amount,
    required this.unit,
    required this.price,
    this.name,
  });

  factory RecipeIngredient.fromJson(Map<String, dynamic> json) {
    return RecipeIngredient(
      id: json['raw_id']?.toString() ?? '',
      amount: json['amount'] != null ? (json['amount'] is double ? json['amount'] : double.tryParse(json['amount'].toString()) ?? 0.0) : 0.0,
      unit: json['uom']?.toString() ?? '',
      price: json['price'] != null ? (json['price'] is double ? json['price'] : double.tryParse(json['price'].toString()) ?? 0.0) : 0.0,
      name: json['name']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'raw_id': id,
      'amount': amount,
      'uom': unit,
      'price': price,
    };

    if (name != null) map['name'] = name;

    return map;
  }
}
