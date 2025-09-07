import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/responsive.dart';
import '../../../core/theme.dart';
import '../../../core/utils.dart';
import '../models/plan.dart';
import '../providers.dart';
import '../widgets/plan_card.dart';
import '../widgets/promo_field.dart';
import '../widgets/upgrade_dialog.dart';

class PlanSelectionScreen extends ConsumerWidget {
  const PlanSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Plan? selected = ref.watch(selectedPlanProvider);
    final promoText = ref.watch(promoCodeTextProvider);
    final isPromoValid = ref.watch(isPromoValidProvider);
    final discount = ref.watch(discountProvider);

    final crossAxisCount =
        R.isDesktop(context) ? 3 : (R.isTablet(context) ? 2 : 1);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: const Text('Choose your plan')),
      body: Stack(children: [
        _DecorBackground(),
        SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Column(
                  children: [
                    const SizedBox(height: 6),
                    Text(
                      'Crystal-clear calls. Flexible plans.',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: GridView.builder(
                        padding: EdgeInsets.zero,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio:
                              R.isPhone(context) ? 1.1 : 1.05,
                        ),
                        itemCount: plans.length,
                        itemBuilder: (_, i) {
                          final p = plans[i];
                          return PlanCard(
                            plan: p,
                            selected: selected?.id == p.id,
                            onTap: () => ref
                                .read(selectedPlanProvider.notifier)
                                .state = p,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    PromoField(
                      value: promoText,
                      isValid: isPromoValid,
                      onChanged: (v) => ref
                          .read(promoCodeTextProvider.notifier)
                          .state = v,
                    ),
                    const SizedBox(height: 12),
                    Row(children: [
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding:
                                const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          // ✅ Fixed route name here
                          onPressed: selected == null
                              ? null
                              : () => Navigator.pushNamed(
                                  context, '/payment-confirmation'),
                          child: const Text('Proceed to Payment'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding:
                                const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
                            final result = await showDialog<String>(
                              context: context,
                              builder: (_) => const UpgradeDialog(),
                            );
                            // ✅ Navigate to welcome if "maybe_later"
                            if (result == 'maybe_later') {
                              Navigator.pushNamedAndRemoveUntil(
                                  context, '/', (route) => false);
                            }
                          },
                          child: const Text('Back to Dashboard'),
                        ),
                      ),
                    ]),
                    const SizedBox(height: 8),
                    if (selected != null)
                      Text(
                        discount > 0
                            ? 'Promo applied: 20% off • New total: ${money(applyDiscount(selected.price, discount))}/mo'
                            : 'Selected: ${selected.name} • ${money(selected.price)}/mo',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class _DecorBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [brandPrimary.withOpacity(0.12), Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
    );
  }
}
