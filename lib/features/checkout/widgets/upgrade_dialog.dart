import 'package:flutter/material.dart';
import '../../../core/theme.dart';

class UpgradeDialog extends StatelessWidget {
  const UpgradeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF14172A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(children: [
            Icon(Icons.auto_awesome, color: brandAccent),
            const SizedBox(width: 10),
            const Expanded(child: Text('Unlock more with Premium', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
          ]),
          const SizedBox(height: 10),
          const Text('Unlimited calls, HD quality, priority support — upgrade anytime.'),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(context, 'maybe_later'), child: const Text('Maybe later'))),
            const SizedBox(width: 12),
            Expanded(child: ElevatedButton(onPressed: () => Navigator.pop(context, 'upgrade'), child: const Text('Upgrade'))),
          ])
        ]),
      ),
    );
  }
}
