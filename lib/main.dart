import 'package:flutter/material.dart';
import 'core/theme/theme.dart';
import 'screens/home_screen.dart';
import 'screens/capture_screen.dart';
import 'screens/analysis_screen.dart';
import 'screens/result_screen.dart';

void main() {
  runApp(const WoodConNetApp());
}

class WoodConNetApp extends StatelessWidget {
  const WoodConNetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WoodConNet',
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/capture': (context) => const CaptureScreen(),
        '/analysis': (context) => const AnalysisScreen(),
        '/result': (context) => const ResultScreen(),
      },
    );
  }
}
