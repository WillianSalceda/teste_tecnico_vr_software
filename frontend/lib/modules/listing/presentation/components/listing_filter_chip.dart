import 'package:flutter/material.dart';

class ListingFilterChip extends StatelessWidget {
  const ListingFilterChip({
    required this.selectedType,
    required this.allLabel,
    required this.saleLabel,
    required this.rentLabel,
    required this.filterLabel,
    required this.onTypeChanged,
    super.key,
  });

  final String? selectedType;
  final String allLabel;
  final String saleLabel;
  final String rentLabel;
  final String filterLabel;
  final ValueChanged<String?> onTypeChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(filterLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            FilterChip(
              label: Text(allLabel),
              selected: selectedType == null,
              onSelected: (_) => onTypeChanged(null),
            ),
            FilterChip(
              label: Text(saleLabel),
              selected: selectedType == 'sale',
              onSelected: (_) => onTypeChanged('sale'),
            ),
            FilterChip(
              label: Text(rentLabel),
              selected: selectedType == 'rent',
              onSelected: (_) => onTypeChanged('rent'),
            ),
          ],
        ),
      ],
    );
  }
}
