class Menu {
  final String id;
  final String branchId;
  final String menuName;
  final String description;
  final String photo;
  final String categoryId;
  final String categoryName;
  final double totalGross;
  final double cost;
  final double hpp;
  final double price;
  final double grossMargin;
  final List<MenuIngredient> ingredients;

  Menu({
    required this.id,
    required this.branchId,
    required this.menuName,
    required this.description,
    required this.photo,
    required this.categoryId,
    required this.categoryName,
    required this.totalGross,
    required this.cost,
    required this.hpp,
    required this.price,
    required this.grossMargin,
    required this.ingredients,
  });

  factory Menu.fromJson(Map<String, dynamic> json) {
    List<MenuIngredient> ingredientsList = [];

    if (json.containsKey('ingredients') && json['ingredients'] is List) {
      ingredientsList = (json['ingredients'] as List).map((ingredient) => MenuIngredient.fromJson(ingredient)).toList();
    }

    return Menu(
      id: json['id'] ?? '',
      branchId: json['branch_id'] ?? '',
      menuName: json['menu_name'] ?? '',
      description: json['description'] ?? '',
      photo: json['photo'] ?? '',
      categoryId: json['category_id'] ?? '',
      categoryName: json['category_name'] ?? '',
      totalGross: double.tryParse(json['total_gross']?.toString() ?? '0') ?? 0.0,
      cost: double.tryParse(json['cost']?.toString() ?? '0') ?? 0.0,
      hpp: double.tryParse(json['hpp']?.toString() ?? '0') ?? 0.0,
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      grossMargin: double.tryParse(json['gross_margin']?.toString() ?? '0') ?? 0.0,
      ingredients: ingredientsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branch_id': branchId,
      'menu_name': menuName,
      'description': description,
      'photo': photo,
      'category_id': categoryId,
      'category_name': categoryName,
      'total_gross': totalGross,
      'cost': cost,
      'hpp': hpp,
      'price': price,
      'gross_margin': grossMargin,
      'ingredients': ingredients.map((ingredient) => ingredient.toJson()).toList(),
    };
  }
}

class MenuIngredient {
  final String rawId;
  final String rawName;
  final double amount;
  final String uom;
  final double price;

  MenuIngredient({
    required this.rawId,
    required this.rawName,
    required this.amount,
    required this.uom,
    required this.price,
  });

  factory MenuIngredient.fromJson(Map<String, dynamic> json) {
    return MenuIngredient(
      rawId: json['raw_id'] ?? '',
      rawName: json['raw_name'] ?? '',
      amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0.0,
      uom: json['uom'] ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'raw_id': rawId,
      'raw_name': rawName,
      'amount': amount,
      'uom': uom,
      'price': price,
    };
  }
}
