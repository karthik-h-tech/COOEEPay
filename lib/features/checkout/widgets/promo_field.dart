import 'package:flutter/material.dart';
import '../../../core/theme.dart';

class PromoField extends StatelessWidget {
  final String value;
  final bool isValid;
  final ValueChanged<String> onChanged;
  const PromoField({super.key, required this.value, required this.isValid, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final suffix = value.isEmpty
        ? const Icon(Icons.discount_outlined)
        : Icon(isValid ? Icons.check_circle : Icons.error, color: isValid ? successColor : errorColor);

    return TextField(
      onChanged: onChanged,
      controller: TextEditingController.fromValue(TextEditingValue(text: value, selection: TextSelection.collapsed(offset: value.length))),
      decoration: InputDecoration(
        hintText: 'Promo code (optional)',
        filled: true,
        fillColor: const Color(0xFF3A3A3A),
        suffixIcon: Padding(padding: const EdgeInsets.only(right: 8), child: suffix),
      ),
    );
  }
}
