import 'package:flutter/material.dart';

import '../../../../core/l10n/app_l10n.dart';
import '../../domain/entities/address.dart';
import '../../domain/entities/listing.dart';

class ListingCard extends StatefulWidget {
  const ListingCard({
    required this.listing,
    required this.l10n,
    super.key,
  });

  final Listing listing;
  final AppL10n l10n;

  @override
  State<ListingCard> createState() => _ListingCardState();
}

class _ListingCardState extends State<ListingCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final typeLabel = widget.listing.type == ListingType.sale
        ? widget.l10n.sale
        : widget.l10n.rent;
    final isSale = widget.listing.type == ListingType.sale;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.basic,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: Card(
          elevation: _hovered ? 4 : 0,
          shadowColor: Colors.black.withOpacity(0.16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child:
                        widget.listing.imageUrl != null &&
                            widget.listing.imageUrl!.isNotEmpty
                        ? Image.network(
                            widget.listing.imageUrl!,
                            width: 120,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (_, error, stackTrace) =>
                                _buildPlaceholder(),
                          )
                        : _buildPlaceholder(),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: isSale
                                    ? const Color(0xFF0D9488).withOpacity(0.15)
                                    : const Color(0xFF6366F1).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                typeLabel,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: isSale
                                      ? const Color(0xFF0D9488)
                                      : const Color(0xFF6366F1),
                                ),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'R\$ ${widget.listing.valueBRL.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                        if (widget.listing.valueUSD != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            '${widget.l10n.valueUSD}: \$${widget.listing.valueUSD!.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                        const SizedBox(height: 8),
                        Flexible(
                          child: Text(
                            _formatAddress(widget.listing.address),
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 120,
      height: 100,
      color: const Color(0xFFF1F5F9),
      child: const Icon(
        Icons.home_rounded,
        size: 40,
        color: Color(0xFF94A3B8),
      ),
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
