import 'dart:developer';
import 'package:get/get.dart';
import '../models/report_model.dart';
import '../models/stock_model.dart';
import '../services/api_service.dart';

abstract class ReportRepository {
  // Sales Reports
  Future<Map<String, dynamic>> getSalesSummary({String? startDate, String? endDate});
  Future<List<ChartData>> getSalesChart({String? startDate, String? endDate});
  Future<List<ProductSales>> getMenuSales({String? startDate, String? endDate});
  Future<List<ProductSales>> getAllMenuSales({String? startDate, String? endDate});
  Future<List<CategorySales>> getCategorySales({String? startDate, String? endDate});
  Future<List<PaymentMethod>> getPaymentMethodSales({String? startDate, String? endDate});
  Future<List<CashierReport>> getCashierReports({String? startDate, String? endDate});

  // Inventory Reports
  Future<Map<String, dynamic>> getInventorySummary({String? startDate, String? endDate});
  Future<List<ChartData>> getInventoryChart({String? startDate, String? endDate});
  Future<List<StockAlert>> getStockAlerts();
  Future<List<StockUsage>> getStockUsageByGroup();
}

class ReportRepositoryImpl implements ReportRepository {
  final ApiService _apiService = Get.find<ApiService>();

  // Sales Reports
  @override
  Future<Map<String, dynamic>> getSalesSummary({String? startDate, String? endDate}) async {
    try {
      final Map<String, dynamic> requestData = {};

      if (startDate != null) {
        requestData['startDate'] = startDate;
      }

      if (endDate != null) {
        requestData['endDate'] = endDate;
      }

      final response = await _apiService.post(
        '/dashboard/sales/summary',
        body: requestData,
      );
      return response;
    } catch (e) {
      log('Error fetching sales summary: $e');
      return {'success': false, 'message': 'Error: $e', 'data': {}};
    }
  }

  @override
  Future<List<ChartData>> getSalesChart({String? startDate, String? endDate}) async {
    try {
      final Map<String, dynamic> requestData = {};

      if (startDate != null) {
        requestData['startDate'] = startDate;
      }

      if (endDate != null) {
        requestData['endDate'] = endDate;
      }

      final response = await _apiService.post(
        '/dashboard/sales/chart',
        body: requestData,
      );

      if (response is Map<String, dynamic> && response.containsKey('data') && response['data'] is List) {
        return (response['data'] as List).map((item) => ChartData.fromJson(item)).toList();
      }

      return [];
    } catch (e) {
      log('Error fetching sales chart: $e');
      return [];
    }
  }

  @override
  Future<List<ProductSales>> getMenuSales({String? startDate, String? endDate}) async {
    try {
      final Map<String, dynamic> requestData = {};

      if (startDate != null) {
        requestData['startDate'] = startDate;
      }

      if (endDate != null) {
        requestData['endDate'] = endDate;
      }

      final response = await _apiService.post(
        '/dashboard/sales',
        body: requestData,
      );

      if (response is Map<String, dynamic> && response.containsKey('data') && response['data'] is List) {
        return (response['data'] as List).map((item) => ProductSales.fromJson(item)).toList();
      }

      return [];
    } catch (e) {
      log('Error fetching menu sales: $e');
      return [];
    }
  }

  @override
  Future<List<ProductSales>> getAllMenuSales({String? startDate, String? endDate}) async {
    try {
      final Map<String, dynamic> requestData = {};

      if (startDate != null) {
        requestData['startDate'] = startDate;
      }

      if (endDate != null) {
        requestData['endDate'] = endDate;
      }

      final response = await _apiService.post(
        '/cashier/report/sales/all',
        body: requestData,
      );

      if (response is Map<String, dynamic> && response.containsKey('data') && response['data'] is List) {
        return (response['data'] as List).map((item) => ProductSales.fromJson(item)).toList();
      }

      return [];
    } catch (e) {
      log('Error fetching all menu sales: $e');
      return [];
    }
  }

  @override
  Future<List<CategorySales>> getCategorySales({String? startDate, String? endDate}) async {
    try {
      final Map<String, dynamic> requestData = {};

      if (startDate != null) {
        requestData['startDate'] = startDate;
      }

      if (endDate != null) {
        requestData['endDate'] = endDate;
      }

      final response = await _apiService.post(
        '/dashboard/sales/category',
        body: requestData,
      );

      if (response is Map<String, dynamic> && response.containsKey('data') && response['data'] is List) {
        return (response['data'] as List).map((item) => CategorySales.fromJson(item)).toList();
      }

      return [];
    } catch (e) {
      log('Error fetching category sales: $e');
      return [];
    }
  }

  @override
  Future<List<PaymentMethod>> getPaymentMethodSales({String? startDate, String? endDate}) async {
    try {
      final Map<String, dynamic> requestData = {};

      if (startDate != null) {
        requestData['startDate'] = startDate;
      }

      if (endDate != null) {
        requestData['endDate'] = endDate;
      }

      final response = await _apiService.post(
        '/dashboard/sales/payment',
        body: requestData,
      );

      if (response is Map<String, dynamic> && response.containsKey('data') && response['data'] is List) {
        return (response['data'] as List).map((item) => PaymentMethod.fromJson(item)).toList();
      }

      return [];
    } catch (e) {
      log('Error fetching payment method sales: $e');
      return [];
    }
  }

  @override
  Future<List<CashierReport>> getCashierReports({String? startDate, String? endDate}) async {
    try {
      final Map<String, dynamic> requestData = {};

      if (startDate != null) {
        requestData['startDate'] = startDate;
      }

      if (endDate != null) {
        requestData['endDate'] = endDate;
      }

      final response = await _apiService.post(
        '/cashier/report/lists',
        body: requestData,
      );

      if (response is Map<String, dynamic> && response.containsKey('data') && response['data'] is List) {
        return (response['data'] as List).map((item) => CashierReport.fromJson(item)).toList();
      }

      return [];
    } catch (e) {
      log('Error fetching cashier reports: $e');
      return [];
    }
  }

  // Inventory Reports
  @override
  Future<Map<String, dynamic>> getInventorySummary({String? startDate, String? endDate}) async {
    try {
      final Map<String, dynamic> requestData = {};

      if (startDate != null) {
        requestData['startDate'] = startDate;
      }

      if (endDate != null) {
        requestData['endDate'] = endDate;
      }

      final response = await _apiService.post(
        '/inventory/summary',
        body: requestData,
      );
      return response;
    } catch (e) {
      log('Error fetching inventory summary: $e');
      return {'success': false, 'message': 'Error: $e', 'data': {}};
    }
  }

  @override
  Future<List<ChartData>> getInventoryChart({String? startDate, String? endDate}) async {
    try {
      final Map<String, dynamic> requestData = {};

      if (startDate != null) {
        requestData['startDate'] = startDate;
      }

      if (endDate != null) {
        requestData['endDate'] = endDate;
      }

      final response = await _apiService.post(
        '/inventory/chart',
        body: requestData,
      );

      if (response is Map<String, dynamic> && response.containsKey('data') && response['data'] is List) {
        return (response['data'] as List).map((item) => ChartData.fromJson(item)).toList();
      }

      return [];
    } catch (e) {
      log('Error fetching inventory chart: $e');
      return [];
    }
  }

  @override
  Future<List<StockAlert>> getStockAlerts() async {
    try {
      final response = await _apiService.post(
        '/inventory/alert',
        body: {},
      );

      if (response is Map<String, dynamic> && response.containsKey('data') && response['data'] is List) {
        return (response['data'] as List).map((item) => StockAlert.fromJson(item)).toList();
      }

      return [];
    } catch (e) {
      log('Error fetching stock alerts: $e');
      return [];
    }
  }

  @override
  Future<List<StockUsage>> getStockUsageByGroup() async {
    try {
      final response = await _apiService.post(
        '/inventory/group',
        body: {},
      );

      if (response is Map<String, dynamic> && response.containsKey('data') && response['data'] is List) {
        return (response['data'] as List).map((item) => StockUsage.fromJson(item)).toList();
      }

      return [];
    } catch (e) {
      log('Error fetching stock usage by group: $e');
      return [];
    }
  }
}
