class ChartData {
  final String label;
  final double value;
  final DateTime? date;
  
  ChartData({
    required this.label,
    required this.value,
    this.date,
  });
  
  factory ChartData.fromJson(Map<String, dynamic> json) {
    return ChartData(
      label: json['label'] as String,
      value: json['value'] as double,
      date: json['date'] != null ? DateTime.parse(json['date'] as String) : null,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'value': value,
      'date': date?.toIso8601String(),
    };
  }
}

class CategoryData {
  final String name;
  final double value;
  final String color;
  
  CategoryData({
    required this.name,
    required this.value,
    required this.color,
  });
  
  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      name: json['name'] as String,
      value: json['value'] as double,
      color: json['color'] as String,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': value,
      'color': color,
    };
  }
}