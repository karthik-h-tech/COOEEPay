import 'package:cooeepay/core/theme.dart';
import 'package:cooeepay/core/utils.dart';
import 'package:cooeepay/features/checkout/services/payment_service.dart';
import 'package:cooeepay/features/checkout/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaymentOptionsScreen extends ConsumerStatefulWidget {
  const PaymentOptionsScreen({super.key});

  @override
  ConsumerState<PaymentOptionsScreen> createState() => _PaymentOptionsScreenState();
}

class _PaymentOptionsScreenState extends ConsumerState<PaymentOptionsScreen> {
  String selectedMethod = "UPI"; // default

  @override
  Widget build(BuildContext context) {
    final plan = ref.watch(selectedPlanProvider);
    final discount = ref.watch(discountProvider);
    final promo = ref.watch(promoCodeTextProvider).trim().toUpperCase();

    if (plan == null) {
      Future.microtask(() => Navigator.pop(context));
      return const SizedBox.shrink();
    }

    final priceAfter = applyDiscount(plan.price, discount);

    return Scaffold(
      appBar: AppBar(title: const Text("Payment Options")),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            _SummaryTile(plan: plan.name, original: plan.price, promo: promo.isEmpty ? null : promo, finalPrice: priceAfter),
            const SizedBox(height: 24),
            Text("Select Payment Method", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Column(
              children: ["UPI", "Google Pay", "Credit/Debit Card", "Wallet"].map((method) {
                return RadioListTile<String>(
                  value: method,
                  groupValue: selectedMethod,
                  title: Text(method),
                  onChanged: (val) => setState(() => selectedMethod = val!),
                );
              }).toList(),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: brandAccent,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () async {
                  // Mock payment API call
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => const Center(child: CircularProgressIndicator()),
                  );

                  await Future.delayed(const Duration(seconds: 2)); // simulate payment delay
                  Navigator.pop(context); // close progress

                  // Navigate to success screen
                  Navigator.pushReplacementNamed(context, "/payment-success");
                },
                child: const Text("Pay Now"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  final String plan;
  final double original;
  final String? promo;
  final double finalPrice;

  const _SummaryTile({required this.plan, required this.original, required this.promo, required this.finalPrice});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF181B2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _row("Plan", plan),
        _row("Price", money(original)),
        if (promo != null) _row("Promo ($promo)", "-20%"),
        const Divider(height: 22),
        _row("Total due now", money(finalPrice), bold: true),
      ]),
    );
  }

  Widget _row(String l, String r, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(children: [
        Text(l, style: TextStyle(color: Colors.white70, fontWeight: bold ? FontWeight.w700 : FontWeight.w500)),
        const Spacer(),
        Text(r, style: TextStyle(fontWeight: bold ? FontWeight.w800 : FontWeight.w600)),
      ]),
    );
  }
}
