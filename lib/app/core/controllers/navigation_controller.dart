import 'package:dandang_gula/app/routes/app_routes.dart';
import 'package:get/get.dart';

class NavigationController extends GetxController {
  final Rx<String> currentRoute = Routes.DASHBOARD.obs;
  final List<String> routeHistory = [Routes.DASHBOARD].obs;
  final isNavigating = false.obs;
  
  void changePage(String routeName) async {
    try {
      if (currentRoute.value != routeName) {
        // Set navigating state
        isNavigating.value = true;

        // Update current route
        currentRoute.value = routeName;

        // Update history
        routeHistory.add(routeName);
        if (routeHistory.length > 20) {
          routeHistory.removeAt(0);
        }

        // Refresh key untuk memaksa rebuild
        final refreshKey = DateTime.now().millisecondsSinceEpoch;

        // Navigasi dengan Get.toNamed
        Get.toNamed(routeName, arguments: {'refreshKey': refreshKey});
      }
    } catch (e) {
      Get.log('Error during navigation: $e');
    } finally {
      await Future.delayed(Duration(milliseconds: 200));
      isNavigating.value = false;
    }
  }

  void handleBackNavigation() {
    if (routeHistory.length > 1) {
      // Remove current route
      routeHistory.removeLast();
      // Get previous route
      String previousRoute = routeHistory.last;

      // Set navigating state
      isNavigating.value = true;

      // Update current route
      currentRoute.value = previousRoute;

      // Navigate to previous route
      Get.toNamed(previousRoute);

      // Reset navigating state
      isNavigating.value = false;
    }
  }
}
