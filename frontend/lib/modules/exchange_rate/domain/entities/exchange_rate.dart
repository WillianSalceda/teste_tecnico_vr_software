class ExchangeRate {
  const ExchangeRate({
    required this.id,
    required this.rate,
    required this.validFrom,
    required this.createdAt,
    this.validTo,
  });

  final String id;
  final double rate;
  final DateTime validFrom;
  final DateTime? validTo;
  final DateTime createdAt;
}
