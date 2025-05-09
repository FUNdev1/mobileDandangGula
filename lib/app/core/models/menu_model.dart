// Model untuk kategori menu
class MenuCategory {
  final String id;
  final String name;
  final String? branchId;

  MenuCategory({
    required this.id,
    required this.name,
    this.branchId,
  });

  factory MenuCategory.fromJson(Map<String, dynamic> json) {
    return MenuCategory(
      id: json['id'] ?? '',
      name: json['category_name'] ?? '',
      branchId: json['branch_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_name': name,
      if (branchId != null) 'branch_id': branchId,
    };
  }
}

// Model untuk bahan menu
class MenuIngredient {
  final String rawId;
  final String name;
  final double amount;
  final String uom;
  final double price;

  MenuIngredient({
    required this.rawId,
    required this.name,
    required this.amount,
    required this.uom,
    required this.price,
  });

  factory MenuIngredient.fromJson(Map<String, dynamic> json) {
    return MenuIngredient(
      rawId: json['raw_id'] ?? '',
      name: json['raw_name'] ?? '',
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      uom: json['uom'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'raw_id': rawId,
      'amount': amount,
      'uom': uom,
      'price': price,
    };
  }
}

// Model untuk menu
class Menu {
  final String id;
  final String name;
  final String? description;
  final String? photoUrl;
  final String categoryId;
  final String? categoryName;
  final double price;
  final double? cost;
  final double? hpp;
  final double? grossMargin;
  final double? totalGross;
  final List<MenuIngredient>? ingredients;

  Menu({
    required this.id,
    required this.name,
    this.description,
    this.photoUrl,
    required this.categoryId,
    this.categoryName,
    required this.price,
    this.cost,
    this.hpp,
    this.grossMargin,
    this.totalGross,
    this.ingredients,
  });

  factory Menu.fromJson(Map<String, dynamic> json) {
    List<MenuIngredient>? ingredientsList;
    if (json['ingredients'] != null && json['ingredients'] is List) {
      ingredientsList = (json['ingredients'] as List).map((item) => MenuIngredient.fromJson(item)).toList();
    }

    return Menu(
      id: json['id'] ?? '',
      name: json['menu_name'] ?? '',
      description: json['description'],
      photoUrl: json['photo'],
      categoryId: json['category_id'] ?? '',
      categoryName: json['category_name'],
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      cost: json['cost'] != null ? double.tryParse(json['cost'].toString()) : null,
      hpp: json['hpp'] != null ? double.tryParse(json['hpp'].toString()) : null,
      grossMargin: json['gross_margin'] != null ? double.tryParse(json['gross_margin'].toString()) : null,
      totalGross: json['total_gross'] != null ? double.tryParse(json['total_gross'].toString()) : null,
      ingredients: ingredientsList,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'menu_name': name,
      'category_id': categoryId,
      'price': price,
    };

    if (description != null) {
      data['description'] = description;
    }

    if (cost != null) {
      data['cost'] = cost;
    }

    if (hpp != null) {
      data['hpp'] = hpp;
    }

    if (grossMargin != null) {
      data['gross_margin'] = grossMargin;
    }

    if (totalGross != null) {
      data['total_gross'] = totalGross;
    }

    if (ingredients != null) {
      data['ingredients'] = ingredients!.map((ingredient) => ingredient.toJson()).toList();
    }

    return data;
  }
}
