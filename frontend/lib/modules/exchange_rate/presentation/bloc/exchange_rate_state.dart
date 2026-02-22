part of 'exchange_rate_bloc.dart';

abstract class ExchangeRateState extends Equatable {
  const ExchangeRateState();

  @override
  List<Object?> get props => [];
}

class ExchangeRateInitial extends ExchangeRateState {
  const ExchangeRateInitial();
}

class ExchangeRateLoading extends ExchangeRateState {
  const ExchangeRateLoading();
}

class ExchangeRateLoaded extends ExchangeRateState {
  const ExchangeRateLoaded({
    required this.exchangeRates,
    required this.total,
  });

  final List<ExchangeRate> exchangeRates;
  final int total;

  @override
  List<Object?> get props => [exchangeRates, total];
}

class ExchangeRateError extends ExchangeRateState {
  const ExchangeRateError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class ExchangeRateCreateLoading extends ExchangeRateState {
  const ExchangeRateCreateLoading();
}
