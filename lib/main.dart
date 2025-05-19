import 'package:flutter/material.dart';
import 'package:grostok/core/routes/app_route.dart';
import 'package:grostok/core/const/app_theme.dart';

void main() {
  runApp(const GrostokApp());
}

class GrostokApp extends StatelessWidget {
  const GrostokApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRoutes.onGenerateRoute,
      theme: AppTheme.appTheme,
    );
  }
}
