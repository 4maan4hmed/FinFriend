import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/finance_data_provider.dart';
import 'screens/finance_home_screen.dart';

void main() {
  runApp(const FinanceApp());
}

class FinanceApp extends StatelessWidget {
  const FinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
      ),
      home: ChangeNotifierProvider(
        create: (context) => FinanceDataProvider(),
        child: const FinanceHomeScreen(),
      ),
    );
  }
}
