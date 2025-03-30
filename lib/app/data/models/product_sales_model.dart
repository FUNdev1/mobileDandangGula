class ProductSales {
  final String id;
  final String name;
  final int orderCount;
  final double totalSales;
  final String? imageUrl;
  final String categoryId;
  final String categoryName;

  ProductSales({
    required this.id,
    required this.name,
    required this.orderCount,
    required this.totalSales,
    this.imageUrl,
    required this.categoryId,
    required this.categoryName,
  });

  factory ProductSales.fromJson(Map<String, dynamic> json) {
    return ProductSales(
      id: json['id'].toString(),
      name: json['name'] as String,
      orderCount: json['order_count'] != null ? int.parse(json['order_count'].toString()) : 0,
      totalSales: json['total_sales'] != null ? double.parse(json['total_sales'].toString()) : 0.0,
      imageUrl: json['image_url'] as String?,
      categoryId: json['category_id']?.toString() ?? '',
      categoryName: json['category_name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'order_count': orderCount,
      'total_sales': totalSales,
      'image_url': imageUrl,
      'category_id': categoryId,
      'category_name': categoryName,
    };
  }
}
