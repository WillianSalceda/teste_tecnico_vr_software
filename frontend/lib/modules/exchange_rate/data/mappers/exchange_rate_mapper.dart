import '../../domain/entities/exchange_rate.dart';

extension ExchangeRateMapper on ExchangeRate {
  static ExchangeRate fromJson(Map<String, dynamic> json) {
    return ExchangeRate(
      id: json['id'] as String,
      rate: (json['rate'] as num).toDouble(),
      validFrom: DateTime.parse(json['valid_from'] as String),
      validTo: json['valid_to'] != null
          ? DateTime.parse(json['valid_to'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
