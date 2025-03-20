import 'package:flutter/material.dart';
import '../models/chart_data_model.dart';
import '../models/product_sales_model.dart';
import '../models/payment_method_model.dart';
import '../models/category_sales_model.dart';

abstract class OrderRepository {
  Future<double> getTotalRevenue();
  Future<int> getTotalOrders();
  Future<List<ChartData>> getRevenueChartData();
  Future<List<ProductSales>> getTopProductSales();
  Future<List<CategorySales>> getCategorySales();
  Future<List<PaymentMethod>> getPaymentMethodData();
}

class OrderRepositoryImpl implements OrderRepository {
  @override
  Future<double> getTotalRevenue() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return 50000000;
  }

  @override
  Future<int> getTotalOrders() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return 1520;
  }

  @override
  Future<List<ChartData>> getRevenueChartData() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    final data = <ChartData>[];
    
    // Generate sample data
    for (int i = 1; i <= 8; i++) {
      data.add(ChartData(
        label: 'Jan $i',
        value: 10000000 + (i * 500000 * (i % 3 == 0 ? -1 : 1)),
        date: DateTime(2023, 1, i),
      ));
    }
    
    return data;
  }

  @override
  Future<List<ProductSales>> getTopProductSales() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    return [
      ProductSales(
        id: '1',
        name: 'Ayam Hamoy',
        orderCount: 1000,
        totalSales: 1500000,
        categoryId: '1',
        categoryName: 'Main Dish',
      ),
      ProductSales(
        id: '2',
        name: 'Ayam Laos',
        orderCount: 520,
        totalSales: 1500000,
        categoryId: '1',
        categoryName: 'Main Dish',
      ),
      ProductSales(
        id: '3',
        name: 'Americano',
        orderCount: 15,
        totalSales: 1500000,
        categoryId: '2',
        categoryName: 'Beverages',
      ),
      ProductSales(
        id: '4',
        name: 'Mix Platter',
        orderCount: 15,
        totalSales: 1500000,
        categoryId: '1',
        categoryName: 'Main Dish',
      ),
      ProductSales(
        id: '5',
        name: 'French Fries',
        orderCount: 15,
        totalSales: 1500000,
        categoryId: '3',
        categoryName: 'Sides',
      ),
    ];
  }

  @override
  Future<List<CategorySales>> getCategorySales() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    return [
      CategorySales(
        id: '1',
        name: 'Main Dish',
        amount: 30000000,
        percentage: 60.0,
        color: '#136C3A',
      ),
      CategorySales(
        id: '2',
        name: 'Soup',
        amount: 10000000,
        percentage: 20.0,
        color: '#1B9851',
      ),
      CategorySales(
        id: '3',
        name: 'Nusantara',
        amount: 5000000,
        percentage: 10.0,
        color: '#90EE90',
      ),
      CategorySales(
        id: '4',
        name: 'Grill & Steak',
        amount: 3000000,
        percentage: 6.0,
        color: '#136C3A',
      ),
      CategorySales(
        id: '5',
        name: 'Beverages',
        amount: 2000000,
        percentage: 4.0,
        color: '#AEDFF7',
      ),
    ];
  }

  @override
  Future<List<PaymentMethod>> getPaymentMethodData() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    return [
      PaymentMethod(
        id: '1',
        name: 'Tunai / Cash',
        amount: 100530000,
        icon: Icons.attach_money,
      ),
      PaymentMethod(
        id: '2',
        name: 'QRIS',
        amount: 25530000,
        icon: Icons.qr_code,
      ),
      PaymentMethod(
        id: '3',
        name: 'EDC',
        amount: 12530000,
        icon: Icons.credit_card,
      ),
    ];
  }
}

