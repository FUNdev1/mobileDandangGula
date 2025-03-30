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
      final response = await _apiService.post('/stock/lists', body: {
        'page': page,
        'pageSize': 10,
        'type': 'raw', // Default type
        'search': '',
        'group': ''
      });

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
  Future<InventoryItem> getInventoryItemById(String id) async {
    try {
      final response = await _apiService.get('/stock/detail/$id');
      return InventoryItem.fromJson(response);
    } catch (e) {
      log('Error fetching inventory item: $e');
      throw Exception('Failed to load item');
    }
  }

  @override
  Future<void> addInventoryItem(InventoryItem item) async {
    try {
      if (item.type == 'raw') {
        await _apiService.post('/stock/create', body: {'name': item.name, 'uom': item.unitName, 'uom_buy': item.purchaseUnit, 'conversion': item.conversionRate, 'group_id': item.categoryId, 'stock_limit': item.minimumStock, 'type': 'raw'});
      } else {
        // Semi-finished item dengan resep
        await _apiService.post('/stock/create', body: {
          'name': item.name,
          'uom': item.unitName,
          'group_id': item.categoryId,
          'result_per_recipe': item.resultPerRecipe,
          'stock_limit': item.minimumStock,
          'type': 'semifinished',
          'price': item.currentPrice,
          'recipe': item.ingredients?.map((ingredient) => {'raw_id': ingredient.id, 'amount': ingredient.amount, 'uom': ingredient.unit, 'price': ingredient.price}).toList()
        });
      }
    } catch (e) {
      log('Error adding inventory item: $e');
      throw Exception('Failed to add item: $e');
    }
  }

  @override
  Future<void> updateInventoryItem(InventoryItem item) async {
    try {
      if (item.type == 'raw') {
        await _apiService.post('/stock/update/${item.id}', body: {'name': item.name, 'uom': item.unitName, 'uom_buy': item.purchaseUnit, 'conversion': item.conversionRate, 'group_id': item.categoryId, 'stock_limit': item.minimumStock, 'type': 'raw'});
      } else {
        await _apiService.post('/stock/update/${item.id}', body: {
          'name': item.name,
          'uom': item.unitName,
          'group_id': item.categoryId,
          'result_per_recipe': item.resultPerRecipe,
          'stock_limit': item.minimumStock,
          'type': 'semifinished',
          'price': item.currentPrice,
          'recipe': item.ingredients?.map((ingredient) => {'raw_id': ingredient.id, 'amount': ingredient.amount, 'uom': ingredient.unit, 'price': ingredient.price}).toList()
        });
      }
    } catch (e) {
      log('Error updating inventory item: $e');
      throw Exception('Failed to update item: $e');
    }
  }

  @override
  Future<void> deleteInventoryItem(String id) async {
    try {
      await _apiService.delete('/stock/delete/$id');
    } catch (e) {
      log('Error deleting inventory item: $e');
      throw Exception('Failed to delete item: $e');
    }
  }

  @override
  Future<void> recordStockPurchase(String itemId, int quantity, double price) async {
    try {
      await _apiService.post('/stock/dailyjournal', body: {
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
  Future<void> recordStockUsage(String itemId, int quantity, String reason) async {
    try {
      // Tidak ada endpoint spesifik di Postman collection
      // Menggunakan endpoint produksi untuk sementara
      await _apiService.post('/stock/production', body: {
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
