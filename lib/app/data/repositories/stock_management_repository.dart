import 'dart:developer';

import 'package:get/get.dart';
import '../../modules/common/stock_management/data/models/inventory_item_model.dart';
import '../models/stock_alert_model.dart';
import '../models/stock_flow_data_model.dart';
import '../models/stock_usage_model.dart';
import '../services/api_service.dart';

abstract class StockManagementRepository {
  Future<Map<String, dynamic>> addGroup(Map<String, dynamic> groupData);
  Future<Map<String, dynamic>> updateGroup(String id, Map<String, dynamic> groupData);
  Future<Map<String, dynamic>> deleteGroup(String id);
  Future<Map<String, dynamic>> getListGroup();
  Future<List<InventoryItem>> getAllInventoryItems({int page, String type, String search, String? group, int limit});

  Future<Map<String, dynamic>> getListUom();
  Future<Map<String, dynamic>> recordStockOpname(List<Map<String, dynamic>> stockData);

  Future<List<StockAlert>> getStockAlerts();
  Future<List<StockFlowData>> getStockFlowData();
  Future<List<StockUsage>> getStockUsageByGroup();
  Future<Map<String, dynamic>> getStockDetail(String id);
  Future<Map<String, dynamic>> addInventoryItem(Map<String, dynamic> item);
  Future<Map<String, dynamic>> updateInventoryItem(Map<String, dynamic> item);
  Future<Map<String, dynamic>> deleteInventoryItem(String id);
  Future<Map<String, dynamic>> recordStockPurchase(String itemId, int quantity, double price);
  Future<Map<String, dynamic>> recordStockUsage(String itemId, int quantity, String reason);
}

class StockManagementRepositoryImpl extends GetxService implements StockManagementRepository {
  final ApiService _apiService = Get.find<ApiService>();

  Future<Map<String, dynamic>> getListIngredient() async {
    try {
      final response = await _apiService.get('/stock/ingredient');
      return response;
    } catch (e) {
      log('Error adding group: $e');
      return {};
    }
  }

  @override
  Future<Map<String, dynamic>> getListUom() async {
    try {
      final response = await _apiService.get('/stock/uom');
      return response;
    } catch (e) {
      log('Error adding group: $e');
      return {'success': false, 'message': 'Failed to get list uom group: $e'};
    }
  }

  @override
  Future<Map<String, dynamic>> addGroup(Map<String, dynamic> groupData) async {
    // TODO : 500 Bad Response
    try {
      final response = await _apiService.post('/stockgroup/create', body: groupData);
      return response;
    } catch (e) {
      log('Error adding group: $e');
      return {'success': false, 'message': 'Failed to add group: $e'};
    }
  }

  @override
  Future<Map<String, dynamic>> recordStockOpname(List<Map<String, dynamic>> stockData) async {
    try {
      return await _apiService.post('/stock/opname', body: stockData);
    } catch (e) {
      log('Error recording stock opname: $e');
      throw Exception('Failed to record stock opname: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> updateGroup(String id, Map<String, dynamic> groupData) async {
    try {
      final response = await _apiService.put(
        '/stockgroup/update/:$id',
        body: groupData,
      );
      return response;
    } catch (e) {
      log('Error updating group: $e');
      return {'success': false, 'message': 'Failed to update group: $e'};
    }
  }

  @override
  Future<Map<String, dynamic>> deleteGroup(String id) async {
    try {
      if (id.isEmpty) {
        throw Exception('Group ID cannot be empty');
      }
      final response = await _apiService.delete('/stockgroup/delete/$id');
      return response;
    } catch (e) {
      log('Error deleting group: $e');
      return {'success': false, 'message': 'Failed to delete group: $e'};
    }
  }

  @override
  Future<Map<String, dynamic>> getListGroup() async {
    try {
      final response = await _apiService.get('/stockgroup');
      return response;
    } catch (e) {
      log('Error fetching group list: $e');
      return {};
    }
  }

  @override
  Future<List<InventoryItem>> getAllInventoryItems({
    int page = 1,
    String type = "raw",
    String search = "",
    String? group,
    int limit = 10,
  }) async {
    try {
      final response = await _apiService.post(
        '/stock/lists',
        body: {
          'page': page,
          'pageSize': limit,
          'type': type,
          'search': search,
          'group': group ?? "",
        },
      );

      if (response is Map && response.containsKey('data') && response['data'] is List) {
        return (response['data'] as List).map((item) => InventoryItem.fromJson(item)).toList();
      } else if (response is List) {
        return response.map((item) => InventoryItem.fromJson(item)).toList();
      }

      return [];
    } catch (e) {
      log('Error fetching inventory items: $e');
      return [];
    }
  }

  @override
  Future<List<StockAlert>> getStockAlerts() async {
    try {
      final response = await _apiService.get('/stock/limit');

      if (response is List) {
        return response.map((alert) => StockAlert.fromJson(alert)).toList();
      } else if (response is Map && response.containsKey('data') && response['data'] is List) {
        return (response['data'] as List).map((alert) => StockAlert.fromJson(alert)).toList();
      }

      return [];
    } catch (e) {
      log('Error fetching stock alerts: $e');
      return [];
    }
  }

  @override
  Future<List<StockFlowData>> getStockFlowData() async {
    try {
      // Tidak ada endpoint spesifik di Postman collection
      // Menggunakan mock data untuk sementara (diperoleh dari ApiService._getMockData)
      final response = await _apiService.get('/inventory/flow');

      if (response is List) {
        return response.map((data) => StockFlowData.fromJson(data)).toList();
      } else if (response is Map && response.containsKey('data') && response['data'] is List) {
        return (response['data'] as List).map((data) => StockFlowData.fromJson(data)).toList();
      }

      return [];
    } catch (e) {
      log('Error fetching stock flow data: $e');
      return [];
    }
  }

  @override
  Future<List<StockUsage>> getStockUsageByGroup() async {
    try {
      // Tidak ada endpoint spesifik di Postman collection
      // Menggunakan mock data untuk sementara (diperoleh dari ApiService._getMockData)
      final response = await _apiService.get('/inventory/usage-by-group');

      if (response is List) {
        return response.map((usage) => StockUsage.fromJson(usage)).toList();
      } else if (response is Map && response.containsKey('data') && response['data'] is List) {
        return (response['data'] as List).map((usage) => StockUsage.fromJson(usage)).toList();
      }

      return [];
    } catch (e) {
      log('Error fetching stock usage data: $e');
      return [];
    }
  }

  @override
  Future<Map<String, dynamic>> getStockDetail(String id) async {
    try {
      final response = await _apiService.get('/stock/detail/$id');
      return response;
    } catch (e) {
      log('Error fetching inventory item: $e');
      throw Exception('Failed to load item');
    }
  }

  @override
  Future<Map<String, dynamic>> addInventoryItem(Map<String, dynamic> item) async {
    try {
      return await _apiService.post(
        '/stock/create',
        body: item,
      );
    } catch (e) {
      log('Error adding inventory item: $e');
      throw Exception('Failed to add item: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> updateInventoryItem(Map<String, dynamic> item) async {
    try {
      if (item['type'] == 'raw') {
        return await _apiService.put(
          '/stock/update/${item["id"]}',
          body: item,
        );
      } else {
        // Semi-finished item dengan resep
        return await _apiService.put(
          '/stock/update/${item["id"]}',
          body: item,
        );
      }
    } catch (e) {
      log('Error updating inventory item: $e');
      throw Exception('Failed to update item: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> deleteInventoryItem(String id) async {
    try {
      if (id.isEmpty) {
        throw Exception('ID cannot be empty');
      }
      return await _apiService.delete('/stock/delete/$id');
    } catch (e) {
      log('Error deleting inventory item: $e');
      throw Exception('Failed to delete item: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> recordStockPurchase(String itemId, int quantity, double price) async {
    try {
      if (itemId.isEmpty) {
        throw Exception('Item ID cannot be empty');
      }
      return await _apiService.post('/stock/dailyjournal', body: {
        'saldo': price + 20000, // contoh saldo awal
        'total': price,
        'balance': 20000, // saldo akhir
        'detail': [
          {
            'stock_id': itemId,
            'amount': quantity,
            'uom': 'kg', // sesuaikan dengan unit yang sesuai
            'price': price / quantity,
            'subtotal': price
          }
        ]
      });
    } catch (e) {
      log('Error recording stock purchase: $e');
      throw Exception('Failed to record purchase: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> recordStockUsage(String itemId, int quantity, String reason) async {
    try {
      if (itemId.isEmpty) {
        throw Exception('Item ID cannot be empty');
      }
      // Tidak ada endpoint spesifik di Postman collection
      // Menggunakan endpoint produksi untuk sementara
      return await _apiService.post('/stock/production', body: {
        'stock_id': itemId,
        'total': quantity.toString(),
        'result': (quantity * 1000).toString(), // Asumsi hasil dalam gram
        'price': '0' // Harga kosong untuk penggunaan
      });
    } catch (e) {
      log('Error recording stock usage: $e');
      throw Exception('Failed to record usage: $e');
    }
  }
}
