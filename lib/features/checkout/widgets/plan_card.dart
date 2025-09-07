import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../models/plan.dart';

class PlanCard extends StatefulWidget {
  final Plan plan;
  final bool selected;
  final VoidCallback onTap;

  const PlanCard({super.key, required this.plan, required this.selected, required this.onTap});

  @override
  State<PlanCard> createState() => _PlanCardState();
}

class _PlanCardState extends State<PlanCard> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.selected ? _pulseAnimation.value : 1.0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: widget.selected ? brandPrimary.withOpacity(0.12) : Colors.transparent,
                border: Border.all(color: widget.selected ? brandAccent : Colors.white12, width: widget.selected ? 1.4 : 1),
                boxShadow: widget.selected
                    ? [BoxShadow(color: brandAccent.withOpacity(0.3), blurRadius: 10, spreadRadius: 2)]
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Icon(_iconFor(widget.plan.id), color: Colors.white, size: 22),
                    const SizedBox(width: 10),
                    Text(widget.plan.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                    const Spacer(),
                    Text(widget.plan.price == 0 ? "Free" : "\$${widget.plan.price}/mo", style: const TextStyle(fontWeight: FontWeight.w700)),
                  ]),
                  const SizedBox(height: 12),
                  ...widget.plan.perks.map((p) => Padding(
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
        },
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
