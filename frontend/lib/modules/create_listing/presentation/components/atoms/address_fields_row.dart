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
  });

  final TextEditingController firstController;
  final String firstLabel;
  final TextEditingController secondController;
  final String secondLabel;
  final int firstFlex;
  final int secondFlex;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: firstFlex,
          child: TextField(
            controller: firstController,
            decoration: InputDecoration(labelText: firstLabel),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: secondFlex,
          child: TextField(
            controller: secondController,
            decoration: InputDecoration(labelText: secondLabel),
          ),
        ),
      ],
    );
  }
}
