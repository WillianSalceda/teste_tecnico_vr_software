import 'package:flutter/material.dart';

class TypeSelector extends StatelessWidget {
  const TypeSelector({
    required this.label,
    required this.saleLabel,
    required this.rentLabel,
    required this.selectedType,
    required this.onTypeChanged,
    super.key,
  });

  final String label;
  final String saleLabel;
  final String rentLabel;
  final String selectedType;
  final ValueChanged<String> onTypeChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        SegmentedButton<String>(
          segments: [
            ButtonSegment(value: 'sale', label: Text(saleLabel)),
            ButtonSegment(value: 'rent', label: Text(rentLabel)),
          ],
          selected: {selectedType},
          onSelectionChanged: (s) => onTypeChanged(s.first),
        ),
      ],
    );
  }
}
