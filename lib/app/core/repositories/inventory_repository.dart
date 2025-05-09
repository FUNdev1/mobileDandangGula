import 'dart:developer';
import 'package:get/get.dart';
import '../models/stock_model.dart';
import '../services/api_service.dart';

abstract class InventoryRepository {
  // Stock Groups
  Future<List<StockGroup>> getAllStockGroups();
  Future<Map<String, dynamic>> createStockGroup(String groupName);
  Future<Map<String, dynamic>> updateStockGroup(String id, String groupName);
  Future<Map<String, dynamic>> deleteStockGroup(String id);

  // Units of Measurement
  Future<List<UnitOfMeasurement>> getAllUom();

  // Stock Items
  Future<Map<String, dynamic>> getStockItemsPage({
    int page = 1,
    int pageSize = 10,
    String type = 'raw',
    String search = '',
    String? groupId,
  });

  Future<StockItem?> getStockItemDetail(String id);

  Future<Map<String, dynamic>> createRawStockItem(Map<String, dynamic> itemData);
  Future<Map<String, dynamic>> createSemiFinishedStockItem(Map<String, dynamic> itemData);

  Future<Map<String, dynamic>> updateStockItem(String id, Map<String, dynamic> itemData);
  Future<Map<String, dynamic>> deleteStockItem(String id);

  // Stock Operations
  Future<Map<String, dynamic>> recordStockPurchase(Map<String, dynamic> purchaseData);
  Future<Map<String, dynamic>> recordStockProduction(Map<String, dynamic> productionData);
  Future<Map<String, dynamic>> performStockOpname(List<Map<String, dynamic>> stockData);

  // Stock Monitoring
  Future<List<StockAlert>> getStockAlerts();
  Future<List<StockItem>> getLowStockItems();
}

class InventoryRepositoryImpl implements InventoryRepository {
  final ApiService _apiService = Get.find<ApiService>();

  // Stock Groups
  @override
  Future<List<StockGroup>> getAllStockGroups() async {
    try {
      final response = await _apiService.get('/stockgroup');

      if (response is Map<String, dynamic> && response.containsKey('data') && response['data'] is List) {
        return (response['data'] as List).map((group) => StockGroup.fromJson(group)).toList();
      }

      return [];
    } catch (e) {
      log('Error fetching stock groups: $e');
      return [];
    }
  }

  @override
  Future<Map<String, dynamic>> createStockGroup(String groupName) async {
    try {
      final response = await _apiService.post(
        '/stockgroup/create',
        body: {'group_name': groupName},
      );

      return response;
    } catch (e) {
      log('Error creating stock group: $e');
      return {'success': false, 'message': 'Failed to create stock group: $e'};
    }
  }

  @override
  Future<Map<String, dynamic>> updateStockGroup(String id, String groupName) async {
    try {
      final response = await _apiService.put(
        '/stockgroup/update/$id',
        body: {'group_name': groupName},
      );

      return response;
    } catch (e) {
      log('Error updating stock group: $e');
      return {'success': false, 'message': 'Failed to update stock group: $e'};
    }
  }

  @override
  Future<Map<String, dynamic>> deleteStockGroup(String id) async {
    try {
      final response = await _apiService.delete('/stockgroup/delete/$id');
      return response;
    } catch (e) {
      log('Error deleting stock group: $e');
      return {'success': false, 'message': 'Failed to delete stock group: $e'};
    }
  }

  // Units of Measurement
  @override
  Future<List<UnitOfMeasurement>> getAllUom() async {
    try {
      final response = await _apiService.get('/stock/uom');

      if (response is Map<String, dynamic> && response.containsKey('data') && response['data'] is List) {
        return (response['data'] as List).map((uom) => UnitOfMeasurement.fromJson(uom)).toList();
      }

      return [];
    } catch (e) {
      log('Error fetching UOM: $e');
      return [];
    }
  }

  // Stock Items
  @override
  Future<Map<String, dynamic>> getStockItemsPage({
    int page = 1,
    int pageSize = 10,
    String type = 'raw',
    String search = '',
    String? groupId,
  }) async {
    try {
      final Map<String, dynamic> requestData = {
        'page': page,
        'pageSize': pageSize,
        'type': type,
        'search': search,
      };

      if (groupId != null && groupId.isNotEmpty) {
        requestData['group'] = groupId;
      }

      final response = await _apiService.post('/stock/lists', body: requestData);
      return response;
    } catch (e) {
      log('Error fetching stock items: $e');
      return {'success': false, 'message': 'Error: $e', 'data': []};
    }
  }

  @override
  Future<StockItem?> getStockItemDetail(String id) async {
    try {
      final response = await _apiService.get('/stock/detail/$id');

      if (response is Map<String, dynamic> && response.containsKey('data') && response['success'] == true) {
        return StockItem.fromJson(response['data']);
      }

      return null;
    } catch (e) {
      log('Error fetching stock item detail: $e');
      return null;
    }
  }

  @override
  Future<Map<String, dynamic>> createRawStockItem(Map<String, dynamic> itemData) async {
    try {
      // Make sure type is set to 'raw'
      final Map<String, dynamic> data = Map<String, dynamic>.from(itemData);
      data['type'] = 'raw';

      // Required fields validation
      if (!data.containsKey('name') || !data.containsKey('uom') || !data.containsKey('uom_buy') || !data.containsKey('conversion') || !data.containsKey('stock_limit')) {
        return {
          'success': false,
          'message': 'Missing required fields for raw stock item',
        };
      }

      final response = await _apiService.post('/stock/create', body: data);
      return response;
    } catch (e) {
      log('Error creating raw stock item: $e');
      return {'success': false, 'message': 'Failed to create raw stock item: $e'};
    }
  }

  @override
  Future<Map<String, dynamic>> createSemiFinishedStockItem(Map<String, dynamic> itemData) async {
    try {
      // Make sure type is set to 'semifinished'
      final Map<String, dynamic> data = Map<String, dynamic>.from(itemData);
      data['type'] = 'semifinished';

      // Required fields validation for semi-finished
      if (!data.containsKey('name') || !data.containsKey('uom') || !data.containsKey('result_per_recipe') || !data.containsKey('stock_limit') || !data.containsKey('price') || !data.containsKey('recipe') || !(data['recipe'] is List)) {
        return {
          'success': false,
          'message': 'Missing required fields for semi-finished stock item',
        };
      }

      final response = await _apiService.post('/stock/create', body: data);
      return response;
    } catch (e) {
      log('Error creating semi-finished stock item: $e');
      return {'success': false, 'message': 'Failed to create semi-finished stock item: $e'};
    }
  }

  @override
  Future<Map<String, dynamic>> updateStockItem(String id, Map<String, dynamic> itemData) async {
    try {
      final response = await _apiService.post('/stock/update/$id', body: itemData);
      return response;
    } catch (e) {
      log('Error updating stock item: $e');
      return {'success': false, 'message': 'Failed to update stock item: $e'};
    }
  }

  @override
  Future<Map<String, dynamic>> deleteStockItem(String id) async {
    try {
      final response = await _apiService.delete('/stock/delete/$id');
      return response;
    } catch (e) {
      log('Error deleting stock item: $e');
      return {'success': false, 'message': 'Failed to delete stock item: $e'};
    }
  }

  // Stock Operations
  @override
  Future<Map<String, dynamic>> recordStockPurchase(Map<String, dynamic> purchaseData) async {
    try {
      // Validate purchase data
      if (!purchaseData.containsKey('saldo') || !purchaseData.containsKey('total') || !purchaseData.containsKey('balance') || !purchaseData.containsKey('detail') || !(purchaseData['detail'] is List) || (purchaseData['detail'] as List).isEmpty) {
        return {
          'success': false,
          'message': 'Invalid purchase data format',
        };
      }

      final response = await _apiService.post('/stock/dailyjournal', body: purchaseData);
      return response;
    } catch (e) {
      log('Error recording stock purchase: $e');
      return {'success': false, 'message': 'Failed to record stock purchase: $e'};
    }
  }

  @override
  Future<Map<String, dynamic>> recordStockProduction(Map<String, dynamic> productionData) async {
    try {
      // Validate production data
      if (!productionData.containsKey('stock_id') || !productionData.containsKey('total') || !productionData.containsKey('result') || !productionData.containsKey('price')) {
        return {
          'success': false,
          'message': 'Invalid production data format',
        };
      }

      final response = await _apiService.post('/stock/production', body: productionData);
      return response;
    } catch (e) {
      log('Error recording stock production: $e');
      return {'success': false, 'message': 'Failed to record stock production: $e'};
    }
  }

  @override
  Future<Map<String, dynamic>> performStockOpname(List<Map<String, dynamic>> stockData) async {
    try {
      // Validate each stock item
      for (var item in stockData) {
        if (!item.containsKey('id') || !item.containsKey('stok') || !item.containsKey('selisih')) {
          return {
            'success': false,
            'message': 'Invalid stock opname data format',
          };
        }
      }

      // Kirim data langsung sebagai body request
      final response = await _apiService.post('/stock/opname', body: stockData);

      if (response is Map<String, dynamic>) {
        return response;
      } else {
        return {
          'success': false,
          'message': 'Unexpected response format from server',
        };
      }
    } catch (e) {
      log('Error performing stock opname: $e');
      return {'success': false, 'message': 'Failed to perform stock opname: $e'};
    }
  }

  // Stock Monitoring
  @override
  Future<List<StockAlert>> getStockAlerts() async {
    try {
      final response = await _apiService.get('/stock/limit');

      if (response is Map<String, dynamic> && response.containsKey('data') && response['data'] is List) {
        return (response['data'] as List).map((alert) => StockAlert.fromJson(alert)).toList();
      }

      return [];
    } catch (e) {
      log('Error fetching stock alerts: $e');
      return [];
    }
  }

  @override
  Future<List<StockItem>> getLowStockItems() async {
    try {
      final alerts = await getStockAlerts();
      final List<StockItem> lowStockItems = [];

      // Fetch details for each alert
      for (var alert in alerts) {
        final item = await getStockItemDetail(alert.id);
        if (item != null) {
          lowStockItems.add(item);
        }
      }

      return lowStockItems;
    } catch (e) {
      log('Error fetching low stock items: $e');
      return [];
    }
  }
}
