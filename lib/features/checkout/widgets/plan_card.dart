import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../models/plan.dart';

class PlanCard extends StatelessWidget {
  final Plan plan;
  final bool selected;
  final VoidCallback onTap;

  const PlanCard({super.key, required this.plan, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: selected ? brandPrimary.withOpacity(0.12) : Colors.transparent,
          border: Border.all(color: selected ? brandAccent : Colors.white12, width: selected ? 1.4 : 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(_iconFor(plan.id), color: Colors.white, size: 22),
              const SizedBox(width: 10),
              Text(plan.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
              const Spacer(),
              Text(plan.price == 0 ? "Free" : "\$${plan.price}/mo", style: const TextStyle(fontWeight: FontWeight.w700)),
            ]),
            const SizedBox(height: 12),
            ...plan.perks.map((p) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(children: [
                const Icon(Icons.check_circle, size: 16, color: Colors.white70),
                const SizedBox(width: 8),
                Expanded(child: Text(p, style: const TextStyle(color: Colors.white70))),
              ]),
            )),
          ],
        ),
      ),
    );
  }

  IconData _iconFor(String id) {
    switch (id) {
      case 'premium': return Icons.call;
      case 'pro': return Icons.video_call_rounded;
      default: return Icons.chat_bubble;
    }
  }
}
