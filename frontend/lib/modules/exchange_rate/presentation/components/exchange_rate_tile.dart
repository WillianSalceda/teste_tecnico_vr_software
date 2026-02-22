import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/exchange_rate.dart';

class ExchangeRateTile extends StatelessWidget {
  const ExchangeRateTile({
    required this.exchangeRate,
    super.key,
  });

  final ExchangeRate exchangeRate;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    return Card(
      child: ListTile(
        title: Text('1 BRL = ${exchangeRate.rate.toStringAsFixed(4)} USD'),
        subtitle: Text(dateFormat.format(exchangeRate.validFrom)),
      ),
    );
  }
}
