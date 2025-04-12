class MenuCategory {
  final String id;
  final String branchId;
  final String categoryName;

  MenuCategory({
    required this.id,
    required this.branchId,
    required this.categoryName,
  });

  factory MenuCategory.fromJson(Map<String, dynamic> json) {
    return MenuCategory(
      id: json['id'] ?? '',
      branchId: json['branch_id'] ?? '',
      categoryName: json['category_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branch_id': branchId,
      'category_name': categoryName,
    };
  }
}
