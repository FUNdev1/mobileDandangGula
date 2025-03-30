import 'dart:developer';

import 'package:get/get.dart';
import '../../modules/common/stock_management/data/models/inventory_item_model.dart';
import '../models/stock_alert_model.dart';
import '../models/stock_flow_data_model.dart';
import '../models/stock_usage_model.dart';
import '../services/api_service.dart';

abstract class StockManagementRepository {
  Future<List<InventoryItem>> getAllInventoryItems({int page});
  Future<List<StockAlert>> getStockAlerts();
  Future<List<StockFlowData>> getStockFlowData();
  Future<List<StockUsage>> getStockUsageByGroup();
  Future<InventoryItem> getInventoryItemById(String id);
  Future<void> addInventoryItem(InventoryItem item);
  Future<void> updateInventoryItem(InventoryItem item);
  Future<void> deleteInventoryItem(String id);
  Future<void> recordStockPurchase(String itemId, int quantity, double price);
  Future<void> recordStockUsage(String itemId, int quantity, String reason);
}

class StockManagementRepositoryImpl extends GetxService implements StockManagementRepository {
  final ApiService _apiService = Get.find<ApiService>();

  @override
  Future<List<InventoryItem>> getAllInventoryItems({int page = 1}) async {
    try {
      final response = await _apiService.get('/inventory/items');

      if (response is List) {
        return response.map((item) => InventoryItem.fromJson(item)).toList();
      } else {
        log('Error: Unexpected response format from inventory items API');
        return [];
      }
    } catch (e) {
      log('Error fetching inventory items: $e');
      return [];
    }
  }

  @override
  Future<List<StockAlert>> getStockAlerts() async {
    try {
      final response = await _apiService.get('/inventory/alerts');

      if (response is List) {
        return response.map((alert) => StockAlert.fromJson(alert)).toList();
      } else {
        log('Error: Unexpected response format from stock alerts API');
        return [];
      }
    } catch (e) {
      log('Error fetching stock alerts: $e');
      return [];
    }
  }

  @override
  Future<List<StockFlowData>> getStockFlowData() async {
    try {
      final response = await _apiService.get('/inventory/flow');

      if (response is List) {
        return response.map((data) => StockFlowData.fromJson(data)).toList();
      } else {
        log('Error: Unexpected response format from stock flow API');
        return [];
      }
    } catch (e) {
      log('Error fetching stock flow data: $e');
      return [];
    }
  }

  @override
  Future<List<StockUsage>> getStockUsageByGroup() async {
    try {
      final response = await _apiService.get('/inventory/usage-by-group');

      if (response is List) {
        return response.map((usage) => StockUsage.fromJson(usage)).toList();
      } else {
        log('Error: Unexpected response format from stock usage API');
        return [];
      }
    } catch (e) {
      log('Error fetching stock usage data: $e');
      return [];
    }
  }

  @override
  Future<InventoryItem> getInventoryItemById(String id) async {
    try {
      final response = await _apiService.get('/inventory/items/$id');
      return InventoryItem.fromJson(response);
    } catch (e) {
      log('Error fetching inventory item: $e');
      throw Exception('Failed to load item');
    }
  }

  @override
  Future<void> addInventoryItem(InventoryItem item) async {
    try {
      await _apiService.post('/inventory/items', body: item.toJson());
    } catch (e) {
      log('Error adding inventory item: $e');
      throw Exception('Failed to add item');
    }
  }

  @override
  Future<void> updateInventoryItem(InventoryItem item) async {
    try {
      await _apiService.put('/inventory/items/${item.id}', body: item.toJson());
    } catch (e) {
      log('Error updating inventory item: $e');
      throw Exception('Failed to update item');
    }
  }

  @override
  Future<void> deleteInventoryItem(String id) async {
    try {
      await _apiService.delete('/inventory/items/$id');
    } catch (e) {
      log('Error deleting inventory item: $e');
      throw Exception('Failed to delete item');
    }
  }

  @override
  Future<void> recordStockPurchase(String itemId, int quantity, double price) async {
    try {
      await _apiService.post('/inventory/purchases', body: {
        'item_id': itemId,
        'quantity': quantity,
        'price': price,
      });
    } catch (e) {
      log('Error recording stock purchase: $e');
      throw Exception('Failed to record purchase');
    }
  }

  @override
  Future<void> recordStockUsage(String itemId, int quantity, String reason) async {
    try {
      await _apiService.post('/inventory/usage', body: {
        'item_id': itemId,
        'quantity': quantity,
        'reason': reason,
      });
    } catch (e) {
      log('Error recording stock usage: $e');
      throw Exception('Failed to record usage');
    }
  }
}
