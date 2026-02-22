import 'address.dart';

enum ListingType { sale, rent }

class Listing {
  const Listing({
    required this.id,
    required this.type,
    required this.valueBRL,
    this.valueUSD,
    this.imageUrl,
    required this.address,
    required this.createdAt,
  });

  final String id;
  final ListingType type;
  final double valueBRL;
  final double? valueUSD;
  final String? imageUrl;
  final Address address;
  final DateTime createdAt;

  String get typeLabel => type == ListingType.sale ? 'sale' : 'rent';
}
