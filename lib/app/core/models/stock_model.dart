// Model untuk grup stok
class StockGroup {
  final String id;
  final String name;
  final String? branchId;

  StockGroup({
    required this.id,
    required this.name,
    this.branchId,
  });

  factory StockGroup.fromJson(Map<String, dynamic> json) {
    return StockGroup(
      id: json['id'] ?? '',
      name: json['group_name'] ?? '',
      branchId: json['branch_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'group_name': name,
      'branch_id': branchId,
    };
  }
}

// Model untuk unit pengukuran
class UnitOfMeasurement {
  final String id;
  final String name;

  UnitOfMeasurement({
    required this.id,
    required this.name,
  });

  factory UnitOfMeasurement.fromJson(Map<String, dynamic> json) {
    return UnitOfMeasurement(
      id: json['id'] ?? '',
      name: json['uom'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uom': name,
    };
  }
}

// Model untuk resep bahan setengah jadi
class RecipeItem {
  final String rawId;
  final String name;
  final double amount;
  final String uom;
  final double price;

  RecipeItem({
    required this.rawId,
    required this.name,
    required this.amount,
    required this.uom,
    required this.price,
  });

  factory RecipeItem.fromJson(Map<String, dynamic> json) {
    return RecipeItem(
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

// Model untuk item stok (bahan mentah atau setengah jadi)
class StockItem {
  final String id;
  final String name;
  final String uom;
  final String? uomBuy;
  final double? conversion;
  final String? groupId;
  final String? groupName;
  final double stockLimit;
  final String type; // 'raw' atau 'semifinished'
  final double? price;
  final double? stock;
  final List<RecipeItem>? recipe;
  final double? resultPerRecipe;

  StockItem({
    required this.id,
    required this.name,
    required this.uom,
    this.uomBuy,
    this.conversion,
    this.groupId,
    this.groupName,
    required this.stockLimit,
    required this.type,
    this.price,
    this.stock,
    this.recipe,
    this.resultPerRecipe,
  });

  factory StockItem.fromJson(Map<String, dynamic> json) {
    List<RecipeItem>? recipeItems;
    if (json['recipe'] != null && json['recipe'] is List) {
      recipeItems = (json['recipe'] as List).map((item) => RecipeItem.fromJson(item)).toList();
    }

    return StockItem(
      id: json['id'] ?? '',
      name: json['stock_name'] ?? json['name_ingredient'] ?? '',
      uom: json['uom'] ?? '',
      uomBuy: json['uom_buy'],
      conversion: json['conversion'] != null ? double.tryParse(json['conversion'].toString()) : null,
      groupId: json['group_id'],
      groupName: json['group_name'],
      stockLimit: json['limit'] != null
          ? double.tryParse(json['limit'].toString()) ?? 0.0
          : json['stock_limit'] != null
              ? double.tryParse(json['stock_limit'].toString()) ?? 0.0
              : 0.0,
      type: json['type'] ?? 'raw',
      price: json['price'] != null ? double.tryParse(json['price'].toString()) : null,
      stock: json['stock'] != null ? double.tryParse(json['stock'].toString()) : null,
      recipe: recipeItems,
      resultPerRecipe: json['result_per_recipe'] != null ? double.tryParse(json['result_per_recipe'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'name': name,
      'uom': uom,
      'stock_limit': stockLimit,
      'type': type,
    };

    if (type == 'raw') {
      data['uom_buy'] = uomBuy;
      data['conversion'] = conversion;
    } else {
      data['result_per_recipe'] = resultPerRecipe;
      data['price'] = price;
      if (recipe != null) {
        data['recipe'] = recipe!.map((item) => item.toJson()).toList();
      }
    }

    if (groupId != null) {
      data['group_id'] = groupId;
    }

    return data;
  }
}

// Model untuk alert stok
class StockAlert {
  final String id;
  final String name;
  final num stock;
  final num limit;
  final String uom;
  final num gap;

  StockAlert({
    required this.id,
    required this.name,
    required this.stock,
    required this.limit,
    required this.uom,
    required this.gap,
  });

  factory StockAlert.fromJson(Map<String, dynamic> json) {
    return StockAlert(
      id: json['id'] ?? '',
      name: json['stock_name'] ?? '',
      stock: num.tryParse(json['stock'].toString()) ?? 0,
      limit: num.tryParse(json['stock_limit'].toString()) ?? 0,
      uom: json['uom'] ?? '',
      gap: num.tryParse(json['gap'].toString())?? 0,
    );
  }
}

// Model untuk data aliran stok
class StockFlowData {
  final String date;
  final double stockIn;
  final double stockOut;
  final double balance;

  StockFlowData({
    required this.date,
    required this.stockIn,
    required this.stockOut,
    required this.balance,
  });

  factory StockFlowData.fromJson(Map<String, dynamic> json) {
    return StockFlowData(
      date: json['date'] ?? '',
      stockIn: double.tryParse(json['stock_in'].toString()) ?? 0.0,
      stockOut: double.tryParse(json['stock_out'].toString()) ?? 0.0,
      balance: double.tryParse(json['balance'].toString()) ?? 0.0,
    );
  }
}

// Model untuk penggunaan stok berdasarkan grup
class StockUsage {
  final String groupId;
  final String groupName;
  final double usage;
  final double percentage;

  StockUsage({
    required this.groupId,
    required this.groupName,
    required this.usage,
    required this.percentage,
  });

  factory StockUsage.fromJson(Map<String, dynamic> json) {
    return StockUsage(
      groupId: json['group_id'] ?? '',
      groupName: json['group_name'] ?? '',
      usage: double.tryParse(json['usage'].toString()) ?? 0.0,
      percentage: double.tryParse(json['percentage'].toString()) ?? 0.0,
    );
  }
}
