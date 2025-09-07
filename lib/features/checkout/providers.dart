import 'package:flutter_riverpod/flutter_riverpod.dart';
import './models/plan.dart';

final selectedPlanProvider = StateProvider<Plan?>((_) => null);
final promoCodeTextProvider = StateProvider<String>((_) => '');

final validPromoCodes = ['COOEE20', 'VIBE20', 'FRIENDS20'];

final isPromoValidProvider = Provider<bool>((ref) {
  final code = ref.watch(promoCodeTextProvider).trim().toUpperCase();
  return code.isNotEmpty && validPromoCodes.contains(code);
});

final discountProvider = Provider<double>((ref) => ref.watch(isPromoValidProvider) ? 0.20 : 0.0);

enum PaymentState { idle, loading, success, error }
final paymentStateProvider = StateProvider<PaymentState>((_) => PaymentState.idle);
final paymentMessageProvider = StateProvider<String>((_) => '');
