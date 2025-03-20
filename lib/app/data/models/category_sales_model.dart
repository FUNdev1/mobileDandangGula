class CategorySales {
  final String id;
  final String name;
  final double amount;
  final double percentage;
  final String color;

  CategorySales({
    required this.id,
    required this.name,
    required this.amount,
    required this.percentage,
    required this.color,
  });

  factory CategorySales.fromJson(Map<String, dynamic> json) {
    return CategorySales(
      id: json['id'] as String,
      name: json['name'] as String,
      amount: json['amount'] as double,
      percentage: json['percentage'] as double,
      color: json['color'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'percentage': percentage,
      'color': color,
    };
  }
}
