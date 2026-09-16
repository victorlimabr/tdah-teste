import 'package:flutter/material.dart';

import 'screens/onboarding_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const TdahTesteApp());
}

class TdahTesteApp extends StatelessWidget {
  const TdahTesteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Teste TDAH',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      themeMode: ThemeMode.light,
      home: const OnboardingScreen(),
    );
  }
}
