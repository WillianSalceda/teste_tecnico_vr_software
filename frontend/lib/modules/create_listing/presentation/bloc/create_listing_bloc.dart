import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/address.dart';
import '../../domain/usecases/create_listing.dart';

part 'create_listing_event.dart';
part 'create_listing_state.dart';

class CreateListingBloc extends Bloc<CreateListingEvent, CreateListingState> {
  CreateListingBloc(this._createListing)
    : super(const CreateListingFormState()) {
    on<CepLookupSucceeded>(_onCepLookupSucceeded);
    on<CreateListingTypeChanged>(_onTypeChanged);
    on<CreateListingImagePathChanged>(_onImagePathChanged);
    on<NavigateTo>(_onNavigateTo);
    on<NavigationHandled>(_onNavigationHandled);
    on<CreateListingSubmitted>(_onSubmitted);
  }

  final CreateListing _createListing;

  CreateListingFormState? get _formState =>
      state is CreateListingFormState ? state as CreateListingFormState : null;

  final cepController = TextEditingController();
  final streetController = TextEditingController();
  final numberController = TextEditingController();
  final complementController = TextEditingController();
  final neighborhoodController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final valueController = TextEditingController();

  void _onCepLookupSucceeded(
    CepLookupSucceeded event,
    Emitter<CreateListingState> emit,
  ) {
    streetController.text = event.address.street;
    neighborhoodController.text = event.address.neighborhood;
    cityController.text = event.address.city;
    stateController.text = event.address.state;
    final s = _formState;
    if (s != null) emit(s.copyWith());
  }

  void _onTypeChanged(
    CreateListingTypeChanged event,
    Emitter<CreateListingState> emit,
  ) {
    final s = _formState;
    if (s != null) emit(s.copyWith(type: event.type));
  }

  void _onImagePathChanged(
    CreateListingImagePathChanged event,
    Emitter<CreateListingState> emit,
  ) {
    final s = _formState;
    if (s != null) emit(s.copyWith(imagePath: event.path));
  }

  void _onNavigateTo(NavigateTo event, Emitter<CreateListingState> emit) {
    emit(CreateListingNavigateState(event.route));
  }

  void _onNavigationHandled(
    NavigationHandled event,
    Emitter<CreateListingState> emit,
  ) {
    emit(
      const CreateListingFormState(
        success: true,
        type: 'sale',
        isLoading: false,
      ),
    );
  }

  Future<void> _onSubmitted(
    CreateListingSubmitted event,
    Emitter<CreateListingState> emit,
  ) async {
    final s = _formState ?? const CreateListingFormState();

    emit(
      s.copyWith(
        isLoading: true,
        errorMessage: null,
        success: false,
      ),
    );

    final params = CreateListingParams(
      type: s.type,
      valueStr: valueController.text,
      cep: cepController.text,
      street: streetController.text,
      number: numberController.text.trim().isEmpty
          ? null
          : numberController.text.trim(),
      complement: complementController.text.trim().isEmpty
          ? null
          : complementController.text.trim(),
      neighborhood: neighborhoodController.text,
      city: cityController.text,
      state: stateController.text,
      imagePath: s.imagePath,
    );

    final result = await _createListing(params);

    result.fold(
      (failure) => emit(
        s.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        ),
      ),
      (_) {
        _clearForm();
        emit(
          s.copyWith(
            isLoading: false,
            success: true,
            errorMessage: null,
            type: 'sale',
            imagePath: null,
          ),
        );
        add(const NavigateTo('/listings'));
      },
    );
  }

  void _clearForm() {
    cepController.clear();
    streetController.clear();
    numberController.clear();
    complementController.clear();
    neighborhoodController.clear();
    cityController.clear();
    stateController.clear();
    valueController.clear();
  }

  @override
  Future<void> close() {
    cepController.dispose();
    streetController.dispose();
    numberController.dispose();
    complementController.dispose();
    neighborhoodController.dispose();
    cityController.dispose();
    stateController.dispose();
    valueController.dispose();
    return super.close();
  }
}
