import 'package:flutter/material.dart';

class AddressFieldsRow extends StatelessWidget {
  const AddressFieldsRow({
    required this.firstController,
    required this.firstLabel,
    required this.secondController,
    required this.secondLabel,
    super.key,
    this.firstFlex = 1,
    this.secondFlex = 1,
    this.firstValidator,
    this.secondValidator,
  });

  final TextEditingController firstController;
  final String firstLabel;
  final TextEditingController secondController;
  final String secondLabel;
  final int firstFlex;
  final int secondFlex;
  final String? Function(String?)? firstValidator;
  final String? Function(String?)? secondValidator;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: firstFlex,
          child: TextFormField(
            controller: firstController,
            decoration: InputDecoration(labelText: firstLabel),
            validator: firstValidator,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: secondFlex,
          child: TextFormField(
            controller: secondController,
            decoration: InputDecoration(labelText: secondLabel),
            validator: secondValidator,
          ),
        ),
      ],
    );
  }
}
