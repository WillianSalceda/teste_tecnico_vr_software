import 'package:flutter/material.dart';

class TextFieldMolecule extends StatelessWidget {
  const TextFieldMolecule({
    required this.controller,
    required this.label,
    super.key,
    this.keyboardType,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(labelText: label),
      validator: validator,
    );
  }
}
