import 'package:get/get.dart';
import '../../modules/common/stock_management/data/models/inventory_item_model.dart';
import '../models/stock_alert_model.dart';
import '../models/stock_flow_data_model.dart';
import '../models/stock_usage_model.dart';
import '../services/api_service.dart';

abstract class StockManagementRepository {
  Future<List<InventoryItem>> getAllInventoryItems();
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

  // Mock data for development
  final _mockItems = <InventoryItem>[
    InventoryItem(
      id: '1',
      name: 'Daging Ayam',
      unit: 'Kg',
      category: 'Protein',
      type: 'raw',
      currentPrice: 100000,
      purchases: 0,
      sales: 1100,
      currentStock: 1100,
      minimumStock: 2000,
      stockPercentage: 0.55,
    ),
    InventoryItem(
      id: '2',
      name: 'Sambal Terasi',
      unit: 'Kg',
      category: 'Bumbu',
      type: 'semi-finished',
      currentPrice: 100000,
      purchases: 2000,
      sales: 1000,
      currentStock: 1500,
      minimumStock: 2000,
      stockPercentage: 0.75,
    ),
    InventoryItem(
      id: '3',
      name: 'Telur Ayam',
      unit: 'Kg',
      category: 'Protein',
      type: 'raw',
      currentPrice: 100000,
      purchases: 0,
      sales: 1100,
      currentStock: 1100,
      minimumStock: 2000,
      stockPercentage: 0.55,
    ),
    InventoryItem(
      id: '4',
      name: 'Susu Sapi',
      unit: 'Botol',
      category: 'Minuman',
      type: 'raw',
      currentPrice: 100000,
      purchases: 0,
      sales: 1100,
      currentStock: 1100,
      minimumStock: 1000,
      stockPercentage: 1.0,
    ),
    InventoryItem(
      id: '5',
      name: 'Garam',
      unit: 'Gram',
      category: 'Bumbu',
      type: 'raw',
      currentPrice: 100000,
      purchases: 0,
      sales: 1800,
      currentStock: 200,
      minimumStock: 1000,
      stockPercentage: 0.2,
    ),
    InventoryItem(
      id: '6',
      name: 'Gula',
      unit: 'Gram',
      category: 'Bumbu',
      type: 'raw',
      currentPrice: 100000,
      purchases: 0,
      sales: 500,
      currentStock: 1500,
      minimumStock: 5000,
      stockPercentage: 0.3,
    ),
    InventoryItem(
      id: '7',
      name: 'Air Mineral',
      unit: 'Ml',
      category: 'Minuman',
      type: 'raw',
      currentPrice: 100000,
      purchases: 0,
      sales: 500,
      currentStock: 1500,
      minimumStock: 1000,
      stockPercentage: 1.0,
    ),
  ];

  final _mockAlerts = <StockAlert>[
    StockAlert(
      id: '1',
      name: 'Lada Bubuk',
      category: 'Bumbu',
      amount: '100 gr',
      stock: 'Bahan',
      alertLevel: 0.23,
      unitId: "1",
      unitName: "kg",
    ),
    StockAlert(
      id: '2',
      name: 'Santan kelapa',
      category: 'Bumbu',
      amount: '200 ml',
      stock: 'Bahan',
      alertLevel: 0.29,
      unitId: "2",
      unitName: "ml",
    ),
    StockAlert(
      id: '3',
      name: 'Telur Asin',
      category: 'Protein',
      amount: '5 Butir',
      stock: 'Bahan',
      alertLevel: 0.29,
      unitId: "3",
      unitName: "butir",
    ),
    StockAlert(
      id: '4',
      name: 'Syrup Chocolate',
      category: 'Minuman',
      amount: '500 ml',
      stock: 'Bahan',
      alertLevel: 0.48,
      unitId: "4",
      unitName: "ml",
    ),
    StockAlert(
      id: '5',
      name: 'Telur Asin',
      category: 'Protein',
      amount: '5 Butir',
      stock: 'Bahan',
      alertLevel: 0.29,
      unitId: "5",
      unitName: "butir",
    ),
    StockAlert(
      id: '6',
      name: 'Syrup Chocolate',
      category: 'Minuman',
      amount: '500 ml',
      stock: 'Bahan',
      alertLevel: 0.48,
      unitId: "6",
      unitName: "ml",
    ),
    StockAlert(
      id: '7',
      name: 'Baking Soda',
      category: 'Bumbu',
      amount: '120 ml',
      stock: 'Bahan',
      alertLevel: 0.48,
      unitId: "7",
      unitName: "ml",
    ),
  ];

  @override
  Future<List<InventoryItem>> getAllInventoryItems() async {
    try {
      // In real implementation, use API call
      // final response = await _apiService.get('/inventory/items');
      // return response.map((json) => InventoryItem.fromJson(json)).toList();

      // Mock implementation
      await Future.delayed(const Duration(milliseconds: 800));
      return _mockItems;
    } catch (e) {
      print('Error fetching inventory items: $e');
      return [];
    }
  }

  @override
  Future<List<StockAlert>> getStockAlerts() async {
    try {
      // In real implementation, use API call
      // final response = await _apiService.get('/inventory/alerts');
      // return response.map((json) => StockAlert.fromJson(json)).toList();

      // Mock implementation
      await Future.delayed(const Duration(milliseconds: 500));
      return _mockAlerts;
    } catch (e) {
      print('Error fetching stock alerts: $e');
      return [];
    }
  }

  @override
  Future<List<StockFlowData>> getStockFlowData() async {
    try {
      // In real implementation, use API call
      // final response = await _apiService.get('/inventory/flow');
      // return response.map((json) => StockFlowData.fromJson(json)).toList();

      // Mock implementation
      await Future.delayed(const Duration(milliseconds: 500));
      return [
        StockFlowData(date: '1 Jul', sales: 100, purchases: 150, wastage: 20),
        StockFlowData(date: '2 Jul', sales: 120, purchases: 120, wastage: 15),
        StockFlowData(date: '3 Jul', sales: 90, purchases: 180, wastage: 25),
        StockFlowData(date: '4 Jul', sales: 110, purchases: 100, wastage: 10),
        StockFlowData(date: '5 Jul', sales: 130, purchases: 90, wastage: 18),
      ];
    } catch (e) {
      print('Error fetching stock flow data: $e');
      return [];
    }
  }

  @override
  Future<List<StockUsage>> getStockUsageByGroup() async {
    try {
      // In real implementation, use API call
      // final response = await _apiService.get('/inventory/usage');
      // return response.map((json) => StockUsage.fromJson(json)).toList();

      // Mock implementation
      await Future.delayed(const Duration(milliseconds: 500));
      return [
        StockUsage(id: "1", category: 'Protein', percentage: 35, color: '#E94235'),
        StockUsage(id: "2", category: 'Bumbu', percentage: 25, color: '#4285F4'),
        StockUsage(id: "3", category: 'Sayuran', percentage: 20, color: '#34A853'),
        StockUsage(id: "4", category: 'Minuman', percentage: 15, color: '#FBBC05'),
        StockUsage(id: "5", category: 'Lainnya', percentage: 5, color: '#9AA0A6'),
      ];
    } catch (e) {
      print('Error fetching stock usage data: $e');
      return [];
    }
  }

  @override
  Future<InventoryItem> getInventoryItemById(String id) async {
    try {
      // In real implementation, use API call
      // final response = await _apiService.get('/inventory/items/$id');
      // return InventoryItem.fromJson(response);

      // Mock implementation
      await Future.delayed(const Duration(milliseconds: 300));
      final item = _mockItems.firstWhere((item) => item.id == id);
      return item;
    } catch (e) {
      print('Error fetching inventory item: $e');
      throw Exception('Failed to load item');
    }
  }

  @override
  Future<void> addInventoryItem(InventoryItem item) async {
    try {
      // In real implementation, use API call
      // await _apiService.post('/inventory/items', item.toJson());

      // Mock implementation
      await Future.delayed(const Duration(milliseconds: 500));
      // Update would happen on the server
    } catch (e) {
      print('Error adding inventory item: $e');
      throw Exception('Failed to add item');
    }
  }

  @override
  Future<void> updateInventoryItem(InventoryItem item) async {
    try {
      // In real implementation, use API call
      // await _apiService.put('/inventory/items/${item.id}', item.toJson());

      // Mock implementation
      await Future.delayed(const Duration(milliseconds: 500));
      // Update would happen on the server
    } catch (e) {
      print('Error updating inventory item: $e');
      throw Exception('Failed to update item');
    }
  }

  @override
  Future<void> deleteInventoryItem(String id) async {
    try {
      // In real implementation, use API call
      // await _apiService.delete('/inventory/items/$id');

      // Mock implementation
      await Future.delayed(const Duration(milliseconds: 500));
      // Delete would happen on the server
    } catch (e) {
      print('Error deleting inventory item: $e');
      throw Exception('Failed to delete item');
    }
  }

  @override
  Future<void> recordStockPurchase(String itemId, int quantity, double price) async {
    try {
      // In real implementation, use API call
      // await _apiService.post('/inventory/purchases', {
      //   'item_id': itemId,
      //   'quantity': quantity,
      //   'price': price,
      // });

      // Mock implementation
      await Future.delayed(const Duration(milliseconds: 500));
      // Update would happen on the server
    } catch (e) {
      print('Error recording stock purchase: $e');
      throw Exception('Failed to record purchase');
    }
  }

  @override
  Future<void> recordStockUsage(String itemId, int quantity, String reason) async {
    try {
      // In real implementation, use API call
      // await _apiService.post('/inventory/usage', {
      //   'item_id': itemId,
      //   'quantity': quantity,
      //   'reason': reason,
      // });

      // Mock implementation
      await Future.delayed(const Duration(milliseconds: 500));
      // Update would happen on the server
    } catch (e) {
      print('Error recording stock usage: $e');
      throw Exception('Failed to record usage');
    }
  }
}
