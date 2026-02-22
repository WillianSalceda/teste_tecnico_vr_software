part of 'exchange_rate_bloc.dart';

abstract class ExchangeRateEvent extends Equatable {
  const ExchangeRateEvent();

  @override
  List<Object?> get props => [];
}

class ExchangeRateLoadRequested extends ExchangeRateEvent {
  const ExchangeRateLoadRequested();
}

class ExchangeRateCreateRequested extends ExchangeRateEvent {
  const ExchangeRateCreateRequested(this.rate);

  final double rate;

  @override
  List<Object?> get props => [rate];
}
