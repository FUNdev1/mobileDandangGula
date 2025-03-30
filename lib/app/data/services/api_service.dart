import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ApiService extends GetxService {
  final String baseUrl;
  String? token;

  // Add a development mode flag
  final bool devMode = false; // Set to true during development, false when API is ready

  // Headers yang akan disertakan di setiap request
  late Map<String, String> _headers;

  ApiService({required this.baseUrl}) {
    _headers = {
      'Content-Type': 'application/json',
    };
  }

  // Metode untuk set token setelah login
  void setAuthToken(String newToken) {
    token = newToken;
    _headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // GET request
  Future<dynamic> get(String endpoint, {Map<String, dynamic>? queryParams}) async {
    // In development mode, immediately return mock data without API call
    if (devMode) {
      log('DEV MODE: Melewatkan GET request ke $endpoint');
      await Future.delayed(const Duration(milliseconds: 200));
      return _getMockData(endpoint, queryParams);
    }

    try {
      final uri = Uri.parse('$baseUrl$endpoint').replace(
        queryParameters: queryParams,
      );

      log('GET Request: $uri');
      log('Headers: $_headers');

      final response = await http
          .get(
            uri,
            headers: _headers,
          )
          .timeout(const Duration(seconds: 30));

      return _processResponse(response);
    } catch (e) {
      log('GET Error: $e');
      throw Exception('Failed to perform GET request: $e');
    }
  }

  // POST request
  Future<dynamic> post(String endpoint, {dynamic body}) async {
    // In development mode, immediately return mock data without API call
    if (devMode) {
      log('DEV MODE: Skipping POST request to $endpoint');
      await Future.delayed(const Duration(milliseconds: 200));
      return _getMockData(endpoint, body);
    }

    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      log('POST Request: $uri');

      if (body is FormData) {
        // FormData kustom, gunakan implementasinya secara langsung
        var headers = Map<String, String>.from(_headers);
        headers['Content-Type'] = 'multipart/form-data; boundary=${body.boundary}';

        // Konversi FormData ke bytes
        final bytes = await body.toBytes();

        // Kirim request menggunakan http.post dengan bytes
        final response = await http
            .post(
              uri,
              headers: headers,
              body: bytes,
            )
            .timeout(const Duration(seconds: 30));

        return _processResponse(response);
      } else {
        // Regular JSON body
        log('POST Body: $body');
        final response = await http
            .post(
              uri,
              headers: _headers,
              body: body != null ? jsonEncode(body) : null,
            )
            .timeout(const Duration(seconds: 30));

        return _processResponse(response);
      }
    } catch (e) {
      log('POST Error: $e');
      throw Exception('Failed to perform POST request: $e');
    }
  }

  // PUT request
  Future<dynamic> put(String endpoint, {Map<String, dynamic>? body}) async {
    // In development mode, immediately return mock data without API call
    if (devMode) {
      log('DEV MODE: Skipping PUT request to $endpoint');
      await Future.delayed(const Duration(milliseconds: 200)); // Small delay to simulate network
      return _getMockData(endpoint, body);
    }

    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      log('PUT Request: $uri');

      final response = await http
          .put(
            uri,
            headers: _headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(const Duration(seconds: 30));

      return _processResponse(response);
    } catch (e) {
      log('PUT Error: $e');
      throw Exception('Failed to perform PUT request: $e');
    }
  }

  // DELETE request
  Future<dynamic> delete(String endpoint) async {
    // In development mode, immediately return mock data without API call
    if (devMode) {
      log('DEV MODE: Skipping DELETE request to $endpoint');
      await Future.delayed(const Duration(milliseconds: 200)); // Small delay to simulate network
      return {'success': true}; // Simple success response for delete
    }

    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      log('DELETE Request: $uri');

      final response = await http
          .delete(
            uri,
            headers: _headers,
          )
          .timeout(const Duration(seconds: 30));

      return _processResponse(response);
    } catch (e) {
      log('DELETE Error: $e');
      throw Exception('Failed to perform DELETE request: $e');
    }
  }

  // Process response dan handle errors
  dynamic _processResponse(http.Response response) {
    log('Response Status Code: ${response.statusCode}');
    log('Response Body: ${response.body}');

    final responseBody = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return responseBody;
    } else {
      // Pesan error spesifik dari API
      final errorMessage = responseBody['message'] ?? 'Terjadi kesalahan pada server';
      throw Exception(errorMessage);
    }
  }

  // Fungsi mock data tetap dipertahankan untuk mode development
  dynamic _getMockData(String endpoint, [dynamic params]) {
    // Basic mock data patterns based on endpoint structure
    if (endpoint.contains('/branches')) {
      if (endpoint == '/branches') {
        // Return list of branches
        return [
          {
            'id': '1',
            'name': 'Kedai Dandang Gula MT. Haryono',
            'address': 'Jl. MT. Haryono No. 10',
            'phone': '021-1234567',
            'email': 'haryono@dandanggula.com',
            'managerId': '101',
            'managerName': 'Joe Heiden',
            'income': 10000000.0, // Use doubles for numeric values
            'cogs': 45000000.0,
            'netProfit': 5000000.0,
            'percentChange': -9.75,
          },
          {
            'id': '2',
            'name': 'Kedai Dandang Gula Margonda',
            'address': 'Jl. Margonda Raya No. 525',
            'phone': '021-8765432',
            'email': 'margonda@dandanggula.com',
            'managerId': '102',
            'managerName': 'Martha Elbert',
            'income': 12000000.0,
            'cogs': 48000000.0,
            'netProfit': 6000000.0,
            'percentChange': 5.25,
          },
          {
            'id': '3',
            'name': 'Kedai Dandang Gula Sentul',
            'address': 'Jl. Sentul No. 100',
            'phone': '021-9876543',
            'email': 'sentul@dandanggula.com',
            'managerId': '103',
            'managerName': 'John Smith',
            'income': 8000000.0,
            'cogs': 35000000.0,
            'netProfit': 4500000.0,
            'percentChange': 3.42,
          },
        ];
      } else if (endpoint.contains('/branches/') && endpoint.endsWith('/revenue-expense')) {
        final data = [];
        for (int i = 1; i <= 8; i++) {
          data.add({
            'date': DateTime(2023, 1, i + 10).toIso8601String(),
            'revenue': 1500000.0 + (i * 100000.0),
            'expense': 1000000.0 + (i * 50000.0 * (i % 3 == 0 ? 1.2 : 0.8)),
          });
        }

        return data;
      } else if (endpoint.contains('/branches/') && endpoint.contains('/chart')) {
        // This will correctly match endpoints like "/branches/1/chart"
        log('Generating mock data for branch chart: $endpoint');
        final data = [];
        for (int i = 1; i <= 8; i++) {
          data.add({
            'label': '$i',
            'value': 1500000.0 + (i * 100000.0 * (i % 3 == 0 ? 0.8 : 1.2)),
            'date': DateTime(2023, 1, i + 10).toIso8601String(),
          });
        }
        return data;
      }
    } else if (endpoint.contains('/branches/') && endpoint.contains('/revenue')) {
      // Branch revenue data
      // Extract branch ID from the URL
      final branchId = int.tryParse(endpoint.split('/')[2]) ?? 1;

      return {
        'revenue': 1500000.0 * (branchId * 0.2),
        'cogs': 900000.0 * (branchId * 0.15),
        'netProfit': 600000.0 * (branchId * 0.25),
        'growth': 3.5 * (branchId % 3 == 0 ? -1 : 1),
      };
    } else if (endpoint.contains('/dashboard')) {
      if (endpoint == '/dashboard/summary') {
        return {
          'totalIncome': 50000000.0, // Use doubles
          'netProfit': 3000000.0,
          'percentChange': -9.75,
        };
      } else if (endpoint.contains('/dashboard/sales-performance')) {
        // Sales performance data - return as list
        final data = [];
        for (int i = 1; i <= 8; i++) {
          data.add({
            'label': '$i',
            'value': 1500000.0 + (i * 100000.0 * (i % 3 == 0 ? 0.8 : 1.2)), // Use doubles
            'date': DateTime(2023, 1, i + 10).toIso8601String(),
          });
        }
        return data;
      } else if (endpoint.contains('/revenue-chart')) {
        // Return as list for chart data
        final data = [];
        for (int i = 1; i <= 8; i++) {
          data.add({
            'label': 'Jan $i',
            'value': 10000000.0 + (i * 500000.0 * (i % 3 == 0 ? -1 : 1)), // Use doubles
            'date': DateTime(2023, 1, i + 10).toIso8601String(),
          });
        }
        return data;
      } else if (endpoint == '/dashboard/total-revenue') {
        return {
          'revenue': 50000000.0,
        };
      } else if (endpoint == '/dashboard/total-profit') {
        return {
          'profit': 3000000.0,
        };
      } else if (endpoint == '/dashboard/revenue-growth') {
        return {
          'growth': -9.75,
        };
      }
    }
    // Stock Management Mock Data
    else if (endpoint.startsWith('/inventory')) {
      // Inventory items endpoint
      if (endpoint == '/inventory/items') {
        return [
          {
            'id': '1',
            'name': 'Daging Ayam',
            'unit': 'Kg',
            'category': 'Protein',
            'type': 'raw',
            'current_price': 100000,
            'purchases': 0,
            'sales': 1100,
            'current_stock': 1100,
            'minimum_stock': 2000,
            'stock_percentage': 0.55,
          },
          {
            'id': '2',
            'name': 'Sambal Terasi',
            'unit': 'Kg',
            'category': 'Bumbu',
            'type': 'semi-finished',
            'current_price': 100000,
            'purchases': 2000,
            'sales': 1000,
            'current_stock': 1500,
            'minimum_stock': 2000,
            'stock_percentage': 0.75,
          },
          {
            'id': '3',
            'name': 'Telur Ayam',
            'unit': 'Kg',
            'category': 'Protein',
            'type': 'raw',
            'current_price': 100000,
            'purchases': 0,
            'sales': 1100,
            'current_stock': 1100,
            'minimum_stock': 2000,
            'stock_percentage': 0.55,
          },
          {
            'id': '4',
            'name': 'Susu Sapi',
            'unit': 'Botol',
            'category': 'Minuman',
            'type': 'raw',
            'current_price': 100000,
            'purchases': 0,
            'sales': 1100,
            'current_stock': 1100,
            'minimum_stock': 1000,
            'stock_percentage': 1.0,
          },
          {
            'id': '5',
            'name': 'Garam',
            'unit': 'Gram',
            'category': 'Bumbu',
            'type': 'raw',
            'current_price': 100000,
            'purchases': 0,
            'sales': 1800,
            'current_stock': 200,
            'minimum_stock': 1000,
            'stock_percentage': 0.2,
          },
          {
            'id': '6',
            'name': 'Gula',
            'unit': 'Gram',
            'category': 'Bumbu',
            'type': 'raw',
            'current_price': 100000,
            'purchases': 0,
            'sales': 500,
            'current_stock': 1500,
            'minimum_stock': 5000,
            'stock_percentage': 0.3,
          },
          {
            'id': '7',
            'name': 'Air Mineral',
            'unit': 'Ml',
            'category': 'Minuman',
            'type': 'raw',
            'current_price': 100000,
            'purchases': 0,
            'sales': 500,
            'current_stock': 1500,
            'minimum_stock': 1000,
            'stock_percentage': 1.0,
          },
          {
            'id': '8',
            'name': 'Mayonaise',
            'unit': 'Kg',
            'category': 'Bumbu',
            'type': 'semi-finished',
            'current_price': 100000,
            'purchases': 2000,
            'sales': 500,
            'current_stock': 1500,
            'minimum_stock': 1000,
            'stock_percentage': 1.0,
          },
          {
            'id': '9',
            'name': 'Sambal Terasi',
            'unit': 'Kg',
            'category': 'Bumbu',
            'type': 'semi-finished',
            'current_price': 100000,
            'purchases': 0,
            'sales': 1100,
            'current_stock': 1100,
            'minimum_stock': 2000,
            'stock_percentage': 0.55,
          },
          {
            'id': '10',
            'name': 'Bumbu Treng',
            'unit': 'Kg',
            'category': 'Bumbu',
            'type': 'semi-finished',
            'current_price': 100000,
            'purchases': 0,
            'sales': 0,
            'current_stock': 1100,
            'minimum_stock': 1000,
            'stock_percentage': 1.0,
          },
          {
            'id': '11',
            'name': 'Meat Hamburg',
            'unit': 'Botol',
            'category': 'Protein',
            'type': 'semi-finished',
            'current_price': 100000,
            'purchases': 0,
            'sales': 0,
            'current_stock': 1100,
            'minimum_stock': 1000,
            'stock_percentage': 1.0,
          },
        ];
      }
      // Stock alerts endpoint - disesuaikan dengan model StockAlert yang sudah ada
      else if (endpoint == '/inventory/alerts') {
        return [
          {
            'id': '1',
            'name': 'Lada Bubuk',
            'category': 'Bumbu',
            'stock': 'Bahan',
            'amount': '100 gr',
            'alert_level': 0.23,
            'image_url': null,
            'unit_id': '1',
            'unit_name': 'kg',
          },
          {
            'id': '2',
            'name': 'Santan kelapa',
            'category': 'Bumbu',
            'stock': 'Bahan',
            'amount': '200 ml',
            'alert_level': 0.29,
            'image_url': null,
            'unit_id': '2',
            'unit_name': 'ml',
          },
          {
            'id': '3',
            'name': 'Telur Asin',
            'category': 'Protein',
            'stock': 'Bahan',
            'amount': '5 Butir',
            'alert_level': 0.29,
            'image_url': null,
            'unit_id': '3',
            'unit_name': 'butir',
          },
          {
            'id': '4',
            'name': 'Syrup Chocolate',
            'category': 'Minuman',
            'stock': 'Bahan',
            'amount': '500 ml',
            'alert_level': 0.48,
            'image_url': null,
            'unit_id': '4',
            'unit_name': 'ml',
          },
          {
            'id': '5',
            'name': 'Telur Asin',
            'category': 'Protein',
            'stock': 'Bahan',
            'amount': '5 Butir',
            'alert_level': 0.29,
            'image_url': null,
            'unit_id': '5',
            'unit_name': 'butir',
          },
          {
            'id': '6',
            'name': 'Syrup Chocolate',
            'category': 'Minuman',
            'stock': 'Bahan',
            'amount': '500 ml',
            'alert_level': 0.48,
            'image_url': null,
            'unit_id': '6',
            'unit_name': 'ml',
          },
        ];
      }
      // Stock flow data endpoint
      else if (endpoint == '/inventory/flow') {
        return [
          {'date': '1 Jul', 'sales': 100, 'purchases': 150, 'wastage': 20},
          {'date': '2 Jul', 'sales': 120, 'purchases': 120, 'wastage': 15},
          {'date': '3 Jul', 'sales': 90, 'purchases': 180, 'wastage': 25},
          {'date': '4 Jul', 'sales': 110, 'purchases': 100, 'wastage': 10},
          {'date': '5 Jul', 'sales': 130, 'purchases': 90, 'wastage': 18},
          {'date': '6 Jul', 'sales': 95, 'purchases': 140, 'wastage': 22},
          {'date': '7 Jul', 'sales': 115, 'purchases': 130, 'wastage': 12},
        ];
      }
      // Stock usage by group endpoint - disesuaikan dengan model StockUsage yang sudah ada
      else if (endpoint == '/inventory/usage-by-group') {
        return [
          {'id': '1', 'category': 'Protein', 'percentage': 35.0, 'color': '#E94235', 'usage_count': 120, 'usage_amount': 325.5, 'unit_id': '1', 'unit_name': 'kg'},
          {'id': '2', 'category': 'Bumbu', 'percentage': 25.0, 'color': '#4285F4', 'usage_count': 85, 'usage_amount': 156.2, 'unit_id': '2', 'unit_name': 'kg'},
          {'id': '3', 'category': 'Sayuran', 'percentage': 20.0, 'color': '#34A853', 'usage_count': 65, 'usage_amount': 95.8, 'unit_id': '3', 'unit_name': 'kg'},
          {'id': '4', 'category': 'Minuman', 'percentage': 15.0, 'color': '#FBBC05', 'usage_count': 42, 'usage_amount': 185.3, 'unit_id': '4', 'unit_name': 'liter'},
          {'id': '5', 'category': 'Lainnya', 'percentage': 5.0, 'color': '#9AA0A6', 'usage_count': 18, 'usage_amount': 42.5, 'unit_id': '5', 'unit_name': 'kg'},
        ];
      }
      // Get specific inventory item
      else if (endpoint.startsWith('/inventory/items/') && endpoint.split('/').length == 4) {
        String id = endpoint.split('/').last;
        // Return a single item based on ID
        return {
          'id': id,
          'name': 'Item $id',
          'unit': 'Kg',
          'category': 'Bumbu',
          'type': id.contains('1') ? 'raw' : 'semi-finished',
          'current_price': 100000,
          'purchases': 1000,
          'sales': 800,
          'current_stock': 1200,
          'minimum_stock': 1000,
          'stock_percentage': 1.2,
        };
      }
      // For create, update, and delete operations
      else if (endpoint == '/inventory/purchases') {
        return {'success': true, 'message': 'Stock purchase recorded successfully'};
      } else if (endpoint == '/inventory/usage') {
        return {'success': true, 'message': 'Stock usage recorded successfully'};
      }
    }

    // Default fallback mock data for any other endpoint
    return {'success': true, 'message': 'Mock data for endpoint: $endpoint', 'data': []};
  }
}
