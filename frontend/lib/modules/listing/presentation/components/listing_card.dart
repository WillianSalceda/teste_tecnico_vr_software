import 'package:flutter/material.dart';

import '../../../../core/l10n/app_l10n.dart';
import '../../domain/entities/address.dart';
import '../../domain/entities/listing.dart';

class ListingCard extends StatelessWidget {
  const ListingCard({
    required this.listing,
    required this.l10n,
    super.key,
  });

  final Listing listing;
  final AppL10n l10n;

  @override
  Widget build(BuildContext context) {
    final typeLabel = listing.type == ListingType.sale ? l10n.sale : l10n.rent;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: listing.imageUrl != null && listing.imageUrl!.isNotEmpty
                  ? Image.network(
                      listing.imageUrl!,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (_, error, stackTrace) =>
                          _buildPlaceholder(),
                    )
                  : _buildPlaceholder(),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Chip(
                        label: Text(
                          typeLabel,
                          style: const TextStyle(fontSize: 12),
                        ),
                        padding: EdgeInsets.zero,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      const Spacer(),
                      Text(
                        'R\$ ${listing.valueBRL.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  if (listing.valueUSD != null)
                    Text(
                      '${l10n.valueUSD}: \$${listing.valueUSD!.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  const SizedBox(height: 4),
                  Text(
                    _formatAddress(listing.address),
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 80,
      height: 80,
      color: Colors.grey[300],
      child: const Icon(Icons.home, size: 40),
    );
  }

  String _formatAddress(Address address) {
    final parts = <String>[];
    if (address.street.isNotEmpty) parts.add(address.street);
    if (address.number != null && address.number!.isNotEmpty) {
      parts.add(address.number!);
    }
    if (address.neighborhood.isNotEmpty) parts.add(address.neighborhood);
    if (address.city.isNotEmpty) parts.add(address.city);
    if (address.state.isNotEmpty) parts.add(address.state);
    return parts.join(', ');
  }
}
