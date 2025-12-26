import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/gta_theme.dart';
import 'presentation/screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: GTA5RPCalculatorApp(),
    ),
  );
}

class GTA5RPCalculatorApp extends StatelessWidget {
  const GTA5RPCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Калькулятор перекупа',
      debugShowCheckedModeBanner: false,
      theme: GTATheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}
