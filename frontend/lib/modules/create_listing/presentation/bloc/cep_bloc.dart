import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/address.dart';
import '../../domain/usecases/get_address_by_cep.dart';

part 'cep_event.dart';
part 'cep_state.dart';

class CepBloc extends Bloc<CepEvent, CepState> {
  final GetAddressByCep _getAddressByCep;

  CepBloc(this._getAddressByCep) : super(CepInitial()) {
    on<CepLookupRequested>((event, emit) async {
      emit(CepLoading());

      final result = await _getAddressByCep(
        GetAddressByCepParams(event.cep),
      );
      result.fold(
        (failure) => emit(CepError(failure.message)),
        (address) => emit(CepLoaded(address)),
      );
    });
  }
}
