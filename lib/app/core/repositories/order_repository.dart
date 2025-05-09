import 'dart:developer';
import 'package:get/get.dart';
import '../models/order_model.dart';
import '../services/api_service.dart';

abstract class OrderRepository {
  // Order Operations
  Future<Map<String, dynamic>> createOrder(OrderData orderData);
  Future<Map<String, dynamic>> updateOrder(String id, OrderData orderData);
  Future<Map<String, dynamic>> cancelOrder(String id);

  // Order Queries
  Future<Map<String, dynamic>> getOrdersPage({
    int page = 1,
    int pageSize = 10,
    String search = '',
    OrderStatus? status,
    String? startDate,
    String? endDate,
  });

  Future<Order?> getOrderDetail(String id);

  // Payment
  Future<Map<String, dynamic>> processPayment(String orderId, PaymentData paymentData);

  // Order Statistics
  Future<int> getPendingOrdersCount();
  Future<Map<String, dynamic>> getOrdersSummary({String? startDate, String? endDate});
}

class OrderRepositoryImpl implements OrderRepository {
  final ApiService _apiService = Get.find<ApiService>();

  // Order Operations
  @override
  Future<Map<String, dynamic>> createOrder(OrderData orderData) async {
    try {
      final response = await _apiService.post('/cashier/order', body: orderData.toJson());
      return response;
    } catch (e) {
      log('Error creating order: $e');
      return {'success': false, 'message': 'Failed to create order: $e'};
    }
  }

  @override
  Future<Map<String, dynamic>> updateOrder(String id, OrderData orderData) async {
    try {
      final response = await _apiService.post('/cashier/order/update/$id', body: orderData.toJson());
      return response;
    } catch (e) {
      log('Error updating order: $e');
      return {'success': false, 'message': 'Failed to update order: $e'};
    }
  }

  @override
  Future<Map<String, dynamic>> cancelOrder(String id) async {
    try {
      final response = await _apiService.delete('/cashier/order/cancel/$id');
      return response;
    } catch (e) {
      log('Error canceling order: $e');
      return {'success': false, 'message': 'Failed to cancel order: $e'};
    }
  }

  // Order Queries
  @override
  Future<Map<String, dynamic>> getOrdersPage({
    int page = 1,
    int pageSize = 10,
    String search = '',
    OrderStatus? status,
    String? startDate,
    String? endDate,
  }) async {
    try {
      final Map<String, dynamic> requestData = {
        'page': page,
        'pageSize': pageSize,
        'search': search,
      };

      if (status != null) {
        requestData['status'] = status.toApiString();
      }

      if (startDate != null) {
        requestData['startDate'] = startDate;
      }

      if (endDate != null) {
        requestData['endDate'] = endDate;
      }

      final response = await _apiService.post('/order', body: requestData);
      return response;
    } catch (e) {
      log('Error fetching orders page: $e');
      return {'success': false, 'message': 'Error: $e', 'data': []};
    }
  }

  @override
  Future<Order?> getOrderDetail(String id) async {
    try {
      final response = await _apiService.get('/order/detail/$id');

      if (response is Map<String, dynamic> && response.containsKey('data') && response['success'] == true) {
        return Order.fromJson(response['data']);
      }

      return null;
    } catch (e) {
      log('Error fetching order detail: $e');
      return null;
    }
  }

  // Payment
  @override
  Future<Map<String, dynamic>> processPayment(String orderId, PaymentData paymentData) async {
    try {
      final response = await _apiService.post(
        '/cashier/order/payment/$orderId',
        body: paymentData.toJson(),
      );
      return response;
    } catch (e) {
      log('Error processing payment: $e');
      return {'success': false, 'message': 'Failed to process payment: $e'};
    }
  }

  // Order Statistics
  @override
  Future<int> getPendingOrdersCount() async {
    try {
      final response = await _apiService.post('/cashier/order/lists', body: {
        'status': 'Belum Terbayar',
      });

      if (response is Map<String, dynamic> && response.containsKey('data') && response['data'] is List) {
        return (response['data'] as List).length;
      }

      return 0;
    } catch (e) {
      log('Error fetching pending orders count: $e');
      return 0;
    }
  }

  @override
  Future<Map<String, dynamic>> getOrdersSummary({String? startDate, String? endDate}) async {
    try {
      final Map<String, dynamic> requestData = {};

      if (startDate != null) {
        requestData['startDate'] = startDate;
      }

      if (endDate != null) {
        requestData['endDate'] = endDate;
      }

      final response = await _apiService.get('/order/summary', queryParams: requestData);
      return response;
    } catch (e) {
      log('Error fetching orders summary: $e');
      return {'success': false, 'message': 'Error: $e'};
    }
  }
}

// Extension to convert enum to API string
extension OrderStatusExtension on OrderStatus {
  String toApiString() {
    switch (this) {
      case OrderStatus.pending:
        return 'Belum Terbayar';
      case OrderStatus.completed:
        return 'Selesai';
      case OrderStatus.cancelled:
        return 'Batal';
      default:
        return '';
    }
  }
}

// Define OrderStatus enum
enum OrderStatus {
  pending, // Belum Terbayar
  completed, // Selesai
  cancelled, // Batal
}
