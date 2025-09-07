import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../core/utils.dart';
import '../models/plan.dart';

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final Plan plan = args['plan'];
    final double priceAfter = args['priceAfter'];
    final String promo = args['promo'];
    final String message = args['message'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Successful'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset('assets/animations/success.json', width: 200, height: 200),
                const SizedBox(height: 24),
                const Text(
                  'Payment Successful!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 16),
                Text(
                  message,
                  style: const TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: const Color(0xFF3A3A3A), borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        const Icon(Icons.receipt_long_outlined),
                        const SizedBox(width: 10),
                        const Text('Receipt', style: TextStyle(fontWeight: FontWeight.w700)),
                      ]),
                      const SizedBox(height: 12),
                      _row('Plan', plan.name),
                      _row('Price', money(plan.price)),
                      if (promo.isNotEmpty) _row('Promo ($promo)', '-20%'),
                      const Divider(height: 20),
                      _row('Total Paid', money(priceAfter), bold: true),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false),
                  child: const Text('Return to Dashboard'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(String l, String r, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(children: [
        Text(l, style: TextStyle(color: Colors.white70, fontWeight: bold ? FontWeight.w800 : FontWeight.w600)),
        const Spacer(),
        Text(r, style: TextStyle(fontWeight: bold ? FontWeight.w800 : FontWeight.w600)),
      ]),
    );
  }
}
