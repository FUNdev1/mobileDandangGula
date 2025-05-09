import 'dart:developer';
import 'package:get/get.dart';
import '../models/cashier_model.dart';
import '../services/api_service.dart';

abstract class CashierRepository {
  // Cashier Session
  Future<Map<String, dynamic>> createInitialCapital(double amount);
  Future<Map<String, dynamic>> cashInOut(String type, double amount, String description);
  Future<Map<String, dynamic>> endSession();

  // Cashier Summary
  Future<CashierSummary> getCurrentSummary();
  Future<Map<String, dynamic>> getCashSummary({String type = 'all'});
  Future<Map<String, dynamic>> getCardSummary();
  Future<ShiftDetail> getShiftDetail();

  // Tax Settings
  Future<double> getTaxRate();
  Future<Map<String, dynamic>> updateTaxRate(double rate, String description);

  // Attendance
  Future<List<StaffMember>> getStaffList();
  Future<Map<String, dynamic>> recordClockIn(String staffId, String pin, {String? photoPath, String? shiftOpen});
  Future<Map<String, dynamic>> recordClockOut(String staffId, String pin, {String? photoPath});
  Future<List<Attendance>> getAttendanceHistory({String? startDate, String? endDate});
}

class CashierRepositoryImpl implements CashierRepository {
  final ApiService _apiService = Get.find<ApiService>();

  // Cashier Session
  @override
  Future<Map<String, dynamic>> createInitialCapital(double amount) async {
    try {
      final response = await _apiService.post(
        '/cashier/home/capital',
        body: {'initial_capital': amount},
      );
      return response;
    } catch (e) {
      log('Error creating initial capital: $e');
      return {'success': false, 'message': 'Failed to create initial capital: $e'};
    }
  }

  @override
  Future<Map<String, dynamic>> cashInOut(String type, double amount, String description) async {
    try {
      // Validate type
      if (type != 'In' && type != 'Out') {
        return {'success': false, 'message': 'Invalid type. Must be "In" or "Out"'};
      }

      final response = await _apiService.post(
        '/cashier/summary/cashout',
        body: {
          'type': type,
          'nominal': amount,
          'description': description,
        },
      );
      return response;
    } catch (e) {
      log('Error recording cash in/out: $e');
      return {'success': false, 'message': 'Failed to record cash transaction: $e'};
    }
  }

  @override
  Future<Map<String, dynamic>> endSession() async {
    try {
      final response = await _apiService.delete('/cashier/summary/close');
      return response;
    } catch (e) {
      log('Error ending cashier session: $e');
      return {'success': false, 'message': 'Failed to end cashier session: $e'};
    }
  }

  // Cashier Summary
  @override
  Future<CashierSummary> getCurrentSummary() async {
    try {
      final response = await _apiService.get('/cashier/summary');

      if (response is Map<String, dynamic> && response['success'] == true) {
        return CashierSummary.fromJson(response['data']);
      }

      return CashierSummary(
        initialCapital: 0,
        cashIn: 0,
        cashOut: 0,
        cardSales: 0,
        totalSales: 0,
        cashSales: 0,
        expectedCash: 0,
      );
    } catch (e) {
      log('Error fetching cashier summary: $e');
      return CashierSummary(
        initialCapital: 0,
        cashIn: 0,
        cashOut: 0,
        cardSales: 0,
        totalSales: 0,
        cashSales: 0,
        expectedCash: 0,
      );
    }
  }

  @override
  Future<Map<String, dynamic>> getCashSummary({String type = 'all'}) async {
    try {
      final response = await _apiService.post(
        '/cashier/summary/tunai',
        body: {'type': type},
      );
      return response;
    } catch (e) {
      log('Error fetching cash summary: $e');
      return {'success': false, 'message': 'Error: $e', 'data': {}};
    }
  }

  @override
  Future<Map<String, dynamic>> getCardSummary() async {
    try {
      final response = await _apiService.get('/cashier/summary/nonTunai');
      return response;
    } catch (e) {
      log('Error fetching card summary: $e');
      return {'success': false, 'message': 'Error: $e', 'data': {}};
    }
  }

  @override
  Future<ShiftDetail> getShiftDetail() async {
    try {
      final response = await _apiService.get('/cashier/summary/detail');

      if (response is Map<String, dynamic> && response['success'] == true) {
        return ShiftDetail.fromJson(response['data']);
      }

      return ShiftDetail(
        id: '',
        openBy: '',
        openAt: DateTime.now(),
        initialCapital: 0,
        shiftNumber: 0,
        cashIn: [],
        cashOut: [],
        orders: [],
      );
    } catch (e) {
      log('Error fetching shift detail: $e');
      return ShiftDetail(
        id: '',
        openBy: '',
        openAt: DateTime.now(),
        initialCapital: 0,
        shiftNumber: 0,
        cashIn: [],
        cashOut: [],
        orders: [],
      );
    }
  }

  // Tax Settings
  @override
  Future<double> getTaxRate() async {
    try {
      final response = await _apiService.post(
        '/param',
        body: {'group': 'tax', 'key': 'tax_resto'},
      );

      if (response is Map<String, dynamic> && response.containsKey('data') && response['success'] == true) {
        return double.tryParse(response['data']['value'].toString()) ?? 0.0;
      }

      return 0.0;
    } catch (e) {
      log('Error fetching tax rate: $e');
      return 0.0;
    }
  }

  @override
  Future<Map<String, dynamic>> updateTaxRate(double rate, String description) async {
    try {
      final response = await _apiService.post(
        '/param/saveTax',
        body: {
          'value': rate,
          'description': description,
        },
      );
      return response;
    } catch (e) {
      log('Error updating tax rate: $e');
      return {'success': false, 'message': 'Failed to update tax rate: $e'};
    }
  }

  // Attendance
  @override
  Future<List<StaffMember>> getStaffList() async {
    try {
      final response = await _apiService.get('/presensi/listStaff');

      if (response is Map<String, dynamic> && response.containsKey('data') && response['data'] is List) {
        return (response['data'] as List).map((staff) => StaffMember.fromJson(staff)).toList();
      }

      return [];
    } catch (e) {
      log('Error fetching staff list: $e');
      return [];
    }
  }

  @override
  Future<Map<String, dynamic>> recordClockIn(String staffId, String pin, {String? photoPath, String? shiftOpen}) async {
    try {
      final Map<String, dynamic> data = {
        'staff_id': staffId,
        'pin': pin,
      };

      if (photoPath != null) {
        data['photo'] = photoPath;
      }

      if (shiftOpen != null) {
        data['shift_open'] = shiftOpen;
      }

      final response = await _apiService.post('/presensi', body: data);
      return response;
    } catch (e) {
      log('Error recording clock in: $e');
      return {'success': false, 'message': 'Failed to record clock in: $e'};
    }
  }

  @override
  Future<Map<String, dynamic>> recordClockOut(String staffId, String pin, {String? photoPath}) async {
    try {
      final Map<String, dynamic> data = {
        'staff_id': staffId,
        'pin': pin,
      };

      if (photoPath != null) {
        data['photo'] = photoPath;
      }

      final response = await _apiService.post('/presensi/keluar', body: data);
      return response;
    } catch (e) {
      log('Error recording clock out: $e');
      return {'success': false, 'message': 'Failed to record clock out: $e'};
    }
  }

  @override
  Future<List<Attendance>> getAttendanceHistory({String? startDate, String? endDate}) async {
    try {
      final Map<String, dynamic> requestData = {};

      if (startDate != null) {
        requestData['startDate'] = startDate;
      }

      if (endDate != null) {
        requestData['endDate'] = endDate;
      }

      final response = await _apiService.post('/presensi/history', body: requestData);

      if (response is Map<String, dynamic> && response.containsKey('data') && response['data'] is List) {
        return (response['data'] as List).map((attendance) => Attendance.fromJson(attendance)).toList();
      }

      return [];
    } catch (e) {
      log('Error fetching attendance history: $e');
      return [];
    }
  }
}
