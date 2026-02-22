import '../../domain/entities/listing.dart';
import 'address_mapper.dart';

extension ListingMapper on Listing {
  static Listing fromJson(Map<String, dynamic> json) {
    ListingType type = ListingType.sale;
    if (json['type'] == 'rent') type = ListingType.rent;
    final addressJson = json['address'] as Map<String, dynamic>? ?? {};
    final address = AddressMapper.fromJson(addressJson);
    return Listing(
      id: json['id'] as String,
      type: type,
      valueBRL: (json['value_brl'] as num).toDouble(),
      valueUSD: (json['value_usd'] as num?)?.toDouble(),
      imageUrl: json['image_url'] as String?,
      address: address,
      createdAt: DateTime.parse(json['created_at'] as String? ?? ''),
    );
  }
}
