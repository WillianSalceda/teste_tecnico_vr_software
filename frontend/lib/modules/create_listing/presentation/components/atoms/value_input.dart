import 'package:flutter/material.dart';

class ValueInput extends StatelessWidget {
  const ValueInput({
    required this.label,
    required this.controller,
    super.key,
    this.hintText = '0.00',
    this.errorText,
  });

  final String label;
  final TextEditingController controller;
  final String hintText;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            hintText: hintText,
            errorText: errorText,
          ),
        ),
      ],
    );
  }
}
