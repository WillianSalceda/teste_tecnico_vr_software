import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/exchange_rate.dart';
import '../../domain/usecases/create_exchange_rate.dart';
import '../../domain/usecases/get_exchange_rates.dart';

part 'exchange_rate_event.dart';
part 'exchange_rate_state.dart';

class ExchangeRateBloc extends Bloc<ExchangeRateEvent, ExchangeRateState> {
  ExchangeRateBloc(this._getExchangeRates, this._createExchangeRate)
    : super(const ExchangeRateInitial()) {
    on<ExchangeRateLoadRequested>(_onLoadRequested);
    on<ExchangeRateCreateRequested>(_onCreateRequested);
  }

  final GetExchangeRates _getExchangeRates;
  final CreateExchangeRate _createExchangeRate;

  Future<void> _onLoadRequested(
    ExchangeRateLoadRequested event,
    Emitter<ExchangeRateState> emit,
  ) async {
    emit(const ExchangeRateLoading());
    final result = await _getExchangeRates(
      const GetExchangeRatesParams(page: 1, limit: 20),
    );
    result.fold(
      (failure) => emit(ExchangeRateError(failure.message)),
      (data) => emit(
        ExchangeRateLoaded(
          exchangeRates: data.exchangeRates,
          total: data.total,
        ),
      ),
    );
  }

  Future<void> _onCreateRequested(
    ExchangeRateCreateRequested event,
    Emitter<ExchangeRateState> emit,
  ) async {
    emit(const ExchangeRateCreateLoading());
    final result = await _createExchangeRate(event.rate);
    await result.fold(
      (failure) async => emit(ExchangeRateError(failure.message)),
      (_) async {
        final loadResult = await _getExchangeRates(
          const GetExchangeRatesParams(page: 1, limit: 20),
        );
        loadResult.fold(
          (failure) => emit(ExchangeRateError(failure.message)),
          (data) => emit(
            ExchangeRateLoaded(
              exchangeRates: data.exchangeRates,
              total: data.total,
            ),
          ),
        );
      },
    );
  }
}
