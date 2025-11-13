import 'package:flutter/material.dart';
import 'app_router.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const DiarioMentalApp());
}

class DiarioMentalApp extends StatelessWidget {
  const DiarioMentalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diário Mental',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      initialRoute: AppRoutes.login,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
