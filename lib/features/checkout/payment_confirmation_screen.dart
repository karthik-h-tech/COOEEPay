import 'package:cooeepay/core/theme.dart';
import 'package:cooeepay/core/utils.dart';
import 'package:cooeepay/features/checkout/services/payment_service.dart';
import 'package:cooeepay/features/checkout/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:confetti/confetti.dart';

class PaymentConfirmationScreen extends ConsumerStatefulWidget {
  const PaymentConfirmationScreen({super.key});
  @override
  ConsumerState<PaymentConfirmationScreen> createState() => _PaymentConfirmationScreenState();
}

class _PaymentConfirmationScreenState extends ConsumerState<PaymentConfirmationScreen> with TickerProviderStateMixin {
  late final AnimationController shakeController;
  late final ConfettiController confetti;

  @override
  void initState() {
    super.initState();
    shakeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    confetti = ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    shakeController.dispose();
    confetti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final plan = ref.watch(selectedPlanProvider);
    final discount = ref.watch(discountProvider);
    final promo = ref.watch(promoCodeTextProvider).trim().toUpperCase();
    final state = ref.watch(paymentStateProvider);

    if (plan == null) {
      Future.microtask(() => Navigator.pop(context));
      return const SizedBox.shrink();
    }

    final priceAfter = applyDiscount(plan.price, discount);

    return Scaffold(
      appBar: AppBar(title: const Text("Payment")),
      body: Stack(children: [
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: confetti,
            blastDirectionality: BlastDirectionality.explosive,
            numberOfParticles: 24,
            shouldLoop: false,
          ),
        ),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _SummaryTile(plan: plan.name, original: plan.price, promo: promo.isEmpty ? null : promo, finalPrice: priceAfter),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: brandAccent,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: state == PaymentState.loading ? null : () async {
                        ref.read(paymentStateProvider.notifier).state = PaymentState.loading;

                        // Free plan: skip API, auto-success
                        if (priceAfter == 0) {
                          ref.read(paymentStateProvider.notifier).state = PaymentState.success;
                          ref.read(paymentMessageProvider.notifier).state = 'Activated Free plan';
                          confetti.play();
                          return;
                        }

                        final res = await PaymentService.checkout(
                          planId: plan.id, amount: priceAfter, promoCode: promo.isEmpty ? null : promo,
                        );

                        if (res.success) {
                          ref.read(paymentStateProvider.notifier).state = PaymentState.success;
                          ref.read(paymentMessageProvider.notifier).state = res.message;
                          confetti.play();
                        } else {
                          ref.read(paymentStateProvider.notifier).state = PaymentState.error;
                          ref.read(paymentMessageProvider.notifier).state = res.message;
                          shakeController.forward(from: 0);
                        }
                      },
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: state == PaymentState.loading
                            ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Text("Confirm & Pay"),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextButton(
                    onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
                    child: const Text("Return to Dashboard"),
                  ),
                  const SizedBox(height: 20),
                  _StatusView(controller: shakeController),
                ],
              ),
            ),
          ),
        ),
      ]),
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
        Row(children: [
          const Icon(Icons.receipt_long_outlined),
          const SizedBox(width: 8),
          Text("Order summary", style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w700)),
        ]),
        const SizedBox(height: 12),
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

class _StatusView extends ConsumerWidget {
  final AnimationController controller;
  const _StatusView({required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(paymentStateProvider);
    final msg = ref.watch(paymentMessageProvider);

    if (state == PaymentState.idle || state == PaymentState.loading) return const SizedBox.shrink();

    if (state == PaymentState.success) {
      return Column(children: [
        // Lottie success if present; fallback to icon
        _maybeLottie("assets/animations/success.json", size: 140) ??
            const Icon(Icons.celebration, size: 96, color: Colors.white),
        const SizedBox(height: 8),
        Text("Payment successful!", style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 4),
        Text(msg, style: const TextStyle(color: Colors.white70)),
      ]);
    }

    // error
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final dx = (1 - (controller.value - .5).abs() * 2) * 8; // shake
        return Transform.translate(
          offset: Offset(dx, 0),
          child: Column(children: [
            _maybeLottie("assets/animations/error.json", size: 120) ??
                const Icon(Icons.error_outline, size: 96, color: Colors.white),
            const SizedBox(height: 8),
            Text("Payment failed", style: Theme.of(context).textTheme.titleLarge!.copyWith(color: errorColor)),
            const SizedBox(height: 4),
            Text(msg, style: const TextStyle(color: Colors.white70)),
          ]),
        );
      },
    );
  }

  Widget? _maybeLottie(String path, {double size = 120}) {
    try {
      return Lottie.asset(path, width: size, height: size, repeat: false);
    } catch (_) {
      return null; // in case asset not found
    }
  }
}
