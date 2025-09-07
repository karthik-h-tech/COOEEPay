import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'features/checkout/screens/plan_selection_screen.dart';
import 'features/checkout/screens/payment_confirmation_screen.dart';
import 'features/welcome/welcome_screen.dart';

class CooeePayApp extends StatelessWidget {
  const CooeePayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CooeePay',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      initialRoute: '/',
      routes: {
        '/': (_) => const WelcomeScreen(),
        '/plans': (_) => const PlanSelectionScreen(),
        '/payment': (_) => const PaymentConfirmationScreen(),
      },
    );
  }
}
