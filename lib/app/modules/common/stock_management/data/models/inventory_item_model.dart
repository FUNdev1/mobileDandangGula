class InventoryItem {
  final String? id;
  final String? name;
  final String? uom;
  final double? stock;
  final double? price;
  final double? uomPrice;
  final String? groupId;

  // Field yang dibutuhkan untuk create/update
  final String? unitName;
  final String? purchaseUnit;
  final double? conversionRate;
  final int? minimumStock;
  final String? type;
  final double? currentPrice;
  final double? resultPerRecipe;
  final List<RecipeIngredient>? ingredients;
  final String? categoryId;

  // Field tambahan lainnya
  final String? category;
  final double? stockPercentage;
  final int? purchases;
  final int? sales;
  final Map<String, dynamic>? additionalData;

  InventoryItem({
    this.id,
    this.name,
    this.uom,
    this.stock,
    this.price,
    this.uomPrice,
    this.groupId,
    this.unitName,
    this.purchaseUnit,
    this.conversionRate,
    this.minimumStock,
    this.type,
    this.currentPrice,
    this.resultPerRecipe,
    this.ingredients,
    this.categoryId,
    this.category,
    this.stockPercentage,
    this.purchases,
    this.sales,
    this.additionalData,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      id: json['id'],
      name: json['name'],
      uom: json['uom'],
      stock: _parseDouble(json['stock']),
      price: _parseDouble(json['price']),
      uomPrice: _parseDouble(json['uom_price']),
      groupId: json['group_id'],
      // Karena beberapa field mungkin memiliki nama berbeda di API
      unitName: json['unit_name'] ?? json['uom'],
      categoryId: json['category_id'] ?? json['group_id'],
      minimumStock: json['minimum_stock'] ?? json['stock_limit'] != null ? int.tryParse(json['stock_limit'].toString()) : null,
      type: json['type'] ?? 'raw',
      currentPrice: _parseDouble(json['current_price'] ?? json['price']),
      resultPerRecipe: _parseDouble(json['result_per_recipe']),
      ingredients: json['recipe'] != null ? (json['recipe'] as List).map((e) => RecipeIngredient.fromJson(e)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (uom != null) 'uom': uom,
      if (stock != null) 'stock': stock,
      if (price != null) 'price': price,
      if (uomPrice != null) 'uom_price': uomPrice,
      if (groupId != null) 'group_id': groupId,
      if (unitName != null) 'unit_name': unitName,
      if (purchaseUnit != null) 'uom_buy': purchaseUnit,
      if (conversionRate != null) 'conversion': conversionRate,
      if (minimumStock != null) 'stock_limit': minimumStock,
      if (type != null) 'type': type,
      if (currentPrice != null) 'current_price': currentPrice,
      if (resultPerRecipe != null) 'result_per_recipe': resultPerRecipe,
      if (ingredients != null) 'recipe': ingredients!.map((i) => i.toJson()).toList(),
      if (categoryId != null) 'category_id': categoryId,
      if (category != null) 'category': category,
      if (stockPercentage != null) 'stock_percentage': stockPercentage,
      if (purchases != null) 'purchases': purchases,
      if (sales != null) 'sales': sales,
      if (additionalData != null) ...additionalData!,
    };
  }

  // Helper method untuk parsing double dengan aman
  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString());
  }

  // Copy with method untuk memudahkan pembaruan
  InventoryItem copyWith({
    String? id,
    String? name,
    String? uom,
    double? stock,
    double? price,
    double? uomPrice,
    String? groupId,
    String? unitName,
    String? purchaseUnit,
    double? conversionRate,
    int? minimumStock,
    String? type,
    double? currentPrice,
    double? resultPerRecipe,
    List<RecipeIngredient>? ingredients,
    String? categoryId,
    String? category,
    double? stockPercentage,
    int? purchases,
    int? sales,
    Map<String, dynamic>? additionalData,
  }) {
    return InventoryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      uom: uom ?? this.uom,
      stock: stock ?? this.stock,
      price: price ?? this.price,
      uomPrice: uomPrice ?? this.uomPrice,
      groupId: groupId ?? this.groupId,
      unitName: unitName ?? this.unitName,
      purchaseUnit: purchaseUnit ?? this.purchaseUnit,
      conversionRate: conversionRate ?? this.conversionRate,
      minimumStock: minimumStock ?? this.minimumStock,
      type: type ?? this.type,
      currentPrice: currentPrice ?? this.currentPrice,
      resultPerRecipe: resultPerRecipe ?? this.resultPerRecipe,
      ingredients: ingredients ?? this.ingredients,
      categoryId: categoryId ?? this.categoryId,
      category: category ?? this.category,
      stockPercentage: stockPercentage ?? this.stockPercentage,
      purchases: purchases ?? this.purchases,
      sales: sales ?? this.sales,
      additionalData: additionalData ?? this.additionalData,
    );
  }
}

class RecipeIngredient {
  final String? id;
  final String? name;
  final num? amount;
  final String? unit;
  final num? price;

  RecipeIngredient({
    this.id,
    this.name,
    this.amount,
    this.unit,
    this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'raw_id': id, // Perhatikan 'raw_id' bukan 'id' sesuai kebutuhan API
      if (name != null) 'name': name,
      if (amount != null) 'amount': amount,
      if (unit != null) 'uom': unit, // Perhatikan 'uom' bukan 'unit' sesuai kebutuhan API
      if (price != null) 'price': price,
    };
  }

  factory RecipeIngredient.fromJson(Map<String, dynamic> json) {
    return RecipeIngredient(
      id: json['raw_id'] ?? json['id'],
      name: json['name'],
      amount: _parseDouble(json['amount']),
      unit: json['uom'] ?? json['unit'],
      price: _parseDouble(json['price']),
    );
  }

  // Helper method untuk parsing double dengan aman
  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString());
  }

  RecipeIngredient copyWith({
    String? id,
    String? name,
    double? amount,
    String? unit,
    double? price,
  }) {
    return RecipeIngredient(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      unit: unit ?? this.unit,
      price: price ?? this.price,
    );
  }
}
