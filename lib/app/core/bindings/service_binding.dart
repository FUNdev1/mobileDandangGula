import 'package:get/get.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class ServiceBinding extends Bindings {
  @override
  Future<void> dependencies() async {
    // Inisialisasi StorageService secara asinkron
    final storageService = await Get.putAsync(() => StorageService().init());

    // Dapatkan token dari storage jika ada
    final token = storageService.getToken();

    // Inisialisasi ApiService dengan token jika tersedia
    Get.put<ApiService>(ApiServiceImpl(token: token), permanent: true);
  }
}
