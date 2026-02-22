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
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          filterLabel,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: 4),
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
    );
  }
}
