import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:confetti/confetti.dart';
import 'package:lottie/lottie.dart';
import '../../../core/theme.dart';
import '../../../core/utils.dart';
import '../models/plan.dart';
import '../providers.dart';
import '../services/payment_service.dart';

class PaymentConfirmationScreen extends ConsumerStatefulWidget {
  const PaymentConfirmationScreen({super.key});

  @override
  ConsumerState<PaymentConfirmationScreen> createState() => _PaymentConfirmationScreenState();
}

class _PaymentConfirmationScreenState extends ConsumerState<PaymentConfirmationScreen> with TickerProviderStateMixin {
  late final ConfettiController _confetti;
  late final AnimationController _shake;

  @override
  void initState() {
    super.initState();
    _confetti = ConfettiController(duration: const Duration(seconds: 2));
    _shake = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
  }

  @override
  void dispose() {
    _confetti.dispose();
    _shake.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Plan? plan = ref.watch(selectedPlanProvider);
    final promo = ref.watch(promoCodeTextProvider).trim().toUpperCase();
    final discount = ref.watch(discountProvider);
    final paymentState = ref.watch(paymentStateProvider);
    final message = ref.watch(paymentMessageProvider);

    if (plan == null) {
      // no plan selected -> go back
      Future.microtask(() => Navigator.pop(context));
      return const SizedBox.shrink();
    }

    final priceAfter = applyDiscount(plan.price, discount);

    return Scaffold(
      appBar: AppBar(title: const Text('Confirm Payment')),
      body: Stack(children: [
        Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 560), child: _buildBody(context, plan, promo, priceAfter, paymentState, message))),
        Align(alignment: Alignment.topCenter, child: ConfettiWidget(confettiController: _confetti, blastDirectionality: BlastDirectionality.explosive, numberOfParticles: 20)),
      ]),
    );
  }

  Widget _buildBody(BuildContext context, Plan plan, String promo, double priceAfter, PaymentState state, String msg) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: const Color(0xFF3A3A3A), borderRadius: BorderRadius.circular(12)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const Icon(Icons.receipt_long_outlined),
              const SizedBox(width: 10),
              const Text('Order summary', style: TextStyle(fontWeight: FontWeight.w700)),
            ]),
            const SizedBox(height: 12),
            _row('Plan', plan.name),
            _row('Price', money(plan.price)),
            if (promo.isNotEmpty) _row('Promo ($promo)', '-20%'),
            const Divider(height: 20),
            _row('Total due now', money(priceAfter), bold: true),
          ]),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: state == PaymentState.loading ? null : () async {
              if (priceAfter == 0) {
                // Free plan, no payment needed
                ref.read(paymentStateProvider.notifier).state = PaymentState.success;
                ref.read(paymentMessageProvider.notifier).state = 'Free plan activated successfully!';
                _confetti.play();
                // Navigate to payment success screen with details
                Navigator.pushNamed(context, '/payment-success', arguments: {
                  'plan': plan,
                  'priceAfter': priceAfter,
                  'promo': promo,
                  'message': 'Free plan activated successfully!',
                });
              } else {
                // Paid plan, show payment methods dialog
                final paymentMethod = await showDialog<String>(
                  context: context,
                  builder: (_) => PaymentMethodDialog(),
                );

                if (paymentMethod != null) {
                  ref.read(paymentStateProvider.notifier).state = PaymentState.loading;
                  final res = await PaymentService.checkout(planId: plan.id, amount: priceAfter, promo: promo.isEmpty ? null : promo);
                  if (res.success) {
                    ref.read(paymentStateProvider.notifier).state = PaymentState.success;
                    ref.read(paymentMessageProvider.notifier).state = res.message;
                    _confetti.play();
                    // Navigate to payment success screen with details
                    Navigator.pushNamed(context, '/payment-success', arguments: {
                      'plan': plan,
                      'priceAfter': priceAfter,
                      'promo': promo,
                      'message': res.message,
                    });
                  } else {
                    ref.read(paymentStateProvider.notifier).state = PaymentState.error;
                    ref.read(paymentMessageProvider.notifier).state = res.message;
                    _shake.forward(from: 0);
                    // Show error dialog
                    await showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Payment Failed'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _maybeLottie('assets/animations/error.json', fallback: const Icon(Icons.error_outline, size: 88)),
                            const SizedBox(height: 8),
                            Text(res.message),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                }
              }
            },
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: state == PaymentState.loading ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Confirm & Pay'),
            ),
          ),
        ),
        const SizedBox(height: 10),
        TextButton(onPressed: () => Navigator.popUntil(context, (r) => r.isFirst), child: const Text('Return to Dashboard')),
      ]),
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

  Widget _statusView(PaymentState state, String msg) {
    if (state == PaymentState.idle || state == PaymentState.loading) return const SizedBox.shrink();
    if (state == PaymentState.success) {
      return Column(children: [
        _maybeLottie('assets/animations/success.json', fallback: const Icon(Icons.celebration, size: 88)),
        const SizedBox(height: 8),
        const Text('Payment successful!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text(msg, style: const TextStyle(color: Colors.white70)),
      ]);
    } else if (state == PaymentState.error) {
      return Column(children: [
        _maybeLottie('assets/animations/error.json', fallback: const Icon(Icons.error_outline, size: 88)),
        const SizedBox(height: 8),
        const Text('Payment failed', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text(msg, style: const TextStyle(color: Colors.white70)),
      ]);
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _maybeLottie(String path, {required Widget fallback}) {
    try {
      return Lottie.asset(path, width: 120, height: 120, repeat: false);
    } catch (_) {
      return fallback;
    }
  }
}

class PaymentMethodDialog extends StatefulWidget {
  const PaymentMethodDialog({super.key});

  @override
  State<PaymentMethodDialog> createState() => _PaymentMethodDialogState();
}

class _PaymentMethodDialogState extends State<PaymentMethodDialog> {
  String? _selectedMethod;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Payment Method'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioListTile<String>(
            title: const Text('Credit Card'),
            value: 'credit_card',
            groupValue: _selectedMethod,
            onChanged: (value) => setState(() => _selectedMethod = value),
          ),
          RadioListTile<String>(
            title: const Text('PayPal'),
            value: 'paypal',
            groupValue: _selectedMethod,
            onChanged: (value) => setState(() => _selectedMethod = value),
          ),
          RadioListTile<String>(
            title: const Text('Apple Pay'),
            value: 'apple_pay',
            groupValue: _selectedMethod,
            onChanged: (value) => setState(() => _selectedMethod = value),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _selectedMethod != null ? () => Navigator.pop(context, _selectedMethod) : null,
          child: const Text('Pay Now'),
        ),
      ],
    );
  }
}
