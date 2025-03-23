import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ApiService extends GetxService {
  final String baseUrl;
  final String apiKey;

  // Add a development mode flag
  final bool devMode = true; // Set to true during development, false when API is ready

  // Headers yang akan disertakan di setiap request
  late Map<String, String> _headers;

  ApiService({required this.baseUrl, required this.apiKey}) {
    _headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };
  }

  // GET request
  Future<dynamic> get(String endpoint, {Map<String, dynamic>? queryParams}) async {
    // In development mode, immediately return mock data without API call
    if (devMode) {
      log('DEV MODE: Skipping GET request to $endpoint');
      await Future.delayed(const Duration(milliseconds: 200)); // Small delay to simulate network
      return _getMockData(endpoint, queryParams);
    }

    try {
      final uri = Uri.parse('$baseUrl$endpoint').replace(
        queryParameters: queryParams,
      );

      log('GET Request: $uri');

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
  Future<dynamic> post(String endpoint, {Map<String, dynamic>? body}) async {
    // In development mode, immediately return mock data without API call
    if (devMode) {
      log('DEV MODE: Skipping POST request to $endpoint');
      await Future.delayed(const Duration(milliseconds: 200)); // Small delay to simulate network
      return _getMockData(endpoint, body);
    }

    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      log('POST Request: $uri');
      log('POST Body: $body');

      final response = await http
          .post(
            uri,
            headers: _headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(const Duration(seconds: 30));

      return _processResponse(response);
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

  // Process response and handle errors
  dynamic _processResponse(http.Response response) {
    log('Response Status Code: ${response.statusCode}');
    log('Response Body: ${response.body}');

    switch (response.statusCode) {
      case 200:
      case 201:
        // Parse response body
        try {
          return jsonDecode(response.body);
        } catch (e) {
          return response.body;
        }

      case 400:
        throw Exception('Bad request: ${response.body}');

      case 401:
        throw Exception('Unauthorized: ${response.body}');

      case 403:
        throw Exception('Forbidden: ${response.body}');

      case 404:
        throw Exception('Not found: ${response.body}');

      case 500:
      case 502:
      case 503:
        throw Exception('Server error: ${response.body}');

      default:
        throw Exception('Request failed with status: ${response.statusCode}');
    }
  }

  // Helper method to generate appropriate mock data based on endpoint
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
    } else if (endpoint.contains('/chart')) {
      // Chart data for a branch - return as list
      final chartData = [];
      for (int i = 1; i <= 8; i++) {
        chartData.add({
          'label': 'Jan $i',
          'value': 5000000.0 + (i * 300000.0 * (i % 4 == 0 ? -1 : 1)), // Use doubles
          'date': DateTime(2023, 1, i).toIso8601String(),
        });
      }
      return chartData;
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

    // Default fallback mock data for any other endpoint
    return {'success': true, 'message': 'Mock data for endpoint: $endpoint', 'data': []};
  }

  // Set authentication token
  void setAuthToken(String token) {
    _headers['Authorization'] = 'Bearer $token';
  }
}
