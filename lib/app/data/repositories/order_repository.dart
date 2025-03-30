import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/chart_data_model.dart';
import '../models/product_sales_model.dart';
import '../models/payment_method_model.dart';
import '../models/category_sales_model.dart';
import '../services/api_service.dart';

abstract class OrderRepository {
  Future<double> getTotalRevenue();
  Future<int> getTotalOrders();
  Future<List<ChartData>> getRevenueChartData();
  Future<List<ProductSales>> getTopProductSales();
  Future<List<CategorySales>> getCategorySales();
  Future<List<PaymentMethod>> getPaymentMethodData();
}

class OrderRepositoryImpl implements OrderRepository {
  final ApiService _apiService = Get.find<ApiService>();

  @override
  Future<double> getTotalRevenue() async {
    try {
      // Tidak ada endpoint spesifik di Postman collection
      // Menggunakan mock data untuk sementara (diperoleh dari ApiService._getMockData)
      final response = await _apiService.get('/order/total-revenue');

      if (response is Map && response.containsKey('revenue')) {
        return double.parse(response['revenue'].toString());
      }

      return 0.0;
    } catch (e) {
      log('Error getting total revenue: $e');
      return 0.0;
    }
  }

  @override
  Future<int> getTotalOrders() async {
    try {
      // Tidak ada endpoint spesifik di Postman collection
      // Menggunakan mock data untuk sementara (diperoleh dari ApiService._getMockData)
      final response = await _apiService.get('/order/total-orders');

      if (response is Map && response.containsKey('total')) {
        return int.parse(response['total'].toString());
      }

      return 0;
    } catch (e) {
      log('Error getting total orders: $e');
      return 0;
    }
  }

  @override
  Future<List<ChartData>> getRevenueChartData() async {
    try {
      // Tidak ada endpoint spesifik di Postman collection
      // Menggunakan mock data untuk sementara (diperoleh dari ApiService._getMockData)
      final response = await _apiService.get('/order/revenue-chart');

      if (response is List) {
        return response.map((item) => ChartData.fromJson(item)).toList();
      } else if (response is Map && response.containsKey('data') && response['data'] is List) {
        return (response['data'] as List).map((item) => ChartData.fromJson(item)).toList();
      }

      return [];
    } catch (e) {
      log('Error getting revenue chart data: $e');
      return [];
    }
  }

  @override
  Future<List<ProductSales>> getTopProductSales() async {
    try {
      // Tidak ada endpoint spesifik di Postman collection
      // Menggunakan mock data untuk sementara (diperoleh dari ApiService._getMockData)
      final response = await _apiService.get('/order/top-products');

      if (response is List) {
        return response.map((item) => ProductSales.fromJson(item)).toList();
      } else if (response is Map && response.containsKey('data') && response['data'] is List) {
        return (response['data'] as List).map((item) => ProductSales.fromJson(item)).toList();
      }

      return [];
    } catch (e) {
      log('Error getting top product sales: $e');
      return [];
    }
  }

  @override
  Future<List<CategorySales>> getCategorySales() async {
    try {
      // Tidak ada endpoint spesifik di Postman collection
      // Menggunakan mock data untuk sementara (diperoleh dari ApiService._getMockData)
      final response = await _apiService.get('/order/category-sales');

      if (response is List) {
        return response.map((item) => CategorySales.fromJson(item)).toList();
      } else if (response is Map && response.containsKey('data') && response['data'] is List) {
        return (response['data'] as List).map((item) => CategorySales.fromJson(item)).toList();
      }

      return [];
    } catch (e) {
      log('Error getting category sales: $e');
      return [];
    }
  }

  @override
  Future<List<PaymentMethod>> getPaymentMethodData() async {
    try {
      // Tidak ada endpoint spesifik di Postman collection
      // Menggunakan mock data untuk sementara (diperoleh dari ApiService._getMockData)
      final response = await _apiService.get('/order/payment-methods');

      if (response is List) {
        return response.map((item) => PaymentMethod.fromJson(item, defaultIcon: Icons.payment)).toList();
      } else if (response is Map && response.containsKey('data') && response['data'] is List) {
        return (response['data'] as List).map((item) => PaymentMethod.fromJson(item, defaultIcon: Icons.payment)).toList();
      }

      return [];
    } catch (e) {
      log('Error getting payment method data: $e');
      return [];
    }
  }
}
