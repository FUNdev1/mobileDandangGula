import 'package:dandang_gula/app/global_widgets/text/app_text.dart';
import 'package:flutter/material.dart';
import '../controllers/dashboard_controller.dart';

class KasirDashboardView extends StatelessWidget {
  final DashboardController controller;

  const KasirDashboardView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AppText("Kasir view"),
      ),
    );
  }
}
