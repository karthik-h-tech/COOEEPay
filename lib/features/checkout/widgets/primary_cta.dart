import 'package:flutter/material.dart';
import 'package:cooee_pay/core/theme.dart';

class PrimaryCta extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  const PrimaryCta({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(999),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          gradient: LinearGradient(colors: [brandPrimary, brandAccent]),
        ),
        child: Center(
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.black)),
        ),
      ),
    );
  }
}
