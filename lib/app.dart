import 'package:flutter/material.dart';
import 'core/theme.dart'; // Make sure buildTheme() exists here
import 'features/checkout/screens/plan_selection_screen.dart';
import 'features/checkout/screens/payment_confirmation_screen.dart';
import 'features/checkout/screens/payment_options_screen.dart';
import 'features/checkout/screens/payment_success_screen.dart';
import 'features/welcome/welcome_screen.dart';

class CooeePayApp extends StatelessWidget {
  const CooeePayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CooeePay',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(), // Ensure buildTheme() exists in core/theme.dart
      initialRoute: '/',
      routes: {
        '/': (_) => const WelcomeScreen(),                       // Welcome page
        '/plans': (_) => const PlanSelectionScreen(),           // Plan selection page
        '/payment-options': (_) => const PaymentOptionsScreen(), // Payment options page
        '/payment-confirmation': (_) => const PaymentConfirmationScreen(), // Payment confirmation
        '/payment-success': (_) => const PaymentSuccessScreen(), // Payment success page
      },
    );
  }
}
