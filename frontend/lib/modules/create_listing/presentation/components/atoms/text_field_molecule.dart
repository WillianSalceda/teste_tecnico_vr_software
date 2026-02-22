import 'package:flutter/material.dart';

class TextFieldMolecule extends StatelessWidget {
  const TextFieldMolecule({
    required this.controller,
    required this.label,
    super.key,
    this.keyboardType,
    this.decoration,
  });

  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final InputDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: decoration ?? InputDecoration(labelText: label),
    );
  }
}
