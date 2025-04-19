import 'package:flutter/material.dart';

class PaymentMethod {
  final String id;
  final String name;
  final double amount;
  final IconData icon;
  final String? imageUrl;
  final bool isActive;

  PaymentMethod({
    required this.id,
    required this.name,
    required this.amount,
    required this.icon,
    this.imageUrl,
    this.isActive = true,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json, {IconData defaultIcon = Icons.credit_card}) {
    return PaymentMethod(
      id: json['id'] as String,
      name: json['name'] as String,
      amount: json['amount'] as double,
      icon: defaultIcon, // Cannot directly store IconData in JSON
      imageUrl: json['image_url'] as String?,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'image_url': imageUrl,
      'is_active': isActive,
    };
  }
}
