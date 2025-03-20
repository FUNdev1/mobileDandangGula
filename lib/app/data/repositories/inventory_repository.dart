import '../models/stock_alert_model.dart';
import '../models/stock_flow_data_model.dart';
import '../models/stock_usage_model.dart';

abstract class InventoryRepository {
  Future<int> getTotalItems();
  Future<int> getStockEntryCountToday();
  Future<double> getStockEntryValueToday();
  Future<List<StockFlowData>> getStockFlowData();
  Future<List<StockUsage>> getStockUsageByGroup();
  Future<List<StockAlert>> getStockAlerts();
}

class InventoryRepositoryImpl implements InventoryRepository {
  @override
  Future<int> getTotalItems() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return 120;
  }

  @override
  Future<int> getStockEntryCountToday() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return 15;
  }

  @override
  Future<double> getStockEntryValueToday() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return 1000000;
  }

  @override
  Future<List<StockFlowData>> getStockFlowData() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final data = <StockFlowData>[];

    // Generate sample data
    for (int i = 1; i <= 7; i++) {
      data.add(StockFlowData(
        date: '0$i',
        sales: 10 + (i * 2.5),
        purchases: 5 + (i * 3.2 * (i % 2 == 0 ? 0.7 : 1.2)),
        wastage: 2 + (i * 0.8 * (i % 3 == 0 ? 1.5 : 0.5)),
      ));
    }

    return data;
  }

  @override
  Future<List<StockUsage>> getStockUsageByGroup() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      StockUsage(
        id: "1", // Added missing 'id' parameter
        category: 'Sayuran',
        percentage: 32.0,
        color: '#228B22', // Forest Green
      ),
      StockUsage(
        id: "2", // Added missing 'id' parameter
        category: 'Protein',
        percentage: 28.0,
        color: '#136C3A', // Dark Green
      ),
      StockUsage(
        id: "3", // Added missing 'id' parameter
        category: 'Minuman',
        percentage: 18.0,
        color: '#87CEEB', // Sky Blue
      ),
      StockUsage(
        id: "4", // Added missing 'id' parameter
        category: 'Seafood',
        percentage: 12.0,
        color: '#20B2AA', // Light Sea Green
      ),
      StockUsage(
        id: "5", // Added missing 'id' parameter
        category: 'Bumbu',
        percentage: 10.0,
        color: '#90EE90', // Light Green
      ),
    ];
  }

  @override
  Future<List<StockAlert>> getStockAlerts() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      StockAlert(
        id: '1',
        name: 'Daging Ayam',
        category: 'Protein',
        stock: 'Sisa stock',
        amount: '500gr',
        alertLevel: 0.9,
        unitId: '1',
        unitName: 'gram',
      ),
      StockAlert(
        id: '2',
        name: 'Selada',
        category: 'Sayuran',
        stock: 'Sisa stock',
        amount: '500gr',
        alertLevel: 0.85,
        unitId: '1',
        unitName: 'gram',
      ),
      StockAlert(
        id: '3',
        name: 'Susu Full Cream',
        category: 'Minuman',
        stock: 'Sisa stock',
        amount: '500gr',
        alertLevel: 0.2,
        unitId: '1',
        unitName: 'gram',
      ),
      StockAlert(
        id: '4',
        name: 'Tomat',
        category: 'Sayuran',
        stock: 'Sisa stock',
        amount: '500gr',
        alertLevel: 0.7,
        unitId: '1',
        unitName: 'gram',
      ),
      StockAlert(
        id: '5',
        name: 'Telur Ayam',
        category: 'Protein',
        stock: 'Sisa stock',
        amount: '500gr',
        alertLevel: 0.8,
        unitId: '1',
        unitName: 'gram',
      ),
    ];
  }
}
