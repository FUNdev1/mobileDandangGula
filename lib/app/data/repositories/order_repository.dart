import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';
import '../models/menu_model.dart';
import '../models/order_model.dart';
import '../models/payment_method_model.dart';
import '../models/category_sales_model.dart';
import '../models/product_sales_model.dart';

abstract class OrderRepository {
  Future<Map<String, dynamic>> getMenuPage({int page = 1, int pageSize = 10, String search = '', String category = ''});
  Future<List<Menu>> getMenuCards({int page = 1, int pageSize = 10, String search = '', String sort = '', String category = ''});
  Future<Menu> getMenuCardDetail(String id);
  Future<Map<String, dynamic>> createInitialBalance(double amount);
  Future<Map<String, dynamic>> createOrder(OrderData orderData);
  Future<List<Order>> getOrderHistory({String? startDate, String? endDate});
  Future<Order> getOrderDetail(String id);
  Future<Map<String, dynamic>> processPayment(String orderId, PaymentData paymentData);
  Future<double> getCurrentBalance();
  Future<double> getDailyRevenue();
  Future<int> getDailyOrderCount();
  Future<List<CategorySales>> getCategorySales({Map<String, dynamic>? filterParams});
  Future<List<ProductSales>> getTopProductSales({Map<String, dynamic>? filterParams});
  Future<List<PaymentMethod>> getPaymentMethodData({Map<String, dynamic>? filterParams});
  Future<double> getTotalRevenue({Map<String, dynamic>? filterParams});
  Future<int> getTotalOrders({Map<String, dynamic>? filterParams});
  Future<int> getPendingOrders();
}

class OrderRepositoryImpl implements OrderRepository {
  final ApiService _apiService = Get.find<ApiService>();

  @override
  Future<Map<String, dynamic>> getMenuPage({
    int page = 1,
    int pageSize = 10,
    String search = "",
    String category = "",
  }) async {
    try {
      final response = await _apiService.post('/menu');
      return response;
    } catch (e) {
      log('Error getting menu page: $e');
      return {'success': false, 'message': 'Failed to get menu page: $e'};
    }
  }

  @override
  Future<List<Menu>> getMenuCards({int page = 1, int pageSize = 10, String search = '', String sort = '', String category = ''}) async {
    try {
      final response = await _apiService.post(
        '/menu/card',
        body: {'page': page, 'pageSize': pageSize, 'search': search, 'sort': sort, 'category': category},
      );

      if (response is Map && response.containsKey('data') && response['data'] is List) {
        return (response['data'] as List).map((item) => Menu.fromJson(item)).toList();
      }

      return [];
    } catch (e) {
      log('Error getting menu cards: $e');
      return [];
    }
  }

  @override
  Future<Menu> getMenuCardDetail(String id) async {
    try {
      final response = await _apiService.get('/menu/cardDetail/$id');

      if (response is Map && response.containsKey('data')) {
        return Menu.fromJson(response['data']);
      }

      throw Exception('Invalid response format');
    } catch (e) {
      log('Error getting menu card detail: $e');
      throw Exception('Failed to get menu card detail: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> createInitialBalance(double amount) async {
    try {
      final response = await _apiService.post(
        '/cashier/initial-balance',
        body: {'amount': amount},
      );

      return response;
    } catch (e) {
      log('Error creating initial balance: $e');
      return {'success': false, 'message': 'Failed to create initial balance: $e'};
    }
  }

  @override
  Future<Map<String, dynamic>> createOrder(OrderData orderData) async {
    try {
      final Map<String, dynamic> body = orderData.toJson();

      final response = await _apiService.post('/order/create', body: body);
      return response;
    } catch (e) {
      log('Error creating order: $e');
      return {'success': false, 'message': 'Failed to create order: $e'};
    }
  }

  @override
  Future<List<Order>> getOrderHistory({String? startDate, String? endDate}) async {
    try {
      final Map<String, dynamic> params = {};

      if (startDate != null) params['startDate'] = startDate;
      if (endDate != null) params['endDate'] = endDate;

      final response = await _apiService.get('/order/history', queryParams: params);

      if (response is Map && response.containsKey('data') && response['data'] is List) {
        return (response['data'] as List).map((item) => Order.fromJson(item)).toList();
      }

      return [];
    } catch (e) {
      log('Error getting order history: $e');
      return [];
    }
  }

  @override
  Future<Order> getOrderDetail(String id) async {
    try {
      final response = await _apiService.get('/order/detail/$id');

      if (response is Map && response.containsKey('data')) {
        return Order.fromJson(response['data']);
      }

      throw Exception('Invalid response format');
    } catch (e) {
      log('Error getting order detail: $e');
      throw Exception('Failed to get order detail: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> processPayment(String orderId, PaymentData paymentData) async {
    try {
      final Map<String, dynamic> body = paymentData.toJson();
      body['order_id'] = orderId;

      final response = await _apiService.post('/order/payment', body: body);
      return response;
    } catch (e) {
      log('Error processing payment: $e');
      return {'success': false, 'message': 'Failed to process payment: $e'};
    }
  }

  @override
  Future<double> getCurrentBalance() async {
    try {
      final response = await _apiService.get('/cashier/current-balance');

      if (response is Map && response.containsKey('balance')) {
        return double.parse(response['balance'].toString());
      }

      return 0.0;
    } catch (e) {
      log('Error getting current balance: $e');
      return 0.0;
    }
  }

  @override
  Future<double> getDailyRevenue() async {
    try {
      final response = await _apiService.get('/cashier/daily-revenue');

      if (response is Map && response.containsKey('revenue')) {
        return double.parse(response['revenue'].toString());
      }

      return 0.0;
    } catch (e) {
      log('Error getting daily revenue: $e');
      return 0.0;
    }
  }

  @override
  Future<int> getDailyOrderCount() async {
    try {
      final response = await _apiService.get('/cashier/daily-order-count');

      if (response is Map && response.containsKey('count')) {
        return int.parse(response['count'].toString());
      }

      return 0;
    } catch (e) {
      log('Error getting daily order count: $e');
      return 0;
    }
  }

  @override
  Future<List<CategorySales>> getCategorySales({Map<String, dynamic>? filterParams}) async {
    try {
      final response = await _apiService.get('/reports/category-sales', queryParams: filterParams);

      if (response is Map && response.containsKey('data') && response['data'] is List) {
        return (response['data'] as List).map((item) => CategorySales.fromJson(item)).toList();
      }

      return [];
    } catch (e) {
      log('Error getting category sales: $e');
      return [];
    }
  }

  @override
  Future<List<ProductSales>> getTopProductSales({Map<String, dynamic>? filterParams}) async {
    try {
      final response = await _apiService.get('/reports/top-products', queryParams: filterParams);

      if (response is Map && response.containsKey('data') && response['data'] is List) {
        return (response['data'] as List).map((item) => ProductSales.fromJson(item)).toList();
      }

      return [];
    } catch (e) {
      log('Error getting top product sales: $e');
      return [];
    }
  }

  @override
  Future<List<PaymentMethod>> getPaymentMethodData({Map<String, dynamic>? filterParams}) async {
    try {
      final response = await _apiService.get('/reports/payment-methods', queryParams: filterParams);

      if (response is Map && response.containsKey('data') && response['data'] is List) {
        return (response['data'] as List).map((item) => PaymentMethod.fromJson(item)).toList();
      }

      return [];
    } catch (e) {
      log('Error getting payment method data: $e');
      return [];
    }
  }

  @override
  Future<double> getTotalRevenue({Map<String, dynamic>? filterParams}) async {
    try {
      final response = await _apiService.get('/reports/total-revenue', queryParams: filterParams);

      if (response is Map && response.containsKey('total')) {
        return double.parse(response['total'].toString());
      }

      return 0.0;
    } catch (e) {
      log('Error getting total revenue: $e');
      return 0.0;
    }
  }

  @override
  Future<int> getTotalOrders({Map<String, dynamic>? filterParams}) async {
    try {
      final response = await _apiService.get('/reports/total-orders', queryParams: filterParams);

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
  Future<int> getPendingOrders() async {
    try {
      final response = await _apiService.get('/order/pending-orders');

      if (response is Map && response.containsKey('count')) {
        return int.parse(response['count'].toString());
      }

      return 0;
    } catch (e) {
      log('Error getting pending orders: $e');
      return 0;
    }
  }
}
