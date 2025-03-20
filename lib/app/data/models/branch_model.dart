import 'dart:convert';

class Branch {
  final String id;
  final String name;
  final String? address;
  final String? phone;
  final String? email;
  final String? managerId;
  final String? managerName;

  // Financial data
  final double income;
  final double cogs;
  final double netProfit;
  final double percentChange;

  Branch({
    required this.id,
    required this.name,
    this.address,
    this.phone,
    this.email,
    this.managerId,
    this.managerName,
    this.income = 0.0,
    this.cogs = 0.0,
    this.netProfit = 0.0,
    this.percentChange = 0.0,
  });

  // Create from JSON
  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      managerId: json['managerId'] as String?,
      managerName: json['managerName'] as String?,
      income: json['income'] != null ? double.parse(json['income'].toString()) : 0.0,
      cogs: json['cogs'] != null ? double.parse(json['cogs'].toString()) : 0.0,
      netProfit: json['netProfit'] != null ? double.parse(json['netProfit'].toString()) : 0.0,
      percentChange: json['percentChange'] != null ? double.parse(json['percentChange'].toString()) : 0.0,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (address != null) 'address': address,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (managerId != null) 'managerId': managerId,
      if (managerName != null) 'managerName': managerName,
      'income': income,
      'cogs': cogs,
      'netProfit': netProfit,
      'percentChange': percentChange,
    };
  }

  // Create a copy with updates
  Branch copyWith({
    String? id,
    String? name,
    String? address,
    String? phone,
    String? email,
    String? managerId,
    String? managerName,
    double? income,
    double? cogs,
    double? netProfit,
    double? percentChange,
  }) {
    return Branch(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      managerId: managerId ?? this.managerId,
      managerName: managerName ?? this.managerName,
      income: income ?? this.income,
      cogs: cogs ?? this.cogs,
      netProfit: netProfit ?? this.netProfit,
      percentChange: percentChange ?? this.percentChange,
    );
  }

  // For comparison
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Branch && other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}