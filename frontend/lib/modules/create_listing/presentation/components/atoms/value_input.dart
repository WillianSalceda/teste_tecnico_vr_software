import 'package:flutter/material.dart';

class ValueInput extends StatelessWidget {
  const ValueInput({
    required this.label,
    required this.controller,
    required this.requiredFieldMessage,
    required this.invalidValueMessage,
    super.key,
    this.hintText = '0.00',
  });

  final String label;
  final TextEditingController controller;
  final String hintText;
  final String requiredFieldMessage;
  final String invalidValueMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(hintText: hintText),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return requiredFieldMessage;
            }
            final num = double.tryParse(value.replaceAll(',', '.'));
            if (num == null || num <= 0) {
              return invalidValueMessage;
            }
            return null;
          },
        ),
      ],
    );
  }
}
